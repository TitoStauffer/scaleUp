package com.scaleup.studyplatform.identity.application;

/**
 * TICKET-cadastro-email-duplicado-visivel.md, AC-02: cadastro com e-mail já existente e com
 * conta ativa — erro específico orientando o usuário a fazer login, em vez da mensagem
 * genérica anterior (revoga o anti-enumeração de cadastro do AC-01 original do ticket mestre,
 * ver seção 6 do ticket novo para o trade-off formalizado).
 */
public class EmailJaCadastradoAtivoException extends RuntimeException {

    public EmailJaCadastradoAtivoException(String message) {
        super(message);
    }
}
