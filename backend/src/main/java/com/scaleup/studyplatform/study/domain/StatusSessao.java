package com.scaleup.studyplatform.study.domain;

/**
 * Espelha o CHECK constraint de study_session.status (V9) — varchar, não enum nativo do
 * Postgres (mesma convenção de StatusRevisao no módulo Content).
 */
public enum StatusSessao {

    EM_ANDAMENTO("em_andamento"),
    CONCLUIDA("concluida"),
    ABANDONADA("abandonada");

    private final String valor;

    StatusSessao(String valor) {
        this.valor = valor;
    }

    public String getValor() {
        return valor;
    }

    public static StatusSessao fromValor(String valor) {
        for (StatusSessao status : values()) {
            if (status.valor.equals(valor)) {
                return status;
            }
        }
        throw new IllegalArgumentException("status de sessão desconhecido: " + valor);
    }
}
