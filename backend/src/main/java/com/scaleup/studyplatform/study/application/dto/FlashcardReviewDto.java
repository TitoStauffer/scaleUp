package com.scaleup.studyplatform.study.application.dto;

import java.time.Instant;
import java.util.UUID;

public record FlashcardReviewDto(UUID id, UUID sessaoId, UUID flashcardId, String resultadoAutoavaliacao,
        Instant revisadoEm) {
}
