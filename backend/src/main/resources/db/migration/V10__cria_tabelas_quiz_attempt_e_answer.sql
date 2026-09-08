-- Módulo Assessment — QuizAttempt e Answer
-- domain_ref em QuizAttempt é denormalizado a partir de StudySession por conveniência de
-- consulta (filtrar/agregar tentativas por domínio sem join adicional), mas sua
-- consistência com a sessão pai é garantida por FK composta — nunca pode divergir do
-- domain_ref da própria StudySession.

CREATE TABLE quiz_attempt (
    id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    study_session_id uuid NOT NULL,
    domain_ref       uuid NOT NULL,
    status           varchar(20) NOT NULL DEFAULT 'em_andamento',
    total_questoes   integer NOT NULL,
    pontuacao_obtida numeric(5, 2) NULL,
    iniciado_em      timestamptz NOT NULL DEFAULT now(),
    concluido_em     timestamptz NULL,

    CONSTRAINT fk_quiz_attempt_session_domain FOREIGN KEY (study_session_id, domain_ref)
        REFERENCES study_session (id, domain_ref) ON DELETE CASCADE,
    CONSTRAINT ck_quiz_attempt_status CHECK (status IN ('em_andamento', 'concluida', 'abandonada')),
    CONSTRAINT ck_quiz_attempt_total_questoes CHECK (total_questoes > 0),
    CONSTRAINT ck_quiz_attempt_pontuacao CHECK (pontuacao_obtida IS NULL OR pontuacao_obtida BETWEEN 0 AND 100),
    CONSTRAINT ck_quiz_attempt_conclusao_apos_inicio
        CHECK (concluido_em IS NULL OR concluido_em >= iniciado_em)
);

CREATE INDEX ix_quiz_attempt_session ON quiz_attempt (study_session_id);
CREATE INDEX ix_quiz_attempt_domain ON quiz_attempt (domain_ref);

CREATE TABLE answer (
    id                         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    quiz_attempt_id            uuid NOT NULL REFERENCES quiz_attempt (id) ON DELETE CASCADE,
    question_id                uuid NOT NULL REFERENCES question (id) ON DELETE RESTRICT,
    -- Referência imutável à versão do conteúdo usada no momento da resposta — exigência
    -- explícita de initial-architecture.md ("respostas devem guardar referência à versão
    -- do conteúdo usada, evitando que uma alteração posterior reescreva o histórico").
    question_content_version  varchar(50) NOT NULL,
    alternativa_selecionada_id uuid NOT NULL,
    correta                    boolean NOT NULL,
    confianca_declarada        smallint NULL,
    respondido_em              timestamptz NOT NULL DEFAULT now(),

    -- Garante, só com o banco, que a alternativa marcada como resposta pertence
    -- exatamente à Question respondida (não a outra Question qualquer).
    CONSTRAINT fk_answer_alternativa_question FOREIGN KEY (alternativa_selecionada_id, question_id)
        REFERENCES question_alternative (id, question_id) ON DELETE RESTRICT,
    CONSTRAINT uq_answer_attempt_question UNIQUE (quiz_attempt_id, question_id),
    CONSTRAINT ck_answer_confianca CHECK (confianca_declarada IS NULL OR confianca_declarada BETWEEN 1 AND 5)
);

CREATE INDEX ix_answer_attempt ON answer (quiz_attempt_id);
CREATE INDEX ix_answer_question ON answer (question_id);
