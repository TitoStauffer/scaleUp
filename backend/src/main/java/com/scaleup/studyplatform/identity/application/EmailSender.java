package com.scaleup.studyplatform.identity.application;

/**
 * Abstração de envio de e-mail (ticket, seção 12, OPEN QUESTION-D). A credencial SMTP real
 * (Gmail/Google Workspace) ainda não está provisionada — {@link LogEmailSender} é a
 * implementação ativa por padrão (loga o token em vez de enviar de verdade), trocável por
 * {@link SmtpEmailSender} só via configuração (`email.provider=smtp` + `spring.mail.*`),
 * sem qualquer mudança nos services de cadastro/confirmação/reenvio, que dependem só desta
 * interface.
 */
public interface EmailSender {

    void enviarTokenConfirmacao(String destinatario, String token);
}
