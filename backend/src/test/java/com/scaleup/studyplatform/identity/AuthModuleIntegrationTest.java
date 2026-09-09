package com.scaleup.studyplatform.identity;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.Instant;
import java.util.UUID;

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
import org.springframework.http.ResponseEntity;
import org.springframework.test.util.ReflectionTestUtils;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import com.scaleup.studyplatform.content.application.dto.DomainSummaryDto;
import com.scaleup.studyplatform.identity.application.dto.CadastroRequest;
import com.scaleup.studyplatform.identity.application.dto.ConfirmarRequest;
import com.scaleup.studyplatform.identity.application.dto.LoginRequest;
import com.scaleup.studyplatform.identity.application.dto.LoginResponseDto;
import com.scaleup.studyplatform.identity.application.dto.MensagemDto;
import com.scaleup.studyplatform.identity.application.dto.ReenviarRequest;
import com.scaleup.studyplatform.identity.application.dto.UsuarioAtualDto;
import com.scaleup.studyplatform.identity.domain.TokenConfirmacaoCadastro;
import com.scaleup.studyplatform.identity.infra.AppUserRepository;
import com.scaleup.studyplatform.identity.infra.TokenConfirmacaoCadastroRepository;
import com.scaleup.studyplatform.shared.ApiErrorResponse;

