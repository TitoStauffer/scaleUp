-- Seed de conteúdo do domínio Sistemas Distribuídos (Backend Engineer).
-- Rascunho de conteúdo autorado por IA, conforme TICKET-content-database.md e
-- TICKET-content-sistemas-distribuidos.md: content_version = 'v1', status_revisao =
-- 'rascunho' em todas as linhas. Este arquivo nunca insere em domain — apenas referencia
-- o domínio já semeado por V13 via subquery em domain.slug.
--
-- 5 Concepts, 15 Slides (3 por Concept), 15 Flashcards, 18 Questions (6 fácil/6 média/6
-- difícil) com 4 alternativas cada (72 alternativas), todas inseridas nesta mesma
-- transação de migração, conforme exigido pelo trigger adiado de V6.

-- ============================================================================
-- CONCEPTS
-- ============================================================================

INSERT INTO concept (id, domain_ref, titulo, resumo, content_version, status_revisao)
VALUES
    ('b1a1c1a0-0001-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'CAP Theorem e trade-offs de consistência',
     'O CAP theorem afirma que, na presença de uma partição de rede, um sistema distribuído precisa escolher entre consistência e disponibilidade. Este conceito cobre as definições formais de Consistency, Availability e Partition Tolerance, por que partição não é opcional em sistemas reais, e como sistemas concretos se posicionam nesse espaço de trade-offs.',
     'v1', 'rascunho'),
    ('b1a1c1a0-0002-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Replicação e modelos de consistência',
     'Replicar dados entre nós melhora disponibilidade e latência de leitura, mas introduz a pergunta de quão consistentes as réplicas precisam estar entre si. Este conceito cobre replicação síncrona vs. assíncrona, consistência forte, eventual e causal, e os problemas práticos de leituras obsoletas (stale reads).',
     'v1', 'rascunho'),
    ('b1a1c1a0-0003-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Consenso distribuído: Paxos e Raft',
     'Fazer um conjunto de nós concordar sobre um valor ou uma ordem de operações, mesmo com falhas, é o problema de consenso. Este conceito cobre por que consenso é necessário, as garantias que algoritmos como Paxos e Raft oferecem, e os conceitos de líder, termo/eleição e log replicado.',
     'v1', 'rascunho'),
    ('b1a1c1a0-0004-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Particionamento e sharding de dados',
     'Quando os dados não cabem (ou não performam bem) em uma única máquina, eles são divididos em partições distribuídas entre nós. Este conceito cobre estratégias de particionamento (por hash, por range), rebalanceamento, hotspots e o papel do consistent hashing.',
     'v1', 'rascunho'),
    ('b1a1c1a0-0005-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Relógios lógicos, ordenação de eventos e tolerância a falhas',
     'Sem um relógio global confiável, sistemas distribuídos precisam de mecanismos próprios para ordenar eventos causalmente relacionados e para detectar e conviver com falhas de nós e de rede. Este conceito cobre relógios de Lamport, vector clocks, detecção de falhas e padrões básicos de tolerância a falhas.',
     'v1', 'rascunho')
ON CONFLICT (domain_ref, titulo) DO NOTHING;

-- ============================================================================
-- SLIDES (3 por Concept, ordem sequencial 1..3)
-- ============================================================================

INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    -- Concept 1: CAP Theorem
    ('b1a1c1a0-0001-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'O que o CAP theorem realmente diz',
     'O CAP theorem, formalizado por Eric Brewer e provado por Gilbert e Lynch, afirma que um sistema distribuído não pode garantir simultaneamente as três propriedades a seguir: Consistency (toda leitura recebe a escrita mais recente ou um erro), Availability (toda requisição recebe uma resposta, sem garantia de que seja a mais recente) e Partition Tolerance (o sistema continua operando mesmo quando mensagens entre nós são perdidas ou atrasadas). Um erro comum é interpretar isso como "escolha 2 de 3" o tempo todo — na prática, partições de rede eventualmente acontecem em qualquer sistema real com mais de um nó, então a escolha relevante é: quando uma partição ocorre, o sistema sacrifica C ou A. Fora de uma partição, é possível ter tanto consistência quanto disponibilidade.',
     1, 'v1', 'rascunho'),
    ('b1a1c1a0-0001-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Partição de rede não é opcional',
     'Em um sistema com um único nó, partição de rede não existe como conceito. Já em qualquer sistema com múltiplos nós comunicando-se por rede, falhas de rede (pacotes perdidos, latência alta, links caindo) são inevitáveis em escala real — não é uma questão de "se", mas de "quando". Por isso, na prática, a escolha do CAP theorem se resume a CP vs. AP: durante uma partição, o sistema recusa operações para preservar consistência (CP) ou aceita operações mesmo arriscando inconsistência temporária, para preservar disponibilidade (AP). Sistemas como bancos relacionais configurados para consistência forte tendem a CP; bancos como Cassandra, por padrão, tendem a AP.',
     2, 'v1', 'rascunho'),
    ('b1a1c1a0-0001-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Exemplo prático: CP vs. AP em um carrinho de compras',
     'Imagine um e-commerce com nós de banco em duas regiões, e a rede entre elas cai por 30 segundos. Em um sistema CP, o nó que não consegue confirmar com a maioria dos outros nós recusa escritas no carrinho até a rede voltar — o cliente vê um erro momentâneo, mas nunca um estado inconsistente. Em um sistema AP, cada nó aceita a escrita local mesmo isolado, e depois reconcilia os dados quando a rede volta (por exemplo, mesclando itens de dois carrinhos divergentes) — o cliente nunca vê erro, mas pode ver, por um tempo, um carrinho desatualizado. Nenhuma escolha é "errada" — depende se o negócio tolera melhor um erro visível ou uma inconsistência temporária invisível.',
     3, 'v1', 'rascunho'),

    -- Concept 2: Replicação e consistência
    ('b1a1c1a0-0002-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Por que replicar dados',
     'Replicação é manter cópias dos mesmos dados em múltiplos nós, geralmente em máquinas ou regiões diferentes. Os motivos principais são: disponibilidade (se um nó cai, outro responde), redução de latência de leitura (servir dados de uma réplica geograficamente próxima do cliente) e capacidade de leitura (distribuir requisições de leitura entre várias réplicas). O custo é a complexidade de manter as réplicas sincronizadas: toda escrita precisa, em algum momento, se propagar para as outras cópias, e a forma como isso acontece define o modelo de consistência do sistema.',
     1, 'v1', 'rascunho'),
    ('b1a1c1a0-0002-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Replicação síncrona vs. assíncrona',
     'Na replicação síncrona, o nó primário só confirma a escrita ao cliente depois que uma ou mais réplicas confirmarem que também gravaram os dados — isso garante que uma réplica promovida a primária após uma falha nunca perderá aquela escrita, mas aumenta a latência percebida pelo cliente e reduz a disponibilidade de escrita (se as réplicas necessárias estiverem indisponíveis, a escrita falha). Na replicação assíncrona, o primário confirma a escrita imediatamente e propaga para as réplicas em segundo plano — menor latência e maior disponibilidade, mas risco real de perda de dados se o primário falhar antes de propagar uma escrita já confirmada ao cliente.',
     2, 'v1', 'rascunho'),
    ('b1a1c1a0-0002-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Consistência forte, eventual e causal',
     'Consistência forte garante que, após uma escrita confirmada, qualquer leitura subsequente (em qualquer nó) retorna esse valor — é a garantia mais fácil de raciocinar, mas a mais cara em latência e disponibilidade. Consistência eventual garante apenas que, se nenhuma nova escrita ocorrer, todas as réplicas eventualmente convergem para o mesmo valor — é barata e disponível, mas permite leituras obsoletas (stale reads) por um período indeterminado. Consistência causal fica no meio: garante que operações causalmente relacionadas (por exemplo, uma resposta a um comentário) sejam vistas na ordem correta por todos, mesmo que operações não relacionadas possam aparecer em ordens diferentes para observadores diferentes.',
     3, 'v1', 'rascunho'),

    -- Concept 3: Consenso (Paxos/Raft)
    ('b1a1c1a0-0003-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'O problema do consenso distribuído',
     'Consenso é o problema de fazer um conjunto de nós concordarem sobre um único valor (ou uma sequência de valores/operações), mesmo quando alguns nós falham ou mensagens se perdem. É a base de mecanismos como eleição de líder, bancos de dados replicados de forma forte e sistemas de coordenação (como locks distribuídos). Um algoritmo de consenso correto precisa garantir, ao mesmo tempo, safety (nunca dois nós decidem valores diferentes para a mesma posição) e liveness (o sistema eventualmente decide um valor, dado tempo suficiente sem falhas).',
     1, 'v1', 'rascunho'),
    ('b1a1c1a0-0003-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Paxos: o algoritmo clássico e sua fama de complexidade',
     'Paxos, proposto por Leslie Lamport, foi o primeiro algoritmo de consenso amplamente aceito como correto e tolerante a falhas, desde que menos da metade dos nós falhe (tolera até f falhas em um cluster de 2f+1 nós). Ele funciona em duas fases (prepare/promise e accept/accepted), nas quais um proposer precisa obter aceitação de uma maioria (quorum) de acceptors antes de um valor ser considerado decidido. Paxos é reconhecidamente difícil de entender e de implementar corretamente na prática — essa dificuldade foi a motivação direta para a criação do Raft.',
     2, 'v1', 'rascunho'),
    ('b1a1c1a0-0003-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Raft: consenso pensado para ser compreensível',
     'Raft decompõe o problema de consenso em três sub-problemas mais fáceis de entender separadamente: eleição de líder (os nós elegem um líder por meio de votação, usando "termos" numerados para detectar líderes desatualizados), replicação de log (o líder recebe comandos do cliente, os anexa ao seu log e os replica para os seguidores, considerando um comando confirmado quando a maioria replica) e segurança (garante que um nó só se torna líder se tiver o log mais atualizado, evitando perda de operações já confirmadas). Como Paxos, Raft exige quorum (maioria) para progredir, e por isso tolera até f falhas em um cluster de 2f+1 nós. Etcd e Consul usam Raft internamente.',
     3, 'v1', 'rascunho'),

    -- Concept 4: Particionamento/sharding
    ('b1a1c1a0-0004-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Por que particionar (sharding) os dados',
     'Particionamento (sharding) é dividir um conjunto de dados em subconjuntos menores (partições/shards), cada um armazenado em um nó diferente. É necessário quando o volume de dados ou de requisições excede o que uma única máquina consegue armazenar ou processar com desempenho aceitável — diferente de replicação, que copia os mesmos dados em vários nós, sharding distribui dados diferentes em nós diferentes. Os dois são frequentemente combinados: cada shard, por sua vez, é replicado para tolerância a falhas.',
     1, 'v1', 'rascunho'),
    ('b1a1c1a0-0004-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Particionamento por hash vs. por range',
     'No particionamento por hash, uma função de hash é aplicada à chave do dado para decidir a qual partição ele pertence — isso distribui a carga de forma bastante uniforme, mas dificulta consultas por intervalo (range queries), já que chaves próximas podem cair em partições diferentes. No particionamento por range, os dados são divididos em faixas contíguas de chaves (ex.: usuários A-M em uma partição, N-Z em outra) — isso facilita range queries e varreduras ordenadas, mas cria risco de hotspots, quando uma faixa específica recebe desproporcionalmente mais tráfego ou dados que as demais.',
     2, 'v1', 'rascunho'),
    ('b1a1c1a0-0004-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Consistent hashing e rebalanceamento',
     'Um problema do hashing simples (ex.: hash(chave) % número_de_nós) é que adicionar ou remover um nó muda o resultado do módulo para quase todas as chaves, forçando uma movimentação massiva de dados. Consistent hashing resolve isso mapeando tanto nós quanto chaves para posições em um anel de hash: cada chave pertence ao primeiro nó encontrado no sentido horário do anel. Adicionar ou remover um nó afeta apenas as chaves adjacentes a ele no anel, minimizando o volume de dados movidos durante o rebalanceamento — técnica usada por sistemas como Cassandra e DynamoDB.',
     3, 'v1', 'rascunho'),

    -- Concept 5: Relógios lógicos / tolerância a falhas
    ('b1a1c1a0-0005-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Por que relógios físicos não bastam',
     'Em uma única máquina, o relógio do sistema operacional é suficiente para ordenar eventos. Em um sistema distribuído, cada nó tem seu próprio relógio físico, e mesmo com sincronização via NTP existe drift (desvio) e latência de rede variável — dois nós podem discordar sobre "o que aconteceu primeiro" caso confiem apenas em timestamps de relógio físico (wall-clock). Isso é especialmente perigoso para decidir qual de duas escritas concorrentes é "mais recente": basear essa decisão só em wall-clock pode levar a perda silenciosa de dados. Por isso, sistemas distribuídos frequentemente usam relógios lógicos, que capturam ordem causal em vez de tempo real.',
     1, 'v1', 'rascunho'),
    ('b1a1c1a0-0005-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Relógios de Lamport e vector clocks',
     'O relógio de Lamport atribui um contador inteiro a cada evento: a cada operação local o contador é incrementado, e ao receber uma mensagem o nó atualiza seu contador para max(contador_local, contador_recebido) + 1. Isso garante que, se o evento A causou o evento B, o contador de A é menor que o de B — mas não garante a recíproca (contadores iguais ou ordenados não implicam causalidade). Vector clocks resolvem essa limitação: cada nó mantém um vetor de contadores, um por nó do sistema, permitindo determinar com precisão se dois eventos são causalmente relacionados ou concorrentes (aconteceram sem que um soubesse do outro) — ao custo de um vetor que cresce com o número de nós.',
     2, 'v1', 'rascunho'),
    ('b1a1c1a0-0005-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Detecção de falhas e tolerância básica',
     'Como não é possível distinguir com certeza, pela rede, um nó lento de um nó morto (o problema fundamental por trás do teorema FLP, que prova ser impossível garantir consenso determinístico em um sistema assíncrono com até uma falha), sistemas reais usam heurísticas: heartbeats periódicos e timeouts para suspeitar de falha, geralmente combinados com detectores de falha "phi accrual" que ajustam o timeout dinamicamente conforme a variação histórica de latência da rede. A partir dessa suspeita, mecanismos de tolerância a falhas entram em ação: failover para uma réplica saudável, nova eleição de líder (em sistemas baseados em Raft/Paxos) ou isolamento temporário do nó suspeito até que ele prove estar de volta.',
     3, 'v1', 'rascunho')
