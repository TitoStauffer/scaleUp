package com.scaleup.studyplatform.identity.application;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

/**
 * Implementação mock de {@link EmailSender}: loga o token de confirmação em vez de enviar
 * e-mail de verdade. Ativa por padrão (`email.provider=mock` ou propriedade ausente) enquanto
 * a credencial SMTP real não está disponível (ticket, seção 12, OPEN QUESTION-D).
 *
 * Permite desenvolver e validar todo o fluxo de cadastro/confirmação/reenvio sem depender de
 * infraestrutura de e-mail — o token fica visível no log da aplicação para uso manual em
 * testes e validação via API.
 */
@Component
@ConditionalOnProperty(prefix = "email", name = "provider", havingValue = "mock", matchIfMissing = true)
public class LogEmailSender implements EmailSender {

    private static final Logger log = LoggerFactory.getLogger(LogEmailSender.class);

    @Override
    public void enviarTokenConfirmacao(String destinatario, String token) {
        log.info("[MOCK EMAIL] Token de confirmação de cadastro para '{}': {}", destinatario, token);
    }

    @Override
    public void enviarTokenRecuperacaoSenha(String destinatario, String token) {
        log.info("[MOCK EMAIL] Token de recuperação de senha para '{}': {}", destinatario, token);
    }
}
