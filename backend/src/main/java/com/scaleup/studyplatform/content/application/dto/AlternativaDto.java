package com.scaleup.studyplatform.content.application.dto;

import java.util.UUID;

/**
 * Nunca expõe o campo `correta` — regra de segurança já decidida na arquitetura: a API de
 * leitura não pode revelar a resposta certa antes da submissão.
 */
public record AlternativaDto(UUID id, String texto) {
}
