-- Módulo Content — Domain
-- Os 7 domínios do MVP são modelados como dados (linhas desta tabela), nunca como enum
-- ou valor fixo no schema/código (restrição herdada de TICKET-content-database.md).
-- A carga dos 7 domínios é responsabilidade do seed do Backend Engineer, não desta
-- migração — esta migração só cria a estrutura.

CREATE TABLE domain (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    slug            varchar(80) NOT NULL,
    nome            varchar(120) NOT NULL,
    descricao       text NOT NULL,
    content_version varchar(50) NOT NULL,
    status_revisao  varchar(20) NOT NULL DEFAULT 'rascunho',
    criado_em       timestamptz NOT NULL DEFAULT now(),
    atualizado_em   timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT uq_domain_slug UNIQUE (slug),
    CONSTRAINT ck_domain_slug_nao_vazio CHECK (length(btrim(slug)) > 0),
    CONSTRAINT ck_domain_nome_nao_vazio CHECK (length(btrim(nome)) > 0),
    CONSTRAINT ck_domain_descricao_nao_vazia CHECK (length(btrim(descricao)) > 0),
    CONSTRAINT ck_domain_content_version_nao_vazio CHECK (length(btrim(content_version)) > 0),
    CONSTRAINT ck_domain_status_revisao CHECK (status_revisao IN ('rascunho', 'revisado_aprovado'))
);

CREATE INDEX ix_domain_status_revisao ON domain (status_revisao);
