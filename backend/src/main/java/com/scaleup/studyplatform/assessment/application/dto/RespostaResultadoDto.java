package com.scaleup.studyplatform.assessment.application.dto;

import java.util.UUID;

/**
 * Só existe depois da submissão — é aqui, e só aqui, que `alternativaCorretaId` e
 * `explicacao` podem ser expostos (AC-01, AC-13).
 */
public record RespostaResultadoDto(UUID questionId, boolean correta, UUID alternativaCorretaId, String explicacao) {
}
