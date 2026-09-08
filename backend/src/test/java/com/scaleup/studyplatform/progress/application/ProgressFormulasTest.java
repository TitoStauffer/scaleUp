package com.scaleup.studyplatform.progress.application;

import static org.assertj.core.api.Assertions.assertThat;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import org.junit.jupiter.api.Test;

import com.scaleup.studyplatform.progress.domain.NivelReferencia;

/**
 * Testes unitários das fórmulas puras (seções 5.1 a 5.3 do ticket) — sem Spring, sem banco.
 * Os cenários de integração ponta a ponta (submissão real via API) ficam em
 * AssessmentProgressModuleIntegrationTest.
 */
class ProgressFormulasTest {

    // Espelha exatamente os thresholds aplicados por V23 (seção 5.1 do ticket).
    private static final List<NivelReferencia> NIVEIS = List.of(
            new NivelReferencia("junior-1", "Júnior 1", (short) 1, bd(0), bd(15)),
            new NivelReferencia("junior-2", "Júnior 2", (short) 2, bd(15), bd(25)),
            new NivelReferencia("junior-3", "Júnior 3", (short) 3, bd(25), bd(35)),
            new NivelReferencia("pleno-1", "Pleno 1", (short) 4, bd(35), bd(45)),
            new NivelReferencia("pleno-2", "Pleno 2", (short) 5, bd(45), bd(55)),
            new NivelReferencia("pleno-3", "Pleno 3", (short) 6, bd(55), bd(65)),
            new NivelReferencia("senior-1", "Sênior 1", (short) 7, bd(65), bd(73)),
            new NivelReferencia("senior-2", "Sênior 2", (short) 8, bd(73), bd(81)),
            new NivelReferencia("senior-3", "Sênior 3", (short) 9, bd(81), bd(89)),
            new NivelReferencia("especialista-1", "Especialista 1", (short) 10, bd(89), bd(94)),
            new NivelReferencia("especialista-2", "Especialista 2", (short) 11, bd(94), bd(97)),
            new NivelReferencia("especialista-3", "Especialista 3", (short) 12, bd(97), bd(100)));

    private static final Map<String, BigDecimal> PESOS = Map.of(
            "quiz", bd2("0.40"),
            "flashcards", bd2("0.25"),
            "questoes_novas", bd2("0.20"),
            "consistencia", bd2("0.10"),
            "calibracao_confianca", bd2("0.05"));

    @Test
    void ac07_fronteiraExataPertenceAoNivelSuperior() {
        NivelReferencia nivel = ProgressFormulas.determinarNivel(bd2("65.00"), NIVEIS);

        assertThat(nivel.getSlug()).isEqualTo("senior-1");
    }

    @Test
    void ac07_pontuacaoLogoAbaixoDaFronteiraFicaNoNivelInferior() {
        NivelReferencia nivel = ProgressFormulas.determinarNivel(bd2("64.99"), NIVEIS);

        assertThat(nivel.getSlug()).isEqualTo("pleno-3");
    }

    @Test
    void ac07_topoDaUltimaFaixaEhFechadoNosDoisExtremos() {
        NivelReferencia nivel = ProgressFormulas.determinarNivel(bd2("100.00"), NIVEIS);

        assertThat(nivel.getSlug()).isEqualTo("especialista-3");
    }

    @Test
    void ac08_componenteAusenteTemPesoRedistribuidoEntreOsDemais() {
        // calibração ausente (usuário nunca declarou confiança) — não deve travar nem contar
        // como zero.
        List<ComponenteValor> componentes = List.of(
                new ComponenteValor("quiz", bd2("80.00")),
                new ComponenteValor("flashcards", bd2("80.00")),
                new ComponenteValor("questoes_novas", bd2("80.00")),
                new ComponenteValor("consistencia", bd2("80.00")),
                new ComponenteValor("calibracao_confianca", null));

        BigDecimal geral = ProgressFormulas.agregarPontuacaoGeral(componentes, PESOS);

        // Todos os componentes presentes valem 80 — com a redistribuição de peso, o resultado
        // continua 80.00 (a soma dos pesos restantes, renormalizada, ainda soma 1). Se o
        // componente ausente fosse tratado como zero, o resultado cairia para 76.00
        // (0.95 * 80 + 0.05 * 0), o que este teste também rejeitaria.
        assertThat(geral).isEqualByComparingTo("80.00");
    }

    @Test
    void ac08_agregacaoNuncaFalhaComComponenteNulo() {
        List<ComponenteValor> componentes = List.of(
                new ComponenteValor("quiz", bd2("50.00")),
                new ComponenteValor("flashcards", null),
                new ComponenteValor("questoes_novas", null),
                new ComponenteValor("consistencia", null),
                new ComponenteValor("calibracao_confianca", null));

        BigDecimal geral = ProgressFormulas.agregarPontuacaoGeral(componentes, PESOS);

        assertThat(geral).isEqualByComparingTo("50.00");
    }

