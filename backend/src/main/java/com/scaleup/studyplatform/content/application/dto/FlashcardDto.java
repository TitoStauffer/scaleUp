package com.scaleup.studyplatform.content.application.dto;

import java.util.UUID;

public record FlashcardDto(UUID id, String frente, String verso, String dificuldade) {
}
