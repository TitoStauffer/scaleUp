package com.scaleup.studyplatform.identity.application;

import java.time.LocalDate;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.identity.application.dto.AtualizarPerfilRequest;
import com.scaleup.studyplatform.identity.application.dto.UsuarioAtualDto;
import com.scaleup.studyplatform.identity.domain.AppUser;

/** PUT /api/usuarios/atual/perfil (TICKET-perfil-usuario.md, seção 6.1). */
@Service
public class AtualizarPerfilService {

    private static final int NOME_TAMANHO_MAXIMO = 120;

    private final CurrentUserProvider currentUserProvider;

    public AtualizarPerfilService(CurrentUserProvider currentUserProvider) {
        this.currentUserProvider = currentUserProvider;
    }

    @Transactional
    public UsuarioAtualDto atualizar(AtualizarPerfilRequest request) {
        AppUser conta = currentUserProvider.getCurrentUser();

        String nome = request.nome();
        if (nome != null) {
            // AC-02: string vazia/só espaços é rejeitada; null é permitido (limpa o campo).
            if (nome.isBlank()) {
                throw new IllegalArgumentException("nome não pode ser vazio");
            }
            if (nome.length() > NOME_TAMANHO_MAXIMO) {
                throw new IllegalArgumentException("nome excede o tamanho máximo de " + NOME_TAMANHO_MAXIMO
                        + " caracteres");
            }
        }

        LocalDate dataNascimento = request.dataNascimento();
        // AC-04: apenas checagem de sanidade (evita erro óbvio de digitação), não é regra de
        // negócio nova — data de nascimento não tem nenhum efeito além de exibição (seção 5.2).
        if (dataNascimento != null && dataNascimento.isAfter(LocalDate.now())) {
            throw new IllegalArgumentException("data de nascimento não pode estar no futuro");
        }

        conta.atualizarNome(nome);
        conta.atualizarDataNascimento(dataNascimento);
        return ConsultarUsuarioAtualService.mapear(conta);
    }
}
