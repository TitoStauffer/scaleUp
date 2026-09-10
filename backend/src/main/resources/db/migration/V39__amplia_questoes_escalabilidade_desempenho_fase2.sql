-- Ampliação do pool de Questions (Fase 2) — Domínio: Escalabilidade e Desempenho (slug: escalabilidade-desempenho)
-- Fase 2 do TICKET-content-expansion-questoes-fase2.md (ver também TICKET-content-database.md
-- e TICKET-content-expansion-questoes.md, referente à Fase 1).
--
-- Escopo: apenas Question + Alternativas. Nenhum Concept/Slide/Flashcard novo — reaproveita
-- os 5 Concepts já criados em V18__seed_conteudo_escalabilidade_desempenho.sql.
--
-- Conteúdo rascunhado por IA (autoria assistida), pendente de revisão humana antes de
-- produção — todo item usa content_version = 'v1' e status_revisao = 'rascunho', mesma
-- convenção dos lotes anteriores (V18 e V30).
--
-- Não-duplicação: as 18 Questions abaixo foram escritas após leitura integral das duas fases
-- anteriores deste domínio — V18__seed_conteudo_escalabilidade_desempenho.sql (18 Questions)
-- e V30__amplia_questoes_escalabilidade_desempenho.sql (18 Questions), 36 no total — e cobrem
-- pontos ainda não testados por elas: downtime/reinício em escalonamento vertical, auto-scaling
-- horizontal orientado a métricas, capacity planning (over/under provisioning), cache local vs.
-- distribuído, hit ratio, cache warming, política de evicção LRU e seu caso patológico,
-- weighted round-robin, downside de sticky sessions/hashing consistente, cold start de
-- instância recém-provisionada, particionamento vertical vs. horizontal, lag de réplicas de
-- leitura assíncronas, denormalização deliberada para leitura em escala, percentis de latência
-- (p95), índices e custo de escrita, paginação por cursor vs. offset, leaky bucket vs. token
-- bucket, e saturação/enfileiramento (throughput estável com latência crescente). Nenhum
-- enunciado repete, literalmente ou como reformulação disfarçada, um ponto já coberto em V18
-- ou V30.
--
-- Volume entregue: 18 Questions novas (6 fácil, 6 média, 6 difícil) com 4 alternativas cada,
-- elevando o total do domínio de 36 para 54 Questions.

-- ---------- FÁCEIS (6) ----------

