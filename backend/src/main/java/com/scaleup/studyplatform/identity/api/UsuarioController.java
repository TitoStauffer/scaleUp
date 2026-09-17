package com.scaleup.studyplatform.identity.api;

import jakarta.validation.Valid;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.scaleup.studyplatform.identity.application.AlterarSenhaService;
import com.scaleup.studyplatform.identity.application.ConsultarUsuarioAtualService;
import com.scaleup.studyplatform.identity.application.dto.AlterarSenhaRequest;
import com.scaleup.studyplatform.identity.application.dto.MensagemDto;
import com.scaleup.studyplatform.identity.application.dto.UsuarioAtualDto;

/**
 * `GET /usuarios/atual`: permite ao cliente descobrir o `userId` da conta autenticada pelo
 * JWT da requisição (ver {@link com.scaleup.studyplatform.identity.application.CurrentUserProvider}),
 * necessário para consumir os endpoints `/usuarios/{userId}/...` de Progress. Contrato
 * observável preservado por TICKET-autenticacao.md (AC-09): mesmo endpoint, agora resolvendo
 * usuário real em vez do registro fixo semeado por V24 (removido por V33).
 *
 * `POST /usuarios/atual/senha` (TICKET-alterar-senha.md): já protegido por JWT como qualquer
 * outra rota fora de `/api/auth/**` (SecurityConfig), sem configuração adicional.
 */
@RestController
@RequestMapping("/api")
public class UsuarioController {

    private final ConsultarUsuarioAtualService consultarUsuarioAtualService;
    private final AlterarSenhaService alterarSenhaService;

    public UsuarioController(ConsultarUsuarioAtualService consultarUsuarioAtualService,
            AlterarSenhaService alterarSenhaService) {
        this.consultarUsuarioAtualService = consultarUsuarioAtualService;
        this.alterarSenhaService = alterarSenhaService;
    }

    @GetMapping("/usuarios/atual")
    public UsuarioAtualDto usuarioAtual() {
        return consultarUsuarioAtualService.consultar();
    }

    @PostMapping("/usuarios/atual/senha")
    public MensagemDto alterarSenha(@Valid @RequestBody AlterarSenhaRequest request) {
        return alterarSenhaService.alterar(request);
    }
}
