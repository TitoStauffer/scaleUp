package com.scaleup.studyplatform.identity.application;

import java.time.Instant;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.identity.application.dto.MensagemDto;
import com.scaleup.studyplatform.identity.application.dto.RedefinirSenhaRequest;
import com.scaleup.studyplatform.identity.domain.AppUser;
import com.scaleup.studyplatform.identity.domain.TokenRecuperacaoSenha;
import com.scaleup.studyplatform.identity.infra.AppUserRepository;
import com.scaleup.studyplatform.identity.infra.TokenRecuperacaoSenhaRepository;

/** POST /api/auth/redefinir-senha (TICKET-esqueci-minha-senha.md, seção 4 e 9). */
@Service
public class RedefinirSenhaService {

    static final String MENSAGEM_SUCESSO = "senha redefinida com sucesso, faça login";
    private static final String MENSAGEM_TOKEN_INVALIDO = "token inválido, expirado ou já utilizado";

    private final AppUserRepository appUserRepository;
    private final TokenRecuperacaoSenhaRepository tokenRepository;
    private final PasswordValidator passwordValidator;
    private final PasswordEncoder passwordEncoder;
    private final RateLimiter rateLimiter;

    public RedefinirSenhaService(AppUserRepository appUserRepository, TokenRecuperacaoSenhaRepository tokenRepository,
            PasswordValidator passwordValidator, PasswordEncoder passwordEncoder, RateLimiter rateLimiter) {
        this.appUserRepository = appUserRepository;
        this.tokenRepository = tokenRepository;
        this.passwordValidator = passwordValidator;
        this.passwordEncoder = passwordEncoder;
        this.rateLimiter = rateLimiter;
    }

    @Transactional
    public MensagemDto redefinir(RedefinirSenhaRequest request) {
        rateLimiter.registrarTentativa("redefinir-senha:" + request.token());

        TokenRecuperacaoSenha token = tokenRepository.findByToken(request.token())
                // AC-07: token inexistente — mesmo erro genérico dos demais casos.
                .orElseThrow(() -> new TokenRecuperacaoInvalidoException(MENSAGEM_TOKEN_INVALIDO));

        // AC-06: token já consumido ou invalidado por uma solicitação mais recente.
        if (!token.isAberto()) {
            throw new TokenRecuperacaoInvalidoException(MENSAGEM_TOKEN_INVALIDO);
        }
        // AC-05: expirado, mesmo erro genérico (não distinto de "inválido", diferente do
        // token de confirmação de cadastro — ver ticket, seção 9: "sem revelar mais detalhes").
        if (token.isExpirado(Instant.now())) {
            throw new TokenRecuperacaoInvalidoException(MENSAGEM_TOKEN_INVALIDO);
        }

        if (!request.novaSenha().equals(request.confirmacaoNovaSenha())) {
            throw new IllegalArgumentException("nova senha e confirmação de nova senha não coincidem");
        }
        passwordValidator.validar(request.novaSenha());

        AppUser conta = appUserRepository.findById(token.getUserId())
                .orElseThrow(() -> new TokenRecuperacaoInvalidoException(MENSAGEM_TOKEN_INVALIDO));

        conta.redefinirSenhaHash(passwordEncoder.encode(request.novaSenha()));
        token.consumir();
        return new MensagemDto(MENSAGEM_SUCESSO);
    }
}
