package com.scaleup.studyplatform.content.application;

import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.content.application.dto.AlternativaDto;
import com.scaleup.studyplatform.content.application.dto.QuestionDto;
import com.scaleup.studyplatform.content.domain.Domain;
import com.scaleup.studyplatform.content.domain.StatusRevisao;
import com.scaleup.studyplatform.content.infra.DomainRepository;
import com.scaleup.studyplatform.content.infra.QuestionRepository;
import com.scaleup.studyplatform.shared.RecursoNaoEncontradoException;

@Service
public class ConsultarQuestoesService {

    private final DomainRepository domainRepository;
    private final QuestionRepository questionRepository;
    private final ContentVisibilidadeConfig visibilidadeConfig;

    public ConsultarQuestoesService(DomainRepository domainRepository, QuestionRepository questionRepository,
            ContentVisibilidadeConfig visibilidadeConfig) {
        this.domainRepository = domainRepository;
        this.questionRepository = questionRepository;
        this.visibilidadeConfig = visibilidadeConfig;
    }

    @Transactional(readOnly = true)
    public List<QuestionDto> listarPorDominio(String slug) {
        Set<StatusRevisao> statusPermitidos = visibilidadeConfig.statusPermitidos();

        Domain dominio = domainRepository.findBySlugAndStatusRevisaoIn(slug, statusPermitidos)
                .orElseThrow(() -> new RecursoNaoEncontradoException("Domínio não encontrado: " + slug));

        return questionRepository.findByDomain_IdAndStatusRevisaoInOrderByCriadoEmAsc(dominio.getId(), statusPermitidos)
                .stream()
                .map(q -> new QuestionDto(
                        q.getId(),
                        q.getEnunciado(),
                        q.getDificuldade().getValor(),
                        q.getAlternativas().stream()
                                .map(a -> new AlternativaDto(a.getId(), a.getTexto()))
                                .toList()))
                .toList();
    }
}
