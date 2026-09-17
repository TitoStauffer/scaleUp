package com.scaleup.studyplatform.identity.application.dto;

import jakarta.validation.constraints.NotBlank;

/**
 * POST /api/usuarios/atual/senha (TICKET-alterar-senha.md, seção 6). A regra completa de
 * força da nova senha, a conferência `novaSenha == confirmacaoNovaSenha` e a comparação com a
 * senha atual são validadas no service, não aqui — mesmo padrão de {@code CadastroRequest}.
 */
public record AlterarSenhaRequest(
        @NotBlank String senhaAtual,
        @NotBlank String novaSenha,
        @NotBlank String confirmacaoNovaSenha) {
}
