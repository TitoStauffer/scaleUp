-- Módulo Identity — token de recuperação de senha (TICKET-esqueci-minha-senha.md, seções 6-7)
--
-- Entidade nova, não reaproveita token_confirmacao_cadastro (V34): são operações diferentes
-- que podem legitimamente coexistir (ticket, seção 6) — misturar as duas na mesma tabela
-- exigiria uma coluna de "tipo de token" e complicaria o índice único parcial de "token em
-- aberto por conta". Mesmo padrão estrutural de V34 (duas colunas de timestamp nullable para
-- distinguir consumido/invalidado, em vez de um enum único), pela mesma razão de auditoria.
--
-- Diferença de formato em relação a V34: token opaco de alta entropia (varchar(64), não
-- varchar(6) numérico) — este token concede a capacidade de trocar a senha de uma conta
-- alheia se vazado, superfície de dano maior que o token de confirmação de cadastro, que só
-- ativa uma conta (ticket, seção 7).

CREATE TABLE token_recuperacao_senha (
    id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id       uuid NOT NULL REFERENCES app_user (id) ON DELETE CASCADE,
    token         varchar(64) NOT NULL,
    gerado_em     timestamptz NOT NULL DEFAULT now(),
    expira_em     timestamptz NOT NULL,
    consumido_em  timestamptz NULL,
    invalidado_em timestamptz NULL,

    -- Token opaco alfanumérico de alta entropia (ticket, seção 7).
    CONSTRAINT ck_token_recuperacao_formato CHECK (token ~ '^[A-Za-z0-9_-]{32,64}$'),
    CONSTRAINT ck_token_recuperacao_expira_apos_gerar CHECK (expira_em > gerado_em),
    CONSTRAINT ck_token_recuperacao_consumo_exclusivo
        CHECK (consumido_em IS NULL OR invalidado_em IS NULL),
    CONSTRAINT ck_token_recuperacao_consumido_apos_gerar
        CHECK (consumido_em IS NULL OR consumido_em >= gerado_em),
    CONSTRAINT ck_token_recuperacao_invalidado_apos_gerar
        CHECK (invalidado_em IS NULL OR invalidado_em >= gerado_em)
);

CREATE INDEX ix_token_recuperacao_user_gerado ON token_recuperacao_senha (user_id, gerado_em DESC);

-- Mesma garantia de integridade de V34: no máximo um token de recuperação "em aberto" (nem
-- consumido, nem invalidado) por conta — nova solicitação invalida o anterior antes de
-- inserir o novo, na mesma transação (ticket, seção 7, "AC-09").
CREATE UNIQUE INDEX ux_token_recuperacao_aberto_por_conta
    ON token_recuperacao_senha (user_id)
    WHERE consumido_em IS NULL AND invalidado_em IS NULL;

-- Busca direta por valor do token (fluxo de redefinição recebe só o token, não o e-mail).
CREATE UNIQUE INDEX ux_token_recuperacao_valor ON token_recuperacao_senha (token);
