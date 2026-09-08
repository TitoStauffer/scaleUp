package com.scaleup.studyplatform.progress.domain;

import java.math.BigDecimal;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/**
 * Mapeia componente_peso (V11) — pesos dos 5 componentes de pontuação, já seedados com os
 * valores do PRD (não alterados por este módulo).
 */
@Entity
@Table(name = "componente_peso")
public class ComponentePeso {

    @Id
    @Column(columnDefinition = "uuid")
    private UUID id;

    @Column(nullable = false, length = 30)
    private String componente;

    @Column(nullable = false)
    private BigDecimal peso;

    @Column(nullable = false)
    private Short ordem;

    protected ComponentePeso() {
    }

    public UUID getId() {
        return id;
    }

    public String getComponente() {
        return componente;
    }

    public BigDecimal getPeso() {
        return peso;
    }

    public Short getOrdem() {
        return ordem;
    }
}
