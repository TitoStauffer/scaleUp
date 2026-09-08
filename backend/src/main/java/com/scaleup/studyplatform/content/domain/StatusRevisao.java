package com.scaleup.studyplatform.content.domain;

/**
 * Status de revisão de um item de conteúdo (Domain, Concept, Slide, Flashcard, Question).
 * Espelha o CHECK constraint das migrações do DBA (V2 a V6): coluna varchar, nunca enum
 * nativo do Postgres — ver docs/architecture/database-schema.md, seção 7.
 */
public enum StatusRevisao {

    RASCUNHO("rascunho"),
    REVISADO_APROVADO("revisado_aprovado");

    private final String valor;

    StatusRevisao(String valor) {
        this.valor = valor;
    }

    public String getValor() {
        return valor;
    }

    public static StatusRevisao fromValor(String valor) {
        for (StatusRevisao status : values()) {
            if (status.valor.equals(valor)) {
                return status;
            }
        }
        throw new IllegalArgumentException("status_revisao desconhecido: " + valor);
    }
}
