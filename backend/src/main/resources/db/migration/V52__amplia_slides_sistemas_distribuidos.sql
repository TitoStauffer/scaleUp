-- Ampliação do pool de Slides — Domínio Sistemas Distribuídos (slug 'sistemas-distribuidos'), Fase 1.
-- TICKET-content-expansion-slides-fase1.md: adiciona 2 Slides novos por Concept (ordem 4 =
-- erros comuns/armadilhas, ordem 5 = comparação com alternativa) às 3 já existentes em
-- V15__seed_conteudo_sistemas_distribuidos.sql, elevando o pool para 5 Slides por Concept / 25 no domínio.

-- Concept: CAP Theorem e trade-offs de consistência
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('b1a1c1a0-0001-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Erro comum: achar que bancos "AP" são sempre eventualmente consistentes em toda operação',
     'Um erro comum é tratar bancos rotulados como "AP" (ex.: Cassandra, DynamoDB) como se toda operação neles fosse necessariamente eventualmente consistente, sem opção de consistência mais forte. Na prática, esses sistemas costumam oferecer consistência ajustável (tunable consistency): é possível pedir leitura e escrita com QUORUM (ou mesmo ALL) para obter consistência forte em operações específicas, ao custo de latência e disponibilidade menores apenas naquela operação — o restante do sistema continua se comportando como AP. Achar que "o banco é AP" é uma propriedade fixa e global, em vez de uma configuração por operação, leva times a desconfiar do banco errado quando na verdade o problema era usar o nível de consistência padrão (geralmente ONE ou LOCAL_QUORUM) em um fluxo que exigia garantias mais fortes, como controle de estoque.',
     4, 'v1', 'rascunho'),
    ('b1a1c1a0-0001-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'CAP vs. PACELC: o trade-off que existe mesmo sem partição',
     'O PACELC theorem, proposto por Daniel Abadi, estende o CAP ao observar que ele só descreve o comportamento durante uma partição (P) — mas mesmo sem partição (Else), todo sistema distribuído enfrenta um trade-off contínuo entre latência (L) e consistência (C), porque replicar uma escrita para garantir consistência forte sempre adiciona round-trips de rede. Um sistema pode ser PA/EL (prioriza disponibilidade na partição e latência baixa no dia a dia, como Cassandra) ou PC/EC (prioriza consistência tanto na partição quanto fora dela, como um banco relacional com replicação síncrona). O critério prático: como a maior parte do tempo de operação de um sistema é "sem partição" (o caso comum), a escolha entre L e C no cenário Else pesa mais no dia a dia do usuário do que a escolha C vs. A durante a partição rara — avaliar só o CAP e ignorar o PACELC subestima o custo de latência da consistência forte em operação normal.',
     5, 'v1', 'rascunho');

-- Concept: Replicação e modelos de consistência
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('b1a1c1a0-0002-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Erro comum: confundir escrita confirmada com leitura garantida na sua própria réplica',
     'Um erro comum é assumir "read-your-writes" implícito: depois de uma escrita confirmada pelo líder, o desenvolvedor lê o dado logo em seguida esperando vê-lo atualizado, sem considerar que essa leitura pode ser roteada para uma réplica assíncrona que ainda não recebeu a propagação. O resultado é uma regressão temporal aparente para o próprio usuário que fez a escrita — ele salva um perfil, é redirecionado para a página de visualização e vê os dados antigos por alguns milissegundos ou segundos, mesmo sem nenhum outro usuário ter escrito nesse meio-tempo. A causa raiz não é um bug de replicação, é a ausência de uma garantia de read-your-writes explícita (ex.: fixar a leitura no líder logo após a escrita, ou usar um token de versão exigindo que a réplica esteja pelo menos tão atualizada quanto a escrita).',
     4, 'v1', 'rascunho'),
    ('b1a1c1a0-0002-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Replicação single-leader vs. multi-leader: quando aceitar conflitos vale a pena',
     'Replicação single-leader (um único nó aceita escritas, os demais só leem) evita conflitos por construção, porque toda escrita passa por um ponto central que define a ordem — é o modelo padrão de bancos relacionais tradicionais. Replicação multi-leader (múltiplos nós aceitam escritas, tipicamente um por região) reduz a latência de escrita para clientes distantes do líder único e mantém disponibilidade de escrita mesmo se uma região inteira ficar isolada, mas exige um mecanismo de resolução de conflitos para escritas concorrentes sobre o mesmo dado. O critério concreto: prefira single-leader quando as escritas se concentram em uma região e a simplicidade de nunca ter conflito compensa a latência extra de clientes remotos; considere multi-leader quando usuários em múltiplas regiões escrevem com frequência e a aplicação consegue definir uma estratégia de merge aceitável (ex.: CRDTs, last-write-wins por campo) para os poucos casos de conflito real.',
     5, 'v1', 'rascunho');

