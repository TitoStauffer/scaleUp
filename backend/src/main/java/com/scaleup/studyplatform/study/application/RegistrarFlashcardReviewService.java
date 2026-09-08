package com.scaleup.studyplatform.study.application;

import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.content.domain.Flashcard;
import com.scaleup.studyplatform.content.infra.FlashcardRepository;
import com.scaleup.studyplatform.progress.application.RecalcularDomainProgressService;
import com.scaleup.studyplatform.shared.RecursoNaoEncontradoException;
import com.scaleup.studyplatform.study.application.dto.FlashcardReviewDto;
import com.scaleup.studyplatform.study.application.dto.RegistrarFlashcardReviewRequest;
import com.scaleup.studyplatform.study.domain.FlashcardReview;
import com.scaleup.studyplatform.study.domain.ResultadoAutoavaliacao;
import com.scaleup.studyplatform.study.domain.StudySession;
import com.scaleup.studyplatform.study.infra.FlashcardReviewRepository;
import com.scaleup.studyplatform.study.infra.StudySessionRepository;

/**
 * POST /sessoes/{sessaoId}/flashcard-reviews (ticket, seção 7). Valida
 * `resultadoAutoavaliacao` na aplicação (AC-10) antes de qualquer escrita — não depende só do
 * CHECK do Postgres para dar um retorno compreensível.
 */
@Service
public class RegistrarFlashcardReviewService {

    private final StudySessionRepository studySessionRepository;
    private final FlashcardRepository flashcardRepository;
    private final FlashcardReviewRepository flashcardReviewRepository;
    private final RecalcularDomainProgressService recalcularDomainProgressService;

    public RegistrarFlashcardReviewService(StudySessionRepository studySessionRepository,
            FlashcardRepository flashcardRepository, FlashcardReviewRepository flashcardReviewRepository,
            RecalcularDomainProgressService recalcularDomainProgressService) {
        this.studySessionRepository = studySessionRepository;
        this.flashcardRepository = flashcardRepository;
        this.flashcardReviewRepository = flashcardReviewRepository;
        this.recalcularDomainProgressService = recalcularDomainProgressService;
    }

    @Transactional
    public FlashcardReviewDto registrar(UUID sessaoId, RegistrarFlashcardReviewRequest request) {
        // AC-10: valida antes de tocar no banco, com mensagem de negócio clara — não deixa o
        // Postgres rejeitar via CHECK constraint (ck_flashcard_review_resultado).
        ResultadoAutoavaliacao resultado = ResultadoAutoavaliacao.fromValor(request.resultadoAutoavaliacao());

        StudySession sessao = studySessionRepository.findById(sessaoId)
                .orElseThrow(() -> new RecursoNaoEncontradoException("Sessão não encontrada: " + sessaoId));

        Flashcard flashcard = flashcardRepository.findById(request.flashcardId())
                .orElseThrow(() -> new RecursoNaoEncontradoException("Flashcard não encontrado: " + request.flashcardId()));

        FlashcardReview review = flashcardReviewRepository.save(new FlashcardReview(sessao.getId(), flashcard.getId(),
                flashcard.getContentVersion(), resultado, request.confiancaDeclarada()));

        recalcularDomainProgressService.recalcular(sessao.getUserId(), sessao.getDomainRef());

        return new FlashcardReviewDto(review.getId(), review.getStudySessionId(), review.getFlashcardId(),
                review.getResultadoAutoavaliacao().getValor(), review.getRevisadoEm());
    }
}
