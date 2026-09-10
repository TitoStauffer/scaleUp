-- Ampliação do pool de Questions do domínio Sistemas Distribuídos (Fase 2 de
-- TICKET-content-expansion-questoes-fase2.md, migração reservada V36 para este domínio).
--
-- Adiciona 18 Questions NOVAS (6 fácil / 6 média / 6 difícil) com 4 alternativas cada
-- (72 alternativas), elevando o pool do domínio de 36 (seed V15 + Fase 1 V27) para 54
-- Questions.
--
-- Regras seguidas (mesmas de V15/V27, sem alteração):
--   - content_version = 'v1', status_revisao = 'rascunho'.
--   - domain_ref via subquery em domain.slug = 'sistemas-distribuidos' (mesmo mecanismo).
--   - concept_ref aponta para um dos 5 Concepts já existentes (UUIDs literais reaproveitados
--     de V15) — nenhum Concept novo criado nesta migração.
--   - Nenhum INSERT em domain/concept/slide/flashcard — apenas question/question_alternative.
--
-- Não-duplicação: V15 (Q1-Q18, ids c2a2c2a0-0001...-0018) e V27 (Q19-Q36, ids
-- c2a2c2a0-0019...-0036) foram lidos integralmente antes de escrever este arquivo. Os 36
-- enunciados já existentes cobrem: definição de AP/CP/C isolada, mito do "escolha 2 de 3",
-- PACELC (trade-off latência x consistência), caso teórico CA, classificação CP de um banco
-- relacional com quorum; replicação síncrona x assíncrona, stale reads, consistência forte x
-- eventual x causal, replicação single-leader, read-your-writes, monotonic reads, conflito em
-- multi-leader, risco de last-write-wins; definição de quorum, fases do Paxos, motivação e
-- eleição de líder do Raft, papel do termo, regra de segurança de voto por log mais atualizado,
-- tolerância a falhas em cluster 2f+1, teorema FLP, split-brain via quorum, gossip x heartbeat
-- centralizado; sharding x replicação, hash x range, consistent hashing, virtual nodes, fórmula
-- de quorum W+R>N, hotspot em range e em hash; relógios físicos insuficientes, relógio de
-- Lamport, vector clocks e seu limite de escala, detector de falha phi accrual, heartbeats e
-- timeouts, failover.
--
-- As 18 Questions desta leva testam ângulos deliberadamente não cobertos acima: definição
-- formal de Availability (sem garantia de frescor), consistência sintonizável (tunable
-- consistency), CAP theorem aplicado apenas a consistência atômica/linearizável (e não a
-- modelos mais fracos como causal); replicação leaderless, read repair, anti-entropy, sloppy
-- quorum e hinted handoff; modelo de falha crash-stop x bizantino, replicação de máquina de
-- estados, bloqueio do two-phase commit (2PC) x progresso via quorum, leitura seg do líder do
-- Raft (risco de líder destituído sem saber); rebalanceamento, estratégia de número fixo de
-- partições, índice secundário local x global, particionamento por diretório x algorítmico;
-- clock skew/NTP, TrueTime/Spanner (commit wait) e gray failure.

-- ============================================================================
-- QUESTIONS + ALTERNATIVAS (18 novas: 6 fácil, 6 média, 6 difícil)
-- ============================================================================

-- Q37 (facil) — Concept 1: CAP Theorem
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0037-4000-8000-000000000037',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0001-4000-8000-000000000001',
    'Segundo a definição formal do CAP theorem, o que a propriedade Availability garante sobre a resposta de um nó não falho?',
    'Availability garante apenas que toda requisição a um nó não falho recebe alguma resposta, sem garantia de que essa resposta reflita a escrita mais recente — não deve ser confundida com a garantia de dado atualizado, que é papel da Consistency.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0037-4000-8000-000000000037', 'Garante que o nó responde à requisição, mesmo que o valor retornado possa estar desatualizado.', true),
    ('c2a2c2a0-0037-4000-8000-000000000037', 'Garante que o nó sempre retorna o valor mais recentemente escrito.', false),
    ('c2a2c2a0-0037-4000-8000-000000000037', 'Garante que o nó nunca fica sobrecarregado por requisições simultâneas.', false),
    ('c2a2c2a0-0037-4000-8000-000000000037', 'Garante que o nó rejeita requisições durante qualquer instabilidade de rede.', false);

