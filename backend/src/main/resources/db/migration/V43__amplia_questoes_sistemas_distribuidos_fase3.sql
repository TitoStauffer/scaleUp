-- Ampliação do pool de Questions do domínio Sistemas Distribuídos (Fase 3 de
-- TICKET-content-expansion-questoes-fase3.md, migração reservada V43 para este domínio).
--
-- Adiciona 18 Questions NOVAS (6 fácil / 6 média / 6 difícil) com 4 alternativas cada
-- (72 alternativas), elevando o pool do domínio de 54 (seed V15 + Fase 1 V27 + Fase 2 V36)
-- para 72 Questions.
--
-- Regras seguidas (mesmas de V15/V27/V36, sem alteração):
--   - content_version = 'v1', status_revisao = 'rascunho'.
--   - domain_ref via subquery em domain.slug = 'sistemas-distribuidos' (mesmo mecanismo).
--   - concept_ref aponta para um dos 5 Concepts já existentes (UUIDs literais reaproveitados
--     de V15) — nenhum Concept novo criado nesta migração.
--   - Nenhum INSERT em domain/concept/slide/flashcard — apenas question/question_alternative.
--
-- Não-duplicação: V15 (Q1–Q18, ids ...-0001..-0018), V27 (Q19–Q36, ids ...-0019..-0036) e
-- V36 (Q37–Q54, ids ...-0037..-0054) foram lidos integralmente antes de escrever este arquivo.
-- Os 54 enunciados já existentes cobrem, entre outros pontos: definição isolada de C/A/P,
-- mito do "escolha 2 de 3", PACELC, caso teórico CA, classificação CP/AP de exemplos
-- concretos, prova do CAP assumindo consistência atômica (e consistência causal como exceção);
-- replicação síncrona x assíncrona, single-leader x leaderless, stale reads, consistência
-- forte/eventual/causal/sintonizável, read-your-writes, monotonic reads, conflito em
-- multi-leader, last-write-wins, read repair, anti-entropy; definição de quorum, fases do
-- Paxos, eleição de líder e termo no Raft, regra de segurança de voto, tolerância 2f+1,
-- teorema FLP, split-brain via quorum, gossip x heartbeat centralizado, crash-stop x
-- bizantino (modelo, sem a fórmula de quorum bizantino), replicação de máquina de estados
-- (sem log compaction), 2PC bloqueante x Raft, leitura segura do líder via lease (safety da
-- leitura, não o mecanismo de lease em si); sharding x replicação, hash x range, consistent
-- hashing, virtual nodes, fórmula W+R>N (sem exemplo numérico aplicado), rebalanceamento,
-- número fixo de partições, índice local x global, particionamento por diretório, hotspot em
-- hash e range, sloppy quorum e hinted handoff; relógios físicos insuficientes, Lamport,
-- vector clocks e limite de escala, phi accrual, heartbeats/timeouts, failover, clock
-- skew/NTP, TrueTime/Spanner, gray failure.
--
-- As 18 Questions desta leva testam ângulos deliberadamente não cobertos acima: distinção
-- entre tolerância a partição (P) e tolerância a falha de nó isolada; locks distribuídos e
-- fencing tokens (incluindo a crítica de Kleppmann a TTL puro em esquemas como Redlock);
-- semânticas de entrega at-least-once x at-most-once e a inatingibilidade de exactly-once
-- delivery na camada de rede (resolvida via idempotência no receptor); algoritmo Bully de
-- eleição de líder (contraste com Raft); CRDTs como alternativa a LWW para merge sem
-- coordenação; Saga pattern como alternativa ao 2PC; quorum bizantino 3f+1 (contraste
-- explícito com 2f+1 de crash-stop); liderança baseada em lease/clock (estilo Chubby) e risco
-- de drift; log compaction/snapshot em replicação de máquina de estados; e distributed tracing
-- (trace/span, correlação com replicação de log e interação com clock skew).

-- ============================================================================
-- QUESTIONS + ALTERNATIVAS (18 novas: 6 fácil, 6 média, 6 difícil)
-- ============================================================================

