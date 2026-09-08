package com.scaleup.studyplatform.content.domain;

/**
 * Dificuldade editorial de Flashcard/Question. Espelha o CHECK constraint das migrações
 * V5/V6 (varchar, não enum nativo do Postgres).
 */
public enum Dificuldade {

    FACIL("facil"),
    MEDIA("media"),
    DIFICIL("dificil");

    private final String valor;

    Dificuldade(String valor) {
        this.valor = valor;
    }

    public String getValor() {
        return valor;
    }

    public static Dificuldade fromValor(String valor) {
        for (Dificuldade dificuldade : values()) {
            if (dificuldade.valor.equals(valor)) {
                return dificuldade;
            }
        }
        throw new IllegalArgumentException("dificuldade desconhecida: " + valor);
    }
}