-- Q38 (facil) — Concept 2: Replicação
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0038-4000-8000-000000000038',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0002-4000-8000-000000000002',
    'O que caracteriza a replicação "leaderless" (sem líder), como usada em sistemas ao estilo Dynamo?',
    'Em replicação leaderless, o cliente (ou um coordenador sem papel fixo) envia escritas e leituras diretamente para múltiplas réplicas, sem que um único nó líder coordene a ordem das operações — a consistência é obtida por meio de quóruns de leitura/escrita e mecanismos de reconciliação, não por uma ordem imposta por um líder.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0038-4000-8000-000000000038', 'O cliente escreve e lê diretamente de múltiplas réplicas, sem um nó líder único coordenando a ordem das operações.', true),
    ('c2a2c2a0-0038-4000-8000-000000000038', 'Um nó líder único aceita todas as escritas e as propaga sequencialmente para os seguidores.', false),
    ('c2a2c2a0-0038-4000-8000-000000000038', 'Os dados são particionados de forma que cada réplica armazene um subconjunto disjunto dos dados.', false),
    ('c2a2c2a0-0038-4000-8000-000000000038', 'As réplicas se comunicam exclusivamente através de um algoritmo de consenso como Raft.', false);

-- Q39 (facil) — Concept 3: Consenso
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0039-4000-8000-000000000039',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0003-4000-8000-000000000003',
    'Algoritmos de consenso clássicos como Paxos e Raft assumem qual modelo de falha para os nós do cluster?',
    'Paxos e Raft assumem o modelo crash-stop (ou crash-fail): um nó falho simplesmente para de responder, mas nunca envia mensagens incorretas ou maliciosas de propósito. Tolerar nós que mentem ou se comportam de forma arbitrária (falhas bizantinas) exige algoritmos diferentes, como PBFT, tipicamente usados em contextos com participantes não confiáveis (ex.: blockchains).',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0039-4000-8000-000000000039', 'Falhas por parada (crash-stop): um nó falho apenas deixa de responder, nunca envia informação incorreta de propósito.', true),
    ('c2a2c2a0-0039-4000-8000-000000000039', 'Falhas bizantinas: um nó falho pode enviar mensagens deliberadamente incorretas ou contraditórias.', false),
    ('c2a2c2a0-0039-4000-8000-000000000039', 'Nenhuma falha é tolerada; qualquer falha de nó interrompe o cluster permanentemente.', false),
    ('c2a2c2a0-0039-4000-8000-000000000039', 'Apenas falhas de rede são toleradas; falhas de disco no nó não são consideradas em nenhuma hipótese.', false);

-- Q40 (facil) — Concept 4: Particionamento
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0040-4000-8000-000000000040',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0004-4000-8000-000000000004',
    'O que é "rebalanceamento" em um sistema de dados particionado (sharded)?',
    'Rebalanceamento é o processo de mover partições (ou faixas de chaves) entre nós quando a topologia do cluster muda — por exemplo, ao adicionar ou remover um nó — com o objetivo de redistribuir a carga de forma equilibrada, idealmente movendo o mínimo de dados necessário.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0040-4000-8000-000000000040', 'Mover partições entre nós quando o cluster muda de tamanho, redistribuindo a carga de forma equilibrada.', true),
    ('c2a2c2a0-0040-4000-8000-000000000040', 'Recalcular o valor de hash de todas as chaves a cada nova escrita.', false),
    ('c2a2c2a0-0040-4000-8000-000000000040', 'Substituir o algoritmo de consenso usado pelo cluster.', false),
    ('c2a2c2a0-0040-4000-8000-000000000040', 'Reduzir o número de réplicas de cada partição para economizar espaço.', false);

