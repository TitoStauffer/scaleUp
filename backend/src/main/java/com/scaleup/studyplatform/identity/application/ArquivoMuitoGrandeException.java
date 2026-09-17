package com.scaleup.studyplatform.identity.application;

/** TICKET-perfil-usuario.md, AC-07: arquivo de foto acima do limite de 2MB. */
public class ArquivoMuitoGrandeException extends RuntimeException {

    public ArquivoMuitoGrandeException(String message) {
        super(message);
    }
}
