package com.scaleup.studyplatform.assessment.application.dto;

import java.util.UUID;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

/**
 * `alternativaSelecionadaId` é intencionalmente nullable (sem `@NotNull`): o frontend deve
 * enviar uma entrada para cada uma das `totalQuestoes` questões da tentativa, mesmo as que
 * ficaram sem resposta — é assim que a aplicação identifica exatamente qual questão está
 * pendente (AC-02), sem precisar de uma tabela nova para lembrar quais questões foram
 * originalmente sorteadas (o schema atual não tem essa tabela — ver seção de decisões no
 * handoff).
 */
public record RespostaSubmissaoRequest(
        @NotNull UUID questionId,
        UUID alternativaSelecionadaId,
        @Min(1) @Max(5) Short confiancaDeclarada) {
}
