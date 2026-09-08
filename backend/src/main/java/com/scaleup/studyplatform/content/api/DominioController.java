package com.scaleup.studyplatform.content.api;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.scaleup.studyplatform.content.application.ConsultarConteudoDominioService;
import com.scaleup.studyplatform.content.application.ConsultarDominiosService;
import com.scaleup.studyplatform.content.application.ConsultarFlashcardsService;
import com.scaleup.studyplatform.content.application.ConsultarQuestoesService;
import com.scaleup.studyplatform.content.application.dto.DomainDetailDto;
import com.scaleup.studyplatform.content.application.dto.DomainSummaryDto;
import com.scaleup.studyplatform.content.application.dto.FlashcardDto;
import com.scaleup.studyplatform.content.application.dto.QuestionDto;
import com.scaleup.studyplatform.content.domain.Dificuldade;

/**
 * API de leitura mínima do módulo Content — contrato definido em
 * docs/architecture/implementation-plan-backend-infra.md, seção 3. Não inclui sessão de
 * estudo, submissão de resposta ou cálculo de pontuação (fora de escopo desta etapa).
 */
@RestController
@RequestMapping("/api/dominios")
public class DominioController {

    private final ConsultarDominiosService consultarDominiosService;
    private final ConsultarConteudoDominioService consultarConteudoDominioService;
    private final ConsultarFlashcardsService consultarFlashcardsService;
    private final ConsultarQuestoesService consultarQuestoesService;

    public DominioController(ConsultarDominiosService consultarDominiosService,
            ConsultarConteudoDominioService consultarConteudoDominioService,
            ConsultarFlashcardsService consultarFlashcardsService,
            ConsultarQuestoesService consultarQuestoesService) {
        this.consultarDominiosService = consultarDominiosService;
        this.consultarConteudoDominioService = consultarConteudoDominioService;
        this.consultarFlashcardsService = consultarFlashcardsService;
        this.consultarQuestoesService = consultarQuestoesService;
    }

    @GetMapping
    public List<DomainSummaryDto> listar() {
        return consultarDominiosService.listar();
    }

    @GetMapping("/{slug}")
    public DomainDetailDto detalhar(@PathVariable String slug) {
        return consultarConteudoDominioService.buscarPorSlug(slug);
    }

    @GetMapping("/{slug}/flashcards")
    public List<FlashcardDto> flashcards(@PathVariable String slug,
            @RequestParam(name = "dificuldade", required = false) String dificuldade) {
        Dificuldade filtro = dificuldade == null ? null : Dificuldade.fromValor(dificuldade);
        return consultarFlashcardsService.listarPorDominio(slug, filtro);
    }

    @GetMapping("/{slug}/questoes")
    public List<QuestionDto> questoes(@PathVariable String slug) {
        return consultarQuestoesService.listarPorDominio(slug);
    }
}
