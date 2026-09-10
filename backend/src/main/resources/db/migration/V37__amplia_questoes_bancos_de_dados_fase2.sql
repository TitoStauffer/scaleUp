-- Ampliação do pool de Questions (Fase 2) — Domínio Bancos de Dados (slug: bancos-de-dados)
-- Ticket: docs/product/tickets/TICKET-content-expansion-questoes-fase2.md
-- Ticket da Fase 1: docs/product/tickets/TICKET-content-expansion-questoes.md
-- Ticket mestre: docs/product/tickets/TICKET-content-database.md
--
-- Fase 2: +18 Questions novas (6 fácil, 6 média, 6 difícil), somando às 36 já existentes
-- (18 em V16__seed_conteudo_bancos_de_dados.sql + 18 em V28__amplia_questoes_bancos_de_dados.sql)
-- -> total de 54 Questions neste domínio após esta migração.
--
-- Nenhum Concept/Slide/Flashcard novo nesta migração — apenas INSERT em question e
-- question_alternative, reaproveitando os 5 Concepts já existentes (UUIDs literais
-- a3000000-0000-4000-8000-000000000001..5, criados em V16).
--
-- Autoria assistida por IA (rascunho), revisão humana obrigatória antes de produção —
-- por isso content_version = 'v1' e status_revisao = 'rascunho' em todas as linhas,
-- mesma convenção do lote original e da Fase 1 (OPEN QUESTION-008 do ticket de Fase 2:
-- mantém 'v1').
--
-- Enunciados novos conferidos individualmente contra os 36 já existentes em V16 e V28
-- para evitar duplicação literal ou disfarçada (mesmo ponto testado com outras
-- palavras). Ângulos cobertos nesta leva, ainda não testados nas fases anteriores:
-- esquema flexível NoSQL, 3FN, índice único, SAVEPOINT, deadlock, replication lag,
-- desnormalização deliberada, índice parcial, índice de cobertura (covering index),
-- ordem de escrita do WAL, controle de concorrência otimista, replicação sem líder
-- (leaderless), esquema estrela (OLAP vs. OLTP), índice de expressão (functional
-- index), bloat por transação longa sob MVCC, gap locks do InnoDB, e quorum de
-- leitura/escrita (R + W > N).

-- =====================================================================
-- QUESTIONS + ALTERNATIVAS (18 novas: 6 fácil, 6 média, 6 difícil)
-- =====================================================================

