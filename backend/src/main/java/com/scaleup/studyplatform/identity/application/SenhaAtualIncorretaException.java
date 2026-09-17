package com.scaleup.studyplatform.identity.application;

/**
 * TICKET-alterar-senha.md, AC-02: a senha atual informada não bate com o hash armazenado.
 * Diferente das exceções de anti-enumeração, esta é específica e visível — o requisitante já
 * está autenticado por JWT válido, já provou ser dono da conta (seção 5.2 do ticket).
 */
public class SenhaAtualIncorretaException extends RuntimeException {

    public SenhaAtualIncorretaException(String message) {
        super(message);
    }
}
