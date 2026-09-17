package com.scaleup.studyplatform.identity;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.Duration;
import java.time.Instant;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.resttestclient.TestRestTemplate;
import org.springframework.boot.resttestclient.autoconfigure.AutoConfigureTestRestTemplate;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.util.ReflectionTestUtils;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import com.scaleup.studyplatform.identity.application.dto.CadastroRequest;
import com.scaleup.studyplatform.identity.application.dto.EsqueciSenhaRequest;
import com.scaleup.studyplatform.identity.application.dto.LoginRequest;
import com.scaleup.studyplatform.identity.application.dto.LoginResponseDto;
import com.scaleup.studyplatform.identity.application.dto.MensagemDto;
import com.scaleup.studyplatform.identity.application.dto.RedefinirSenhaRequest;
import com.scaleup.studyplatform.identity.domain.TokenRecuperacaoSenha;
import com.scaleup.studyplatform.identity.infra.AppUserRepository;
import com.scaleup.studyplatform.identity.infra.TokenConfirmacaoCadastroRepository;
import com.scaleup.studyplatform.identity.infra.TokenRecuperacaoSenhaRepository;
import com.scaleup.studyplatform.shared.ApiErrorResponse;
import com.scaleup.studyplatform.support.AuthTestSupport;
import com.scaleup.studyplatform.support.AutenticacaoTeste;

