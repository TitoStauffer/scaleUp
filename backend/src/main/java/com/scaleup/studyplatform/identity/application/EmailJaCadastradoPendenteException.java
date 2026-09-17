package com.scaleup.studyplatform.identity.application;

/**
 * TICKET-cadastro-email-duplicado-visivel.md, AC-03: cadastro com e-mail já existente e ainda
 * pendente de confirmação — erro específico orientando a confirmar o cadastro ou solicitar
 * reenvio via POST /api/auth/reenviar-token. Diferente do comportamento anterior, o cadastro
 * não reenvia token automaticamente como efeito colateral (ver seção 4 do ticket).
 */
public class EmailJaCadastradoPendenteException extends RuntimeException {

    public EmailJaCadastradoPendenteException(String message) {
        super(message);
    }
}