ON CONFLICT (concept_ref, ordem) DO NOTHING;

-- ============================================================================
-- FLASHCARDS (15, ~3 por Concept)
-- ============================================================================

INSERT INTO flashcard (domain_ref, concept_ref, frente, verso, dificuldade, content_version, status_revisao)
VALUES
    ((SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'b1a1c1a0-0001-4000-8000-000000000001',
     'O que significa o "P" no CAP theorem?',
     'Partition Tolerance: a capacidade do sistema de continuar operando mesmo quando mensagens entre nós são perdidas ou atrasadas por uma falha de rede.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'b1a1c1a0-0001-4000-8000-000000000001',
     'Por que "escolha 2 de 3" é uma simplificação enganosa do CAP theorem?',
     'Porque partição de rede não é opcional em sistemas distribuídos reais — ela eventualmente acontece. Na prática, a escolha relevante é entre C e A durante uma partição, não uma escolha livre entre as três propriedades o tempo todo.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'b1a1c1a0-0001-4000-8000-000000000001',
     'Um sistema CP faz o quê durante uma partição de rede?',
     'Recusa (ou atrasa) operações que não conseguem ser confirmadas com garantia de consistência, sacrificando disponibilidade para nunca retornar um dado desatualizado ou inconsistente.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'b1a1c1a0-0002-4000-8000-000000000002',
     'Qual a principal desvantagem da replicação síncrona?',
     'Maior latência de escrita (é preciso esperar a confirmação de réplicas) e menor disponibilidade de escrita, já que a operação falha se as réplicas exigidas estiverem indisponíveis.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'b1a1c1a0-0002-4000-8000-000000000002',
     'O que é um "stale read" (leitura obsoleta)?',
     'Uma leitura que retorna um valor desatualizado porque foi servida por uma réplica que ainda não recebeu a propagação da escrita mais recente.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'b1a1c1a0-0002-4000-8000-000000000002',
     'O que consistência causal garante que consistência eventual, sozinha, não garante?',
     'Que operações causalmente relacionadas (ex.: uma resposta a um comentário) sejam vistas na ordem correta por todos os observadores, mesmo que operações não relacionadas possam ser vistas em ordens diferentes.',
     'dificil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'b1a1c1a0-0003-4000-8000-000000000003',
     'Quantas falhas um cluster de consenso com 2f+1 nós tolera (Paxos ou Raft)?',
     'Até f falhas, desde que uma maioria (quorum) de nós continue disponível e se comunicando.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'b1a1c1a0-0003-4000-8000-000000000003',
     'Qual foi a principal motivação para a criação do Raft?',
     'Tornar o consenso distribuído mais fácil de entender e implementar corretamente, decompondo o problema em eleição de líder, replicação de log e segurança — em contraste com a complexidade reconhecida do Paxos clássico.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'b1a1c1a0-0003-4000-8000-000000000003',
     'No Raft, o que impede um nó com log desatualizado de se tornar líder?',
     'A regra de segurança do algoritmo: um candidato só recebe voto de um nó se seu log for pelo menos tão atualizado quanto o do votante, garantindo que o novo líder sempre tenha todas as operações já confirmadas.',
     'dificil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'b1a1c1a0-0004-4000-8000-000000000004',
     'Qual a diferença fundamental entre sharding e replicação?',
     'Sharding distribui dados diferentes entre nós diferentes (cada nó tem uma parte do total); replicação copia os mesmos dados em múltiplos nós (cada nó tem uma cópia completa daquele subconjunto).',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'b1a1c1a0-0004-4000-8000-000000000004',
     'Por que particionamento por range facilita range queries mas cria risco de hotspot?',
     'Porque chaves próximas ficam na mesma partição, o que ajuda buscas por intervalo, mas também concentra tráfego ou volume de dados desproporcional em uma única partição quando o acesso não é uniforme entre as faixas.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'b1a1c1a0-0004-4000-8000-000000000004',
     'Qual problema do hashing simples (hash % N nós) o consistent hashing resolve?',
     'Evita que adicionar ou remover um nó force a movimentação de quase todas as chaves — no consistent hashing, apenas as chaves adjacentes ao nó alterado no anel de hash precisam ser remapeadas.',
     'dificil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'b1a1c1a0-0005-4000-8000-000000000005',
     'Por que confiar apenas em wall-clock (relógio físico) para ordenar eventos distribuídos é arriscado?',
     'Porque relógios físicos em nós diferentes sofrem drift e latência de rede variável, podendo levar dois nós a discordar sobre qual evento aconteceu primeiro — o que é perigoso ao decidir qual de duas escritas concorrentes deve prevalecer.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'b1a1c1a0-0005-4000-8000-000000000005',
     'O que um vector clock permite determinar que um relógio de Lamport simples não permite?',
     'Se dois eventos são causalmente relacionados ou concorrentes (aconteceram sem que um nó soubesse do outro) — o relógio de Lamport garante ordenação causal em uma direção, mas não permite essa distinção com certeza.',
     'dificil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'b1a1c1a0-0005-4000-8000-000000000005',
     'Por que é impossível, pela rede, distinguir com certeza um nó lento de um nó morto?',
     'Porque a única informação disponível é a ausência de resposta dentro de um tempo esperado, que pode ser causada tanto por um nó realmente falho quanto por um nó vivo porém lento ou por uma mensagem atrasada na rede — por isso sistemas usam heurísticas como heartbeats e timeouts, não certeza absoluta.',
     'facil', 'v1', 'rascunho')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- QUESTIONS + ALTERNATIVAS (18: 6 fácil, 6 média, 6 difícil)
-- ============================================================================

-- Q1 (facil)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0001-4000-8000-000000000001',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0001-4000-8000-000000000001',
    'De acordo com o CAP theorem, o que uma escolha "AP" (Availability + Partition Tolerance) implica durante uma partição de rede?',
    'Em AP, o sistema continua respondendo requisições mesmo durante a partição, aceitando o risco de retornar dados desatualizados ou de divergir temporariamente entre nós, já que não é possível confirmar consistência forte sem comunicação com os demais nós.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0001-4000-8000-000000000001', 'O sistema continua respondendo requisições, mesmo com risco de dados desatualizados ou divergentes.', true),
    ('c2a2c2a0-0001-4000-8000-000000000001', 'O sistema recusa todas as requisições até a partição ser resolvida.', false),
    ('c2a2c2a0-0001-4000-8000-000000000001', 'O sistema garante consistência forte ignorando a partição.', false),
    ('c2a2c2a0-0001-4000-8000-000000000001', 'O sistema desliga automaticamente os nós isolados.', false);

