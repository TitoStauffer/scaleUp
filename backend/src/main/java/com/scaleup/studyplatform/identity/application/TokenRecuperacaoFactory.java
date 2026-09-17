package com.scaleup.studyplatform.identity.application;

import java.security.SecureRandom;
import java.time.Duration;
import java.time.Instant;
import java.util.Base64;
import java.util.UUID;

import org.springframework.stereotype.Component;

import com.scaleup.studyplatform.identity.domain.TokenRecuperacaoSenha;

/**
 * Gera tokens de recuperação de senha opacos e de alta entropia, com validade de 45 minutos
 * (TICKET-esqueci-minha-senha.md, OPEN QUESTION-004: fechada nesta implementação no meio da
 * faixa proposta de 30-60 min, sem motivo para pender para um dos extremos).
 *
 * 32 bytes aleatórios (256 bits) codificados em Base64 URL-safe sem padding — 43 caracteres,
 * dentro do intervalo aceito pela constraint {@code ck_token_recuperacao_formato} (V49).
 */
@Component
public class TokenRecuperacaoFactory {

    static final Duration VALIDADE = Duration.ofMinutes(45);
    private static final int TAMANHO_BYTES = 32;

    private final SecureRandom random = new SecureRandom();

    public TokenRecuperacaoSenha novoToken(UUID userId) {
        byte[] bytes = new byte[TAMANHO_BYTES];
        random.nextBytes(bytes);
        String valor = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
        Instant agora = Instant.now();
        return new TokenRecuperacaoSenha(userId, valor, agora, agora.plus(VALIDADE));
    }
}