-- Q41 (facil) — Concept 4: Particionamento
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0041-4000-8000-000000000041',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0004-4000-8000-000000000004',
    'Na estratégia de "número fixo de partições", por que um sistema cria, desde o início, muito mais partições do que o número atual de nós?',
    'Criar mais partições do que nós desde o início permite que o rebalanceamento, quando um nó é adicionado ou removido, mova partições inteiras entre nós (sem recalcular limites de partição), simplificando a operação — cada nó passa a hospedar mais ou menos partições, mas o número total de partições permanece constante.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0041-4000-8000-000000000041', 'Para permitir mover partições inteiras entre nós durante o rebalanceamento, sem precisar recalcular os limites das partições.', true),
    ('c2a2c2a0-0041-4000-8000-000000000041', 'Para eliminar completamente a necessidade de replicação entre partições.', false),
    ('c2a2c2a0-0041-4000-8000-000000000041', 'Porque partições fixas garantem consistência forte automaticamente.', false),
    ('c2a2c2a0-0041-4000-8000-000000000041', 'Para reduzir o número total de nós necessários no cluster.', false);

-- Q42 (facil) — Concept 5: Relógios lógicos e tolerância a falhas
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0042-4000-8000-000000000042',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0005-4000-8000-000000000005',
    'O que é "clock skew" (desvio de relógio) entre nós de um sistema distribuído, e por que o NTP não o elimina completamente?',
    'Clock skew é a diferença entre os valores mostrados pelos relógios físicos de nós diferentes em um mesmo instante. Mesmo com sincronização via NTP, latência de rede variável e imprecisão dos osciladores locais impedem sincronização perfeita, deixando sempre uma margem de incerteza (tipicamente da ordem de milissegundos) entre os relógios dos nós.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0042-4000-8000-000000000042', 'É a diferença entre os relógios físicos de nós diferentes; o NTP reduz mas não elimina essa diferença devido a latência de rede variável e imprecisão dos osciladores.', true),
    ('c2a2c2a0-0042-4000-8000-000000000042', 'É a diferença entre os contadores de relógios lógicos (Lamport) de dois nós.', false),
    ('c2a2c2a0-0042-4000-8000-000000000042', 'É o tempo que uma réplica leva para aplicar uma escrita replicada de forma assíncrona.', false),
    ('c2a2c2a0-0042-4000-8000-000000000042', 'É o atraso entre a eleição de um líder e o início efetivo de seu mandato.', false);

-- Q43 (media) — Concept 1: CAP Theorem
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0043-4000-8000-000000000043',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0001-4000-8000-000000000001',
    'O que significa dizer que um banco de dados como Cassandra oferece "consistência sintonizável" (tunable consistency)?',
    'Significa que o nível de consistência (por exemplo, ONE, QUORUM ou ALL réplicas) pode ser escolhido por operação de leitura ou escrita, em vez de ser uma propriedade fixa de todo o sistema — permitindo que diferentes operações do mesmo sistema façam trade-offs distintos entre consistência, disponibilidade e latência, conforme a necessidade de cada caso de uso.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0043-4000-8000-000000000043', 'O nível de consistência pode ser configurado por operação (leitura ou escrita), não como uma propriedade fixa de todo o sistema.', true),
    ('c2a2c2a0-0043-4000-8000-000000000043', 'O sistema ajusta automaticamente sua topologia de rede para evitar partições.', false),
    ('c2a2c2a0-0043-4000-8000-000000000043', 'O sistema garante consistência forte para todas as operações, ajustando apenas a latência.', false),
    ('c2a2c2a0-0043-4000-8000-000000000043', 'O sistema converte automaticamente escritas síncronas em assíncronas conforme a carga.', false);

