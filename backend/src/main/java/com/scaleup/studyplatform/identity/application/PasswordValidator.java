package com.scaleup.studyplatform.identity.application;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import org.springframework.stereotype.Component;

/**
 * Regra de senha decidida pelo Tito (ticket, seção 4): mínimo 8 caracteres, com pelo menos 1
 * maiúscula, 1 minúscula, 1 número e 1 símbolo. AC-02 exige mensagem clara indicando qual
 * regra faltou — por isso a validação lista todos os requisitos não atendidos, em vez de
 * parar no primeiro.
 */
@Component
public class PasswordValidator {

    private static final int TAMANHO_MINIMO = 8;
    private static final Pattern MAIUSCULA = Pattern.compile("[A-Z]");
    private static final Pattern MINUSCULA = Pattern.compile("[a-z]");
    private static final Pattern NUMERO = Pattern.compile("[0-9]");
    private static final Pattern SIMBOLO = Pattern.compile("[^A-Za-z0-9]");

    public void validar(String senha) {
        String valor = senha == null ? "" : senha;
        List<String> requisitosNaoAtendidos = new ArrayList<>();

        if (valor.length() < TAMANHO_MINIMO) {
            requisitosNaoAtendidos.add("mínimo de " + TAMANHO_MINIMO + " caracteres");
        }
        if (!MAIUSCULA.matcher(valor).find()) {
            requisitosNaoAtendidos.add("pelo menos 1 letra maiúscula");
        }
        if (!MINUSCULA.matcher(valor).find()) {
            requisitosNaoAtendidos.add("pelo menos 1 letra minúscula");
        }
        if (!NUMERO.matcher(valor).find()) {
            requisitosNaoAtendidos.add("pelo menos 1 número");
        }
        if (!SIMBOLO.matcher(valor).find()) {
            requisitosNaoAtendidos.add("pelo menos 1 símbolo");
        }

        if (!requisitosNaoAtendidos.isEmpty()) {
            throw new IllegalArgumentException(
                    "senha não atende aos requisitos: " + String.join(", ", requisitosNaoAtendidos));
        }
    }
}
