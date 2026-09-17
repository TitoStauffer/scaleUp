package com.scaleup.studyplatform.identity.api;

import jakarta.validation.Valid;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.scaleup.studyplatform.identity.application.CadastrarContaService;
import com.scaleup.studyplatform.identity.application.ConfirmarCadastroService;
import com.scaleup.studyplatform.identity.application.EsqueciSenhaService;
import com.scaleup.studyplatform.identity.application.LoginService;
import com.scaleup.studyplatform.identity.application.RedefinirSenhaService;
import com.scaleup.studyplatform.identity.application.ReenviarTokenService;
import com.scaleup.studyplatform.identity.application.dto.CadastroRequest;
import com.scaleup.studyplatform.identity.application.dto.ConfirmarRequest;
import com.scaleup.studyplatform.identity.application.dto.EsqueciSenhaRequest;
import com.scaleup.studyplatform.identity.application.dto.LoginRequest;
import com.scaleup.studyplatform.identity.application.dto.LoginResponseDto;
import com.scaleup.studyplatform.identity.application.dto.MensagemDto;
import com.scaleup.studyplatform.identity.application.dto.RedefinirSenhaRequest;
import com.scaleup.studyplatform.identity.application.dto.ReenviarRequest;

/**
 * Endpoints de autenticação (TICKET-autenticacao.md, seções 4-7) — únicos endpoints públicos
 * (`permitAll` em {@link com.scaleup.studyplatform.shared.security.SecurityConfig}), todo o
 * resto da API exige JWT.
 */
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final CadastrarContaService cadastrarContaService;
    private final ConfirmarCadastroService confirmarCadastroService;
    private final ReenviarTokenService reenviarTokenService;
    private final LoginService loginService;
    private final EsqueciSenhaService esqueciSenhaService;
    private final RedefinirSenhaService redefinirSenhaService;

    public AuthController(CadastrarContaService cadastrarContaService, ConfirmarCadastroService confirmarCadastroService,
            ReenviarTokenService reenviarTokenService, LoginService loginService, EsqueciSenhaService esqueciSenhaService,
            RedefinirSenhaService redefinirSenhaService) {
        this.cadastrarContaService = cadastrarContaService;
        this.confirmarCadastroService = confirmarCadastroService;
        this.reenviarTokenService = reenviarTokenService;
        this.loginService = loginService;
        this.esqueciSenhaService = esqueciSenhaService;
        this.redefinirSenhaService = redefinirSenhaService;
    }

    @PostMapping("/cadastro")
    public MensagemDto cadastro(@Valid @RequestBody CadastroRequest request) {
        return cadastrarContaService.cadastrar(request);
    }

    @PostMapping("/confirmar")
    public MensagemDto confirmar(@Valid @RequestBody ConfirmarRequest request) {
        return confirmarCadastroService.confirmar(request);
    }

    @PostMapping("/reenviar-token")
    public MensagemDto reenviarToken(@Valid @RequestBody ReenviarRequest request) {
        return reenviarTokenService.reenviar(request);
    }

    @PostMapping("/login")
    public LoginResponseDto login(@Valid @RequestBody LoginRequest request) {
        return loginService.login(request);
    }

    @PostMapping("/esqueci-senha")
    public MensagemDto esqueciSenha(@Valid @RequestBody EsqueciSenhaRequest request) {
        return esqueciSenhaService.solicitar(request);
    }

    @PostMapping("/redefinir-senha")
    public MensagemDto redefinirSenha(@Valid @RequestBody RedefinirSenhaRequest request) {
        return redefinirSenhaService.redefinir(request);
    }
}
