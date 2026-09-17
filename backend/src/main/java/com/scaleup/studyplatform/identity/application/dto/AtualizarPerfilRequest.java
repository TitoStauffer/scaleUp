package com.scaleup.studyplatform.identity.application.dto;

import java.time.LocalDate;

/**
 * PUT /api/usuarios/atual/perfil (TICKET-perfil-usuario.md, seção 6.1). `nome` e
 * `dataNascimento` são ambos opcionais e podem ser enviados como `null` para limpar o valor
 * já salvo — validação de conteúdo (nome vazio, data futura) acontece no service, não aqui.
 */
public record AtualizarPerfilRequest(String nome, LocalDate dataNascimento) {
}
