package com.scaleup.studyplatform.content.domain;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OrderBy;
import jakarta.persistence.Table;

/**
 * domain_ref é obrigatório: é a referência usada por DomainProgress para calcular pontos
 * fortes/fracos por categoria. concept_ref é opcional (mesma decisão de Flashcard).
 */
@Entity
@Table(name = "question")
public class Question {

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
    private String enunciado;

    @Column(nullable = false, columnDefinition = "text")
    private String explicacao;

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

    @OneToMany(mappedBy = "question", fetch = FetchType.LAZY)
    @OrderBy("criadoEm asc")
    private List<QuestionAlternative> alternativas;

    protected Question() {
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

    public String getEnunciado() {
        return enunciado;
    }

    public String getExplicacao() {
        return explicacao;
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

    public List<QuestionAlternative> getAlternativas() {
        return alternativas;
    }
}
