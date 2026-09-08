package com.scaleup.studyplatform.progress.application;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import java.util.Map;

import com.scaleup.studyplatform.progress.domain.NivelReferencia;

/**
 * Fórmulas dos 5 componentes de pontuação, da agregação em `pontuacao_geral` e da conversão
 * pontuação → nível — TICKET-assessment-progress.md, seções 5.1 a 5.3. Classe sem estado e
 * sem dependência de Spring/JPA de propósito: as fórmulas em si são lógica pura,
 * testável isoladamente de qualquer banco (ver ProgressFormulasTest).
 *
 * Busca de evidências (quais tentativas/revisões considerar) é responsabilidade de
 * {@link RecalcularDomainProgressService}; esta classe só recebe listas já filtradas e
 * calcula.
 */
public final class ProgressFormulas {

    private ProgressFormulas() {
    }

    /** Componente Quiz (seção 5.3): média das últimas até 3 QuizAttempt concluídas. */
    public static BigDecimal calcularPontuacaoQuiz(List<BigDecimal> ultimasPontuacoes) {
        if (ultimasPontuacoes.isEmpty()) {
            return null;
        }
        BigDecimal soma = ultimasPontuacoes.stream().reduce(BigDecimal.ZERO, BigDecimal::add);
        return soma.divide(BigDecimal.valueOf(ultimasPontuacoes.size()), 2, RoundingMode.HALF_UP);
    }

    /** Componente Flashcards (seção 5.3): % de 'lembrei' nas últimas até 30 revisões. */
    public static BigDecimal calcularPontuacaoFlashcards(List<Boolean> ultimosLembrei) {
        if (ultimosLembrei.isEmpty()) {
            return null;
        }
        long lembrou = ultimosLembrei.stream().filter(Boolean::booleanValue).count();
        return percentual(lembrou, ultimosLembrei.size());
    }

    /** Componente Questões novas (seção 5.3): % de acerto nas últimas até 20 respostas novas. */
    public static BigDecimal calcularPontuacaoQuestoesNovas(List<Boolean> acertosRespostasNovas) {
        if (acertosRespostasNovas.isEmpty()) {
            return null;
        }
        long acertos = acertosRespostasNovas.stream().filter(Boolean::booleanValue).count();
        return percentual(acertos, acertosRespostasNovas.size());
    }

    /**
     * Componente Consistência (seção 5.2). O chamador decide se há volume mínimo (≥2 dias
     * distintos E ≥3 eventos de evidência nos últimos 30 dias) antes de invocar este método —
     * abaixo disso o componente é NULL e este método nem deve ser chamado.
     *
     * @param diasDistintosComAtividade dias distintos (últimos 30 dias corridos) com pelo menos
     *                                   1 QuizAttempt concluída ou FlashcardReview no domínio.
     * @param ultimasPontuacoesQuiz     até 5 últimas pontuações de QuizAttempt concluídas no
     *                                   domínio, para o sub-indicador de estabilidade.
     */
    public static BigDecimal calcularPontuacaoConsistencia(int diasDistintosComAtividade,
            List<BigDecimal> ultimasPontuacoesQuiz) {
        double regularidade = Math.min(100.0, (diasDistintosComAtividade / 8.0) * 100.0);
        double desvioPadrao = desvioPadraoAmostral(ultimasPontuacoesQuiz);
        double estabilidade = Math.max(0.0, 100.0 - desvioPadrao * 2.0);
        double consistencia = 0.6 * regularidade + 0.4 * estabilidade;
        return arredondar(consistencia);
    }

    /**
     * Componente Calibração de autoconfiança (seção 5.2). O chamador decide se há volume
     * mínimo (≥5 declarações de confiança não nulas) antes de invocar este método.
     */
    public static BigDecimal calcularPontuacaoCalibracao(List<ConfiancaResultado> declaracoes) {
        double somaQuadrados = declaracoes.stream()
                .mapToDouble(d -> Math.pow(d.probabilidade() - (d.resultado() ? 1.0 : 0.0), 2))
                .sum();
        double brier = somaQuadrados / declaracoes.size();
        return arredondar((1 - brier) * 100.0);
    }

