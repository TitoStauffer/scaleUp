package com.scaleup.studyplatform.content.application.dto;

import java.util.UUID;

public record DomainSummaryDto(UUID id, String slug, String nome, String descricao) {
}
