package com.scaleup.studyplatform.identity.infra;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.scaleup.studyplatform.identity.domain.TokenConfirmacaoCadastro;

public interface TokenConfirmacaoCadastroRepository extends JpaRepository<TokenConfirmacaoCadastro, UUID> {

    /**
     * No máximo um resultado por conta, garantido pelo índice único parcial
     * {@code ux_token_confirmacao_aberto_por_conta} (V34) — "em aberto" significa nem
     * consumido, nem invalidado (independentemente de já ter expirado por tempo).
     */
    Optional<TokenConfirmacaoCadastro> findByUserIdAndConsumidoEmIsNullAndInvalidadoEmIsNull(UUID userId);
}