-- Q2 (facil)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0002-4000-8000-000000000002',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0002-4000-8000-000000000002',
    'Qual é a principal vantagem da replicação assíncrona em relação à síncrona?',
    'Na replicação assíncrona, o nó primário confirma a escrita ao cliente sem esperar a confirmação das réplicas, o que reduz a latência percebida e aumenta a disponibilidade de escrita — ao custo de risco de perda de dados se o primário falhar antes de propagar a escrita.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0002-4000-8000-000000000002', 'Menor latência de escrita e maior disponibilidade, com risco de perda de dados em caso de falha do primário.', true),
    ('c2a2c2a0-0002-4000-8000-000000000002', 'Garante que nenhuma escrita confirmada seja perdida, mesmo com falha do primário.', false),
    ('c2a2c2a0-0002-4000-8000-000000000002', 'Elimina completamente a possibilidade de leituras obsoletas.', false),
    ('c2a2c2a0-0002-4000-8000-000000000002', 'Torna desnecessário ter mais de uma réplica.', false);

-- Q3 (facil)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0003-4000-8000-000000000003',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0003-4000-8000-000000000003',
    'O que é "quorum" no contexto de algoritmos de consenso como Paxos e Raft?',
    'Quorum é o número mínimo de nós (tipicamente uma maioria) que precisa concordar para que uma decisão (eleição de líder, confirmação de escrita) seja considerada válida, garantindo que duas decisões conflitantes não possam ser tomadas simultaneamente por conjuntos disjuntos de nós.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0003-4000-8000-000000000003', 'O número mínimo de nós que precisa concordar para uma decisão ser considerada válida.', true),
    ('c2a2c2a0-0003-4000-8000-000000000003', 'O nó designado permanentemente como líder do cluster.', false),
    ('c2a2c2a0-0003-4000-8000-000000000003', 'O tempo máximo de espera antes de declarar um nó como falho.', false),
    ('c2a2c2a0-0003-4000-8000-000000000003', 'O número total de réplicas dos dados no sistema.', false);

