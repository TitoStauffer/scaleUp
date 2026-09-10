-- Ampliação do pool de Questions (Fase 3) — Domínio Bancos de Dados (slug: bancos-de-dados)
-- Ticket: docs/product/tickets/TICKET-content-expansion-questoes-fase3.md
-- Ticket da Fase 1: docs/product/tickets/TICKET-content-expansion-questoes.md
-- Ticket da Fase 2: docs/product/tickets/TICKET-content-expansion-questoes-fase2.md
-- Ticket mestre: docs/product/tickets/TICKET-content-database.md
--
-- Fase 3: +18 Questions novas (6 fácil, 6 média, 6 difícil), somando às 54 já existentes
-- (18 em V16__seed_conteudo_bancos_de_dados.sql + 18 em V28__amplia_questoes_bancos_de_dados.sql
-- + 18 em V37__amplia_questoes_bancos_de_dados_fase2.sql) -> total de 72 Questions neste
-- domínio após esta migração.
--
-- Nenhum Concept/Slide/Flashcard novo nesta migração — apenas INSERT em question e
-- question_alternative, reaproveitando os 5 Concepts já existentes (UUIDs literais
-- a3000000-0000-4000-8000-000000000001..5, criados em V16).
--
-- Autoria assistida por IA (rascunho), revisão humana obrigatória antes de produção —
-- por isso content_version = 'v1' e status_revisao = 'rascunho' em todas as linhas,
-- mesma convenção do lote original, da Fase 1 e da Fase 2 (decisão fechada nesta Fase 3:
-- content_version = 'v1', sem reabrir a pendência).
--
-- Enunciados novos conferidos individualmente contra os 54 já existentes em V16, V28 e
-- V37 para evitar duplicação literal ou disfarçada (mesmo ponto testado com outras
-- palavras). Ângulos cobertos nesta leva, ainda não testados nas fases anteriores:
-- materialized view vs. view, connection pooling e seu dimensionamento, UPSERT
-- (INSERT ... ON CONFLICT), UUID vs. chave sequencial e fragmentação de índice, change
-- data capture (CDC) básico e baseado em log (WAL/binlog) vs. polling, séries temporais
-- (downsampling/retenção e compressão delta/gorilla), índices GIN/GiST para full-text/
-- JSONB e para constraints de exclusão (EXCLUDE) sobre intervalos sobrepostos,
-- consistência read-your-writes, recuperação point-in-time (PITR) via base backup + WAL,
-- armazenamento colunar para agregação OLAP, padrão saga como alternativa ao two-phase
-- commit, LSM-tree vs. B-tree (amplificação de escrita e compactação), e replicação
-- semi-síncrona como meio-termo entre síncrona e assíncrona.

-- =====================================================================
-- QUESTIONS + ALTERNATIVAS (18 novas: 6 fácil, 6 média, 6 difícil)
-- =====================================================================

