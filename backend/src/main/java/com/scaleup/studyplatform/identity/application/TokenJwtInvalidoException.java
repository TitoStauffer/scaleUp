package com.scaleup.studyplatform.identity.application;

/**
 * JWT ausente, malformado, com assinatura inválida ou expirado. Nunca chega ao cliente com
 * detalhe (AC-11 exige 401 uniforme) — capturada pelo filtro de autenticação, não pelo
 * {@code GlobalExceptionHandler}.
 */
public class TokenJwtInvalidoException extends RuntimeException {

    public TokenJwtInvalidoException(String message, Throwable cause) {
        super(message, cause);
    }
}
