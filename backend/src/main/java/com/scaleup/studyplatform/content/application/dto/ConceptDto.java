package com.scaleup.studyplatform.content.application.dto;

import java.util.List;
import java.util.UUID;

public record ConceptDto(UUID id, String titulo, String resumo, List<SlideDto> slides) {
}
