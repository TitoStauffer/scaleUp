package com.scaleup.studyplatform.content.domain;

import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

/**
 * Não tem content_version/status_revisao próprios: faz parte da versão da Question à qual
 * pertence. O campo `correta` NUNCA deve ser exposto pela API de leitura antes da
 * submissão (regra já decidida na arquitetura) — por isso não existe no QuestionDto.
 */
@Entity
@Table(name = "question_alternative")
public class QuestionAlternative {

    @Id
    @Column(columnDefinition = "uuid")
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "question_id", nullable = false)
    private Question question;

    @Column(nullable = false, columnDefinition = "text")
    private String texto;

    @Column(nullable = false)
    private boolean correta;

    @Column(name = "criado_em", nullable = false)
    private Instant criadoEm;

    protected QuestionAlternative() {
    }

    public UUID getId() {
        return id;
    }

    public Question getQuestion() {
        return question;
    }

    public String getTexto() {
        return texto;
    }

    public boolean isCorreta() {
        return correta;
    }

    public Instant getCriadoEm() {
        return criadoEm;
    }
}
