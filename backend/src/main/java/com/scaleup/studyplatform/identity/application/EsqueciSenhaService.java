package com.scaleup.studyplatform.identity.application;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.identity.application.dto.EsqueciSenhaRequest;
import com.scaleup.studyplatform.identity.application.dto.MensagemDto;
import com.scaleup.studyplatform.identity.domain.AppUser;
import com.scaleup.studyplatform.identity.domain.TokenRecuperacaoSenha;
import com.scaleup.studyplatform.identity.infra.AppUserRepository;
import com.scaleup.studyplatform.identity.infra.TokenRecuperacaoSenhaRepository;

/**
 * POST /api/auth/esqueci-senha (TICKET-esqueci-minha-senha.md, seção 4). Resposta sempre
 * genérica (seção 5: anti-enumeração mantida, diferente do cadastro) — o chamador nunca
 * descobre se o e-mail existe, está ativo ou pendente.
 */
@Service
public class EsqueciSenhaService {

    static final String MENSAGEM_GENERICA =
            "se este e-mail estiver cadastrado e a conta ativa, você receberá instruções de recuperação em instantes";

    private final AppUserRepository appUserRepository;
    private final TokenRecuperacaoSenhaRepository tokenRepository;
    private final EmailSender emailSender;
    private final RateLimiter rateLimiter;
    private final TokenRecuperacaoFactory tokenFactory;

    public EsqueciSenhaService(AppUserRepository appUserRepository, TokenRecuperacaoSenhaRepository tokenRepository,
            EmailSender emailSender, RateLimiter rateLimiter, TokenRecuperacaoFactory tokenFactory) {
        this.appUserRepository = appUserRepository;
        this.tokenRepository = tokenRepository;
        this.emailSender = emailSender;
        this.rateLimiter = rateLimiter;
        this.tokenFactory = tokenFactory;
    }

    @Transactional
    public MensagemDto solicitar(EsqueciSenhaRequest request) {
        String email = request.email().trim().toLowerCase();
        rateLimiter.registrarTentativa("esqueci-senha:" + email);

        appUserRepository.findByEmail(email)
                // AC-03: conta pendente de confirmação de cadastro não pode logar de qualquer
                // forma — nenhum token de recuperação é emitido, mas a resposta permanece
                // genérica (não revela o estado da conta).
                .filter(AppUser::isAtiva)
                .ifPresent(this::invalidarTokenAbertoEGerarNovo);

        return new MensagemDto(MENSAGEM_GENERICA);
    }

    private void invalidarTokenAbertoEGerarNovo(AppUser conta) {
        // Mesmo cuidado de ordenação de flush já documentado em ReenviarTokenService: o
        // UPDATE de invalidação precisa acontecer antes do INSERT do novo token, por causa do
        // índice único parcial ux_token_recuperacao_aberto_por_conta (V49).
        tokenRepository.findByUserIdAndConsumidoEmIsNullAndInvalidadoEmIsNull(conta.getId())
                .ifPresent(tokenAberto -> {
                    tokenAberto.invalidar();
                    tokenRepository.saveAndFlush(tokenAberto);
                });
        TokenRecuperacaoSenha token = tokenFactory.novoToken(conta.getId());
        tokenRepository.save(token);
        emailSender.enviarTokenRecuperacaoSenha(conta.getEmail(), token.getToken());
    }
}
