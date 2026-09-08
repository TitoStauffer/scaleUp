package com.scaleup.studyplatform.content.infra;

import java.util.Collection;
import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

import com.scaleup.studyplatform.content.domain.Dificuldade;
import com.scaleup.studyplatform.content.domain.Flashcard;
import com.scaleup.studyplatform.content.domain.StatusRevisao;

public interface FlashcardRepository extends JpaRepository<Flashcard, UUID> {

    List<Flashcard> findByDomain_IdAndStatusRevisaoInOrderByCriadoEmAsc(UUID domainId,
            Collection<StatusRevisao> statusRevisaos);

    List<Flashcard> findByDomain_IdAndStatusRevisaoInAndDificuldadeOrderByCriadoEmAsc(UUID domainId,
            Collection<StatusRevisao> statusRevisaos, Dificuldade dificuldade);
}
