package com.scaleup.studyplatform.content.application.dto;

import java.util.List;
import java.util.UUID;

/**
 * Não expõe `explicacao` — pelo mesmo motivo de `AlternativaDto.correta`: evitaria vazar a
 * resposta certa indiretamente antes da submissão.
 */
public record QuestionDto(UUID id, String enunciado, String dificuldade, List<AlternativaDto> alternativas) {
}
