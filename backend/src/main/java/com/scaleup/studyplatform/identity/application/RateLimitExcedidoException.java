package com.scaleup.studyplatform.identity.application;

/**
 * Requisito não funcional do ticket (seção 8): login, cadastro e reenvio de token devem ter
 * alguma limitação de taxa. Mecanismo simplificado, documentado em {@link RateLimiter}.
 */
public class RateLimitExcedidoException extends RuntimeException {

    public RateLimitExcedidoException(String message) {
        super(message);
    }
}
