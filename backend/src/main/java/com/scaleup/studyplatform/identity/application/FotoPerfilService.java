package com.scaleup.studyplatform.identity.application;

import java.io.IOException;
import java.io.UncheckedIOException;
import java.util.Set;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.scaleup.studyplatform.identity.domain.AppUser;
import com.scaleup.studyplatform.shared.RecursoNaoEncontradoException;

/** POST/GET/DELETE /api/usuarios/atual/foto (TICKET-perfil-usuario.md, seção 6.2). */
@Service
public class FotoPerfilService {

    static final int TAMANHO_MAXIMO_BYTES = 2 * 1024 * 1024;
    static final Set<String> TIPOS_ACEITOS = Set.of("image/jpeg", "image/png", "image/webp");

    private final CurrentUserProvider currentUserProvider;

    public FotoPerfilService(CurrentUserProvider currentUserProvider) {
        this.currentUserProvider = currentUserProvider;
    }

    @Transactional
    public void atualizar(MultipartFile arquivo) {
        if (arquivo == null || arquivo.isEmpty()) {
            throw new IllegalArgumentException("nenhum arquivo enviado");
        }

        String contentType = arquivo.getContentType();
        // AC-08: tipo de arquivo checado antes do tamanho — um GIF de 10MB deve ser rejeitado
        // pelo tipo, não pelo tamanho (mensagem mais específica para o usuário).
        if (contentType == null || !TIPOS_ACEITOS.contains(contentType)) {
            throw new TipoArquivoNaoSuportadoException(
                    "tipo de arquivo não suportado, use image/jpeg, image/png ou image/webp");
        }
        if (arquivo.getSize() > TAMANHO_MAXIMO_BYTES) {
            throw new ArquivoMuitoGrandeException("arquivo excede o limite de 2MB");
        }

        byte[] bytes;
        try {
            bytes = arquivo.getBytes();
        } catch (IOException e) {
            throw new UncheckedIOException("falha ao ler o arquivo de foto enviado", e);
        }

        AppUser conta = currentUserProvider.getCurrentUser();
        conta.definirFotoPerfil(bytes, contentType);
    }

    @Transactional(readOnly = true)
    public FotoPerfil consultar() {
        AppUser conta = currentUserProvider.getCurrentUser();
        if (!conta.temFotoPerfil()) {
            throw new RecursoNaoEncontradoException("conta não possui foto de perfil");
        }
        return new FotoPerfil(conta.getFotoPerfil(), conta.getFotoPerfilContentType());
    }

    @Transactional
    public void remover() {
        AppUser conta = currentUserProvider.getCurrentUser();
        if (!conta.temFotoPerfil()) {
            throw new RecursoNaoEncontradoException("conta não possui foto de perfil");
        }
        conta.removerFotoPerfil();
    }

    public record FotoPerfil(byte[] bytes, String contentType) {
    }
}
