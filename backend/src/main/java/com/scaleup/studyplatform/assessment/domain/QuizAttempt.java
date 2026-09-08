package com.scaleup.studyplatform.assessment.domain;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/**
 * Mapeia quiz_attempt (V10). study_session_id e domain_ref ficam como UUID simples, mesma
 * decisão de desacoplamento já documentada em study.domain.StudySession.
 */
@Entity
@Table(name = "quiz_attempt")
public class QuizAttempt {

    @Id
    @GeneratedValue
    @Column(columnDefinition = "uuid", updatable = false, nullable = false)
    private UUID id;

    @Column(name = "study_session_id", nullable = false, columnDefinition = "uuid")
    private UUID studySessionId;

    @Column(name = "domain_ref", nullable = false, columnDefinition = "uuid")
    private UUID domainRef;

    @Convert(converter = StatusTentativaConverter.class)
    @Column(nullable = false, length = 20)
    private StatusTentativa status;

    @Column(name = "total_questoes", nullable = false)
    private int totalQuestoes;

    @Column(name = "pontuacao_obtida")
    private BigDecimal pontuacaoObtida;

    @Column(name = "iniciado_em", nullable = false)
    private Instant iniciadoEm;

    @Column(name = "concluido_em")
    private Instant concluidoEm;

    protected QuizAttempt() {
    }

    public QuizAttempt(UUID studySessionId, UUID domainRef, int totalQuestoes) {
        this.studySessionId = studySessionId;
        this.domainRef = domainRef;
        this.status = StatusTentativa.EM_ANDAMENTO;
        this.totalQuestoes = totalQuestoes;
        this.iniciadoEm = Instant.now();
    }

    public UUID getId() {
        return id;
    }

    public UUID getStudySessionId() {
        return studySessionId;
    }

    public UUID getDomainRef() {
        return domainRef;
    }

    public StatusTentativa getStatus() {
        return status;
    }

    public int getTotalQuestoes() {
        return totalQuestoes;
    }

    public BigDecimal getPontuacaoObtida() {
        return pontuacaoObtida;
    }

    public Instant getIniciadoEm() {
        return iniciadoEm;
    }

    public Instant getConcluidoEm() {
        return concluidoEm;
    }

    public void concluir(BigDecimal pontuacaoObtida) {
        this.status = StatusTentativa.CONCLUIDA;
        this.pontuacaoObtida = pontuacaoObtida;
        this.concluidoEm = Instant.now();
    }
}
