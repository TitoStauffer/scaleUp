package com.scaleup.studyplatform.content.infra;

import java.util.Collection;
import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.scaleup.studyplatform.content.domain.Concept;
import com.scaleup.studyplatform.content.domain.StatusRevisao;

public interface ConceptRepository extends JpaRepository<Concept, UUID> {

    List<Concept> findByDomain_IdAndStatusRevisaoInOrderByOrdemAsc(UUID domainId, Collection<StatusRevisao> statusRevisaos);
}
