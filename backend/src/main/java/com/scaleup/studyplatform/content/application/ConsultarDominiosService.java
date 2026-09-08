package com.scaleup.studyplatform.content.application;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.content.application.dto.DomainSummaryDto;
import com.scaleup.studyplatform.content.infra.DomainRepository;

@Service
public class ConsultarDominiosService {

    private final DomainRepository domainRepository;
    private final ContentVisibilidadeConfig visibilidadeConfig;

    public ConsultarDominiosService(DomainRepository domainRepository, ContentVisibilidadeConfig visibilidadeConfig) {
        this.domainRepository = domainRepository;
        this.visibilidadeConfig = visibilidadeConfig;
    }

    @Transactional(readOnly = true)
    public List<DomainSummaryDto> listar() {
        return domainRepository.findByStatusRevisaoInOrderByNomeAsc(visibilidadeConfig.statusPermitidos())
                .stream()
                .map(d -> new DomainSummaryDto(d.getId(), d.getSlug(), d.getNome(), d.getDescricao()))
                .toList();
    }
}