-- Q55 (facil) — Concept 1: CAP Theorem
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0055-4000-8000-000000000055',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0001-4000-8000-000000000001',
    'No CAP theorem, a propriedade "Partition Tolerance" (P) se refere especificamente a qual tipo de falha?',
    'P se refere a falhas de comunicação entre nós (mensagens perdidas ou atrasadas na rede), não à falha (crash) de um nó individual isolado. Um nó pode cair sem que isso caracterize uma partição de rede entre os nós restantes.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0055-4000-8000-000000000055', 'Falhas de comunicação de rede entre nós, como mensagens perdidas ou atrasadas.', true),
    ('c2a2c2a0-0055-4000-8000-000000000055', 'O crash (parada completa) de um nó individual, isoladamente.', false),
    ('c2a2c2a0-0055-4000-8000-000000000055', 'A perda de dados em disco de um nó específico.', false),
    ('c2a2c2a0-0055-4000-8000-000000000055', 'A indisponibilidade total do sistema por manutenção planejada.', false);

-- Q56 (facil) — Concept 3: Consenso (distributed lock)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0056-4000-8000-000000000056',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0003-4000-8000-000000000003',
    'Que problema um lock distribuído resolve que um mutex (lock) em memória local, dentro de um único processo, não é capaz de resolver?',
    'Um mutex local só coordena threads dentro do mesmo processo/máquina. Um lock distribuído garante exclusão mútua entre processos rodando em máquinas diferentes, que não compartilham memória, permitindo que apenas um deles execute uma seção crítica (ex.: processar um mesmo job) por vez.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0056-4000-8000-000000000056', 'Garantir exclusão mútua entre processos rodando em máquinas diferentes, sem memória compartilhada.', true),
    ('c2a2c2a0-0056-4000-8000-000000000056', 'Acelerar o acesso a dados em cache dentro de um único processo.', false),
    ('c2a2c2a0-0056-4000-8000-000000000056', 'Substituir a necessidade de replicação de dados entre nós.', false),
    ('c2a2c2a0-0056-4000-8000-000000000056', 'Eliminar a necessidade de sincronização entre threads de um mesmo processo.', false);

-- Q57 (facil) — Concept 3: Consenso (at-least-once)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0057-4000-8000-000000000057',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0003-4000-8000-000000000003',
    'O que caracteriza a semântica de entrega "at-least-once" (pelo menos uma vez) em comunicação distribuída?',
    'At-least-once garante que uma mensagem nunca é perdida — o emissor reenvia até receber confirmação —, mas isso pode causar entregas duplicadas se a confirmação se perder mesmo após o receptor ter processado a mensagem, exigindo que o receptor trate duplicatas.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0057-4000-8000-000000000057', 'A mensagem nunca é perdida, mas pode ser entregue mais de uma vez.', true),
    ('c2a2c2a0-0057-4000-8000-000000000057', 'A mensagem é entregue exatamente uma vez, sem exceção.', false),
    ('c2a2c2a0-0057-4000-8000-000000000057', 'A mensagem pode ser perdida, mas nunca duplicada.', false),
    ('c2a2c2a0-0057-4000-8000-000000000057', 'A mensagem só é enviada se o receptor estiver comprovadamente disponível.', false);

-- Q58 (facil) — Concept 3: Consenso (at-most-once)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0058-4000-8000-000000000058',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0003-4000-8000-000000000003',
    'Em contraste com "at-least-once", o que caracteriza a semântica de entrega "at-most-once" (no máximo uma vez)?',
    'At-most-once garante que uma mensagem nunca é entregue mais de uma vez — não há reenvio automático em caso de dúvida —, mas isso significa que, se a confirmação ou a própria mensagem se perder, ela pode nunca chegar ao destino, priorizando ausência de duplicatas sobre garantia de entrega.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0058-4000-8000-000000000058', 'A mensagem nunca é duplicada, mas pode ser perdida sem reenvio.', true),
    ('c2a2c2a0-0058-4000-8000-000000000058', 'A mensagem é sempre reenviada até haver confirmação de entrega.', false),
    ('c2a2c2a0-0058-4000-8000-000000000058', 'A mensagem é entregue simultaneamente a todos os consumidores possíveis.', false),
    ('c2a2c2a0-0058-4000-8000-000000000058', 'A mensagem é garantida como entregue exatamente uma vez, sempre.', false);

