package com.scaleup.studyplatform.identity.application;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

/**
 * Implementação real via SMTP (Spring Mail), pronta para ativar assim que a credencial do
 * Google Workspace (senha de app) for provisionada (ticket, seção 12, OPEN QUESTION-D — owner:
 * Tito). Ativa via `email.provider=smtp`, configurando `spring.mail.*` (host, porta, usuário,
 * senha de app) — nenhuma mudança de código é necessária nos services de negócio, que
 * dependem apenas de {@link EmailSender}.
 *
 * Não testada com credencial real ainda (não há credencial disponível) — validada só por
 * compilação/injeção de dependências.
 *
 * {@code @Async("emailTaskExecutor")} (TICKET-envio-email-assincrono.md, seção 7, Open
 * Question-E, Opção A escolhida pelo Tito): a chamada de rede síncrona ao SMTP não deve
 * bloquear a resposta HTTP de {@code POST /api/auth/cadastro} / {@code /reenviar-token}. Como
 * {@link EmailSender} é injetado como bean separado nos services chamadores (não é
 * self-invocation), o proxy {@code @Async} funciona normalmente mesmo sendo chamado de dentro
 * de um método {@code @Transactional}.
 */
@Component
@ConditionalOnProperty(prefix = "email", name = "provider", havingValue = "smtp")
public class SmtpEmailSender implements EmailSender {

    private static final Logger log = LoggerFactory.getLogger(SmtpEmailSender.class);

    private final JavaMailSender mailSender;
    private final String remetente;

    public SmtpEmailSender(JavaMailSender mailSender, @Value("${email.remetente:no-reply@scaleup.dev}") String remetente) {
        this.mailSender = mailSender;
        this.remetente = remetente;
    }

    @Override
    @Async("emailTaskExecutor")
    public void enviarTokenConfirmacao(String destinatario, String token) {
        SimpleMailMessage mensagem = new SimpleMailMessage();
        mensagem.setFrom(remetente);
        mensagem.setTo(destinatario);
        mensagem.setSubject("ScaleUp - confirme seu cadastro");
        mensagem.setText("Seu código de confirmação é: " + token
                + "\n\nEle expira em 20 minutos. Se você não solicitou este cadastro, ignore este e-mail.");
        try {
            mailSender.send(mensagem);
        } catch (RuntimeException e) {
            // Falha de envio de e-mail não pode quebrar a transação de cadastro/reenvio já
            // persistida — loga e deixa o fluxo seguir (o usuário pode pedir reenvio depois).
            log.error("Falha ao enviar e-mail de confirmação para '{}'", destinatario, e);
        }
    }

    @Override
    @Async("emailTaskExecutor")
    public void enviarTokenRecuperacaoSenha(String destinatario, String token) {
        SimpleMailMessage mensagem = new SimpleMailMessage();
        mensagem.setFrom(remetente);
        mensagem.setTo(destinatario);
        mensagem.setSubject("ScaleUp - recuperação de senha");
        mensagem.setText("Recebemos uma solicitação de recuperação de senha para esta conta.\n\n"
                + "Token de recuperação: " + token
                + "\n\nEle expira em 45 minutos. Se você não solicitou esta recuperação, ignore este e-mail.");
        try {
            mailSender.send(mensagem);
        } catch (RuntimeException e) {
            log.error("Falha ao enviar e-mail de recuperação de senha para '{}'", destinatario, e);
        }
    }
}
