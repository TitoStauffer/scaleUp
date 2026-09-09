package com.scaleup.studyplatform.security;

import static org.assertj.core.api.Assertions.assertThat;

import java.util.Arrays;
import java.util.List;
import java.util.UUID;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.resttestclient.TestRestTemplate;
import org.springframework.boot.resttestclient.autoconfigure.AutoConfigureTestRestTemplate;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import com.scaleup.studyplatform.assessment.application.dto.QuizAttemptDto;
import com.scaleup.studyplatform.content.application.dto.DomainSummaryDto;
import com.scaleup.studyplatform.content.application.dto.FlashcardDto;
import com.scaleup.studyplatform.identity.infra.AppUserRepository;
import com.scaleup.studyplatform.identity.infra.TokenConfirmacaoCadastroRepository;
import com.scaleup.studyplatform.progress.application.dto.HistoricoItemDto;
import com.scaleup.studyplatform.progress.application.dto.ResultadoGeralDto;
import com.scaleup.studyplatform.shared.ApiErrorResponse;
import com.scaleup.studyplatform.study.application.dto.FlashcardReviewDto;
import com.scaleup.studyplatform.study.application.dto.RegistrarFlashcardReviewRequest;
import com.scaleup.studyplatform.study.application.dto.StudySessionDto;
import com.scaleup.studyplatform.support.AuthTestSupport;
import com.scaleup.studyplatform.support.AutenticacaoTeste;