-- Q59 (facil) — Concept 5: Relógios lógicos e tolerância a falhas (tracing)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0059-4000-8000-000000000059',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0005-4000-8000-000000000005',
    'Para que serve um "trace" com seus "spans" em distributed tracing?',
    'Um trace identifica uma requisição única enquanto ela atravessa múltiplos serviços/nós de um sistema distribuído, e cada span representa uma etapa (ex.: uma chamada a um serviço específico) dentro desse trace — juntos, permitem reconstruir o caminho completo e o tempo gasto em cada etapa de uma operação distribuída.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0059-4000-8000-000000000059', 'Correlacionar e reconstruir o caminho e o tempo de uma requisição ao atravessar múltiplos serviços/nós.', true),
    ('c2a2c2a0-0059-4000-8000-000000000059', 'Substituir a necessidade de logs de erro em cada serviço.', false),
    ('c2a2c2a0-0059-4000-8000-000000000059', 'Sincronizar os relógios físicos de todos os nós envolvidos na requisição.', false),
    ('c2a2c2a0-0059-4000-8000-000000000059', 'Determinar automaticamente qual nó deve ser o líder do cluster.', false);

-- Q60 (facil) — Concept 2: Replicação (idempotência)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0060-4000-8000-000000000060',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0002-4000-8000-000000000002',
    'Por que tornar o processamento de uma mensagem idempotente é a estratégia prática mais comum para lidar com entregas duplicadas de uma semântica "at-least-once"?',
    'Como at-least-once pode entregar a mesma mensagem mais de uma vez, um processamento idempotente (que produz o mesmo resultado final independentemente de quantas vezes é aplicado, ex.: usando uma chave de deduplicação) permite que o sistema se comporte, do ponto de vista do efeito observável, como se fosse "exactly-once", mesmo sem essa garantia existir na camada de entrega.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0060-4000-8000-000000000060', 'Porque processar a mesma mensagem mais de uma vez produz o mesmo resultado final, neutralizando o efeito das duplicatas.', true),
    ('c2a2c2a0-0060-4000-8000-000000000060', 'Porque idempotência impede fisicamente que uma mensagem seja reenviada pela rede.', false),
    ('c2a2c2a0-0060-4000-8000-000000000060', 'Porque idempotência elimina a necessidade de replicação de dados entre nós.', false),
    ('c2a2c2a0-0060-4000-8000-000000000060', 'Porque idempotência converte automaticamente a semântica em at-most-once.', false);

-- Q61 (media) — Concept 3: Consenso (Bully algorithm)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0061-4000-8000-000000000061',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0003-4000-8000-000000000003',
    'Como o algoritmo Bully de eleição de líder decide qual nó se torna líder, e em que isso difere da eleição do Raft?',
    'No algoritmo Bully, quando um nó suspeita que o líder falhou, ele notifica os nós de maior identificador; o nó vivo com o maior identificador numérico "vence" e se torna líder, sem considerar o estado do log de dados. No Raft, a eleição depende de votos de maioria e da atualidade do log de cada candidato (não apenas de um identificador fixo), garantindo que o novo líder tenha todas as operações já confirmadas.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0061-4000-8000-000000000061', 'O nó vivo de maior identificador numérico vence, sem considerar o estado do log de dados — diferente do Raft, que exige log atualizado para ganhar votos.', true),
    ('c2a2c2a0-0061-4000-8000-000000000061', 'O algoritmo Bully e o Raft usam exatamente o mesmo critério: log mais atualizado vence.', false),
    ('c2a2c2a0-0061-4000-8000-000000000061', 'O algoritmo Bully escolhe o líder por sorteio aleatório entre os nós disponíveis.', false),
    ('c2a2c2a0-0061-4000-8000-000000000061', 'O algoritmo Bully não permite reeleição depois que um líder é escolhido pela primeira vez.', false);

