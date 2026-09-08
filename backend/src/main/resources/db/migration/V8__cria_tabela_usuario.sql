-- Módulo Identity — abstração mínima de usuário local.
-- O PRD assume usuário único/local no MVP, mas a entidade já existe isoladamente para não
-- exigir reescrever o schema quando autenticação real for adicionada (ver "Decisões
-- futuras" em initial-architecture.md). Não inclui credenciais/senha ainda — serão
-- adicionadas depois via migração aditiva (ALTER TABLE ... ADD COLUMN ... NULL), quando a
-- autenticação for de fato implementada.

CREATE TABLE app_user (
    id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    email         varchar(255) NOT NULL,
    nome          varchar(120) NOT NULL,
    criado_em     timestamptz NOT NULL DEFAULT now(),
    atualizado_em timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT uq_app_user_email UNIQUE (email),
    CONSTRAINT ck_app_user_email_nao_vazio CHECK (length(btrim(email)) > 0),
    CONSTRAINT ck_app_user_nome_nao_vazio CHECK (length(btrim(nome)) > 0)
);
