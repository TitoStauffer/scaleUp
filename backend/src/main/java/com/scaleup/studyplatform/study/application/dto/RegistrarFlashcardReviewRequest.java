package com.scaleup.studyplatform.study.application.dto;

import java.util.UUID;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

/**
 * `resultadoAutoavaliacao` chega como String (não o enum diretamente) para que a aplicação
 * rejeite valores inválidos com uma mensagem clara antes de qualquer tentativa de persistir
 * (AC-10) — deserializar direto para o enum faria o Jackson falhar com um erro genérico de
 * parsing em vez de uma mensagem de negócio.
 */
public record RegistrarFlashcardReviewRequest(
        @NotNull UUID flashcardId,
        @NotBlank String resultadoAutoavaliacao,
        @Min(1) @Max(5) Short confiancaDeclarada) {
}