-- Q62 (media) — Concept 3: Consenso (fencing tokens)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0062-4000-8000-000000000062',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0003-4000-8000-000000000003',
    'Qual problema um "fencing token" (contador monotonicamente crescente emitido junto com um lock distribuído) resolve?',
    'Sem fencing token, um cliente que obteve o lock mas ficou momentaneamente pausado (ex.: garbage collection longo) pode, ao "acordar", acreditar que ainda o detém e escrever no recurso protegido mesmo depois de o lock ter expirado e sido concedido a outro cliente. O fencing token permite que o recurso protegido rejeite escritas com um token mais antigo que o último já aceito, prevenindo essa corrupção.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0062-4000-8000-000000000062', 'Impede que um cliente com o lock expirado (ex.: após uma pausa longa) corrompa dados escrevendo com um token mais antigo que o já aceito.', true),
    ('c2a2c2a0-0062-4000-8000-000000000062', 'Elimina completamente a necessidade de expirar locks distribuídos por TTL.', false),
    ('c2a2c2a0-0062-4000-8000-000000000062', 'Sincroniza os relógios físicos dos clientes que disputam o lock.', false),
    ('c2a2c2a0-0062-4000-8000-000000000062', 'Garante que o lock nunca precise ser liberado explicitamente pelo cliente.', false);

-- Q63 (media) — Concept 2: Replicação (CRDTs)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0063-4000-8000-000000000063',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0002-4000-8000-000000000002',
    'O que um CRDT (Conflict-free Replicated Data Type) oferece que o torna uma alternativa a "last-write-wins" para resolver escritas concorrentes em réplicas diferentes?',
    'Um CRDT é projetado matematicamente (com operações comutativas, associativas e idempotentes) de forma que réplicas que receberam atualizações concorrentes em ordens diferentes sempre convergem para o mesmo estado final ao serem mescladas, sem descartar nenhuma escrita como o last-write-wins faz — em vez de "vencer", as atualizações são combinadas (ex.: um contador que soma incrementos de todas as réplicas).',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0063-4000-8000-000000000063', 'Convergência garantida ao mesclar atualizações concorrentes sem descartar nenhuma escrita, diferente do descarte que ocorre em last-write-wins.', true),
    ('c2a2c2a0-0063-4000-8000-000000000063', 'Elimina totalmente a necessidade de replicar dados entre nós.', false),
    ('c2a2c2a0-0063-4000-8000-000000000063', 'Exige que todas as escritas passem obrigatoriamente por um único nó líder.', false),
    ('c2a2c2a0-0063-4000-8000-000000000063', 'Garante consistência forte equivalente a um sistema com replicação síncrona.', false);

-- Q64 (media) — Concept 5: Relógios lógicos e tolerância a falhas (tracing + replicação)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0064-4000-8000-000000000064',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0005-4000-8000-000000000005',
    'Como distributed tracing pode ajudar a diagnosticar uma escrita lenta em um cluster Raft, correlacionando os spans de uma requisição?',
    'Ao propagar um mesmo trace ID pela chamada do cliente ao líder e pelas mensagens de replicação de log do líder para cada seguidor, é possível visualizar, span a span, quanto tempo cada seguidor levou para confirmar a entrada — revelando, por exemplo, se um seguidor específico está consistentemente lento e atrasando a confirmação por maioria, algo que métricas agregadas isoladas não deixam claro por requisição individual.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0064-4000-8000-000000000064', 'Permite visualizar, por requisição, o tempo de confirmação de cada seguidor, revelando qual deles atrasa a maioria necessária.', true),
    ('c2a2c2a0-0064-4000-8000-000000000064', 'Substitui a necessidade de o líder aguardar confirmação de maioria antes de responder ao cliente.', false),
    ('c2a2c2a0-0064-4000-8000-000000000064', 'Garante automaticamente que o cluster elegerá um novo líder mais rápido.', false),
    ('c2a2c2a0-0064-4000-8000-000000000064', 'Elimina a necessidade de heartbeats entre líder e seguidores.', false);

