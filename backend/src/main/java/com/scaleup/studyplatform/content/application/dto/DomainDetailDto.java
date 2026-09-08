package com.scaleup.studyplatform.content.application.dto;

import java.util.List;
import java.util.UUID;

public record DomainDetailDto(UUID id, String slug, String nome, String descricao, List<ConceptDto> conceitos) {
}
