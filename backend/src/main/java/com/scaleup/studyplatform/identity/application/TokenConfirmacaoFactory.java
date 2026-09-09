package com.scaleup.studyplatform.identity.application;

import java.security.SecureRandom;
import java.time.Duration;
import java.time.Instant;
import java.util.UUID;

import org.springframework.stereotype.Component;

import com.scaleup.studyplatform.identity.domain.TokenConfirmacaoCadastro;

/**
 * Gera tokens de confirmação de 6 dígitos numéricos com 20 minutos de validade (ticket, seção
 * 5) — usado tanto no cadastro quanto no reenvio, para não duplicar a regra de formato/prazo
 * em dois services.
 */
@Component
public class TokenConfirmacaoFactory {

    static final Duration VALIDADE = Duration.ofMinutes(20);

    private final SecureRandom random = new SecureRandom();

    public TokenConfirmacaoCadastro novoToken(UUID userId) {
        String valor = String.format("%06d", random.nextInt(1_000_000));
        Instant agora = Instant.now();
        return new TokenConfirmacaoCadastro(userId, valor, agora, agora.plus(VALIDADE));
    }
}
