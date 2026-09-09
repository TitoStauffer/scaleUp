package com.scaleup.studyplatform.identity.application;

/**
 * AC-08: e-mail não encontrado OU senha incorreta — sempre a mesma mensagem genérica, para
 * não diferenciar os dois casos (anti-enumeração, ticket seção 7).
 */
public class CredenciaisInvalidasException extends RuntimeException {

    public CredenciaisInvalidasException(String message) {
        super(message);
    }
}
