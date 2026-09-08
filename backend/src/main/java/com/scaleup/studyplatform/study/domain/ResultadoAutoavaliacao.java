package com.scaleup.studyplatform.study.domain;

/**
 * Espelha o CHECK constraint de flashcard_review.resultado_autoavaliacao (V9): binário,
 * confirmado no ticket (seção 6.3) — 'lembrei' / 'nao_lembrei'.
 */
public enum ResultadoAutoavaliacao {

    LEMBREI("lembrei"),
    NAO_LEMBREI("nao_lembrei");

    private final String valor;

    ResultadoAutoavaliacao(String valor) {
        this.valor = valor;
    }

    public String getValor() {
        return valor;
    }

    public static ResultadoAutoavaliacao fromValor(String valor) {
        for (ResultadoAutoavaliacao resultado : values()) {
            if (resultado.valor.equals(valor)) {
                return resultado;
            }
        }
        throw new IllegalArgumentException(
                "resultado_autoavaliacao inválido: '" + valor + "' (esperado 'lembrei' ou 'nao_lembrei')");
    }
}
