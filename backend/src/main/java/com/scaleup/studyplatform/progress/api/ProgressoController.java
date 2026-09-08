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
     * outros dois endpoints deste controller) — o ticket o expõe sob `/dominios/...`, não sob
     * `/usuarios/...`. Como o MVP assume usuário único/local (sem autenticação real), resolve
     * o usuário atual do mesmo jeito que os módulos Study/Assessment.
     */
    @GetMapping("/dominios/{dominioId}/progresso")
    public DomainProgressDto progresso(@PathVariable UUID dominioId) {
        return consultarProgressoService.consultar(currentUserProvider.getCurrentUserId(), dominioId);
    }

    @GetMapping("/usuarios/{userId}/resultado-geral")
    public ResultadoGeralDto resultadoGeral(@PathVariable UUID userId) {
        return consultarResultadoGeralService.consultar(userId);
    }

    @GetMapping("/usuarios/{userId}/historico")
    public List<HistoricoItemDto> historico(@PathVariable UUID userId,
            @RequestParam(name = "dominioId", required = false) UUID dominioId) {
        return consultarHistoricoService.consultar(userId, dominioId);
    }
}