-- Q44 (media) — Concept 2: Replicação
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0044-4000-8000-000000000044',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0002-4000-8000-000000000002',
    'O que é "read repair" em um sistema de replicação leaderless?',
    'Read repair é o mecanismo pelo qual, ao consultar múltiplas réplicas durante uma leitura, o cliente (ou coordenador) detecta que uma ou mais réplicas retornaram um valor desatualizado e aproveita essa mesma operação de leitura para escrever o valor mais recente de volta na réplica atrasada, corrigindo-a de forma incremental.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0044-4000-8000-000000000044', 'Ao detectar, durante uma leitura de múltiplas réplicas, que uma delas está desatualizada, o sistema aproveita a leitura para corrigi-la, propagando o valor mais recente.', true),
    ('c2a2c2a0-0044-4000-8000-000000000044', 'Um processo que reconstrói do zero uma réplica inteira após uma falha de disco.', false),
    ('c2a2c2a0-0044-4000-8000-000000000044', 'Um algoritmo que elege um novo líder quando o líder atual falha.', false),
    ('c2a2c2a0-0044-4000-8000-000000000044', 'Uma técnica de compressão que reduz o tamanho dos dados replicados.', false);

-- Q45 (media) — Concept 2: Replicação
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0045-4000-8000-000000000045',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0002-4000-8000-000000000002',
    'Em que "anti-entropy" (processo de sincronização em segundo plano) difere de "read repair" na correção de réplicas desatualizadas?',
    'Anti-entropy é um processo em segundo plano que compara e sincroniza réplicas periodicamente, independentemente de haver leituras de clientes, garantindo que réplicas raramente lidas também convirjam eventualmente; read repair, por outro lado, só corrige uma réplica quando ela é efetivamente consultada em uma leitura.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0045-4000-8000-000000000045', 'Anti-entropy sincroniza réplicas periodicamente em segundo plano, mesmo sem leituras; read repair só corrige uma réplica quando ela é lida.', true),
    ('c2a2c2a0-0045-4000-8000-000000000045', 'Anti-entropy só atua durante a inicialização do cluster; read repair atua continuamente.', false),
    ('c2a2c2a0-0045-4000-8000-000000000045', 'Anti-entropy exige um algoritmo de consenso como Raft; read repair não usa réplicas.', false),
    ('c2a2c2a0-0045-4000-8000-000000000045', 'Não há diferença: são dois nomes para o mesmo mecanismo.', false);

-- Q46 (media) — Concept 3: Consenso
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0046-4000-8000-000000000046',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0003-4000-8000-000000000003',
    'O que é "replicação de máquina de estados" (state machine replication) no contexto de algoritmos como Raft?',
    'É a técnica de garantir que todos os nós apliquem exatamente a mesma sequência de comandos, na mesma ordem, a uma máquina de estados determinística local — como cada nó parte do mesmo estado inicial e processa os mesmos comandos na mesma ordem, todos chegam ao mesmo estado final, mesmo sem comunicação direta durante a aplicação de cada comando.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0046-4000-8000-000000000046', 'Garantir que todos os nós apliquem a mesma sequência de comandos, na mesma ordem, a uma máquina de estados determinística, levando-os ao mesmo estado final.', true),
    ('c2a2c2a0-0046-4000-8000-000000000046', 'Substituir o disco de cada nó por uma máquina de estados virtual sem persistência.', false),
    ('c2a2c2a0-0046-4000-8000-000000000046', 'Permitir que cada nó execute comandos em uma ordem diferente, desde que o resultado final seja eventualmente sincronizado.', false),
    ('c2a2c2a0-0046-4000-8000-000000000046', 'Garantir que apenas o nó líder mantenha estado; os seguidores permanecem sem estado (stateless).', false);

