-- Ampliação do pool de Questions do domínio Sistemas Distribuídos (Fase 1 de
-- TICKET-content-expansion-questoes.md, migração reservada V27 para este domínio).
--
-- Adiciona 18 Questions NOVAS (6 fácil / 6 média / 6 difícil) com 4 alternativas cada
-- (72 alternativas), elevando o pool do domínio de 18 para 36 Questions.
--
-- Regras seguidas (mesmas do V15, sem alteração):
--   - content_version = 'v1', status_revisao = 'rascunho'.
--   - domain_ref via subquery em domain.slug = 'sistemas-distribuidos' (mesmo mecanismo do V15).
--   - concept_ref aponta para um dos 5 Concepts já existentes (UUIDs literais reaproveitados
--     do V15) — nenhum Concept novo criado nesta migração.
--   - Nenhum INSERT em domain/concept/slide/flashcard — apenas question/question_alternative.
--
-- Não-duplicação: o V15 foi lido integralmente antes de escrever este arquivo. Nenhum dos
-- 18 enunciados abaixo repete, literalmente ou como reformulação disfarçada, nenhum dos 18
-- enunciados já existentes em V15 (Q1–Q18, ids c2a2c2a0-0001...-0018). Os pontos testados
-- aqui são deliberadamente diferentes: definição isolada de "C" no CAP (vs. AP/CP já
-- cobertos), replicação single-leader básica, objetivo da eleição de líder, definição de
-- shard, failover, read-your-writes, PACELC, fases do Paxos, fórmula de quorum W+R>N,
-- detector de falha phi accrual, risco de last-write-wins, virtual nodes, sistema CA como
-- caso teórico, split-brain via quorum, custo de escala de vector clocks, hotspot mesmo com
-- hash partitioning, monotonic reads, e gossip vs. heartbeat centralizado — nenhum desses
-- pontos é perguntado em V15.

-- ============================================================================
-- QUESTIONS + ALTERNATIVAS (18 novas: 6 fácil, 6 média, 6 difícil)
-- ============================================================================

-- Q19 (facil) — Concept 1: CAP Theorem
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0019-4000-8000-000000000019',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0001-4000-8000-000000000001',
    'O que a letra "C" representa no CAP theorem, e o que essa propriedade garante a uma leitura?',
    'Consistency garante que toda leitura recebe a escrita confirmada mais recente, ou um erro — nunca um dado desatualizado sem sinalização de que pode estar desatualizado.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0019-4000-8000-000000000019', 'Consistency: toda leitura recebe a escrita mais recente ou um erro.', true),
    ('c2a2c2a0-0019-4000-8000-000000000019', 'Availability: toda requisição recebe resposta rápida, sem erro.', false),
    ('c2a2c2a0-0019-4000-8000-000000000019', 'Coordenação entre nós via relógio físico sincronizado.', false),
    ('c2a2c2a0-0019-4000-8000-000000000019', 'Compressão dos dados antes de replicá-los entre nós.', false);

-- Q20 (facil) — Concept 2: Replicação
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0020-4000-8000-000000000020',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0002-4000-8000-000000000002',
    'O que caracteriza a replicação single-leader (primário-secundário)?',
    'Um único nó (o líder) aceita todas as escritas e as propaga para os demais nós (seguidores), que tipicamente servem a maior parte das leituras — diferente de esquemas multi-leader, em que mais de um nó aceita escritas.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0020-4000-8000-000000000020', 'Um único nó líder aceita todas as escritas e as propaga para os nós seguidores.', true),
    ('c2a2c2a0-0020-4000-8000-000000000020', 'Qualquer nó pode aceitar escritas e propagá-las de forma assíncrona para os demais.', false),
    ('c2a2c2a0-0020-4000-8000-000000000020', 'Os dados são divididos entre os nós, sem que nenhum tenha uma cópia completa.', false),
    ('c2a2c2a0-0020-4000-8000-000000000020', 'Não existe distinção entre os nós: todos leem e escrevem sem qualquer coordenação.', false);

