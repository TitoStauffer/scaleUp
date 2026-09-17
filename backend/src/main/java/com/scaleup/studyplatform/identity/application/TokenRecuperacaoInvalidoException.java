package com.scaleup.studyplatform.identity.application;

/**
 * TICKET-esqueci-minha-senha.md, AC-05/AC-06/AC-07: token de recuperação inexistente,
 * expirado ou já consumido — um único erro genérico para os três casos (ticket, seção 9: "não
 * revelar mais detalhes").
 */
public class TokenRecuperacaoInvalidoException extends RuntimeException {

    public TokenRecuperacaoInvalidoException(String message) {
        super(message);
    }
}
