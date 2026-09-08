package com.scaleup.studyplatform.identity.application;

import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.identity.domain.AppUser;
import com.scaleup.studyplatform.identity.infra.AppUserRepository;

/**
 * Resolve "o usuário atual" enquanto não existe autenticação real (PRD assume usuário
 * único/local no MVP — ver Identity em database-schema.md e TICKET-assessment-progress.md).
 *
 * Decisão: em vez de inventar um mecanismo de sessão/token fora de escopo, a aplicação
 * resolve sempre o mesmo registro fixo de {@code app_user}, semeado por
 * V24__seed_usuario_local.sql com um e-mail conhecido. Quando autenticação real for
 * implementada, esta classe é o único ponto a trocar (extrair o usuário do contexto de
 * segurança em vez de uma consulta fixa) — nenhum outro módulo depende de como o usuário é
 * resolvido, todos dependem só de {@link #getCurrentUserId()}.
 */
@Service
public class CurrentUserProvider {

    private static final String EMAIL_USUARIO_LOCAL = "local@scaleup.dev";

    private final AppUserRepository appUserRepository;

    public CurrentUserProvider(AppUserRepository appUserRepository) {
        this.appUserRepository = appUserRepository;
    }

    @Transactional(readOnly = true)
    public UUID getCurrentUserId() {
        return getCurrentUser().getId();
    }

    @Transactional(readOnly = true)
    public AppUser getCurrentUser() {
        return appUserRepository.findByEmail(EMAIL_USUARIO_LOCAL)
                .orElseThrow(() -> new IllegalStateException(
                        "Usuário local (" + EMAIL_USUARIO_LOCAL + ") não encontrado — V24 aplicou?"));
    }
}