-- Q4 (facil)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0004-4000-8000-000000000004',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0004-4000-8000-000000000004',
    'Qual a diferença essencial entre sharding e replicação?',
    'Sharding divide dados diferentes entre nós diferentes (cada shard contém uma parte do total), enquanto replicação mantém cópias completas dos mesmos dados em múltiplos nós. As duas técnicas são frequentemente combinadas.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0004-4000-8000-000000000004', 'Sharding distribui dados diferentes entre nós; replicação copia os mesmos dados em vários nós.', true),
    ('c2a2c2a0-0004-4000-8000-000000000004', 'Sharding e replicação são termos sinônimos para a mesma técnica.', false),
    ('c2a2c2a0-0004-4000-8000-000000000004', 'Replicação divide dados diferentes entre nós; sharding copia os mesmos dados.', false),
    ('c2a2c2a0-0004-4000-8000-000000000004', 'Sharding só pode ser aplicado a bancos não relacionais.', false);

-- Q5 (facil)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0005-4000-8000-000000000005',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0005-4000-8000-000000000005',
    'Por que sistemas distribuídos costumam usar heartbeats e timeouts para detectar falhas de nós?',
    'Porque não é possível, apenas observando a rede, distinguir com certeza um nó lento de um nó morto: a única evidência disponível é a ausência de resposta dentro de um tempo esperado, então o sistema usa heurísticas em vez de detecção determinística.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0005-4000-8000-000000000005', 'Porque não é possível distinguir com certeza, pela rede, um nó lento de um nó morto.', true),
    ('c2a2c2a0-0005-4000-8000-000000000005', 'Porque relógios físicos entre nós são sempre perfeitamente sincronizados.', false),
    ('c2a2c2a0-0005-4000-8000-000000000005', 'Porque heartbeats eliminam totalmente a necessidade de replicação.', false),
    ('c2a2c2a0-0005-4000-8000-000000000005', 'Porque é uma exigência do protocolo TCP.', false);

