package com.scaleup.studyplatform.identity.application.dto;

import java.time.Instant;

/** AC-09: JWT emitido no login bem-sucedido. `tipo` segue a convenção do header `Authorization: Bearer <token>`. */
public record LoginResponseDto(String token, String tipo, Instant expiraEm) {
}
