package com.scaleup.studyplatform.shared;

/**
 * Exceção para operações rejeitadas por causa do estado atual do recurso (ex.: submeter uma
 * tentativa de quiz já concluída, iniciar um quiz-attempt numa sessão já encerrada).
 * Reaproveitável por qualquer módulo, mapeada para HTTP 409 em {@link GlobalExceptionHandler}.
 */
public class EstadoInvalidoException extends RuntimeException {

    public EstadoInvalidoException(String message) {
        super(message);
    }
}
