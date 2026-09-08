package com.scaleup.studyplatform.content.application;

import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.content.application.dto.ConceptDto;
import com.scaleup.studyplatform.content.application.dto.DomainDetailDto;
import com.scaleup.studyplatform.content.application.dto.SlideDto;
import com.scaleup.studyplatform.content.domain.Concept;
import com.scaleup.studyplatform.content.domain.Domain;
import com.scaleup.studyplatform.content.domain.Slide;
import com.scaleup.studyplatform.content.domain.StatusRevisao;
import com.scaleup.studyplatform.content.infra.ConceptRepository;
import com.scaleup.studyplatform.content.infra.DomainRepository;
import com.scaleup.studyplatform.content.infra.SlideRepository;
import com.scaleup.studyplatform.shared.RecursoNaoEncontradoException;

@Service
public class ConsultarConteudoDominioService {

    private final DomainRepository domainRepository;
    private final ConceptRepository conceptRepository;
    private final SlideRepository slideRepository;
    private final ContentVisibilidadeConfig visibilidadeConfig;

    public ConsultarConteudoDominioService(DomainRepository domainRepository, ConceptRepository conceptRepository,
            SlideRepository slideRepository, ContentVisibilidadeConfig visibilidadeConfig) {
        this.domainRepository = domainRepository;
        this.conceptRepository = conceptRepository;
        this.slideRepository = slideRepository;
        this.visibilidadeConfig = visibilidadeConfig;
    }

    @Transactional(readOnly = true)
    public DomainDetailDto buscarPorSlug(String slug) {
        Set<StatusRevisao> statusPermitidos = visibilidadeConfig.statusPermitidos();

        Domain dominio = domainRepository.findBySlugAndStatusRevisaoIn(slug, statusPermitidos)
                .orElseThrow(() -> new RecursoNaoEncontradoException("Domínio não encontrado: " + slug));

        List<Concept> conceitos = conceptRepository
                .findByDomain_IdAndStatusRevisaoInOrderByOrdemAsc(dominio.getId(), statusPermitidos);

        List<UUID> conceptIds = conceitos.stream().map(Concept::getId).toList();
        List<Slide> slides = conceptIds.isEmpty()
                ? List.of()
                : slideRepository.findByConcept_IdInAndStatusRevisaoInOrderByOrdemAsc(conceptIds, statusPermitidos);

        Map<UUID, List<SlideDto>> slidesPorConcept = slides.stream()
                .collect(Collectors.groupingBy(
                        s -> s.getConcept().getId(),
                        Collectors.mapping(
                                s -> new SlideDto(s.getId(), s.getTitulo(), s.getConteudo(), s.getOrdem()),
                                Collectors.toList())));

        List<ConceptDto> conceptDtos = conceitos.stream()
                .map(c -> new ConceptDto(c.getId(), c.getTitulo(), c.getResumo(),
                        slidesPorConcept.getOrDefault(c.getId(), List.of())))
                .toList();

        return new DomainDetailDto(dominio.getId(), dominio.getSlug(), dominio.getNome(), dominio.getDescricao(),
                conceptDtos);
    }
}