-- Q21 (facil) — Concept 3: Consenso
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0021-4000-8000-000000000021',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0003-4000-8000-000000000003',
    'Qual é o objetivo da eleição de líder em algoritmos de consenso como Raft?',
    'Escolher um único nó responsável por coordenar a replicação do log e receber comandos dos clientes naquele termo, evitando que múltiplos nós tomem decisões conflitantes sobre a mesma posição do log.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0021-4000-8000-000000000021', 'Escolher um único nó para coordenar a replicação do log, evitando decisões conflitantes.', true),
    ('c2a2c2a0-0021-4000-8000-000000000021', 'Dividir os dados entre os nós do cluster de forma balanceada.', false),
    ('c2a2c2a0-0021-4000-8000-000000000021', 'Sincronizar os relógios físicos de todos os nós do cluster.', false),
    ('c2a2c2a0-0021-4000-8000-000000000021', 'Determinar quais clientes têm permissão para se conectar ao sistema.', false);

-- Q22 (facil) — Concept 4: Particionamento
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0022-4000-8000-000000000022',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0004-4000-8000-000000000004',
    'O que é um shard (partição de dados) em um sistema particionado?',
    'Um subconjunto dos dados totais, armazenado e processado por um nó (ou grupo de nós) específico — diferente dos subconjuntos de dados armazenados nos demais nós do sistema.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0022-4000-8000-000000000022', 'Um subconjunto dos dados totais, armazenado por um nó ou grupo específico de nós.', true),
    ('c2a2c2a0-0022-4000-8000-000000000022', 'Uma cópia completa de todos os dados do sistema.', false),
    ('c2a2c2a0-0022-4000-8000-000000000022', 'Um mecanismo temporário de cache de leitura.', false),
    ('c2a2c2a0-0022-4000-8000-000000000022', 'Um algoritmo usado para eleger o líder do cluster.', false);

-- Q23 (facil) — Concept 5: Relógios lógicos e tolerância a falhas
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0023-4000-8000-000000000023',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0005-4000-8000-000000000005',
    'O que é failover em um sistema distribuído tolerante a falhas?',
    'O processo de transferir automaticamente a responsabilidade de um nó que falhou (ou é suspeito de falha) para um nó saudável, geralmente uma réplica, de modo que o sistema continue operando.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0023-4000-8000-000000000023', 'Transferir automaticamente a responsabilidade de um nó falho para um nó saudável.', true),
    ('c2a2c2a0-0023-4000-8000-000000000023', 'Sincronizar relógios físicos entre nós via NTP.', false),
    ('c2a2c2a0-0023-4000-8000-000000000023', 'Dividir os dados do sistema em partições menores.', false),
    ('c2a2c2a0-0023-4000-8000-000000000023', 'O algoritmo que decide o particionamento por hash.', false);

-- Q24 (facil) — Concept 2: Replicação
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0024-4000-8000-000000000024',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0002-4000-8000-000000000002',
    'O que garante a propriedade de consistência "read-your-writes" (leia suas próprias escritas)?',
    'Garante que, após um usuário realizar uma escrita, leituras subsequentes feitas por esse mesmo usuário sempre refletem aquela escrita, mesmo que outros usuários ainda vejam, por um tempo, o valor anterior.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0024-4000-8000-000000000024', 'Que o próprio usuário sempre vê, em leituras seguintes, a escrita que ele mesmo acabou de fazer.', true),
    ('c2a2c2a0-0024-4000-8000-000000000024', 'Que todos os usuários veem imediatamente qualquer escrita feita por qualquer outro usuário.', false),
    ('c2a2c2a0-0024-4000-8000-000000000024', 'Que nenhuma escrita concorrente pode ocorrer no sistema.', false),
    ('c2a2c2a0-0024-4000-8000-000000000024', 'Que os dados nunca precisam ser replicados entre nós.', false);

-- Q25 (media) — Concept 1: CAP Theorem
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0025-4000-8000-000000000025',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0001-4000-8000-000000000001',
    'Mesmo fora de uma partição de rede, sistemas distribuídos ainda enfrentam qual trade-off, segundo a extensão PACELC ao CAP theorem?',
    'Entre latência (Latency) e consistência (Consistency): mesmo sem partição, esperar a confirmação de mais réplicas para garantir consistência forte aumenta a latência percebida da operação.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0025-4000-8000-000000000025', 'Entre latência e consistência: consistência forte tende a custar mais latência, mesmo sem partição.', true),
    ('c2a2c2a0-0025-4000-8000-000000000025', 'Entre segurança da rede e desempenho da CPU.', false),
    ('c2a2c2a0-0025-4000-8000-000000000025', 'Entre número de shards e número de réplicas configuradas.', false),
    ('c2a2c2a0-0025-4000-8000-000000000025', 'Entre CPU e memória disponíveis no nó líder.', false);

