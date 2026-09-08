package com.scaleup.studyplatform.content.application;

import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.content.application.dto.FlashcardDto;
import com.scaleup.studyplatform.content.domain.Dificuldade;
import com.scaleup.studyplatform.content.domain.Domain;
import com.scaleup.studyplatform.content.domain.StatusRevisao;
import com.scaleup.studyplatform.content.infra.DomainRepository;
import com.scaleup.studyplatform.content.infra.FlashcardRepository;
import com.scaleup.studyplatform.shared.RecursoNaoEncontradoException;

@Service
public class ConsultarFlashcardsService {

    private final DomainRepository domainRepository;
    private final FlashcardRepository flashcardRepository;
    private final ContentVisibilidadeConfig visibilidadeConfig;

    public ConsultarFlashcardsService(DomainRepository domainRepository, FlashcardRepository flashcardRepository,
            ContentVisibilidadeConfig visibilidadeConfig) {
        this.domainRepository = domainRepository;
        this.flashcardRepository = flashcardRepository;
        this.visibilidadeConfig = visibilidadeConfig;
    }

    @Transactional(readOnly = true)
    public List<FlashcardDto> listarPorDominio(String slug, Dificuldade dificuldade) {
        Set<StatusRevisao> statusPermitidos = visibilidadeConfig.statusPermitidos();

        Domain dominio = domainRepository.findBySlugAndStatusRevisaoIn(slug, statusPermitidos)
                .orElseThrow(() -> new RecursoNaoEncontradoException("Domínio não encontrado: " + slug));

        var flashcards = dificuldade == null
                ? flashcardRepository.findByDomain_IdAndStatusRevisaoInOrderByCriadoEmAsc(dominio.getId(),
                        statusPermitidos)
                : flashcardRepository.findByDomain_IdAndStatusRevisaoInAndDificuldadeOrderByCriadoEmAsc(
                        dominio.getId(), statusPermitidos, dificuldade);

        return flashcards.stream()
                .map(f -> new FlashcardDto(f.getId(), f.getFrente(), f.getVerso(), f.getDificuldade().getValor()))
                .toList();
    }
}
