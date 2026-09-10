package com.scaleup.studyplatform.identity.application;

import java.lang.reflect.Method;
import java.util.concurrent.Executor;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.aop.interceptor.AsyncUncaughtExceptionHandler;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.AsyncConfigurer;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

/**
 * Habilita {@code @Async} do Spring para o envio de e-mail de confirmação de cadastro/reenvio
 * de token (TICKET-envio-email-assincrono.md), com um {@link ThreadPoolTaskExecutor} dedicado e
 * limitado — nunca o {@code SimpleAsyncTaskExecutor} default do Spring, que cria uma thread nova
 * por chamada sem nenhum limite (ticket, seção 4.2).
 *
 * Decisão do Tito (ticket, seção 7, Open Question-E, Opção A): {@code @Async} é aplicado
 * diretamente em {@link SmtpEmailSender#enviarTokenConfirmacao}, não num listener de evento
 * pós-commit. {@link LogEmailSender} permanece síncrono (ticket, seção 4.4).
 *
 * Implementa {@link AsyncConfigurer} apenas para registrar um {@link AsyncUncaughtExceptionHandler}
 * como rede de segurança (AC-04): mesmo que o {@code try/catch} interno de
 * {@link SmtpEmailSender} já capture e logue falhas de envio hoje, qualquer exceção não
 * tratada que escape de um método {@code @Async} não deve derrubar a aplicação nem deixar a
 * thread do pool em estado inconsistente — só deve ser logada.
 */
@Configuration
@EnableAsync
public class EmailAsyncConfig implements AsyncConfigurer {

    private static final Logger log = LoggerFactory.getLogger(EmailAsyncConfig.class);

    @Bean(name = "emailTaskExecutor")
    public Executor emailTaskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        // Volume de e-mail é baixo (cadastro/reenvio) — limites pequenos e explícitos, só
        // para eliminar o bloqueio de UX sem abrir um novo vetor de esgotamento de threads
        // (ticket, seção 4.2).
        executor.setCorePoolSize(2);
        executor.setMaxPoolSize(5);
        executor.setQueueCapacity(50);
        executor.setThreadNamePrefix("email-async-");
        executor.initialize();
        return executor;
    }

    @Override
    public AsyncUncaughtExceptionHandler getAsyncUncaughtExceptionHandler() {
        return this::logarExcecaoNaoTratada;
    }

    private void logarExcecaoNaoTratada(Throwable excecao, Method metodo, Object... parametros) {
        // Rede de segurança (AC-04): apenas loga. Não deve propagar nem derrubar a aplicação.
        log.error("Exceção não tratada em método assíncrono '{}' (parâmetros: {})", metodo.getName(), parametros,
                excecao);
    }
}