    /** `confianca_declarada` (1–5) → probabilidade estimada [0,1] (seção 5.2). */
    public static double mapConfiancaParaProbabilidade(short confiancaDeclarada) {
        return (confiancaDeclarada - 1) / 4.0;
    }

    /**
     * Agregação em `pontuacao_geral` (seção 5.3): média ponderada dos componentes não nulos,
     * com os pesos dos componentes ausentes redistribuídos proporcionalmente (AC-08) — nunca
     * trata um componente ausente como zero.
     *
     * @param componentes valores calculados (ou `null`) de cada componente.
     * @param pesos       peso de cada componente por nome (`componente_peso.componente`).
     * @return `null` se nenhum componente tiver valor (não deveria ocorrer uma vez que o
     *         volume mínimo — que exige quiz concluído — foi atingido).
     */
    public static BigDecimal agregarPontuacaoGeral(List<ComponenteValor> componentes, Map<String, BigDecimal> pesos) {
        BigDecimal somaPonderada = BigDecimal.ZERO;
        BigDecimal somaPesos = BigDecimal.ZERO;
        for (ComponenteValor componente : componentes) {
            if (componente.valor() == null) {
                continue;
            }
            BigDecimal peso = pesos.get(componente.nomeComponente());
            if (peso == null) {
                throw new IllegalStateException("Peso não configurado para componente: " + componente.nomeComponente());
            }
            somaPonderada = somaPonderada.add(peso.multiply(componente.valor()));
            somaPesos = somaPesos.add(peso);
        }
        if (somaPesos.compareTo(BigDecimal.ZERO) == 0) {
            return null;
        }
        return somaPonderada.divide(somaPesos, 2, RoundingMode.HALF_UP);
    }

    /**
     * Conversão pontuação → nível (seção 5.1): faixas `[mínima, máxima)`, exceto a última
     * (maior `ordem`), fechada nos dois extremos para incluir 100.00 (AC-07: fronteira
     * pertence ao nível superior).
     */
    public static NivelReferencia determinarNivel(BigDecimal pontuacaoGeral, List<NivelReferencia> niveisPorOrdemAsc) {
        NivelReferencia ultimo = niveisPorOrdemAsc.get(niveisPorOrdemAsc.size() - 1);
        for (NivelReferencia nivel : niveisPorOrdemAsc) {
            boolean atingeMinima = pontuacaoGeral.compareTo(nivel.getPontuacaoMinima()) >= 0;
            boolean abaixoDaMaxima = pontuacaoGeral.compareTo(nivel.getPontuacaoMaxima()) < 0;
            boolean noTetoDoUltimoNivel = nivel == ultimo && pontuacaoGeral.compareTo(nivel.getPontuacaoMaxima()) == 0;
            if (atingeMinima && (abaixoDaMaxima || noTetoDoUltimoNivel)) {
                return nivel;
            }
        }
        throw new IllegalStateException("Nenhum nível cobre a pontuação " + pontuacaoGeral
                + " — thresholds de nivel_referencia incompletos?");
    }

    private static BigDecimal percentual(long parte, long total) {
        return arredondar((parte * 100.0) / total);
    }

    private static BigDecimal arredondar(double valor) {
        return BigDecimal.valueOf(valor).setScale(2, RoundingMode.HALF_UP);
    }

    private static double desvioPadraoAmostral(List<BigDecimal> valores) {
        if (valores.size() < 2) {
            // Sem pelo menos 2 observações a variância amostral não é definida; tratar como
            // "nenhuma variabilidade observada" é o valor neutro razoável (não penaliza nem
            // beneficia estabilidade por falta de dado).
            return 0.0;
        }
        double media = valores.stream().mapToDouble(BigDecimal::doubleValue).average().orElseThrow();
        double somaDosQuadrados = valores.stream()
                .mapToDouble(v -> Math.pow(v.doubleValue() - media, 2))
                .sum();
        return Math.sqrt(somaDosQuadrados / (valores.size() - 1));
    }
}
