package com.scaleup.studyplatform.progress.domain;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

/**
 * Mapeia domain_progress (V12) — um registro por (usuário, domínio), recalculado
 * deterministicamente a partir das evidências brutas (não é tabela de histórico, ver
 * database-schema.md). user_id/domain_ref ficam como UUID simples pelo mesmo motivo já
 * documentado em study.domain.StudySession; nivel_atual_id é a única relação JPA de fato
 * (aponta para configuração do próprio módulo Progress).
 */
@Entity
@Table(name = "domain_progress")
public class DomainProgress {

    @Id
    @GeneratedValue
    @Column(columnDefinition = "uuid", updatable = false, nullable = false)
    private UUID id;

    @Column(name = "user_id", nullable = false, columnDefinition = "uuid")
    private UUID userId;

    @Column(name = "domain_ref", nullable = false, columnDefinition = "uuid")
    private UUID domainRef;

    @Column(name = "pontuacao_quiz")
    private BigDecimal pontuacaoQuiz;

    @Column(name = "pontuacao_flashcards")
    private BigDecimal pontuacaoFlashcards;

    @Column(name = "pontuacao_questoes_novas")
    private BigDecimal pontuacaoQuestoesNovas;

    @Column(name = "pontuacao_consistencia")
    private BigDecimal pontuacaoConsistencia;

    @Column(name = "pontuacao_calibracao")
    private BigDecimal pontuacaoCalibracao;

    @Column(name = "pontuacao_geral")
    private BigDecimal pontuacaoGeral;

    @ManyToOne
    @JoinColumn(name = "nivel_atual_id")
    private NivelReferencia nivelAtual;

    @Column(name = "volume_evidencia_quiz", nullable = false)
    private int volumeEvidenciaQuiz;

    @Column(name = "volume_evidencia_flashcard", nullable = false)
    private int volumeEvidenciaFlashcard;

    @Column(name = "volume_minimo_atingido", nullable = false)
    private boolean volumeMinimoAtingido;

    @Column(name = "ultima_avaliacao_em")
    private Instant ultimaAvaliacaoEm;

    @Column(name = "atualizado_em", nullable = false)
    private Instant atualizadoEm;

    protected DomainProgress() {
    }

    public DomainProgress(UUID userId, UUID domainRef) {
        this.userId = userId;
        this.domainRef = domainRef;
        this.atualizadoEm = Instant.now();
    }

    public UUID getId() {
        return id;
    }

    public UUID getUserId() {
        return userId;
    }

    public UUID getDomainRef() {
        return domainRef;
    }

    public BigDecimal getPontuacaoQuiz() {
        return pontuacaoQuiz;
    }

    public void setPontuacaoQuiz(BigDecimal pontuacaoQuiz) {
        this.pontuacaoQuiz = pontuacaoQuiz;
    }

    public BigDecimal getPontuacaoFlashcards() {
        return pontuacaoFlashcards;
    }

    public void setPontuacaoFlashcards(BigDecimal pontuacaoFlashcards) {
        this.pontuacaoFlashcards = pontuacaoFlashcards;
    }

    public BigDecimal getPontuacaoQuestoesNovas() {
        return pontuacaoQuestoesNovas;
    }

    public void setPontuacaoQuestoesNovas(BigDecimal pontuacaoQuestoesNovas) {
        this.pontuacaoQuestoesNovas = pontuacaoQuestoesNovas;
    }

    public BigDecimal getPontuacaoConsistencia() {
        return pontuacaoConsistencia;
    }

    public void setPontuacaoConsistencia(BigDecimal pontuacaoConsistencia) {
        this.pontuacaoConsistencia = pontuacaoConsistencia;
    }

    public BigDecimal getPontuacaoCalibracao() {
        return pontuacaoCalibracao;
    }

    public void setPontuacaoCalibracao(BigDecimal pontuacaoCalibracao) {
        this.pontuacaoCalibracao = pontuacaoCalibracao;
    }

    public BigDecimal getPontuacaoGeral() {
        return pontuacaoGeral;
    }

    public void setPontuacaoGeral(BigDecimal pontuacaoGeral) {
        this.pontuacaoGeral = pontuacaoGeral;
    }

    public NivelReferencia getNivelAtual() {
        return nivelAtual;
    }

    public void setNivelAtual(NivelReferencia nivelAtual) {
        this.nivelAtual = nivelAtual;
    }

    public int getVolumeEvidenciaQuiz() {
        return volumeEvidenciaQuiz;
    }

    public void setVolumeEvidenciaQuiz(int volumeEvidenciaQuiz) {
        this.volumeEvidenciaQuiz = volumeEvidenciaQuiz;
    }

    public int getVolumeEvidenciaFlashcard() {
        return volumeEvidenciaFlashcard;
    }

    public void setVolumeEvidenciaFlashcard(int volumeEvidenciaFlashcard) {
        this.volumeEvidenciaFlashcard = volumeEvidenciaFlashcard;
    }

    public boolean isVolumeMinimoAtingido() {
        return volumeMinimoAtingido;
    }

    public void setVolumeMinimoAtingido(boolean volumeMinimoAtingido) {
        this.volumeMinimoAtingido = volumeMinimoAtingido;
    }

    public Instant getUltimaAvaliacaoEm() {
        return ultimaAvaliacaoEm;
    }

    public void setUltimaAvaliacaoEm(Instant ultimaAvaliacaoEm) {
        this.ultimaAvaliacaoEm = ultimaAvaliacaoEm;
    }

    public Instant getAtualizadoEm() {
        return atualizadoEm;
    }

    public void setAtualizadoEm(Instant atualizadoEm) {
        this.atualizadoEm = atualizadoEm;
    }
}
