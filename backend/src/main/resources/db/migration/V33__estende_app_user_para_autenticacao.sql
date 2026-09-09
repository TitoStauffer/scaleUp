-- Módulo Identity — autenticação real (TICKET-autenticacao.md)
--
-- Decisão do DBA: ESTENDER app_user via ALTER TABLE, não substituir por uma tabela nova.
-- Motivo: app_user.id (uuid) já é referenciado por FK em study_session.user_id (V9) e
-- domain_progress.user_id (V12), e transitivamente por quiz_attempt/answer/flashcard_review
-- via study_session (V9/V10). A própria V8 já previa isso: "Não inclui credenciais/senha
-- ainda — serão adicionadas depois via migração aditiva (ALTER TABLE ... ADD COLUMN ...
-- NULL), quando a autenticação for de fato implementada." Trocar de tabela exigiria recriar
-- todas essas FKs (drop+add em 4 tabelas) sem nenhum ganho de integridade ou modelagem —
-- o "usuário" continua sendo a mesma entidade de domínio, só ganhando os atributos que
-- faltavam. PK e tipo (uuid) permanecem idênticos, então nenhuma FK existente é tocada.
--
-- O que muda:
--   1. senha_hash: obrigatória para contas novas, mas adicionada como NULL porque o
--      usuário local semeado por V24 será removido nesta mesma migração antes de a coluna
--      virar NOT NULL — não há linha remanescente sem hash quando a constraint é aplicada.
--   2. status_conta: enum textual + CHECK, mesmo padrão já usado no projeto para
--      status_revisao/dificuldade/status de sessão (ver docs/architecture/database-schema.md
--      seção 7) — não CREATE TYPE, para manter evolução barata via
--      DROP CONSTRAINT + ADD CONSTRAINT numa migração futura, sem risco de lock de DDL
--      versionado que ALTER TYPE ... ADD VALUE exige. Valores: só 'pendente' e 'ativo'
--      (ticket seção 9 menciona "conta desativada" como possível estado futuro, mas marca
--      isso explicitamente como fora de escopo agora — não modelo um terceiro valor
--      hipotético sem consumidor definido).
--   3. nome: passa a ser opcional (estava NOT NULL em V8). O ticket de autenticação (seção
--      4) define cadastro como e-mail + senha + confirmação de senha — não há campo "nome"
--      no fluxo de cadastro real. Manter NOT NULL quebraria o INSERT do fluxo de cadastro
--      assim que implementado. Isto é uma consequência estrutural do novo fluxo de dados
--      descrito no ticket, não uma decisão de regra de negócio nova por parte do DBA.
--   4. Descarte do usuário local (V24) e de todo o histórico de teste associado a ele —
--      decisão explícita do ticket (seção 3, item 5): "não é necessário migrar ou preservar
--      nenhum dado do usuário semeado por V24". A remoção respeita a ordem exigida pelos
--      ON DELETE RESTRICT existentes (domain_progress) e se apoia nos ON DELETE CASCADE já
--      existentes (study_session -> quiz_attempt -> answer/quiz_attempt_question,
--      study_session -> flashcard_review) para não precisar reimplementar cada cascade aqui.

-- 1) Descarta domain_progress do usuário local (única dependência com ON DELETE RESTRICT).
DELETE FROM domain_progress
WHERE user_id IN (SELECT id FROM app_user WHERE email = 'local@scaleup.dev');

-- 2) Descarta as sessões de estudo do usuário local — CASCADE já remove
--    quiz_attempt, answer, quiz_attempt_question e flashcard_review associados.
DELETE FROM study_session
WHERE user_id IN (SELECT id FROM app_user WHERE email = 'local@scaleup.dev');

-- 3) Descarta o próprio usuário local semeado por V24.
DELETE FROM app_user WHERE email = 'local@scaleup.dev';

-- 4) Estende app_user com os atributos de autenticação real.
ALTER TABLE app_user
    ADD COLUMN senha_hash   varchar(255) NULL,
    ADD COLUMN status_conta varchar(20)  NULL;

-- 5) Backfill não é necessário: a tabela está vazia neste ponto desta migração (passo 3
--    removeu a única linha existente no MVP). Ainda assim, o UPDATE abaixo é mantido por
--    segurança/idempotência caso este schema já tenha outras linhas em algum ambiente onde
--    o seed V24 não tenha sido a única fonte de dados — nesse caso não há hash real
--    disponível, então a linha é marcada como pendente para forçar novo fluxo de
--    confirmação em vez de assumir uma senha que nunca existiu.
UPDATE app_user SET status_conta = 'pendente' WHERE status_conta IS NULL;

-- 6) Agora que não há mais linha sem status, a constraint pode exigir o valor.
--    senha_hash permanece NULL-able no schema porque o banco não decide a regra de negócio
--    de "toda conta precisa de hash" — isso é imposto pela aplicação no momento do cadastro
--    (a própria natureza de hash bcrypt não tem um valor placeholder seguro para forçar
--    NOT NULL sem inventar um hash falso). Ver nota para o Backend Engineer no handoff.
ALTER TABLE app_user
    ALTER COLUMN status_conta SET NOT NULL,
    ALTER COLUMN status_conta SET DEFAULT 'pendente',
    ALTER COLUMN nome DROP NOT NULL;

ALTER TABLE app_user
    ADD CONSTRAINT ck_app_user_status_conta CHECK (status_conta IN ('pendente', 'ativo')),
    ADD CONSTRAINT ck_app_user_senha_hash_nao_vazio
        CHECK (senha_hash IS NULL OR length(btrim(senha_hash)) > 0);

-- Índice de apoio a login (busca por e-mail já é coberta pela UNIQUE de V8, mas o filtro
-- por status é comum no fluxo de confirmação/reenvio: "contas pendentes"). Volume esperado
-- (dezenas de milhares de contas no MVP) não justificaria por si só um índice dedicado,
-- mas como o predicado (status_conta = 'pendente') tende a ser uma fração pequena da
-- tabela à medida que ela cresce, um índice parcial é praticamente gratuito em espaço.
CREATE INDEX ix_app_user_status_pendente ON app_user (email) WHERE status_conta = 'pendente';
