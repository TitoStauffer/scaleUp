package com.scaleup.studyplatform.progress.api;

import java.util.List;
import java.util.UUID;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.scaleup.studyplatform.identity.application.CurrentUserProvider;
import com.scaleup.studyplatform.progress.application.ConsultarHistoricoService;
import com.scaleup.studyplatform.progress.application.ConsultarProgressoService;
import com.scaleup.studyplatform.progress.application.ConsultarResultadoGeralService;
import com.scaleup.studyplatform.progress.application.dto.DomainProgressDto;
import com.scaleup.studyplatform.progress.application.dto.HistoricoItemDto;
import com.scaleup.studyplatform.progress.application.dto.ResultadoGeralDto;
import com.scaleup.studyplatform.shared.RecursoNaoEncontradoException;

/**
 * 3 dos 7 endpoints do ticket (seção 7): progresso por domínio, resultado geral do usuário e
 * histórico/evolução.
 */
@RestController
@RequestMapping("/api")
public class ProgressoController {

    private final ConsultarProgressoService consultarProgressoService;
    private final ConsultarResultadoGeralService consultarResultadoGeralService;
    private final ConsultarHistoricoService consultarHistoricoService;
    private final CurrentUserProvider currentUserProvider;

    public ProgressoController(ConsultarProgressoService consultarProgressoService,
            ConsultarResultadoGeralService consultarResultadoGeralService,
            ConsultarHistoricoService consultarHistoricoService, CurrentUserProvider currentUserProvider) {
        this.consultarProgressoService = consultarProgressoService;
        this.consultarResultadoGeralService = consultarResultadoGeralService;
        this.consultarHistoricoService = consultarHistoricoService;
        this.currentUserProvider = currentUserProvider;
    }

    /**
     * `GET /dominios/{dominioId}/progresso` não carrega `{userId}` na URL (ao contrário dos
     * outros dois endpoints deste controller) — o ticket original o expõe sob `/dominios/...`,
     * não sob `/usuarios/...`. Resolve o usuário autenticado da requisição (JWT) do mesmo
     * jeito que os módulos Study/Assessment, via {@link CurrentUserProvider}.
     */
    @GetMapping("/dominios/{dominioId}/progresso")
    public DomainProgressDto progresso(@PathVariable UUID dominioId) {
        return consultarProgressoService.consultar(currentUserProvider.getCurrentUserId(), dominioId);
    }

    /**
     * IDOR (achado do QA): `{userId}` continua na URL por compatibilidade de contrato, mas só
     * é aceito quando bate com o usuário do JWT — qualquer outro id responde 404, pelo mesmo
     * princípio anti-enumeração do ticket de autenticação (não revela se o id pertence a
     * outra conta ou não existe).
     */
    @GetMapping("/usuarios/{userId}/resultado-geral")
    public ResultadoGeralDto resultadoGeral(@PathVariable UUID userId) {
        exigirProprioUsuario(userId);
        return consultarResultadoGeralService.consultar(userId);
    }

    @GetMapping("/usuarios/{userId}/historico")
    public List<HistoricoItemDto> historico(@PathVariable UUID userId,
            @RequestParam(name = "dominioId", required = false) UUID dominioId) {
        exigirProprioUsuario(userId);
        return consultarHistoricoService.consultar(userId, dominioId);
    }

    private void exigirProprioUsuario(UUID userId) {
        if (!currentUserProvider.getCurrentUserId().equals(userId)) {
            throw new RecursoNaoEncontradoException("Usuário não encontrado: " + userId);
        }
    }
}