-- Concept: Consenso distribuído: Paxos e Raft
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('b1a1c1a0-0003-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Erro comum: achar que adicionar nós a um cluster Raft/Paxos aumenta a capacidade de escrita',
     'Um erro comum é achar que adicionar mais nós a um cluster Raft ou Paxos aumenta a capacidade de escrita do sistema, no mesmo raciocínio de "escalar horizontalmente" aplicado a sharding. Na prática, cada escrita em um sistema de consenso precisa esperar a confirmação de uma maioria (quorum) dos nós antes de ser considerada decidida — em um cluster de 2f+1 nós, isso significa esperar f+1 confirmações, incluindo o nó mais lento desse subconjunto. Adicionar nós não paraleliza escritas (elas continuam sendo uma única sequência replicada, não partições independentes): apenas aumenta o tamanho do quorum necessário e, frequentemente, a latência de cada escrita, já que mais réplicas geograficamente dispersas tendem a incluir alguma mais distante no quorum. Consenso forte escala a tolerância a falhas, não o throughput de escrita.',
     4, 'v1', 'rascunho'),
    ('b1a1c1a0-0003-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Consenso forte (Raft/Paxos) vs. protocolos gossip: quando abrir mão de ordem total',
     'Protocolos de consenso forte como Raft e Paxos garantem ordem total e linearizável sobre cada decisão, mas pagam o preço de um round-trip de quorum síncrono por escrita. Protocolos gossip (epidemic protocols), usados por sistemas como Cassandra e DynamoDB para propagar estado entre nós, trocam essa garantia por disponibilidade e escala: cada nó propaga atualizações de forma assíncrona e probabilística para vizinhos aleatórios, sem esperar confirmação de uma maioria, aceitando convergência eventual em vez de consistência imediata. O critério concreto: use consenso forte para decisões que exigem uma única fonte de verdade inquestionável (eleição de líder, configuração de cluster, locks distribuídos); use gossip quando o dado é naturalmente tolerante a convergência tardia (ex.: status de membership do cluster, contadores agregados) e o volume de nós ou a dispersão geográfica tornaria um quorum síncrono caro demais.',
     5, 'v1', 'rascunho');

-- Concept: Particionamento e sharding de dados
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('b1a1c1a0-0004-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Erro comum: achar que hash da chave sempre elimina hotspots',
     'Um erro comum é achar que particionar por hash da chave elimina hotspots por definição, só porque a função de hash distribui uniformemente. Isso só é verdade se a própria distribuição de acesso às chaves também for uniforme — se uma pequena fração das chaves concentra a maior parte do tráfego (ex.: sharding por tenant_id quando um cliente grande gera 40% das requisições, ou uma chave "viral" em um sistema de contadores), essa chave específica sempre cai na mesma partição, não importa quão bem distribuído seja o hash das demais chaves. O hash resolve distribuição de volume de dados armazenados, não necessariamente distribuição de carga de acesso — os dois problemas são frequentemente confundidos, mas exigem soluções diferentes (ex.: sharding secundário da chave quente, ou cache dedicado para ela).',
     4, 'v1', 'rascunho'),
    ('b1a1c1a0-0004-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Sharding horizontal vs. escalar verticalmente: quando particionar não é a resposta certa',
     'Sharding horizontal resolve o problema de volume/throughput que excede uma única máquina, mas introduz complexidade real: queries que cruzam partições, transações distribuídas e rebalanceamento. Escalar verticalmente (scale-up: máquina maior, mais CPU/RAM/IO) evita toda essa complexidade operacional, mas tem um teto físico e de custo — em algum ponto a maior instância disponível não é suficiente ou o custo marginal se torna proibitivo. O critério concreto: só vale a pena shardar quando o volume de dados ou de requisições já ultrapassou (ou claramente vai ultrapassar em prazo previsível) o que a maior máquina disponível consegue sustentar com folga operacional — shardar cedo demais, "por precaução", troca uma complexidade real e imediata (joins entre shards, rebalanceamento) por um problema futuro incerto.',
     5, 'v1', 'rascunho');

-- Concept: Relógios lógicos, ordenação de eventos e tolerância a falhas
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('b1a1c1a0-0005-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Erro comum: usar timestamp de Lamport para decidir qual escrita concorrente "venceu"',
     'Um erro comum é usar o timestamp de um relógio de Lamport para decidir qual de duas escritas concorrentes deve "vencer" (ex.: manter sempre o valor com o maior contador). Isso parece razoável porque o relógio de Lamport produz uma ordem total (já que empates são desempatados, tipicamente pelo identificador do nó), mas essa ordem total é artificial: para eventos verdadeiramente concorrentes (nenhum causou o outro), o desempate não reflete nenhuma relação causal real, apenas uma convenção arbitrária de comparação de números. Usar esse valor para resolver conflitos de escrita (uma forma de last-write-wins) descarta silenciosamente uma escrita legítima sem que o desempate tenha qualquer relação com qual escrita "realmente" aconteceu depois no tempo real ou na intenção do usuário.',
     4, 'v1', 'rascunho'),
    ('b1a1c1a0-0005-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
     'Relógios lógicos vs. TrueTime/HLC: quando vale investir em relógios físicos sincronizados',
     'Relógios lógicos (Lamport, vector clocks) são baratos e funcionam com qualquer infraestrutura, mas só capturam ordem causal, não tempo real. TrueTime, usado internamente pelo Google Spanner, é uma abordagem alternativa: uma API de relógio físico que retorna um intervalo de incerteza (baseado em receptores GPS e relógios atômicos redundantes em cada datacenter), permitindo que o sistema espere deliberadamente esse intervalo (commit-wait) antes de confirmar uma transação, obtendo consistência externa (linearizabilidade global) sem depender de trocar mensagens de coordenação a cada operação. O critério concreto: relógios lógicos bastam quando o objetivo é rastrear causalidade entre eventos de aplicação a custo baixo; uma abordagem à la TrueTime só se justifica quando a organização controla a infraestrutura física o suficiente para instalar hardware de sincronização dedicado e precisa de transações globalmente ordenadas com garantia forte de tempo real, algo que a maioria das empresas fora de provedores de nuvem hyperscale não tem acesso prático.',
     5, 'v1', 'rascunho');
