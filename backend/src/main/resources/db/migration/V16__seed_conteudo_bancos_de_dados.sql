-- Seed de conteúdo — Domínio Bancos de Dados (slug: bancos-de-dados)
-- Ticket: docs/product/tickets/content/TICKET-content-bancos-de-dados.md
-- Ticket mestre: docs/product/tickets/TICKET-content-database.md
--
-- Autoria assistida por IA (rascunho), revisão humana obrigatória antes de produção —
-- por isso content_version = 'v1' e status_revisao = 'rascunho' em todas as linhas.
-- Domain já existe (V13); esta migração NUNCA insere em domain, só referencia via
-- subquery em domain.slug = 'bancos-de-dados', conforme instruído.
--
-- 5 Concepts, 15 Slides (3 por Concept), 15 Flashcards (3 por Concept),
-- 18 Questions (6 fácil, 6 média, 6 difícil) com 4 alternativas cada.

-- =====================================================================
-- CONCEPTS
-- =====================================================================

INSERT INTO concept (id, domain_ref, titulo, resumo, content_version, status_revisao)
VALUES
    ('a3000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'Modelagem relacional vs. NoSQL',
     'Diferenças entre modelagem relacional (normalização, esquema rígido, joins) e modelos NoSQL (documento, chave-valor, coluna larga, grafo), e critérios para escolher entre eles conforme o padrão de acesso aos dados.',
     'v1', 'rascunho'),
    ('a3000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'Indexação e desempenho de consultas',
     'Como índices B-tree e hash aceleram consultas, o custo de escrita que eles introduzem, e como ler um plano de execução para identificar oportunidades de indexação.',
     'v1', 'rascunho'),
    ('a3000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'Transações e ACID',
     'As garantias de atomicidade, consistência, isolamento e durabilidade que uma transação oferece, e por que elas importam para operações que alteram múltiplos registros.',
     'v1', 'rascunho'),
    ('a3000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'Níveis de isolamento e controle de concorrência',
     'Os fenômenos de concorrência (dirty read, non-repeatable read, phantom read) e como os níveis de isolamento padrão do SQL e mecanismos como MVCC lidam com eles.',
     'v1', 'rascunho'),
    ('a3000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'Replicação, particionamento e CAP',
     'Estratégias de replicação (síncrona/assíncrona, líder-seguidor), particionamento/sharding de dados entre nós, e como o teorema CAP molda os trade-offs de consistência em bancos distribuídos.',
     'v1', 'rascunho')
ON CONFLICT (domain_ref, titulo) DO NOTHING;

-- =====================================================================
-- SLIDES (3 por Concept, ordem sequencial 1..3)
-- =====================================================================

-- Concept: Modelagem relacional vs. NoSQL
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a3000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'O que é modelagem relacional',
     'Um banco relacional organiza dados em tabelas com esquema fixo, onde cada linha representa uma entidade e colunas representam seus atributos. A normalização é o processo de estruturar essas tabelas para eliminar redundância: em vez de repetir o endereço de um cliente em cada pedido, guarda-se o endereço uma vez na tabela de clientes e referencia-se por chave estrangeira. Isso evita anomalias de atualização (mudar o endereço em um lugar só) ao custo de precisar de joins para reconstruir a informação completa em uma consulta.',
     1, 'v1', 'rascunho'),
    ('a3000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'Famílias de bancos NoSQL',
     'NoSQL não é um modelo único, mas uma família de abordagens que abrem mão de parte das garantias e da rigidez relacional em troca de escala horizontal e flexibilidade de esquema. As principais famílias são: documento (MongoDB — armazena JSON aninhado, bom para dados semiestruturados que mudam de forma); chave-valor (Redis, DynamoDB — acesso extremamente rápido por chave, sem consultas complexas); coluna larga (Cassandra — otimizado para grandes volumes de escrita e leitura por partição); e grafo (Neo4j — otimizado para percorrer relacionamentos complexos entre entidades).',
     2, 'v1', 'rascunho'),
    ('a3000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'Quando escolher cada um',
     'A escolha depende do padrão de acesso, não de moda. Prefira relacional quando há necessidade forte de integridade referencial, consultas ad-hoc variadas e transações multi-tabela (ex.: sistema financeiro). Prefira documento quando o dado é naturalmente hierárquico e lido/escrito como um todo (ex.: perfil de usuário com preferências aninhadas). Prefira chave-valor para caching e sessões, onde a latência de leitura por chave é crítica. Prefira coluna larga ou bancos distribuídos quando o volume de escrita excede o que um único nó relacional aguenta e o padrão de consulta é previsível (ex.: séries temporais, eventos). Um mesmo sistema frequentemente usa mais de um desses bancos lado a lado, cada um para a parte do problema em que é mais forte.',
     3, 'v1', 'rascunho');

