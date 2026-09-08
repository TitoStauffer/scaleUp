package com.scaleup.studyplatform.progress.application.dto;

import java.math.BigDecimal;
import java.util.UUID;

/**
 * `emAvaliacao=true` significa que o domínio ainda não atingiu o volume mínimo de evidência
 * (seção 5.4 do ticket) — `pontuacaoGeral` e `nivelAtual` permanecem `null` nesse caso, e
 * `faltamSessoesQuiz`/`faltamRevisoesFlashcard` informam quanto falta.
 */
public record DomainProgressDto(
        UUID domainRef,
        boolean volumeMinimoAtingido,
        boolean emAvaliacao,
        int faltamSessoesQuiz,
        int faltamRevisoesFlashcard,
        BigDecimal pontuacaoQuiz,
        BigDecimal pontuacaoFlashcards,
        BigDecimal pontuacaoQuestoesNovas,
        BigDecimal pontuacaoConsistencia,
        BigDecimal pontuacaoCalibracao,
        BigDecimal pontuacaoGeral,
        String nivelAtual) {
}
