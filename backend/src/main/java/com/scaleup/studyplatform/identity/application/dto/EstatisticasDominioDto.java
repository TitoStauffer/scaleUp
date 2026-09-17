package com.scaleup.studyplatform.identity.application.dto;

import java.math.BigDecimal;
import java.util.UUID;

/**
 * Item do bloco "porDominio" de GET /api/usuarios/atual/perfil/estatisticas
 * (TICKET-perfil-usuario.md, seção 7). Inclui todos os domínios existentes, mesmo sem
 * nenhuma atividade do usuário (contadores em 0, `pontuacaoQuizMedia=null`) — nunca omite um
 * domínio silenciosamente (AC-12).
 */
public record EstatisticasDominioDto(UUID domainRef, String nomeDominio, int totalSessoesEstudo,
        int totalTentativasQuiz, boolean volumeMinimoAtingido, BigDecimal pontuacaoQuizMedia) {
}
