-- Módulo Progress — DomainProgress
-- Um registro por usuário/domínio, recalculado deterministicamente a partir das
-- evidências acumuladas em StudySession/QuizAttempt/Answer/FlashcardReview — não é um log
-- histórico (ver docs/architecture/database-schema.md, seção "Por que DomainProgress não
-- é uma tabela de histórico").

CREATE TABLE domain_progress (
    id                         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id                    uuid NOT NULL REFERENCES app_user (id) ON DELETE RESTRICT,
    domain_ref                 uuid NOT NULL REFERENCES domain (id) ON DELETE RESTRICT,
    pontuacao_quiz             numeric(5, 2) NULL,
    pontuacao_flashcards       numeric(5, 2) NULL,
    pontuacao_questoes_novas   numeric(5, 2) NULL,
    pontuacao_consistencia     numeric(5, 2) NULL,
    pontuacao_calibracao       numeric(5, 2) NULL,
    pontuacao_geral            numeric(5, 2) NULL,
    nivel_atual_id             uuid NULL REFERENCES nivel_referencia (id) ON DELETE RESTRICT,
    volume_evidencia_quiz      integer NOT NULL DEFAULT 0,
    volume_evidencia_flashcard integer NOT NULL DEFAULT 0,
    volume_minimo_atingido     boolean NOT NULL DEFAULT false,
    ultima_avaliacao_em        timestamptz NULL,
    atualizado_em              timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT uq_domain_progress_user_domain UNIQUE (user_id, domain_ref),
    CONSTRAINT ck_domain_progress_pontuacao_quiz CHECK (pontuacao_quiz IS NULL OR pontuacao_quiz BETWEEN 0 AND 100),
    CONSTRAINT ck_domain_progress_pontuacao_flashcards CHECK (pontuacao_flashcards IS NULL OR pontuacao_flashcards BETWEEN 0 AND 100),
    CONSTRAINT ck_domain_progress_pontuacao_questoes_novas CHECK (pontuacao_questoes_novas IS NULL OR pontuacao_questoes_novas BETWEEN 0 AND 100),
    CONSTRAINT ck_domain_progress_pontuacao_consistencia CHECK (pontuacao_consistencia IS NULL OR pontuacao_consistencia BETWEEN 0 AND 100),
    CONSTRAINT ck_domain_progress_pontuacao_calibracao CHECK (pontuacao_calibracao IS NULL OR pontuacao_calibracao BETWEEN 0 AND 100),
    CONSTRAINT ck_domain_progress_pontuacao_geral CHECK (pontuacao_geral IS NULL OR pontuacao_geral BETWEEN 0 AND 100),
    CONSTRAINT ck_domain_progress_volume_quiz CHECK (volume_evidencia_quiz >= 0),
    CONSTRAINT ck_domain_progress_volume_flashcard CHECK (volume_evidencia_flashcard >= 0)
);

CREATE INDEX ix_domain_progress_user ON domain_progress (user_id);
CREATE INDEX ix_domain_progress_domain ON domain_progress (domain_ref);
