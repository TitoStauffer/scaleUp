package com.scaleup.studyplatform.progress.application;

import java.math.BigDecimal;

/**
 * Um componente de pontuação e seu valor calculado (ou `null`, se abaixo do volume mínimo
 * exigido para aquele componente — ver seções 5.2/5.3 do ticket). O nome deve bater com
 * `componente_peso.componente` para a agregação encontrar o peso correto.
 */
public record ComponenteValor(String nomeComponente, BigDecimal valor) {
}
