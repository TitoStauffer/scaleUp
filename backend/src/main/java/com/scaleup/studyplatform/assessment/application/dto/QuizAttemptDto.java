package com.scaleup.studyplatform.assessment.application.dto;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

import com.scaleup.studyplatform.content.application.dto.QuestionDto;

/**
 * Resposta de criação de um QuizAttempt: as `questoes` reaproveitam
 * {@link QuestionDto}/{@link com.scaleup.studyplatform.content.application.dto.AlternativaDto}
 * do módulo Content — que já nunca expõem `correta`/`explicacao` (AC-13).
 */
public record QuizAttemptDto(UUID id, UUID domainRef, String status, int totalQuestoes, Instant iniciadoEm,
        List<QuestionDto> questoes) {
}