-- Q65 (media) — Concept 4: Particionamento (quorum numérico concreto)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0065-4000-8000-000000000065',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0004-4000-8000-000000000004',
    'Em um sistema com N=5 réplicas configurado com quorum de escrita W=3 e quorum de leitura R=2, uma leitura tem garantia de sempre enxergar a escrita confirmada mais recente?',
    'Não: W + R = 5, que não é maior que N = 5, então não há garantia matemática de sobreposição entre o conjunto de réplicas usado na escrita e o usado na leitura. Seria necessário, por exemplo, R=3 (W+R=6 > N=5) para garantir que ao menos uma réplica lida também tenha recebido a última escrita.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0065-4000-8000-000000000065', 'Não, pois W + R = N (5 = 5), não havendo garantia de sobreposição entre os conjuntos de réplicas.', true),
    ('c2a2c2a0-0065-4000-8000-000000000065', 'Sim, pois W e R juntos já cobrem mais da metade das réplicas.', false),
    ('c2a2c2a0-0065-4000-8000-000000000065', 'Sim, desde que as réplicas estejam na mesma região geográfica.', false),
    ('c2a2c2a0-0065-4000-8000-000000000065', 'Não é possível responder sem saber qual algoritmo de consenso está em uso.', false);

-- Q66 (media) — Concept 3: Consenso (Saga pattern)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0066-4000-8000-000000000066',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0003-4000-8000-000000000003',
    'Como o padrão Saga coordena uma transação que abrange múltiplos serviços distribuídos, sem usar um protocolo bloqueante como o 2PC?',
    'Uma Saga decompõe a transação em uma sequência de passos locais, cada um com uma "transação compensatória" correspondente. Se um passo falhar no meio da sequência, o sistema executa as compensações dos passos já concluídos, na ordem inversa, para desfazer o efeito parcial — em vez de manter recursos bloqueados esperando uma decisão de commit global como no 2PC.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0066-4000-8000-000000000066', 'Executa uma sequência de passos locais com transações compensatórias que desfazem o efeito de passos já concluídos em caso de falha.', true),
    ('c2a2c2a0-0066-4000-8000-000000000066', 'Exige que todos os serviços envolvidos votem simultaneamente antes de qualquer passo ser executado.', false),
    ('c2a2c2a0-0066-4000-8000-000000000066', 'Bloqueia todos os recursos de todos os serviços até que o último passo seja confirmado.', false),
    ('c2a2c2a0-0066-4000-8000-000000000066', 'Substitui a necessidade de qualquer tratamento de erro nos serviços participantes.', false);

-- Q67 (dificil) — Concept 3: Consenso (BFT quorum 3f+1)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0067-4000-8000-000000000067',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0003-4000-8000-000000000003',
    'Por que algoritmos de consenso tolerantes a falhas bizantinas (BFT) exigem um cluster de 3f+1 nós para tolerar f nós maliciosos, em vez dos 2f+1 nós suficientes em algoritmos como Raft sob o modelo crash-stop?',
    'Sob falhas bizantinas, um nó defeituoso pode mentir ativamente, inclusive votando de forma diferente para observadores diferentes. Para garantir que a maioria de respostas honestas ainda supere qualquer combinação possível entre nós maliciosos e uma possível partição, é necessário que os nós honestos superem em número os nós maliciosos por uma margem maior — o que a aritmética de 3f+1 (com no máximo f nós falhos) garante, mas 2f+1 não garante quando as falhas podem ser deliberadamente enganosas.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0067-4000-8000-000000000067', 'Porque nós bizantinos podem mentir ativamente, exigindo uma margem maior de nós honestos para garantir uma decisão correta e única.', true),
    ('c2a2c2a0-0067-4000-8000-000000000067', 'Porque BFT sempre precisa de mais réplicas de dados do que crash-stop, independentemente de consenso.', false),
    ('c2a2c2a0-0067-4000-8000-000000000067', 'Porque 3f+1 é apenas uma convenção histórica, sem relação com a matemática do quorum.', false),
    ('c2a2c2a0-0067-4000-8000-000000000067', 'Porque nós bizantinos consomem o triplo de largura de banda de rede que nós crash-stop.', false);

