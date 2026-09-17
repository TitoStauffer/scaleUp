package com.scaleup.studyplatform.identity.api;

import jakarta.validation.Valid;

import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.scaleup.studyplatform.identity.application.AlterarSenhaService;
import com.scaleup.studyplatform.identity.application.AtualizarPerfilService;
import com.scaleup.studyplatform.identity.application.ConsultarEstatisticasPerfilService;
import com.scaleup.studyplatform.identity.application.ConsultarUsuarioAtualService;
import com.scaleup.studyplatform.identity.application.FotoPerfilService;
import com.scaleup.studyplatform.identity.application.dto.AlterarSenhaRequest;
import com.scaleup.studyplatform.identity.application.dto.AtualizarPerfilRequest;
import com.scaleup.studyplatform.identity.application.dto.EstatisticasPerfilDto;
import com.scaleup.studyplatform.identity.application.dto.MensagemDto;
import com.scaleup.studyplatform.identity.application.dto.UsuarioAtualDto;

/**
 * `GET /usuarios/atual`: permite ao cliente descobrir o `userId` da conta autenticada pelo
 * JWT da requisição (ver {@link com.scaleup.studyplatform.identity.application.CurrentUserProvider}),
 * necessário para consumir os endpoints `/usuarios/{userId}/...` de Progress. Contrato
 * observável preservado por TICKET-autenticacao.md (AC-09): mesmo endpoint, agora resolvendo
 * usuário real em vez do registro fixo semeado por V24 (removido por V33).
 *
 * `POST /usuarios/atual/senha` (TICKET-alterar-senha.md), `PUT /usuarios/atual/perfil`,
 * `POST|GET|DELETE /usuarios/atual/foto` e `GET /usuarios/atual/perfil/estatisticas`
 * (TICKET-perfil-usuario.md): já protegidos por JWT como qualquer outra rota fora de
 * `/api/auth/**` (SecurityConfig), sem configuração adicional.
 */
@RestController
@RequestMapping("/api")
public class UsuarioController {

    private final ConsultarUsuarioAtualService consultarUsuarioAtualService;
    private final AlterarSenhaService alterarSenhaService;
    private final AtualizarPerfilService atualizarPerfilService;
    private final FotoPerfilService fotoPerfilService;
    private final ConsultarEstatisticasPerfilService consultarEstatisticasPerfilService;

    public UsuarioController(ConsultarUsuarioAtualService consultarUsuarioAtualService,
            AlterarSenhaService alterarSenhaService, AtualizarPerfilService atualizarPerfilService,
            FotoPerfilService fotoPerfilService, ConsultarEstatisticasPerfilService consultarEstatisticasPerfilService) {
        this.consultarUsuarioAtualService = consultarUsuarioAtualService;
        this.alterarSenhaService = alterarSenhaService;
        this.atualizarPerfilService = atualizarPerfilService;
        this.fotoPerfilService = fotoPerfilService;
        this.consultarEstatisticasPerfilService = consultarEstatisticasPerfilService;
    }

    @GetMapping("/usuarios/atual")
    public UsuarioAtualDto usuarioAtual() {
        return consultarUsuarioAtualService.consultar();
    }

    @PostMapping("/usuarios/atual/senha")
    public MensagemDto alterarSenha(@Valid @RequestBody AlterarSenhaRequest request) {
        return alterarSenhaService.alterar(request);
    }

    @PutMapping("/usuarios/atual/perfil")
    public UsuarioAtualDto atualizarPerfil(@RequestBody AtualizarPerfilRequest request) {
        return atualizarPerfilService.atualizar(request);
    }

    @PostMapping("/usuarios/atual/foto")
    public MensagemDto atualizarFoto(@RequestParam("arquivo") MultipartFile arquivo) {
        fotoPerfilService.atualizar(arquivo);
        return new MensagemDto("foto de perfil atualizada com sucesso");
    }

    @GetMapping("/usuarios/atual/foto")
    public ResponseEntity<byte[]> foto() {
        FotoPerfilService.FotoPerfil foto = fotoPerfilService.consultar();
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(foto.contentType()))
                .header(HttpHeaders.CACHE_CONTROL, "no-store")
                .body(foto.bytes());
    }

    @DeleteMapping("/usuarios/atual/foto")
    public MensagemDto removerFoto() {
        fotoPerfilService.remover();
        return new MensagemDto("foto de perfil removida com sucesso");
    }

    @GetMapping("/usuarios/atual/perfil/estatisticas")
    public EstatisticasPerfilDto estatisticas() {
        return consultarEstatisticasPerfilService.consultar();
    }
}