    @Test
    void ac06_umaTentativaAtipicaEDiluidaPelaMediaDasUltimas3NaoTrocaDeNivel() {
        // Domínio sustentado em Pleno 2 (~52 pontos) por 3 tentativas de quiz consistentes,
        // com os demais componentes também em ~52.
        BigDecimal pontuacaoQuizAntes = ProgressFormulas.calcularPontuacaoQuiz(List.of(bd2("52"), bd2("52"), bd2("52")));
        assertThat(pontuacaoQuizAntes).isEqualByComparingTo("52.00");

        List<ComponenteValor> componentesAntes = List.of(
                new ComponenteValor("quiz", pontuacaoQuizAntes),
                new ComponenteValor("flashcards", bd2("52")),
                new ComponenteValor("questoes_novas", bd2("52")),
                new ComponenteValor("consistencia", bd2("52")),
                new ComponenteValor("calibracao_confianca", bd2("52")));
        BigDecimal geralAntes = ProgressFormulas.agregarPontuacaoGeral(componentesAntes, PESOS);
        assertThat(geralAntes).isEqualByComparingTo("52.00");
        assertThat(ProgressFormulas.determinarNivel(geralAntes, NIVEIS).getSlug()).isEqualTo("pleno-2");

        // Uma nova tentativa muito abaixo do padrão (10 pontos, por distração) entra na janela
        // das "últimas 3" — a mais antiga (52) sai, a nova (10) entra: [52, 52, 10].
        BigDecimal pontuacaoQuizDepois = ProgressFormulas.calcularPontuacaoQuiz(List.of(bd2("52"), bd2("52"), bd2("10")));
        assertThat(pontuacaoQuizDepois).isEqualByComparingTo("38.00");

        List<ComponenteValor> componentesDepois = List.of(
                new ComponenteValor("quiz", pontuacaoQuizDepois),
                new ComponenteValor("flashcards", bd2("52")),
                new ComponenteValor("questoes_novas", bd2("52")),
                new ComponenteValor("consistencia", bd2("52")),
                new ComponenteValor("calibracao_confianca", bd2("52")));
        BigDecimal geralDepois = ProgressFormulas.agregarPontuacaoGeral(componentesDepois, PESOS);

        // A diluição (média de 3, não substituição direta) evita que a pontuação geral
        // despenque para o nível de uma tentativa isolada — cai, mas continua em Pleno 2.
        assertThat(geralDepois).isEqualByComparingTo("46.40");
        assertThat(ProgressFormulas.determinarNivel(geralDepois, NIVEIS).getSlug()).isEqualTo("pleno-2");

        // Prova de que a diluição é o mecanismo que faz diferença: SEM ela (se o componente de
        // quiz fosse substituído diretamente pela pontuação da tentativa isolada, 10, em vez
        // da média das últimas 3), o domínio teria trocado de nível na mesma sessão.
        List<ComponenteValor> semDiluicao = List.of(
                new ComponenteValor("quiz", bd2("10")),
                new ComponenteValor("flashcards", bd2("52")),
                new ComponenteValor("questoes_novas", bd2("52")),
                new ComponenteValor("consistencia", bd2("52")),
                new ComponenteValor("calibracao_confianca", bd2("52")));
        BigDecimal geralSemDiluicao = ProgressFormulas.agregarPontuacaoGeral(semDiluicao, PESOS);
        assertThat(ProgressFormulas.determinarNivel(geralSemDiluicao, NIVEIS).getSlug()).isEqualTo("pleno-1");
    }

    @Test
    void calcularPontuacaoFlashcards_percentualDeLembrei() {
        BigDecimal pontuacao = ProgressFormulas.calcularPontuacaoFlashcards(
                List.of(true, true, true, false));

        assertThat(pontuacao).isEqualByComparingTo("75.00");
    }

    @Test
    void calcularPontuacaoCalibracao_confiancaPerfeitaDaNotaMaxima() {
        // confiança 5 (probabilidade 1.0) sempre acertando, e confiança 1 (probabilidade 0.0)
        // sempre errando — calibração perfeita, Brier score = 0, nota = 100.
        List<ConfiancaResultado> declaracoes = List.of(
                new ConfiancaResultado(1.0, true),
                new ConfiancaResultado(1.0, true),
                new ConfiancaResultado(0.0, false),
                new ConfiancaResultado(0.0, false),
                new ConfiancaResultado(1.0, true));

        BigDecimal pontuacao = ProgressFormulas.calcularPontuacaoCalibracao(declaracoes);

        assertThat(pontuacao).isEqualByComparingTo("100.00");
    }

    @Test
    void mapConfiancaParaProbabilidade_extremos() {
        assertThat(ProgressFormulas.mapConfiancaParaProbabilidade((short) 1)).isEqualTo(0.0);
        assertThat(ProgressFormulas.mapConfiancaParaProbabilidade((short) 5)).isEqualTo(1.0);
    }

    private static BigDecimal bd(int valor) {
        return BigDecimal.valueOf(valor).setScale(2);
    }

    private static BigDecimal bd2(String valor) {
        return new BigDecimal(valor).setScale(2);
    }
}