-- Q68 (dificil) — Concept 3: Consenso (lease-based leadership)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0068-4000-8000-000000000068',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0003-4000-8000-000000000003',
    'Em um esquema de liderança baseada em "lease" (concessão temporária de liderança por um período, ao estilo Chubby), qual risco concreto surge se o relógio local do líder atual e o dos demais nós tiverem um drift (desvio) significativo entre si?',
    'Se o relógio do líder atual atrasar em relação ao dos demais nós, ele pode acreditar que seu lease ainda é válido (segundo seu próprio relógio) enquanto os outros nós já consideram o lease expirado e elegem um novo líder — abrindo uma janela em que dois nós agem como líder simultaneamente, violando a garantia de líder único que o esquema deveria assegurar.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0068-4000-8000-000000000068', 'O líder antigo pode acreditar que seu lease ainda é válido enquanto os demais já elegeram um novo líder, causando dois líderes simultâneos.', true),
    ('c2a2c2a0-0068-4000-8000-000000000068', 'O cluster perde permanentemente a capacidade de eleger qualquer líder novo.', false),
    ('c2a2c2a0-0068-4000-8000-000000000068', 'O drift de relógio impede fisicamente que mensagens de heartbeat sejam enviadas.', false),
    ('c2a2c2a0-0068-4000-8000-000000000068', 'Leases eliminam qualquer dependência de relógio, tornando esse risco inexistente por definição.', false);

-- Q69 (dificil) — Concept 2: Replicação (log compaction / snapshot)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0069-4000-8000-000000000069',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0002-4000-8000-000000000002',
    'Por que sistemas que usam replicação de máquina de estados via log replicado (como o Raft) precisam de um mecanismo de "log compaction" (compactação por snapshot)?',
    'Sem compaction, o log cresceria indefinidamente, já que toda operação já aplicada continuaria armazenada — isso aumentaria sem limite o tempo de recuperação de um nó que reinicia (precisaria reprocessar todo o histórico) e o espaço em disco necessário. Um snapshot periódico captura o estado atual da máquina de estados, permitindo descartar com segurança as entradas de log anteriores a ele, já que seu efeito está capturado no snapshot.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0069-4000-8000-000000000069', 'Para evitar que o log cresça indefinidamente, permitindo descartar entradas antigas cujo efeito já está capturado em um snapshot do estado atual.', true),
    ('c2a2c2a0-0069-4000-8000-000000000069', 'Para acelerar a eleição de líder, já que candidatos com log compactado sempre vencem.', false),
    ('c2a2c2a0-0069-4000-8000-000000000069', 'Para substituir a necessidade de replicar o log entre os nós seguidores.', false),
    ('c2a2c2a0-0069-4000-8000-000000000069', 'Para permitir que o sistema tolere falhas bizantinas além das falhas crash-stop.', false);

-- Q70 (dificil) — Concept 5: Relógios lógicos (tracing + clock skew)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0070-4000-8000-000000000070',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0005-4000-8000-000000000005',
    'Por que ordenar os spans de um trace distribuído apenas pelos timestamps de wall-clock registrados localmente em cada serviço pode enganar sobre a real ordem causal dos eventos?',
    'Como cada serviço registra o timestamp com seu próprio relógio físico, e relógios físicos entre máquinas sofrem clock skew, é possível que um span filho (que só pôde começar depois que o span pai o chamou) apareça, pelo timestamp, como tendo iniciado antes do span pai — uma inversão de causalidade aparente causada puramente pela imprecisão da sincronização de relógios, não por um problema real no fluxo da requisição.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0070-4000-8000-000000000070', 'Porque clock skew entre os relógios físicos dos serviços pode fazer um span filho parecer ter começado antes do span pai que o originou.', true),
    ('c2a2c2a0-0070-4000-8000-000000000070', 'Porque spans nunca carregam informação de tempo, apenas de identificador.', false),
    ('c2a2c2a0-0070-4000-8000-000000000070', 'Porque distributed tracing exige obrigatoriamente vector clocks para funcionar.', false),
    ('c2a2c2a0-0070-4000-8000-000000000070', 'Porque a ordem causal entre spans é sempre garantida pelo protocolo HTTP, independentemente do relógio.', false);