-- ---- FÁCIL (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000002',
    'Qual é a principal diferença entre uma materialized view e uma view comum?',
    'Uma view comum é apenas uma consulta armazenada, executada novamente a cada acesso; uma materialized view armazena fisicamente o resultado da consulta em disco, sendo lida diretamente sem reexecutar o cálculo, mas precisa ser atualizada (REFRESH) para refletir mudanças nos dados de origem.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('A materialized view armazena o resultado fisicamente e precisa ser atualizada; a view comum reexecuta a consulta a cada acesso', true),
    ('A view comum ocupa mais espaço em disco do que a materialized view', false),
    ('A materialized view sempre reflete os dados mais recentes automaticamente, sem necessidade de refresh', false),
    ('Não há diferença prática entre as duas; são apenas nomes alternativos para o mesmo recurso', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Qual é a principal diferença entre uma materialized view e uma view comum?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000002',
    'Qual é o principal objetivo de um connection pool entre a aplicação e o banco de dados?',
    'Abrir e fechar uma conexão TCP com o banco a cada requisição é caro; um connection pool mantém um conjunto de conexões já estabelecidas e as reutiliza entre requisições, reduzindo a latência e a sobrecarga de criar conexões novas repetidamente.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Reutilizar conexões já estabelecidas, evitando o custo de abrir e fechar uma conexão a cada requisição', true),
    ('Criptografar automaticamente todo o tráfego entre aplicação e banco de dados', false),
    ('Substituir a necessidade de índices nas tabelas mais consultadas', false),
    ('Garantir que todas as transações sejam executadas com isolamento Serializable', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Qual é o principal objetivo de um connection pool entre a aplicação e o banco de dados?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000003',
    'O que faz um comando UPSERT (como o INSERT ... ON CONFLICT do PostgreSQL)?',
    'UPSERT combina inserção e atualização em uma única operação atômica: tenta inserir uma nova linha e, se já existir um registro conflitante (por exemplo, mesma chave única), atualiza o registro existente em vez de falhar com um erro de violação de unicidade.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Insere uma nova linha ou atualiza a linha existente em caso de conflito de unicidade, em uma única operação atômica', true),
    ('Remove a linha existente antes de inserir uma nova, sempre em duas transações separadas', false),
    ('Insere a linha apenas se a tabela estiver vazia, ignorando qualquer outra condição', false),
    ('Cria automaticamente um índice único na coluna usada no conflito', false)
) AS x(texto, correta)
WHERE q.enunciado = 'O que faz um comando UPSERT (como o INSERT ... ON CONFLICT do PostgreSQL)?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000002',
    'Por que usar um UUID gerado aleatoriamente como chave primária tende a causar mais fragmentação em um índice B-tree do que usar um valor sequencial (auto-increment)?',
    'Um valor sequencial sempre é inserido no final do índice B-tree, mantendo as páginas ordenadas e compactas. Um UUID aleatório é inserido em posições dispersas por toda a árvore, forçando divisões de página (page splits) frequentes e deixando o índice mais fragmentado e espalhado em disco.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Porque o UUID aleatório é inserido em posições dispersas da árvore, causando divisões de página frequentes', true),
    ('Porque UUIDs não podem ser indexados por um índice B-tree, apenas por índice hash', false),
    ('Porque chaves sequenciais sempre ocupam menos espaço em disco do que qualquer outro tipo de dado', false),
    ('Porque o banco de dados precisa converter o UUID para texto antes de cada inserção', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Por que usar um UUID gerado aleatoriamente como chave primária tende a causar mais fragmentação em um índice B-tree do que usar um valor sequencial (auto-increment)?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000005',
    'O que é Change Data Capture (CDC), em linhas gerais?',
    'CDC é a técnica de capturar, em tempo quase real, as alterações (inserções, atualizações, remoções) feitas em um banco de dados e publicá-las como uma sequência de eventos, permitindo que outros sistemas reajam a essas mudanças sem consultar o banco repetidamente.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Capturar as alterações feitas no banco de dados e publicá-las como eventos para outros sistemas consumirem', true),
    ('Criar automaticamente uma cópia de segurança completa do banco a cada alteração', false),
    ('Impedir que qualquer alteração seja feita em tabelas marcadas como somente leitura', false),
    ('Validar a integridade referencial entre tabelas antes de cada escrita', false)
) AS x(texto, correta)
WHERE q.enunciado = 'O que é Change Data Capture (CDC), em linhas gerais?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000001',
    'O que é "downsampling" em um banco de dados de séries temporais (time-series database)?',
    'Downsampling é o processo de reduzir a granularidade de dados históricos ao longo do tempo — por exemplo, agregando medições de segundo em segundo para médias por hora após alguns dias — economizando espaço de armazenamento em troca de perder o detalhe fino de dados antigos, que raramente são consultados no nível original.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Reduzir a granularidade de dados antigos, agregando-os em intervalos maiores para economizar espaço', true),
    ('Aumentar a frequência de coleta de novas métricas conforme o volume de dados cresce', false),
    ('Excluir permanentemente todos os dados com mais de 24 horas, sem possibilidade de consulta', false),
    ('Replicar os dados de série temporal em todos os nós do cluster simultaneamente', false)
) AS x(texto, correta)
WHERE q.enunciado = 'O que é "downsampling" em um banco de dados de séries temporais (time-series database)?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

