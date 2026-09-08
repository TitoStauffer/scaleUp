package com.scaleup.studyplatform.study.infra;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.scaleup.studyplatform.study.domain.FlashcardReview;

/**
 * As consultas por (usuário, domínio) fazem join nativo com study_session porque
 * flashcard_review só referencia study_session_id — domínio e usuário vivem na sessão, não
 * na revisão em si (ver V9). Native queries em vez de JPQL: mais simples de ler para joins
 * entre entidades sem relação JPA direta (decisão deliberada de manter StudySession/
 * FlashcardReview desacopladas de outras entidades de módulo via @ManyToOne — ver
 * FlashcardReview/StudySession).
 */
public interface FlashcardReviewRepository extends JpaRepository<FlashcardReview, UUID> {

    @Query(value = """
            select count(*) from flashcard_review fr
            join study_session ss on fr.study_session_id = ss.id
            where ss.user_id = :userId and ss.domain_ref = :domainRef
            """, nativeQuery = true)
    long countByUserAndDomain(@Param("userId") UUID userId, @Param("domainRef") UUID domainRef);

    @Query(value = """
            select fr.* from flashcard_review fr
            join study_session ss on fr.study_session_id = ss.id
            where ss.user_id = :userId and ss.domain_ref = :domainRef
            order by fr.revisado_em desc
            limit :limite
            """, nativeQuery = true)
    List<FlashcardReview> findRecentByUserAndDomain(@Param("userId") UUID userId, @Param("domainRef") UUID domainRef,
            @Param("limite") int limite);

    @Query(value = """
            select fr.revisado_em from flashcard_review fr
            join study_session ss on fr.study_session_id = ss.id
            where ss.user_id = :userId and ss.domain_ref = :domainRef and fr.revisado_em >= :desde
            """, nativeQuery = true)
    List<Instant> findDatasRevisaoDesde(@Param("userId") UUID userId, @Param("domainRef") UUID domainRef,
            @Param("desde") Instant desde);

    @Query(value = """
            select fr.* from flashcard_review fr
            join study_session ss on fr.study_session_id = ss.id
            where ss.user_id = :userId and ss.domain_ref = :domainRef and fr.confianca_declarada is not null
            order by fr.revisado_em desc
            limit :limite
            """, nativeQuery = true)
    List<FlashcardReview> findRecentComConfiancaByUserAndDomain(@Param("userId") UUID userId,
            @Param("domainRef") UUID domainRef, @Param("limite") int limite);
}