-- Concept: Indexação e desempenho de consultas
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a3000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'Por que índices existem',
     'Sem índice, encontrar uma linha que satisfaça uma condição exige varrer a tabela inteira (full table scan) — custo linear no número de linhas. Um índice é uma estrutura de dados auxiliar, ordenada por uma ou mais colunas, que permite localizar linhas em tempo logarítmico (ou constante, no caso de hash) em vez de linear. O custo desse ganho de leitura é pago na escrita: toda inserção, atualização ou remoção precisa também atualizar cada índice da tabela, e o índice ocupa espaço em disco adicional.',
     1, 'v1', 'rascunho'),
    ('a3000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'B-tree, hash e índices compostos',
     'B-tree é a estrutura padrão da maioria dos bancos relacionais: uma árvore balanceada que mantém as chaves ordenadas, suportando igualdade e faixas (`>`, `<`, `BETWEEN`) com custo logarítmico. Índices hash suportam apenas igualdade exata, mas em O(1) — úteis quando não há necessidade de ordenação ou faixas. Índices compostos (sobre múltiplas colunas) só são úteis a partir do prefixo esquerdo: um índice em `(a, b)` acelera filtros por `a` ou por `a e b` juntos, mas não um filtro só por `b`. A ordem das colunas no índice composto deve refletir o padrão real de consulta.',
     2, 'v1', 'rascunho'),
    ('a3000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'Lendo um plano de execução',
     'Comandos como `EXPLAIN ANALYZE` mostram como o otimizador decidiu executar uma consulta: se usou um índice (`Index Scan`) ou varreu a tabela inteira (`Seq Scan`), quantas linhas estimou versus quantas realmente encontrou, e o tempo gasto em cada etapa. Um `Seq Scan` não é sempre ruim — em tabelas pequenas ou quando a consulta retorna grande parte das linhas, o otimizador pode preferi-lo por ser mais barato que acessar o índice e depois a tabela. O sinal de alerta real é um `Seq Scan` em uma tabela grande para uma consulta que deveria retornar poucas linhas: normalmente indica falta de índice na coluna filtrada.',
     3, 'v1', 'rascunho');

-- Concept: Transações e ACID
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a3000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'O que é uma transação',
     'Uma transação agrupa uma ou mais operações de leitura/escrita em uma unidade que deve ser tratada como indivisível: ou todas as operações são aplicadas, ou nenhuma é. O exemplo clássico é uma transferência bancária: debitar de uma conta e creditar em outra precisam acontecer juntos — se o sistema falhar entre as duas operações, o dinheiro não pode desaparecer nem ser duplicado. `BEGIN`, `COMMIT` e `ROLLBACK` são os comandos que delimitam esse agrupamento na maioria dos bancos SQL.',
     1, 'v1', 'rascunho'),
    ('a3000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'As quatro garantias de ACID',
     'Atomicidade: a transação é tudo ou nada — uma falha no meio desfaz tudo que já foi feito. Consistência: a transação leva o banco de um estado válido a outro estado válido, respeitando constraints, triggers e regras de integridade definidas no schema. Isolamento: transações concorrentes não devem enxergar estados intermediários umas das outras (o nível exato de isolamento é configurável — ver o conceito de Níveis de isolamento). Durabilidade: uma vez confirmada (`COMMIT`), a alteração sobrevive a uma queda de energia ou crash do processo, tipicamente porque já foi escrita em um log de transação persistido em disco antes de confirmar ao cliente.',
     2, 'v1', 'rascunho'),
    ('a3000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'ACID tem custo, e nem todo banco oferece tudo',
     'Garantir ACID completo exige coordenação: locks, logs de write-ahead e, em bancos distribuídos, protocolos de commit entre nós — tudo isso adiciona latência. Por isso muitos bancos NoSQL relaxam alguma dessas garantias (tipicamente isolamento ou consistência imediata) em troca de mais throughput e disponibilidade. Isso não torna ACID "melhor" ou "pior" em absoluto — é uma escolha de engenharia: sistemas onde a integridade forte importa mais que a latência (pagamentos, estoque) tendem a preferir ACID completo; sistemas onde disponibilidade e escala importam mais que uma inconsistência temporária (feed social, contador de curtidas) toleram consistência eventual.',
     3, 'v1', 'rascunho');