-- ---- MÉDIA (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000002',
    'Por que um índice GIN tende a ser mais adequado que um índice B-tree para buscas de containment em uma coluna JSONB (ex.: "o documento contém esta chave")?',
    'Um índice GIN (Generalized Inverted Index) indexa os elementos individuais dentro de uma estrutura composta, como as chaves de um JSONB ou os lexemas de um texto, permitindo localizar diretamente quais linhas contêm um determinado elemento. Um índice B-tree comum indexa o valor da coluna como um todo, não seus componentes internos, então não consegue responder esse tipo de busca de forma eficiente.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Porque o GIN indexa os elementos internos da estrutura (chaves, lexemas), enquanto o B-tree indexa o valor da coluna como um todo', true),
    ('Porque o B-tree não pode ser criado sobre colunas do tipo JSONB por limitação do banco', false),
    ('Porque o GIN é sempre mais rápido que o B-tree para qualquer tipo de consulta, inclusive igualdade simples', false),
    ('Porque o GIN elimina a necessidade de a coluna JSONB ter um esquema definido', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Por que um índice GIN tende a ser mais adequado que um índice B-tree para buscas de containment em uma coluna JSONB (ex.: "o documento contém esta chave")?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000005',
    'Uma aplicação escreve um dado no líder e, logo em seguida, lê o mesmo dado de uma réplica assíncrona, não encontrando a alteração recém-feita. Qual estratégia garante "read-your-writes" (o usuário sempre vê suas próprias escritas) nesse cenário?',
    'Uma estratégia comum é rotear, por um curto período após uma escrita daquele usuário, as leituras subsequentes dele diretamente para o líder (ou para uma réplica já confirmadamente atualizada), em vez de qualquer réplica escolhida arbitrariamente, evitando que ele veja um estado anterior à sua própria alteração.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Rotear as leituras subsequentes do próprio usuário para o líder (ou réplica já atualizada) por um período após sua escrita', true),
    ('Aumentar o replication lag para dar tempo de todas as réplicas se atualizarem antes de qualquer leitura', false),
    ('Impedir que o usuário faça qualquer leitura nos primeiros segundos após uma escrita', false),
    ('Migrar todo o sistema para replicação sem líder, que elimina esse problema automaticamente', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Uma aplicação escreve um dado no líder e, logo em seguida, lê o mesmo dado de uma réplica assíncrona, não encontrando a alteração recém-feita. Qual estratégia garante "read-your-writes" (o usuário sempre vê suas próprias escritas) nesse cenário?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000003',
    'Em uma recuperação point-in-time (PITR), por que é necessário tanto um backup base (snapshot completo) quanto o histórico contínuo de arquivos WAL, e não apenas um dos dois?',
    'O backup base restaura o banco a um estado conhecido em um momento fixo no passado, mas sozinho não permite retornar a um instante específico entre backups; o histórico de WAL contém o registro sequencial de todas as alterações desde então, permitindo reaplicá-las sobre o backup base até o exato ponto no tempo desejado.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('O backup base dá o ponto de partida; o WAL permite reaplicar as alterações posteriores até o instante exato desejado', true),
    ('O WAL sozinho já contém uma cópia completa dos dados, tornando o backup base redundante', false),
    ('O backup base é suficiente sozinho; o WAL só é necessário para replicação entre nós, não para recuperação', false),
    ('PITR não depende do WAL, apenas de backups completos feitos a cada poucos minutos', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Em uma recuperação point-in-time (PITR), por que é necessário tanto um backup base (snapshot completo) quanto o histórico contínuo de arquivos WAL, e não apenas um dos dois?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000001',
    'Por que o armazenamento colunar (column-oriented storage), usado em muitos bancos analíticos, tende a acelerar consultas de agregação que leem poucas colunas de tabelas muito largas?',
    'No armazenamento colunar, os valores de cada coluna ficam fisicamente agrupados em disco, então uma agregação que usa apenas algumas colunas (ex.: SUM de uma coluna de valor) só precisa ler os blocos dessas colunas, ignorando as demais — ao contrário do armazenamento orientado a linhas, em que cada linha inteira (todas as colunas) precisa ser lida mesmo que a consulta use poucas delas.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Porque só é preciso ler os blocos das colunas realmente usadas na consulta, sem carregar as demais colunas de cada linha', true),
    ('Porque o armazenamento colunar elimina completamente a necessidade de qualquer índice', false),
    ('Porque cada coluna é automaticamente replicada em todos os nós do cluster', false),
    ('Porque o armazenamento colunar impede a execução de consultas com JOIN entre tabelas', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Por que o armazenamento colunar (column-oriented storage), usado em muitos bancos analíticos, tende a acelerar consultas de agregação que leem poucas colunas de tabelas muito largas?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000003',
    'Em que cenário o padrão saga tende a ser preferido ao two-phase commit (2PC) para coordenar uma operação que abrange múltiplos serviços com bancos próprios?',
    'Saga substitui a coordenação bloqueante do 2PC (que exige manter locks em todos os participantes até a decisão final) por uma sequência de transações locais independentes, cada uma com uma ação compensatória para desfazer seu efeito em caso de falha adiante — preferível quando a operação é de longa duração ou envolve serviços que não podem ficar bloqueados esperando a decisão de um coordenador central.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Quando a operação é de longa duração e os serviços não podem ficar bloqueados esperando um coordenador central decidir', true),
    ('Quando é necessário garantir isolamento Serializable entre todos os serviços envolvidos', false),
    ('Quando todos os serviços compartilham o mesmo banco de dados físico', false),
    ('Quando não há nenhuma possibilidade de falha em nenhum dos serviços envolvidos', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Em que cenário o padrão saga tende a ser preferido ao two-phase commit (2PC) para coordenar uma operação que abrange múltiplos serviços com bancos próprios?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000002',
    'Diferente de um REFRESH normal, o que a cláusula CONCURRENTLY (REFRESH MATERIALIZED VIEW CONCURRENTLY, no PostgreSQL) permite fazer, e que pré-requisito ela exige?',
    'REFRESH MATERIALIZED VIEW CONCURRENTLY reconstrói a materialized view sem bloquear leituras simultâneas dela durante o processo (um REFRESH normal bloqueia consultas até terminar), mas exige que a materialized view tenha ao menos um índice único, usado para identificar quais linhas mudaram entre a versão antiga e a nova.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Permite atualizar a materialized view sem bloquear leituras simultâneas, exigindo que ela tenha ao menos um índice único', true),
    ('Permite atualizar a materialized view sem nunca precisar reler os dados de origem', false),
    ('Elimina a necessidade de qualquer índice na materialized view', false),
    ('Faz o refresh ocorrer automaticamente a cada escrita nas tabelas de origem, sem comando explícito', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Diferente de um REFRESH normal, o que a cláusula CONCURRENTLY (REFRESH MATERIALIZED VIEW CONCURRENTLY, no PostgreSQL) permite fazer, e que pré-requisito ela exige?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

-- ---- DIFÍCIL (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000002',
    'Por que uma LSM-tree (log-structured merge-tree), usada por bancos como Cassandra e RocksDB, favorece escritas em detrimento de leituras, em comparação com uma B-tree?',
    'Uma LSM-tree escreve dados sequencialmente em uma estrutura em memória (memtable) e depois em arquivos imutáveis ordenados em disco (SSTables), evitando as reescritas aleatórias que uma B-tree faz ao manter uma única estrutura balanceada — isso torna a escrita muito mais rápida. Em troca, uma leitura pode precisar consultar várias SSTables até encontrar a versão mais recente de uma chave, e um processo de compactação em segundo plano é necessário para mesclar SSTables e remover versões obsoletas.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Porque escreve sequencialmente em SSTables imutáveis, evitando reescritas aleatórias, mas a leitura pode precisar consultar várias SSTables', true),
    ('Porque a LSM-tree não suporta operações de leitura, apenas de escrita', false),
    ('Porque a LSM-tree mantém a mesma estrutura balanceada de uma B-tree, apenas com nome diferente', false),
    ('Porque toda leitura em uma LSM-tree exige varrer a tabela inteira, como um full table scan', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Por que uma LSM-tree (log-structured merge-tree), usada por bancos como Cassandra e RocksDB, favorece escritas em detrimento de leituras, em comparação com uma B-tree?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000005',
    'Como a replicação semi-síncrona se posiciona como meio-termo entre a replicação totalmente síncrona e a totalmente assíncrona?',
    'Na replicação semi-síncrona, o líder confirma a escrita ao cliente assim que pelo menos um seguidor confirma tê-la recebido (não todos), diferente da síncrona completa (que pode exigir confirmação de vários ou todos os seguidores) e da assíncrona (que não espera nenhuma confirmação) — reduzindo o risco de perda de dados em relação à assíncrona, sem pagar a latência mais alta de esperar todos os seguidores.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('O líder confirma a escrita assim que ao menos um seguidor a recebe, sem esperar todos nem nenhum', true),
    ('A replicação semi-síncrona nunca confirma escritas até que todos os seguidores estejam disponíveis', false),
    ('A replicação semi-síncrona é idêntica à assíncrona, apenas com um nome diferente', false),
    ('A replicação semi-síncrona elimina completamente a possibilidade de replication lag', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Como a replicação semi-síncrona se posiciona como meio-termo entre a replicação totalmente síncrona e a totalmente assíncrona?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000005',
    'Por que um CDC baseado em log (lendo o WAL ou o binlog do banco) é geralmente preferível a um CDC baseado em polling (consultas periódicas filtrando por uma coluna de última atualização)?',
    'CDC baseado em log lê o registro de alterações que o próprio banco já mantém para durabilidade e replicação, capturando toda alteração (incluindo deleções, que uma coluna de "última atualização" não registra) sem impor carga de consulta repetida sobre as tabelas de origem. O polling, por sua vez, adiciona carga de leitura periódica, pode perder deleções físicas e está sujeito ao intervalo entre execuções, atrasando a detecção de mudanças.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Porque lê o log de alterações que o banco já mantém, capturando também deleções, sem impor consultas repetidas às tabelas de origem', true),
    ('Porque CDC baseado em log não depende de nenhum mecanismo de durabilidade do banco', false),
    ('Porque o polling sempre captura as alterações com latência menor que o CDC baseado em log', false),
    ('Porque CDC baseado em log elimina a necessidade de qualquer réplica de leitura', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Por que um CDC baseado em log (lendo o WAL ou o binlog do banco) é geralmente preferível a um CDC baseado em polling (consultas periódicas filtrando por uma coluna de última atualização)?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000001',
    'Por que bancos de séries temporais frequentemente usam compressão por delta (ou variantes como a codificação gorilla) para armazenar sequências de timestamps e valores?',
    'Em uma série temporal, timestamps consecutivos e valores de métricas costumam variar pouco de uma amostra para a outra; em vez de armazenar cada valor por completo, a compressão por delta armazena apenas a diferença em relação ao valor anterior, que costuma exigir muito menos bits — reduzindo drasticamente o espaço em disco em cargas de altíssimo volume de escrita, comuns nesse tipo de banco.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Porque armazenar apenas a diferença entre valores consecutivos exige muito menos espaço do que armazenar cada valor por completo', true),
    ('Porque a compressão por delta permite eliminar completamente a necessidade de índices na série temporal', false),
    ('Porque valores de métricas em série temporal nunca se repetem, tornando a compressão comum ineficaz', false),
    ('Porque a compressão por delta converte automaticamente os dados para o formato relacional normalizado', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Por que bancos de séries temporais frequentemente usam compressão por delta (ou variantes como a codificação gorilla) para armazenar sequências de timestamps e valores?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000002',
    'Um connection pool dimensionado com um número de conexões muito maior do que os núcleos de CPU disponíveis no banco pode piorar o throughput em vez de melhorá-lo. Por quê?',
    'Cada conexão ativa executando uma query concorrente consome recursos de CPU, memória e locks; além de certo ponto, adicionar mais conexões simultâneas apenas aumenta a disputa por esses recursos (contenção de CPU, mais trocas de contexto, mais contenção de locks), fazendo cada query individual demorar mais e reduzindo o throughput total, mesmo que mais conexões estejam "ocupadas" ao mesmo tempo.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Porque, além de certo ponto, mais conexões concorrentes só aumentam a disputa por CPU, memória e locks, piorando a latência de cada query', true),
    ('Porque o banco de dados rejeita automaticamente qualquer conexão acima do número de núcleos de CPU', false),
    ('Porque conexões ociosas em um pool grande demais consomem largura de banda de rede continuamente', false),
    ('Porque um pool maior sempre força o banco a usar Seq Scan em vez de índices', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Um connection pool dimensionado com um número de conexões muito maior do que os núcleos de CPU disponíveis no banco pode piorar o throughput em vez de melhorá-lo. Por quê?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000002',
    'Por que uma constraint de exclusão (EXCLUDE), usada no PostgreSQL para impedir que duas reservas com intervalos de datas sobrepostos sejam inseridas na mesma sala, depende de um índice GiST em vez de um índice B-tree?',
    'B-tree só compara valores por ordem total (igual, menor, maior), o que não expressa a noção de "sobreposição" entre dois intervalos. GiST é uma estrutura de índice genérica que suporta operadores customizados, incluindo o operador de sobreposição sobre tipos de intervalo (range types), permitindo que o banco verifique eficientemente, no momento da escrita, se o novo intervalo colide com algum já existente.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Porque o GiST suporta o operador de sobreposição sobre range types, algo que a ordem total de um B-tree não expressa', true),
    ('Porque o B-tree não pode ser criado sobre colunas de tipo intervalo (range), apenas sobre texto e números', false),
    ('Porque o GiST é sempre mais rápido que o B-tree para qualquer tipo de constraint, inclusive unicidade simples', false),
    ('Porque constraints de exclusão não existem no PostgreSQL, apenas em bancos NoSQL', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Por que uma constraint de exclusão (EXCLUDE), usada no PostgreSQL para impedir que duas reservas com intervalos de datas sobrepostos sejam inseridas na mesma sala, depende de um índice GiST em vez de um índice B-tree?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');