-- Q47 (media) — Concept 4: Particionamento
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0047-4000-8000-000000000047',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0004-4000-8000-000000000004',
    'Qual é a principal desvantagem de um índice secundário "local" (particionado da mesma forma que os dados) em um banco de dados particionado, em comparação a um índice "global"?',
    'Um índice local mantém, em cada partição, um índice apenas dos dados daquela partição — uma consulta pelo campo indexado que não seja a chave de particionamento precisa varrer todas as partições (scatter-gather), o que aumenta a latência de leitura. Um índice global particiona o índice pelo próprio campo indexado, tornando a leitura mais direta, ao custo de escritas mais complexas (a escrita pode precisar atualizar uma partição de índice diferente da partição de dados).',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0047-4000-8000-000000000047', 'Consultas pelo campo indexado exigem varrer todas as partições (scatter-gather), já que cada partição só indexa seus próprios dados.', true),
    ('c2a2c2a0-0047-4000-8000-000000000047', 'Índices locais não podem ser usados em bancos particionados por hash.', false),
    ('c2a2c2a0-0047-4000-8000-000000000047', 'Índices locais exigem replicação síncrona obrigatória entre todas as partições.', false),
    ('c2a2c2a0-0047-4000-8000-000000000047', 'Índices locais tornam as escritas mais lentas que índices globais em qualquer cenário.', false);

-- Q48 (media) — Concept 5: Relógios lógicos e tolerância a falhas
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0048-4000-8000-000000000048',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0005-4000-8000-000000000005',
    'Como o TrueTime, usado pelo Google Spanner, ajuda a oferecer consistência externa (linearizabilidade) em transações distribuídas globalmente?',
    'TrueTime expõe o tempo não como um valor único, mas como um intervalo de incerteza (usando GPS e relógios atômicos para manter essa incerteza pequena e conhecida). O Spanner usa isso para implementar "commit wait": antes de confirmar uma transação, o sistema espera o tempo suficiente para garantir que o intervalo de incerteza já passou, assegurando que transações que aconteceram depois, no tempo real, recebam timestamps maiores — algo que relógios físicos comuns, sem uma incerteza limitada e conhecida, não permitem garantir com segurança.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0048-4000-8000-000000000048', 'Expondo o tempo como um intervalo de incerteza limitado e conhecido, permitindo esperar ("commit wait") até ter certeza da ordem real dos eventos antes de confirmar uma transação.', true),
    ('c2a2c2a0-0048-4000-8000-000000000048', 'Eliminando completamente a necessidade de qualquer sincronização de relógio entre data centers.', false),
    ('c2a2c2a0-0048-4000-8000-000000000048', 'Substituindo o algoritmo de consenso do Spanner por um relógio único centralizado e global.', false),
    ('c2a2c2a0-0048-4000-8000-000000000048', 'Garantindo que todas as transações sejam processadas por um único data center, evitando distribuição geográfica.', false);

-- Q49 (dificil) — Concept 1: CAP Theorem
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0049-4000-8000-000000000049',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0001-4000-8000-000000000001',
    'A prova formal do CAP theorem (Gilbert e Lynch) assume o modelo mais forte de consistência (atômica/linearizável). O que isso implica para um sistema que adota, em vez disso, um modelo mais fraco, como consistência causal?',
    'Como a impossibilidade provada pelo CAP theorem se aplica especificamente à consistência atômica/linearizável, sistemas que adotam garantias mais fracas — como consistência causal — não são forçados pela mesma prova a escolher entre disponibilidade e essa garantia mais fraca durante uma partição: é possível manter consistência causal e disponibilidade simultaneamente mesmo com partição, algo que seria impossível se a garantia exigida fosse consistência atômica.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0049-4000-8000-000000000049', 'Um sistema com consistência causal pode, em teoria, manter disponibilidade durante uma partição sem violar essa garantia mais fraca — a impossibilidade do CAP não se aplica da mesma forma a modelos mais fracos que o atômico.', true),
    ('c2a2c2a0-0049-4000-8000-000000000049', 'Não muda nada: o CAP theorem força a mesma escolha entre C e A para qualquer modelo de consistência, forte ou fraco.', false),
    ('c2a2c2a0-0049-4000-8000-000000000049', 'Consistência causal exige ainda mais disponibilidade sacrificada do que consistência atômica.', false),
    ('c2a2c2a0-0049-4000-8000-000000000049', 'Consistência causal só é definida para sistemas com um único nó, tornando o CAP theorem inaplicável por definição.', false);

