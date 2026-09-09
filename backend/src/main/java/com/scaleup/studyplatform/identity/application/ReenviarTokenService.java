package com.scaleup.studyplatform.identity.application;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.identity.application.dto.MensagemDto;
import com.scaleup.studyplatform.identity.application.dto.ReenviarRequest;
import com.scaleup.studyplatform.identity.domain.AppUser;
import com.scaleup.studyplatform.identity.domain.TokenConfirmacaoCadastro;
import com.scaleup.studyplatform.identity.infra.AppUserRepository;
import com.scaleup.studyplatform.identity.infra.TokenConfirmacaoCadastroRepository;

/**
 * POST /api/auth/reenviar-token (ticket, seção 6). Transacional: invalidar o token anterior e
 * inserir o novo precisa acontecer atomicamente por causa do índice único parcial
 * {@code ux_token_confirmacao_aberto_por_conta} (V34) — se a invalidação e o insert não
 * estiverem na mesma transação, uma falha entre os dois passos deixaria a conta sem nenhum
 * token em aberto (nem o antigo, nem um novo), impedindo qualquer confirmação futura sem
 * intervenção manual.
 */
@Service
public class ReenviarTokenService {

    static final String MENSAGEM_JA_CONFIRMADA = "conta já confirmada, você já pode fazer login";
    static final String MENSAGEM_REENVIADO = "se a conta existir e estiver pendente, um novo token foi enviado";

    private final AppUserRepository appUserRepository;
    private final TokenConfirmacaoCadastroRepository tokenRepository;
    private final EmailSender emailSender;
    private final RateLimiter rateLimiter;
    private final TokenConfirmacaoFactory tokenFactory;

    public ReenviarTokenService(AppUserRepository appUserRepository, TokenConfirmacaoCadastroRepository tokenRepository,
            EmailSender emailSender, RateLimiter rateLimiter, TokenConfirmacaoFactory tokenFactory) {
        this.appUserRepository = appUserRepository;
        this.tokenRepository = tokenRepository;
        this.emailSender = emailSender;
        this.rateLimiter = rateLimiter;
        this.tokenFactory = tokenFactory;
    }

    @Transactional
    public MensagemDto reenviar(ReenviarRequest request) {
        String email = request.email().trim().toLowerCase();
        rateLimiter.registrarTentativa("reenvio:" + email);

        return appUserRepository.findByEmail(email)
                .map(conta -> {
                    if (conta.isAtiva()) {
                        // AC-14: idempotente, sem enviar e-mail.
                        return new MensagemDto(MENSAGEM_JA_CONFIRMADA);
                    }
                    // flush explícito: por padrão o Hibernate executa INSERTs antes de UPDATEs
                    // na mesma transação, na ordem de flush — sem forçar o UPDATE de
                    // invalidação a acontecer antes, o INSERT do token novo colidiria com o
                    // índice único parcial (2 tokens "em aberto" simultâneos para a mesma
                    // conta, mesmo que só por um instante dentro da mesma transação).
                    tokenRepository.findByUserIdAndConsumidoEmIsNullAndInvalidadoEmIsNull(conta.getId())
                            .ifPresent(tokenAberto -> {
                                tokenAberto.invalidar();
                                tokenRepository.saveAndFlush(tokenAberto);
                            });
                    gerarEEnviarToken(conta);
                    return new MensagemDto(MENSAGEM_REENVIADO);
                })
                // Anti-enumeração: e-mail inexistente responde a mesma mensagem genérica de
                // "reenviado", sem criar nada nem enviar e-mail nenhum.
                .orElseGet(() -> new MensagemDto(MENSAGEM_REENVIADO));
    }

    private void gerarEEnviarToken(AppUser conta) {
        TokenConfirmacaoCadastro token = tokenFactory.novoToken(conta.getId());
        tokenRepository.save(token);
        emailSender.enviarTokenConfirmacao(conta.getEmail(), token.getToken());
    }
}
