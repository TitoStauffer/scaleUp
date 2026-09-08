package com.scaleup.studyplatform.content.application.dto;

import java.util.UUID;

public record SlideDto(UUID id, String titulo, String conteudo, int ordem) {
}
