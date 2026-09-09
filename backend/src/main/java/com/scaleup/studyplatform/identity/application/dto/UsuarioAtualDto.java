package com.scaleup.studyplatform.identity.application.dto;

import java.util.UUID;

/**
 * Resposta de `GET /usuarios/atual` — permite ao cliente descobrir o `userId` da conta
 * autenticada pelo JWT da requisição, sem hardcode
 * (ver {@link com.scaleup.studyplatform.identity.application.CurrentUserProvider}). `nome` é
 * opcional (TICKET-autenticacao.md: cadastro real não coleta nome).
 */
public record UsuarioAtualDto(UUID id, String nome, String email) {
}
