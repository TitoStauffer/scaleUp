package com.scaleup.studyplatform.assessment;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.function.Consumer;
import java.util.stream.Collectors;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.resttestclient.TestRestTemplate;
import org.springframework.boot.resttestclient.autoconfigure.AutoConfigureTestRestTemplate;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import tools.jackson.databind.JsonNode;
import tools.jackson.databind.ObjectMapper;

import com.scaleup.studyplatform.assessment.application.dto.QuizAttemptDto;
import com.scaleup.studyplatform.assessment.application.dto.RespostaSubmissaoRequest;
import com.scaleup.studyplatform.assessment.application.dto.SubmissaoQuizRequest;
import com.scaleup.studyplatform.assessment.application.dto.SubmissaoResultadoDto;
import com.scaleup.studyplatform.content.application.dto.DomainSummaryDto;
import com.scaleup.studyplatform.content.application.dto.FlashcardDto;
import com.scaleup.studyplatform.content.application.dto.QuestionDto;
import com.scaleup.studyplatform.content.domain.Question;
import com.scaleup.studyplatform.content.domain.QuestionAlternative;
import com.scaleup.studyplatform.content.infra.QuestionRepository;
import com.scaleup.studyplatform.identity.infra.AppUserRepository;
import com.scaleup.studyplatform.identity.infra.TokenConfirmacaoCadastroRepository;
import com.scaleup.studyplatform.progress.application.dto.DomainProgressDto;
import com.scaleup.studyplatform.progress.application.dto.HistoricoItemDto;
import com.scaleup.studyplatform.progress.application.dto.ResultadoGeralDto;
import com.scaleup.studyplatform.shared.ApiErrorResponse;
import com.scaleup.studyplatform.study.application.dto.FlashcardReviewDto;
import com.scaleup.studyplatform.study.application.dto.RegistrarFlashcardReviewRequest;
import com.scaleup.studyplatform.study.application.dto.StudySessionDto;
import com.scaleup.studyplatform.support.AuthTestSupport;

