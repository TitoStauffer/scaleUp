package com.scaleup.studyplatform.identity.application;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.identity.application.dto.AlterarSenhaRequest;
import com.scaleup.studyplatform.identity.application.dto.MensagemDto;
import com.scaleup.studyplatform.identity.domain.AppUser;

/**
 * POST /api/usuarios/atual/senha (TICKET-alterar-senha.md, seção 4). A conta é sempre
 * resolvida via {@link CurrentUserProvider} (JWT da requisição), nunca por identificador no
 * corpo da requisição — AC-09.
 */
@Service
public class AlterarSenhaService {

    static final String MENSAGEM_SUCESSO = "senha alterada com sucesso";

    private final CurrentUserProvider currentUserProvider;
    private final PasswordEncoder passwordEncoder;
    private final PasswordValidator passwordValidator;
    private final RateLimiter rateLimiter;

    public AlterarSenhaService(CurrentUserProvider currentUserProvider, PasswordEncoder passwordEncoder,
            PasswordValidator passwordValidator, RateLimiter rateLimiter) {
        this.currentUserProvider = currentUserProvider;
        this.passwordEncoder = passwordEncoder;
        this.passwordValidator = passwordValidator;
        this.rateLimiter = rateLimiter;
    }

    @Transactional
    public MensagemDto alterar(AlterarSenhaRequest request) {
        AppUser conta = currentUserProvider.getCurrentUser();
        rateLimiter.registrarTentativa("alterar-senha:" + conta.getId());

        // AC-02: erro específico — quem chega aqui já provou ser dono da conta via JWT
        // (seção 5.2 do ticket), diferente da anti-enumeração de login/cadastro.
        if (conta.getSenhaHash() == null || !passwordEncoder.matches(request.senhaAtual(), conta.getSenhaHash())) {
            throw new SenhaAtualIncorretaException("senha atual incorreta");
        }

        if (!request.novaSenha().equals(request.confirmacaoNovaSenha())) {
            throw new IllegalArgumentException("nova senha e confirmação de nova senha não coincidem");
        }
        if (request.novaSenha().equals(request.senhaAtual())) {
            // AC-05 / seção 5.4: rejeitado como validação de entrada, não como falha de
            // segurança — evita o "não-evento" de trocar por trocar.
            throw new IllegalArgumentException("a nova senha deve ser diferente da senha atual");
        }
        passwordValidator.validar(request.novaSenha());

        conta.redefinirSenhaHash(passwordEncoder.encode(request.novaSenha()));
        return new MensagemDto(MENSAGEM_SUCESSO);
    }
}