-- Concept: Níveis de isolamento e controle de concorrência
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a3000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'Os fenômenos que o isolamento previne',
     'Quando transações concorrentes acessam os mesmos dados, três fenômenos indesejados podem ocorrer. Dirty read: uma transação lê um dado que outra transação alterou mas ainda não confirmou (commitou) — se a segunda fizer rollback, a primeira leu um dado que nunca existiu de fato. Non-repeatable read: uma transação lê a mesma linha duas vezes e obtém valores diferentes, porque outra transação a alterou e confirmou entre as duas leituras. Phantom read: uma transação repete uma consulta com filtro (ex.: "todos os pedidos acima de R$100") e obtém um conjunto de linhas diferente na segunda vez, porque outra transação inseriu ou removeu linhas que passam a satisfazer o filtro.',
     1, 'v1', 'rascunho'),
    ('a3000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'Os quatro níveis de isolamento do padrão SQL',
     'O padrão SQL define quatro níveis, do mais permissivo ao mais restritivo: Read Uncommitted (permite dirty read; raramente usado na prática), Read Committed (previne dirty read; é o padrão do PostgreSQL e do Oracle), Repeatable Read (previne dirty e non-repeatable read; é o padrão do MySQL/InnoDB) e Serializable (previne todos os três fenômenos, incluindo phantom read, comportando-se como se as transações rodassem uma de cada vez). Quanto mais restritivo o nível, mais forte a garantia, mas maior o custo em contenção (locks) ou em abortar e reexecutar transações que conflitam.',
     2, 'v1', 'rascunho'),
    ('a3000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'MVCC: como o PostgreSQL implementa isolamento sem travar tudo',
     'Multiversion Concurrency Control (MVCC) é a técnica usada pelo PostgreSQL (e por muitos outros bancos) para oferecer bons níveis de isolamento sem que leitores bloqueiem escritores nem vice-versa. Em vez de sobrescrever uma linha alterada, o banco mantém múltiplas versões dela, cada uma marcada com o intervalo de transações para o qual é visível. Uma transação enxerga a versão da linha que era válida no momento em que ela começou (ou no momento de cada statement, dependendo do nível), sem precisar esperar um lock ser liberado. O custo é a necessidade de um processo de limpeza (`VACUUM`) para remover versões antigas que não são mais visíveis a nenhuma transação ativa.',
     3, 'v1', 'rascunho');

