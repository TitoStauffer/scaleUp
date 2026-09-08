-- Módulo Assessment — fecha lacuna de integridade: registra QUAIS questões foram
-- sorteadas para cada QuizAttempt.
--
-- Achado (QA): IniciarQuizAttemptService sorteia 10 questões e devolve no DTO, mas nunca
-- persiste esse conjunto. Na submissão, SubmeterQuizAttemptService só valida contagem
-- (10 respostas), domínio (AC-03) e ausência de duplicata (Set<UUID> no payload) — nada
-- valida que as questões recebidas são efetivamente as que foram sorteadas para aquela
-- tentativa. Resultado: o cliente pode trocar 1+ questão por outra qualquer do mesmo
-- domínio (inclusive de outra tentativa, inclusive uma que ele já sabe a resposta de uma
-- tentativa anterior), inflando a pontuação. Reproduzido ao vivo pelo QA.
--
-- Mecanismo escolhido: tabela de junção `quiz_attempt_question`, gravada no momento em
-- que IniciarQuizAttemptService sorteia as questões (mesma transação do INSERT em
-- quiz_attempt), seguindo o mesmo padrão já estabelecido em V22 para Answer: domain_ref
-- denormalizado + FK composta contra os dois "pais" que precisam concordar sobre o
-- domínio (a Question sorteada e o QuizAttempt ao qual o sorteio pertence).
--
-- Por que PK composta (quiz_attempt_id, question_id) em vez de id substituto próprio:
-- a identidade natural da linha É o par (tentativa, questão) — não existe conceito de
-- "duas linhas para a mesma questão na mesma tentativa" (isso seria exatamente o bug que
-- estamos fechando) nem motivo para referenciar uma linha desta tabela a partir de outro
-- lugar. A PK composta já impõe unicidade sem precisar de um UNIQUE adicional.
--
-- Por que a coluna `ordem`: o sorteio de IniciarQuizAttemptService já produz uma ordem de
-- apresentação (List<Question> embaralhada). Persistir essa ordem custa uma coluna e
-- evita que o Backend precise resolver "em que sequência mostrar as 10 questões" via
-- outro mecanismo (ex.: reordenar por criado_em, que reintroduziria padrão previsível).
-- Não é estritamente exigida pelo defeito relatado (que é sobre integridade do CONJUNTO,
-- não da ordem), mas é uma extensão de custo marginal quase zero dado que o dado já
-- existe em memória no momento do INSERT, então optamos por incluir agora em vez de
-- reabrir a tabela depois. UNIQUE (quiz_attempt_id, ordem) garante que a mesma tentativa
-- não tenha duas questões na mesma posição.
--
-- Por que domain_ref denormalizado + FK dupla (não apenas FK simples contra question):
-- mesmo raciocínio de V22 — sem o domain_ref aqui e as duas FKs compostas, seria
-- estruturalmente possível gravar, para um QuizAttempt de "Bancos de Dados", uma questão
-- sorteada de "Segurança". A FK composta contra question(id, domain_ref) garante que a
-- questão sorteada pertence ao domínio gravado nesta linha; a FK composta contra
-- quiz_attempt(id, domain_ref) garante que esse domínio é exatamente o da tentativa. As
-- duas juntas tornam a inconsistência de domínio irrepresentável no banco, não apenas
-- checada pela aplicação — ambos os alvos (question e quiz_attempt) já têm a UNIQUE
-- (id, domain_ref) necessária desde V22, reaproveitada aqui sem alteração.
--
-- ON DELETE: CASCADE contra quiz_attempt (se a tentativa for removida, o registro de
-- sorteio não tem mais razão de existir — mesma política já usada por answer.quiz_attempt_id
-- em V10). RESTRICT contra question (mesma política já usada por answer.question_id e
-- fk_answer_question_domain em V10/V22 — uma Question referenciada por um sorteio
-- existente não pode ser apagada por baixo).

CREATE TABLE quiz_attempt_question (
    quiz_attempt_id uuid NOT NULL,
    question_id     uuid NOT NULL,
    domain_ref      uuid NOT NULL,
    ordem           smallint NOT NULL,
    sorteada_em     timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT pk_quiz_attempt_question PRIMARY KEY (quiz_attempt_id, question_id),

    -- Garante que a Question sorteada pertence ao domain_ref gravado nesta linha.
    CONSTRAINT fk_quiz_attempt_question_question_domain FOREIGN KEY (question_id, domain_ref)
        REFERENCES question (id, domain_ref) ON DELETE RESTRICT,

    -- Garante que o domain_ref gravado nesta linha é exatamente o do QuizAttempt ao qual
    -- o sorteio pertence. Combinada com a FK acima, torna estruturalmente impossível uma
    -- linha cujo QuizAttempt e Question discordem de domínio.
    CONSTRAINT fk_quiz_attempt_question_attempt_domain FOREIGN KEY (quiz_attempt_id, domain_ref)
        REFERENCES quiz_attempt (id, domain_ref) ON DELETE CASCADE,

    CONSTRAINT uq_quiz_attempt_question_ordem UNIQUE (quiz_attempt_id, ordem),
    CONSTRAINT ck_quiz_attempt_question_ordem CHECK (ordem BETWEEN 1 AND 10)
);

CREATE INDEX ix_quiz_attempt_question_domain ON quiz_attempt_question (domain_ref);
CREATE INDEX ix_quiz_attempt_question_question ON quiz_attempt_question (question_id);
