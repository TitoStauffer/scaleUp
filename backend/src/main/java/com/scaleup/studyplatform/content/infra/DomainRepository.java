package com.scaleup.studyplatform.content.infra;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.scaleup.studyplatform.content.domain.Domain;
import com.scaleup.studyplatform.content.domain.StatusRevisao;

public interface DomainRepository extends JpaRepository<Domain, UUID> {

    List<Domain> findByStatusRevisaoInOrderByNomeAsc(Collection<StatusRevisao> statusRevisaos);

    Optional<Domain> findBySlugAndStatusRevisaoIn(String slug, Collection<StatusRevisao> statusRevisaos);
}
