package com.scaleup.studyplatform.study.domain;

import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/**
 * Mapeia flashcard_review (V9). study_session_id e flashcard_id ficam como UUID simples
 * pelo mesmo motivo documentado em {@link StudySession}.
 */
@Entity
@Table(name = "flashcard_review")
public class FlashcardReview {

    @Id
    @GeneratedValue
    @Column(columnDefinition = "uuid", updatable = false, nullable = false)
    private UUID id;

    @Column(name = "study_session_id", nullable = false, columnDefinition = "uuid")
    private UUID studySessionId;

    @Column(name = "flashcard_id", nullable = false, columnDefinition = "uuid")
    private UUID flashcardId;

    @Column(name = "flashcard_content_version", nullable = false, length = 50)
    private String flashcardContentVersion;

    @Convert(converter = ResultadoAutoavaliacaoConverter.class)
    @Column(name = "resultado_autoavaliacao", nullable = false, length = 20)
    private ResultadoAutoavaliacao resultadoAutoavaliacao;

    @Column(name = "confianca_declarada")
    private Short confiancaDeclarada;

    @Column(name = "revisado_em", nullable = false)
    private Instant revisadoEm;

    protected FlashcardReview() {
    }

    public FlashcardReview(UUID studySessionId, UUID flashcardId, String flashcardContentVersion,
            ResultadoAutoavaliacao resultadoAutoavaliacao, Short confiancaDeclarada) {
        this.studySessionId = studySessionId;
        this.flashcardId = flashcardId;
        this.flashcardContentVersion = flashcardContentVersion;
        this.resultadoAutoavaliacao = resultadoAutoavaliacao;
        this.confiancaDeclarada = confiancaDeclarada;
        this.revisadoEm = Instant.now();
    }

    public UUID getId() {
        return id;
    }

    public UUID getStudySessionId() {
        return studySessionId;
    }

    public UUID getFlashcardId() {
        return flashcardId;
    }

    public String getFlashcardContentVersion() {
        return flashcardContentVersion;
    }

    public ResultadoAutoavaliacao getResultadoAutoavaliacao() {
        return resultadoAutoavaliacao;
    }

    public Short getConfiancaDeclarada() {
        return confiancaDeclarada;
    }

    public Instant getRevisadoEm() {
        return revisadoEm;
    }
}
