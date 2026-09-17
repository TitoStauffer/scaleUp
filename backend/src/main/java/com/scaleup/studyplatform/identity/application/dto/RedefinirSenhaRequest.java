package com.scaleup.studyplatform.identity.application.dto;

import jakarta.validation.constraints.NotBlank;

/** POST /api/auth/redefinir-senha (TICKET-esqueci-minha-senha.md, seção 9). */
public record RedefinirSenhaRequest(
        @NotBlank String token,
        @NotBlank String novaSenha,
        @NotBlank String confirmacaoNovaSenha) {
}
