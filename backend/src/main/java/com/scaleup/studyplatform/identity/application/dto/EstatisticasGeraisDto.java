package com.scaleup.studyplatform.identity.application.dto;

import java.math.BigDecimal;

/**
 * Bloco "geral" de GET /api/usuarios/atual/perfil/estatisticas (TICKET-perfil-usuario.md,
 * seção 7). `resultadoGeralAvaliado=false` (com `pontuacaoGeralMedia=null`) espelha o mesmo
 * estado explícito de {@code ResultadoGeralDto.avaliado} — nunca um `0` numérico.
 */
public record EstatisticasGeraisDto(int totalSessoesEstudo, int totalTentativasQuiz, boolean resultadoGeralAvaliado,
        BigDecimal pontuacaoGeralMedia) {
}
