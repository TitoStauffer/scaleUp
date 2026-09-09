package com.scaleup.studyplatform.identity.application.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;

/** POST /api/auth/reenviar-token (ticket, seção 6). */
public record ReenviarRequest(@NotBlank @Email String email) {
}