-- Concept: Replicação, particionamento e CAP
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a3000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'Replicação líder-seguidor: síncrona vs. assíncrona',
     'Replicação mantém cópias dos mesmos dados em múltiplos nós, tipicamente para tolerância a falhas e para distribuir carga de leitura. No modelo líder-seguidor, todas as escritas vão para o líder, que propaga as mudanças aos seguidores. Na replicação síncrona, o líder só confirma a escrita ao cliente depois que pelo menos um seguidor confirmou tê-la recebido — mais seguro contra perda de dados, mais lento. Na replicação assíncrona, o líder confirma a escrita imediatamente e propaga em segundo plano — mais rápido, mas uma queda do líder antes da propagação pode perder as últimas escritas confirmadas.',
     1, 'v1', 'rascunho'),
    ('a3000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'Particionamento (sharding) de dados',
     'Particionamento divide um conjunto de dados grande demais para um único nó em partes menores (partições ou shards), cada uma hospedada em um nó diferente. A escolha da chave de particionamento é a decisão mais importante: uma chave mal escolhida gera hot spots (uma partição recebendo muito mais tráfego que as outras). Estratégias comuns incluem particionamento por faixa (range — bom para varreduras ordenadas, mas propenso a hot spots em chaves crescentes como timestamp) e particionamento por hash (distribui melhor a carga, mas perde a ordenação natural entre partições). Rebalancear partições conforme os dados crescem é um dos problemas operacionais mais difíceis de sistemas distribuídos.',
     2, 'v1', 'rascunho'),
    ('a3000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'CAP aplicado a bancos de dados',
     'O teorema CAP afirma que, durante uma partição de rede (P) entre nós de um sistema distribuído, é preciso escolher entre Consistência (C — todo nó vê a mesma versão mais recente do dado) e Disponibilidade (A — todo nó continua respondendo a requisições). Sem partição, um sistema pode oferecer C e A juntos; a escolha só é forçada quando a rede falha. Bancos como o PostgreSQL em configuração single-node não enfrentam esse trade-off diretamente, mas bancos distribuídos precisam declarar sua posição: Cassandra e DynamoDB tendem a priorizar disponibilidade (AP, com consistência eventual); bancos com consenso forte como o Google Spanner ou um cluster de PostgreSQL com replicação síncrona tendem a priorizar consistência (CP), recusando escritas ou leituras quando não conseguem garantir a versão mais recente.',
     3, 'v1', 'rascunho');

-- =====================================================================
-- FLASHCARDS (3 por Concept)
-- =====================================================================