/**
 * Teste de integração ponta a ponta de POST /api/auth/esqueci-senha e
 * POST /api/auth/redefinir-senha, cobrindo os critérios de aceite de
 * TICKET-esqueci-minha-senha.md, seção 11 (AC-01 a AC-09; AC-10 de rate limiting não
 * duplicado aqui — mesmo mecanismo já reaproveitado de {@code RateLimiter}, sem teste
 * dedicado em nenhum outro fluxo de auth desta base).
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureTestRestTemplate
@Testcontainers
class EsqueciSenhaModuleIntegrationTest {

    @Container
    @ServiceConnection
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");

    private static final String NOVA_SENHA_FORTE = "OutraSenha456!@#";

    @Autowired
    private TestRestTemplate restTemplate;

    @Autowired
    private AppUserRepository appUserRepository;

    @Autowired
    private TokenConfirmacaoCadastroRepository tokenConfirmacaoRepository;

    @Autowired
    private TokenRecuperacaoSenhaRepository tokenRecuperacaoRepository;

    @Test
    void ac01_solicitarRecuperacaoComEmailExistenteEAtivoGeraTokenERespondeGenerico() {
        AutenticacaoTeste conta = cadastrarConfirmarELogar();

        ResponseEntity<MensagemDto> resposta = restTemplate.postForEntity("/api/auth/esqueci-senha",
                new EsqueciSenhaRequest(conta.email()), MensagemDto.class);

        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(tokenAbertoDe(conta.userId())).isPresent();
    }

    @Test
    void ac02_solicitarRecuperacaoComEmailInexistenteRespondeMesmaMensagemGenerica() {
        ResponseEntity<MensagemDto> resposta = restTemplate.postForEntity("/api/auth/esqueci-senha",
                new EsqueciSenhaRequest(novoEmail()), MensagemDto.class);

        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(resposta.getBody()).isNotNull();
        assertThat(resposta.getBody().mensagem()).isNotBlank();
    }

    @Test
    void ac03_solicitarRecuperacaoComContaPendenteRespondeGenericoSemGerarToken() {
        String email = novoEmail();
        restTemplate.postForEntity("/api/auth/cadastro", new CadastroRequest(email, AuthTestSupport.SENHA_TESTE,
                AuthTestSupport.SENHA_TESTE), MensagemDto.class);
        UUID userId = appUserRepository.findByEmail(email).orElseThrow().getId();

        ResponseEntity<MensagemDto> resposta = restTemplate.postForEntity("/api/auth/esqueci-senha",
                new EsqueciSenhaRequest(email), MensagemDto.class);

        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(tokenAbertoDe(userId)).isEmpty();
    }

    @Test
    void ac04_redefinirSenhaComTokenValidoAtualizaSenhaEPermiteLogin() {
        AutenticacaoTeste conta = cadastrarConfirmarELogar();
        restTemplate.postForEntity("/api/auth/esqueci-senha", new EsqueciSenhaRequest(conta.email()), MensagemDto.class);
        String token = tokenAbertoDe(conta.userId()).orElseThrow().getToken();

        ResponseEntity<MensagemDto> resposta = restTemplate.postForEntity("/api/auth/redefinir-senha",
                new RedefinirSenhaRequest(token, NOVA_SENHA_FORTE, NOVA_SENHA_FORTE), MensagemDto.class);
        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.OK);

        ResponseEntity<LoginResponseDto> login = restTemplate.postForEntity("/api/auth/login",
                new LoginRequest(conta.email(), NOVA_SENHA_FORTE), LoginResponseDto.class);
        assertThat(login.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    @Test
    void ac05_redefinirSenhaComTokenExpiradoRejeita() {
        AutenticacaoTeste conta = cadastrarConfirmarELogar();
        restTemplate.postForEntity("/api/auth/esqueci-senha", new EsqueciSenhaRequest(conta.email()), MensagemDto.class);
        TokenRecuperacaoSenha token = tokenAbertoDe(conta.userId()).orElseThrow();

        // Mesmo artifício de AuthModuleIntegrationTest.ac05: retrocede geração e expiração
        // juntas para não violar o CHECK expira_em > gerado_em (V49).
        ReflectionTestUtils.setField(token, "geradoEm", Instant.now().minus(Duration.ofMinutes(60)));
        ReflectionTestUtils.setField(token, "expiraEm", Instant.now().minus(Duration.ofMinutes(10)));
        tokenRecuperacaoRepository.saveAndFlush(token);

        ResponseEntity<ApiErrorResponse> resposta = restTemplate.postForEntity("/api/auth/redefinir-senha",
                new RedefinirSenhaRequest(token.getToken(), NOVA_SENHA_FORTE, NOVA_SENHA_FORTE), ApiErrorResponse.class);

        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(resposta.getBody()).isNotNull();
        assertThat(resposta.getBody().erro()).isEqualTo("TOKEN_RECUPERACAO_INVALIDO");
    }

    @Test
    void ac06_redefinirSenhaComTokenJaConsumidoRejeita() {
        AutenticacaoTeste conta = cadastrarConfirmarELogar();
        restTemplate.postForEntity("/api/auth/esqueci-senha", new EsqueciSenhaRequest(conta.email()), MensagemDto.class);
        String token = tokenAbertoDe(conta.userId()).orElseThrow().getToken();

        ResponseEntity<MensagemDto> primeiraVez = restTemplate.postForEntity("/api/auth/redefinir-senha",
                new RedefinirSenhaRequest(token, NOVA_SENHA_FORTE, NOVA_SENHA_FORTE), MensagemDto.class);
        assertThat(primeiraVez.getStatusCode()).isEqualTo(HttpStatus.OK);

        ResponseEntity<ApiErrorResponse> segundaVez = restTemplate.postForEntity("/api/auth/redefinir-senha",
                new RedefinirSenhaRequest(token, "MaisUmaSenha789!@#", "MaisUmaSenha789!@#"), ApiErrorResponse.class);

        assertThat(segundaVez.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(segundaVez.getBody()).isNotNull();
        assertThat(segundaVez.getBody().erro()).isEqualTo("TOKEN_RECUPERACAO_INVALIDO");
    }

    @Test
    void ac07_redefinirSenhaComTokenInexistenteRejeita() {
        ResponseEntity<ApiErrorResponse> resposta = restTemplate.postForEntity("/api/auth/redefinir-senha",
                new RedefinirSenhaRequest("token-que-nunca-existiu-123", NOVA_SENHA_FORTE, NOVA_SENHA_FORTE),
                ApiErrorResponse.class);

        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(resposta.getBody()).isNotNull();
        assertThat(resposta.getBody().erro()).isEqualTo("TOKEN_RECUPERACAO_INVALIDO");
    }

    @Test
    void ac08_redefinirSenhaComNovaSenhaFracaRejeitaENaoAlteraSenha() {
        AutenticacaoTeste conta = cadastrarConfirmarELogar();
        restTemplate.postForEntity("/api/auth/esqueci-senha", new EsqueciSenhaRequest(conta.email()), MensagemDto.class);
        String token = tokenAbertoDe(conta.userId()).orElseThrow().getToken();

        ResponseEntity<ApiErrorResponse> resposta = restTemplate.postForEntity("/api/auth/redefinir-senha",
                new RedefinirSenhaRequest(token, "fraca", "fraca"), ApiErrorResponse.class);

        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(resposta.getBody()).isNotNull();
        assertThat(resposta.getBody().erro()).isEqualTo("REQUISICAO_INVALIDA");

        ResponseEntity<LoginResponseDto> loginComSenhaOriginal = restTemplate.postForEntity("/api/auth/login",
                new LoginRequest(conta.email(), AuthTestSupport.SENHA_TESTE), LoginResponseDto.class);
        assertThat(loginComSenhaOriginal.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    @Test
    void ac09_novaSolicitacaoInvalidaTokenAnterior() {
        AutenticacaoTeste conta = cadastrarConfirmarELogar();
        restTemplate.postForEntity("/api/auth/esqueci-senha", new EsqueciSenhaRequest(conta.email()), MensagemDto.class);
        String tokenAntigo = tokenAbertoDe(conta.userId()).orElseThrow().getToken();

        restTemplate.postForEntity("/api/auth/esqueci-senha", new EsqueciSenhaRequest(conta.email()), MensagemDto.class);
        String tokenNovo = tokenAbertoDe(conta.userId()).orElseThrow().getToken();

        assertThat(tokenNovo).isNotEqualTo(tokenAntigo);

        ResponseEntity<ApiErrorResponse> comTokenAntigo = restTemplate.postForEntity("/api/auth/redefinir-senha",
                new RedefinirSenhaRequest(tokenAntigo, NOVA_SENHA_FORTE, NOVA_SENHA_FORTE), ApiErrorResponse.class);
        assertThat(comTokenAntigo.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);

        ResponseEntity<MensagemDto> comTokenNovo = restTemplate.postForEntity("/api/auth/redefinir-senha",
                new RedefinirSenhaRequest(tokenNovo, NOVA_SENHA_FORTE, NOVA_SENHA_FORTE), MensagemDto.class);
        assertThat(comTokenNovo.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    // ---- helpers ----

    private String novoEmail() {
        return "esqueci-senha-" + UUID.randomUUID() + "@scaleup.dev";
    }

    private AutenticacaoTeste cadastrarConfirmarELogar() {
        return AuthTestSupport.cadastrarConfirmarELogar(restTemplate, appUserRepository, tokenConfirmacaoRepository);
    }

    private java.util.Optional<TokenRecuperacaoSenha> tokenAbertoDe(UUID userId) {
        return tokenRecuperacaoRepository.findByUserIdAndConsumidoEmIsNullAndInvalidadoEmIsNull(userId);
    }
}
