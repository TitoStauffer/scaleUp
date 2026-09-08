-- Módulo Content — Slide
-- concept_ref é OBRIGATÓRIO por decisão do PM (diferente de Flashcard/Question, cujo
-- concept_ref é opcional — ver OPEN QUESTION-003 em docs/architecture/database-schema.md).
-- domain_ref é mantido explícito (recomendação do ticket, para facilitar consultas) e sua
-- consistência com o Concept pai é garantida por FK composta — não por trigger.

CREATE TABLE slide (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    concept_ref     uuid NOT NULL,
    domain_ref      uuid NOT NULL,
    titulo          varchar(200) NOT NULL,
    conteudo        text NOT NULL,
    ordem           integer NOT NULL,
    content_version varchar(50) NOT NULL,
    status_revisao  varchar(20) NOT NULL DEFAULT 'rascunho',
    criado_em       timestamptz NOT NULL DEFAULT now(),
    atualizado_em   timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT fk_slide_concept_domain FOREIGN KEY (concept_ref, domain_ref)
        REFERENCES concept (id, domain_ref) ON DELETE RESTRICT,
    -- Garante unicidade da ordem dentro do Concept via constraint de banco. Ausência de
    -- lacunas (sequência 1..N sem buracos) fica a cargo de validação de aplicação — ver
    -- justificativa em docs/architecture/database-schema.md.
    CONSTRAINT uq_slide_concept_ordem UNIQUE (concept_ref, ordem),
    CONSTRAINT ck_slide_ordem_positiva CHECK (ordem >= 1),
    CONSTRAINT ck_slide_titulo_nao_vazio CHECK (length(btrim(titulo)) > 0),
    CONSTRAINT ck_slide_conteudo_nao_vazio CHECK (length(btrim(conteudo)) > 0),
    CONSTRAINT ck_slide_content_version_nao_vazio CHECK (length(btrim(content_version)) > 0),
    CONSTRAINT ck_slide_status_revisao CHECK (status_revisao IN ('rascunho', 'revisado_aprovado'))
);

CREATE INDEX ix_slide_concept_ref ON slide (concept_ref);
CREATE INDEX ix_slide_domain_ref ON slide (domain_ref);
CREATE INDEX ix_slide_status_revisao ON slide (status_revisao);
