package com.scaleup.studyplatform.progress.application.dto;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

public record HistoricoItemDto(UUID quizAttemptId, UUID domainRef, BigDecimal pontuacaoObtida, Instant iniciadoEm,
        Instant concluidoEm) {
}
