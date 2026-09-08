package com.scaleup.studyplatform.content.infra;

import java.util.Collection;
import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.scaleup.studyplatform.content.domain.Slide;
import com.scaleup.studyplatform.content.domain.StatusRevisao;

public interface SlideRepository extends JpaRepository<Slide, UUID> {

    List<Slide> findByConcept_IdInAndStatusRevisaoInOrderByOrdemAsc(Collection<UUID> conceptIds,
            Collection<StatusRevisao> statusRevisaos);
}
