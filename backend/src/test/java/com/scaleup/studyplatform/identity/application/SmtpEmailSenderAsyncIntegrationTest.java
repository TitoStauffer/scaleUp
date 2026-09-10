package com.scaleup.studyplatform.identity.application;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatCode;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicBoolean;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.test.context.TestPropertySource;

/**
 * Prova, com um contexto Spring real (proxy {@code @Async} ativo via {@link EmailAsyncConfig}),
 * que {@link SmtpEmailSender#enviarTokenConfirmacao} não bloqueia quem chama
 * (TICKET-envio-email-assincrono.md, AC-01/AC-02: a chamada de rede real ao SMTP acontece numa
 * thread separada do executor {@code emailTaskExecutor}, não na thread do chamador) e que uma
 * falha de envio simulada não propaga para o chamador (AC-03/AC-04).
 *
 * Usa um {@link JavaMailSender} de teste com latência artificial em vez do
 * {@code AuthModuleIntegrationTest} completo (que roda com {@code email.provider} ausente, logo
 * {@link SmtpEmailSender} nem fica ativo) — este teste ativa {@code email.provider=smtp}
 * isoladamente, sem subir Postgres/Testcontainers, focado só no comportamento assíncrono.
 */
@SpringBootTest(classes = { EmailAsyncConfig.class, SmtpEmailSender.class,
        SmtpEmailSenderAsyncIntegrationTest.TestMailConfig.class })
@TestPropertySource(properties = "email.provider=smtp")
class SmtpEmailSenderAsyncIntegrationTest {

    private static final long LATENCIA_ARTIFICIAL_MS = 1500;

    @Autowired
    private EmailSender emailSender;

    @Autowired
    private TestMailConfig.LatenteJavaMailSender mailSender;

    @Test
    void enviarTokenConfirmacaoNaoBloqueiaOChamadorEnquantoOEnvioAindaEstaEmAndamento() throws InterruptedException {
        mailSender.prepararEnvioComLatencia();

        long inicio = System.currentTimeMillis();
        emailSender.enviarTokenConfirmacao("destinatario@scaleup.dev", "123456");
        long duracaoDaChamada = System.currentTimeMillis() - inicio;

        // AC-01/AC-02: a chamada retorna quase imediatamente — bem antes da latência artificial
        // configurada no envio real, provando que ela não roda na thread do chamador.
        assertThat(duracaoDaChamada).isLessThan(LATENCIA_ARTIFICIAL_MS);

        // O envio de fato acontece, só que em outra thread, dentro do tempo esperado.
        boolean enviouATempo = mailSender.aguardarEnvio(LATENCIA_ARTIFICIAL_MS + 2000, TimeUnit.MILLISECONDS);
        assertThat(enviouATempo).isTrue();
        assertThat(mailSender.threadDoEnvio()).isNotEqualTo(Thread.currentThread().getName());
    }

    @Test
    void falhaNoEnvioNaoPropagaParaOChamador() {
        mailSender.prepararFalhaNoEnvio();

        // AC-03/AC-04: SmtpEmailSender já captura RuntimeException internamente e só loga —
        // nenhuma exceção deve escapar para quem chamou, síncrono ou assíncrono.
        assertThatCode(() -> emailSender.enviarTokenConfirmacao("destinatario@scaleup.dev", "123456"))
                .doesNotThrowAnyException();
    }

    @TestConfiguration
    static class TestMailConfig {

        @Bean
        @Primary
        JavaMailSender javaMailSender() {
            return new LatenteJavaMailSender();
        }

        /** Fake de {@link JavaMailSender} com latência/falha configuráveis por teste. */
        static class LatenteJavaMailSender extends JavaMailSenderImpl {

            private volatile long latenciaMs;
            private volatile boolean deveFalhar;
            private volatile String threadDoEnvio;
            private final CountDownLatch enviado = new CountDownLatch(1);
            private final AtomicBoolean configurado = new AtomicBoolean(false);

            void prepararEnvioComLatencia() {
                this.latenciaMs = LATENCIA_ARTIFICIAL_MS;
                configurado.set(true);
            }

            void prepararFalhaNoEnvio() {
                this.deveFalhar = true;
                configurado.set(true);
            }

            boolean aguardarEnvio(long tempo, TimeUnit unidade) throws InterruptedException {
                return enviado.await(tempo, unidade);
            }

            String threadDoEnvio() {
                return threadDoEnvio;
            }

            @Override
            public void send(SimpleMailMessage simpleMessage) throws MailException {
                threadDoEnvio = Thread.currentThread().getName();
                if (deveFalhar) {
                    enviado.countDown();
                    throw new org.springframework.mail.MailSendException("falha simulada de SMTP");
                }
                try {
                    Thread.sleep(latenciaMs);
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                } finally {
                    enviado.countDown();
                }
            }
        }
    }
}
