package com.scaleup.studyplatform.assessment.domain;

import java.time.Instant;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;

/**
 * Mapeia quiz_attempt_question (V25) — registra QUAIS questões foram efetivamente sorteadas
 * para cada QuizAttempt, na ordem sorteada. Fecha a lacuna de integridade relatada pelo QA:
 * antes desta tabela, SubmeterQuizAttemptService não tinha como distinguir uma questão
 * realmente sorteada de qualquer outra do mesmo domínio.
 *
 * `domainRef` segue a mesma regra já usada em {@link Answer}: DEVE ser sempre preenchido a
 * partir de {@code QuizAttempt.domainRef} (nunca do domain_ref da Question), pois é assim que
 * a FK composta fk_quiz_attempt_question_attempt_domain (V25) passa.
 */
@Entity
@Table(name = "quiz_attempt_question")
@IdClass(QuizAttemptQuestionId.class)
public class QuizAttemptQuestion {

    @Id
    @Column(name = "quiz_attempt_id", updatable = false, nullable = false, columnDefinition = "uuid")
    private UUID quizAttemptId;

    @Id
    @Column(name = "question_id", updatable = false, nullable = false, columnDefinition = "uuid")
    private UUID questionId;

    @Column(name = "domain_ref", nullable = false, columnDefinition = "uuid")
    private UUID domainRef;

    @Column(nullable = false)
    private short ordem;

    @Column(name = "sorteada_em", nullable = false)
    private Instant sorteadaEm;

    protected QuizAttemptQuestion() {
    }

    public QuizAttemptQuestion(UUID quizAttemptId, UUID questionId, UUID domainRef, short ordem) {
        this.quizAttemptId = quizAttemptId;
        this.questionId = questionId;
        this.domainRef = domainRef;
        this.ordem = ordem;
        this.sorteadaEm = Instant.now();
    }

    public UUID getQuizAttemptId() {
        return quizAttemptId;
    }

    public UUID getQuestionId() {
        return questionId;
    }

    public UUID getDomainRef() {
        return domainRef;
    }

    public short getOrdem() {
        return ordem;
    }

    public Instant getSorteadaEm() {
        return sorteadaEm;
    }
}
