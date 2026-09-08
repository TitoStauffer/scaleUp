package com.scaleup.studyplatform.content.infra;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import com.scaleup.studyplatform.content.domain.Question;
import com.scaleup.studyplatform.content.domain.StatusRevisao;

public interface QuestionRepository extends JpaRepository<Question, UUID> {

    @EntityGraph(attributePaths = "alternativas")
    List<Question> findByDomain_IdAndStatusRevisaoInOrderByCriadoEmAsc(UUID domainId,
            Collection<StatusRevisao> statusRevisaos);

    /**
     * Usada onde as alternativas precisam ser lidas fora de uma transação já aberta pelo
     * chamador (ex.: fixtures de teste de integração) — {@code findById} sozinho deixaria
     * `alternativas` (LAZY) inacessível depois que a sessão do Hibernate fechar
     * (open-in-view=false).
     */
    @EntityGraph(attributePaths = "alternativas")
    Optional<Question> findWithAlternativasById(UUID id);
}
