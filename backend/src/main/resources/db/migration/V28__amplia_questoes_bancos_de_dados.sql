-- Ampliação do pool de Questions — Domínio Bancos de Dados (slug: bancos-de-dados)
-- Ticket: docs/product/tickets/TICKET-content-expansion-questoes.md (Fase 1)
-- Ticket mestre: docs/product/tickets/TICKET-content-database.md
--
-- Fase 1: +18 Questions novas (6 fácil, 6 média, 6 difícil), somando às 18 já existentes
-- em V16__seed_conteudo_bancos_de_dados.sql -> total de 36 Questions neste domínio.
--
-- Nenhum Concept/Slide/Flashcard novo nesta migração — apenas INSERT em question e
-- question_alternative, reaproveitando os 5 Concepts já existentes (UUIDs literais
-- a3000000-0000-4000-8000-000000000001..5, criados em V16).
--
-- Autoria assistida por IA (rascunho), revisão humana obrigatória antes de produção —
-- por isso content_version = 'v1' e status_revisao = 'rascunho' em todas as linhas,
-- mesma convenção do lote original (OPEN QUESTION-005 do ticket de ampliação: mantém 'v1').
--
-- Enunciados novos conferidos individualmente contra os 18 já existentes em V16 para
-- evitar duplicação literal ou disfarçada (mesmo ponto testado com outras palavras).

-- =====================================================================
-- QUESTIONS + ALTERNATIVAS (18 novas: 6 fácil, 6 média, 6 difícil)
-- =====================================================================

