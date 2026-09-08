-- Seed de conteúdo — Domínio: Escalabilidade e Desempenho (slug: escalabilidade-desempenho)
-- Origem: docs/product/tickets/content/TICKET-content-escalabilidade-desempenho.md
-- Regras gerais: docs/product/tickets/TICKET-content-database.md
--
-- Conteúdo rascunhado por IA (autoria assistida), pendente de revisão humana antes de
-- produção — todo item usa content_version = 'v1' e status_revisao = 'rascunho'.
-- Esta migração nunca insere em domain (V13 já fez isso); referencia o domínio existente
-- via subquery em domain.slug, conforme padrão estabelecido para V14-V20.
--
-- Volume entregue: 5 Concepts, 15 Slides (3 por Concept), 15 Flashcards (3 por Concept),
-- 18 Questions (6 fácil, 6 média, 6 difícil) com 4 alternativas cada.

-- =====================================================================================
-- CONCEPTS
-- =====================================================================================

INSERT INTO concept (id, domain_ref, titulo, resumo, content_version, status_revisao)
VALUES
    ('a1000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'Escalabilidade horizontal vs. vertical',
     'Diferenças entre escalar adicionando mais máquinas (horizontal) ou aumentando a capacidade de uma máquina existente (vertical), com seus limites, custos e implicações para o design da aplicação.',
     'v1', 'rascunho'),
    ('a1000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'Caching e estratégias de invalidação',
     'Uso de camadas de cache (aplicação, CDN, banco) para reduzir latência e carga em sistemas de origem, e as estratégias para manter os dados em cache consistentes com a fonte de verdade.',
     'v1', 'rascunho'),
    ('a1000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'Balanceamento de carga',
     'Distribuição de requisições entre múltiplas instâncias de um serviço para maximizar utilização de recursos, evitar sobrecarga de um único nó e sustentar disponibilidade.',
     'v1', 'rascunho'),
    ('a1000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'Particionamento e distribuição de tráfego',
     'Técnicas de sharding e particionamento de dados/tráfego para permitir que um sistema cresça além da capacidade de um único nó, incluindo estratégias de chave de partição e hot spots.',
     'v1', 'rascunho'),
    ('a1000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'Otimização de latência, throughput e rate limiting',
     'Trade-offs entre latência e throughput, técnicas de otimização (assincronismo, batching, connection pooling) e uso de rate limiting para proteger sistemas contra sobrecarga.',
     'v1', 'rascunho');

-- =====================================================================================
-- SLIDES (3 por Concept, ordem sequencial 1..3)
-- =====================================================================================

