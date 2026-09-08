-- Módulo Content — Concept
-- Concept agrupa Slides/Flashcards/Questions dentro de um Domain para fins de
-- organização do estudo. Não é usado como categoria de força/fraqueza do usuário — isso é
-- resolvido por Question.domain_ref + DomainProgress (ver OPEN QUESTION-003, resolvida em
-- docs/architecture/database-schema.md).

CREATE TABLE concept (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_ref      uuid NOT NULL REFERENCES domain (id) ON DELETE RESTRICT,
    titulo          varchar(200) NOT NULL,
    resumo          text NOT NULL,
    content_version varchar(50) NOT NULL,
    status_revisao  varchar(20) NOT NULL DEFAULT 'rascunho',
    criado_em       timestamptz NOT NULL DEFAULT now(),
    atualizado_em   timestamptz NOT NULL DEFAULT now(),

    -- Unicidade composta necessária para que Slide/Flashcard/Question referenciem
    -- (concept_ref, domain_ref) via FK composta e o banco garanta, sozinho, que o
    -- domain_ref informado bate com o domain_ref real do Concept pai.
    CONSTRAINT uq_concept_id_domain UNIQUE (id, domain_ref),
    CONSTRAINT uq_concept_domain_titulo UNIQUE (domain_ref, titulo),
    CONSTRAINT ck_concept_titulo_nao_vazio CHECK (length(btrim(titulo)) > 0),
    CONSTRAINT ck_concept_resumo_nao_vazio CHECK (length(btrim(resumo)) > 0),
    CONSTRAINT ck_concept_content_version_nao_vazio CHECK (length(btrim(content_version)) > 0),
    CONSTRAINT ck_concept_status_revisao CHECK (status_revisao IN ('rascunho', 'revisado_aprovado'))
);

CREATE INDEX ix_concept_domain_ref ON concept (domain_ref);
CREATE INDEX ix_concept_status_revisao ON concept (status_revisao);
