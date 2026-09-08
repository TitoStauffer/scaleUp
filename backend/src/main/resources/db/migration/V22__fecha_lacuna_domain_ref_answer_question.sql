-- Módulo Assessment — fecha lacuna de integridade entre Answer e Question (domain_ref).
--
-- Achado (TICKET-assessment-progress.md, seção 8): nada no banco garantia que uma
-- `answer` referenciasse uma `question` do MESMO domínio do `quiz_attempt` ao qual ela
-- pertence. Era estruturalmente possível gravar uma Answer de uma Question de
-- "Segurança" dentro de um QuizAttempt cujo domain_ref é "Bancos de Dados". A única
-- proteção existente era validação de aplicação (AC-03 do ticket), como controle
-- temporário — o ticket pede que isso seja fechado no banco.
--
-- Mecanismo escolhido: o mesmo já usado em todo o schema para herdar consistência do
-- pai (slide/concept, question/concept, quiz_attempt/study_session, answer/
-- question_alternative) — denormalizar domain_ref na tabela filha e amarrar com FK
-- composta contra (id, domain_ref) da(s) tabela(s) pai. Aqui, diferente dos casos
-- anteriores (1 pai), Answer tem DOIS "pais" que precisam concordar sobre o domínio:
--   1. A Question respondida (domain_ref da pergunta em si).
--   2. O QuizAttempt ao qual a resposta pertence (domain_ref da tentativa).
-- Solução: adicionar `answer.domain_ref` e criar DUAS FKs compostas, uma contra cada
-- pai. Como ambas obrigam `answer.domain_ref` a bater exatamente com o domain_ref do
-- respectivo pai, a transitividade força `question.domain_ref = quiz_attempt.domain_ref`
-- para qualquer Answer que exista — a inconsistência relatada no ticket deixa de ser
-- representável no banco, não apenas checada pela aplicação.
--
-- Alternativas consideradas e descartadas:
--   - Trigger de validação customizado: funciona, mas o próprio schema já estabelece
--     (seção 7 de database-schema.md) que FK composta é preferida a trigger sempre que
--     a regra é "coluna denormalizada deve bater com a do pai" — é declarativo, mais
--     barato de manter e o otimizador já sabe lidar com ele. Trigger fica reservado
--     para regras que uma FK não consegue expressar (ex.: "exatamente 4 alternativas").
--   - CHECK com subquery: Postgres não permite subquery em CHECK constraint.
--   - Só manter a validação de aplicação (não fechar no banco): rejeitado — é
--     exatamente a lacuna que o ticket pede para fechar; validação de aplicação sozinha
--     não sobrevive a um bug de código, uma migração de dados manual ou um acesso direto
--     ao banco fora da aplicação.
--
-- `question` ainda não tinha UNIQUE (id, domain_ref) (só question_alternative tinha,
-- para suportar a FK de Answer contra alternativa). Precisa existir para servir de alvo
-- de FK composta aqui — criá-la é seguro e imediato: `id` já é PK (portanto já único
-- sozinho), então UNIQUE (id, domain_ref) nunca pode falhar contra dados existentes.
-- O mesmo vale para `quiz_attempt`, que também não tinha essa constraint ainda.
--
-- Migração aditiva em 3 passos (coluna nullable -> backfill -> NOT NULL + FKs), seguindo
-- o mesmo padrão já usado em V21 (concept.ordem), para nunca deixar uma linha existente
-- inconsistente durante a aplicação da migração. Não há dados de produção em `answer`
-- ainda (módulo Assessment não tem implementação de aplicação até o momento desta
-- migração), mas o backfill é feito do mesmo jeito por disciplina — este script precisa
-- continuar correto se um dia rodar contra um banco com dados reais.

-- =====================================================================================
-- 1. UNIQUE (id, domain_ref) nos dois "pais" de Answer, para servir de alvo de FK composta
-- =====================================================================================

ALTER TABLE question ADD CONSTRAINT uq_question_id_domain UNIQUE (id, domain_ref);
ALTER TABLE quiz_attempt ADD CONSTRAINT uq_quiz_attempt_id_domain UNIQUE (id, domain_ref);

-- =====================================================================================
-- 2. Coluna nova em answer, nullable, com backfill a partir da Question respondida
-- =====================================================================================

ALTER TABLE answer ADD COLUMN domain_ref uuid;

UPDATE answer a
   SET domain_ref = q.domain_ref
  FROM question q
 WHERE q.id = a.question_id
   AND a.domain_ref IS NULL;

-- =====================================================================================
-- 3. NOT NULL + FKs compostas contra os dois pais + índice (mesmo padrão de
--    ix_quiz_attempt_domain em V10)
-- =====================================================================================

ALTER TABLE answer ALTER COLUMN domain_ref SET NOT NULL;

-- Garante que a Question referenciada por esta Answer pertence ao domain_ref gravado
-- na própria Answer.
ALTER TABLE answer ADD CONSTRAINT fk_answer_question_domain FOREIGN KEY (question_id, domain_ref)
    REFERENCES question (id, domain_ref) ON DELETE RESTRICT;

-- Garante que o domain_ref gravado na Answer é exatamente o do QuizAttempt ao qual ela
-- pertence. Combinada com a FK acima, torna estruturalmente impossível uma Answer cujo
-- QuizAttempt e Question discordem de domínio — a lacuna do ticket fica fechada no banco.
ALTER TABLE answer ADD CONSTRAINT fk_answer_quiz_attempt_domain FOREIGN KEY (quiz_attempt_id, domain_ref)
    REFERENCES quiz_attempt (id, domain_ref) ON DELETE CASCADE;

CREATE INDEX ix_answer_domain ON answer (domain_ref);