-- Concept 1: Escalabilidade horizontal vs. vertical
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ((SELECT id FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000001'),
     (SELECT domain_ref FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000001'),
     'O que é escalar um sistema',
     'Escalar significa aumentar a capacidade de um sistema de lidar com mais carga (mais usuários, mais requisições, mais dados) sem degradar desempenho de forma inaceitável. Existem duas direções principais: escalar verticalmente (scale up), aumentando os recursos de uma única máquina — mais CPU, mais memória, discos mais rápidos —, e escalar horizontalmente (scale out), adicionando mais máquinas que trabalham em conjunto para dividir a carga. A escolha entre as duas não é binária: sistemas reais frequentemente combinam ambas as estratégias em diferentes camadas.',
     1, 'v1', 'rascunho'),
    ((SELECT id FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000001'),
     (SELECT domain_ref FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000001'),
     'Limites e custos de cada abordagem',
     'Escalar verticalmente é simples de implementar — não exige mudanças na arquitetura da aplicação — mas tem um teto físico: existe um limite de CPU/memória que uma única máquina suporta, o custo cresce de forma não linear à medida que se aproxima do topo da linha de hardware disponível, e a máquina se torna um ponto único de falha. Escalar horizontalmente remove esse teto (em teoria, pode-se sempre adicionar mais máquinas) e melhora a resiliência, mas exige que a aplicação seja projetada para rodar em múltiplas instâncias: estado precisa ser externalizado (sessões, cache), é necessário balanceamento de carga, e a complexidade operacional aumenta (deploy, monitoramento, coordenação entre nós).',
     2, 'v1', 'rascunho'),
    ((SELECT id FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000001'),
     (SELECT domain_ref FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000001'),
     'Aplicação prática: stateless como pré-requisito',
     'Para escalar horizontalmente com eficácia, serviços de aplicação geralmente precisam ser stateless — ou seja, qualquer instância pode atender qualquer requisição, sem depender de estado guardado em memória local de uma instância específica (por exemplo, sessão de usuário). Estado que precisa persistir entre requisições é movido para um armazenamento compartilhado (banco de dados, cache distribuído como Redis). Bancos de dados relacionais tradicionais, por sua vez, são mais difíceis de escalar horizontalmente para escrita (exigem particionamento/sharding), enquanto réplicas de leitura permitem escalar horizontalmente a leitura com relativa facilidade.',
     3, 'v1', 'rascunho');

-- Concept 2: Caching e estratégias de invalidação
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ((SELECT id FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000002'),
     (SELECT domain_ref FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000002'),
     'Por que cachear',
     'Cache é o armazenamento temporário de uma cópia de um dado, mais próxima de quem o consome, para evitar recalculá-lo ou buscá-lo novamente na fonte original (mais lenta ou mais cara de acessar). Cache reduz latência percebida pelo usuário, reduz a carga sobre sistemas de origem (banco de dados, serviços downstream) e pode reduzir custo (menos chamadas a serviços cobrados por uso). Existem múltiplas camadas onde cache pode ser aplicado: no navegador, em uma CDN, em um cache de aplicação (ex.: Redis, Memcached) e no próprio banco de dados (buffer pool).',
     1, 'v1', 'rascunho'),
    ((SELECT id FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000002'),
     (SELECT domain_ref FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000002'),
     'Estratégias de leitura e escrita em cache',
     'Cache-aside (lazy loading): a aplicação verifica o cache primeiro; se não encontrar (cache miss), busca na fonte e grava no cache para as próximas leituras. É a estratégia mais comum, simples e resiliente a falhas do cache, mas a primeira leitura após um miss é mais lenta. Write-through: toda escrita é feita simultaneamente no cache e na fonte, mantendo-os sempre sincronizados, ao custo de latência de escrita maior. Write-behind (write-back): a escrita vai primeiro para o cache e é propagada de forma assíncrona para a fonte, priorizando latência de escrita, mas com risco de perda de dados se o cache falhar antes da propagação.',
     2, 'v1', 'rascunho'),
    ((SELECT id FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000002'),
     (SELECT domain_ref FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000002'),
     'O problema difícil: invalidação',
     'A frase "existem apenas duas coisas difíceis em ciência da computação: cache invalidation e nomear coisas" resume um problema real: dados em cache podem ficar desatualizados (stale) em relação à fonte, e decidir quando e como atualizá-los é a parte mais delicada de qualquer estratégia de cache. Abordagens comuns incluem: TTL (time-to-live), que expira o dado automaticamente após um tempo, aceitando uma janela de inconsistência; invalidação explícita, em que a aplicação remove ou atualiza a entrada do cache no momento em que o dado de origem muda; e versionamento de chaves, em que a própria chave do cache muda quando o dado muda, tornando entradas antigas naturalmente inacessíveis (mas exigindo limpeza posterior). Não existe estratégia universalmente correta — a escolha depende de quão tolerável é servir um dado ligeiramente desatualizado para aquele caso de uso específico.',
     3, 'v1', 'rascunho');

-- Concept 3: Balanceamento de carga
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ((SELECT id FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000003'),
     (SELECT domain_ref FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000003'),
     'O papel do load balancer',
     'Um load balancer é um componente que recebe requisições de entrada e as distribui entre múltiplas instâncias de um serviço, evitando que qualquer instância individual fique sobrecarregada enquanto outras ficam ociosas. Além de distribuir carga, um load balancer tipicamente também detecta instâncias com falha (health checks) e para de enviar tráfego para elas, contribuindo diretamente para a disponibilidade do sistema. Pode operar na camada de transporte (L4, baseado em IP/porta, mais rápido e simples) ou na camada de aplicação (L7, baseado em conteúdo da requisição HTTP, como path ou headers, mais flexível mas com mais overhead).',
     1, 'v1', 'rascunho'),
    ((SELECT id FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000003'),
     (SELECT domain_ref FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000003'),
     'Algoritmos de distribuição',
     'Round-robin distribui requisições sequencialmente entre as instâncias disponíveis, de forma simples e previsível, mas ignora a carga atual de cada instância. Least connections envia a próxima requisição para a instância com menos conexões ativas no momento, adaptando-se melhor a cargas desiguais entre requisições. Hashing consistente calcula qual instância deve atender uma requisição com base em uma chave (ex.: ID do cliente), garantindo que a mesma chave sempre vá para a mesma instância — útil quando é necessário afinidade de sessão (sticky sessions) ou para maximizar acerto de cache local por instância.',
     2, 'v1', 'rascunho'),
    ((SELECT id FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000003'),
     (SELECT domain_ref FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000003'),
     'Balanceamento em múltiplas camadas',
     'Em sistemas reais, balanceamento de carga costuma acontecer em várias camadas simultaneamente: um balanceador global de DNS/CDN distribui usuários entre regiões geográficas, um balanceador de borda distribui tráfego entre clusters ou zonas de disponibilidade, e balanceadores internos distribuem requisições entre instâncias de um serviço específico ou entre réplicas de um banco de dados. Cada camada adicional de balanceamento aumenta a resiliência do sistema a falhas localizadas, mas também adiciona um salto de rede e, portanto, latência — um trade-off que precisa ser avaliado conforme a criticidade de disponibilidade versus a sensibilidade a latência do serviço.',
     3, 'v1', 'rascunho');

-- Concept 4: Particionamento e distribuição de tráfego
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ((SELECT id FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000004'),
     (SELECT domain_ref FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000004'),
     'Por que particionar dados',
     'Particionamento (sharding) é a divisão de um conjunto de dados em partes menores (partições ou shards), cada uma armazenada e servida por um subconjunto diferente de máquinas. É necessário quando o volume de dados ou o volume de escrita excede o que uma única máquina (mesmo escalada verticalmente ao limite) consegue suportar. Diferente de réplicas — que são cópias completas dos mesmos dados usadas para escalar leitura e disponibilidade —, partições contêm subconjuntos distintos dos dados, e cada requisição de escrita ou leitura precisa ser roteada para a partição correta.',
     1, 'v1', 'rascunho'),
    ((SELECT id FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000004'),
     (SELECT domain_ref FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000004'),
     'Escolha da chave de partição',
     'A chave de partição (partition key ou shard key) determina como os dados são distribuídos entre as partições, e essa escolha tem impacto direto no desempenho do sistema. Uma boa chave distribui a carga de forma razoavelmente uniforme entre as partições e permite que a maioria das consultas seja resolvida acessando uma única partição (evitando fan-out para todas as partições a cada consulta). Escolher mal a chave pode concentrar dados ou tráfego, gerando desequilíbrio entre partições.',
     2, 'v1', 'rascunho'),
    ((SELECT id FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000004'),
     (SELECT domain_ref FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000004'),
     'Hot spots e rebalanceamento',
     'Um hot spot ocorre quando uma partição recebe volume de tráfego ou dados desproporcionalmente maior que as demais — por exemplo, ao particionar por ID de usuário quando um pequeno grupo de usuários (ou um único usuário muito ativo, como uma conta corporativa grande) concentra a maior parte das requisições. Hot spots anulam o benefício do particionamento, já que a partição sobrecarregada se torna o novo gargalo do sistema. Mitigações incluem escolher chaves com maior cardinalidade e distribuição mais uniforme, dividir chaves muito "quentes" em subchaves artificiais, e suportar rebalanceamento — mover partições entre nós conforme a carga muda ao longo do tempo, idealmente de forma automática e sem downtime.',
     3, 'v1', 'rascunho');

-- Concept 5: Otimização de latência, throughput e rate limiting
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ((SELECT id FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000005'),
     (SELECT domain_ref FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000005'),
     'Latência vs. throughput',
     'Latência é o tempo que uma única requisição leva para ser processada e respondida; throughput é a quantidade de requisições que o sistema consegue processar em um período de tempo. Os dois nem sempre andam juntos: é possível aumentar throughput agrupando requisições em lotes (batching), o que geralmente aumenta a latência individual de cada requisição dentro do lote, em troca de processar mais requisições por segundo no total. Sistemas de baixa latência (ex.: negociação de alta frequência, jogos em tempo real) priorizam responder rápido mesmo que isso limite o throughput total; sistemas de processamento em lote (ex.: geração de relatórios noturnos) priorizam o inverso.',
     1, 'v1', 'rascunho'),
    ((SELECT id FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000005'),
     (SELECT domain_ref FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000005'),
     'Técnicas comuns de otimização',
     'Processamento assíncrono move trabalho que não precisa bloquear a resposta ao usuário (ex.: envio de e-mail, geração de relatório) para fora do caminho crítico da requisição, reduzindo a latência percebida. Connection pooling reutiliza conexões já estabelecidas (com banco de dados, com outros serviços) em vez de abrir e fechar uma conexão nova a cada requisição, evitando o custo de handshake repetido. Compressão de payload reduz o volume de dados trafegado na rede, ao custo de CPU para comprimir/descomprimir. Paralelização de chamadas independentes (em vez de encadeá-las sequencialmente) reduz a latência total de uma requisição que depende de múltiplas fontes de dados.',
     2, 'v1', 'rascunho'),
    ((SELECT id FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000005'),
     (SELECT domain_ref FROM concept WHERE id = 'a1000000-0000-4000-8000-000000000005'),
     'Rate limiting como proteção',
     'Rate limiting restringe a quantidade de requisições que um cliente (usuário, API key, IP) pode fazer em uma janela de tempo, protegendo o sistema contra sobrecarga — seja por tráfego legítimo em excesso, seja por uso abusivo ou ataques. Algoritmos comuns incluem token bucket, em que cada requisição consome um "token" de um balde que é reabastecido a uma taxa fixa, permitindo picos curtos de tráfego (rajadas) enquanto limita a taxa média sustentada; e sliding window, que conta requisições dentro de uma janela de tempo que se move continuamente, evitando o problema de picos exatamente na borda entre duas janelas fixas. Quando o limite é excedido, o sistema tipicamente responde com o código HTTP 429 (Too Many Requests), sinalizando ao cliente que ele deve reduzir a taxa de chamadas.',
     3, 'v1', 'rascunho');

-- =====================================================================================
-- FLASHCARDS (3 por Concept)
-- =====================================================================================

INSERT INTO flashcard (domain_ref, concept_ref, frente, verso, dificuldade, content_version, status_revisao)
VALUES
    -- Concept 1
    ((SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'a1000000-0000-4000-8000-000000000001',
     'Qual a diferença entre escalabilidade vertical e horizontal?',
     'Vertical (scale up) aumenta os recursos de uma única máquina (CPU, memória). Horizontal (scale out) adiciona mais máquinas para dividir a carga entre elas.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'a1000000-0000-4000-8000-000000000001',
     'Por que escalabilidade vertical tem um limite físico?',
     'Porque existe um teto de hardware disponível (CPU, memória, disco) para uma única máquina, e o custo cresce de forma não linear ao se aproximar desse teto.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'a1000000-0000-4000-8000-000000000001',
     'Por que serviços stateless são mais fáceis de escalar horizontalmente?',
     'Porque qualquer instância pode atender qualquer requisição sem depender de estado guardado localmente, permitindo adicionar ou remover instâncias livremente.',
     'media', 'v1', 'rascunho'),
    -- Concept 2
    ((SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'a1000000-0000-4000-8000-000000000002',
     'O que é a estratégia de cache "cache-aside"?',
     'A aplicação consulta o cache primeiro; em caso de miss, busca na fonte de dados e grava o resultado no cache para leituras futuras.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'a1000000-0000-4000-8000-000000000002',
     'Qual a diferença entre write-through e write-behind (write-back)?',
     'Write-through escreve simultaneamente no cache e na fonte (mais consistente, mais lento). Write-behind escreve primeiro no cache e propaga para a fonte de forma assíncrona (mais rápido, com risco de perda de dados).',
     'dificil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'a1000000-0000-4000-8000-000000000002',
     'O que é TTL em uma entrada de cache?',
     'Time-to-live: tempo após o qual a entrada expira automaticamente, forçando uma nova busca na fonte e limitando a janela de inconsistência entre cache e origem.',
     'facil', 'v1', 'rascunho'),
    -- Concept 3
    ((SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'a1000000-0000-4000-8000-000000000003',
     'Qual a diferença entre balanceamento L4 e L7?',
     'L4 opera na camada de transporte (IP/porta), é mais rápido e simples. L7 opera na camada de aplicação (conteúdo HTTP, como path/headers), é mais flexível mas com mais overhead.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'a1000000-0000-4000-8000-000000000003',
     'O que faz o algoritmo "least connections" em um load balancer?',
     'Envia a próxima requisição para a instância que possui menos conexões ativas no momento, adaptando-se a cargas desiguais entre instâncias.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'a1000000-0000-4000-8000-000000000003',
     'Para que serve um health check em um load balancer?',
     'Para detectar instâncias com falha e parar de rotear tráfego para elas, contribuindo diretamente para a disponibilidade do sistema.',
     'facil', 'v1', 'rascunho'),
    -- Concept 4
    ((SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'a1000000-0000-4000-8000-000000000004',
     'Qual a diferença entre particionamento (sharding) e replicação?',
     'Particionamento divide os dados em subconjuntos distintos entre nós; replicação mantém cópias completas dos mesmos dados em múltiplos nós.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'a1000000-0000-4000-8000-000000000004',
     'O que é um hot spot em um sistema particionado?',
     'Uma partição que recebe volume de tráfego ou dados desproporcionalmente maior que as demais, anulando o benefício do particionamento ao se tornar o novo gargalo.',
     'dificil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'a1000000-0000-4000-8000-000000000004',
     'O que caracteriza uma boa chave de partição?',
     'Distribui a carga de forma uniforme entre as partições e permite que a maioria das consultas seja resolvida acessando uma única partição.',
     'media', 'v1', 'rascunho'),
    -- Concept 5
    ((SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'a1000000-0000-4000-8000-000000000005',
     'O que é o algoritmo de rate limiting "token bucket"?',
     'Cada requisição consome um token de um balde reabastecido a taxa fixa, permitindo rajadas curtas de tráfego enquanto limita a taxa média sustentada.',
     'dificil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'a1000000-0000-4000-8000-000000000005',
     'Qual código HTTP indica que um cliente excedeu o limite de requisições?',
     '429 (Too Many Requests).',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'a1000000-0000-4000-8000-000000000005',
     'Por que processamento assíncrono reduz a latência percebida pelo usuário?',
     'Porque move trabalho que não precisa bloquear a resposta (ex.: envio de e-mail) para fora do caminho crítico da requisição, permitindo responder ao usuário mais rápido.',
     'media', 'v1', 'rascunho');

-- =====================================================================================
-- QUESTIONS + ALTERNATIVAS (18 questões: 6 fácil, 6 média, 6 difícil)
-- =====================================================================================

-- ---------- FÁCEIS (6) ----------

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('b1000000-0000-4000-8000-000000000001',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000001',
        'Escalar verticalmente (scale up) significa, principalmente:',
        'Escalar verticalmente é aumentar a capacidade de uma única máquina, adicionando mais CPU, memória ou disco, em vez de adicionar novas máquinas.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('b1000000-0000-4000-8000-000000000001', 'Aumentar os recursos (CPU, memória) de uma máquina já existente', true),
    ('b1000000-0000-4000-8000-000000000001', 'Adicionar mais máquinas ao cluster para dividir a carga', false),
    ('b1000000-0000-4000-8000-000000000001', 'Migrar o sistema para uma arquitetura de microsserviços', false),
    ('b1000000-0000-4000-8000-000000000001', 'Reduzir o número de instâncias em execução', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('b1000000-0000-4000-8000-000000000002',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000001',
        'Qual das opções abaixo é uma desvantagem típica de escalar apenas verticalmente?',
        'Escalar apenas verticalmente concentra tudo em uma única máquina, criando um ponto único de falha e um limite físico de hardware que eventualmente se torna caro ou impossível de superar.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('b1000000-0000-4000-8000-000000000002', 'A máquina se torna um ponto único de falha e tem um teto físico de capacidade', true),
    ('b1000000-0000-4000-8000-000000000002', 'Exige balanceamento de carga entre múltiplas instâncias', false),
    ('b1000000-0000-4000-8000-000000000002', 'Torna a aplicação obrigatoriamente stateless', false),
    ('b1000000-0000-4000-8000-000000000002', 'Elimina a necessidade de monitoramento', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('b1000000-0000-4000-8000-000000000003',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000002',
        'Qual é o principal benefício de usar cache em um sistema?',
        'Cache reduz a latência percebida pelo usuário e diminui a carga sobre sistemas de origem, servindo dados já calculados/buscados anteriormente a partir de um armazenamento mais rápido de acessar.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('b1000000-0000-4000-8000-000000000003', 'Reduzir latência e carga sobre o sistema de origem dos dados', true),
    ('b1000000-0000-4000-8000-000000000003', 'Garantir que os dados nunca fiquem desatualizados', false),
    ('b1000000-0000-4000-8000-000000000003', 'Eliminar a necessidade de um banco de dados', false),
    ('b1000000-0000-4000-8000-000000000003', 'Aumentar o tamanho do payload trafegado na rede', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('b1000000-0000-4000-8000-000000000004',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000003',
        'Qual é a função principal de um load balancer?',
        'Um load balancer distribui requisições entre múltiplas instâncias de um serviço, evitando que uma instância fique sobrecarregada enquanto outras ficam ociosas, e tipicamente também remove instâncias com falha do tráfego.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('b1000000-0000-4000-8000-000000000004', 'Distribuir requisições entre múltiplas instâncias de um serviço', true),
    ('b1000000-0000-4000-8000-000000000004', 'Armazenar dados em cache para reduzir latência', false),
    ('b1000000-0000-4000-8000-000000000004', 'Particionar dados entre múltiplos bancos de dados', false),
    ('b1000000-0000-4000-8000-000000000004', 'Comprimir o payload das respostas HTTP', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('b1000000-0000-4000-8000-000000000005',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000004',
        'O que é particionamento (sharding) de dados?',
        'Particionamento é dividir um conjunto de dados em partes menores (shards), cada uma armazenada em um subconjunto diferente de máquinas, permitindo que o sistema cresça além da capacidade de uma única máquina.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('b1000000-0000-4000-8000-000000000005', 'Dividir um conjunto de dados em partes menores distribuídas entre máquinas diferentes', true),
    ('b1000000-0000-4000-8000-000000000005', 'Criar cópias idênticas completas dos dados em múltiplos servidores', false),
    ('b1000000-0000-4000-8000-000000000005', 'Comprimir dados para reduzir espaço em disco', false),
    ('b1000000-0000-4000-8000-000000000005', 'Armazenar dados temporariamente em memória para acesso rápido', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('b1000000-0000-4000-8000-000000000006',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000005',
        'Qual código de status HTTP é tipicamente retornado quando um cliente excede um limite de rate limiting?',
        'O código 429 (Too Many Requests) sinaliza ao cliente que ele excedeu a taxa de requisições permitida e deve reduzir a frequência de chamadas.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('b1000000-0000-4000-8000-000000000006', '429 (Too Many Requests)', true),
    ('b1000000-0000-4000-8000-000000000006', '404 (Not Found)', false),
    ('b1000000-0000-4000-8000-000000000006', '500 (Internal Server Error)', false),
    ('b1000000-0000-4000-8000-000000000006', '301 (Moved Permanently)', false);

-- ---------- MÉDIAS (6) ----------

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('b1000000-0000-4000-8000-000000000007',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000001',
        'Por que serviços de aplicação precisam geralmente ser stateless para escalar horizontalmente com eficácia?',
        'Se o estado (ex.: sessão de usuário) vive apenas na memória de uma instância específica, requisições subsequentes desse usuário precisam necessariamente chegar à mesma instância, o que dificulta ou impede o balanceamento livre de carga entre instâncias.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('b1000000-0000-4000-8000-000000000007', 'Porque qualquer instância precisa poder atender qualquer requisição sem depender de estado local', true),
    ('b1000000-0000-4000-8000-000000000007', 'Porque bancos de dados relacionais não suportam múltiplas instâncias de aplicação', false),
    ('b1000000-0000-4000-8000-000000000007', 'Porque escalabilidade horizontal exige que a aplicação não use cache', false),
    ('b1000000-0000-4000-8000-000000000007', 'Porque instâncias stateless consomem menos CPU que instâncias com estado', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('b1000000-0000-4000-8000-000000000008',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000002',
        'Na estratégia de cache "cache-aside" (lazy loading), o que acontece em caso de cache miss?',
        'Em cache-aside, a aplicação primeiro consulta o cache; se o dado não estiver lá (miss), ela busca na fonte original e grava o resultado no cache para que leituras futuras sejam atendidas diretamente pelo cache.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('b1000000-0000-4000-8000-000000000008', 'A aplicação busca o dado na fonte original e grava o resultado no cache', true),
    ('b1000000-0000-4000-8000-000000000008', 'A requisição é rejeitada até o cache ser reabastecido manualmente', false),
    ('b1000000-0000-4000-8000-000000000008', 'O cache é automaticamente removido de todas as instâncias', false),
    ('b1000000-0000-4000-8000-000000000008', 'A aplicação retorna um erro 429 ao cliente', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('b1000000-0000-4000-8000-000000000009',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000003',
        'O algoritmo de balanceamento "least connections" distribui requisições com base em quê?',
        'Least connections envia a próxima requisição para a instância que possui o menor número de conexões ativas no momento, adaptando-se melhor a cargas desiguais entre requisições do que round-robin.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('b1000000-0000-4000-8000-000000000009', 'No número de conexões ativas que cada instância possui no momento', true),
    ('b1000000-0000-4000-8000-000000000009', 'Na ordem sequencial fixa em que as instâncias foram registradas', false),
    ('b1000000-0000-4000-8000-000000000009', 'No hash do IP de origem da requisição, sempre', false),
    ('b1000000-0000-4000-8000-000000000009', 'No tempo de vida (uptime) de cada instância', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('b1000000-0000-4000-8000-000000000010',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000004',
        'O que diferencia particionamento (sharding) de replicação de dados?',
        'Particionamento divide os dados em subconjuntos distintos entre nós (cada nó tem uma parte diferente dos dados); replicação mantém cópias completas e idênticas dos mesmos dados em múltiplos nós.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('b1000000-0000-4000-8000-000000000010', 'Particionamento divide os dados em subconjuntos distintos; replicação mantém cópias completas dos mesmos dados', true),
    ('b1000000-0000-4000-8000-000000000010', 'Particionamento e replicação são termos sinônimos e resolvem exatamente o mesmo problema', false),
    ('b1000000-0000-4000-8000-000000000010', 'Replicação só é usada para escrita; particionamento só é usado para leitura', false),
    ('b1000000-0000-4000-8000-000000000010', 'Particionamento elimina a necessidade de balanceamento de carga', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('b1000000-0000-4000-8000-000000000011',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000005',
        'Aumentar throughput agrupando requisições em lotes (batching) tipicamente tem qual efeito sobre a latência individual?',
        'Batching aumenta o throughput total (mais itens processados por unidade de tempo), mas geralmente aumenta a latência de cada item individual, já que ele precisa esperar o lote se formar antes de ser processado.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('b1000000-0000-4000-8000-000000000011', 'Geralmente aumenta a latência individual de cada requisição dentro do lote', true),
    ('b1000000-0000-4000-8000-000000000011', 'Sempre reduz a latência individual de cada requisição', false),
    ('b1000000-0000-4000-8000-000000000011', 'Não tem nenhuma relação com latência, apenas com uso de disco', false),
    ('b1000000-0000-4000-8000-000000000011', 'Elimina completamente a necessidade de rate limiting', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('b1000000-0000-4000-8000-000000000012',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000005',
        'Qual o benefício de usar connection pooling ao acessar um banco de dados a partir da aplicação?',
        'Connection pooling reutiliza conexões já estabelecidas em vez de abrir e fechar uma nova conexão a cada requisição, evitando o custo repetido de handshake e reduzindo a latência das operações.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('b1000000-0000-4000-8000-000000000012', 'Evita o custo de abrir e fechar uma nova conexão a cada requisição', true),
    ('b1000000-0000-4000-8000-000000000012', 'Garante que os dados nunca fiquem desatualizados no cache', false),
    ('b1000000-0000-4000-8000-000000000012', 'Elimina a necessidade de índices no banco de dados', false),
    ('b1000000-0000-4000-8000-000000000012', 'Substitui a necessidade de um load balancer', false);

-- ---------- DIFÍCEIS (6) ----------

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('b1000000-0000-4000-8000-000000000013',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000001',
        'Em um sistema que já escala horizontalmente a camada de aplicação, por que a escrita em um banco de dados relacional único ainda costuma ser o gargalo mais difícil de resolver?',
        'Réplicas de leitura escalam bem a leitura, mas todas as escritas continuam indo para um único nó primário; escalar escrita exige particionar os dados (sharding), o que introduz complexidade adicional de roteamento e consistência entre partições.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('b1000000-0000-4000-8000-000000000013', 'Porque réplicas de leitura escalam a leitura, mas escritas continuam concentradas em um único nó primário, exigindo particionamento para escalar', true),
    ('b1000000-0000-4000-8000-000000000013', 'Porque bancos relacionais não suportam réplicas de nenhum tipo', false),
    ('b1000000-0000-4000-8000-000000000013', 'Porque escrever em disco é sempre mais lento que ler em qualquer banco de dados', false),
    ('b1000000-0000-4000-8000-000000000013', 'Porque aplicações stateless não conseguem se conectar a bancos de dados relacionais', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('b1000000-0000-4000-8000-000000000014',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000002',
        'Qual é o principal risco da estratégia de cache "write-behind" (write-back) em comparação com "write-through"?',
        'Em write-behind, a escrita é confirmada no cache antes de ser propagada de forma assíncrona para a fonte; se o cache falhar antes dessa propagação, os dados ainda não persistidos na fonte são perdidos — um risco que write-through, por escrever nos dois lugares de forma síncrona, não tem.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('b1000000-0000-4000-8000-000000000014', 'Risco de perda de dados se o cache falhar antes de propagar a escrita para a fonte', true),
    ('b1000000-0000-4000-8000-000000000014', 'Latência de escrita maior que em write-through', false),
    ('b1000000-0000-4000-8000-000000000014', 'Impossibilidade de usar TTL nas entradas do cache', false),
    ('b1000000-0000-4000-8000-000000000014', 'Necessidade obrigatória de um load balancer L7', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('b1000000-0000-4000-8000-000000000015',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000003',
        'Por que um sistema pode usar hashing consistente em vez de round-robin em seu balanceamento de carga, mesmo sabendo que round-robin distribui a carga de forma mais uniforme?',
        'Hashing consistente garante que a mesma chave (ex.: ID do cliente) sempre seja roteada para a mesma instância, o que é necessário para sticky sessions ou para maximizar o acerto de um cache local por instância — um benefício que compensa a distribuição potencialmente menos uniforme.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('b1000000-0000-4000-8000-000000000015', 'Para garantir que a mesma chave sempre seja roteada para a mesma instância (afinidade de sessão ou cache local)', true),
    ('b1000000-0000-4000-8000-000000000015', 'Porque hashing consistente é sempre mais rápido de calcular que round-robin', false),
    ('b1000000-0000-4000-8000-000000000015', 'Porque round-robin não funciona em balanceadores de camada 7', false),
    ('b1000000-0000-4000-8000-000000000015', 'Porque hashing consistente elimina a necessidade de health checks', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('b1000000-0000-4000-8000-000000000016',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000004',
        'Um sistema particiona seus dados por ID de usuário, mas uma pequena conta corporativa gera volume de tráfego muito acima da média dos demais usuários, sobrecarregando a partição que a contém. Que problema é esse e qual mitigação é mais direta?',
        'Esse é um hot spot: uma partição recebendo carga desproporcional. Uma mitigação direta é dividir a chave "quente" em subchaves artificiais, espalhando o tráfego dessa conta específica entre múltiplas partições em vez de concentrá-lo em uma só.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('b1000000-0000-4000-8000-000000000016', 'É um hot spot; uma mitigação é dividir a chave quente em subchaves artificiais distribuídas entre partições', true),
    ('b1000000-0000-4000-8000-000000000016', 'É uma falha de replicação; a mitigação é desativar o particionamento completamente', false),
    ('b1000000-0000-4000-8000-000000000016', 'É um problema de cache invalidation; a mitigação é reduzir o TTL do cache', false),
    ('b1000000-0000-4000-8000-000000000016', 'É um problema de rate limiting; a mitigação é bloquear a conta corporativa', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('b1000000-0000-4000-8000-000000000017',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000005',
        'Por que o algoritmo de rate limiting "sliding window" é geralmente preferido a uma janela fixa simples para evitar picos de tráfego na borda entre janelas?',
        'Em janela fixa, um cliente pode enviar o limite máximo de requisições no fim de uma janela e novamente o máximo logo no início da janela seguinte, gerando um pico de até o dobro do limite em um curto intervalo. Sliding window conta requisições em uma janela que se move continuamente, evitando essa concentração exatamente na transição entre janelas.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('b1000000-0000-4000-8000-000000000017', 'Porque janela fixa permite um pico de até o dobro do limite exatamente na transição entre duas janelas consecutivas', true),
    ('b1000000-0000-4000-8000-000000000017', 'Porque sliding window não exige nenhum armazenamento de estado sobre requisições anteriores', false),
    ('b1000000-0000-4000-8000-000000000017', 'Porque janela fixa só pode ser implementada em balanceadores de camada 4', false),
    ('b1000000-0000-4000-8000-000000000017', 'Porque sliding window elimina completamente a necessidade de retornar o código 429', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('b1000000-0000-4000-8000-000000000018',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000002',
        'Um sistema usa TTL curto para invalidar cache de forma simples, mas percebe alta carga no banco de origem porque muitas chaves expiram ao mesmo tempo, gerando um pico simultâneo de cache misses (cache stampede). Qual das opções melhor descreve uma forma de mitigar esse problema?',
        'Cache stampede acontece quando muitas chaves expiram juntas e todas as requisições correspondentes vão simultaneamente buscar a mesma informação na fonte de origem. Mitigações comuns incluem "jitter" (variar levemente o TTL de cada entrada para não expirarem todas no mesmo instante) e mecanismos de lock/recomputação única, em que apenas uma requisição recalcula o valor enquanto as demais aguardam ou recebem o valor antigo temporariamente.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('b1000000-0000-4000-8000-000000000018', 'Adicionar variação (jitter) ao TTL das entradas para evitar que todas expirem no mesmo instante', true),
    ('b1000000-0000-4000-8000-000000000018', 'Aumentar o número de réplicas de leitura do balanceador de carga', false),
    ('b1000000-0000-4000-8000-000000000018', 'Reduzir o número de alternativas por questão de 4 para 3', false),
    ('b1000000-0000-4000-8000-000000000018', 'Trocar o algoritmo de particionamento de hash para round-robin', false);
