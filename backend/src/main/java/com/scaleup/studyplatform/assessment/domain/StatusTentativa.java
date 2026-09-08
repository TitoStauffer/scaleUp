package com.scaleup.studyplatform.assessment.domain;

/**
 * Espelha o CHECK constraint de quiz_attempt.status (V10) — mesmos 3 valores de
 * study_session.status, mas modelado separadamente porque pertence a uma entidade diferente
 * (Assessment, não Study).
 */
public enum StatusTentativa {

    EM_ANDAMENTO("em_andamento"),
    CONCLUIDA("concluida"),
    ABANDONADA("abandonada");

    private final String valor;

    StatusTentativa(String valor) {
        this.valor = valor;
    }

    public String getValor() {
        return valor;
    }

    public static StatusTentativa fromValor(String valor) {
        for (StatusTentativa status : values()) {
            if (status.valor.equals(valor)) {
                return status;
            }
        }
        throw new IllegalArgumentException("status de tentativa desconhecido: " + valor);
    }
}