-- ---- FÁCIL (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000001',
    'O que significa dizer que um banco de documento como o MongoDB tem "esquema flexível"?',
    'Esquema flexível significa que documentos da mesma coleção podem ter estruturas de campos diferentes entre si, sem exigir alteração de um esquema global antes de gravar um novo formato de dado — ao contrário de uma tabela relacional, em que toda linha segue as mesmas colunas definidas previamente.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Documentos da mesma coleção podem ter estruturas de campos diferentes entre si, sem exigir alteração de esquema', true),
    ('O banco aceita qualquer tipo de dado sem nenhuma validação, mesmo em produção', false),
    ('As consultas podem ser escritas em qualquer linguagem de programação diretamente no banco', false),
    ('Não é possível indexar campos, já que o esquema muda constantemente', false)
) AS x(texto, correta)
WHERE q.enunciado = 'O que significa dizer que um banco de documento como o MongoDB tem "esquema flexível"?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000001',
    'O que a Terceira Forma Normal (3FN) busca eliminar em uma tabela relacional?',
    'A 3FN elimina dependências transitivas: quando uma coluna não-chave depende de outra coluna não-chave (em vez de depender diretamente da chave primária), essa informação deve ser movida para uma tabela separada, evitando redundância e anomalias de atualização.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Dependências transitivas entre colunas não-chave', true),
    ('A necessidade de qualquer chave estrangeira entre tabelas', false),
    ('A possibilidade de uma tabela ter mais de uma chave candidata', false),
    ('O uso de índices compostos em consultas com múltiplas colunas', false)
) AS x(texto, correta)
WHERE q.enunciado = 'O que a Terceira Forma Normal (3FN) busca eliminar em uma tabela relacional?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000002',
    'Além de acelerar buscas pela coluna indexada, que garantia adicional um índice único (UNIQUE INDEX) oferece?',
    'Um índice único, além de servir para localizar registros rapidamente, impede que dois registros tenham o mesmo valor na coluna (ou combinação de colunas) indexada — o banco rejeita a escrita que violaria essa unicidade.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Garante que não existam dois registros com o mesmo valor na coluna indexada', true),
    ('Garante que a coluna nunca aceite valores nulos', false),
    ('Garante que a tabela nunca precise passar por VACUUM', false),
    ('Garante que a consulta sempre use um Index Scan, nunca um Seq Scan', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Além de acelerar buscas pela coluna indexada, que garantia adicional um índice único (UNIQUE INDEX) oferece?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000003',
    'O que é um SAVEPOINT dentro de uma transação?',
    'Um SAVEPOINT marca um ponto intermediário dentro de uma transação em andamento, permitindo desfazer (ROLLBACK TO SAVEPOINT) apenas as operações feitas depois desse ponto, sem precisar desfazer a transação inteira nem confirmá-la ainda.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Um ponto intermediário que permite desfazer parte de uma transação sem desfazê-la por completo', true),
    ('Um comando que confirma definitivamente parte de uma transação antes do COMMIT final', false),
    ('Uma cópia de segurança automática do banco de dados inteiro', false),
    ('Um mecanismo que impede outras transações de ler a tabela durante a transação atual', false)
) AS x(texto, correta)
WHERE q.enunciado = 'O que é um SAVEPOINT dentro de uma transação?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000004',
    'O que caracteriza um deadlock entre duas transações concorrentes?',
    'Um deadlock ocorre quando duas (ou mais) transações ficam bloqueadas esperando indefinidamente uma pela outra, porque cada uma detém um lock que a outra precisa para continuar — nenhuma consegue avançar sem que uma delas seja abortada.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Cada transação detém um lock que a outra precisa, e ambas ficam bloqueadas esperando uma pela outra indefinidamente', true),
    ('Uma transação lê um dado que a outra ainda não confirmou', false),
    ('Duas transações tentam inserir exatamente a mesma linha ao mesmo tempo, e ambas têm sucesso', false),
    ('O banco de dados trava completamente e para de aceitar qualquer nova conexão', false)
) AS x(texto, correta)
WHERE q.enunciado = 'O que caracteriza um deadlock entre duas transações concorrentes?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000005',
    'O que é "replication lag" (atraso de replicação)?',
    'É o intervalo de tempo entre uma escrita ser confirmada no líder e essa mesma alteração se tornar visível em um seguidor — mais comum e potencialmente maior em replicação assíncrona, podendo fazer com que uma leitura no seguidor retorne dados desatualizados.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('O intervalo de tempo entre uma escrita ser confirmada no líder e se tornar visível em um seguidor', true),
    ('O tempo que uma transação leva para ser confirmada (COMMIT) no próprio líder', false),
    ('A diferença de espaço em disco ocupado entre o líder e os seguidores', false),
    ('O número de seguidores que ainda não foram configurados no cluster', false)
) AS x(texto, correta)
WHERE q.enunciado = 'O que é "replication lag" (atraso de replicação)?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