INSERT INTO flashcard (domain_ref, concept_ref, frente, verso, dificuldade, content_version, status_revisao)
VALUES
    ((SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'a3000000-0000-4000-8000-000000000001',
     'O que é normalização e qual problema ela resolve?',
     'É o processo de organizar tabelas relacionais para eliminar redundância de dados, guardando cada informação em um único lugar e referenciando-a por chave estrangeira. Resolve anomalias de atualização (evita ter que alterar o mesmo dado repetido em vários lugares).',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'a3000000-0000-4000-8000-000000000001',
     'Cite uma família de banco NoSQL e um caso de uso típico.',
     'Exemplos: documento (MongoDB) para dados hierárquicos como perfil de usuário; chave-valor (Redis) para cache e sessões; coluna larga (Cassandra) para grandes volumes de escrita; grafo (Neo4j) para relacionamentos complexos.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'a3000000-0000-4000-8000-000000000001',
     'Por que um sistema pode usar mais de um tipo de banco ao mesmo tempo?',
     'Porque cada modelo é forte em um padrão de acesso diferente; usar o banco certo para cada parte do problema (ex.: relacional para dados transacionais, chave-valor para cache) costuma superar tentar resolver tudo com um único banco.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'a3000000-0000-4000-8000-000000000002',
     'Qual é o custo de se adicionar um índice a uma tabela?',
     'Toda escrita (INSERT/UPDATE/DELETE) precisa atualizar também o índice, tornando escritas mais lentas, além do índice ocupar espaço adicional em disco.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'a3000000-0000-4000-8000-000000000002',
     'Um índice composto em (a, b) acelera uma consulta que filtra só por b?',
     'Não. Índices compostos só são úteis a partir do prefixo esquerdo: aceleram filtros por "a" ou por "a e b" juntos, mas não um filtro isolado por "b".',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'a3000000-0000-4000-8000-000000000002',
     'O que indica um "Seq Scan" em uma tabela grande para uma consulta seletiva?',
     'Normalmente indica falta de um índice adequado na coluna filtrada, fazendo o banco varrer a tabela inteira em vez de acessar diretamente as poucas linhas relevantes.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'a3000000-0000-4000-8000-000000000003',
     'O que significa a "atomicidade" em ACID?',
     'Significa que a transação é tudo ou nada: ou todas as suas operações são aplicadas com sucesso, ou nenhuma delas é, mesmo que ocorra uma falha no meio da execução.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'a3000000-0000-4000-8000-000000000003',
     'O que garante a "durabilidade" em ACID?',
     'Que, uma vez confirmada (COMMIT) uma transação, sua alteração sobrevive a falhas como queda de energia ou crash do processo, tipicamente por já estar registrada em um log de transação persistido em disco.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'a3000000-0000-4000-8000-000000000003',
     'Por que alguns bancos NoSQL relaxam garantias ACID?',
     'Para reduzir a coordenação necessária (locks, logs, protocolos de commit distribuído) e assim ganhar mais throughput e disponibilidade, aceitando em troca consistência eventual ou isolamento mais fraco.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'a3000000-0000-4000-8000-000000000004',
     'O que é um "dirty read"?',
     'É quando uma transação lê um dado alterado por outra transação que ainda não foi confirmada (commitada); se essa outra transação fizer rollback, o dado lido nunca existiu de fato.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'a3000000-0000-4000-8000-000000000004',
     'Qual nível de isolamento do padrão SQL previne todos os três fenômenos de concorrência clássicos?',
     'Serializable — previne dirty read, non-repeatable read e phantom read, comportando-se como se as transações rodassem sequencialmente, uma de cada vez.',
     'dificil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'a3000000-0000-4000-8000-000000000004',
     'O que é MVCC e qual problema ele resolve?',
     'Multiversion Concurrency Control mantém múltiplas versões de uma linha, cada uma visível a um intervalo de transações; resolve o problema de leitores bloquearem escritores (e vice-versa) para oferecer bons níveis de isolamento sem lock pesado.',
     'dificil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'a3000000-0000-4000-8000-000000000005',
     'Qual a diferença entre replicação síncrona e assíncrona?',
     'Na síncrona, o líder só confirma a escrita ao cliente depois que ao menos um seguidor confirmou recebê-la (mais seguro, mais lento). Na assíncrona, o líder confirma antes de propagar, arriscando perder as últimas escritas se cair antes de propagar (mais rápido, menos seguro).',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'a3000000-0000-4000-8000-000000000005',
     'O que é um "hot spot" em um sistema particionado (sharded)?',
     'É uma partição que recebe uma carga de tráfego desproporcionalmente maior que as outras, geralmente causada por uma escolha ruim de chave de particionamento (ex.: chave sempre crescente como timestamp em particionamento por faixa).',
     'dificil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'a3000000-0000-4000-8000-000000000005',
     'Segundo o teorema CAP, quando um sistema é forçado a escolher entre consistência e disponibilidade?',
     'Apenas durante uma partição de rede (P) entre nós. Sem partição, o sistema pode oferecer consistência e disponibilidade simultaneamente; a escolha só é forçada quando a comunicação entre nós falha.',
     'dificil', 'v1', 'rascunho');

-- =====================================================================
-- QUESTIONS + ALTERNATIVAS (18: 6 fácil, 6 média, 6 difícil)
-- =====================================================================

-- ---- FÁCIL (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000001',
    'Qual é o principal objetivo da normalização em um banco relacional?',
    'Normalização organiza os dados para eliminar redundância, garantindo que cada informação exista em um único lugar e evitando anomalias de atualização, ao custo de exigir joins para reconstruir dados relacionados.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Eliminar redundância de dados e evitar anomalias de atualização', true),
    ('Aumentar a velocidade de leitura eliminando a necessidade de joins', false),
    ('Permitir que o esquema do banco mude livremente sem migração', false),
    ('Substituir a necessidade de chaves estrangeiras', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Qual é o principal objetivo da normalização em um banco relacional?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000001',
    'Um banco de dados do tipo chave-valor, como o Redis, é mais adequado para qual cenário?',
    'Bancos chave-valor oferecem acesso extremamente rápido por chave, mas não suportam consultas complexas — por isso são ideais para caching e armazenamento de sessões, onde a latência de leitura por chave é crítica.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Cache e armazenamento de sessões com acesso rápido por chave', true),
    ('Relatórios com consultas ad-hoc complexas e joins entre entidades', false),
    ('Armazenamento de relacionamentos complexos entre entidades', false),
    ('Garantir integridade referencial forte entre múltiplas tabelas', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Um banco de dados do tipo chave-valor, como o Redis, é mais adequado para qual cenário?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000002',
    'O que ocorre em um "full table scan"?',
    'Sem um índice adequado, o banco precisa examinar cada linha da tabela para verificar se ela satisfaz a condição da consulta, resultando em custo linear no número de linhas.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('O banco examina todas as linhas da tabela para encontrar as que satisfazem a condição', true),
    ('O banco usa um índice hash para localizar a linha em tempo constante', false),
    ('O banco cria automaticamente um novo índice para a consulta', false),
    ('O banco rejeita a consulta por falta de índice', false)
) AS x(texto, correta)
WHERE q.enunciado = 'O que ocorre em um "full table scan"?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000003',
    'Em uma transferência bancária, por que débito e crédito precisam ocorrer dentro da mesma transação?',
    'A atomicidade garante que a transação é tudo ou nada: se o sistema falhar entre o débito e o crédito, a transação inteira é desfeita, evitando que o dinheiro desapareça ou seja duplicado.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Para garantir que, em caso de falha, nenhuma das duas operações fique aplicada sozinha', true),
    ('Para aumentar a velocidade de execução das duas operações', false),
    ('Porque o banco não permite duas operações separadas na mesma sessão', false),
    ('Para reduzir o espaço em disco ocupado pelas operações', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Em uma transferência bancária, por que débito e crédito precisam ocorrer dentro da mesma transação?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000003',
    'Qual garantia de ACID assegura que uma alteração confirmada (COMMIT) sobrevive a uma queda de energia?',
    'A durabilidade garante que, após o COMMIT, a alteração persiste mesmo diante de falhas como queda de energia, tipicamente porque já foi registrada em um log de transação em disco antes da confirmação.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Durabilidade', true),
    ('Atomicidade', false),
    ('Isolamento', false),
    ('Consistência', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Qual garantia de ACID assegura que uma alteração confirmada (COMMIT) sobrevive a uma queda de energia?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000005',
    'No modelo de replicação líder-seguidor, para onde vão todas as escritas?',
    'No modelo líder-seguidor, todas as escritas são direcionadas ao líder, que depois propaga as mudanças para os seguidores, seja de forma síncrona ou assíncrona.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Para o líder, que depois propaga as mudanças aos seguidores', true),
    ('Para qualquer seguidor disponível, que propaga ao líder', false),
    ('Para todos os nós simultaneamente, sem coordenação', false),
    ('Para um nó eleito aleatoriamente a cada escrita', false)
) AS x(texto, correta)
WHERE q.enunciado = 'No modelo de replicação líder-seguidor, para onde vão todas as escritas?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

