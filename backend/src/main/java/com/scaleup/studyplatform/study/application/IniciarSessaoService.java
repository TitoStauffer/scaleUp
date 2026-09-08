package com.scaleup.studyplatform.study.application;

import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.scaleup.studyplatform.content.infra.DomainRepository;
import com.scaleup.studyplatform.identity.application.CurrentUserProvider;
import com.scaleup.studyplatform.shared.RecursoNaoEncontradoException;
import com.scaleup.studyplatform.study.application.dto.StudySessionDto;
import com.scaleup.studyplatform.study.domain.StudySession;
import com.scaleup.studyplatform.study.infra.StudySessionRepository;

/** POST /dominios/{dominioId}/sessoes (ticket, seção 7). */
@Service
public class IniciarSessaoService {

    private final StudySessionRepository studySessionRepository;
    private final DomainRepository domainRepository;
    private final CurrentUserProvider currentUserProvider;

    public IniciarSessaoService(StudySessionRepository studySessionRepository, DomainRepository domainRepository,
            CurrentUserProvider currentUserProvider) {
        this.studySessionRepository = studySessionRepository;
        this.domainRepository = domainRepository;
        this.currentUserProvider = currentUserProvider;
    }

    @Transactional
    public StudySessionDto iniciar(UUID dominioId) {
        if (!domainRepository.existsById(dominioId)) {
            throw new RecursoNaoEncontradoException("Domínio não encontrado: " + dominioId);
        }

        UUID userId = currentUserProvider.getCurrentUserId();
        StudySession sessao = studySessionRepository.save(new StudySession(userId, dominioId));
        return new StudySessionDto(sessao.getId(), sessao.getDomainRef(), sessao.getStatus().getValor(),
                sessao.getIniciadaEm());
    }
}
