package com.scaleup.studyplatform.identity.domain;

import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Convert;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/**
 * Conta de usuário (TICKET-autenticacao.md). Antes desta migração, era um registro único e
 * fixo semeado por V24 (usuário "local" do MVP, sem credenciais). V33 estendeu a tabela com
 * {@code senha_hash} e {@code status_conta} para suportar cadastro/confirmação/login reais —
 * ver notas do DBA na própria migração.
 *
 * {@code nome} é opcional (V33): o fluxo de cadastro real (ticket, seção 4) só pede e-mail e
 * senha, não nome.
 */
@Entity
@Table(name = "app_user")
public class AppUser {

    @Id
    @GeneratedValue
    @Column(columnDefinition = "uuid", updatable = false, nullable = false)
    private UUID id;

    @Column(nullable = false, length = 255)
    private String email;

    @Column(length = 120)
    private String nome;

    @Column(name = "senha_hash", length = 255)
    private String senhaHash;

    @Convert(converter = StatusContaConverter.class)
    @Column(name = "status_conta", nullable = false, length = 20)
    private StatusConta statusConta;

    @Column(name = "criado_em", nullable = false)
    private Instant criadoEm;

    @Column(name = "atualizado_em", nullable = false)
    private Instant atualizadoEm;

    protected AppUser() {
    }

    /** Cria uma conta nova pendente de confirmação (ticket, seção 4). */
    public AppUser(String email, String senhaHash) {
        this.email = email;
        this.senhaHash = senhaHash;
        this.statusConta = StatusConta.PENDENTE;
        Instant agora = Instant.now();
        this.criadoEm = agora;
        this.atualizadoEm = agora;
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

    public String getSenhaHash() {
        return senhaHash;
    }

    public StatusConta getStatusConta() {
        return statusConta;
    }

    public boolean isAtiva() {
        return statusConta == StatusConta.ATIVO;
    }

    public Instant getCriadoEm() {
        return criadoEm;
    }

    public Instant getAtualizadoEm() {
        return atualizadoEm;
    }

    /** Ativa a conta (AC-03) — idempotente por natureza: chamar de novo não faz sentido de negócio,
     * mas quem decide "já está ativa" é o serviço de confirmação (AC-13), não esta entidade. */
    public void ativar() {
        this.statusConta = StatusConta.ATIVO;
        this.atualizadoEm = Instant.now();
    }

    /** Substitui a senha (reservado para reenvio/futuro; hoje só usado na criação). */
    public void redefinirSenhaHash(String novoHash) {
        this.senhaHash = novoHash;
        this.atualizadoEm = Instant.now();
    }
}
