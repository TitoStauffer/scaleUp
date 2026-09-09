package com.scaleup.studyplatform.identity.application;

import java.util.UUID;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.identity.domain.AppUser;
import com.scaleup.studyplatform.identity.infra.AppUserRepository;

/**
 * Resolve "o usuário atual" a partir do contexto de segurança da requisição (TICKET-autenticacao.md).
 *
 * Antes desta tarefa, resolvia sempre o mesmo registro fixo semeado por
 * V24__seed_usuario_local.sql (removido por V33). Agora o id do usuário vem do JWT validado
 * por {@link com.scaleup.studyplatform.shared.security.JwtAuthenticationFilter}, que popula o
 * {@link SecurityContextHolder} com o id como principal da {@link Authentication}.
 *
 * Contrato observável preservado (AC-12): Study, Assessment e Progress continuam dependendo
 * só de {@link #getCurrentUserId()}/{@link #getCurrentUser()} — nenhum desses módulos precisou
 * mudar por causa desta substituição.
 */
@Service
public class CurrentUserProvider {

    private final AppUserRepository appUserRepository;

    public CurrentUserProvider(AppUserRepository appUserRepository) {
        this.appUserRepository = appUserRepository;
    }

    public UUID getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()
                || !(authentication.getPrincipal() instanceof UUID userId)) {
            throw new IllegalStateException(
                    "Nenhum usuário autenticado no contexto de segurança — rota deveria estar protegida.");
        }
        return userId;
    }

    @Transactional(readOnly = true)
    public AppUser getCurrentUser() {
        UUID userId = getCurrentUserId();
        return appUserRepository.findById(userId)
                .orElseThrow(() -> new IllegalStateException(
                        "Usuário autenticado (" + userId + ") não encontrado — conta removida após emissão do JWT?"));
    }
}
