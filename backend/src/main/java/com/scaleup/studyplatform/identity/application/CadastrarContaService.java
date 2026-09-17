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
 * POST /api/auth/cadastro (TICKET-cadastro-email-duplicado-visivel.md, seção 4 — revoga o
 * anti-enumeração de cadastro do AC-01 original de TICKET-autenticacao.md). E-mail novo
 * responde com a mensagem genérica de sempre; e-mail já existente responde com um erro
 * específico e visível ({@link EmailJaCadastradoAtivoException} ou
 * {@link EmailJaCadastradoPendenteException}), sem criar conta nem enviar e-mail.
 */
@Service
public class CadastrarContaService {

    static final String MENSAGEM_GENERICA = "se o cadastro foi possível, verifique seu e-mail para confirmar a conta";
    static final String MENSAGEM_EMAIL_JA_CADASTRADO_ATIVO = "este e-mail já possui uma conta ativa, faça login";
    static final String MENSAGEM_EMAIL_JA_CADASTRADO_PENDENTE =
            "este e-mail já possui um cadastro pendente de confirmação, confirme o token recebido ou solicite reenvio";

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
            return new MensagemDto(MENSAGEM_GENERICA);
        }

        // E-mail já existe: erro específico e visível, nenhuma conta nova criada, nenhum
        // e-mail enviado — reenvio de token só ocorre sob demanda explícita do usuário via
        // POST /api/auth/reenviar-token (AC-02/AC-03 do ticket).
        if (existente.get().isAtiva()) {
            throw new EmailJaCadastradoAtivoException(MENSAGEM_EMAIL_JA_CADASTRADO_ATIVO);
        }
        throw new EmailJaCadastradoPendenteException(MENSAGEM_EMAIL_JA_CADASTRADO_PENDENTE);
    }

    private void gerarEEnviarToken(AppUser conta) {
        TokenConfirmacaoCadastro token = tokenFactory.novoToken(conta.getId());
        tokenRepository.save(token);
        emailSender.enviarTokenConfirmacao(conta.getEmail(), token.getToken());
    }
}
