package com.scaleup.studyplatform.identity.application;

import java.util.Optional;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.identity.application.dto.CadastroRequest;
import com.scaleup.studyplatform.identity.application.dto.MensagemDto;
import com.scaleup.studyplatform.identity.domain.AppUser;
import com.scaleup.studyplatform.identity.domain.TokenConfirmacaoCadastro;
import com.scaleup.studyplatform.identity.infra.AppUserRepository;
import com.scaleup.studyplatform.identity.infra.TokenConfirmacaoCadastroRepository;

/**
 * POST /api/auth/cadastro (ticket, seção 4). Resposta sempre genérica (anti-enumeração,
 * AC-01): o chamador nunca descobre pela resposta se o e-mail já existia.
 */
@Service
public class CadastrarContaService {

    static final String MENSAGEM_GENERICA = "se o cadastro foi possível, verifique seu e-mail para confirmar a conta";

    private final AppUserRepository appUserRepository;
    private final TokenConfirmacaoCadastroRepository tokenRepository;
    private final PasswordValidator passwordValidator;
    private final PasswordEncoder passwordEncoder;
    private final EmailSender emailSender;
    private final RateLimiter rateLimiter;
    private final TokenConfirmacaoFactory tokenFactory;

    public CadastrarContaService(AppUserRepository appUserRepository, TokenConfirmacaoCadastroRepository tokenRepository,
            PasswordValidator passwordValidator, PasswordEncoder passwordEncoder, EmailSender emailSender,
            RateLimiter rateLimiter, TokenConfirmacaoFactory tokenFactory) {
        this.appUserRepository = appUserRepository;
        this.tokenRepository = tokenRepository;
        this.passwordValidator = passwordValidator;
        this.passwordEncoder = passwordEncoder;
        this.emailSender = emailSender;
        this.rateLimiter = rateLimiter;
        this.tokenFactory = tokenFactory;
    }

    @Transactional
    public MensagemDto cadastrar(CadastroRequest request) {
        String email = request.email().trim().toLowerCase();
        rateLimiter.registrarTentativa("cadastro:" + email);

        // Validado ANTES de tocar no banco: senha fraca não pode criar conta nem revelar se o
        // e-mail já existia (AC-02 é levantado com erro claro, não com a mensagem genérica).
        if (!request.senha().equals(request.confirmacaoSenha())) {
            throw new IllegalArgumentException("senha e confirmação de senha não coincidem");
        }
        passwordValidator.validar(request.senha());

        Optional<AppUser> existente = appUserRepository.findByEmail(email);
        if (existente.isEmpty()) {
            AppUser novaConta = new AppUser(email, passwordEncoder.encode(request.senha()));
            appUserRepository.save(novaConta);
            appUserRepository.flush();
            gerarEEnviarToken(novaConta);
        } else if (!existente.get().isAtiva()) {
            // E-mail já existe, mas ainda pendente: mesmo comportamento do reenvio (seção 4).
            reenviarTokenParaContaPendente(existente.get());
        }
        // E-mail já existe e está ativo: nenhuma ação, nenhum e-mail — só a mensagem genérica.

        return new MensagemDto(MENSAGEM_GENERICA);
    }

    private void reenviarTokenParaContaPendente(AppUser conta) {
        // Mesmo cuidado de ordenação de flush do ReenviarTokenService: força o UPDATE de
        // invalidação antes do INSERT do novo token, por causa do índice único parcial.
        tokenRepository.findByUserIdAndConsumidoEmIsNullAndInvalidadoEmIsNull(conta.getId())
                .ifPresent(tokenAberto -> {
                    tokenAberto.invalidar();
                    tokenRepository.saveAndFlush(tokenAberto);
                });
        gerarEEnviarToken(conta);
    }

    private void gerarEEnviarToken(AppUser conta) {
        TokenConfirmacaoCadastro token = tokenFactory.novoToken(conta.getId());
        tokenRepository.save(token);
        emailSender.enviarTokenConfirmacao(conta.getEmail(), token.getToken());
    }
}
