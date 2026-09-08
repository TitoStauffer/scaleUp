-- Módulo Content — imutabilidade após publicação
-- Arquitetura e ticket exigem que content_version seja imutável após publicação:
-- alterar conteúdo publicado deve gerar uma NOVA linha (nova versão), nunca sobrescrever
-- a existente. Em vez de depender apenas de disciplina de aplicação, o banco bloqueia
-- qualquer UPDATE ou DELETE em uma linha cujo status_revisao já é 'revisado_aprovado'.
-- Enquanto status_revisao = 'rascunho', a linha pode ser livremente editada (inclusive a
-- própria transição para 'revisado_aprovado').

CREATE OR REPLACE FUNCTION bloquear_alteracao_conteudo_publicado()
RETURNS trigger AS $$
BEGIN
    IF OLD.status_revisao = 'revisado_aprovado' THEN
        RAISE EXCEPTION
            'Linha da tabela % (id=%) já está revisado_aprovado e é imutável; publique uma nova versão em vez de alterar/remover esta linha.',
            TG_TABLE_NAME, OLD.id;
    END IF;

    IF TG_OP = 'UPDATE' THEN
        NEW.atualizado_em := now();
        RETURN NEW;
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_domain_bloquear_alteracao
    BEFORE UPDATE OR DELETE ON domain
    FOR EACH ROW EXECUTE FUNCTION bloquear_alteracao_conteudo_publicado();

CREATE TRIGGER trg_concept_bloquear_alteracao
    BEFORE UPDATE OR DELETE ON concept
    FOR EACH ROW EXECUTE FUNCTION bloquear_alteracao_conteudo_publicado();

CREATE TRIGGER trg_slide_bloquear_alteracao
    BEFORE UPDATE OR DELETE ON slide
    FOR EACH ROW EXECUTE FUNCTION bloquear_alteracao_conteudo_publicado();

CREATE TRIGGER trg_flashcard_bloquear_alteracao
    BEFORE UPDATE OR DELETE ON flashcard
    FOR EACH ROW EXECUTE FUNCTION bloquear_alteracao_conteudo_publicado();

CREATE TRIGGER trg_question_bloquear_alteracao
    BEFORE UPDATE OR DELETE ON question
    FOR EACH ROW EXECUTE FUNCTION bloquear_alteracao_conteudo_publicado();

-- question_alternative não tem status_revisao próprio: sua imutabilidade depende do
-- status_revisao da Question pai.
CREATE OR REPLACE FUNCTION bloquear_alteracao_alternativa_publicada()
RETURNS trigger AS $$
DECLARE
    v_status_question varchar(20);
BEGIN
    SELECT status_revisao INTO v_status_question
      FROM question WHERE id = OLD.question_id;

    IF v_status_question = 'revisado_aprovado' THEN
        RAISE EXCEPTION
            'Alternativa % pertence a uma Question revisado_aprovado e é imutável; publique uma nova versão da Question em vez de alterar/remover esta alternativa.',
            OLD.id;
    END IF;

    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_question_alternative_bloquear_alteracao
    BEFORE UPDATE OR DELETE ON question_alternative
    FOR EACH ROW EXECUTE FUNCTION bloquear_alteracao_alternativa_publicada();
