package com.scaleup.studyplatform.identity.application.dto;

/**
 * Resposta genérica de sucesso para cadastro/confirmação/reenvio — nunca revela se o e-mail
 * já existia ou o estado interno da conta além do estritamente necessário (anti-enumeração,
 * ticket seções 4 e 7).
 */
public record MensagemDto(String mensagem) {
}
