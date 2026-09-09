package com.scaleup.studyplatform.identity.application.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

/** POST /api/auth/login (ticket, seção 7). */
public record LoginRequest(@NotBlank @Email String email, @NotBlank String senha) {
}
