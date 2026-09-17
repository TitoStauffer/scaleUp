package com.scaleup.studyplatform.identity.domain;

import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/**
 * Mapeia token_recuperacao_senha (V49). Espelha {@link TokenConfirmacaoCadastro} quase 1:1
 * (TICKET-esqueci-minha-senha.md, seção 6) — mesmo padrão de histórico por conta, mesma
 * distinção consumido/invalidado, mesma garantia de banco de no máximo um token "em aberto"
 * por conta (via {@code ux_token_recuperacao_aberto_por_conta}).
 */
@Entity
@Table(name = "token_recuperacao_senha")
public class TokenRecuperacaoSenha {

    @Id
    @GeneratedValue
    @Column(columnDefinition = "uuid", updatable = false, nullable = false)
    private UUID id;

    @Column(name = "user_id", nullable = false, columnDefinition = "uuid")
    private UUID userId;

    @Column(nullable = false, length = 64)
    private String token;

    @Column(name = "gerado_em", nullable = false)
    private Instant geradoEm;

    @Column(name = "expira_em", nullable = false)
    private Instant expiraEm;

    @Column(name = "consumido_em")
    private Instant consumidoEm;

    @Column(name = "invalidado_em")
    private Instant invalidadoEm;

    protected TokenRecuperacaoSenha() {
    }

    public TokenRecuperacaoSenha(UUID userId, String token, Instant geradoEm, Instant expiraEm) {
        this.userId = userId;
        this.token = token;
        this.geradoEm = geradoEm;
        this.expiraEm = expiraEm;
    }

    public UUID getId() {
        return id;
    }

    public UUID getUserId() {
        return userId;
    }

    public String getToken() {
        return token;
    }

    public Instant getGeradoEm() {
        return geradoEm;
    }

    public Instant getExpiraEm() {
        return expiraEm;
    }

    public Instant getConsumidoEm() {
        return consumidoEm;
    }

    public Instant getInvalidadoEm() {
        return invalidadoEm;
    }

    public boolean isExpirado(Instant agora) {
        return agora.isAfter(expiraEm);
    }

    public boolean isAberto() {
        return consumidoEm == null && invalidadoEm == null;
    }

    /** AC-04: marca o token como efetivamente usado para redefinir a senha. */
    public void consumir() {
        this.consumidoEm = Instant.now();
    }

    /** AC-09: marca o token como substituído por uma nova solicitação, sem ter sido usado. */
    public void invalidar() {
        this.invalidadoEm = Instant.now();
    }
}
