package com.scaleup.studyplatform.identity.domain;

/**
 * Espelha o CHECK constraint de app_user.status_conta (V33): apenas os dois valores que o
 * ticket de autenticação precisa agora — "conta desativada" foi marcado como fora de escopo
 * (ver comentário da própria migração).
 */
public enum StatusConta {

    PENDENTE("pendente"),
    ATIVO("ativo");

    private final String valor;

    StatusConta(String valor) {
        this.valor = valor;
    }

    public String getValor() {
        return valor;
    }

    public static StatusConta fromValor(String valor) {
        for (StatusConta status : values()) {
            if (status.valor.equals(valor)) {
                return status;
            }
        }
        throw new IllegalArgumentException("status de conta desconhecido: " + valor);
    }
}
