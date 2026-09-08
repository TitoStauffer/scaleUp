-- Módulo Progress — configuração de níveis e pesos
-- O PRD exige que os 12 níveis (Junior 1-3, Pleno 1-3, Senior 1-3, Especialista 1-3) e
-- seus thresholds, e os pesos dos 5 componentes de pontuação, sejam configuráveis — "não
-- codificados em múltiplas telas ou regras duplicadas". Ambos são modelados como dados,
-- seguindo o mesmo princípio já aplicado a Domain.

CREATE TABLE nivel_referencia (
    id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    slug             varchar(30) NOT NULL,
    nome             varchar(60) NOT NULL,
    ordem            smallint NOT NULL,
    pontuacao_minima numeric(5, 2) NOT NULL,
    pontuacao_maxima numeric(5, 2) NOT NULL,

    CONSTRAINT uq_nivel_referencia_slug UNIQUE (slug),
    CONSTRAINT uq_nivel_referencia_ordem UNIQUE (ordem),
    CONSTRAINT ck_nivel_referencia_ordem CHECK (ordem BETWEEN 1 AND 12),
    CONSTRAINT ck_nivel_referencia_faixa CHECK (pontuacao_minima < pontuacao_maxima),
    CONSTRAINT ck_nivel_referencia_pontuacao_minima CHECK (pontuacao_minima >= 0),
    CONSTRAINT ck_nivel_referencia_pontuacao_maxima CHECK (pontuacao_maxima <= 100)
);

-- ATENÇÃO — PENDÊNCIA PARA O PM: os thresholds abaixo são um PLACEHOLDER (12 faixas de
-- largura igual, ~8.33 pontos cada) só para permitir que o sistema funcione de ponta a
-- ponta. O PRD define os 12 níveis mas não os cortes de pontuação entre eles — isso é uma
-- decisão de produto que não foi tomada e não deve ser inventada silenciosamente pelo DBA
-- (ver docs/architecture/database-schema.md). Ajustar via UPDATE nesta tabela quando o PM
-- definir os valores reais — nunca via novo código ou nova migração destrutiva.
INSERT INTO nivel_referencia (slug, nome, ordem, pontuacao_minima, pontuacao_maxima) VALUES
    ('junior-1', 'Júnior 1', 1, 0.00, 8.33),
    ('junior-2', 'Júnior 2', 2, 8.33, 16.67),
    ('junior-3', 'Júnior 3', 3, 16.67, 25.00),
    ('pleno-1', 'Pleno 1', 4, 25.00, 33.33),
    ('pleno-2', 'Pleno 2', 5, 33.33, 41.67),
    ('pleno-3', 'Pleno 3', 6, 41.67, 50.00),
    ('senior-1', 'Sênior 1', 7, 50.00, 58.33),
    ('senior-2', 'Sênior 2', 8, 58.33, 66.67),
    ('senior-3', 'Sênior 3', 9, 66.67, 75.00),
    ('especialista-1', 'Especialista 1', 10, 75.00, 83.33),
    ('especialista-2', 'Especialista 2', 11, 83.33, 91.67),
    ('especialista-3', 'Especialista 3', 12, 91.67, 100.00);

CREATE TABLE componente_peso (
    id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    componente varchar(30) NOT NULL,
    peso       numeric(4, 3) NOT NULL,
    ordem      smallint NOT NULL,

    CONSTRAINT uq_componente_peso_componente UNIQUE (componente),
    CONSTRAINT uq_componente_peso_ordem UNIQUE (ordem),
    CONSTRAINT ck_componente_peso_valor CHECK (peso > 0 AND peso <= 1),
    CONSTRAINT ck_componente_peso_nome CHECK (
        componente IN ('quiz', 'flashcards', 'questoes_novas', 'consistencia', 'calibracao_confianca')
    )
);

-- Pesos definidos explicitamente no PRD (requisito funcional 7) — não são placeholder.
-- A soma (1.000) não é validada por constraint de banco (ver database-schema.md); deve
-- ser verificada pela aplicação/testes ao alterar esta tabela.
INSERT INTO componente_peso (componente, peso, ordem) VALUES
    ('quiz', 0.40, 1),
    ('flashcards', 0.25, 2),
    ('questoes_novas', 0.20, 3),
    ('consistencia', 0.10, 4),
    ('calibracao_confianca', 0.05, 5);
