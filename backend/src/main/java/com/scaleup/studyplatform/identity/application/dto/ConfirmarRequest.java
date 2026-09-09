package com.scaleup.studyplatform.identity.application.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

/** POST /api/auth/confirmar (ticket, seção 5). */
public record ConfirmarRequest(
        @NotBlank @Email String email,
        @NotBlank @Pattern(regexp = "^[0-9]{6}$", message = "deve ter exatamente 6 dígitos numéricos") String token) {
}
