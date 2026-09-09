package com.scaleup.studyplatform.identity.application;

/**
 * AC-05: token correto, mas expirado — erro específico e distinto de "token inválido",
 * porque a ação certa do usuário é diferente (pedir reenvio, não tentar de novo).
 */
public class TokenExpiradoException extends RuntimeException {

    public TokenExpiradoException(String message) {
        super(message);
    }
}
