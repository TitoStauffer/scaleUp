package com.scaleup.studyplatform.study.domain;

import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/**
 * Mapeia study_session (V9). user_id e domain_ref são mantidos como UUID simples (não
 * @ManyToOne para AppUser/Domain de outros módulos) para não acoplar o módulo Study a
 * entidades JPA de Identity/Content — a consistência referencial já é garantida pelo banco
 * (FKs em V9); a aplicação só precisa do id quando referenciar Content/Identity.
 */
@Entity
@Table(name = "study_session")
public class StudySession {

    @Id
    @GeneratedValue
    @Column(columnDefinition = "uuid", updatable = false, nullable = false)
    private UUID id;

    @Column(name = "user_id", nullable = false, columnDefinition = "uuid")
    private UUID userId;

    @Column(name = "domain_ref", nullable = false, columnDefinition = "uuid")
    private UUID domainRef;

    @Convert(converter = StatusSessaoConverter.class)
    @Column(nullable = false, length = 20)
    private StatusSessao status;

    @Column(name = "iniciada_em", nullable = false)
    private Instant iniciadaEm;

    @Column(name = "concluida_em")
    private Instant concluidaEm;

    protected StudySession() {
    }

    public StudySession(UUID userId, UUID domainRef) {
        this.userId = userId;
        this.domainRef = domainRef;
        this.status = StatusSessao.EM_ANDAMENTO;
        this.iniciadaEm = Instant.now();
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

    public StatusSessao getStatus() {
        return status;
    }

    public Instant getIniciadaEm() {
        return iniciadaEm;
    }

    public Instant getConcluidaEm() {
        return concluidaEm;
    }
}
