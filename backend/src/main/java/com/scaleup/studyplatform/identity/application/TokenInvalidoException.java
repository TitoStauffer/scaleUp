package com.scaleup.studyplatform.identity.application;

/** AC-04: token informado difere do token em aberto da conta. */
public class TokenInvalidoException extends RuntimeException {

    public TokenInvalidoException(String message) {
        super(message);
    }
}
