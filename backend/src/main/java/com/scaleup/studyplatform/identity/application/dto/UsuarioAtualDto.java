package com.scaleup.studyplatform.identity.application.dto;

import java.util.UUID;

/**
 * Resposta de `GET /usuarios/atual` — permite ao cliente descobrir o `userId` do único
 * usuário local do MVP sem hardcode (ver {@link com.scaleup.studyplatform.identity.application.CurrentUserProvider}).
 */
public record UsuarioAtualDto(UUID id, String nome, String email) {
}