-- ---- FÁCIL (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000001',
    'Qual é a função de uma chave estrangeira (foreign key) em um banco relacional?',
    'Uma chave estrangeira garante integridade referencial: impede que um registro referencie, em outra tabela, um valor que não existe, mantendo a consistência dos relacionamentos entre tabelas.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Garantir integridade referencial, impedindo referências a registros inexistentes', true),
    ('Acelerar automaticamente todas as consultas que usam a coluna', false),
    ('Permitir que a mesma linha seja duplicada em várias tabelas com segurança', false),
    ('Substituir a necessidade de uma chave primária na tabela', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Qual é a função de uma chave estrangeira (foreign key) em um banco relacional?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000001',
    'Qual família de banco NoSQL é mais indicada para modelar e percorrer relacionamentos complexos entre entidades, como conexões em uma rede social?',
    'Bancos de grafo (como o Neo4j) são otimizados para armazenar entidades e suas conexões, permitindo percorrer relacionamentos complexos com bom desempenho, o que modelos de documento ou chave-valor não fazem naturalmente.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Banco de grafo', true),
    ('Banco de documento', false),
    ('Banco chave-valor', false),
    ('Banco de coluna larga', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Qual família de banco NoSQL é mais indicada para modelar e percorrer relacionamentos complexos entre entidades, como conexões em uma rede social?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000002',
    'Qual tipo de índice permite apenas buscas por igualdade exata, sem suportar consultas por faixa como BETWEEN?',
    'Índices hash localizam uma chave em tempo constante, mas só suportam igualdade exata: não mantêm nenhuma ordenação interna que permita responder consultas por intervalo, ao contrário de um índice B-tree.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Índice hash', true),
    ('Índice B-tree', false),
    ('Índice composto', false),
    ('Índice parcial', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Qual tipo de índice permite apenas buscas por igualdade exata, sem suportar consultas por faixa como BETWEEN?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000003',
    'Quais comandos demarcam o início e o encerramento de uma transação em SQL?',
    'BEGIN inicia o agrupamento de operações em uma transação; COMMIT confirma todas elas de uma vez, e ROLLBACK as desfaz por completo caso algo dê errado antes da confirmação.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('BEGIN, e COMMIT ou ROLLBACK', true),
    ('SELECT e INSERT', false),
    ('CREATE e DROP', false),
    ('GRANT e REVOKE', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Quais comandos demarcam o início e o encerramento de uma transação em SQL?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000004',
    'O que caracteriza um "dirty read"?',
    'Um dirty read ocorre quando uma transação lê um dado alterado por outra transação que ainda não foi confirmada (commit); se essa segunda transação for desfeita, o dado lido nunca chegou a existir de fato.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Ler um dado alterado por uma transação ainda não confirmada', true),
    ('Ler duas vezes a mesma linha e obter valores diferentes', false),
    ('Ler um conjunto de linhas que muda entre duas execuções da mesma consulta', false),
    ('Ler uma linha que já foi permanentemente removida do banco', false)
) AS x(texto, correta)
WHERE q.enunciado = 'O que caracteriza um "dirty read"?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000005',
    'Qual é a principal vantagem prática de manter réplicas (seguidores) de leitura em um banco de dados?',
    'Réplicas de leitura permitem distribuir as consultas de leitura entre múltiplos nós, aliviando a carga sobre o líder, que continua sendo o único responsável por processar escritas.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Distribuir a carga de leitura entre múltiplos nós, aliviando o líder', true),
    ('Aumentar diretamente a capacidade de escrita do sistema', false),
    ('Eliminar a necessidade de backups periódicos', false),
    ('Garantir consistência forte automaticamente entre todos os nós', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Qual é a principal vantagem prática de manter réplicas (seguidores) de leitura em um banco de dados?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

-- ---- MÉDIA (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000001',
    'Um sistema precisa registrar um altíssimo volume de eventos de sensores (série temporal), com escrita constante e leitura tipicamente por partição. Qual família de banco tende a se encaixar melhor?',
    'Bancos de coluna larga, como o Cassandra, são otimizados justamente para grandes volumes de escrita e leitura por partição, cenário típico de séries temporais e eventos, algo que um banco relacional normalizado sustenta com mais dificuldade nessa escala.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Banco de coluna larga', true),
    ('Banco de grafo', false),
    ('Banco relacional altamente normalizado', false),
    ('Banco de documento com leitura sempre do documento inteiro', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Um sistema precisa registrar um altíssimo volume de eventos de sensores (série temporal), com escrita constante e leitura tipicamente por partição. Qual família de banco tende a se encaixar melhor?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000002',
    'Além do espaço em disco adicional, qual é o principal custo de manter um índice em uma tabela com alta frequência de escrita?',
    'Toda operação de INSERT, UPDATE ou DELETE precisa também atualizar as estruturas dos índices existentes na tabela, o que torna as escritas mais lentas quanto mais índices a tabela tiver.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Cada escrita precisa também atualizar as estruturas dos índices, tornando-a mais lenta', true),
    ('As leituras passam a retornar dados desatualizados com mais frequência', false),
    ('O índice impede que a tabela seja usada em consultas com JOIN', false),
    ('O índice força o bloqueio de toda a tabela a cada escrita', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Além do espaço em disco adicional, qual é o principal custo de manter um índice em uma tabela com alta frequência de escrita?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000003',
    'Em contraste com a atomicidade, o que especificamente a garantia de "isolamento" em ACID assegura?',
    'Isolamento assegura que transações concorrentes não enxerguem estados intermediários umas das outras, ainda que estejam sendo executadas ao mesmo tempo — é uma garantia distinta de atomicidade (tudo ou nada) e de consistência (respeito às regras de integridade do schema).',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Que transações concorrentes não enxerguem estados intermediários umas das outras', true),
    ('Que a transação nunca falhe, independente do que aconteça', false),
    ('Que os dados persistam mesmo após uma queda de energia', false),
    ('Que todas as constraints do schema sejam respeitadas pela transação', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Em contraste com a atomicidade, o que especificamente a garantia de "isolamento" em ACID assegura?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000004',
    'Qual é o nível de isolamento padrão do MySQL/InnoDB, e qual fenômeno clássico ele previne em relação ao Read Committed?',
    'O MySQL/InnoDB usa Repeatable Read como padrão, que além de prevenir dirty read (como o Read Committed já faz), também previne non-repeatable read, garantindo que releituras da mesma linha dentro de uma transação retornem sempre o mesmo valor.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Repeatable Read; previne também non-repeatable read', true),
    ('Read Uncommitted; previne apenas dirty read', false),
    ('Serializable; previne todos os fenômenos, incluindo phantom read', false),
    ('Read Committed; previne apenas dirty read', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Qual é o nível de isolamento padrão do MySQL/InnoDB, e qual fenômeno clássico ele previne em relação ao Read Committed?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000005',
    'Qual é a principal diferença entre particionamento por hash e particionamento por faixa (range), em termos de distribuição de carga e ordenação dos dados?',
    'Particionamento por hash tende a distribuir a carga de forma mais uniforme entre as partições, mas perde a ordenação natural entre elas; particionamento por faixa preserva a ordenação (bom para varreduras ordenadas), mas é mais propenso a hot spots quando a chave cresce continuamente.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Hash distribui a carga de forma mais uniforme, mas perde ordenação; range preserva ordenação, mas é mais propenso a hot spots', true),
    ('Hash é sempre mais lento e range é sempre mais rápido, independente do padrão de acesso', false),
    ('Particionamento por hash elimina completamente a necessidade de rebalanceamento futuro', false),
    ('Particionamento por range só pode ser aplicado a chaves numéricas', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Qual é a principal diferença entre particionamento por hash e particionamento por faixa (range), em termos de distribuição de carga e ordenação dos dados?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000002',
    'Ao analisar um plano de execução com EXPLAIN ANALYZE, por que uma grande diferença entre o número de linhas estimado pelo otimizador e o número real retornado costuma ser um sinal de alerta?',
    'Uma estimativa muito distante do valor real geralmente indica estatísticas desatualizadas sobre a distribuição dos dados, o que leva o otimizador a escolher um plano de execução abaixo do ideal (por exemplo, um Seq Scan quando um Index Scan seria mais barato).',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Indica estatísticas desatualizadas, levando o otimizador a escolher um plano abaixo do ideal', true),
    ('Essa diferença nunca influencia o plano escolhido pelo otimizador', false),
    ('Sempre significa que o índice da tabela está corrompido', false),
    ('Significa que a consulta necessariamente vai falhar em produção', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Ao analisar um plano de execução com EXPLAIN ANALYZE, por que uma grande diferença entre o número de linhas estimado pelo otimizador e o número real retornado costuma ser um sinal de alerta?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

-- ---- DIFÍCIL (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000001',
    'Por que, mesmo em sistemas de grande escala, dados como saldo de conta ou controle de estoque tendem a permanecer em um banco relacional em vez de migrar para um banco NoSQL de alta escala?',
    'Esses dados costumam exigir transações multi-tabela com garantias fortes de integridade (ACID completo) — atualizar saldo e criar um lançamento contábil, por exemplo, precisam ser atômicos e isolados — algo que a maioria dos bancos NoSQL relaxa deliberadamente em troca de mais escala e disponibilidade.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Porque exigem transações multi-tabela com garantias ACID fortes, que bancos NoSQL tipicamente relaxam', true),
    ('Porque bancos NoSQL não suportam nenhum tipo de escrita concorrente', false),
    ('Porque bancos relacionais são sempre mais rápidos, em qualquer escala de dados', false),
    ('Porque bancos NoSQL não conseguem armazenar valores numéricos decimais', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Por que, mesmo em sistemas de grande escala, dados como saldo de conta ou controle de estoque tendem a permanecer em um banco relacional em vez de migrar para um banco NoSQL de alta escala?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000002',
    'Por que um índice hash não ajuda em uma consulta que usa o operador BETWEEN sobre a coluna indexada, mesmo com o índice presente?',
    'Índices hash mapeiam cada valor a uma posição por meio de uma função hash, sem preservar nenhuma ordenação entre os valores — por isso só respondem buscas por igualdade exata, e não conseguem localizar diretamente um intervalo de valores como um BETWEEN exige.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Índices hash só suportam igualdade exata e não preservam ordenação entre os valores', true),
    ('Porque o operador BETWEEN sempre força um full table scan, independente do índice existente', false),
    ('Porque índices hash só podem ser criados sobre colunas numéricas', false),
    ('Porque o otimizador ignora índices hash sempre que há mais de uma condição no WHERE', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Por que um índice hash não ajuda em uma consulta que usa o operador BETWEEN sobre a coluna indexada, mesmo com o índice presente?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000003',
    'Garantir ACID completo em um banco distribuído entre múltiplos nós tipicamente exige qual mecanismo adicional, ausente em um banco de nó único?',
    'Bancos distribuídos precisam de um protocolo de commit distribuído (como two-phase commit) para garantir que uma transação envolvendo múltiplos nós seja confirmada ou desfeita de forma atômica em todos eles simultaneamente, coordenação que não é necessária quando tudo roda em um único nó.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Um protocolo de commit distribuído entre os nós (ex.: two-phase commit)', true),
    ('Um índice hash duplicado em cada nó do cluster', false),
    ('A desativação do log de transação (write-ahead log)', false),
    ('A eliminação da necessidade de chaves primárias nas tabelas', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Garantir ACID completo em um banco distribuído entre múltiplos nós tipicamente exige qual mecanismo adicional, ausente em um banco de nó único?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000004',
    'Por que elevar o nível de isolamento de Read Committed para Serializable tende a reduzir o throughput de um sistema com alta concorrência de escrita?',
    'Serializable exige coordenação mais forte entre transações concorrentes — seja por meio de locks mais amplos, seja detectando conflitos e abortando/reexecutando transações — o que aumenta a contenção e o custo de manter o comportamento equivalente a uma execução sequencial das transações.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Porque exige mais coordenação entre transações concorrentes, aumentando contenção e abortos/reexecuções', true),
    ('Porque Serializable desativa completamente o MVCC do banco', false),
    ('Porque Serializable força todas as transações a rodar em um único núcleo de CPU', false),
    ('Porque Serializable elimina o uso do log de transação (write-ahead log)', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Por que elevar o nível de isolamento de Read Committed para Serializable tende a reduzir o throughput de um sistema com alta concorrência de escrita?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000005',
    'Por que um cluster de PostgreSQL configurado com replicação síncrona tende a ser classificado como CP (prioriza consistência) segundo o teorema CAP?',
    'Ao exigir a confirmação de pelo menos um seguidor antes de confirmar uma escrita ao cliente, esse arranjo recusa ou atrasa operações quando não consegue se comunicar com esse seguidor durante uma partição de rede — priorizando a garantia de que os dados confirmados estejam replicados (consistência) em vez de continuar respondendo a qualquer custo (disponibilidade).',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Porque recusa ou atrasa escritas quando não consegue confirmar com um seguidor, priorizando consistência sobre disponibilidade contínua', true),
    ('Porque replicação síncrona elimina completamente a necessidade de particionamento de dados', false),
    ('Porque o PostgreSQL não suporta réplicas de nenhum tipo', false),
    ('Porque CP significa que o sistema nunca sofre indisponibilidade', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Por que um cluster de PostgreSQL configurado com replicação síncrona tende a ser classificado como CP (prioriza consistência) segundo o teorema CAP?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000002',
    'Existe um índice B-tree composto sobre as colunas (a, b, c). Uma consulta filtra por "a" e por "c", mas não por "b". Esse índice consegue responder esse filtro de forma totalmente otimizada?',
    'Não completamente: o índice pode ser usado para localizar as linhas pelo prefixo "a", mas o filtro por "c" precisa ser aplicado depois, sem aproveitar diretamente a estrutura do índice, já que "b" (que está entre "a" e "c" na definição do índice) não faz parte do filtro e quebra a continuidade do prefixo.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Não completamente: só o filtro por "a" usa o índice diretamente; o filtro por "c" é aplicado à parte', true),
    ('Sim, qualquer combinação de colunas de um índice composto é sempre otimizada da mesma forma', false),
    ('Não, índices compostos com mais de duas colunas nunca podem ser usados por nenhuma consulta', false),
    ('Sim, porque o otimizador reordena automaticamente as colunas do índice para casar com qualquer filtro', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Existe um índice B-tree composto sobre as colunas (a, b, c). Uma consulta filtra por "a" e por "c", mas não por "b". Esse índice consegue responder esse filtro de forma totalmente otimizada?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');
