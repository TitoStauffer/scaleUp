package com.scaleup.studyplatform.identity.application;

/**
 * TICKET-perfil-usuario.md, AC-08: `Content-Type` do arquivo de foto fora de
 * image/jpeg, image/png, image/webp.
 */
public class TipoArquivoNaoSuportadoException extends RuntimeException {

    public TipoArquivoNaoSuportadoException(String message) {
        super(message);
    }
}
