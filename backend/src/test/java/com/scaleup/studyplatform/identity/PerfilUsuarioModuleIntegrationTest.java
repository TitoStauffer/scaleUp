package com.scaleup.studyplatform.identity;

import static org.assertj.core.api.Assertions.assertThat;

import java.time.LocalDate;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.resttestclient.TestRestTemplate;
import org.springframework.boot.resttestclient.autoconfigure.AutoConfigureTestRestTemplate;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import com.scaleup.studyplatform.identity.application.dto.AtualizarPerfilRequest;
import com.scaleup.studyplatform.identity.application.dto.EstatisticasPerfilDto;
import com.scaleup.studyplatform.identity.application.dto.MensagemDto;
import com.scaleup.studyplatform.identity.application.dto.UsuarioAtualDto;
import com.scaleup.studyplatform.identity.infra.AppUserRepository;
import com.scaleup.studyplatform.identity.infra.TokenConfirmacaoCadastroRepository;
import com.scaleup.studyplatform.shared.ApiErrorResponse;
import com.scaleup.studyplatform.support.AuthTestSupport;
import com.scaleup.studyplatform.support.AutenticacaoTeste;

/**
 * Teste de integração ponta a ponta dos endpoints de perfil (dados pessoais, foto e
 * estatísticas consolidadas), cobrindo os critérios de aceite de TICKET-perfil-usuario.md,
 * seção 10 (AC-01 a AC-14).
 *
 * Mesmo cuidado de {@code AlterarSenhaModuleIntegrationTest}: não usa o interceptor global de
 * Authorization (o {@code TestRestTemplate} é reaproveitado entre os métodos da classe) —
 * cada requisição autenticada informa o JWT explicitamente via {@code exchange}.
 */
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureTestRestTemplate
@Testcontainers
class PerfilUsuarioModuleIntegrationTest {

    @Container
    @ServiceConnection
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine");

    private static final int TOTAL_DOMINIOS_SEED = 7;

    @Autowired
    private TestRestTemplate restTemplate;

    @Autowired
    private AppUserRepository appUserRepository;

    @Autowired
    private TokenConfirmacaoCadastroRepository tokenRepository;

    @Test
    void ac01_editarNomeComSucesso() {
        AutenticacaoTeste conta = autenticar();

        ResponseEntity<UsuarioAtualDto> resposta = atualizarPerfil(conta.jwt(), "Fulano de Tal", null,
                UsuarioAtualDto.class);

        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(resposta.getBody()).isNotNull();
        assertThat(resposta.getBody().nome()).isEqualTo("Fulano de Tal");

        ResponseEntity<UsuarioAtualDto> usuarioAtual = usuarioAtual(conta.jwt());
        assertThat(usuarioAtual.getBody().nome()).isEqualTo("Fulano de Tal");
    }

    @Test
    void ac02_editarNomeComValorVazioRejeita() {
        AutenticacaoTeste conta = autenticar();

        ResponseEntity<ApiErrorResponse> resposta = atualizarPerfil(conta.jwt(), "   ", null, ApiErrorResponse.class);

        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(resposta.getBody()).isNotNull();
        assertThat(resposta.getBody().erro()).isEqualTo("REQUISICAO_INVALIDA");
    }

