package com.scaleup.studyplatform.shared.security;

import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.Instant;
import java.util.Date;
import java.util.UUID;

import javax.crypto.SecretKey;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.scaleup.studyplatform.identity.application.TokenJwtInvalidoException;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

/**
 * Emissão e validação de JWT (ticket, seção 7). Claim {@code sub} carrega o id do usuário
 * (UUID), sem outras claims sensíveis (nunca e-mail/senha).
 *
 * <b>Expiração:</b> 24h por padrão (`auth.jwt.expiration-minutes`), escolhida como equilíbrio
 * entre não forçar login excessivamente frequente (não há refresh token neste ticket — fora
 * de escopo) e limitar a janela de um token vazado, dado que MFA/recuperação de sessão também
 * estão fora de escopo aqui.
 *
 * <b>Segredo:</b> lido de `auth.jwt.secret` (variável de ambiente `AUTH_JWT_SECRET`). O valor
 * default abaixo é só para desenvolvimento local — mesmo padrão de aviso já usado para
 * DB_USERNAME/DB_PASSWORD em application.yml. Precisa ter pelo menos 256 bits (32 bytes) para
 * HS256.
 */
@Component
public class JwtService {

    private final SecretKey chave;
    private final Duration expiracao;

    public JwtService(
            @Value("${auth.jwt.secret}") String segredo,
            @Value("${auth.jwt.expiration-minutes:1440}") long expiracaoMinutos) {
        this.chave = Keys.hmacShaKeyFor(segredo.getBytes(StandardCharsets.UTF_8));
        this.expiracao = Duration.ofMinutes(expiracaoMinutos);
    }

    public String gerarToken(UUID userId) {
        Instant agora = Instant.now();
        return Jwts.builder()
                .subject(userId.toString())
                .issuedAt(Date.from(agora))
                .expiration(Date.from(agora.plus(expiracao)))
                .signWith(chave)
                .compact();
    }

    public Instant calcularExpiracao(Instant emitidoEm) {
        return emitidoEm.plus(expiracao);
    }

    /** @throws TokenJwtInvalidoException se o token estiver ausente, malformado, com assinatura
     * inválida ou expirado — o chamador (filtro de autenticação) não distingue esses casos ao
     * responder ao cliente (AC-11: 401 uniforme). */
    public UUID validarEExtrairUserId(String token) {
        try {
            Claims claims = Jwts.parser()
                    .verifyWith(chave)
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();
            return UUID.fromString(claims.getSubject());
        } catch (JwtException | IllegalArgumentException e) {
            throw new TokenJwtInvalidoException("JWT inválido ou expirado", e);
        }
    }
}
