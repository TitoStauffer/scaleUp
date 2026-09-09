package com.scaleup.studyplatform.support;

import java.util.UUID;

/** Resultado de {@link AuthTestSupport#cadastrarConfirmarELogar}: usuário de teste já autenticado. */
public record AutenticacaoTeste(UUID userId, String email, String jwt) {
}
