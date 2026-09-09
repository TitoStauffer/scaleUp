package com.scaleup.studyplatform.identity.application;

/**
 * AC-07: credenciais corretas, mas conta ainda pendente de confirmação — erro específico e
 * distinto do genérico de credenciais inválidas (ticket seção 7: aqui já se provou ser o
 * dono da conta, então a distinção não fere o princípio anti-enumeração).
 */
public class ContaNaoConfirmadaException extends RuntimeException {

    public ContaNaoConfirmadaException(String message) {
        super(message);
    }
}