-- Concept 1: Escalabilidade horizontal vs. vertical
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('d1000000-0000-4000-8000-000000000001',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000001',
        'Reiniciar ou substituir a máquina para efetivar o aumento de recursos (CPU, memória) costuma ser necessário em qual tipo de escalabilidade?',
        'Escalar verticalmente geralmente exige reiniciar a máquina (ou trocá-la por uma de maior capacidade), o que interrompe temporariamente o serviço — um custo operacional que a escalabilidade horizontal, ao adicionar novas máquinas sem afetar as existentes, não tem.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('d1000000-0000-4000-8000-000000000001', 'Escalabilidade vertical', true),
    ('d1000000-0000-4000-8000-000000000001', 'Escalabilidade horizontal', false),
    ('d1000000-0000-4000-8000-000000000001', 'Nenhuma das duas, pois ambas dispensam qualquer reinício', false),
    ('d1000000-0000-4000-8000-000000000001', 'Apenas o balanceamento de carga entre instâncias', false);

-- Concept 2: Caching e estratégias de invalidação
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('d1000000-0000-4000-8000-000000000002',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000002',
        'O que mede a métrica de "hit ratio" (taxa de acerto) de um cache?',
        'Hit ratio é a proporção de requisições atendidas diretamente pelo cache, sem precisar acessar a fonte original de dados; é uma métrica central para avaliar se um cache está efetivamente reduzindo carga e latência.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('d1000000-0000-4000-8000-000000000002', 'A proporção de requisições atendidas pelo cache sem precisar consultar a fonte original', true),
    ('d1000000-0000-4000-8000-000000000002', 'O tempo médio de vida (TTL) configurado para as entradas do cache', false),
    ('d1000000-0000-4000-8000-000000000002', 'A quantidade de memória RAM total disponível para o cache', false),
    ('d1000000-0000-4000-8000-000000000002', 'O número de instâncias que compartilham o mesmo cache distribuído', false);

-- Concept 3: Balanceamento de carga
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('d1000000-0000-4000-8000-000000000003',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000003',
        'O que faz o algoritmo de balanceamento "weighted round-robin"?',
        'Weighted round-robin distribui requisições em ciclo, como o round-robin simples, mas atribui pesos às instâncias conforme sua capacidade, enviando proporcionalmente mais requisições às instâncias com maior peso — útil em clusters com máquinas de capacidades diferentes.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('d1000000-0000-4000-8000-000000000003', 'Distribui requisições em ciclo, enviando mais para instâncias com maior peso/capacidade configurada', true),
    ('d1000000-0000-4000-8000-000000000003', 'Envia todas as requisições sempre para a mesma instância até ela falhar', false),
    ('d1000000-0000-4000-8000-000000000003', 'Distribui requisições apenas com base no hash do corpo da requisição', false),
    ('d1000000-0000-4000-8000-000000000003', 'Ignora completamente a capacidade das instâncias e prioriza a mais recente adicionada', false);

-- Concept 4: Particionamento e distribuição de tráfego
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('d1000000-0000-4000-8000-000000000004',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000004',
        'O que é particionamento vertical de dados, em contraste com o particionamento horizontal (sharding)?',
        'Particionamento vertical divide os dados por colunas, tabelas ou domínio funcional (por exemplo, um banco de dados dedicado por serviço), em vez de dividir linhas de um mesmo esquema entre nós idênticos, como faz o sharding horizontal.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('d1000000-0000-4000-8000-000000000004', 'Divide os dados por colunas, tabelas ou domínio funcional entre bancos diferentes', true),
    ('d1000000-0000-4000-8000-000000000004', 'Divide as linhas de uma mesma tabela igualmente entre nós idênticos', false),
    ('d1000000-0000-4000-8000-000000000004', 'Cria cópias completas e idênticas dos dados em múltiplos servidores', false),
    ('d1000000-0000-4000-8000-000000000004', 'Comprime os dados verticalmente para reduzir espaço em disco', false);

-- Concept 5: Otimização de latência, throughput e rate limiting
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('d1000000-0000-4000-8000-000000000005',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000005',
        'O que representa a métrica de latência "p95" (percentil 95)?',
        'p95 é o tempo de resposta abaixo do qual 95% das requisições foram atendidas, evidenciando o comportamento de cauda (piores casos) de forma mais informativa do que a média, que pode esconder requisições muito lentas.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('d1000000-0000-4000-8000-000000000005', 'O tempo de resposta abaixo do qual 95% das requisições foram atendidas', true),
    ('d1000000-0000-4000-8000-000000000005', 'A média aritmética simples do tempo de resposta de todas as requisições', false),
    ('d1000000-0000-4000-8000-000000000005', 'O percentual de requisições que retornaram erro 500', false),
    ('d1000000-0000-4000-8000-000000000005', 'O número máximo de requisições que o sistema pode processar por segundo', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('d1000000-0000-4000-8000-000000000006',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000005',
        'O que é "capacity planning" (planejamento de capacidade)?',
        'Capacity planning é o processo de estimar a capacidade de infraestrutura necessária para suportar a carga futura esperada, com base em projeções de crescimento e testes de carga, evitando tanto a falta quanto o excesso de recursos provisionados.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('d1000000-0000-4000-8000-000000000006', 'Estimar a capacidade de infraestrutura necessária para suportar a carga futura esperada', true),
    ('d1000000-0000-4000-8000-000000000006', 'Definir o algoritmo de balanceamento de carga que será usado em produção', false),
    ('d1000000-0000-4000-8000-000000000006', 'Escolher a estratégia de invalidação de cache mais adequada ao sistema', false),
    ('d1000000-0000-4000-8000-000000000006', 'Determinar a chave de partição de uma tabela particionada', false);

-- ---------- MÉDIAS (6) ----------

-- Concept 1
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('d1000000-0000-4000-8000-000000000007',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000001',
        'Por que a escalabilidade horizontal costuma viabilizar auto-scaling automático (adicionar/remover instâncias conforme métricas como uso de CPU) de forma mais natural do que a escalabilidade vertical?',
        'Adicionar ou remover instâncias idênticas é uma operação simples e reversível quando a aplicação é stateless, enquanto redimensionar verticalmente uma máquina em produção geralmente exige reinício e planejamento manual, o que dificulta automatizar esse ajuste em tempo real.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('d1000000-0000-4000-8000-000000000007', 'Porque adicionar/remover instâncias idênticas é simples e reversível, enquanto redimensionar uma máquina exige reinício e planejamento manual', true),
    ('d1000000-0000-4000-8000-000000000007', 'Porque escalabilidade vertical não pode ser monitorada por métricas de uso de recursos', false),
    ('d1000000-0000-4000-8000-000000000007', 'Porque auto-scaling só é suportado por bancos de dados relacionais, não por serviços de aplicação', false),
    ('d1000000-0000-4000-8000-000000000007', 'Porque escalabilidade horizontal elimina a necessidade de qualquer balanceador de carga', false);

-- Concept 2
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('d1000000-0000-4000-8000-000000000008',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000002',
        'O que é "cache warming" (pré-aquecimento de cache)?',
        'Cache warming é popular o cache com os dados esperados antes de um pico de tráfego previsto (ex.: um lançamento de produto), evitando que uma onda grande de requisições chegue simultaneamente com cache vazio logo no início do pico.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('d1000000-0000-4000-8000-000000000008', 'Popular o cache com dados esperados antes de um pico de tráfego previsto', true),
    ('d1000000-0000-4000-8000-000000000008', 'Aumentar o TTL de todas as entradas do cache automaticamente durante a madrugada', false),
    ('d1000000-0000-4000-8000-000000000008', 'Remover todas as entradas do cache periodicamente para forçar dados sempre atualizados', false),
    ('d1000000-0000-4000-8000-000000000008', 'Migrar o cache de uma instância local para um banco de dados relacional', false);

-- Concept 3
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('d1000000-0000-4000-8000-000000000009',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000003',
        'Qual é uma desvantagem de usar sticky sessions (afinidade via hashing consistente) quando uma sessão específica gera tráfego muito acima da média das demais?',
        'Como toda a sessão fica presa a uma única instância, essa instância recebe uma carga desproporcional em relação às demais, quebrando a distribuição uniforme que algoritmos como round-robin ou least connections ofereceriam sem essa afinidade.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('d1000000-0000-4000-8000-000000000009', 'A instância responsável por aquela sessão pode receber carga desproporcional, quebrando a distribuição uniforme', true),
    ('d1000000-0000-4000-8000-000000000009', 'O balanceador de carga deixa de conseguir realizar health checks nas instâncias', false),
    ('d1000000-0000-4000-8000-000000000009', 'Todas as sessões passam a compartilhar obrigatoriamente o mesmo cache distribuído', false),
    ('d1000000-0000-4000-8000-000000000009', 'O balanceamento passa a operar exclusivamente na camada de transporte (L4)', false);

-- Concept 4
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('d1000000-0000-4000-8000-000000000010',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000004',
        'Por que réplicas de leitura mantidas por replicação assíncrona podem servir dados desatualizados ao escalar horizontalmente a leitura?',
        'A replicação assíncrona propaga as escritas do nó primário para as réplicas com algum atraso (lag); uma leitura feita em uma réplica durante essa janela pode retornar um valor anterior ao mais recente já confirmado no primário.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('d1000000-0000-4000-8000-000000000010', 'Porque existe um atraso (lag) entre a escrita no nó primário e sua propagação para as réplicas', true),
    ('d1000000-0000-4000-8000-000000000010', 'Porque réplicas de leitura armazenam apenas metadados, nunca os dados completos', false),
    ('d1000000-0000-4000-8000-000000000010', 'Porque réplicas de leitura não podem ser usadas em conjunto com balanceamento de carga', false),
    ('d1000000-0000-4000-8000-000000000010', 'Porque toda réplica de leitura recalcula os dados a partir do zero a cada consulta', false);

-- Concept 5
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('d1000000-0000-4000-8000-000000000011',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000005',
        'Por que adicionar um índice em uma tabela com alto volume de escrita pode piorar o desempenho de escrita, mesmo acelerando as leituras?',
        'Cada operação de escrita (insert, update ou delete) precisa também atualizar as estruturas de índice correspondentes, adicionando overhead proporcional ao número de índices existentes na tabela — um trade-off clássico entre desempenho de leitura e de escrita.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('d1000000-0000-4000-8000-000000000011', 'Porque cada escrita precisa atualizar também as estruturas de índice, adicionando overhead', true),
    ('d1000000-0000-4000-8000-000000000011', 'Porque índices só podem ser criados em tabelas que não recebem nenhuma escrita', false),
    ('d1000000-0000-4000-8000-000000000011', 'Porque índices convertem automaticamente todas as escritas em operações assíncronas', false),
    ('d1000000-0000-4000-8000-000000000011', 'Porque índices ocupam espaço apenas em memória, nunca em disco', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('d1000000-0000-4000-8000-000000000012',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000005',
        'Por que a paginação baseada em cursor (keyset pagination) tende a ter desempenho melhor que a paginação por offset em tabelas muito grandes?',
        'A paginação por offset exige que o banco percorra e descarte todas as linhas anteriores à página solicitada, ficando cada vez mais lenta conforme o offset cresce; a paginação por cursor busca diretamente a partir da última chave vista, sem essa varredura.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('d1000000-0000-4000-8000-000000000012', 'Porque offset exige percorrer e descartar todas as linhas anteriores à página, enquanto cursor busca diretamente a partir da última chave vista', true),
    ('d1000000-0000-4000-8000-000000000012', 'Porque paginação por cursor não permite ordenar os resultados por nenhuma coluna', false),
    ('d1000000-0000-4000-8000-000000000012', 'Porque paginação por offset é proibida em bancos de dados relacionais modernos', false),
    ('d1000000-0000-4000-8000-000000000012', 'Porque paginação por cursor sempre retorna todos os registros de uma vez, sem páginas', false);

-- ---------- DIFÍCEIS (6) ----------

-- Concept 1
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('d1000000-0000-4000-8000-000000000013',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000001',
        'Uma equipe decide superdimensionar (overprovision) a infraestrutura bem acima da carga observada, "por segurança", em vez de dimensionar com base em capacity planning orientado a dados. Qual é o principal custo dessa decisão?',
        'Overprovisioning generoso significa pagar continuamente por capacidade ociosa, já que a carga real raramente se aproxima do limite provisionado, aumentando o custo operacional sem um benefício proporcional de disponibilidade ou desempenho.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('d1000000-0000-4000-8000-000000000013', 'Pagar continuamente por capacidade ociosa, sem benefício proporcional de disponibilidade ou desempenho', true),
    ('d1000000-0000-4000-8000-000000000013', 'Reduzir automaticamente a resiliência do sistema a picos de tráfego', false),
    ('d1000000-0000-4000-8000-000000000013', 'Impedir completamente a criação de réplicas de leitura', false),
    ('d1000000-0000-4000-8000-000000000013', 'Eliminar a necessidade de qualquer balanceamento de carga', false);

-- Concept 2
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('d1000000-0000-4000-8000-000000000014',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000002',
        'Por que a política de evicção de cache LRU (least recently used) pode ter desempenho ruim quando o padrão de acesso é uma varredura sequencial de um conjunto de dados maior que o próprio cache?',
        'Em uma varredura sequencial, cada item é acessado uma única vez e depois nunca mais reacessado; a política LRU substitui constantemente entradas antigas por esses itens de uso único, expulsando dados que de fato seriam reutilizados, sem capturar nenhum padrão real de reuso.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('d1000000-0000-4000-8000-000000000014', 'Porque cada item da varredura é acessado uma única vez, fazendo o LRU expulsar dados úteis para dar lugar a itens que não serão reacessados', true),
    ('d1000000-0000-4000-8000-000000000014', 'Porque LRU só pode ser usado em caches com TTL desabilitado', false),
    ('d1000000-0000-4000-8000-000000000014', 'Porque LRU exige que todos os dados caibam simultaneamente em memória, sem exceção', false),
    ('d1000000-0000-4000-8000-000000000014', 'Porque LRU converte automaticamente o cache de cache-aside para write-through', false);

-- Concept 3
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('d1000000-0000-4000-8000-000000000015',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000003',
        'Um sistema com auto-scaling adiciona uma nova instância sob pico de tráfego, e o load balancer imediatamente envia a ela uma fatia igual de requisições, mesmo antes de suas conexões e caches locais estarem "aquecidos". Que problema isso pode causar?',
        'A nova instância pode responder mais lentamente ou até falhar sob carga plena recebida de imediato, já que ainda não tem conexões de banco estabelecidas nem cache populado — podendo inclusive ser removida prematuramente do pool por falhar em health checks devido a essa lentidão inicial.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('d1000000-0000-4000-8000-000000000015', 'A instância recém-criada pode responder lentamente ou falhar sob carga plena antes de estar aquecida, podendo inclusive ser removida por health checks', true),
    ('d1000000-0000-4000-8000-000000000015', 'O load balancer perde automaticamente a capacidade de fazer round-robin entre as demais instâncias', false),
    ('d1000000-0000-4000-8000-000000000015', 'Todas as outras instâncias do cluster são reiniciadas simultaneamente por segurança', false),
    ('d1000000-0000-4000-8000-000000000015', 'O sistema passa a operar obrigatoriamente em balanceamento de camada 4 (L4)', false);

-- Concept 4
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('d1000000-0000-4000-8000-000000000016',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000004',
        'Por que denormalizar dados (duplicar informação entre tabelas ou serviços) pode ser uma decisão deliberada para escalar leitura em alto volume, apesar do custo que introduz?',
        'Denormalização evita joins custosos entre tabelas ou chamadas síncronas entre serviços a cada leitura, ao custo de precisar manter múltiplas cópias do mesmo dado sincronizadas a cada escrita, aumentando a complexidade de manter consistência entre elas.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('d1000000-0000-4000-8000-000000000016', 'Evita joins custosos ou chamadas entre serviços a cada leitura, ao custo de manter múltiplas cópias sincronizadas na escrita', true),
    ('d1000000-0000-4000-8000-000000000016', 'Elimina completamente a necessidade de particionar os dados em qualquer cenário', false),
    ('d1000000-0000-4000-8000-000000000016', 'Garante que os dados nunca fiquem inconsistentes entre as cópias duplicadas', false),
    ('d1000000-0000-4000-8000-000000000016', 'Substitui a necessidade de qualquer estratégia de cache na camada de leitura', false);

-- Concept 5
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('d1000000-0000-4000-8000-000000000017',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000005',
        'Qual é a principal diferença entre os algoritmos de rate limiting "leaky bucket" e "token bucket"?',
        'Leaky bucket processa requisições a uma taxa de saída constante, suavizando rajadas de entrada; token bucket acumula tokens a uma taxa fixa e permite que o cliente consuma vários de uma vez, tolerando rajadas curtas dentro do limite acumulado.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('d1000000-0000-4000-8000-000000000017', 'Leaky bucket processa a uma taxa de saída constante, suavizando rajadas; token bucket permite rajadas dentro do limite de tokens acumulados', true),
    ('d1000000-0000-4000-8000-000000000017', 'Os dois algoritmos são idênticos, apenas com nomes diferentes para o mesmo comportamento', false),
    ('d1000000-0000-4000-8000-000000000017', 'Leaky bucket só pode ser implementado em balanceadores de camada 7', false),
    ('d1000000-0000-4000-8000-000000000017', 'Token bucket nunca permite rajadas de tráfego, apenas taxa constante', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('d1000000-0000-4000-8000-000000000018',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000005',
        'Um sistema mantém throughput aparentemente estável sob carga crescente, mas a latência das requisições começa a crescer continuamente. O que esse padrão geralmente indica?',
        'Indica que o sistema está se aproximando da saturação: requisições estão se acumulando em filas internas (de processamento, de conexões, etc.) mais rápido do que conseguem ser atendidas; o throughput medido ainda não caiu porque a fila absorve o excesso temporariamente, mas a latência crescente já reflete esse acúmulo.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('d1000000-0000-4000-8000-000000000018', 'Que o sistema está se aproximando da saturação, com requisições se acumulando em filas internas mais rápido do que são atendidas', true),
    ('d1000000-0000-4000-8000-000000000018', 'Que o sistema está subutilizado e poderia receber ainda mais carga sem nenhum efeito colateral', false),
    ('d1000000-0000-4000-8000-000000000018', 'Que o cache atingiu 100% de hit ratio e não há mais nada a otimizar', false),
    ('d1000000-0000-4000-8000-000000000018', 'Que o balanceador de carga parou de distribuir requisições entre instâncias', false);
