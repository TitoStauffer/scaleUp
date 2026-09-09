package com.scaleup.studyplatform.identity.application;

import java.time.Duration;
import java.time.Instant;
import java.util.ArrayDeque;
import java.util.Deque;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * Rate limiting simplificado (ticket, seção 8: "mecanismo técnico é do Backend... não precisa
 * ser Redis/produção-grade"). Janela deslizante em memória, por chave lógica (ex.
 * "login:usuario@exemplo.com").
 *
 * <b>Limitação conhecida, aceita deliberadamente:</b> estado em memória local da JVM — não
 * funciona corretamente com múltiplas instâncias do backend atrás de um load balancer (cada
 * instância tem seu próprio contador) e é perdido a cada restart. Suficiente para o MVP
 * (instância única). Se o backend escalar horizontalmente, isto precisa migrar para um
 * armazenamento compartilhado (ex. Redis) — registrado aqui como débito técnico conhecido,
 * não como omissão.
 */
@Component
public class RateLimiter {

    private final Map<String, Deque<Instant>> tentativasPorChave = new ConcurrentHashMap<>();
    private final int maximoTentativas;
    private final Duration janela;

    public RateLimiter(
            @Value("${auth.rate-limit.max-tentativas:10}") int maximoTentativas,
            @Value("${auth.rate-limit.janela-minutos:1}") long janelaMinutos) {
        this.maximoTentativas = maximoTentativas;
        this.janela = Duration.ofMinutes(janelaMinutos);
    }

    /** @throws RateLimitExcedidoException se a chave já excedeu o limite na janela atual. */
    public void registrarTentativa(String chave) {
        Deque<Instant> tentativas = tentativasPorChave.computeIfAbsent(chave, k -> new ArrayDeque<>());
        Instant agora = Instant.now();
        synchronized (tentativas) {
            Instant limiteInferior = agora.minus(janela);
            while (!tentativas.isEmpty() && tentativas.peekFirst().isBefore(limiteInferior)) {
                tentativas.pollFirst();
            }
            if (tentativas.size() >= maximoTentativas) {
                throw new RateLimitExcedidoException(
                        "muitas tentativas em pouco tempo, aguarde antes de tentar novamente");
            }
            tentativas.addLast(agora);
        }
    }
}
