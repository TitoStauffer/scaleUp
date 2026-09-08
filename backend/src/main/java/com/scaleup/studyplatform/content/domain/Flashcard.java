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
 * concept_ref é opcional (OPEN QUESTION-003, resolvida pelo DBA como NULL permitido).
 */
@Entity
@Table(name = "flashcard")
public class Flashcard {

    @Id
    @Column(columnDefinition = "uuid")
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "domain_ref", nullable = false)
    private Domain domain;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "concept_ref")
    private Concept concept;

    @Column(nullable = false, columnDefinition = "text")
    private String frente;

    @Column(nullable = false, columnDefinition = "text")
    private String verso;

    @Convert(converter = DificuldadeConverter.class)
    @Column(nullable = false, length = 10)
    private Dificuldade dificuldade;

    @Column(name = "content_version", nullable = false, length = 50)
    private String contentVersion;

    @Convert(converter = StatusRevisaoConverter.class)
    @Column(name = "status_revisao", nullable = false, length = 20)
    private StatusRevisao statusRevisao;

    @Column(name = "criado_em", nullable = false)
    private Instant criadoEm;

    @Column(name = "atualizado_em", nullable = false)
    private Instant atualizadoEm;

    protected Flashcard() {
    }

    public UUID getId() {
        return id;
    }

    public Domain getDomain() {
        return domain;
    }

    public Concept getConcept() {
        return concept;
    }

    public String getFrente() {
        return frente;
    }

    public String getVerso() {
        return verso;
    }

    public Dificuldade getDificuldade() {
        return dificuldade;
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
