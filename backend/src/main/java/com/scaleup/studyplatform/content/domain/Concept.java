package com.scaleup.studyplatform.content.domain;

import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

/**
 * Agrupa Slides/Flashcards/Questions dentro de um Domain para fins de organização do
 * estudo. Não é usado como categoria de força/fraqueza do usuário — isso é resolvido por
 * Question.domain_ref + DomainProgress (OPEN QUESTION-003, resolvida pelo DBA).
 */
@Entity
@Table(name = "concept")
public class Concept {

    @Id
    @Column(columnDefinition = "uuid")
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "domain_ref", nullable = false)
    private Domain domain;

    @Column(nullable = false, length = 200)
    private String titulo;

    @Column(nullable = false, columnDefinition = "text")
    private String resumo;

    @Column(nullable = false)
    private Integer ordem;

    @Column(name = "content_version", nullable = false, length = 50)
    private String contentVersion;

    @Convert(converter = StatusRevisaoConverter.class)
    @Column(name = "status_revisao", nullable = false, length = 20)
    private StatusRevisao statusRevisao;

    @Column(name = "criado_em", nullable = false)
    private Instant criadoEm;

    @Column(name = "atualizado_em", nullable = false)
    private Instant atualizadoEm;

    protected Concept() {
    }

    public UUID getId() {
        return id;
    }

    public Domain getDomain() {
        return domain;
    }

    public String getTitulo() {
        return titulo;
    }

    public String getResumo() {
        return resumo;
    }

    public Integer getOrdem() {
        return ordem;
    }

    public String getContentVersion() {
        return contentVersion;
    }

    public StatusRevisao getStatusRevisao() {
        return statusRevisao;
    }

    public Instant getCriadoEm() {
        return criadoEm;
    }

    public Instant getAtualizadoEm() {
        return atualizadoEm;
    }
}
