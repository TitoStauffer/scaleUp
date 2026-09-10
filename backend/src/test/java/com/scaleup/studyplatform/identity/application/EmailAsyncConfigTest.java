package com.scaleup.studyplatform.identity.application;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatCode;

import java.lang.reflect.Method;
import java.util.concurrent.Executor;

import org.junit.jupiter.api.Test;
import org.springframework.aop.interceptor.AsyncUncaughtExceptionHandler;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

/**
 * Testa {@link EmailAsyncConfig} isoladamente (sem contexto Spring), cobrindo:
 *
 * <p>AC-05 (TICKET-envio-email-assincrono.md) — o executor de e-mail é um
 * {@link ThreadPoolTaskExecutor} configurado explicitamente (não o {@code SimpleAsyncTaskExecutor}
 * default do Spring), com {@code corePoolSize}, {@code maxPoolSize} e {@code queueCapacity}
 * definidos.
 *
 * <p>AC-04 — o {@link AsyncUncaughtExceptionHandler} registrado apenas loga uma exceção não
 * tratada, sem propagá-la. Testado como unidade porque, na prática, o {@code try/catch} interno
 * de {@link SmtpEmailSender} já captura qualquer falha de envio antes que ela chegue a este
 * handler (ticket, seção 4.3) — este handler é a rede de segurança para o caso de uma exceção
 * escapar mesmo assim (ex.: um {@code Error}, ou uma futura mudança que remova o try/catch).
 */
class EmailAsyncConfigTest {

    private final EmailAsyncConfig config = new EmailAsyncConfig();

    @Test
    void emailTaskExecutorEhThreadPoolTaskExecutorComLimitesExplicitos() {
        Executor executor = config.emailTaskExecutor();

        assertThat(executor).isInstanceOf(ThreadPoolTaskExecutor.class);
        ThreadPoolTaskExecutor pool = (ThreadPoolTaskExecutor) executor;
        assertThat(pool.getCorePoolSize()).isEqualTo(2);
        assertThat(pool.getMaxPoolSize()).isEqualTo(5);
        // queueCapacity não tem getter direto no ThreadPoolTaskExecutor — inspeciona a
        // capacidade restante da fila subjacente logo após a inicialização (ainda vazia).
        assertThat(pool.getThreadPoolExecutor().getQueue().remainingCapacity()).isEqualTo(50);
    }

    @Test
    void asyncUncaughtExceptionHandlerApenasLogaSemPropagarExcecao() throws NoSuchMethodException {
        AsyncUncaughtExceptionHandler handler = config.getAsyncUncaughtExceptionHandler();
        assertThat(handler).isNotNull();

        Method metodoQualquer = SmtpEmailSender.class.getDeclaredMethod("enviarTokenConfirmacao", String.class,
                String.class);

        // AC-04: exceção não tratada dentro de um método @Async chega até aqui — o handler
        // deve engolir e logar, nunca propagar (o que derrubaria a thread do pool / apareceria
        // como erro fatal da aplicação).
        assertThatCode(() -> handler.handleUncaughtException(new RuntimeException("falha simulada de SMTP"),
                metodoQualquer, "destinatario@scaleup.dev", "123456")).doesNotThrowAnyException();
    }
}
