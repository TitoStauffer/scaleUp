package com.scaleup.studyplatform.identity.application;

import java.time.Instant;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.identity.application.dto.ConfirmarRequest;
import com.scaleup.studyplatform.identity.application.dto.MensagemDto;
import com.scaleup.studyplatform.identity.domain.AppUser;
import com.scaleup.studyplatform.identity.domain.TokenConfirmacaoCadastro;
import com.scaleup.studyplatform.identity.infra.AppUserRepository;
import com.scaleup.studyplatform.identity.infra.TokenConfirmacaoCadastroRepository;

/** POST /api/auth/confirmar (ticket, seção 5). */
@Service
public class ConfirmarCadastroService {

    static final String MENSAGEM_JA_CONFIRMADA = "conta já confirmada, você já pode fazer login";
    static final String MENSAGEM_SUCESSO = "conta confirmada com sucesso, você já pode fazer login";

    private final AppUserRepository appUserRepository;
    private final TokenConfirmacaoCadastroRepository tokenRepository;

    public ConfirmarCadastroService(AppUserRepository appUserRepository,
            TokenConfirmacaoCadastroRepository tokenRepository) {
        this.appUserRepository = appUserRepository;
        this.tokenRepository = tokenRepository;
    }

    @Transactional
    public MensagemDto confirmar(ConfirmarRequest request) {
        String email = request.email().trim().toLowerCase();
        AppUser conta = appUserRepository.findByEmail(email)
                // Não revela se o e-mail existe: trata como token inválido, mesma família de
                // erro que "token errado" (AC-04) — sem inventar um novo caso de resposta.
                .orElseThrow(() -> new TokenInvalidoException("token inválido"));

        // AC-13: idempotente para conta já ativa, independente do token informado.
        if (conta.isAtiva()) {
            return new MensagemDto(MENSAGEM_JA_CONFIRMADA);
        }

        TokenConfirmacaoCadastro tokenAberto = tokenRepository
                .findByUserIdAndConsumidoEmIsNullAndInvalidadoEmIsNull(conta.getId())
                .orElseThrow(() -> new TokenInvalidoException("token inválido"));

        if (!tokenAberto.getToken().equals(request.token())) {
            // AC-04: token errado não invalida o token original, que continua válido até
            // expirar ou ser reenviado.
            throw new TokenInvalidoException("token inválido");
        }

        if (tokenAberto.isExpirado(Instant.now())) {
            // AC-05: erro específico, distinto de "token inválido" — orienta reenvio.
            throw new TokenExpiradoException("token expirado, solicite o reenvio de um novo token");
        }

        tokenAberto.consumir();
        conta.ativar();
        return new MensagemDto(MENSAGEM_SUCESSO);
    }
}
