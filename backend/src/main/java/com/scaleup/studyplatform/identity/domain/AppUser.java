package com.scaleup.studyplatform.identity.domain;

import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/**
 * Usuário único/local do MVP (ver V8__cria_tabela_usuario.sql). Sem credenciais — o PRD
 * assume usuário único/local, autenticação real é decisão futura. A única linha em uso hoje
 * é semeada por V24__seed_usuario_local.sql e resolvida por
 * {@link com.scaleup.studyplatform.identity.application.CurrentUserProvider}.
 *
 * Entidade somente leitura: a criação de usuário não é um caso de uso desta etapa.
 */
@Entity
@Table(name = "app_user")
public class AppUser {

    @Id
    @Column(columnDefinition = "uuid")
    private UUID id;

    @Column(nullable = false, length = 255)
    private String email;

    @Column(nullable = false, length = 120)
    private String nome;

    @Column(name = "criado_em", nullable = false)
    private Instant criadoEm;

    @Column(name = "atualizado_em", nullable = false)
    private Instant atualizadoEm;

    protected AppUser() {
    }

    public UUID getId() {
        return id;
    }

    public String getEmail() {
        return email;
    }

    public String getNome() {
        return nome;
    }

    public Instant getCriadoEm() {
        return criadoEm;
    }

    public Instant getAtualizadoEm() {
        return atualizadoEm;
    }
}
