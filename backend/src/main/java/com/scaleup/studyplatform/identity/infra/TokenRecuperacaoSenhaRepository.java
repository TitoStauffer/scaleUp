package com.scaleup.studyplatform.identity.infra;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.scaleup.studyplatform.identity.domain.TokenRecuperacaoSenha;

public interface TokenRecuperacaoSenhaRepository extends JpaRepository<TokenRecuperacaoSenha, UUID> {

    /**
     * No máximo um resultado por conta, garantido pelo índice único parcial
     * {@code ux_token_recuperacao_aberto_por_conta} (V49) — "em aberto" significa nem
     * consumido, nem invalidado (independentemente de já ter expirado por tempo).
     */
    Optional<TokenRecuperacaoSenha> findByUserIdAndConsumidoEmIsNullAndInvalidadoEmIsNull(UUID userId);

    Optional<TokenRecuperacaoSenha> findByToken(String token);
}