/**
 * Teste de integração ponta a ponta do módulo Assessment/Progress: sobe um Postgres real em
 * container (Testcontainers), aplica as 25 migrações reais via Flyway e exercita a API real
 * (sem mock de repositório/serviço) — mesmo padrão de
 * {@code content.ContentModuleIntegrationTest}.
 *
 * Cobre os 13 critérios de aceite de TICKET-assessment-progress.md, seção 10. AC-06 e AC-07
 * (dilução da média e fronteira exata entre níveis) já têm cobertura matemática detalhada em
 * ProgressFormulasTest (unitário, sem banco) — não repetidos aqui em detalhe, só confirmados
 * de leve via consulta de progresso.
 *
 * Além dos 13 ACs, cobre o defeito de integridade encontrado pelo QA depois (V25,
 * quiz_attempt_question): troca de uma questão sorteada por outra do mesmo domínio, mas
 * sorteada para OUTRA tentativa, agora é rejeitada — ver
 * {@code quizAttemptQuestion_trocaDeQuestaoPorOutraDaMesmaTentativaMasDeOutraTentativaERejeitada}.
 *
 * Métodos ordenados propositalmente: AC-09 ("nenhum domínio avaliado ainda") só é verdade
 * enquanto NENHUM teste anterior tiver levado um domínio a volume mínimo — como o MVP usa um
 * único usuário local compartilhado entre todos os testes desta classe (mesmo container,
 * mesmo Spring context), essa checagem precisa rodar antes de qualquer teste que complete
 * volume mínimo em algum domínio.
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureTestRestTemplate
@Testcontainers
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class AssessmentProgressModuleIntegrationTest {

    @Container
    @ServiceConnection
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");

    @Autowired
    private TestRestTemplate restTemplate;

    @Autowired
    private QuestionRepository questionRepository;

    @Autowired
    private AppUserRepository appUserRepository;

    @Autowired
    private TokenConfirmacaoCadastroRepository tokenRepository;

    // Desde TICKET-autenticacao.md, todas as rotas exigem JWT — cadastra, confirma e loga um
    // usuário de teste uma única vez por classe (mesmo container/contexto compartilhado entre
    // os métodos, executados em ordem por MethodOrderer.OrderAnnotation), guardando o id do
    // usuário para os endpoints `/usuarios/{userId}/...` que ainda recebem o id na URL.
    private static final AtomicBoolean AUTENTICADO = new AtomicBoolean(false);
    private static UUID usuarioAutenticadoId;

    @BeforeEach
    void garantirUsuarioAutenticado() {
        if (AUTENTICADO.compareAndSet(false, true)) {
            var autenticacao = AuthTestSupport.cadastrarConfirmarELogar(restTemplate, appUserRepository, tokenRepository);
            AuthTestSupport.configurarAuthorizationHeaderPadrao(restTemplate, autenticacao.jwt());
            usuarioAutenticadoId = autenticacao.userId();
        }
    }

    // Instância própria (não gerenciada pelo Spring), só para leitura de árvore JSON genérica
    // no teste de vazamento de campo sensível (AC-13) — não precisa de módulos de data/hora
    // registrados, ao contrário de uma desserialização tipada.
    private final ObjectMapper objectMapper = new ObjectMapper();

    // Bean gerenciado pelo Spring (com os módulos que o Boot registra automaticamente, ex.:
    // suporte a java.time) — usado para desserializar o mesmo corpo bruto em QuizAttemptDto
    // depois do teste de vazamento, sem precisar de uma segunda chamada POST (que criaria uma
    // segunda tentativa).
    @Autowired
    private ObjectMapper springObjectMapper;

    @Test
    @Order(1)
    void ac09_resultadoGeralAindaNaoAvaliadoQuandoNenhumDominioAtingiuVolumeMinimo() {
        UUID userId = usuarioLocalId();

        ResponseEntity<ResultadoGeralDto> response = restTemplate.getForEntity(
                "/api/usuarios/" + userId + "/resultado-geral", ResultadoGeralDto.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        ResultadoGeralDto corpo = response.getBody();
        assertThat(corpo).isNotNull();
        assertThat(corpo.avaliado()).isFalse();
        assertThat(corpo.resultadoGeral()).isNull();
    }

    @Test
    @Order(2)
    void ac01_ac04_ac13_fluxoCompletoDeUmaPrimeiraTentativa() throws Exception {
        UUID dominioId = domainId("arquitetura");

        StudySessionDto sessao = iniciarSessao(dominioId);
        assertThat(sessao.status()).isEqualTo("em_andamento");

        ResponseEntity<String> attemptRaw = restTemplate.postForEntity(
                "/api/sessoes/" + sessao.id() + "/quiz-attempts", null, String.class);
        assertThat(attemptRaw.getStatusCode()).isEqualTo(HttpStatus.CREATED);

        // AC-13: a resposta de criação da tentativa (perguntas antes de submeter) nunca pode
        // conter `correta` nem `explicacao`.
        assertNenhumCampoSensivelVazado(attemptRaw.getBody());

        QuizAttemptDto attempt = springObjectMapper.readValue(attemptRaw.getBody(), QuizAttemptDto.class);
        assertThat(attempt.questoes()).hasSize(10);
        assertThat(attempt.totalQuestoes()).isEqualTo(10);

        SubmissaoQuizRequest submissao = respostasTodasCorretas(attempt.questoes());
        ResponseEntity<SubmissaoResultadoDto> resultado = restTemplate.postForEntity(
                "/api/quiz-attempts/" + attempt.id() + "/submissao", submissao, SubmissaoResultadoDto.class);

        assertThat(resultado.getStatusCode()).isEqualTo(HttpStatus.OK);
        SubmissaoResultadoDto corpo = resultado.getBody();
        assertThat(corpo).isNotNull();
        assertThat(corpo.acertos()).isEqualTo(10);
        assertThat(corpo.pontuacaoObtida()).isEqualByComparingTo("100.00");
        assertThat(corpo.concluidoEm()).isNotNull();
        assertThat(corpo.respostas()).hasSize(10);
        corpo.respostas().forEach(r -> {
            assertThat(r.correta()).isTrue();
            assertThat(r.alternativaCorretaId()).isNotNull();
            assertThat(r.explicacao()).isNotBlank();
        });

        // AC-04: primeira tentativa concluída no domínio — pontuacao_quiz já existe, mas
        // pontuacao_geral e nível continuam em avaliação (volume mínimo não atingido: precisa
        // de 3 tentativas de quiz e 10 revisões de flashcard).
        DomainProgressDto progresso = corpo.progresso();
        assertThat(progresso.volumeMinimoAtingido()).isFalse();
        assertThat(progresso.emAvaliacao()).isTrue();
        assertThat(progresso.faltamSessoesQuiz()).isEqualTo(2);
        assertThat(progresso.faltamRevisoesFlashcard()).isEqualTo(10);
        assertThat(progresso.pontuacaoQuiz()).isEqualByComparingTo("100.00");
        assertThat(progresso.pontuacaoGeral()).isNull();
        assertThat(progresso.nivelAtual()).isNull();
    }

    @Test
    @Order(3)
    void ac02_submissaoComRespostaFaltandoERejeitadaEATentativaContinuaEmAndamento() {
        UUID dominioId = domainId("apis-mensageria");
        StudySessionDto sessao = iniciarSessao(dominioId);
        QuizAttemptDto attempt = iniciarQuizAttempt(sessao.id());

        List<RespostaSubmissaoRequest> respostas = new ArrayList<>();
        for (int i = 0; i < attempt.questoes().size(); i++) {
            QuestionDto questao = attempt.questoes().get(i);
            if (i == 0) {
                // A primeira questão fica sem alternativa selecionada (simula "9 de 10
                // respondidas").
                respostas.add(new RespostaSubmissaoRequest(questao.id(), null, null));
            } else {
                respostas.add(new RespostaSubmissaoRequest(questao.id(), alternativaCorreta(questao.id()).getId(), null));
            }
        }

        ResponseEntity<ApiErrorResponse> response = restTemplate.postForEntity(
                "/api/quiz-attempts/" + attempt.id() + "/submissao", new SubmissaoQuizRequest(respostas),
                ApiErrorResponse.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(response.getBody()).isNotNull();
        assertThat(response.getBody().mensagem()).contains(attempt.questoes().get(0).id().toString());

        // A tentativa permanece em andamento: uma nova submissão completa ainda deve funcionar.
        SubmissaoQuizRequest completa = respostasTodasCorretas(attempt.questoes());
        ResponseEntity<SubmissaoResultadoDto> segundaTentativa = restTemplate.postForEntity(
                "/api/quiz-attempts/" + attempt.id() + "/submissao", completa, SubmissaoResultadoDto.class);
        assertThat(segundaTentativa.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    @Test
    @Order(4)
    void ac03_respostaAQuestaoDeOutroDominioERejeitadaAntesDePersistir() {
        UUID dominioBancoDeDados = domainId("bancos-de-dados");
        UUID dominioSeguranca = domainId("seguranca");

        StudySessionDto sessao = iniciarSessao(dominioBancoDeDados);
        QuizAttemptDto attempt = iniciarQuizAttempt(sessao.id());

        ResponseEntity<QuestionDto[]> questoesSeguranca = restTemplate.getForEntity(
                "/api/dominios/seguranca/questoes", QuestionDto[].class);
        UUID questaoDeOutroDominio = questoesSeguranca.getBody()[0].id();

        List<RespostaSubmissaoRequest> respostas = new ArrayList<>();
        // Substitui a primeira questão da tentativa por uma questão de outro domínio.
        respostas.add(new RespostaSubmissaoRequest(questaoDeOutroDominio,
                alternativaCorreta(questaoDeOutroDominio).getId(), null));
        for (int i = 1; i < attempt.questoes().size(); i++) {
            QuestionDto questao = attempt.questoes().get(i);
            respostas.add(new RespostaSubmissaoRequest(questao.id(), alternativaCorreta(questao.id()).getId(), null));
        }

        ResponseEntity<ApiErrorResponse> response = restTemplate.postForEntity(
                "/api/quiz-attempts/" + attempt.id() + "/submissao", new SubmissaoQuizRequest(respostas),
                ApiErrorResponse.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(dominioSeguranca).isNotNull();
    }

    @Test
    @Order(5)
    void ac05_ac08_ac11_volumeMinimoNivelAtribuidoEHistoricoOrdenado() {
        UUID dominioId = domainId("escalabilidade-desempenho");
        List<FlashcardDto> flashcards = Arrays.asList(restTemplate
                .getForEntity("/api/dominios/escalabilidade-desempenho/flashcards", FlashcardDto[].class).getBody());
        assertThat(flashcards).hasSizeGreaterThanOrEqualTo(10);

        // 3 QuizAttempt concluídas (volume mínimo de quiz).
        for (int i = 0; i < 3; i++) {
            StudySessionDto sessao = iniciarSessao(dominioId);
            QuizAttemptDto attempt = iniciarQuizAttempt(sessao.id());
            SubmissaoQuizRequest submissao = respostasTodasCorretas(attempt.questoes());
            ResponseEntity<SubmissaoResultadoDto> resultado = restTemplate.postForEntity(
                    "/api/quiz-attempts/" + attempt.id() + "/submissao", submissao, SubmissaoResultadoDto.class);
            assertThat(resultado.getStatusCode()).isEqualTo(HttpStatus.OK);
        }

        // 10 FlashcardReview (volume mínimo de flashcard) — sem `confiancaDeclarada`, então o
        // componente de calibração permanece NULL (AC-08: não pode travar o cálculo geral).
        StudySessionDto sessaoFlashcards = iniciarSessao(dominioId);
        for (int i = 0; i < 10; i++) {
            RegistrarFlashcardReviewRequest request = new RegistrarFlashcardReviewRequest(
                    flashcards.get(i % flashcards.size()).id(), "lembrei", null);
            ResponseEntity<FlashcardReviewDto> response = restTemplate.postForEntity(
                    "/api/sessoes/" + sessaoFlashcards.id() + "/flashcard-reviews", request, FlashcardReviewDto.class);
            assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        }

        ResponseEntity<DomainProgressDto> progressoResponse = restTemplate.getForEntity(
                "/api/dominios/" + dominioId + "/progresso", DomainProgressDto.class);
        DomainProgressDto progresso = progressoResponse.getBody();
        assertThat(progresso).isNotNull();

        // AC-05: volume mínimo atingido pela 3ª tentativa de quiz (já com as 10 revisões
        // registradas) — pontuação geral calculada e nível atribuído pela primeira vez.
        assertThat(progresso.volumeMinimoAtingido()).isTrue();
        assertThat(progresso.emAvaliacao()).isFalse();
        assertThat(progresso.pontuacaoGeral()).isNotNull();
        assertThat(progresso.nivelAtual()).isNotNull();

        // AC-08: calibração nunca foi declarada (fica NULL) e ainda assim a agregação
        // calculou pontuacao_geral normalmente — 100% de acerto em quiz/flashcards/questões
        // novas deve resultar em pontuação geral máxima mesmo com um componente ausente.
        assertThat(progresso.pontuacaoCalibracao()).isNull();
        assertThat(progresso.pontuacaoGeral()).isEqualByComparingTo("100.00");
        assertThat(progresso.nivelAtual()).isEqualTo("Especialista 3");

        // AC-11: histórico ordenado do mais recente para o mais antigo, com pontuação e data.
        ResponseEntity<HistoricoItemDto[]> historicoResponse = restTemplate.getForEntity(
                "/api/usuarios/" + usuarioLocalId() + "/historico?dominioId=" + dominioId, HistoricoItemDto[].class);
        assertThat(historicoResponse.getStatusCode()).isEqualTo(HttpStatus.OK);
        List<HistoricoItemDto> historico = Arrays.asList(historicoResponse.getBody());
        assertThat(historico).hasSize(3);
        assertThat(historico).allMatch(item -> item.pontuacaoObtida().compareTo(new java.math.BigDecimal("100.00")) == 0);
        for (int i = 0; i < historico.size() - 1; i++) {
            assertThat(historico.get(i).concluidoEm()).isAfterOrEqualTo(historico.get(i + 1).concluidoEm());
        }

        // Consequência natural de AC-05 sobre o AC-09: agora que um domínio foi avaliado, o
        // resultado geral do usuário deixa de ser "ainda não avaliado".
        ResponseEntity<ResultadoGeralDto> resultadoGeral = restTemplate.getForEntity(
                "/api/usuarios/" + usuarioLocalId() + "/resultado-geral", ResultadoGeralDto.class);
        assertThat(resultadoGeral.getBody().avaliado()).isTrue();
        assertThat(resultadoGeral.getBody().resultadoGeral()).isEqualByComparingTo("100.00");
    }

    @Test
    @Order(6)
    void ac10_autoavaliacaoDeFlashcardInvalidaERejeitadaAntesDoBanco() {
        UUID dominioId = domainId("observabilidade-confiabilidade");
        StudySessionDto sessao = iniciarSessao(dominioId);
        List<FlashcardDto> flashcards = Arrays.asList(restTemplate
                .getForEntity("/api/dominios/observabilidade-confiabilidade/flashcards", FlashcardDto[].class)
                .getBody());

        RegistrarFlashcardReviewRequest requestInvalido = new RegistrarFlashcardReviewRequest(flashcards.get(0).id(),
                "talvez", null);

        ResponseEntity<ApiErrorResponse> response = restTemplate.postForEntity(
                "/api/sessoes/" + sessao.id() + "/flashcard-reviews", requestInvalido, ApiErrorResponse.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(response.getBody()).isNotNull();
        assertThat(response.getBody().mensagem()).contains("resultado_autoavaliacao");
    }

    @Test
    @Order(7)
    void ac12_questoesNovasEsgotadasMantemUltimoValorCalculado() {
        UUID dominioId = domainId("sistemas-distribuidos");
        int totalQuestoes = restTemplate.getForEntity("/api/dominios/sistemas-distribuidos/questoes", QuestionDto[].class)
                .getBody().length;
        int tentativasParaEsgotar = (int) Math.ceil(totalQuestoes / 10.0);

        DomainProgressDto ultimoProgressoDuranteEsgotamento = null;
        for (int i = 0; i < tentativasParaEsgotar; i++) {
            StudySessionDto sessao = iniciarSessao(dominioId);
            QuizAttemptDto attempt = iniciarQuizAttempt(sessao.id());
            SubmissaoResultadoDto resultado = restTemplate.postForEntity(
                    "/api/quiz-attempts/" + attempt.id() + "/submissao", respostasTodasCorretas(attempt.questoes()),
                    SubmissaoResultadoDto.class).getBody();
            ultimoProgressoDuranteEsgotamento = resultado.progresso();
        }
        assertThat(ultimoProgressoDuranteEsgotamento.pontuacaoQuestoesNovas()).isNotNull();
        java.math.BigDecimal valorAposEsgotar = ultimoProgressoDuranteEsgotamento.pontuacaoQuestoesNovas();

        // Uma tentativa a mais necessariamente repete questões (pool de "novas" esgotado) —
        // pontuacao_questoes_novas deve permanecer com o último valor, não virar NULL.
        StudySessionDto sessaoExtra = iniciarSessao(dominioId);
        QuizAttemptDto attemptExtra = iniciarQuizAttempt(sessaoExtra.id());
        SubmissaoResultadoDto resultadoExtra = restTemplate.postForEntity(
                "/api/quiz-attempts/" + attemptExtra.id() + "/submissao", respostasTodasCorretas(attemptExtra.questoes()),
                SubmissaoResultadoDto.class).getBody();

        assertThat(resultadoExtra.progresso().pontuacaoQuestoesNovas()).isNotNull();
        assertThat(resultadoExtra.progresso().pontuacaoQuestoesNovas()).isEqualByComparingTo(valorAposEsgotar);
    }

    @Test
    @Order(8)
    void quizAttemptQuestion_trocaDeQuestaoPorOutraDaMesmaTentativaMasDeOutraTentativaERejeitada() {
        // Reprodução exata do defeito relatado pelo QA: trocar 1 das 10 questões sorteadas de
        // uma tentativa por outra questão do MESMO domínio, mas sorteada para OUTRA tentativa —
        // antes de V25/quiz_attempt_question, a checagem de domínio (AC-03) deixava isso passar
        // e pontuar normalmente.
        UUID dominioId = domainId("bancos-de-dados");

        StudySessionDto sessaoA = iniciarSessao(dominioId);
        QuizAttemptDto attemptA = iniciarQuizAttempt(sessaoA.id());

        StudySessionDto sessaoB = iniciarSessao(dominioId);
        QuizAttemptDto attemptB = iniciarQuizAttempt(sessaoB.id());

        Set<UUID> questoesA = attemptA.questoes().stream().map(QuestionDto::id).collect(Collectors.toSet());
        QuestionDto questaoDeOutraTentativa = attemptB.questoes().stream()
                .filter(q -> !questoesA.contains(q.id()))
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("Pool do domínio 'bancos-de-dados' pequeno demais para "
                        + "o teste: as duas tentativas sortearam exatamente as mesmas 10 questões"));

        List<RespostaSubmissaoRequest> respostas = new ArrayList<>();
        // Substitui a primeira questão da tentativa A por uma questão sorteada para a
        // tentativa B (mesmo domínio, tentativa diferente).
        respostas.add(new RespostaSubmissaoRequest(questaoDeOutraTentativa.id(),
                alternativaCorreta(questaoDeOutraTentativa.id()).getId(), null));
        for (int i = 1; i < attemptA.questoes().size(); i++) {
            QuestionDto questao = attemptA.questoes().get(i);
            respostas.add(new RespostaSubmissaoRequest(questao.id(), alternativaCorreta(questao.id()).getId(), null));
        }

        ResponseEntity<ApiErrorResponse> response = restTemplate.postForEntity(
                "/api/quiz-attempts/" + attemptA.id() + "/submissao", new SubmissaoQuizRequest(respostas),
                ApiErrorResponse.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(response.getBody()).isNotNull();
        assertThat(response.getBody().mensagem()).contains(questaoDeOutraTentativa.id().toString());
        assertThat(response.getBody().mensagem()).contains(attemptA.id().toString());

        // A tentativa A permanece em andamento: uma submissão legítima (só com questões
        // realmente sorteadas para ela) ainda deve ser aceita normalmente.
        SubmissaoQuizRequest completa = respostasTodasCorretas(attemptA.questoes());
        ResponseEntity<SubmissaoResultadoDto> legitima = restTemplate.postForEntity(
                "/api/quiz-attempts/" + attemptA.id() + "/submissao", completa, SubmissaoResultadoDto.class);
        assertThat(legitima.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    // ---- helpers ----

    /**
     * Os endpoints `/usuarios/{userId}/...` continuam recebendo o id na URL (ticket de
     * autenticação não mudou essa parte do contrato) — aqui é o id do usuário de teste
     * autenticado por {@link AuthTestSupport} em {@link #garantirUsuarioAutenticado()}.
     */
    private UUID usuarioLocalId() {
        return usuarioAutenticadoId;
    }

    private UUID domainId(String slug) {
        ResponseEntity<DomainSummaryDto[]> response = restTemplate.getForEntity("/api/dominios", DomainSummaryDto[].class);
        return Arrays.stream(response.getBody())
                .filter(d -> d.slug().equals(slug))
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("Domínio não encontrado nos seeds: " + slug))
                .id();
    }

    private StudySessionDto iniciarSessao(UUID dominioId) {
        ResponseEntity<StudySessionDto> response = restTemplate.postForEntity(
                "/api/dominios/" + dominioId + "/sessoes", null, StudySessionDto.class);
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        return response.getBody();
    }

    private QuizAttemptDto iniciarQuizAttempt(UUID sessaoId) {
        ResponseEntity<QuizAttemptDto> response = restTemplate.postForEntity(
                "/api/sessoes/" + sessaoId + "/quiz-attempts", null, QuizAttemptDto.class);
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        return response.getBody();
    }

    private SubmissaoQuizRequest respostasTodasCorretas(List<QuestionDto> questoes) {
        List<RespostaSubmissaoRequest> respostas = questoes.stream()
                .map(q -> new RespostaSubmissaoRequest(q.id(), alternativaCorreta(q.id()).getId(), null))
                .toList();
        return new SubmissaoQuizRequest(respostas);
    }

    private QuestionAlternative alternativaCorreta(UUID questionId) {
        Question questao = questionRepository.findWithAlternativasById(questionId).orElseThrow();
        return questao.getAlternativas().stream().filter(QuestionAlternative::isCorreta).findFirst().orElseThrow();
    }

    private void assertNenhumCampoSensivelVazado(String corpoJson) throws Exception {
        JsonNode raiz = objectMapper.readTree(corpoJson);
        Consumer<JsonNode> falhaSeCampoSensivelExistir = new Consumer<>() {
            @Override
            public void accept(JsonNode node) {
                if (node.isObject()) {
                    node.propertyNames().forEach(nomeDoCampo -> assertThat(nomeDoCampo)
                            .as("campo sensível vazado no JSON de criação de quiz-attempt: '%s'", nomeDoCampo)
                            .isNotIn("correta", "explicacao"));
                    node.forEach(this::accept);
                } else if (node.isArray()) {
                    node.forEach(this::accept);
                }
            }
        };
        falhaSeCampoSensivelExistir.accept(raiz);
    }
}
