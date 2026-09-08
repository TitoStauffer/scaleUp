package com.scaleup.studyplatform.progress.application.dto;

import java.math.BigDecimal;

/**
 * `avaliado=false` (com `resultadoGeral=null`) representa o estado explícito "ainda não
 * avaliado" (AC-09) — nunca um resultado numérico `0`.
 */
public record ResultadoGeralDto(boolean avaliado, BigDecimal resultadoGeral, int dominiosAvaliados) {
}
