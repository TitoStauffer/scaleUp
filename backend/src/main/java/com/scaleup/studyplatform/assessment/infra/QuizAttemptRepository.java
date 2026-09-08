package com.scaleup.studyplatform.assessment.infra;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.scaleup.studyplatform.assessment.domain.QuizAttempt;

/**
 * As consultas por (usuário, domínio) fazem join nativo com study_session porque
 * quiz_attempt não guarda user_id diretamente (só domain_ref, denormalizado da sessão) — ver
 * V10. Native queries pelo mesmo motivo documentado em
 * study.infra.FlashcardReviewRepository.
 */
public interface QuizAttemptRepository extends JpaRepository<QuizAttempt, UUID> {

    @Query(value = """
            select count(*) from quiz_attempt qa
            join study_session ss on qa.study_session_id = ss.id
            where ss.user_id = :userId and qa.domain_ref = :domainRef and qa.status = 'concluida'
            """, nativeQuery = true)
    long countConcludedByUserAndDomain(@Param("userId") UUID userId, @Param("domainRef") UUID domainRef);

    @Query(value = """
            select qa.* from quiz_attempt qa
            join study_session ss on qa.study_session_id = ss.id
            where ss.user_id = :userId and qa.domain_ref = :domainRef and qa.status = 'concluida'
            order by qa.concluido_em desc
            limit :limite
            """, nativeQuery = true)
    List<QuizAttempt> findRecentConcludedByUserAndDomain(@Param("userId") UUID userId,
            @Param("domainRef") UUID domainRef, @Param("limite") int limite);

    @Query(value = """
            select qa.concluido_em from quiz_attempt qa
            join study_session ss on qa.study_session_id = ss.id
            where ss.user_id = :userId and qa.domain_ref = :domainRef and qa.status = 'concluida'
              and qa.concluido_em >= :desde
            """, nativeQuery = true)
    List<Instant> findDatasConclusaoDesde(@Param("userId") UUID userId, @Param("domainRef") UUID domainRef,
            @Param("desde") Instant desde);

    @Query(value = """
            select qa.* from quiz_attempt qa
            join study_session ss on qa.study_session_id = ss.id
            where ss.user_id = :userId and qa.domain_ref = :domainRef and qa.status = 'concluida'
            order by qa.concluido_em desc
            """, nativeQuery = true)
    List<QuizAttempt> findAllConcludedByUserAndDomainOrderByConcluidoEmDesc(@Param("userId") UUID userId,
            @Param("domainRef") UUID domainRef);

    @Query(value = """
            select qa.* from quiz_attempt qa
            join study_session ss on qa.study_session_id = ss.id
            where ss.user_id = :userId and qa.status = 'concluida'
            order by qa.concluido_em desc
            """, nativeQuery = true)
    List<QuizAttempt> findAllConcludedByUserOrderByConcluidoEmDesc(@Param("userId") UUID userId);
}