-- Q26 (media) — Concept 3: Consenso
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0026-4000-8000-000000000026',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0003-4000-8000-000000000003',
    'Nas duas fases do Paxos clássico, qual é a diferença entre a fase "prepare/promise" e a fase "accept/accepted"?',
    'Na fase prepare/promise, o proposer verifica se pode propor um valor obtendo promessas de uma maioria de acceptors; na fase accept/accepted, o proposer efetivamente envia o valor e obtém confirmação de aceitação da maioria para considerá-lo decidido.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0026-4000-8000-000000000026', 'Prepare/promise verifica se é possível propor; accept/accepted efetiva e confirma o valor decidido.', true),
    ('c2a2c2a0-0026-4000-8000-000000000026', 'Ambas as fases executam exatamente a mesma verificação, como redundância.', false),
    ('c2a2c2a0-0026-4000-8000-000000000026', 'A fase prepare elege um líder permanente e a fase accept nunca mais é executada.', false),
    ('c2a2c2a0-0026-4000-8000-000000000026', 'A fase accept sempre ocorre antes da fase prepare, em ordem inversa.', false);

-- Q27 (media) — Concept 4: Particionamento (quorum de leitura/escrita)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0027-4000-8000-000000000027',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0004-4000-8000-000000000004',
    'Em um esquema de replicação com quorum configurável, sendo N o número de réplicas, W o quorum de escrita e R o quorum de leitura, qual condição garante que toda leitura enxergue a escrita mais recente?',
    'W + R > N garante que o conjunto de réplicas usado em qualquer leitura e o conjunto usado na escrita mais recente necessariamente se sobrepõem em pelo menos um nó, que já contém o valor atualizado.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0027-4000-8000-000000000027', 'W + R > N, pois isso garante sobreposição entre o conjunto de leitura e o de escrita.', true),
    ('c2a2c2a0-0027-4000-8000-000000000027', 'W + R < N, para minimizar a sobreposição entre os conjuntos de réplicas.', false),
    ('c2a2c2a0-0027-4000-8000-000000000027', 'W = R = 1, garantindo sempre a menor latência possível.', false),
    ('c2a2c2a0-0027-4000-8000-000000000027', 'N deve ser sempre um número par para garantir sobreposição.', false);

-- Q28 (media) — Concept 5: Relógios lógicos e tolerância a falhas
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0028-4000-8000-000000000028',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0005-4000-8000-000000000005',
    'Como um detector de falhas "phi accrual" melhora em relação a um timeout fixo simples para suspeitar da falha de um nó?',
    'Ele ajusta dinamicamente o limiar de suspeita com base no histórico de variação de latência da rede, reduzindo falsos positivos em redes instáveis, em vez de usar um único valor fixo de timeout para todos os cenários.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0028-4000-8000-000000000028', 'Ajusta dinamicamente o limiar de suspeita conforme o histórico de variação de latência da rede.', true),
    ('c2a2c2a0-0028-4000-8000-000000000028', 'Elimina totalmente a possibilidade de falsos positivos na detecção de falhas.', false),
    ('c2a2c2a0-0028-4000-8000-000000000028', 'Substitui completamente a necessidade de heartbeats entre os nós.', false),
    ('c2a2c2a0-0028-4000-8000-000000000028', 'Sincroniza os relógios físicos dos nós para detectar falhas com exatidão.', false);

-- Q29 (media) — Concept 2: Replicação (resolução de conflitos)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0029-4000-8000-000000000029',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0002-4000-8000-000000000002',
    'Por que a estratégia de resolução de conflito "last-write-wins" (LWW), baseada em timestamp, é arriscada em sistemas com múltiplos líderes?',
    'Porque relógios físicos entre nós podem estar dessincronizados (drift), fazendo com que uma escrita mais recente na realidade seja descartada silenciosamente por carregar um timestamp menor que uma escrita concorrente, causando perda de dados sem aviso.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0029-4000-8000-000000000029', 'Drift entre relógios físicos pode fazer uma escrita mais recente ser descartada silenciosamente.', true),
    ('c2a2c2a0-0029-4000-8000-000000000029', 'Porque LWW exige obrigatoriamente consenso via Raft antes de qualquer escrita.', false),
    ('c2a2c2a0-0029-4000-8000-000000000029', 'Porque LWW impede fisicamente a existência de mais de um líder no sistema.', false),
    ('c2a2c2a0-0029-4000-8000-000000000029', 'Porque LWW só pode ser usada em sistemas com um único nó.', false);