/**
 * Teste de integração ponta a ponta do módulo de autenticação: sobe um Postgres real em
 * container (Testcontainers), aplica as 34 migrações reais via Flyway e exercita a API real
 * (cadastro/confirmação/reenvio/login + proteção de rotas), sem mock de repositório/serviço —
 * mesmo padrão de {@code AssessmentProgressModuleIntegrationTest}.
 *
 * Cobre os 14 critérios de aceite de TICKET-autenticacao.md, seção 13 (AC-01 a AC-14).
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureTestRestTemplate
@Testcontainers
class AuthModuleIntegrationTest {

    @Container
    @ServiceConnection
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");

    private static final String SENHA_FORTE = "Senha123!@#";

    @Autowired
    private TestRestTemplate restTemplate;

    @Autowired
    private AppUserRepository appUserRepository;

    @Autowired
    private TokenConfirmacaoCadastroRepository tokenRepository;

    @Test
    void ac01_cadastroComEmailJaExistenteEAtivoRespondeMensagemGenericaSemReenviarEmail() {
        String email = novoEmail();
        cadastrar(email, SENHA_FORTE, SENHA_FORTE);
        confirmar(email, tokenAbertoDe(email));

        // Segunda tentativa de cadastro com o MESMO e-mail, já ativo.
        ResponseEntity<MensagemDto> segundaTentativa = cadastrar(email, SENHA_FORTE, SENHA_FORTE);

        assertThat(segundaTentativa.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(segundaTentativa.getBody()).isNotNull();
        // Mesma mensagem genérica de sempre — não revela que a conta já existe/está ativa.
        assertThat(segundaTentativa.getBody().mensagem()).isNotBlank();

        // Nenhum e-mail novo foi "enviado": nenhum token novo foi criado para essa conta.
        UUID userId = appUserRepository.findByEmail(email).orElseThrow().getId();
        long totalTokens = tokenRepository.findAll().stream().filter(t -> t.getUserId().equals(userId)).count();
        assertThat(totalTokens).isEqualTo(1);
    }

    @Test
    void ac02_cadastroComSenhaFracaERejeitadoENenhumaContaECriada() {
        String email = novoEmail();

        ResponseEntity<ApiErrorResponse> semMaiusculaNumeroOuSimbolo = restTemplate.postForEntity("/api/auth/cadastro",
                new CadastroRequest(email, "abcdefgh", "abcdefgh"), ApiErrorResponse.class);
        assertThat(semMaiusculaNumeroOuSimbolo.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);

        ResponseEntity<ApiErrorResponse> semSimbolo = restTemplate.postForEntity("/api/auth/cadastro",
                new CadastroRequest(email, "Abc12345", "Abc12345"), ApiErrorResponse.class);
        assertThat(semSimbolo.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);

        assertThat(appUserRepository.findByEmail(email)).isEmpty();
    }

    @Test
    void ac03_confirmacaoComTokenCertoAtivaAContaEPermiteLogin() {
        String email = novoEmail();
        cadastrar(email, SENHA_FORTE, SENHA_FORTE);

        ResponseEntity<MensagemDto> confirmacao = confirmar(email, tokenAbertoDe(email));
        assertThat(confirmacao.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(appUserRepository.findByEmail(email).orElseThrow().isAtiva()).isTrue();

        ResponseEntity<LoginResponseDto> login = login(email, SENHA_FORTE);
        assertThat(login.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(login.getBody().token()).isNotBlank();
    }

    @Test
    void ac04_confirmacaoComTokenErradoRejeitaEContaContinuaPendenteETokenOriginalContinuaValido() {
        String email = novoEmail();
        cadastrar(email, SENHA_FORTE, SENHA_FORTE);
        String tokenCorreto = tokenAbertoDe(email);
        String tokenErrado = tokenCorreto.equals("123456") ? "654321" : "123456";

        ResponseEntity<ApiErrorResponse> tentativaErrada = confirmarEsperandoErro(email, tokenErrado);
        assertThat(tentativaErrada.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(tentativaErrada.getBody().erro()).isEqualTo("TOKEN_INVALIDO");
        assertThat(appUserRepository.findByEmail(email).orElseThrow().isAtiva()).isFalse();

        // O token original continua válido — confirmar com ele agora funciona normalmente.
        ResponseEntity<MensagemDto> confirmacaoComTokenOriginal = confirmar(email, tokenCorreto);
        assertThat(confirmacaoComTokenOriginal.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    @Test
    void ac05_confirmacaoComTokenExpiradoRejeitaComErroEspecificoDistintoDeTokenInvalido() {
        String email = novoEmail();
        cadastrar(email, SENHA_FORTE, SENHA_FORTE);
        UUID userId = appUserRepository.findByEmail(email).orElseThrow().getId();
        TokenConfirmacaoCadastro token = tokenRepository
                .findByUserIdAndConsumidoEmIsNullAndInvalidadoEmIsNull(userId).orElseThrow();

        // Sem esperar 20 minutos de verdade: retrocede geração e expiração do token
        // diretamente no banco, simulando um token gerado há muito tempo. Precisa mexer nos
        // dois campos juntos — só mudar `expiraEm` para o passado violaria o CHECK
        // `expira_em > gerado_em` (V34), já que `geradoEm` continuaria "agora".
        ReflectionTestUtils.setField(token, "geradoEm", Instant.now().minus(java.time.Duration.ofMinutes(30)));
        ReflectionTestUtils.setField(token, "expiraEm", Instant.now().minus(java.time.Duration.ofMinutes(10)));
        tokenRepository.saveAndFlush(token);

        ResponseEntity<ApiErrorResponse> resposta = confirmarEsperandoErro(email, token.getToken());
        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(resposta.getBody().erro()).isEqualTo("TOKEN_EXPIRADO");
        assertThat(appUserRepository.findByEmail(email).orElseThrow().isAtiva()).isFalse();
    }

    @Test
    void ac06_reenvioDeTokenInvalidaOAnteriorEGeraNovoComNovaValidade() {
        String email = novoEmail();
        cadastrar(email, SENHA_FORTE, SENHA_FORTE);
        String tokenAntigo = tokenAbertoDe(email);

        ResponseEntity<MensagemDto> reenvio = restTemplate.postForEntity("/api/auth/reenviar-token",
                new ReenviarRequest(email), MensagemDto.class);
        assertThat(reenvio.getStatusCode()).isEqualTo(HttpStatus.OK);

        String tokenNovo = tokenAbertoDe(email);
        assertThat(tokenNovo).isNotEqualTo(tokenAntigo);

        // O token antigo não confirma mais a conta.
        ResponseEntity<ApiErrorResponse> comTokenAntigo = confirmarEsperandoErro(email, tokenAntigo);
        assertThat(comTokenAntigo.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);

        // O token novo confirma normalmente, com prazo de validade novo.
        ResponseEntity<MensagemDto> comTokenNovo = confirmar(email, tokenNovo);
        assertThat(comTokenNovo.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    @Test
    void ac07_loginAntesDeConfirmarContaRejeitaComErroEspecificoENenhumJwtEmitido() {
        String email = novoEmail();
        cadastrar(email, SENHA_FORTE, SENHA_FORTE);

        ResponseEntity<ApiErrorResponse> resposta = restTemplate.postForEntity("/api/auth/login",
                new LoginRequest(email, SENHA_FORTE), ApiErrorResponse.class);

        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.FORBIDDEN);
        assertThat(resposta.getBody().erro()).isEqualTo("CONTA_NAO_CONFIRMADA");
    }

    @Test
    void ac08_loginComCredenciaisErradasRejeitaComMensagemGenericaNosDoisCasos() {
        String emailInexistente = novoEmail();
        ResponseEntity<ApiErrorResponse> respostaEmailInexistente = restTemplate.postForEntity("/api/auth/login",
                new LoginRequest(emailInexistente, SENHA_FORTE), ApiErrorResponse.class);
        assertThat(respostaEmailInexistente.getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);
        assertThat(respostaEmailInexistente.getBody().erro()).isEqualTo("CREDENCIAIS_INVALIDAS");

        String emailAtivo = novoEmail();
        cadastrar(emailAtivo, SENHA_FORTE, SENHA_FORTE);
        confirmar(emailAtivo, tokenAbertoDe(emailAtivo));

        ResponseEntity<ApiErrorResponse> respostaSenhaErrada = restTemplate.postForEntity("/api/auth/login",
                new LoginRequest(emailAtivo, "SenhaErrada123!"), ApiErrorResponse.class);
        assertThat(respostaSenhaErrada.getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);
        assertThat(respostaSenhaErrada.getBody().erro()).isEqualTo("CREDENCIAIS_INVALIDAS");

        // Mesma mensagem nos dois casos (anti-enumeração).
        assertThat(respostaEmailInexistente.getBody().mensagem()).isEqualTo(respostaSenhaErrada.getBody().mensagem());
    }

    @Test
    void ac09_loginCorretoRetornaJwtEUsuarioAtualResolveAContaCerta() {
        String email = novoEmail();
        cadastrar(email, SENHA_FORTE, SENHA_FORTE);
        confirmar(email, tokenAbertoDe(email));

        ResponseEntity<LoginResponseDto> login = login(email, SENHA_FORTE);
        assertThat(login.getStatusCode()).isEqualTo(HttpStatus.OK);
        String jwt = login.getBody().token();
        assertThat(jwt).isNotBlank();

        HttpHeaders headers = new HttpHeaders();
        headers.add(HttpHeaders.AUTHORIZATION, "Bearer " + jwt);
        ResponseEntity<UsuarioAtualDto> usuarioAtual = restTemplate.exchange("/api/usuarios/atual", HttpMethod.GET,
                new HttpEntity<>(headers), UsuarioAtualDto.class);

        assertThat(usuarioAtual.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(usuarioAtual.getBody().email()).isEqualTo(email);
        assertThat(usuarioAtual.getBody().id()).isEqualTo(appUserRepository.findByEmail(email).orElseThrow().getId());
    }

    @Test
    void ac10_acessoARotaProtegidaSemTokenRetorna401() {
        ResponseEntity<ApiErrorResponse> resposta = restTemplate.getForEntity("/api/dominios", ApiErrorResponse.class);
        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);
    }

    @Test
    void ac11_acessoARotaProtegidaComTokenMalformadoOuAdulteradoRetorna401SemDistincao() {
        HttpHeaders headersMalformado = new HttpHeaders();
        headersMalformado.add(HttpHeaders.AUTHORIZATION, "Bearer isto-nao-e-um-jwt");
        ResponseEntity<ApiErrorResponse> respostaMalformado = restTemplate.exchange("/api/dominios", HttpMethod.GET,
                new HttpEntity<>(headersMalformado), ApiErrorResponse.class);
        assertThat(respostaMalformado.getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);

        // JWT com estrutura válida, mas assinatura adulterada (payload trocado à mão) —
        // mesmo tratamento uniforme de 401 do token malformado acima, sem detalhar o motivo.
        HttpHeaders headersAdulterado = new HttpHeaders();
        headersAdulterado.add(HttpHeaders.AUTHORIZATION, "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZHVsdGVyYWRvIn0."
                + "assinatura-invalida-adulterada");
        ResponseEntity<ApiErrorResponse> respostaAdulterado = restTemplate.exchange("/api/dominios", HttpMethod.GET,
                new HttpEntity<>(headersAdulterado), ApiErrorResponse.class);
        assertThat(respostaAdulterado.getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);

        assertThat(respostaMalformado.getBody().erro()).isEqualTo(respostaAdulterado.getBody().erro());
    }

    @Test
    void ac12_acessoComTokenValidoDeUsuariosDiferentesResolveCadaUsuarioCorretamente() {
        String emailA = novoEmail();
        cadastrar(emailA, SENHA_FORTE, SENHA_FORTE);
        confirmar(emailA, tokenAbertoDe(emailA));
        String jwtA = login(emailA, SENHA_FORTE).getBody().token();

        String emailB = novoEmail();
        cadastrar(emailB, SENHA_FORTE, SENHA_FORTE);
        confirmar(emailB, tokenAbertoDe(emailB));
        String jwtB = login(emailB, SENHA_FORTE).getBody().token();

        // Cada JWT resolve o SEU PRÓPRIO usuário (não mais um usuário fixo compartilhado) —
        // o fluxo de estudo completo com JWT válido já é exercitado ponta a ponta em
        // AssessmentProgressModuleIntegrationTest; aqui a garantia específica deste ticket é
        // o isolamento por usuário real.
        assertThat(usuarioAtualCom(jwtA).email()).isEqualTo(emailA);
        assertThat(usuarioAtualCom(jwtB).email()).isEqualTo(emailB);
        assertThat(usuarioAtualCom(jwtA).id()).isNotEqualTo(usuarioAtualCom(jwtB).id());
    }

    @Test
    void ac13_confirmacaoDeContaJaConfirmadaEIdempotenteMesmoComTokenErrado() {
        String email = novoEmail();
        cadastrar(email, SENHA_FORTE, SENHA_FORTE);
        confirmar(email, tokenAbertoDe(email));
        assertThat(appUserRepository.findByEmail(email).orElseThrow().isAtiva()).isTrue();

        // Qualquer token, mesmo claramente inválido, numa conta já ativa: sucesso idempotente.
        ResponseEntity<MensagemDto> resposta = confirmar(email, "999999");
        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(resposta.getBody().mensagem()).contains("já confirmada");
    }

    @Test
    void ac14_reenvioParaContaJaAtivaEIdempotenteESemEnviarEmail() {
        String email = novoEmail();
        cadastrar(email, SENHA_FORTE, SENHA_FORTE);
        confirmar(email, tokenAbertoDe(email));
        UUID userId = appUserRepository.findByEmail(email).orElseThrow().getId();
        long totalTokensAntes = tokenRepository.findAll().stream().filter(t -> t.getUserId().equals(userId)).count();

        ResponseEntity<MensagemDto> resposta = restTemplate.postForEntity("/api/auth/reenviar-token",
                new ReenviarRequest(email), MensagemDto.class);

        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(resposta.getBody().mensagem()).contains("já confirmada");
        long totalTokensDepois = tokenRepository.findAll().stream().filter(t -> t.getUserId().equals(userId)).count();
        assertThat(totalTokensDepois).isEqualTo(totalTokensAntes);
    }

    // ---- helpers ----

    private String novoEmail() {
        return "ac-" + UUID.randomUUID() + "@scaleup.dev";
    }

    private ResponseEntity<MensagemDto> cadastrar(String email, String senha, String confirmacaoSenha) {
        ResponseEntity<MensagemDto> resposta = restTemplate.postForEntity("/api/auth/cadastro",
                new CadastroRequest(email, senha, confirmacaoSenha), MensagemDto.class);
        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.OK);
        return resposta;
    }

    private ResponseEntity<MensagemDto> confirmar(String email, String token) {
        return restTemplate.postForEntity("/api/auth/confirmar", new ConfirmarRequest(email, token), MensagemDto.class);
    }

    private ResponseEntity<ApiErrorResponse> confirmarEsperandoErro(String email, String token) {
        return restTemplate.postForEntity("/api/auth/confirmar", new ConfirmarRequest(email, token), ApiErrorResponse.class);
    }

    private ResponseEntity<LoginResponseDto> login(String email, String senha) {
        return restTemplate.postForEntity("/api/auth/login", new LoginRequest(email, senha), LoginResponseDto.class);
    }

    private UsuarioAtualDto usuarioAtualCom(String jwt) {
        HttpHeaders headers = new HttpHeaders();
        headers.add(HttpHeaders.AUTHORIZATION, "Bearer " + jwt);
        ResponseEntity<UsuarioAtualDto> resposta = restTemplate.exchange("/api/usuarios/atual", HttpMethod.GET,
                new HttpEntity<>(headers), UsuarioAtualDto.class);
        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.OK);
        return resposta.getBody();
    }

    /** Lê diretamente do banco o token "em aberto" (histórico via V34) da conta — mesmo
     * artifício de {@code AuthTestSupport}, já que não há SMTP real (mock loga o token). */
    private String tokenAbertoDe(String email) {
        UUID userId = appUserRepository.findByEmail(email).orElseThrow().getId();
        return tokenRepository.findByUserIdAndConsumidoEmIsNullAndInvalidadoEmIsNull(userId)
                .orElseThrow(() -> new IllegalStateException("Nenhum token em aberto para " + email))
                .getToken();
    }
}
