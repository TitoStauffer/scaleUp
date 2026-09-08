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
 * concept_ref é obrigatório (decisão do PM) — diferente de Flashcard/Question, cujo
 * concept_ref é opcional. domain_ref é mantido explícito na tabela (facilita consultas),
 * com consistência garantida por FK composta no banco (fk_slide_concept_domain).
 */
@Entity
@Table(name = "slide")
public class Slide {

    @Id
    @Column(columnDefinition = "uuid")
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "concept_ref", nullable = false)
    private Concept concept;

    @Column(name = "domain_ref", nullable = false, columnDefinition = "uuid")
    private UUID domainRef;

    @Column(nullable = false, length = 200)
    private String titulo;

    @Column(nullable = false, columnDefinition = "text")
    private String conteudo;

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

    protected Slide() {
    }

    public UUID getId() {
        return id;
    }

    public Concept getConcept() {
        return concept;
    }

    public UUID getDomainRef() {
        return domainRef;
    }

    public String getTitulo() {
        return titulo;
    }

    public String getConteudo() {
        return conteudo;
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
