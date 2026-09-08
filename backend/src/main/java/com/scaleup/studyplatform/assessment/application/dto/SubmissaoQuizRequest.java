package com.scaleup.studyplatform.assessment.application.dto;

import java.util.List;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotEmpty;

public record SubmissaoQuizRequest(@NotEmpty @Valid List<RespostaSubmissaoRequest> respostas) {
}
