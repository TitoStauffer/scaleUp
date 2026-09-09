package com.scaleup.studyplatform.identity.domain;

import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/**
 * Mapeia token_confirmacao_cadastro (V34). Histórico de tokens por conta — reenviar invalida
 * o token anterior e insere um novo (ticket, seção 6), nunca reescreve a mesma linha.
 *
 * O banco garante, via {@code ux_token_confirmacao_aberto_por_conta}, no máximo um token "em
 * aberto" (nem consumido, nem invalidado) por conta — a aplicação precisa invalidar o
 * anterior e inserir o novo na MESMA transação ao reenviar, senão o INSERT falha.
 */
@Entity
@Table(name = "token_confirmacao_cadastro")
public class TokenConfirmacaoCadastro {

    @Id
    @GeneratedValue
    @Column(columnDefinition = "uuid", updatable = false, nullable = false)
    private UUID id;

    @Column(name = "user_id", nullable = false, columnDefinition = "uuid")
    private UUID userId;

    @Column(nullable = false, length = 6)
    private String token;

    @Column(name = "gerado_em", nullable = false)
    private Instant geradoEm;

    @Column(name = "expira_em", nullable = false)
    private Instant expiraEm;

    @Column(name = "consumido_em")
    private Instant consumidoEm;

    @Column(name = "invalidado_em")
    private Instant invalidadoEm;

    protected TokenConfirmacaoCadastro() {
    }

    public TokenConfirmacaoCadastro(UUID userId, String token, Instant geradoEm, Instant expiraEm) {
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

    /** AC-03: marca o token como efetivamente usado para confirmar a conta. */
    public void consumir() {
        this.consumidoEm = Instant.now();
    }

    /** Seção 6: marca o token como substituído por um reenvio, sem ter sido usado. */
    public void invalidar() {
        this.invalidadoEm = Instant.now();
    }
}