-- Q50 (dificil) — Concept 2: Replicação
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0050-4000-8000-000000000050',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0002-4000-8000-000000000002',
    'Em um sistema de replicação com "sloppy quorum" e "hinted handoff" (como em sistemas ao estilo Dynamo), o que acontece quando uma escrita não consegue alcançar quorum entre as réplicas designadas de uma chave durante uma instabilidade de rede?',
    'Com sloppy quorum, a escrita é temporariamente aceita por outros nós disponíveis, mesmo que não sejam as réplicas designadas daquela chave, para preservar disponibilidade de escrita. Esses nós guardam a escrita como uma "dica" (hint) e, quando a conectividade com o nó designado é restaurada, encaminham (handoff) o dado para ele. Isso aumenta a disponibilidade, mas significa que, por um período, a garantia estrita de quorum entre as réplicas corretas fica temporariamente enfraquecida.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0050-4000-8000-000000000050', 'A escrita é aceita por nós disponíveis não designados (sloppy quorum), que a guardam como "hint" e a encaminham ao nó correto quando ele volta a responder (hinted handoff), priorizando disponibilidade sobre a garantia estrita de quorum.', true),
    ('c2a2c2a0-0050-4000-8000-000000000050', 'A escrita é sempre rejeitada até que todas as réplicas designadas voltem a responder.', false),
    ('c2a2c2a0-0050-4000-8000-000000000050', 'O sistema automaticamente promove um novo conjunto permanente de réplicas designadas para substituir as antigas.', false),
    ('c2a2c2a0-0050-4000-8000-000000000050', 'A escrita é descartada silenciosamente e o cliente não recebe nenhuma confirmação nem erro.', false);

-- Q51 (dificil) — Concept 3: Consenso
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0051-4000-8000-000000000051',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0003-4000-8000-000000000003',
    'Por que o protocolo de commit em duas fases (2PC, two-phase commit) é considerado "bloqueante" de uma forma que algoritmos de consenso baseados em quorum, como Raft, não são?',
    'No 2PC, se o coordenador falhar depois que os participantes já votaram "sim" na fase de preparação, mas antes de enviar a decisão final (commit ou abort), os participantes ficam bloqueados, incapazes de decidir sozinhos se devem confirmar ou desfazer a transação, até o coordenador se recuperar. Em algoritmos baseados em quorum como Raft, uma maioria dos nós pode eleger um novo líder e continuar progredindo mesmo que o líder anterior falhe permanentemente, sem depender da recuperação de um único nó coordenador.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0051-4000-8000-000000000051', 'Se o coordenador do 2PC falha entre a fase de preparação e a decisão final, os participantes ficam bloqueados esperando sua recuperação; em Raft, uma maioria pode eleger um novo líder e seguir em frente.', true),
    ('c2a2c2a0-0051-4000-8000-000000000051', 'Porque o 2PC não usa réplicas, enquanto Raft sempre exige pelo menos cinco nós.', false),
    ('c2a2c2a0-0051-4000-8000-000000000051', 'Porque o 2PC é executado apenas em sistemas de arquivo único, nunca em bancos de dados distribuídos.', false),
    ('c2a2c2a0-0051-4000-8000-000000000051', 'Porque Raft não depende de nenhum tipo de votação entre os nós, apenas o 2PC depende.', false);

