package com.scaleup.studyplatform.content.domain;

import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/**
 * Um dos 7 domínios do MVP (Arquitetura, Sistemas Distribuídos, etc.). Os registros são
 * dados (seed em V13__seed_dominios.sql), nunca hardcode/enum — restrição herdada do
 * ticket de conteúdo e do schema do DBA.
 *
 * Entidade somente leitura nesta etapa: a escrita de conteúdo é feita via migração SQL
 * (Flyway), não via este repositório JPA.
 */
@Entity
@Table(name = "domain")
public class Domain {

    @Id
    @Column(columnDefinition = "uuid")
    private UUID id;

    @Column(nullable = false, length = 80)
    private String slug;

    @Column(nullable = false, length = 120)
    private String nome;

    @Column(nullable = false, columnDefinition = "text")
    private String descricao;

    @Column(name = "content_version", nullable = false, length = 50)
    private String contentVersion;

    @Convert(converter = StatusRevisaoConverter.class)
    @Column(name = "status_revisao", nullable = false, length = 20)
    private StatusRevisao statusRevisao;

    @Column(name = "criado_em", nullable = false)
    private Instant criadoEm;

    @Column(name = "atualizado_em", nullable = false)
    private Instant atualizadoEm;

    protected Domain() {
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

    public String getDescricao() {
        return descricao;
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
