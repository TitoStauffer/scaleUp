-- Módulo Study — StudySession e FlashcardReview
-- initial-architecture.md descreve apenas de forma narrativa: "StudySession registra a
-- sessão; FlashcardReview... registram evidências". Campos abaixo detalhados a partir dos
-- requisitos funcionais 5, 6 e 10 e da seção "Dados e instrumentação" do PRD-mvp.md.

CREATE TABLE study_session (
    id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id      uuid NOT NULL REFERENCES app_user (id) ON DELETE RESTRICT,
    domain_ref   uuid NOT NULL REFERENCES domain (id) ON DELETE RESTRICT,
    status       varchar(20) NOT NULL DEFAULT 'em_andamento',
    iniciada_em  timestamptz NOT NULL DEFAULT now(),
    concluida_em timestamptz NULL,

    -- Suporte à FK composta de QuizAttempt: garante que o domain_ref do attempt sempre
    -- bate com o domain_ref da sessão à qual pertence (ver V10).
    CONSTRAINT uq_study_session_id_domain UNIQUE (id, domain_ref),
    CONSTRAINT ck_study_session_status CHECK (status IN ('em_andamento', 'concluida', 'abandonada')),
    CONSTRAINT ck_study_session_conclusao_apos_inicio
        CHECK (concluida_em IS NULL OR concluida_em >= iniciada_em)
);

-- Suporta a consulta de "histórico recente de sessões e evolução por domínio" (requisito
-- funcional 10 do PRD): filtro por usuário+domínio, ordenado por data.
CREATE INDEX ix_study_session_user_domain ON study_session (user_id, domain_ref, iniciada_em DESC);

CREATE TABLE flashcard_review (
    id                        uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    study_session_id         uuid NOT NULL REFERENCES study_session (id) ON DELETE CASCADE,
    flashcard_id              uuid NOT NULL REFERENCES flashcard (id) ON DELETE RESTRICT,
    -- Snapshot imutável da versão do conteúdo revisado no momento da revisão, mesmo
    -- princípio de rastreabilidade aplicado a Answer (ver V10).
    flashcard_content_version varchar(50) NOT NULL,
    resultado_autoavaliacao   varchar(20) NOT NULL,
    confianca_declarada       smallint NULL,
    revisado_em               timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT ck_flashcard_review_resultado CHECK (resultado_autoavaliacao IN ('lembrei', 'nao_lembrei')),
    CONSTRAINT ck_flashcard_review_confianca CHECK (confianca_declarada IS NULL OR confianca_declarada BETWEEN 1 AND 5)
);

CREATE INDEX ix_flashcard_review_session ON flashcard_review (study_session_id);
CREATE INDEX ix_flashcard_review_flashcard ON flashcard_review (flashcard_id);
