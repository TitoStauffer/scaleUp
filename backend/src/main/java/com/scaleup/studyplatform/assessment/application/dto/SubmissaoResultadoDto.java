package com.scaleup.studyplatform.assessment.application.dto;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.UUID;

import com.scaleup.studyplatform.progress.application.dto.DomainProgressDto;

public record SubmissaoResultadoDto(UUID quizAttemptId, int acertos, int totalQuestoes, BigDecimal pontuacaoObtida,
        Instant concluidoEm, List<RespostaResultadoDto> respostas, DomainProgressDto progresso) {
}