-- Q71 (dificil) — Concept 4: Particionamento (crítica de Kleppmann ao Redlock)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0071-4000-8000-000000000071',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0004-4000-8000-000000000004',
    'Por que confiar apenas em um TTL (tempo de expiração) para garantir a segurança de um lock distribuído, sem fencing token, é arriscado mesmo quando o lock foi obtido com quorum entre múltiplos nós (ao estilo Redlock)?',
    'Uma pausa longa e imprevisível no cliente que detém o lock (ex.: garbage collection, swap de memória, ou uma pausa de rede) pode fazer o TTL expirar e o lock ser concedido a outro cliente antes que o primeiro "acorde" e continue escrevendo no recurso protegido, acreditando ainda deter o lock — o quorum na obtenção do lock não protege contra esse cenário, porque a violação ocorre depois, na escrita ao recurso, não na obtenção do lock em si.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0071-4000-8000-000000000071', 'Uma pausa longa no cliente pode fazer o TTL expirar e o lock ser concedido a outro, sem que o primeiro cliente saiba disso ao retomar a execução e escrever no recurso.', true),
    ('c2a2c2a0-0071-4000-8000-000000000071', 'Porque TTLs não podem ser implementados em sistemas com múltiplos nós de lock.', false),
    ('c2a2c2a0-0071-4000-8000-000000000071', 'Porque quorum na obtenção do lock impede fisicamente qualquer pausa no cliente.', false),
    ('c2a2c2a0-0071-4000-8000-000000000071', 'Porque Redlock exige obrigatoriamente um algoritmo de consenso como Raft para funcionar.', false);

-- Q72 (dificil) — Concept 3: Consenso (impossibilidade de exactly-once delivery)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    'c2a2c2a0-0072-4000-8000-000000000072',
    (SELECT id FROM domain WHERE slug = 'sistemas-distribuidos'),
    'b1a1c1a0-0003-4000-8000-000000000003',
    'Por que "exactly-once delivery" (entrega exatamente uma vez) é considerada inatingível na camada pura de rede, sendo, na prática, obtida apenas como um efeito observável combinando at-least-once com processamento idempotente?',
    'Na camada de rede, o emissor nunca tem certeza absoluta de que uma mensagem chegou e foi processada apenas pela ausência de confirmação (que pode ter se perdido, não a mensagem) — então ele só pode escolher entre arriscar duplicar (reenviando, at-least-once) ou arriscar perder (não reenviando, at-most-once). "Exactly-once" na prática significa exactly-once effect: a mensagem pode ser entregue mais de uma vez na rede (at-least-once), mas o processamento idempotente no receptor garante que o efeito final seja equivalente a processá-la uma única vez.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c2a2c2a0-0072-4000-8000-000000000072', 'Porque o emissor nunca sabe com certeza se uma falta de confirmação significa mensagem perdida ou confirmação perdida, então só pode escolher entre arriscar duplicar ou arriscar perder — o "exactly-once" real vem do efeito idempotente no receptor, não da entrega em si.', true),
    ('c2a2c2a0-0072-4000-8000-000000000072', 'Porque exactly-once delivery já é garantido nativamente por qualquer protocolo de rede moderno, como o TCP.', false),
    ('c2a2c2a0-0072-4000-8000-000000000072', 'Porque exactly-once só é impossível quando o sistema usa replicação leaderless.', false),
    ('c2a2c2a0-0072-4000-8000-000000000072', 'Porque idempotência é incompatível com semânticas at-least-once.', false);
