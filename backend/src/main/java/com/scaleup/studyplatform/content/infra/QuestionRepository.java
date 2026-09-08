package com.scaleup.studyplatform.content.infra;

import java.util.Collection;
import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import com.scaleup.studyplatform.content.domain.Question;
import com.scaleup.studyplatform.content.domain.StatusRevisao;

public interface QuestionRepository extends JpaRepository<Question, UUID> {

    @EntityGraph(attributePaths = "alternativas")
    List<Question> findByDomain_IdAndStatusRevisaoInOrderByCriadoEmAsc(UUID domainId,
            Collection<StatusRevisao> statusRevisaos);
}
