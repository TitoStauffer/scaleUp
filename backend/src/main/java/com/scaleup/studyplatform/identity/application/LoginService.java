package com.scaleup.studyplatform.identity.application;

import java.time.Instant;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.identity.application.dto.LoginRequest;
import com.scaleup.studyplatform.identity.application.dto.LoginResponseDto;
import com.scaleup.studyplatform.identity.domain.AppUser;
import com.scaleup.studyplatform.identity.infra.AppUserRepository;
import com.scaleup.studyplatform.shared.security.JwtService;

/** POST /api/auth/login (ticket, seção 7). */
@Service
public class LoginService {

    static final String MENSAGEM_CREDENCIAIS_INVALIDAS = "e-mail ou senha inválidos";
    static final String MENSAGEM_CONTA_NAO_CONFIRMADA =
            "confirme seu cadastro antes de entrar; solicite o reenvio do token de confirmação se necessário";

    private final AppUserRepository appUserRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final RateLimiter rateLimiter;

    public LoginService(AppUserRepository appUserRepository, PasswordEncoder passwordEncoder, JwtService jwtService,
            RateLimiter rateLimiter) {
        this.appUserRepository = appUserRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.rateLimiter = rateLimiter;
    }

    @Transactional(readOnly = true)
    public LoginResponseDto login(LoginRequest request) {
        String email = request.email().trim().toLowerCase();
        rateLimiter.registrarTentativa("login:" + email);

        AppUser conta = appUserRepository.findByEmail(email)
                // AC-08: e-mail não encontrado usa a MESMA mensagem de senha incorreta.
                .orElseThrow(() -> new CredenciaisInvalidasException(MENSAGEM_CREDENCIAIS_INVALIDAS));

        if (conta.getSenhaHash() == null || !passwordEncoder.matches(request.senha(), conta.getSenhaHash())) {
            throw new CredenciaisInvalidasException(MENSAGEM_CREDENCIAIS_INVALIDAS);
        }

        if (!conta.isAtiva()) {
            // AC-07: aqui a distinção é intencional — quem chega até aqui já provou a senha.
            throw new ContaNaoConfirmadaException(MENSAGEM_CONTA_NAO_CONFIRMADA);
        }

        Instant agora = Instant.now();
        String token = jwtService.gerarToken(conta.getId());
        return new LoginResponseDto(token, "Bearer", jwtService.calcularExpiracao(agora));
    }
}
