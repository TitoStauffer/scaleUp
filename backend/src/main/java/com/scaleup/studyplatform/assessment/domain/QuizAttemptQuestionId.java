package com.scaleup.studyplatform.assessment.domain;

import java.io.Serializable;
import java.util.Objects;
import java.util.UUID;

/**
 * Chave composta de quiz_attempt_question (V25): a identidade natural da linha é o par
 * (tentativa, questão) sorteada — não existe conceito de id substituto para essa tabela de
 * junção (ver comentário da migração).
 */
public class QuizAttemptQuestionId implements Serializable {

    private UUID quizAttemptId;
    private UUID questionId;

    public QuizAttemptQuestionId() {
    }

    public QuizAttemptQuestionId(UUID quizAttemptId, UUID questionId) {
        this.quizAttemptId = quizAttemptId;
        this.questionId = questionId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof QuizAttemptQuestionId that)) {
            return false;
        }
        return Objects.equals(quizAttemptId, that.quizAttemptId) && Objects.equals(questionId, that.questionId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(quizAttemptId, questionId);
    }
}
