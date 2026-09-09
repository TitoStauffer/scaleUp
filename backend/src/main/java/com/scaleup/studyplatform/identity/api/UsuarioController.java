package com.scaleup.studyplatform.identity.api;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.scaleup.studyplatform.identity.application.ConsultarUsuarioAtualService;
import com.scaleup.studyplatform.identity.application.dto.UsuarioAtualDto;

/**
 * `GET /usuarios/atual`: permite ao cliente descobrir o `userId` da conta autenticada pelo
 * JWT da requisição (ver {@link com.scaleup.studyplatform.identity.application.CurrentUserProvider}),
 * necessário para consumir os endpoints `/usuarios/{userId}/...` de Progress. Contrato
 * observável preservado por TICKET-autenticacao.md (AC-09): mesmo endpoint, agora resolvendo
 * usuário real em vez do registro fixo semeado por V24 (removido por V33).
 */
@RestController
@RequestMapping("/api")
public class UsuarioController {

    private final ConsultarUsuarioAtualService consultarUsuarioAtualService;

    public UsuarioController(ConsultarUsuarioAtualService consultarUsuarioAtualService) {
        this.consultarUsuarioAtualService = consultarUsuarioAtualService;
    }

    @GetMapping("/usuarios/atual")
    public UsuarioAtualDto usuarioAtual() {
        return consultarUsuarioAtualService.consultar();
    }
}
