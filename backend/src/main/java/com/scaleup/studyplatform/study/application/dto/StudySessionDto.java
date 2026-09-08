package com.scaleup.studyplatform.study.application.dto;

import java.time.Instant;
import java.util.UUID;

public record StudySessionDto(UUID id, UUID dominioId, String status, Instant iniciadaEm) {
}
