-- Módulo Identity — token de confirmação de cadastro (TICKET-autenticacao.md, seções 5-6, 9)
--
-- Tabela nova (não é extensão de app_user) porque o ticket exige histórico: "reenviar
-- invalida o token anterior... o schema precisa suportar mais de um token por conta ao
-- longo do tempo (histórico), não só o token atual" (seção 6/9). Um único par de colunas
-- em app_user (token atual + expiração) sobrescrito a cada reenvio perderia a auditoria de
-- quantos tokens foram gerados e quando, exatamente o que a seção 9 pede para evitar.
--
-- Modelagem do "estado" do token: duas colunas de timestamp nullable, em vez de um único
-- enum/status:
--   - consumido_em: preenchido quando o token foi de fato usado para confirmar a conta
--     com sucesso (AC-03).
--   - invalidado_em: preenchido quando o token deixou de ser válido por ter sido
--     substituído por um reenvio (seção 6), SEM nunca ter sido de fato usado.
-- Um único booleano "usado" misturaria esses dois casos e destruiria exatamente a
-- distinção de auditoria que a seção 9 pede ("evitar ambiguidade de concorrência entre
-- 'gerar novo' e 'validar antigo'"): com colunas separadas dá para responder "esse token
-- expirou sem uso", "foi invalidado por reenvio sem uso" ou "foi efetivamente consumido",
-- três fatos distintos que a aplicação e um eventual suporte/auditoria podem precisar
-- diferenciar depois.
--
-- Token errado (AC-04) NÃO invalida o token válido existente — isso é responsabilidade da
-- lógica de aplicação (seção 5: "não invalida por tentativa errada"), o schema não guarda
-- contagem de tentativas erradas porque nenhuma regra do ticket exige bloqueio por
-- contagem (isso é rate limiting, seção 8, delegado ao Backend, mecanismo não especificado
-- pelo ticket e portanto fora do escopo físico deste schema).

CREATE TABLE token_confirmacao_cadastro (
    id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id       uuid NOT NULL REFERENCES app_user (id) ON DELETE CASCADE,
    token         varchar(6) NOT NULL,
    gerado_em     timestamptz NOT NULL DEFAULT now(),
    expira_em     timestamptz NOT NULL,
    consumido_em  timestamptz NULL,
    invalidado_em timestamptz NULL,

    -- Token numérico de 6 dígitos (seção 5: "numérico, dígitos 0-9, ex. 482913").
    CONSTRAINT ck_token_confirmacao_formato CHECK (token ~ '^[0-9]{6}$'),
    -- Expiração é sempre posterior à geração (seção 5: 20 minutos a partir do envio,
    -- mas o valor exato dos minutos é regra de aplicação, não constraint de banco).
    CONSTRAINT ck_token_confirmacao_expira_apos_gerar CHECK (expira_em > gerado_em),
    -- Um token não pode ter sido simultaneamente consumido com sucesso E invalidado por
    -- reenvio — são desfechos mutuamente exclusivos do mesmo token.
    CONSTRAINT ck_token_confirmacao_consumo_exclusivo
        CHECK (consumido_em IS NULL OR invalidado_em IS NULL),
    CONSTRAINT ck_token_confirmacao_consumido_apos_gerar
        CHECK (consumido_em IS NULL OR consumido_em >= gerado_em),
    CONSTRAINT ck_token_confirmacao_invalidado_apos_gerar
        CHECK (invalidado_em IS NULL OR invalidado_em >= gerado_em)
);

-- Suporta a consulta mais comum: histórico de tokens de uma conta, mais recente primeiro
-- (auditoria, e também é a query base para "achar o token ativo atual" antes de filtrar).
CREATE INDEX ix_token_confirmacao_user_gerado ON token_confirmacao_cadastro (user_id, gerado_em DESC);

-- Garantia de integridade forte (banco, não "verificar antes de inserir" na aplicação):
-- no máximo um token "ainda em aberto" (nem consumido, nem invalidado) por conta, a
-- qualquer momento. Isso obriga a aplicação a invalidar o token anterior e inserir o novo
-- na MESMA transação ao reenviar (seção 6) — se tentar inserir um segundo token em aberto
-- sem antes invalidar o primeiro, o INSERT falha na constraint em vez de silenciosamente
-- deixar dois tokens "ativos" e abrir uma corrida entre "qual token o usuário realmente
-- recebeu por e-mail" e "qual o banco aceitaria". Expiração por tempo não precisa ser
-- refletida aqui: um token expirado e nunca invalidado ainda conta como "em aberto" para
-- este índice de propósito — a invalidação explícita (invalidado_em) é responsabilidade da
-- aplicação no momento do reenvio (que já teria de tocar essa linha de qualquer forma para
-- decidir se reenvia ou responde idempotente).
CREATE UNIQUE INDEX ux_token_confirmacao_aberto_por_conta
    ON token_confirmacao_cadastro (user_id)
    WHERE consumido_em IS NULL AND invalidado_em IS NULL;
