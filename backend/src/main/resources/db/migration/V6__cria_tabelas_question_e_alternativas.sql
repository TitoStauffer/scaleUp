-- Módulo Content — Question + Alternativas
-- concept_ref é OPCIONAL, mesma decisão e mecanismo de Flashcard (OPEN QUESTION-003).
-- domain_ref é OBRIGATÓRIO: é a referência usada por DomainProgress para calcular pontos
-- fortes/fracos por categoria (categoria = Domain, não Concept — ver histórico de revisão
-- do ticket mestre de conteúdo).

CREATE TABLE question (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_ref      uuid NOT NULL REFERENCES domain (id) ON DELETE RESTRICT,
    concept_ref     uuid NULL,
    enunciado       text NOT NULL,
    explicacao      text NOT NULL,
    dificuldade     varchar(10) NOT NULL,
    content_version varchar(50) NOT NULL,
    status_revisao  varchar(20) NOT NULL DEFAULT 'rascunho',
    criado_em       timestamptz NOT NULL DEFAULT now(),
    atualizado_em   timestamptz NOT NULL DEFAULT now(),

    CONSTRAINT fk_question_concept_domain FOREIGN KEY (concept_ref, domain_ref)
        REFERENCES concept (id, domain_ref) ON DELETE RESTRICT,
    CONSTRAINT uq_question_domain_enunciado UNIQUE (domain_ref, enunciado),
    CONSTRAINT ck_question_enunciado_nao_vazio CHECK (length(btrim(enunciado)) > 0),
    CONSTRAINT ck_question_explicacao_nao_vazia CHECK (length(btrim(explicacao)) > 0),
    CONSTRAINT ck_question_dificuldade CHECK (dificuldade IN ('facil', 'media', 'dificil')),
    CONSTRAINT ck_question_content_version_nao_vazio CHECK (length(btrim(content_version)) > 0),
    CONSTRAINT ck_question_status_revisao CHECK (status_revisao IN ('rascunho', 'revisado_aprovado'))
);

CREATE INDEX ix_question_domain_ref ON question (domain_ref);
CREATE INDEX ix_question_concept_ref ON question (concept_ref);
CREATE INDEX ix_question_domain_status_dificuldade ON question (domain_ref, status_revisao, dificuldade);

-- Alternativas não têm content_version/status_revisao próprios: fazem parte da versão da
-- Question à qual pertencem, não são uma entidade versionada independente.
CREATE TABLE question_alternative (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    question_id uuid NOT NULL REFERENCES question (id) ON DELETE CASCADE,
    texto       text NOT NULL,
    correta     boolean NOT NULL DEFAULT false,
    criado_em   timestamptz NOT NULL DEFAULT now(),

    -- Suporte à FK composta usada por Answer (alternativa_selecionada_id, question_id),
    -- que garante no banco que a alternativa marcada como resposta pertence à Question
    -- efetivamente respondida.
    CONSTRAINT uq_question_alternative_id_question UNIQUE (id, question_id),
    CONSTRAINT uq_question_alternative_texto UNIQUE (question_id, texto),
    CONSTRAINT ck_question_alternative_texto_nao_vazio CHECK (length(btrim(texto)) > 0)
);

-- Garante, de forma imediata (não adiada), que no máximo 1 alternativa por Question está
-- marcada como correta. Não garante sozinha "exatamente 1" nem "exatamente 4" — isso é
-- responsabilidade do trigger adiado abaixo, avaliado ao final da transação.
CREATE UNIQUE INDEX ux_question_alternative_unica_correta
    ON question_alternative (question_id) WHERE correta;

CREATE INDEX ix_question_alternative_question_id ON question_alternative (question_id);

-- Trigger de constraint adiada: garante, ao final da transação, que toda Question ainda
-- existente tem exatamente 4 alternativas e exatamente 1 marcada como correta.
-- É DEFERRABLE INITIALLY DEFERRED porque a aplicação insere as 4 alternativas em
-- statements separados dentro da mesma transação da Question; validar a cada INSERT
-- individual quebraria esse fluxo (o requisito ao Backend Engineer é: inserir a Question e
-- suas 4 alternativas na mesma transação).
-- Se a própria Question estiver sendo removida (cascade apaga as alternativas junto), a
-- checagem é pulada — não há mais Question para validar.
CREATE OR REPLACE FUNCTION verificar_alternativas_question()
RETURNS trigger AS $$
DECLARE
    v_question_id uuid;
    v_total       integer;
    v_corretas    integer;
BEGIN
    v_question_id := COALESCE(NEW.question_id, OLD.question_id);

    IF NOT EXISTS (SELECT 1 FROM question WHERE id = v_question_id) THEN
        RETURN NULL;
    END IF;

    SELECT count(*), count(*) FILTER (WHERE correta)
      INTO v_total, v_corretas
      FROM question_alternative
     WHERE question_id = v_question_id;

    IF v_total <> 4 THEN
        RAISE EXCEPTION 'Question % deve ter exatamente 4 alternativas (encontrado: %)',
            v_question_id, v_total;
    END IF;

    IF v_corretas <> 1 THEN
        RAISE EXCEPTION 'Question % deve ter exatamente 1 alternativa correta (encontrado: %)',
            v_question_id, v_corretas;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE CONSTRAINT TRIGGER trg_verificar_alternativas_question
    AFTER INSERT OR UPDATE OR DELETE ON question_alternative
    DEFERRABLE INITIALLY DEFERRED
    FOR EACH ROW EXECUTE FUNCTION verificar_alternativas_question();