-- Q30 (media) — Concept 4: Particionamento (virtual nodes)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0030-4000-8000-000000000030',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0004-4000-8000-000000000004',
    'Por que "nós virtuais" (virtual nodes) costumam ser usados junto com consistent hashing?',
    'Para distribuir a carga de forma mais uniforme entre os nós físicos: cada nó físico recebe várias posições (nós virtuais) no anel de hash, evitando que um nó físico fique sobrecarregado por ocupar, por acaso, uma faixa muito grande do anel.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0030-4000-8000-000000000030', 'Para distribuir a carga de forma mais uniforme, dando a cada nó físico várias posições no anel.', true),
    ('c2a2c2a0-0030-4000-8000-000000000030', 'Para eliminar completamente a necessidade do anel de hash.', false),
    ('c2a2c2a0-0030-4000-8000-000000000030', 'Para substituir a necessidade de replicação dos shards.', false),
    ('c2a2c2a0-0030-4000-8000-000000000030', 'Para garantir que apenas um nó físico exista no cluster.', false);

-- Q31 (dificil) — Concept 1: CAP Theorem
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0031-4000-8000-000000000031',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0001-4000-8000-000000000001',
    'Por que um sistema "CA" (Consistency + Availability, sem Partition Tolerance) é considerado, na prática, apenas um caso teórico ou limitado a um único nó?',
    'Porque garantir simultaneamente consistência e disponibilidade sem tolerar partição exige que a rede entre os nós nunca falhe — algo inatingível em qualquer sistema distribuído real com mais de um nó; "CA" só é sustentável quando não há distribuição de fato (um único nó, onde partição não é sequer um conceito aplicável).',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0031-4000-8000-000000000031', 'Porque exige uma rede que nunca falha, o que só é realista sem distribuição de fato (um único nó).', true),
    ('c2a2c2a0-0031-4000-8000-000000000031', 'Porque CA é matematicamente impossível mesmo em um único nó.', false),
    ('c2a2c2a0-0031-4000-8000-000000000031', 'Porque CA exige mais hardware do que CP ou AP.', false),
    ('c2a2c2a0-0031-4000-8000-000000000031', 'Porque nenhum banco de dados comercial jamais implementou uma configuração CA.', false);

-- Q32 (dificil) — Concept 3: Consenso (split-brain)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0032-4000-8000-000000000032',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0003-4000-8000-000000000003',
    'Como o requisito de quorum (maioria) em algoritmos de consenso previne uma situação de "split-brain", em que duas partições da rede decidem valores conflitantes de forma independente?',
    'Como quorum exige mais da metade dos nós, é matematicamente impossível que duas partições disjuntas da rede atinjam quorum ao mesmo tempo — no máximo uma delas pode conter a maioria, então apenas essa partição pode progredir e tomar decisões válidas.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0032-4000-8000-000000000032', 'No máximo uma partição de rede disjunta pode conter a maioria dos nós, então só ela progride.', true),
    ('c2a2c2a0-0032-4000-8000-000000000032', 'Porque cada partição de rede automaticamente elege o mesmo líder.', false),
    ('c2a2c2a0-0032-4000-8000-000000000032', 'Porque split-brain é impedido pela replicação assíncrona, não pelo quorum.', false),
    ('c2a2c2a0-0032-4000-8000-000000000032', 'Porque quorum garante que todas as partições de rede se comuniquem periodicamente.', false);

-- Q33 (dificil) — Concept 5: Relógios lógicos (limitação de escala de vector clocks)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0033-4000-8000-000000000033',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0005-4000-8000-000000000005',
    'Qual é a principal limitação de escalabilidade dos vector clocks em sistemas distribuídos com um número grande e crescente de nós?',
    'O tamanho do vetor cresce proporcionalmente ao número de nós do sistema, já que cada nó precisa manter um contador para cada um dos outros nós — em sistemas com milhares de nós, isso torna o overhead de armazenamento e transmissão do vetor impraticável.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0033-4000-8000-000000000033', 'O vetor cresce proporcionalmente ao número de nós, tornando o overhead impraticável em grande escala.', true),
    ('c2a2c2a0-0033-4000-8000-000000000033', 'Vector clocks deixam de funcionar corretamente com mais de dois nós.', false),
    ('c2a2c2a0-0033-4000-8000-000000000033', 'Vector clocks exigem que todos os nós compartilhem o mesmo relógio físico.', false),
    ('c2a2c2a0-0033-4000-8000-000000000033', 'Vector clocks tornam impossível detectar qualquer relação causal entre eventos.', false);

