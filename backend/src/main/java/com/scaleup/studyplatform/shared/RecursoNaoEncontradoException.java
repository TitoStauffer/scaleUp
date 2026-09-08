package com.scaleup.studyplatform.shared;

/**
 * Exceção genérica para "recurso não encontrado", reaproveitável por qualquer módulo
 * (Content agora; Study/Assessment/Progress/Identity quando forem implementados).
 */
public class RecursoNaoEncontradoException extends RuntimeException {

    public RecursoNaoEncontradoException(String message) {
        super(message);
    }
}
