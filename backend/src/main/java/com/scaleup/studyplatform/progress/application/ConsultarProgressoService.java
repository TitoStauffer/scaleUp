package com.scaleup.studyplatform.progress.application;

import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.progress.application.dto.DomainProgressDto;
import com.scaleup.studyplatform.progress.domain.DomainProgress;
import com.scaleup.studyplatform.progress.infra.DomainProgressRepository;
import com.scaleup.studyplatform.shared.RecursoNaoEncontradoException;
import com.scaleup.studyplatform.content.infra.DomainRepository;

/**
 * GET /dominios/{dominioId}/progresso (ticket, seção 7). Se o usuário ainda não gerou
 * nenhuma evidência no domínio, não existe linha em domain_progress ainda — retorna o
 * estado "em avaliação" com o volume mínimo completo por atingir (seção 5.4), em vez de 404,
 * já que o domínio em si existe.
 */
@Service
public class ConsultarProgressoService {

    private static final int MIN_VOLUME_QUIZ = 3;
    private static final int MIN_VOLUME_FLASHCARD = 10;

    private final DomainProgressRepository domainProgressRepository;
    private final DomainRepository domainRepository;

    public ConsultarProgressoService(DomainProgressRepository domainProgressRepository,
            DomainRepository domainRepository) {
        this.domainProgressRepository = domainProgressRepository;
        this.domainRepository = domainRepository;
    }

    @Transactional(readOnly = true)
    public DomainProgressDto consultar(UUID userId, UUID domainId) {
        if (!domainRepository.existsById(domainId)) {
            throw new RecursoNaoEncontradoException("Domínio não encontrado: " + domainId);
        }

        return domainProgressRepository.findByUserIdAndDomainRef(userId, domainId)
                .map(ConsultarProgressoService::toDto)
                .orElseGet(() -> new DomainProgressDto(domainId, false, true, MIN_VOLUME_QUIZ, MIN_VOLUME_FLASHCARD,
                        null, null, null, null, null, null, null));
    }

    /**
     * Público e estático porque também é reaproveitado por
     * {@code assessment.application.SubmeterQuizAttemptService} para montar o
     * {@code DomainProgressDto} embutido na resposta da submissão (seção 7 do ticket: "retorna
     * ... o estado atualizado de domain_progress").
     */
    public static DomainProgressDto toDto(DomainProgress progresso) {
        boolean emAvaliacao = !progresso.isVolumeMinimoAtingido();
        int faltamQuiz = Math.max(0, MIN_VOLUME_QUIZ - progresso.getVolumeEvidenciaQuiz());
        int faltamFlashcard = Math.max(0, MIN_VOLUME_FLASHCARD - progresso.getVolumeEvidenciaFlashcard());
        String nivelAtual = progresso.getNivelAtual() == null ? null : progresso.getNivelAtual().getNome();
        return new DomainProgressDto(progresso.getDomainRef(), progresso.isVolumeMinimoAtingido(), emAvaliacao,
                faltamQuiz, faltamFlashcard, progresso.getPontuacaoQuiz(), progresso.getPontuacaoFlashcards(),
                progresso.getPontuacaoQuestoesNovas(), progresso.getPontuacaoConsistencia(),
                progresso.getPontuacaoCalibracao(), progresso.getPontuacaoGeral(), nivelAtual);
    }
}
