package com.scaleup.studyplatform.identity.application;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import org.junit.jupiter.api.Test;

/**
 * Testes unitários da regra de senha (TICKET-autenticacao.md, seção 4) — sem Spring, sem
 * banco. Os cenários de ponta a ponta (via API) ficam em AuthModuleIntegrationTest.
 */
class PasswordValidatorTest {

    private final PasswordValidator validator = new PasswordValidator();

    @Test
    void aceitaSenhaComTodosOsRequisitos() {
        assertThat(catchMessage("Abcdef1!")).isNull();
    }

    @Test
    void rejeitaSenhaCurta() {
        assertThatThrownBy(() -> validator.validar("Ab1!"))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("mínimo de 8 caracteres");
    }

    @Test
    void rejeitaSenhaSemMaiuscula() {
        assertThatThrownBy(() -> validator.validar("abcdefg1!"))
                .hasMessageContaining("maiúscula");
    }

    @Test
    void rejeitaSenhaSemMinuscula() {
        assertThatThrownBy(() -> validator.validar("ABCDEFG1!"))
                .hasMessageContaining("minúscula");
    }

    @Test
    void rejeitaSenhaSemNumero() {
        assertThatThrownBy(() -> validator.validar("Abcdefgh!"))
                .hasMessageContaining("número");
    }

    @Test
    void rejeitaSenhaSemSimbolo() {
        assertThatThrownBy(() -> validator.validar("Abcdefg1"))
                .hasMessageContaining("símbolo");
    }

    // AC-02: exemplos literais do ticket.
    @Test
    void rejeitaExemploDoTicketSemMaiusculaNumeroOuSimbolo() {
        assertThatThrownBy(() -> validator.validar("abcdefgh"))
                .hasMessageContaining("maiúscula")
                .hasMessageContaining("número")
                .hasMessageContaining("símbolo");
    }

    @Test
    void rejeitaExemploDoTicketSemSimbolo() {
        assertThatThrownBy(() -> validator.validar("Abc12345"))
                .hasMessageContaining("símbolo");
    }

    private String catchMessage(String senha) {
        try {
            validator.validar(senha);
            return null;
        } catch (IllegalArgumentException e) {
            return e.getMessage();
        }
    }
}
