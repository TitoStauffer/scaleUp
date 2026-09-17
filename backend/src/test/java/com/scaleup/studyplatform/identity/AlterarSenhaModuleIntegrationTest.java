package com.scaleup.studyplatform.identity;

import static org.assertj.core.api.Assertions.assertThat;

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
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import com.scaleup.studyplatform.identity.application.dto.AlterarSenhaRequest;
import com.scaleup.studyplatform.identity.application.dto.LoginRequest;
import com.scaleup.studyplatform.identity.application.dto.LoginResponseDto;
import com.scaleup.studyplatform.identity.application.dto.MensagemDto;
import com.scaleup.studyplatform.identity.infra.AppUserRepository;
import com.scaleup.studyplatform.identity.infra.TokenConfirmacaoCadastroRepository;
import com.scaleup.studyplatform.shared.ApiErrorResponse;
import com.scaleup.studyplatform.support.AuthTestSupport;
import com.scaleup.studyplatform.support.AutenticacaoTeste;

/**
 * Teste de integração ponta a ponta de POST /api/usuarios/atual/senha, cobrindo os 9
 * critérios de aceite de TICKET-alterar-senha.md, seção 10 (AC-01 a AC-09).
 *
 * Não usa {@link AuthTestSupport#configurarAuthorizationHeaderPadrao} (interceptor global no
 * {@link TestRestTemplate}): como o contexto Spring — e o bean de {@code TestRestTemplate} —
 * é reaproveitado entre os métodos desta classe, um interceptor registrado por um teste
 * continuaria ativo (empilhado com o de outros testes) nos testes seguintes, corrompendo o
 * header Authorization. Cada requisição autenticada aqui informa o JWT explicitamente via
 * {@code exchange}.
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureTestRestTemplate
@Testcontainers
class AlterarSenhaModuleIntegrationTest {

    @Container
    @ServiceConnection
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");

    private static final String NOVA_SENHA_FORTE = "OutraSenha456!@#";

    @Autowired
    private TestRestTemplate restTemplate;

    @Autowired
    private AppUserRepository appUserRepository;

    @Autowired
    private TokenConfirmacaoCadastroRepository tokenRepository;

    @Test
    void ac01_alterarSenhaComSenhaAtualCorretaEnovaSenhaValidaAtualizaEPermiteLoginComNova() {
        AutenticacaoTeste conta = autenticar();

        ResponseEntity<MensagemDto> resposta = alterarSenha(conta.jwt(), AuthTestSupport.SENHA_TESTE, NOVA_SENHA_FORTE,
                NOVA_SENHA_FORTE, MensagemDto.class);

        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.OK);

        ResponseEntity<LoginResponseDto> login = restTemplate.postForEntity("/api/auth/login",
                new LoginRequest(conta.email(), NOVA_SENHA_FORTE), LoginResponseDto.class);
        assertThat(login.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    @Test
    void ac02_alterarSenhaComSenhaAtualIncorretaRejeitaENaoAltera() {
        AutenticacaoTeste conta = autenticar();

        ResponseEntity<ApiErrorResponse> resposta = alterarSenha(conta.jwt(), "SenhaErrada123!", NOVA_SENHA_FORTE,
                NOVA_SENHA_FORTE, ApiErrorResponse.class);

        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);
        assertThat(resposta.getBody()).isNotNull();
        assertThat(resposta.getBody().erro()).isEqualTo("SENHA_ATUAL_INCORRETA");
    }

    @Test
    void ac03_alterarSenhaComNovaSenhaFracaRejeita() {
        AutenticacaoTeste conta = autenticar();

        ResponseEntity<ApiErrorResponse> resposta = alterarSenha(conta.jwt(), AuthTestSupport.SENHA_TESTE, "fraca",
                "fraca", ApiErrorResponse.class);

        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(resposta.getBody()).isNotNull();
        assertThat(resposta.getBody().erro()).isEqualTo("REQUISICAO_INVALIDA");
    }

    @Test
    void ac04_alterarSenhaComConfirmacaoNaoCoincidenteRejeita() {
        AutenticacaoTeste conta = autenticar();

        ResponseEntity<ApiErrorResponse> resposta = alterarSenha(conta.jwt(), AuthTestSupport.SENHA_TESTE,
                NOVA_SENHA_FORTE, "OutraCoisa789!@#", ApiErrorResponse.class);

        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(resposta.getBody()).isNotNull();
        assertThat(resposta.getBody().erro()).isEqualTo("REQUISICAO_INVALIDA");
    }

    @Test
    void ac05_alterarSenhaParaMesmoValorDaSenhaAtualRejeita() {
        AutenticacaoTeste conta = autenticar();

        ResponseEntity<ApiErrorResponse> resposta = alterarSenha(conta.jwt(), AuthTestSupport.SENHA_TESTE,
                AuthTestSupport.SENHA_TESTE, AuthTestSupport.SENHA_TESTE, ApiErrorResponse.class);

        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(resposta.getBody()).isNotNull();
        assertThat(resposta.getBody().erro()).isEqualTo("REQUISICAO_INVALIDA");
    }

    @Test
    void ac06_tentativaSemAutenticacaoRetorna401() {
        ResponseEntity<ApiErrorResponse> resposta = restTemplate.postForEntity("/api/usuarios/atual/senha",
                new AlterarSenhaRequest(AuthTestSupport.SENHA_TESTE, NOVA_SENHA_FORTE, NOVA_SENHA_FORTE),
                ApiErrorResponse.class);

        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);
    }

    @Test
    void ac08_sessaoAtualContinuaValidaAposATroca() {
        AutenticacaoTeste conta = autenticar();

        ResponseEntity<MensagemDto> alteracao = alterarSenha(conta.jwt(), AuthTestSupport.SENHA_TESTE, NOVA_SENHA_FORTE,
                NOVA_SENHA_FORTE, MensagemDto.class);
        assertThat(alteracao.getStatusCode()).isEqualTo(HttpStatus.OK);

        // Mesmo JWT de antes da troca continua funcionando em outra rota protegida.
        ResponseEntity<String> usuarioAtual = restTemplate.exchange("/api/usuarios/atual", HttpMethod.GET,
                new HttpEntity<>(autorizacao(conta.jwt())), String.class);
        assertThat(usuarioAtual.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    @Test
    void ac09_alteracaoNaoAfetaOutraConta() {
        AutenticacaoTeste contaA = autenticar();
        AutenticacaoTeste contaB = autenticar();

        ResponseEntity<MensagemDto> resposta = alterarSenha(contaA.jwt(), AuthTestSupport.SENHA_TESTE, NOVA_SENHA_FORTE,
                NOVA_SENHA_FORTE, MensagemDto.class);
        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.OK);

        // Conta A consegue logar com a nova senha; conta B continua com a senha original.
        ResponseEntity<LoginResponseDto> loginA = restTemplate.postForEntity("/api/auth/login",
                new LoginRequest(contaA.email(), NOVA_SENHA_FORTE), LoginResponseDto.class);
        assertThat(loginA.getStatusCode()).isEqualTo(HttpStatus.OK);

        ResponseEntity<LoginResponseDto> loginB = restTemplate.postForEntity("/api/auth/login",
                new LoginRequest(contaB.email(), AuthTestSupport.SENHA_TESTE), LoginResponseDto.class);
        assertThat(loginB.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    private <T> ResponseEntity<T> alterarSenha(String jwt, String senhaAtual, String novaSenha,
            String confirmacaoNovaSenha, Class<T> tipoResposta) {
        return restTemplate.exchange("/api/usuarios/atual/senha", HttpMethod.POST,
                new HttpEntity<>(new AlterarSenhaRequest(senhaAtual, novaSenha, confirmacaoNovaSenha), autorizacao(jwt)),
                tipoResposta);
    }

    private HttpHeaders autorizacao(String jwt) {
        HttpHeaders headers = new HttpHeaders();
        headers.add(HttpHeaders.AUTHORIZATION, "Bearer " + jwt);
        return headers;
    }

    private AutenticacaoTeste autenticar() {
        return AuthTestSupport.cadastrarConfirmarELogar(restTemplate, appUserRepository, tokenRepository);
    }
}
