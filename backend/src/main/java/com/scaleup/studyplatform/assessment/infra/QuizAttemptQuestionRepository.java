package com.scaleup.studyplatform.assessment.infra;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.scaleup.studyplatform.assessment.domain.QuizAttemptQuestion;
import com.scaleup.studyplatform.assessment.domain.QuizAttemptQuestionId;

public interface QuizAttemptQuestionRepository extends JpaRepository<QuizAttemptQuestion, QuizAttemptQuestionId> {

    /**
     * Conjunto de questões efetivamente sorteadas para a tentativa — usado por
     * SubmeterQuizAttemptService para rejeitar, antes de persistir qualquer Answer, um
     * question_id que não foi sorteado para esta tentativa específica (controle primário que
     * fecha o defeito relatado pelo QA; a checagem de domínio antiga permanece como defesa em
     * profundidade).
     */
    @Query("select q.questionId from QuizAttemptQuestion q where q.quizAttemptId = :quizAttemptId")
    List<UUID> findQuestionIdsByQuizAttemptId(@Param("quizAttemptId") UUID quizAttemptId);
}