-- Q34 (dificil) — Concept 4: Particionamento (hotspot mesmo com hash)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0034-4000-8000-000000000034',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0004-4000-8000-000000000004',
    'Mesmo usando particionamento por hash (que distribui chaves de forma uniforme em teoria), por que um shard específico ainda pode se tornar um hotspot na prática?',
    'Porque a distribuição uniforme do hash pressupõe um padrão de acesso uniforme entre as chaves; se um pequeno subconjunto de chaves (ex.: um usuário ou produto muito popular) receber uma parcela desproporcional das requisições, o shard que armazena essas chaves fica sobrecarregado, independentemente de como o hash distribuiu o espaço de chaves.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0034-4000-8000-000000000034', 'Porque o padrão de acesso pode ser desigual entre chaves, mesmo com o espaço de chaves distribuído uniformemente.', true),
    ('c2a2c2a0-0034-4000-8000-000000000034', 'Porque particionamento por hash sempre distribui volumes de dados desiguais entre os shards.', false),
    ('c2a2c2a0-0034-4000-8000-000000000034', 'Porque hotspots só podem ocorrer em particionamento por range, nunca por hash.', false),
    ('c2a2c2a0-0034-4000-8000-000000000034', 'Porque hashing sempre atribui múltiplas chaves populares ao mesmo shard por definição do algoritmo.', false);

-- Q35 (dificil) — Concept 2: Replicação (monotonic reads)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0035-4000-8000-000000000035',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0002-4000-8000-000000000002',
    'O que a garantia de consistência "monotonic reads" evita que consistência eventual pura, sozinha, não evita?',
    'Evita que um mesmo usuário, ao fazer leituras sucessivas, veja o tempo "andar para trás" — ou seja, depois de ler um valor mais recente de uma réplica, uma leitura seguinte (possivelmente servida por outra réplica menos atualizada) não pode retornar um valor mais antigo para esse mesmo usuário.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0035-4000-8000-000000000035', 'Que o mesmo usuário veja, em leituras sucessivas, um valor mais antigo do que já havia lido antes.', true),
    ('c2a2c2a0-0035-4000-8000-000000000035', 'Que réplicas diferentes cheguem a valores diferentes para sempre.', false),
    ('c2a2c2a0-0035-4000-8000-000000000035', 'Qualquer necessidade de replicação assíncrona no sistema.', false),
    ('c2a2c2a0-0035-4000-8000-000000000035', 'Que escritas sejam confirmadas de forma síncrona por todas as réplicas.', false);

-- Q36 (dificil) — Concept 3: Consenso (gossip vs. heartbeat centralizado)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0036-4000-8000-000000000036',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0003-4000-8000-000000000003',
    'Como um protocolo de gossip para detecção de falhas e membership difere fundamentalmente de um esquema de heartbeat centralizado?',
    'Em gossip, cada nó troca periodicamente informações de estado (incluindo suspeitas de falha) com um subconjunto aleatório de outros nós, propagando o conhecimento de forma descentralizada e escalável pelo cluster; um esquema de heartbeat centralizado depende de um coordenador único receber sinais de todos os nós, criando um ponto único de sobrecarga e de falha.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0036-4000-8000-000000000036', 'Gossip propaga o estado de forma descentralizada entre pares; heartbeat centralizado depende de um coordenador único.', true),
    ('c2a2c2a0-0036-4000-8000-000000000036', 'Gossip exige que todos os nós se comuniquem diretamente com todos os outros a cada ciclo, sem exceção.', false),
    ('c2a2c2a0-0036-4000-8000-000000000036', 'Gossip elimina totalmente a possibilidade de falsos positivos na detecção de falhas.', false),
    ('c2a2c2a0-0036-4000-8000-000000000036', 'Heartbeat centralizado é mais escalável que gossip para clusters muito grandes.', false);
