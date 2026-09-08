package com.scaleup.studyplatform.progress.infra;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.scaleup.studyplatform.progress.domain.DomainProgress;

public interface DomainProgressRepository extends JpaRepository<DomainProgress, UUID> {

    Optional<DomainProgress> findByUserIdAndDomainRef(UUID userId, UUID domainRef);

    List<DomainProgress> findByUserIdAndVolumeMinimoAtingidoTrue(UUID userId);
}
