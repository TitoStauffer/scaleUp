package com.scaleup.studyplatform.progress.application;

/**
 * Um par (probabilidade estimada, resultado real) usado pelo componente de calibração de
 * autoconfiança (TICKET-assessment-progress.md, seção 5.2). `probabilidade` já é o
 * mapeamento de `confianca_declarada` (1–5) para [0,1] — ver
 * {@link ProgressFormulas#mapConfiancaParaProbabilidade(short)}. `resultado` é `true` em
 * caso de acerto (`Answer.correta`) ou `resultado_autoavaliacao = 'lembrei'`.
 */
public record ConfiancaResultado(double probabilidade, boolean resultado) {
}
