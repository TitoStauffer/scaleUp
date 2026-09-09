package com.scaleup.studyplatform.support;

import java.util.UUID;

import org.springframework.boot.resttestclient.TestRestTemplate;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import com.scaleup.studyplatform.identity.application.dto.CadastroRequest;
import com.scaleup.studyplatform.identity.application.dto.ConfirmarRequest;
import com.scaleup.studyplatform.identity.application.dto.LoginRequest;
import com.scaleup.studyplatform.identity.application.dto.LoginResponseDto;
import com.scaleup.studyplatform.identity.application.dto.MensagemDto;
import com.scaleup.studyplatform.identity.domain.AppUser;
import com.scaleup.studyplatform.identity.domain.TokenConfirmacaoCadastro;
import com.scaleup.studyplatform.identity.infra.AppUserRepository;
import com.scaleup.studyplatform.identity.infra.TokenConfirmacaoCadastroRepository;

/**
 * Suporte para testes de integração que precisam de um usuário real autenticado (depois de
 * TICKET-autenticacao.md, todas as rotas de conteúdo/estudo/quiz/progresso exigem JWT — ver
 * {@code SecurityConfig}). Em vez de ler o token de confirmação de um e-mail de verdade
 * (não há SMTP real, só o mock que loga — ver {@code LogEmailSender}), o teste lê o token
 * diretamente do banco via {@link TokenConfirmacaoCadastroRepository}, já que ambos rodam no
 * mesmo processo/contexto Spring.
 */
public final class AuthTestSupport {

    public static final String SENHA_TESTE = "Senha123!@#";

    private AuthTestSupport() {
    }

    public static AutenticacaoTeste cadastrarConfirmarELogar(TestRestTemplate restTemplate,
            AppUserRepository appUserRepository, TokenConfirmacaoCadastroRepository tokenRepository) {
        String email = "teste-" + UUID.randomUUID() + "@scaleup.dev";

        ResponseEntity<MensagemDto> cadastro = restTemplate.postForEntity("/api/auth/cadastro",
                new CadastroRequest(email, SENHA_TESTE, SENHA_TESTE), MensagemDto.class);
        if (cadastro.getStatusCode() != HttpStatus.OK) {
            throw new IllegalStateException("Falha ao cadastrar usuário de teste: " + cadastro);
        }

        AppUser conta = appUserRepository.findByEmail(email)
                .orElseThrow(() -> new IllegalStateException("Conta de teste não persistida: " + email));
        TokenConfirmacaoCadastro token = tokenRepository
                .findByUserIdAndConsumidoEmIsNullAndInvalidadoEmIsNull(conta.getId())
                .orElseThrow(() -> new IllegalStateException("Token de confirmação não gerado para: " + email));

        ResponseEntity<MensagemDto> confirmacao = restTemplate.postForEntity("/api/auth/confirmar",
                new ConfirmarRequest(email, token.getToken()), MensagemDto.class);
        if (confirmacao.getStatusCode() != HttpStatus.OK) {
            throw new IllegalStateException("Falha ao confirmar conta de teste: " + confirmacao);
        }

        ResponseEntity<LoginResponseDto> login = restTemplate.postForEntity("/api/auth/login",
                new LoginRequest(email, SENHA_TESTE), LoginResponseDto.class);
        LoginResponseDto corpoLogin = login.getBody();
        if (login.getStatusCode() != HttpStatus.OK || corpoLogin == null) {
            throw new IllegalStateException("Falha ao logar usuário de teste: " + login);
        }

        return new AutenticacaoTeste(conta.getId(), email, corpoLogin.token());
    }

    /**
     * Registra um interceptor que injeta {@code Authorization: Bearer <jwt>} em toda
     * requisição feita por este {@link TestRestTemplate} daqui em diante — permite que os
     * testes existentes continuem chamando {@code restTemplate.getForEntity(...)} sem
     * precisar montar headers manualmente em cada chamada.
     */
    public static void configurarAuthorizationHeaderPadrao(TestRestTemplate restTemplate, String jwt) {
        restTemplate.getRestTemplate().getInterceptors().add((request, body, execution) -> {
            request.getHeaders().add(HttpHeaders.AUTHORIZATION, "Bearer " + jwt);
            return execution.execute(request, body);
        });
    }
}