-- Q6 (facil)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0006-4000-8000-000000000006',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0002-4000-8000-000000000002',
    'O que caracteriza consistência eventual?',
    'Consistência eventual garante apenas que, se nenhuma nova escrita ocorrer, todas as réplicas eventualmente convergem para o mesmo valor — não há garantia de quando isso acontece, e leituras podem retornar dados desatualizados nesse meio-tempo.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0006-4000-8000-000000000006', 'Réplicas convergem para o mesmo valor eventualmente, se não houver novas escritas, sem prazo garantido.', true),
    ('c2a2c2a0-0006-4000-8000-000000000006', 'Toda leitura sempre retorna o valor mais recente, sem exceção.', false),
    ('c2a2c2a0-0006-4000-8000-000000000006', 'As réplicas nunca precisam se comunicar entre si.', false),
    ('c2a2c2a0-0006-4000-8000-000000000006', 'É uma garantia mais forte que consistência forte.', false);

-- Q7 (media)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0007-4000-8000-000000000007',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0001-4000-8000-000000000001',
    'Por que a interpretação "escolha 2 de 3 propriedades do CAP" é considerada uma simplificação enganosa?',
    'Partição de rede não é uma escolha do arquiteto — ela eventualmente acontece em qualquer sistema distribuído real com mais de um nó. Por isso, na prática, C e A só entram em conflito real durante uma partição; fora dela, um sistema bem projetado pode oferecer tanto consistência quanto disponibilidade.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0007-4000-8000-000000000007', 'Porque partição de rede é inevitável em sistemas reais, então a escolha efetiva é entre C e A apenas durante a partição.', true),
    ('c2a2c2a0-0007-4000-8000-000000000007', 'Porque na verdade é sempre possível ter C, A e P simultaneamente.', false),
    ('c2a2c2a0-0007-4000-8000-000000000007', 'Porque o CAP theorem se aplica apenas a bancos de dados relacionais.', false),
    ('c2a2c2a0-0007-4000-8000-000000000007', 'Porque P é uma propriedade opcional que pode ser desativada em produção.', false);

-- Q8 (media)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0008-4000-8000-000000000008',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0002-4000-8000-000000000002',
    'O que diferencia consistência causal de consistência eventual pura?',
    'Consistência causal garante que operações causalmente relacionadas sejam vistas na mesma ordem por todos os observadores (ex.: uma resposta nunca aparece antes do comentário original), enquanto consistência eventual pura não oferece nenhuma garantia de ordem, apenas de convergência final.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0008-4000-8000-000000000008', 'Consistência causal preserva a ordem de eventos causalmente relacionados; consistência eventual pura não garante ordem alguma.', true),
    ('c2a2c2a0-0008-4000-8000-000000000008', 'Consistência causal é estritamente mais fraca que consistência eventual.', false),
    ('c2a2c2a0-0008-4000-8000-000000000008', 'Não há diferença prática entre os dois modelos.', false),
    ('c2a2c2a0-0008-4000-8000-000000000008', 'Consistência causal exige replicação síncrona obrigatoriamente.', false);

-- Q9 (media)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0009-4000-8000-000000000009',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0003-4000-8000-000000000003',
    'Em um cluster Raft de 5 nós, quantas falhas simultâneas o sistema tolera sem perder a capacidade de eleger um líder e progredir?',
    'Um cluster de 2f+1 nós tolera até f falhas mantendo quorum. Com 5 nós (2f+1=5, logo f=2), o sistema tolera até 2 falhas simultâneas — com 3 nós saudáveis ainda é possível formar maioria.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0009-4000-8000-000000000009', '2 falhas', true),
    ('c2a2c2a0-0009-4000-8000-000000000009', '4 falhas', false),
    ('c2a2c2a0-0009-4000-8000-000000000009', '1 falha', false),
    ('c2a2c2a0-0009-4000-8000-000000000009', '5 falhas', false);

