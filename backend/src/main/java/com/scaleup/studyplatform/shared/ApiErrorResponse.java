package com.scaleup.studyplatform.shared;

import java.time.Instant;

public record ApiErrorResponse(Instant timestamp, int status, String erro, String mensagem, String caminho) {
}
