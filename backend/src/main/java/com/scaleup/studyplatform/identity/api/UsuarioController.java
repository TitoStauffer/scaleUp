package com.scaleup.studyplatform.identity.api;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.scaleup.studyplatform.identity.application.ConsultarUsuarioAtualService;
import com.scaleup.studyplatform.identity.application.dto.UsuarioAtualDto;

/**
 * `GET /usuarios/atual`: permite ao cliente descobrir o `userId` do único usuário local do
 * MVP (sem autenticação real — ver {@link com.scaleup.studyplatform.identity.application.CurrentUserProvider}),
 * necessário para consumir os endpoints `/usuarios/{userId}/...` de Progress.
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