-- Q10 (media)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0010-4000-8000-000000000010',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0004-4000-8000-000000000004',
    'Qual é a principal desvantagem do particionamento por range em comparação ao particionamento por hash?',
    'O particionamento por range facilita consultas por intervalo, mas cria risco de hotspots: se o padrão de acesso não for uniforme entre as faixas de chave, uma partição específica pode receber tráfego ou volume de dados desproporcional, enquanto outras ficam ociosas.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0010-4000-8000-000000000010', 'Maior risco de hotspots, já que faixas de chaves podem receber carga desproporcional.', true),
    ('c2a2c2a0-0010-4000-8000-000000000010', 'Impossibilidade total de realizar consultas por intervalo.', false),
    ('c2a2c2a0-0010-4000-8000-000000000010', 'Exige obrigatoriamente um algoritmo de consenso para funcionar.', false),
    ('c2a2c2a0-0010-4000-8000-000000000010', 'Não pode ser combinado com replicação.', false);

-- Q11 (media)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0011-4000-8000-000000000011',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0005-4000-8000-000000000005',
    'O que o relógio de Lamport garante ao atribuir contadores aos eventos de um sistema distribuído?',
    'O relógio de Lamport garante que, se um evento A causou um evento B, então o contador de A é menor que o de B. Não garante a recíproca: contadores ordenados não implicam necessariamente uma relação causal entre os eventos.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0011-4000-8000-000000000011', 'Se A causou B, o contador de A é menor que o de B (mas a recíproca não é garantida).', true),
    ('c2a2c2a0-0011-4000-8000-000000000011', 'Contadores idênticos sempre significam eventos concorrentes.', false),
    ('c2a2c2a0-0011-4000-8000-000000000011', 'Garante sincronização perfeita entre os relógios físicos dos nós.', false),
    ('c2a2c2a0-0011-4000-8000-000000000011', 'Elimina a necessidade de vector clocks em qualquer cenário.', false);

-- Q12 (media)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0012-4000-8000-000000000012',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0003-4000-8000-000000000003',
    'Qual é o papel do "termo" (term) numerado no algoritmo Raft?',
    'O termo é um número lógico incrementado a cada nova eleição, usado pelos nós para detectar informações desatualizadas (por exemplo, mensagens de um líder antigo) e para garantir que, no máximo, um líder seja eleito por termo.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0012-4000-8000-000000000012', 'Identificar e descartar informação desatualizada, garantindo no máximo um líder eleito por termo.', true),
    ('c2a2c2a0-0012-4000-8000-000000000012', 'Definir o tamanho máximo do log replicado.', false),
    ('c2a2c2a0-0012-4000-8000-000000000012', 'Substituir a necessidade de heartbeats entre líder e seguidores.', false),
    ('c2a2c2a0-0012-4000-8000-000000000012', 'Determinar quantas partições existem no cluster.', false);

-- Q13 (dificil)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0013-4000-8000-000000000013',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0003-4000-8000-000000000003',
    'No Raft, o que impede que um nó com log desatualizado vença uma eleição e se torne líder, potencialmente descartando operações já confirmadas?',
    'A regra de segurança de eleição do Raft: um nó só concede seu voto a um candidato se o log do candidato for pelo menos tão atualizado quanto o seu próprio (comparando o termo e o índice da última entrada). Isso garante que o líder eleito sempre contenha todas as entradas já confirmadas por uma maioria.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0013-4000-8000-000000000013', 'A regra de que um nó só vota em candidatos cujo log seja pelo menos tão atualizado quanto o seu.', true),
    ('c2a2c2a0-0013-4000-8000-000000000013', 'O uso de criptografia assimétrica para assinar cada entrada do log.', false),
    ('c2a2c2a0-0013-4000-8000-000000000013', 'A obrigatoriedade de todos os nós terem o mesmo endereço IP fixo.', false),
    ('c2a2c2a0-0013-4000-8000-000000000013', 'A eleição sempre escolher o nó com menor identificador numérico.', false);

-- Q14 (dificil)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0014-4000-8000-000000000014',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0005-4000-8000-000000000005',
    'O que o teorema FLP (Fischer, Lynch, Paterson) prova sobre consenso em sistemas assíncronos?',
    'O teorema FLP prova que é impossível garantir consenso determinístico em um sistema puramente assíncrono (sem limites conhecidos de tempo de processamento ou de rede) se ao menos um nó pode falhar — não existe algoritmo que garanta, ao mesmo tempo, safety e liveness nesse modelo. Na prática, algoritmos como Paxos e Raft contornam isso assumindo timeouts e um modelo parcialmente síncrono.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0014-4000-8000-000000000014', 'É impossível garantir consenso determinístico em um sistema assíncrono com até uma falha de nó.', true),
    ('c2a2c2a0-0014-4000-8000-000000000014', 'É impossível haver mais de um líder em qualquer sistema distribuído.', false),
    ('c2a2c2a0-0014-4000-8000-000000000014', 'Consenso é sempre alcançável desde que se use replicação síncrona.', false),
    ('c2a2c2a0-0014-4000-8000-000000000014', 'Sistemas assíncronos não podem sofrer partição de rede.', false);