-- Q52 (dificil) — Concept 3: Consenso
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0052-4000-8000-000000000052',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0003-4000-8000-000000000003',
    'Por que um líder do Raft não pode responder com segurança a uma leitura usando apenas seu estado local, mesmo estando convencido de que ainda é o líder?',
    'É possível que o nó tenha sido isolado por uma partição de rede e que, do outro lado da partição, uma maioria já tenha eleito um novo líder mais atualizado — o nó antigo pode não ter recebido ainda a notificação de que perdeu a liderança. Servir uma leitura só do estado local, sem confirmar ativamente que ainda mantém uma maioria de votos/heartbeats (ou sem uma lease de liderança válida), arrisca retornar um valor desatualizado, violando linearizabilidade.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0052-4000-8000-000000000052', 'Porque o nó pode ter sido isolado por uma partição e já ter sido substituído por um novo líder do outro lado, sem saber disso ainda — servir a leitura sem confirmar a liderança arrisca retornar dado desatualizado.', true),
    ('c2a2c2a0-0052-4000-8000-000000000052', 'Porque o Raft nunca permite que o líder sirva leituras, apenas escritas.', false),
    ('c2a2c2a0-0052-4000-8000-000000000052', 'Porque leituras no Raft sempre exigem reiniciar uma nova eleição antes de cada resposta.', false),
    ('c2a2c2a0-0052-4000-8000-000000000052', 'Porque o estado local do líder é sempre criptografado e não pode ser lido diretamente.', false);

-- Q53 (dificil) — Concept 4: Particionamento
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0053-4000-8000-000000000053',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0004-4000-8000-000000000004',
    'Qual é o principal trade-off de usar particionamento baseado em diretório (um serviço externo que mapeia explicitamente cada chave ou faixa de chaves a uma partição), em comparação com particionamento puramente algorítmico (hash ou range)?',
    'Particionamento baseado em diretório oferece mais flexibilidade — permite mover chaves individuais entre partições sem seguir uma fórmula rígida, e facilita rebalanceamento sob medida — mas introduz uma dependência de um serviço de metadados que precisa ser consultado (ou cacheado) a cada operação, adicionando latência e um novo componente que, se mal projetado, pode virar gargalo ou ponto único de falha.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0053-4000-8000-000000000053', 'Ganha flexibilidade de mapeamento e rebalanceamento sob medida, mas depende de um serviço de metadados adicional, que pode adicionar latência e se tornar gargalo ou ponto único de falha.', true),
    ('c2a2c2a0-0053-4000-8000-000000000053', 'Particionamento por diretório elimina completamente a necessidade de replicação das partições.', false),
    ('c2a2c2a0-0053-4000-8000-000000000053', 'Particionamento por diretório é sempre mais rápido, pois dispensa qualquer cálculo de hash ou comparação de faixas.', false),
    ('c2a2c2a0-0053-4000-8000-000000000053', 'Particionamento algorítmico exige um serviço de metadados externo, enquanto particionamento por diretório não exige nenhum lookup.', false);

-- Q54 (dificil) — Concept 5: Relógios lógicos e tolerância a falhas
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0054-4000-8000-000000000054',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0005-4000-8000-000000000005',
    'O que é uma "gray failure" (falha cinzenta) em um sistema distribuído, e por que ela é mais perigosa do que uma falha total (crash) de um nó?',
    'Gray failure é uma degradação parcial de um nó — por exemplo, disco lento, perda intermitente de pacotes ou um processo travado em parte de suas funções — em que o nó continua respondendo a verificações de saúde básicas (heartbeats) e por isso não é detectado como falho pelos mecanismos usuais de detecção de falhas, mesmo causando lentidão ou erros para quem depende dele. Diferente de um crash claro, que aciona failover rapidamente, uma gray failure pode persistir sem ser detectada, degradando o sistema de forma silenciosa.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0054-4000-8000-000000000054', 'É uma degradação parcial em que o nó continua respondendo a heartbeats básicos, escapando da detecção usual de falhas, mas causando lentidão ou erros — mais perigosa por não acionar failover automaticamente.', true),
    ('c2a2c2a0-0054-4000-8000-000000000054', 'É uma falha que ocorre exclusivamente durante a troca de líder em algoritmos de consenso.', false),
    ('c2a2c2a0-0054-4000-8000-000000000054', 'É um sinônimo para falha bizantina, em que o nó envia dados maliciosos deliberadamente.', false),
    ('c2a2c2a0-0054-4000-8000-000000000054', 'É uma falha que só pode ocorrer em sistemas com um único nó, sem replicação.', false);
