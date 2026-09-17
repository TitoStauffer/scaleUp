package com.scaleup.studyplatform.identity.application;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.identity.application.dto.UsuarioAtualDto;
import com.scaleup.studyplatform.identity.domain.AppUser;

/**
 * GET /usuarios/atual: expõe o único usuário local do MVP para que o cliente descubra o
 * `userId` sem hardcode (sem isso não há como consumir `/usuarios/{userId}/...` na prática).
 */
@Service
public class ConsultarUsuarioAtualService {

    private final CurrentUserProvider currentUserProvider;

    public ConsultarUsuarioAtualService(CurrentUserProvider currentUserProvider) {
        this.currentUserProvider = currentUserProvider;
    }

    @Transactional(readOnly = true)
    public UsuarioAtualDto consultar() {
        return mapear(currentUserProvider.getCurrentUser());
    }

    static UsuarioAtualDto mapear(AppUser usuario) {
        return new UsuarioAtualDto(usuario.getId(), usuario.getNome(), usuario.getEmail(), usuario.getDataNascimento(),
                usuario.temFotoPerfil());
    }
}
