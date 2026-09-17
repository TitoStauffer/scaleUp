package com.scaleup.studyplatform.identity.application.dto;

import java.time.LocalDate;
import java.util.UUID;

/**
 * Resposta de `GET /usuarios/atual` — permite ao cliente descobrir o `userId` da conta
 * autenticada pelo JWT da requisição, sem hardcode
 * (ver {@link com.scaleup.studyplatform.identity.application.CurrentUserProvider}). `nome` e
 * `dataNascimento` são opcionais (TICKET-perfil-usuario.md). `temFotoPerfil` é derivado
 * (`foto_perfil IS NOT NULL`) — o cliente busca os bytes separadamente em
 * `GET /usuarios/atual/foto` só quando precisa exibir a imagem.
 */
public record UsuarioAtualDto(UUID id, String nome, String email, LocalDate dataNascimento, boolean temFotoPerfil) {
}
