-- Módulo Content — Flashcard
-- concept_ref é OPCIONAL (NULL permitido) — decisão de OPEN QUESTION-003, justificada em
-- docs/architecture/database-schema.md. Quando presente, é garantido consistente com
-- domain_ref via FK composta (mesmo mecanismo usado em Slide); quando NULL, a FK composta
-- não é validada (comportamento padrão MATCH SIMPLE do Postgres).

CREATE TABLE flashcard (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_ref      uuid NOT NULL REFERENCES domain (id) ON DELETE RESTRICT,
    concept_ref     uuid NULL,
    frente          text NOT NULL,
    verso           text NOT NULL,
    dificuldade     varchar(10) NOT NULL,
    content_version varchar(50) NOT NULL,
    status_revisao  varchar(20) NOT NULL DEFAULT 'rascunho',
    criado_em       timestamptz NOT NULL DEFAULT now(),
    atualizado_em   timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT fk_flashcard_concept_domain FOREIGN KEY (concept_ref, domain_ref)
        REFERENCES concept (id, domain_ref) ON DELETE RESTRICT,
    CONSTRAINT ck_flashcard_frente_nao_vazia CHECK (length(btrim(frente)) > 0),
    CONSTRAINT ck_flashcard_verso_nao_vazio CHECK (length(btrim(verso)) > 0),
    CONSTRAINT ck_flashcard_dificuldade CHECK (dificuldade IN ('facil', 'media', 'dificil')),
    CONSTRAINT ck_flashcard_content_version_nao_vazio CHECK (length(btrim(content_version)) > 0),
    CONSTRAINT ck_flashcard_status_revisao CHECK (status_revisao IN ('rascunho', 'revisado_aprovado'))
);

CREATE INDEX ix_flashcard_domain_ref ON flashcard (domain_ref);
CREATE INDEX ix_flashcard_concept_ref ON flashcard (concept_ref);
CREATE INDEX ix_flashcard_domain_status_dificuldade ON flashcard (domain_ref, status_revisao, dificuldade);
