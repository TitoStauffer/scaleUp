package com.scaleup.studyplatform.study.api;

import java.util.UUID;

import jakarta.validation.Valid;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.scaleup.studyplatform.study.application.IniciarSessaoService;
import com.scaleup.studyplatform.study.application.RegistrarFlashcardReviewService;
import com.scaleup.studyplatform.study.application.dto.FlashcardReviewDto;
import com.scaleup.studyplatform.study.application.dto.RegistrarFlashcardReviewRequest;
import com.scaleup.studyplatform.study.application.dto.StudySessionDto;

/** 2 dos 7 endpoints do ticket (seção 7): iniciar sessão e registrar revisão de flashcard. */
@RestController
@RequestMapping("/api")
public class SessaoController {

    private final IniciarSessaoService iniciarSessaoService;
    private final RegistrarFlashcardReviewService registrarFlashcardReviewService;

    public SessaoController(IniciarSessaoService iniciarSessaoService,
            RegistrarFlashcardReviewService registrarFlashcardReviewService) {
        this.iniciarSessaoService = iniciarSessaoService;
        this.registrarFlashcardReviewService = registrarFlashcardReviewService;
    }

    @PostMapping("/dominios/{dominioId}/sessoes")
    @ResponseStatus(HttpStatus.CREATED)
    public StudySessionDto iniciarSessao(@PathVariable UUID dominioId) {
        return iniciarSessaoService.iniciar(dominioId);
    }

    @PostMapping("/sessoes/{sessaoId}/flashcard-reviews")
    @ResponseStatus(HttpStatus.CREATED)
    public FlashcardReviewDto registrarFlashcardReview(@PathVariable UUID sessaoId,
            @Valid @RequestBody RegistrarFlashcardReviewRequest request) {
        return registrarFlashcardReviewService.registrar(sessaoId, request);
    }
}