-- ---- MÉDIA (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000001',
    'Por que uma equipe pode decidir desnormalizar deliberadamente uma tabela, mesmo sabendo que isso reintroduz redundância de dados?',
    'Desnormalizar (duplicar dados que poderiam estar normalizados) pode eliminar joins custosos em consultas de leitura muito frequentes, melhorando desempenho de leitura à custa de mais espaço em disco e da necessidade de manter os dados duplicados sincronizados nas escritas — uma troca aceitável quando leituras superam muito as escritas.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Para reduzir a necessidade de joins em consultas de leitura frequentes, melhorando desempenho às custas de redundância', true),
    ('Porque tabelas desnormalizadas nunca precisam de índices', false),
    ('Porque a desnormalização é exigida pelo padrão SQL para tabelas com mais de uma chave estrangeira', false),
    ('Porque isso elimina automaticamente qualquer necessidade de transações', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Por que uma equipe pode decidir desnormalizar deliberadamente uma tabela, mesmo sabendo que isso reintroduz redundância de dados?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000002',
    'Qual é a vantagem de um índice parcial (partial index), criado com uma cláusula WHERE, em relação a um índice completo sobre a mesma coluna?',
    'Um índice parcial cobre apenas o subconjunto de linhas que satisfaz a condição definida (ex.: WHERE status = ''ativo''), resultando em um índice menor, mais rápido de manter e de percorrer, quando as consultas reais só precisam desse subconjunto de linhas.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('É menor e mais rápido de manter, pois indexa apenas o subconjunto de linhas relevante às consultas', true),
    ('Ele automaticamente se aplica a todas as tabelas do banco, não só à indicada', false),
    ('Ele elimina a necessidade de estatísticas para o otimizador de consultas', false),
    ('Ele garante isolamento Serializable para qualquer consulta que o utilize', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Qual é a vantagem de um índice parcial (partial index), criado com uma cláusula WHERE, em relação a um índice completo sobre a mesma coluna?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000003',
    'Por que o log de write-ahead (WAL) é escrito em disco antes das próprias páginas de dados serem alteradas permanentemente?',
    'Escrever primeiro no WAL garante que, se o banco cair entre a escrita do log e a atualização das páginas de dados, seja possível reconstruir as alterações confirmadas a partir do log na recuperação — é o mecanismo que sustenta a durabilidade sem exigir que cada página alterada seja gravada em disco antes de confirmar a transação ao cliente.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Para permitir que as alterações confirmadas sejam reconstruídas a partir do log em caso de falha antes das páginas de dados serem atualizadas', true),
    ('Para reduzir o tamanho do banco de dados, já que as páginas de dados deixam de ser necessárias', false),
    ('Porque o padrão SQL exige que todo COMMIT seja registrado em pelo menos dois arquivos diferentes', false),
    ('Para acelerar exclusivamente as consultas de leitura, sem relação com falhas do sistema', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Por que o log de write-ahead (WAL) é escrito em disco antes das próprias páginas de dados serem alteradas permanentemente?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000004',
    'Como o controle de concorrência otimista (optimistic locking) costuma detectar que duas transações tentaram atualizar a mesma linha ao mesmo tempo?',
    'Na abordagem otimista, cada linha carrega uma coluna de versão (ou timestamp); ao atualizar, a transação verifica se a versão lida ainda é a mesma antes de gravar — se outra transação já alterou a linha (e incrementou a versão) nesse meio-tempo, a atualização é rejeitada e a aplicação decide como resolver o conflito, sem usar locks durante a leitura.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Comparando uma coluna de versão (ou timestamp) lida no início contra o valor atual da linha antes de confirmar a atualização', true),
    ('Bloqueando a linha inteira com um lock exclusivo assim que ela é lida pela primeira vez', false),
    ('Impedindo que mais de uma transação leia a mesma linha simultaneamente', false),
    ('Registrando a transação em um log separado que é consultado antes de cada leitura futura', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Como o controle de concorrência otimista (optimistic locking) costuma detectar que duas transações tentaram atualizar a mesma linha ao mesmo tempo?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000005',
    'O que diferencia a replicação sem líder (leaderless), como no estilo do Dynamo, do modelo líder-seguidor?',
    'Em replicação sem líder, qualquer réplica pode aceitar leituras e escritas diretamente do cliente, em vez de centralizar todas as escritas em um único nó líder — isso elimina o ponto único de coordenação, mas exige mecanismos como quorum e resolução de conflitos para lidar com réplicas que ficam temporariamente divergentes.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Qualquer réplica pode aceitar escritas diretamente do cliente, sem um nó central coordenando todas elas', true),
    ('Não existe replicação de fato; cada nó mantém dados completamente independentes', false),
    ('As escritas são sempre mais lentas do que no modelo líder-seguidor, sem exceção', false),
    ('Apenas um nó pode existir no cluster a qualquer momento', false)
) AS x(texto, correta)
WHERE q.enunciado = 'O que diferencia a replicação sem líder (leaderless), como no estilo do Dynamo, do modelo líder-seguidor?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000002',
    'O que é um "covering index" (índice de cobertura) e por que ele pode evitar acesso adicional à tabela?',
    'Um covering index inclui todas as colunas que uma consulta precisa (tanto as do filtro quanto as do SELECT), permitindo que o banco responda inteiramente a partir do índice, sem precisar acessar a tabela (heap) para buscar colunas adicionais — o que reduz I/O em relação a um índice comum, que exige esse salto extra.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Um índice que contém todas as colunas exigidas pela consulta, dispensando o acesso extra à tabela para buscar as demais colunas', true),
    ('Um índice que cobre automaticamente todas as tabelas do banco de dados', false),
    ('Um índice que substitui a necessidade de uma chave primária na tabela', false),
    ('Um índice que garante isolamento Serializable para a consulta que o utiliza', false)
) AS x(texto, correta)
WHERE q.enunciado = 'O que é um "covering index" (índice de cobertura) e por que ele pode evitar acesso adicional à tabela?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

