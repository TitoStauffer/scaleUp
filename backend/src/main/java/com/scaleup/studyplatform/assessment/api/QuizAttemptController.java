package com.scaleup.studyplatform.assessment.api;

import java.util.UUID;

import jakarta.validation.Valid;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.scaleup.studyplatform.assessment.application.IniciarQuizAttemptService;
import com.scaleup.studyplatform.assessment.application.SubmeterQuizAttemptService;
import com.scaleup.studyplatform.assessment.application.dto.QuizAttemptDto;
import com.scaleup.studyplatform.assessment.application.dto.SubmissaoQuizRequest;
import com.scaleup.studyplatform.assessment.application.dto.SubmissaoResultadoDto;

/** 2 dos 7 endpoints do ticket (seção 7): iniciar tentativa de quiz e submeter respostas. */
@RestController
@RequestMapping("/api")
public class QuizAttemptController {

    private final IniciarQuizAttemptService iniciarQuizAttemptService;
    private final SubmeterQuizAttemptService submeterQuizAttemptService;

    public QuizAttemptController(IniciarQuizAttemptService iniciarQuizAttemptService,
            SubmeterQuizAttemptService submeterQuizAttemptService) {
        this.iniciarQuizAttemptService = iniciarQuizAttemptService;
        this.submeterQuizAttemptService = submeterQuizAttemptService;
    }

    @PostMapping("/sessoes/{sessaoId}/quiz-attempts")
    @ResponseStatus(HttpStatus.CREATED)
    public QuizAttemptDto iniciar(@PathVariable UUID sessaoId) {
        return iniciarQuizAttemptService.iniciar(sessaoId);
    }

    @PostMapping("/quiz-attempts/{attemptId}/submissao")
    public SubmissaoResultadoDto submeter(@PathVariable UUID attemptId, @Valid @RequestBody SubmissaoQuizRequest request) {
        return submeterQuizAttemptService.submeter(attemptId, request);
    }
}