-- ---- MÉDIA (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000001',
    'Uma aplicação precisa armazenar perfis de usuário com estrutura variável (campos opcionais, listas aninhadas) e sempre lê/escreve o perfil inteiro de uma vez. Qual modelo tende a se encaixar melhor?',
    'Bancos de documento (como MongoDB) armazenam dados hierárquicos de forma natural e são lidos/escritos como um todo, sendo mais adequados que um modelo relacional rígido quando a estrutura do dado varia e não há necessidade de joins complexos.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Banco de documento', true),
    ('Banco relacional altamente normalizado', false),
    ('Banco de grafo', false),
    ('Banco chave-valor sem suporte a estrutura aninhada', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Uma aplicação precisa armazenar perfis de usuário com estrutura variável (campos opcionais, listas aninhadas) e sempre lê/escreve o perfil inteiro de uma vez. Qual modelo tende a se encaixar melhor?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000002',
    'Existe um índice composto sobre as colunas (pais, cidade). Qual consulta consegue se beneficiar diretamente desse índice?',
    'Índices compostos só são úteis a partir do prefixo esquerdo: um filtro por "pais" sozinho, ou por "pais e cidade" juntos, usa o índice; um filtro só por "cidade" não consegue aproveitá-lo, pois "cidade" não é o prefixo.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Uma consulta que filtra apenas pela coluna pais', true),
    ('Uma consulta que filtra apenas pela coluna cidade', false),
    ('Uma consulta que não filtra por nenhuma das duas colunas', false),
    ('Nenhuma consulta pode usar um índice composto para filtro parcial', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Existe um índice composto sobre as colunas (pais, cidade). Qual consulta consegue se beneficiar diretamente desse índice?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000003',
    'Por que muitos bancos NoSQL relaxam garantias ACID em favor de consistência eventual?',
    'Garantir ACID completo exige coordenação (locks, logs, protocolos de commit), o que adiciona latência. Relaxar isolamento ou consistência imediata permite mais throughput e disponibilidade, um trade-off aceitável quando inconsistências temporárias não são críticas.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Para reduzir a coordenação necessária e ganhar throughput e disponibilidade', true),
    ('Porque bancos NoSQL não conseguem implementar transações de forma alguma', false),
    ('Porque ACID é uma exigência apenas de bancos relacionais antigos', false),
    ('Para simplificar o código da aplicação cliente', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Por que muitos bancos NoSQL relaxam garantias ACID em favor de consistência eventual?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000004',
    'Uma transação lê um pedido duas vezes e obtém valores diferentes na segunda leitura porque outra transação alterou e confirmou a mudança entre as duas leituras. Qual fenômeno é esse?',
    'Non-repeatable read ocorre quando a mesma linha, lida duas vezes dentro de uma transação, retorna valores diferentes porque outra transação a alterou e confirmou entre as duas leituras.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Non-repeatable read', true),
    ('Dirty read', false),
    ('Phantom read', false),
    ('Deadlock', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Uma transação lê um pedido duas vezes e obtém valores diferentes na segunda leitura porque outra transação alterou e confirmou a mudança entre as duas leituras. Qual fenômeno é esse?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000004',
    'Qual é o nível de isolamento padrão do PostgreSQL?',
    'O PostgreSQL usa Read Committed como nível padrão, que previne dirty read mas permite non-repeatable read e phantom read.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Read Committed', true),
    ('Read Uncommitted', false),
    ('Repeatable Read', false),
    ('Serializable', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Qual é o nível de isolamento padrão do PostgreSQL?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000005',
    'Um sistema particiona pedidos por timestamp de criação usando particionamento por faixa (range). Qual problema esse esquema tende a causar?',
    'Particionar por uma chave sempre crescente, como timestamp, com particionamento por faixa concentra todas as escritas recentes em uma única partição (a mais "nova"), criando um hot spot em vez de distribuir a carga uniformemente.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Hot spot: a partição mais recente concentra a maior parte das escritas', true),
    ('Perda de dados permanente em partições antigas', false),
    ('Impossibilidade de fazer qualquer consulta por faixa de datas', false),
    ('Aumento do espaço em disco de todas as partições igualmente', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Um sistema particiona pedidos por timestamp de criação usando particionamento por faixa (range). Qual problema esse esquema tende a causar?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

-- ---- DIFÍCIL (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000004',
    'Como o MVCC (Multiversion Concurrency Control) permite que leitores nunca bloqueiem escritores?',
    'O MVCC mantém múltiplas versões de cada linha, cada uma associada a um intervalo de visibilidade. Um leitor enxerga a versão da linha válida no início de sua transação (ou statement), sem precisar esperar um lock de escrita ser liberado, enquanto o escritor cria uma nova versão em vez de sobrescrever a existente.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Mantendo múltiplas versões de cada linha, cada uma visível a um intervalo de transações específico', true),
    ('Bloqueando todas as leituras até que a transação de escrita seja confirmada', false),
    ('Impedindo que mais de uma transação de escrita exista no banco ao mesmo tempo', false),
    ('Convertendo automaticamente toda leitura em uma escrita fantasma', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Como o MVCC (Multiversion Concurrency Control) permite que leitores nunca bloqueiem escritores?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000004',
    'Uma transação consulta "todos os pedidos acima de R$100" duas vezes e, na segunda vez, um novo pedido inserido por outra transação aparece no resultado. Qual fenômeno é esse e qual nível de isolamento o previne por completo?',
    'É um phantom read: o conjunto de linhas que satisfaz um filtro muda entre duas execuções da mesma consulta porque outra transação inseriu (ou removeu) linhas que passam a atendê-lo. Apenas o nível Serializable garante a prevenção completa desse fenômeno no padrão SQL.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Phantom read; prevenido por completo apenas em Serializable', true),
    ('Dirty read; prevenido por completo em Read Committed', false),
    ('Non-repeatable read; prevenido por completo em Read Uncommitted', false),
    ('Deadlock; prevenido por completo em Repeatable Read', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Uma transação consulta "todos os pedidos acima de R$100" duas vezes e, na segunda vez, um novo pedido inserido por outra transação aparece no resultado. Qual fenômeno é esse e qual nível de isolamento o previne por completo?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000005',
    'Segundo o teorema CAP, em que momento exato um sistema distribuído é forçado a escolher entre consistência e disponibilidade?',
    'O CAP força essa escolha apenas durante uma partição de rede (P) entre nós — quando a comunicação entre réplicas falha. Sem partição, o sistema pode oferecer consistência e disponibilidade simultaneamente; a tensão só aparece quando os nós não conseguem se comunicar.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Apenas durante uma partição de rede entre os nós do sistema', true),
    ('Sempre, em qualquer momento de operação do sistema distribuído', false),
    ('Apenas durante o processo de particionamento (sharding) inicial dos dados', false),
    ('Apenas quando o número de réplicas é ímpar', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Segundo o teorema CAP, em que momento exato um sistema distribuído é forçado a escolher entre consistência e disponibilidade?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000005',
    'Por que um banco como o Cassandra é tipicamente classificado como AP (disponível, com consistência eventual) e não CP?',
    'O Cassandra prioriza continuar aceitando leituras e escritas mesmo quando nós estão particionados ou indisponíveis, aceitando que réplicas divergentes sejam reconciliadas depois (consistência eventual), em vez de recusar operações para garantir que todo nó veja sempre a versão mais recente.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Porque prioriza continuar respondendo requisições mesmo sob partição, aceitando divergência temporária entre réplicas', true),
    ('Porque não suporta replicação de dados entre nós', false),
    ('Porque usa apenas um único nó para todas as operações', false),
    ('Porque implementa isolamento Serializable por padrão em todas as consultas', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Por que um banco como o Cassandra é tipicamente classificado como AP (disponível, com consistência eventual) e não CP?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000002',
    'Por que o otimizador de consultas às vezes escolhe um "Seq Scan" mesmo existindo um índice na coluna filtrada?',
    'Quando a consulta retorna uma grande parte das linhas da tabela, acessar cada linha via índice (que exige um salto adicional à tabela para buscar as demais colunas) pode ser mais caro que simplesmente ler a tabela inteira sequencialmente; o otimizador estima o custo de cada abordagem e escolhe a mais barata.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Porque, para consultas que retornam grande parte das linhas, ler a tabela inteira pode ser mais barato que usar o índice', true),
    ('Porque índices só funcionam em tabelas com menos de mil linhas', false),
    ('Porque o Seq Scan sempre é mais rápido que o Index Scan em qualquer cenário', false),
    ('Porque o índice estava desabilitado manualmente pelo administrador', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Por que o otimizador de consultas às vezes escolhe um "Seq Scan" mesmo existindo um índice na coluna filtrada?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000003',
    'A garantia de "consistência" em ACID (o "C") refere-se a que, especificamente?',
    'A consistência em ACID significa que a transação leva o banco de um estado válido a outro estado válido, respeitando todas as constraints, triggers e regras de integridade definidas no schema — é diferente da consistência do teorema CAP, que trata de réplicas verem o mesmo dado.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('A transação respeita as constraints e regras de integridade do schema, levando o banco de um estado válido a outro', true),
    ('Todas as réplicas do banco veem exatamente o mesmo dado a qualquer momento', false),
    ('As transações concorrentes nunca enxergam estados intermediários umas das outras', false),
    ('O resultado de uma consulta nunca muda entre duas execuções seguidas', false)
) AS x(texto, correta)
WHERE q.enunciado = 'A garantia de "consistência" em ACID (o "C") refere-se a que, especificamente?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');
