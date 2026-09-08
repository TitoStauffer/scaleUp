package com.scaleup.studyplatform.assessment.infra;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.scaleup.studyplatform.assessment.domain.Answer;

/**
 * Native queries pelo mesmo motivo documentado em
 * study.infra.FlashcardReviewRepository/assessment.infra.QuizAttemptRepository: Answer só
 * referencia quiz_attempt_id, e o usuário mora em study_session (via quiz_attempt).
 */
public interface AnswerRepository extends JpaRepository<Answer, UUID> {

    @Query(value = """
            select distinct a.question_id from answer a
            join quiz_attempt qa on a.quiz_attempt_id = qa.id
            join study_session ss on qa.study_session_id = ss.id
            where ss.user_id = :userId and a.domain_ref = :domainRef
            """, nativeQuery = true)
    List<UUID> findQuestionIdsJaRespondidas(@Param("userId") UUID userId, @Param("domainRef") UUID domainRef);

    /**
     * Todas as respostas do usuário no domínio, em ordem cronológica ascendente — usado para
     * derivar, em memória, a primeira resposta de cada questão (componente "questões novas",
     * seção 5.3 do ticket: "Uma Answer é 'nova' se é a primeira resposta já registrada para
     * aquele par (usuário, question_id)"). Extrair isso em SQL exigiria window functions
     * (ROW_NUMBER); calcular em Java com um LinkedHashMap é mais simples de ler e testar.
     */
    @Query(value = """
            select a.* from answer a
            join quiz_attempt qa on a.quiz_attempt_id = qa.id
            join study_session ss on qa.study_session_id = ss.id
            where ss.user_id = :userId and a.domain_ref = :domainRef
            order by a.respondido_em asc
            """, nativeQuery = true)
    List<Answer> findAllByUserAndDomainOrderByRespondidoEmAsc(@Param("userId") UUID userId,
            @Param("domainRef") UUID domainRef);

    @Query(value = """
            select a.* from answer a
            join quiz_attempt qa on a.quiz_attempt_id = qa.id
            join study_session ss on qa.study_session_id = ss.id
            where ss.user_id = :userId and a.domain_ref = :domainRef and a.confianca_declarada is not null
            order by a.respondido_em desc
            limit :limite
            """, nativeQuery = true)
    List<Answer> findRecentComConfiancaByUserAndDomain(@Param("userId") UUID userId,
            @Param("domainRef") UUID domainRef, @Param("limite") int limite);
}
