package com.scaleup.studyplatform.identity.application.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

/**
 * POST /api/auth/cadastro (ticket, seção 4). A regra completa de força de senha e a
 * conferência `senha == confirmacaoSenha` são validadas no service, não aqui — mensagens de
 * erro específicas (AC-02) exigem lógica além do que `@Pattern` conseguiria expressar com
 * clareza.
 */
public record CadastroRequest(
        @NotBlank @Email String email,
        @NotBlank String senha,
        @NotBlank String confirmacaoSenha) {
}
