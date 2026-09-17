package com.scaleup.studyplatform.study.infra;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.scaleup.studyplatform.study.domain.StudySession;

public interface StudySessionRepository extends JpaRepository<StudySession, UUID> {

    // TICKET-perfil-usuario.md, seção 7: contagem de sessões de estudo por usuário, geral e
    // por domínio, para o bloco de estatísticas consolidadas do perfil.
    long countByUserId(UUID userId);

    long countByUserIdAndDomainRef(UUID userId, UUID domainRef);
}
