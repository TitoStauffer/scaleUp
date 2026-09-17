package com.scaleup.studyplatform.progress.infra;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.scaleup.studyplatform.progress.domain.DomainProgress;

public interface DomainProgressRepository extends JpaRepository<DomainProgress, UUID> {

    Optional<DomainProgress> findByUserIdAndDomainRef(UUID userId, UUID domainRef);

    List<DomainProgress> findByUserIdAndVolumeMinimoAtingidoTrue(UUID userId);

    // TICKET-perfil-usuario.md, seção 7: todos os DomainProgress do usuário de uma vez, para
    // montar o bloco "porDominio" das estatísticas sem 1 query por domínio.
    List<DomainProgress> findByUserId(UUID userId);
}