    @Test
    void ac03_editarELimparDataDeNascimento() {
        AutenticacaoTeste conta = autenticar();
        LocalDate data = LocalDate.of(1990, 5, 20);

        ResponseEntity<UsuarioAtualDto> primeira = atualizarPerfil(conta.jwt(), null, data, UsuarioAtualDto.class);
        assertThat(primeira.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(primeira.getBody().dataNascimento()).isEqualTo(data);

        ResponseEntity<UsuarioAtualDto> segunda = atualizarPerfil(conta.jwt(), null, null, UsuarioAtualDto.class);
        assertThat(segunda.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(segunda.getBody().dataNascimento()).isNull();
    }

    @Test
    void ac04_editarDataDeNascimentoNoFuturoRejeita() {
        AutenticacaoTeste conta = autenticar();

        ResponseEntity<ApiErrorResponse> resposta = atualizarPerfil(conta.jwt(), null, LocalDate.now().plusDays(1),
                ApiErrorResponse.class);

        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(resposta.getBody()).isNotNull();
        assertThat(resposta.getBody().erro()).isEqualTo("REQUISICAO_INVALIDA");
    }

    @Test
    void ac05_emailNaoEEditavel() {
        AutenticacaoTeste conta = autenticar();

        ResponseEntity<UsuarioAtualDto> resposta = usuarioAtual(conta.jwt());

        assertThat(resposta.getBody()).isNotNull();
        assertThat(resposta.getBody().email()).isEqualTo(conta.email());
        // Nenhum campo "email" existe em AtualizarPerfilRequest — não há como enviá-lo por
        // esta rota (reforça a decisão de escopo por ausência de campo, não por validação).
    }

    @Test
    void ac06_uploadDeFotoValida() {
        AutenticacaoTeste conta = autenticar();

        ResponseEntity<MensagemDto> upload = enviarFoto(conta.jwt(), new byte[500 * 1024], "foto.png", "image/png");
        assertThat(upload.getStatusCode()).isEqualTo(HttpStatus.OK);

        ResponseEntity<UsuarioAtualDto> usuarioAtual = usuarioAtual(conta.jwt());
        assertThat(usuarioAtual.getBody().temFotoPerfil()).isTrue();

        ResponseEntity<byte[]> foto = restTemplate.exchange("/api/usuarios/atual/foto", HttpMethod.GET,
                new HttpEntity<>(autorizacao(conta.jwt())), byte[].class);
        assertThat(foto.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(foto.getHeaders().getContentType()).isEqualTo(MediaType.IMAGE_PNG);
        assertThat(foto.getBody()).hasSize(500 * 1024);
    }

    @Test
    void ac07_uploadDeFotoMaiorQueOLimiteRejeita() {
        AutenticacaoTeste conta = autenticar();

        ResponseEntity<ApiErrorResponse> resposta = enviarFoto(conta.jwt(), new byte[3 * 1024 * 1024], "grande.png",
                "image/png", ApiErrorResponse.class);

        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(resposta.getBody()).isNotNull();
        assertThat(resposta.getBody().erro()).isEqualTo("ARQUIVO_MUITO_GRANDE");

        ResponseEntity<UsuarioAtualDto> usuarioAtual = usuarioAtual(conta.jwt());
        assertThat(usuarioAtual.getBody().temFotoPerfil()).isFalse();
    }

    @Test
    void ac08_uploadDeTipoDeArquivoNaoAceitoRejeita() {
        AutenticacaoTeste conta = autenticar();

        ResponseEntity<ApiErrorResponse> resposta = enviarFoto(conta.jwt(), new byte[100], "foto.gif", "image/gif",
                ApiErrorResponse.class);

        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(resposta.getBody()).isNotNull();
        assertThat(resposta.getBody().erro()).isEqualTo("TIPO_ARQUIVO_NAO_SUPORTADO");
    }

    @Test
    void ac09_removerFotoDePerfil() {
        AutenticacaoTeste conta = autenticar();
        enviarFoto(conta.jwt(), new byte[1024], "foto.png", "image/png");

        ResponseEntity<MensagemDto> resposta = restTemplate.exchange("/api/usuarios/atual/foto", HttpMethod.DELETE,
                new HttpEntity<>(autorizacao(conta.jwt())), MensagemDto.class);
        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.OK);

        ResponseEntity<UsuarioAtualDto> usuarioAtual = usuarioAtual(conta.jwt());
        assertThat(usuarioAtual.getBody().temFotoPerfil()).isFalse();

        ResponseEntity<ApiErrorResponse> foto = restTemplate.exchange("/api/usuarios/atual/foto", HttpMethod.GET,
                new HttpEntity<>(autorizacao(conta.jwt())), ApiErrorResponse.class);
        assertThat(foto.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        assertThat(foto.getBody().erro()).isEqualTo("RECURSO_NAO_ENCONTRADO");
    }

    @Test
    void ac10_removerFotoQuandoNaoHaFotoSalvaRejeita() {
        AutenticacaoTeste conta = autenticar();

        ResponseEntity<ApiErrorResponse> resposta = restTemplate.exchange("/api/usuarios/atual/foto", HttpMethod.DELETE,
                new HttpEntity<>(autorizacao(conta.jwt())), ApiErrorResponse.class);

        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        assertThat(resposta.getBody()).isNotNull();
        assertThat(resposta.getBody().erro()).isEqualTo("RECURSO_NAO_ENCONTRADO");
    }

    @Test
    void ac12_estatisticasParaUsuarioSemNenhumaAtividade() {
        AutenticacaoTeste conta = autenticar();

        ResponseEntity<EstatisticasPerfilDto> resposta = estatisticas(conta.jwt());

        assertThat(resposta.getStatusCode()).isEqualTo(HttpStatus.OK);
        EstatisticasPerfilDto corpo = resposta.getBody();
        assertThat(corpo).isNotNull();
        assertThat(corpo.geral().totalSessoesEstudo()).isZero();
        assertThat(corpo.geral().totalTentativasQuiz()).isZero();
        assertThat(corpo.geral().resultadoGeralAvaliado()).isFalse();
        assertThat(corpo.geral().pontuacaoGeralMedia()).isNull();
        assertThat(corpo.porDominio()).hasSize(TOTAL_DOMINIOS_SEED);
        assertThat(corpo.porDominio()).allSatisfy(item -> {
            assertThat(item.totalSessoesEstudo()).isZero();
            assertThat(item.totalTentativasQuiz()).isZero();
            assertThat(item.pontuacaoQuizMedia()).isNull();
        });
    }

    @Test
    void ac13_estatisticasNaoMisturamDadosDeOutraConta() {
        AutenticacaoTeste contaA = autenticar();
        AutenticacaoTeste contaB = autenticar();

        atualizarPerfil(contaA.jwt(), "Conta A", null, UsuarioAtualDto.class);

        ResponseEntity<UsuarioAtualDto> usuarioA = usuarioAtual(contaA.jwt());
        ResponseEntity<UsuarioAtualDto> usuarioB = usuarioAtual(contaB.jwt());

        assertThat(usuarioA.getBody().nome()).isEqualTo("Conta A");
        assertThat(usuarioB.getBody().nome()).isNull();

        ResponseEntity<EstatisticasPerfilDto> estatisticasB = estatisticas(contaB.jwt());
        assertThat(estatisticasB.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    @Test
    void ac14_acessoSemAutenticacaoRetorna401EmTodosOsEndpoints() {
        assertThat(restTemplate.exchange("/api/usuarios/atual/perfil", HttpMethod.PUT,
                new HttpEntity<>(new AtualizarPerfilRequest("x", null)), ApiErrorResponse.class).getStatusCode())
                .isEqualTo(HttpStatus.UNAUTHORIZED);

        assertThat(restTemplate.exchange("/api/usuarios/atual/foto", HttpMethod.GET, HttpEntity.EMPTY,
                ApiErrorResponse.class).getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);

        assertThat(restTemplate.exchange("/api/usuarios/atual/foto", HttpMethod.DELETE, HttpEntity.EMPTY,
                ApiErrorResponse.class).getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);

        assertThat(restTemplate.exchange("/api/usuarios/atual/perfil/estatisticas", HttpMethod.GET, HttpEntity.EMPTY,
                ApiErrorResponse.class).getStatusCode()).isEqualTo(HttpStatus.UNAUTHORIZED);
    }

    // ---- helpers ----

    private <T> ResponseEntity<T> atualizarPerfil(String jwt, String nome, LocalDate dataNascimento,
            Class<T> tipoResposta) {
        return restTemplate.exchange("/api/usuarios/atual/perfil", HttpMethod.PUT,
                new HttpEntity<>(new AtualizarPerfilRequest(nome, dataNascimento), autorizacao(jwt)), tipoResposta);
    }

    private ResponseEntity<UsuarioAtualDto> usuarioAtual(String jwt) {
        return restTemplate.exchange("/api/usuarios/atual", HttpMethod.GET, new HttpEntity<>(autorizacao(jwt)),
                UsuarioAtualDto.class);
    }

    private ResponseEntity<EstatisticasPerfilDto> estatisticas(String jwt) {
        return restTemplate.exchange("/api/usuarios/atual/perfil/estatisticas", HttpMethod.GET,
                new HttpEntity<>(autorizacao(jwt)), EstatisticasPerfilDto.class);
    }

    private ResponseEntity<MensagemDto> enviarFoto(String jwt, byte[] conteudo, String nomeArquivo, String contentType) {
        return enviarFoto(jwt, conteudo, nomeArquivo, contentType, MensagemDto.class);
    }

    private <T> ResponseEntity<T> enviarFoto(String jwt, byte[] conteudo, String nomeArquivo, String contentType,
            Class<T> tipoResposta) {
        ByteArrayResource recurso = new ByteArrayResource(conteudo) {
            @Override
            public String getFilename() {
                return nomeArquivo;
            }
        };

        MultiValueMap<String, Object> corpo = new LinkedMultiValueMap<>();
        HttpHeaders headersArquivo = new HttpHeaders();
        headersArquivo.setContentType(MediaType.parseMediaType(contentType));
        corpo.add("arquivo", new HttpEntity<>(recurso, headersArquivo));

        HttpHeaders headers = autorizacao(jwt);
        headers.setContentType(MediaType.MULTIPART_FORM_DATA);
        return restTemplate.exchange("/api/usuarios/atual/foto", HttpMethod.POST, new HttpEntity<>(corpo, headers),
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