-- Q15 (dificil)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0015-4000-8000-000000000015',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0004-4000-8000-000000000004',
    'Por que consistent hashing reduz drasticamente o volume de dados movidos ao adicionar ou remover um nó, em comparação com hash(chave) % número_de_nós?',
    'No hashing simples, alterar o número de nós muda o divisor do módulo, remapeando quase todas as chaves para nós diferentes. No consistent hashing, nós e chaves são posicionados em um anel, e uma chave pertence ao primeiro nó encontrado no sentido horário — adicionar ou remover um nó afeta apenas as chaves adjacentes a ele no anel, não o conjunto inteiro.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0015-4000-8000-000000000015', 'Porque apenas as chaves adjacentes ao nó alterado no anel de hash precisam ser remapeadas.', true),
    ('c2a2c2a0-0015-4000-8000-000000000015', 'Porque consistent hashing elimina completamente a necessidade de rebalanceamento.', false),
    ('c2a2c2a0-0015-4000-8000-000000000015', 'Porque consistent hashing usa replicação síncrona entre todos os nós.', false),
    ('c2a2c2a0-0015-4000-8000-000000000015', 'Porque o número de nós no anel é sempre fixo e nunca muda.', false);

-- Q16 (dificil)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0016-4000-8000-000000000016',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0005-4000-8000-000000000005',
    'Em que cenário um vector clock consegue determinar algo que um relógio de Lamport simples não consegue?',
    'Vector clocks conseguem identificar com precisão quando dois eventos são concorrentes (nenhum causou o outro, aconteceram de forma independente) versus causalmente relacionados. Relógios de Lamport, por atribuírem um único contador escalar, podem ordenar eventos concorrentes de forma arbitrária sem permitir distinguir essa concorrência.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0016-4000-8000-000000000016', 'Determinar com precisão se dois eventos são concorrentes ou causalmente relacionados.', true),
    ('c2a2c2a0-0016-4000-8000-000000000016', 'Sincronizar relógios físicos entre nós com precisão de milissegundos.', false),
    ('c2a2c2a0-0016-4000-8000-000000000016', 'Eliminar a necessidade de replicação de dados.', false),
    ('c2a2c2a0-0016-4000-8000-000000000016', 'Reduzir o tamanho do log replicado em algoritmos de consenso.', false);

-- Q17 (dificil)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0017-4000-8000-000000000017',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0001-4000-8000-000000000001',
    'Um banco relacional configurado com replicação síncrona e quorum de escrita, que recusa escritas quando não consegue confirmar com a maioria dos nós durante uma partição, está se posicionando como qual combinação do CAP theorem?',
    'Esse comportamento — recusar escritas para preservar a garantia de que toda leitura confirmada reflete o dado mais recente — é a definição de um sistema CP: prioriza consistência e tolerância a partição, sacrificando disponibilidade durante a partição.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0017-4000-8000-000000000017', 'CP — prioriza consistência e tolerância a partição, sacrificando disponibilidade.', true),
    ('c2a2c2a0-0017-4000-8000-000000000017', 'AP — prioriza disponibilidade mesmo com dados inconsistentes.', false),
    ('c2a2c2a0-0017-4000-8000-000000000017', 'CA — garante consistência e disponibilidade sem tolerar partição.', false),
    ('c2a2c2a0-0017-4000-8000-000000000017', 'Nenhuma das três, pois quorum é incompatível com o CAP theorem.', false);

-- Q18 (dificil)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0018-4000-8000-000000000018',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0002-4000-8000-000000000002',
    'Por que um sistema com replicação assíncrona e múltiplos líderes aceitando escritas simultaneamente (multi-leader) precisa de um mecanismo de resolução de conflitos?',
    'Como cada líder aceita escritas localmente antes de propagar de forma assíncrona para os demais, é possível que dois líderes aceitem escritas concorrentes e conflitantes sobre o mesmo dado antes de saberem uma da outra. Sem um mecanismo de resolução (ex.: last-write-wins, merge customizado, ou vector clocks para detectar o conflito), o sistema pode convergir para um estado que descarta silenciosamente uma das escritas de forma arbitrária.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0018-4000-8000-000000000018', 'Porque líderes diferentes podem aceitar escritas concorrentes e conflitantes antes de saberem uma da outra.', true),
    ('c2a2c2a0-0018-4000-8000-000000000018', 'Porque replicação assíncrona impede fisicamente mais de uma escrita por segundo.', false),
    ('c2a2c2a0-0018-4000-8000-000000000018', 'Porque múltiplos líderes exigem obrigatoriamente consenso via Raft.', false),
    ('c2a2c2a0-0018-4000-8000-000000000018', 'Porque conflitos só ocorrem quando há apenas um líder no sistema.', false);