-- ---- DIFÍCIL (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000001',
    'Por que um data warehouse (OLAP) tende a usar um esquema estrela (star schema), com tabelas de fatos e dimensões desnormalizadas, em vez do esquema altamente normalizado típico de um sistema transacional (OLTP)?',
    'Cargas OLAP fazem agregações sobre grandes volumes de dados históricos, priorizando poucas leituras analíticas complexas em vez de muitas escritas transacionais pequenas; desnormalizar as dimensões reduz o número de joins necessários nessas consultas analíticas, mesmo à custa da redundância que a normalização evitaria em um sistema OLTP focado em escritas frequentes e consistentes.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Porque prioriza poucas consultas analíticas complexas sobre grandes volumes, e menos joins compensam a redundância introduzida', true),
    ('Porque bancos OLAP não suportam chaves estrangeiras entre tabelas', false),
    ('Porque o esquema estrela é exigido para se usar índices B-tree', false),
    ('Porque sistemas OLAP não permitem nenhum tipo de escrita, tornando a normalização irrelevante', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Por que um data warehouse (OLAP) tende a usar um esquema estrela (star schema), com tabelas de fatos e dimensões desnormalizadas, em vez do esquema altamente normalizado típico de um sistema transacional (OLTP)?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000002',
    'Uma consulta usa WHERE LOWER(email) = ''ana@exemplo.com'', mas existe apenas um índice comum sobre a coluna email. Por que esse índice não é utilizado, e que tipo de índice resolveria o problema?',
    'Um índice comum é construído sobre o valor bruto armazenado na coluna, não sobre o resultado de uma função aplicada a ela; como a consulta filtra pelo resultado de LOWER(email), o otimizador não consegue casar essa expressão com o índice existente. Um índice de expressão (functional index), criado diretamente sobre LOWER(email), resolveria o problema ao indexar o valor já transformado.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('O índice indexa o valor bruto da coluna, não o resultado da função; um índice de expressão sobre LOWER(email) resolveria', true),
    ('O índice não é usado porque a coluna email não pode ser indexada por ser do tipo texto', false),
    ('O índice não é usado porque a cláusula WHERE precisa vir antes do FROM na consulta', false),
    ('Um índice hash sobre a coluna email resolveria, pois hash ignora maiúsculas e minúsculas automaticamente', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Uma consulta usa WHERE LOWER(email) = ''ana@exemplo.com'', mas existe apenas um índice comum sobre a coluna email. Por que esse índice não é utilizado, e que tipo de índice resolveria o problema?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000003',
    'Por que uma transação de longa duração, mantida aberta por horas em um banco com MVCC como o PostgreSQL, pode causar acúmulo de espaço em disco (bloat) mesmo sem realizar nenhuma escrita?',
    'Sob MVCC, o processo de limpeza (VACUUM) só pode remover versões antigas de linhas que não são mais visíveis a nenhuma transação ativa. Uma transação de longa duração, mesmo somente lendo, mantém um snapshot antigo que ainda pode precisar enxergar versões anteriores das linhas — isso impede o VACUUM de removê-las, deixando-as se acumular como "tuplas mortas" até essa transação terminar.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Ela mantém um snapshot antigo que impede o VACUUM de remover versões de linhas ainda potencialmente visíveis a ela', true),
    ('Toda transação aberta grava automaticamente uma cópia completa do banco em disco', false),
    ('Transações de leitura sempre criam novos índices temporários que não são removidos', false),
    ('O PostgreSQL bloqueia a tabela inteira enquanto qualquer transação estiver aberta, causando fragmentação', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Por que uma transação de longa duração, mantida aberta por horas em um banco com MVCC como o PostgreSQL, pode causar acúmulo de espaço em disco (bloat) mesmo sem realizar nenhuma escrita?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000004',
    'Por que o MySQL/InnoDB usa "gap locks" (bloqueios de intervalo) no nível de isolamento Repeatable Read, mesmo esse nível sendo baseado em snapshots (MVCC)?',
    'O Repeatable Read do padrão SQL, por definição, não é obrigado a prevenir phantom read — mas o InnoDB implementa Repeatable Read de forma mais forte que o padrão, também prevenindo phantoms. Para isso, além do snapshot MVCC (que resolve leituras), o InnoDB usa gap locks para impedir que outras transações insiram novas linhas dentro de um intervalo já consultado por uma transação de escrita, fechando a lacuna que permitiria um phantom.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Para impedir que novas linhas sejam inseridas dentro de um intervalo já consultado, prevenindo phantom read também em Repeatable Read', true),
    ('Porque o MVCC do InnoDB não funciona para nenhum tipo de operação de escrita', false),
    ('Para substituir completamente a necessidade do log de transação (redo log)', false),
    ('Porque o InnoDB não suporta índices B-tree, apenas locks para toda leitura', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Por que o MySQL/InnoDB usa "gap locks" (bloqueios de intervalo) no nível de isolamento Repeatable Read, mesmo esse nível sendo baseado em snapshots (MVCC)?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000005',
    'Em um sistema com N réplicas usando quorum de leitura R e quorum de escrita W, por que garantir R + W > N assegura que toda leitura enxergue ao menos uma cópia da escrita mais recente confirmada?',
    'Se W réplicas confirmam cada escrita e R réplicas são consultadas em cada leitura, R + W > N garante que os conjuntos de réplicas lidas e escritas necessariamente se sobrepõem em pelo menos uma réplica — por contagem, não é possível escolher R réplicas para ler e W réplicas para escrever, de um total de N, sem que ao menos uma pertença aos dois grupos. Essa réplica em comum garante que a leitura enxergue a escrita mais recente.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Porque, por contagem, os conjuntos de réplicas lidas e escritas necessariamente se sobrepõem em pelo menos uma réplica', true),
    ('Porque isso força todas as N réplicas a serem atualizadas antes de qualquer leitura ser permitida', false),
    ('Porque R e W precisam ser sempre iguais a N para o sistema funcionar', false),
    ('Porque isso elimina a necessidade de qualquer replicação assíncrona no sistema', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Em um sistema com N réplicas usando quorum de leitura R e quorum de escrita W, por que garantir R + W > N assegura que toda leitura enxergue ao menos uma cópia da escrita mais recente confirmada?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
    'a3000000-0000-4000-8000-000000000005',
    'Como sistemas de replicação sem líder costumam lidar com duas escritas concorrentes na mesma chave, feitas em réplicas diferentes antes de se propagarem entre si?',
    'Como não há um líder único para serializar as escritas, o sistema precisa detectar e resolver o conflito depois que as réplicas se sincronizam — estratégias comuns incluem "last write wins" (descarta a escrita mais antiga com base em timestamp, podendo perder dados silenciosamente) ou manter metadados de versão (como vetores de versão) para detectar concorrência real e deixar a aplicação decidir como fazer o merge.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, x.texto, x.correta FROM question q
CROSS JOIN (VALUES
    ('Detectam o conflito na sincronização entre réplicas e o resolvem via estratégias como last-write-wins ou vetores de versão', true),
    ('A segunda escrita é automaticamente rejeitada pelo sistema, preservando sempre a primeira', false),
    ('O sistema impede fisicamente que duas escritas concorrentes cheguem a réplicas diferentes', false),
    ('Um protocolo de commit distribuído (two-phase commit) é acionado automaticamente antes de cada escrita', false)
) AS x(texto, correta)
WHERE q.enunciado = 'Como sistemas de replicação sem líder costumam lidar com duas escritas concorrentes na mesma chave, feitas em réplicas diferentes antes de se propagarem entre si?'
  AND q.domain_ref = (SELECT id FROM domain WHERE slug = 'bancos-de-dados');