/**
 * Reproduz o defeito CRÍTICO de IDOR relatado pelo QA: com um JWT válido do usuário B, era
 * possível ler/gravar recursos (sessão, tentativa de quiz, resultado geral, histórico) que
 * pertencem ao usuário A, só por conhecer o id na URL/payload.
 *
 * Ao contrário de {@code AssessmentProgressModuleIntegrationTest} (um único usuário
 * autenticado, reaproveitado via interceptor global no {@link TestRestTemplate}), este teste
 * precisa de DOIS usuários simultâneos — por isso monta o header {@code Authorization}
 * explicitamente em cada chamada, em vez de usar
 * {@link AuthTestSupport#configurarAuthorizationHeaderPadrao}.
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureTestRestTemplate
@Testcontainers
class IdorProtectionIntegrationTest {

    @Container
    @ServiceConnection
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");

    @Autowired
    private TestRestTemplate restTemplate;

    @Autowired
    private AppUserRepository appUserRepository;

    @Autowired
    private TokenConfirmacaoCadastroRepository tokenRepository;

    private AutenticacaoTeste usuarioA;
    private AutenticacaoTeste usuarioB;

    @BeforeEach
    void cadastrarDoisUsuarios() {
        usuarioA = AuthTestSupport.cadastrarConfirmarELogar(restTemplate, appUserRepository, tokenRepository);
        usuarioB = AuthTestSupport.cadastrarConfirmarELogar(restTemplate, appUserRepository, tokenRepository);
    }

    @Test
    void usuarioBNaoConsegueLerNemEscreverRecursosDoUsuarioA() {
        UUID dominioId = domainId(usuarioA, "arquitetura");

        // Usuário A cria sessão, tentativa de quiz e gera progresso (resultado geral avaliado).
        StudySessionDto sessaoA = iniciarSessao(usuarioA, dominioId);
        QuizAttemptDto attemptA = iniciarQuizAttempt(usuarioA, sessaoA.id());

        // Fluxo normal: o próprio usuário A consegue ler os próprios recursos (sem regressão).
        assertThat(get(usuarioA, "/api/usuarios/" + usuarioA.userId() + "/resultado-geral", ResultadoGeralDto.class)
                .getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(get(usuarioA, "/api/usuarios/" + usuarioA.userId() + "/historico", HistoricoItemDto[].class)
                .getStatusCode()).isEqualTo(HttpStatus.OK);

        // Cenário exato do QA: usuário B, com o PRÓPRIO token válido, tenta acessar/escrever
        // recursos do usuário A usando os ids de A na URL/payload.

        // 1) GET /api/usuarios/{userId-A}/resultado-geral
        ResponseEntity<ApiErrorResponse> resultadoGeral = get(usuarioB,
                "/api/usuarios/" + usuarioA.userId() + "/resultado-geral", ApiErrorResponse.class);
        assertThat(resultadoGeral.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);

        // 2) GET /api/usuarios/{userId-A}/historico
        ResponseEntity<ApiErrorResponse> historico = get(usuarioB,
                "/api/usuarios/" + usuarioA.userId() + "/historico", ApiErrorResponse.class);
        assertThat(historico.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);

        // 3) POST /api/sessoes/{sessaoId-A}/quiz-attempts
        ResponseEntity<ApiErrorResponse> quizAttempt = post(usuarioB,
                "/api/sessoes/" + sessaoA.id() + "/quiz-attempts", null, ApiErrorResponse.class);
        assertThat(quizAttempt.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);

        // 4) POST /api/quiz-attempts/{attemptId-A}/submissao — payload bem-formado (senão a
        // validação de bean (@NotEmpty/@NotNull) rejeitaria com 400 antes de chegar à
        // checagem de posse, mascarando o teste).
        List<com.scaleup.studyplatform.assessment.application.dto.RespostaSubmissaoRequest> respostasFormadas = attemptA
                .questoes().stream()
                .map(q -> new com.scaleup.studyplatform.assessment.application.dto.RespostaSubmissaoRequest(q.id(),
                        q.alternativas().get(0).id(), null))
                .toList();
        ResponseEntity<ApiErrorResponse> submissao = post(usuarioB,
                "/api/quiz-attempts/" + attemptA.id() + "/submissao",
                new com.scaleup.studyplatform.assessment.application.dto.SubmissaoQuizRequest(respostasFormadas),
                ApiErrorResponse.class);
        assertThat(submissao.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);

        // 5) POST /api/sessoes/{sessaoId-A}/flashcard-reviews
        List<FlashcardDto> flashcards = Arrays
                .asList(get(usuarioA, "/api/dominios/arquitetura/flashcards", FlashcardDto[].class).getBody());
        ResponseEntity<ApiErrorResponse> flashcardReview = post(usuarioB,
                "/api/sessoes/" + sessaoA.id() + "/flashcard-reviews",
                new RegistrarFlashcardReviewRequest(flashcards.get(0).id(), "lembrei", null), ApiErrorResponse.class);
        assertThat(flashcardReview.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);

        // Nenhuma dessas tentativas deve ter vazado dados de A nem alterado o estado dela:
        // a própria tentativa de A continua em andamento e aceitando a submissão legítima.
        SubmissaoLegitima resultadoLegitimo = submeterComoDono(usuarioA, attemptA);
        assertThat(resultadoLegitimo.status()).isEqualTo(HttpStatus.OK);
    }

    @Test
    void usuarioBNaoConsegueUsarUserIdDeAMesmoAcessandoOProprioResultado() {
        // Regressão adicional: garante que o bloqueio é por posse (comparação com o usuário do
        // JWT), não por algum efeito colateral de B não ter nenhum progresso ainda — B
        // acessando o PRÓPRIO userId continua funcionando normalmente.
        ResponseEntity<ResultadoGeralDto> resultadoProprio = get(usuarioB,
                "/api/usuarios/" + usuarioB.userId() + "/resultado-geral", ResultadoGeralDto.class);
        assertThat(resultadoProprio.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    // ---- helpers ----

    private record SubmissaoLegitima(HttpStatusCode status) {
    }

    private SubmissaoLegitima submeterComoDono(AutenticacaoTeste usuario, QuizAttemptDto attempt) {
        List<com.scaleup.studyplatform.assessment.application.dto.RespostaSubmissaoRequest> respostas = attempt
                .questoes().stream()
                .map(q -> new com.scaleup.studyplatform.assessment.application.dto.RespostaSubmissaoRequest(q.id(),
                        q.alternativas().get(0).id(), null))
                .toList();
        ResponseEntity<String> resposta = post(usuario, "/api/quiz-attempts/" + attempt.id() + "/submissao",
                new com.scaleup.studyplatform.assessment.application.dto.SubmissaoQuizRequest(respostas), String.class);
        return new SubmissaoLegitima(resposta.getStatusCode());
    }

    private UUID domainId(AutenticacaoTeste usuario, String slug) {
        ResponseEntity<DomainSummaryDto[]> response = get(usuario, "/api/dominios", DomainSummaryDto[].class);
        return Arrays.stream(response.getBody())
                .filter(d -> d.slug().equals(slug))
                .findFirst()
                .orElseThrow(() -> new IllegalStateException("Domínio não encontrado nos seeds: " + slug))
                .id();
    }

    private StudySessionDto iniciarSessao(AutenticacaoTeste usuario, UUID dominioId) {
        ResponseEntity<StudySessionDto> response = post(usuario, "/api/dominios/" + dominioId + "/sessoes", null,
                StudySessionDto.class);
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        return response.getBody();
    }

    private QuizAttemptDto iniciarQuizAttempt(AutenticacaoTeste usuario, UUID sessaoId) {
        ResponseEntity<QuizAttemptDto> response = post(usuario, "/api/sessoes/" + sessaoId + "/quiz-attempts", null,
                QuizAttemptDto.class);
        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        return response.getBody();
    }

    private <T> ResponseEntity<T> get(AutenticacaoTeste usuario, String path, Class<T> tipo) {
        HttpEntity<Void> entidade = new HttpEntity<>(headersPara(usuario));
        return restTemplate.exchange(path, HttpMethod.GET, entidade, tipo);
    }

    private <T> ResponseEntity<T> post(AutenticacaoTeste usuario, String path, Object corpo, Class<T> tipo) {
        HttpEntity<Object> entidade = new HttpEntity<>(corpo, headersPara(usuario));
        return restTemplate.exchange(path, HttpMethod.POST, entidade, tipo);
    }

    private HttpHeaders headersPara(AutenticacaoTeste usuario) {
        HttpHeaders headers = new HttpHeaders();
        headers.add(HttpHeaders.AUTHORIZATION, "Bearer " + usuario.jwt());
        return headers;
    }
}
