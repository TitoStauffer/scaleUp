package com.scaleup.studyplatform.identity.application.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

/** POST /api/auth/esqueci-senha (TICKET-esqueci-minha-senha.md, seção 9). */
public record EsqueciSenhaRequest(@NotBlank @Email String email) {
}
