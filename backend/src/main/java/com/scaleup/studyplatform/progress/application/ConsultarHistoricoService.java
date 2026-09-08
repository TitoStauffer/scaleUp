package com.scaleup.studyplatform.progress.application;

import java.util.List;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.assessment.domain.QuizAttempt;
import com.scaleup.studyplatform.assessment.infra.QuizAttemptRepository;
import com.scaleup.studyplatform.progress.application.dto.HistoricoItemDto;

/**
 * GET /usuarios/{userId}/historico?dominioId= (ticket, seção 7 e AC-11): QuizAttempt
 * concluídas, mais recente primeiro, com `pontuacao_obtida` e `concluido_em` — suficiente
 * para uma série temporal de evolução sem nenhuma tabela de snapshot adicional (mesma
 * decisão já registrada em database-schema.md, seção 6).
 */
@Service
public class ConsultarHistoricoService {

    private final QuizAttemptRepository quizAttemptRepository;

    public ConsultarHistoricoService(QuizAttemptRepository quizAttemptRepository) {
        this.quizAttemptRepository = quizAttemptRepository;
    }

    @Transactional(readOnly = true)
    public List<HistoricoItemDto> consultar(UUID userId, UUID dominioId) {
        List<QuizAttempt> tentativas = dominioId == null
                ? quizAttemptRepository.findAllConcludedByUserOrderByConcluidoEmDesc(userId)
                : quizAttemptRepository.findAllConcludedByUserAndDomainOrderByConcluidoEmDesc(userId, dominioId);

        return tentativas.stream()
                .map(qa -> new HistoricoItemDto(qa.getId(), qa.getDomainRef(), qa.getPontuacaoObtida(),
                        qa.getIniciadoEm(), qa.getConcluidoEm()))
                .toList();
    }
}
