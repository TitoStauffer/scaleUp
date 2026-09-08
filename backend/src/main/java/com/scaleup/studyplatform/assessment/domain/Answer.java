package com.scaleup.studyplatform.assessment.domain;

import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/**
 * Mapeia answer (V10, coluna domain_ref acrescentada por V22). `domainRef` DEVE ser sempre
 * preenchido a partir de `quiz_attempt.domain_ref` (nunca do domain_ref da Question) — é
 * assim que a FK composta fk_answer_quiz_attempt_domain passa (ver V22 e
 * TICKET-assessment-progress.md, instrução do DBA no handoff da migração).
 */
@Entity
@Table(name = "answer")
public class Answer {

    @Id
    @GeneratedValue
    @Column(columnDefinition = "uuid", updatable = false, nullable = false)
    private UUID id;

    @Column(name = "quiz_attempt_id", nullable = false, columnDefinition = "uuid")
    private UUID quizAttemptId;

    @Column(name = "question_id", nullable = false, columnDefinition = "uuid")
    private UUID questionId;

    @Column(name = "question_content_version", nullable = false, length = 50)
    private String questionContentVersion;

    @Column(name = "alternativa_selecionada_id", nullable = false, columnDefinition = "uuid")
    private UUID alternativaSelecionadaId;

    @Column(nullable = false)
    private boolean correta;

    @Column(name = "confianca_declarada")
    private Short confiancaDeclarada;

    @Column(name = "domain_ref", nullable = false, columnDefinition = "uuid")
    private UUID domainRef;

    @Column(name = "respondido_em", nullable = false)
    private Instant respondidoEm;

    protected Answer() {
    }

    public Answer(UUID quizAttemptId, UUID questionId, String questionContentVersion,
            UUID alternativaSelecionadaId, boolean correta, Short confiancaDeclarada, UUID domainRef) {
        this.quizAttemptId = quizAttemptId;
        this.questionId = questionId;
        this.questionContentVersion = questionContentVersion;
        this.alternativaSelecionadaId = alternativaSelecionadaId;
        this.correta = correta;
        this.confiancaDeclarada = confiancaDeclarada;
        this.domainRef = domainRef;
        this.respondidoEm = Instant.now();
    }

    public UUID getId() {
        return id;
    }

    public UUID getQuizAttemptId() {
        return quizAttemptId;
    }

    public UUID getQuestionId() {
        return questionId;
    }

    public String getQuestionContentVersion() {
        return questionContentVersion;
    }

    public UUID getAlternativaSelecionadaId() {
        return alternativaSelecionadaId;
    }

    public boolean isCorreta() {
        return correta;
    }

    public Short getConfiancaDeclarada() {
        return confiancaDeclarada;
    }

    public UUID getDomainRef() {
        return domainRef;
    }

    public Instant getRespondidoEm() {
        return respondidoEm;
    }
}
