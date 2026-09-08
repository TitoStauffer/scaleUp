package com.scaleup.studyplatform.progress.domain;

import java.math.BigDecimal;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/**
 * Mapeia nivel_referencia (V11, thresholds atualizados por V23 — ver
 * TICKET-assessment-progress.md, seção 5.1). Configuração, não escrita pela aplicação.
 */
@Entity
@Table(name = "nivel_referencia")
public class NivelReferencia {

    @Id
    @Column(columnDefinition = "uuid")
    private UUID id;

    @Column(nullable = false, length = 30)
    private String slug;

    @Column(nullable = false, length = 60)
    private String nome;

    @Column(nullable = false)
    private Short ordem;

    @Column(name = "pontuacao_minima", nullable = false)
    private BigDecimal pontuacaoMinima;

    @Column(name = "pontuacao_maxima", nullable = false)
    private BigDecimal pontuacaoMaxima;

    protected NivelReferencia() {
    }

    /**
     * Construtor de conveniência para testes (ex.: ProgressFormulasTest) que exercitam
     * {@link com.scaleup.studyplatform.progress.application.ProgressFormulas#determinarNivel}
     * sem subir um banco — a entidade em si é só configuração lida do banco em produção,
     * nunca escrita pela aplicação.
     */
    public NivelReferencia(String slug, String nome, short ordem, BigDecimal pontuacaoMinima, BigDecimal pontuacaoMaxima) {
        this.slug = slug;
        this.nome = nome;
        this.ordem = ordem;
        this.pontuacaoMinima = pontuacaoMinima;
        this.pontuacaoMaxima = pontuacaoMaxima;
    }

    public UUID getId() {
        return id;
    }

    public String getSlug() {
        return slug;
    }

    public String getNome() {
        return nome;
    }

    public Short getOrdem() {
        return ordem;
    }

    public BigDecimal getPontuacaoMinima() {
        return pontuacaoMinima;
    }

    public BigDecimal getPontuacaoMaxima() {
        return pontuacaoMaxima;
    }
}
