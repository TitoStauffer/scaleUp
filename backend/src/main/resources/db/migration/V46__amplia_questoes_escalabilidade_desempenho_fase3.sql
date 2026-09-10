-- Ampliação do pool de Questions (Fase 3) — Domínio: Escalabilidade e Desempenho (slug: escalabilidade-desempenho)
-- Fase 3 do TICKET-content-expansion-questoes-fase3.md (ver também TICKET-content-database.md,
-- TICKET-content-expansion-questoes.md — Fase 1 — e TICKET-content-expansion-questoes-fase2.md — Fase 2).
--
-- Escopo: apenas Question + Alternativas. Nenhum Concept/Slide/Flashcard novo — reaproveita
-- os 5 Concepts já criados em V18__seed_conteudo_escalabilidade_desempenho.sql.
--
-- Conteúdo rascunhado por IA (autoria assistida), pendente de revisão humana antes de
-- produção — todo item usa content_version = 'v1' e status_revisao = 'rascunho', mesma
-- convenção dos lotes anteriores (V18, V30 e V39).
--
-- Não-duplicação: as 18 Questions abaixo foram escritas após leitura integral das três fases
-- anteriores deste domínio — V18__seed_conteudo_escalabilidade_desempenho.sql (18 Questions),
-- V30__amplia_questoes_escalabilidade_desempenho.sql (18 Questions) e
-- V39__amplia_questoes_escalabilidade_desempenho_fase2.sql (18 Questions), 54 no total — e
-- cobrem ângulos ainda não testados por elas: autoscaling reativo vs. preditivo, invalidação
-- (purge) de CDN e versionamento de URL como alternativa, connection draining em load balancer
-- durante deploy, write amplification (inclusive seu efeito multiplicativo entre índices,
-- réplicas e particionamento), backpressure (e sua diferença conceitual de rate limiting),
-- compressão de payload como trade-off CPU vs. banda, roteamento de leitura/escrita entre
-- primário e réplicas, esgotamento de pool de conexões sob alta concorrência, circuit breaker
-- (comportamento básico e por que abrir preventivamente evita falha em cascata), hedged
-- requests para reduzir latência de cauda (p99), e um cenário de estado compartilhado em
-- memória que impede escalabilidade horizontal eficaz. Nenhum enunciado repete, literalmente
-- ou como reformulação disfarçada, um ponto já coberto em V18, V30 ou V39.
--
-- Volume entregue: 18 Questions novas (6 fácil, 6 média, 6 difícil) com 4 alternativas cada,
-- elevando o total do domínio de 54 para 72 Questions.

-- ---------- FÁCEIS (6) ----------

-- Concept 1: Escalabilidade horizontal vs. vertical
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('e1000000-0000-4000-8000-000000000001',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000001',
        'O que caracteriza o autoscaling reativo de instâncias?',
        'Autoscaling reativo adiciona ou remove instâncias com base em métricas atuais observadas (como uso de CPU ou fila de requisições), reagindo depois que a carga já mudou, com um atraso natural entre a detecção e o provisionamento efetivo.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('e1000000-0000-4000-8000-000000000001', 'Adicionar ou remover instâncias com base em métricas atuais observadas, como uso de CPU no momento', true),
    ('e1000000-0000-4000-8000-000000000001', 'Prever a carga futura com base em padrões históricos e provisionar antecipadamente', false),
    ('e1000000-0000-4000-8000-000000000001', 'Redimensionar verticalmente uma única máquina sempre que a carga aumenta', false),
    ('e1000000-0000-4000-8000-000000000001', 'Remover todas as instâncias e reiniciar o sistema periodicamente para liberar memória', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('e1000000-0000-4000-8000-000000000002',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000001',
        'O que caracteriza o autoscaling preditivo (ou programado) de instâncias?',
        'Autoscaling preditivo provisiona capacidade adicional antes do aumento de carga acontecer, com base em previsões (padrões históricos, sazonalidade, eventos agendados), em vez de esperar métricas atuais indicarem a necessidade.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('e1000000-0000-4000-8000-000000000002', 'Provisionar capacidade adicional antecipadamente, com base em previsões de carga futura', true),
    ('e1000000-0000-4000-8000-000000000002', 'Reagir a métricas de uso de CPU coletadas no exato momento da sobrecarga', false),
    ('e1000000-0000-4000-8000-000000000002', 'Escalar verticalmente a máquina apenas após ela atingir 100% de utilização', false),
    ('e1000000-0000-4000-8000-000000000002', 'Depender exclusivamente de health checks para decidir quando adicionar instâncias', false);

-- Concept 2: Caching e estratégias de invalidação
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('e1000000-0000-4000-8000-000000000003',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000002',
        'O que é necessário fazer em uma CDN quando o conteúdo de origem muda e a cópia em cache nos edges precisa refletir a mudança?',
        'É preciso invalidar (fazer purge) explicitamente as cópias já distribuídas nos servidores edge da CDN, pois cada edge mantém sua própria cópia local do conteúdo até expirar ou ser invalidada — a mudança na origem não propaga automaticamente para os caches já distribuídos.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('e1000000-0000-4000-8000-000000000003', 'Invalidar (purge) explicitamente as cópias já distribuídas nos edges da CDN', true),
    ('e1000000-0000-4000-8000-000000000003', 'Aguardar que o navegador do usuário detecte a mudança automaticamente', false),
    ('e1000000-0000-4000-8000-000000000003', 'Aumentar o TTL de todas as entradas para garantir mais tempo de cache', false),
    ('e1000000-0000-4000-8000-000000000003', 'Migrar o conteúdo para um banco de dados relacional', false);

-- Concept 3: Balanceamento de carga
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('e1000000-0000-4000-8000-000000000004',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000003',
        'O que é connection draining (drenagem de conexões) em um load balancer?',
        'Connection draining é o mecanismo pelo qual, ao remover uma instância do pool (por exemplo, durante um deploy), o load balancer para de enviar novas requisições a ela, mas permite que as requisições já em andamento naquela instância terminem normalmente antes de desligá-la.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('e1000000-0000-4000-8000-000000000004', 'Permitir que requisições já em andamento em uma instância terminem antes de removê-la do pool', true),
    ('e1000000-0000-4000-8000-000000000004', 'Encerrar imediatamente todas as conexões de uma instância assim que ela é removida', false),
    ('e1000000-0000-4000-8000-000000000004', 'Redirecionar todo o tráfego para uma única instância durante a manutenção', false),
    ('e1000000-0000-4000-8000-000000000004', 'Aumentar o número de conexões simultâneas permitidas por instância', false);

-- Concept 4: Particionamento e distribuição de tráfego
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('e1000000-0000-4000-8000-000000000005',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000004',
        'O que é write amplification (amplificação de escrita)?',
        'Write amplification é quando uma única escrita lógica realizada pela aplicação resulta em múltiplas escritas físicas no armazenamento (por exemplo, por causa de índices, réplicas ou processos internos do motor de armazenamento), fazendo o volume real de I/O de escrita ser maior do que o volume lógico gravado.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('e1000000-0000-4000-8000-000000000005', 'Quando uma única escrita lógica gera múltiplas escritas físicas no armazenamento subjacente', true),
    ('e1000000-0000-4000-8000-000000000005', 'Quando uma leitura é respondida por múltiplas réplicas simultaneamente', false),
    ('e1000000-0000-4000-8000-000000000005', 'Quando o cache aumenta o tamanho do payload antes de armazená-lo', false),
    ('e1000000-0000-4000-8000-000000000005', 'Quando o balanceador de carga duplica requisições entre instâncias', false);

-- Concept 5: Otimização de latência, throughput e rate limiting
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('e1000000-0000-4000-8000-000000000006',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000005',
        'O que é backpressure, no contexto de controle de sobrecarga entre componentes de um sistema?',
        'Backpressure é o mecanismo pelo qual um componente sobrecarregado sinaliza para quem está enviando trabalho a ele (um produtor, um serviço upstream) que deve reduzir o ritmo de envio, evitando que filas internas cresçam sem limite e o componente entre em colapso.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('e1000000-0000-4000-8000-000000000006', 'Um componente sobrecarregado sinaliza para reduzir o ritmo de envio de trabalho, evitando acúmulo descontrolado', true),
    ('e1000000-0000-4000-8000-000000000006', 'Um componente aumenta automaticamente seu próprio número de instâncias sem intervenção externa', false),
    ('e1000000-0000-4000-8000-000000000006', 'Um cliente é bloqueado permanentemente após exceder um limite de requisições', false),
    ('e1000000-0000-4000-8000-000000000006', 'Um banco de dados comprime os dados antes de gravá-los em disco', false);

-- ---------- MÉDIAS (6) ----------

-- Concept 1
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('e1000000-0000-4000-8000-000000000007',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000001',
        'Qual é uma limitação do autoscaling reativo que o autoscaling preditivo busca mitigar?',
        'Autoscaling reativo só provisiona capacidade depois que a métrica já indica sobrecarga, e provisionar novas instâncias leva tempo (cold start, inicialização); nesse intervalo, o sistema pode operar degradado. Autoscaling preditivo antecipa a necessidade antes do pico chegar, reduzindo essa janela de degradação — desde que a previsão seja razoavelmente precisa.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('e1000000-0000-4000-8000-000000000007', 'O atraso entre a métrica indicar sobrecarga e a nova capacidade estar de fato disponível', true),
    ('e1000000-0000-4000-8000-000000000007', 'A impossibilidade de reagir a qualquer métrica de uso de CPU', false),
    ('e1000000-0000-4000-8000-000000000007', 'A obrigatoriedade de usar apenas escalabilidade vertical', false),
    ('e1000000-0000-4000-8000-000000000007', 'A eliminação completa da necessidade de balanceamento de carga', false);

-- Concept 2
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('e1000000-0000-4000-8000-000000000008',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000002',
        'Por que comprimir o payload de uma resposta HTTP nem sempre é vantajoso, apesar de reduzir o volume de dados trafegado?',
        'Comprimir e descomprimir consome CPU, e esse custo pode superar o ganho de rede em alguns casos — por exemplo, ao comprimir dados que já estão em formato compactado (como imagens JPEG ou vídeos), o ganho de tamanho é mínimo, mas o custo de CPU permanece, tornando a compressão adicional um trade-off desfavorável para esse tipo de conteúdo.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('e1000000-0000-4000-8000-000000000008', 'Porque a compressão consome CPU, e para dados já compactados o ganho de tamanho é mínimo, tornando o custo desfavorável', true),
    ('e1000000-0000-4000-8000-000000000008', 'Porque payloads comprimidos nunca podem ser armazenados em cache', false),
    ('e1000000-0000-4000-8000-000000000008', 'Porque compressão é incompatível com o protocolo HTTP', false),
    ('e1000000-0000-4000-8000-000000000008', 'Porque comprimir sempre aumenta a latência de leitura no banco de dados', false);

-- Concept 3
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('e1000000-0000-4000-8000-000000000009',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000003',
        'Por que connection draining é importante durante um deploy com rolling update, quando instâncias antigas são removidas gradualmente do pool?',
        'Sem connection draining, uma instância poderia ser encerrada abruptamente enquanto ainda processa requisições em andamento, causando erros para esses usuários. Com draining, o load balancer para de enviar requisições novas para a instância, mas espera as em andamento terminarem antes de desligá-la, evitando erros 5xx durante o deploy.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('e1000000-0000-4000-8000-000000000009', 'Evita que requisições em andamento numa instância sendo removida falhem com erro, dando tempo para elas terminarem', true),
    ('e1000000-0000-4000-8000-000000000009', 'Garante que todas as instâncias sejam atualizadas simultaneamente, sem gradualismo', false),
    ('e1000000-0000-4000-8000-000000000009', 'Elimina a necessidade de health checks durante o processo de deploy', false),
    ('e1000000-0000-4000-8000-000000000009', 'Faz com que o cache local de cada instância seja replicado automaticamente para as demais', false);

-- Concept 4
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('e1000000-0000-4000-8000-000000000010',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000004',
        'Em um sistema com réplicas de leitura, quem é tipicamente responsável por rotear escritas para o nó primário e leituras para as réplicas?',
        'Diferente do particionamento por chave (onde a partição correta é determinada automaticamente por um mecanismo de roteamento dedicado), o roteamento entre primário e réplicas de leitura costuma ser responsabilidade explícita da aplicação ou de um driver/proxy de banco de dados configurado para essa divisão, direcionando escritas sempre ao primário e distribuindo leituras entre as réplicas disponíveis.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('e1000000-0000-4000-8000-000000000010', 'A aplicação ou um driver/proxy de banco de dados configurado especificamente para separar escritas e leituras', true),
    ('e1000000-0000-4000-8000-000000000010', 'O próprio hardware de disco, de forma totalmente transparente', false),
    ('e1000000-0000-4000-8000-000000000010', 'O algoritmo de hashing consistente do load balancer de camada 4', false),
    ('e1000000-0000-4000-8000-000000000010', 'Isso nunca precisa ser roteado, pois toda réplica aceita escritas diretamente', false);

-- Concept 5
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('e1000000-0000-4000-8000-000000000011',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000005',
        'O que acontece quando um pool de conexões com banco de dados se esgota (todas as conexões estão em uso) sob alta concorrência?',
        'Quando não há conexões disponíveis no pool, novas requisições que precisam de uma conexão ficam esperando (enfileiradas) até que uma conexão seja liberada, ou falham por timeout se a espera ultrapassar um limite configurado — um pool subdimensionado para o nível de concorrência real vira um gargalo mesmo que o banco em si tenha capacidade sobrando.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('e1000000-0000-4000-8000-000000000011', 'Novas requisições esperam na fila por uma conexão livre ou falham por timeout, criando um gargalo', true),
    ('e1000000-0000-4000-8000-000000000011', 'O banco de dados cria automaticamente novas conexões sem limite até atender a todos', false),
    ('e1000000-0000-4000-8000-000000000011', 'As conexões existentes dobram de capacidade automaticamente', false),
    ('e1000000-0000-4000-8000-000000000011', 'O cache da aplicação assume todas as leituras até o pool se recuperar', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('e1000000-0000-4000-8000-000000000012',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000005',
        'Como um circuit breaker se comporta, de forma básica, ao detectar uma taxa de falhas acima de um limite ao chamar uma dependência?',
        'Ao ultrapassar o limite de falhas configurado, o circuit breaker "abre" e passa a rejeitar chamadas para aquela dependência imediatamente (sem sequer tentar), por um período, antes de permitir novas tentativas de forma controlada para verificar se a dependência se recuperou.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('e1000000-0000-4000-8000-000000000012', 'Passa a rejeitar novas chamadas para a dependência imediatamente, sem tentá-las, por um período', true),
    ('e1000000-0000-4000-8000-000000000012', 'Aumenta automaticamente o número de tentativas (retries) para cada chamada com falha', false),
    ('e1000000-0000-4000-8000-000000000012', 'Redireciona todas as chamadas para uma réplica de leitura', false),
    ('e1000000-0000-4000-8000-000000000012', 'Reduz o TTL do cache da dependência para forçar atualização mais frequente', false);

-- ---------- DIFÍCEIS (6) ----------

-- Concept 1
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('e1000000-0000-4000-8000-000000000013',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000001',
        'Um sistema legado mantém um lock em memória compartilhada entre todas as requisições de uma mesma máquina para coordenar acesso a um recurso interno, e essa lógica nunca foi desenhada para rodar em múltiplas instâncias. Por que simplesmente adicionar mais instâncias (escalar horizontalmente) não resolve o gargalo desse sistema?',
        'O lock em memória só coordena requisições dentro da mesma instância; em múltiplas instâncias, cada uma teria sua própria cópia do lock, sem coordenação entre elas, quebrando a garantia original ou exigindo externalizar esse mecanismo de coordenação (por exemplo, para um lock distribuído) antes que escalar horizontalmente funcione corretamente.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('e1000000-0000-4000-8000-000000000013', 'Porque o lock é local a cada instância; múltiplas instâncias teriam locks independentes, sem coordenação real entre elas', true),
    ('e1000000-0000-4000-8000-000000000013', 'Porque escalabilidade horizontal é incompatível com qualquer forma de concorrência', false),
    ('e1000000-0000-4000-8000-000000000013', 'Porque adicionar instâncias sempre reduz automaticamente o throughput do sistema', false),
    ('e1000000-0000-4000-8000-000000000013', 'Porque locks em memória só podem existir em sistemas que usam particionamento', false);

-- Concept 2
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('e1000000-0000-4000-8000-000000000014',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000002',
        'Uma aplicação com CDN global decide não fazer purge explícito a cada atualização de conteúdo, preferindo usar URLs versionadas (ex.: incluir um hash do conteúdo no nome do arquivo) para invalidação. Por que essa abordagem evita o problema de atraso de propagação do purge entre milhares de edges?',
        'Ao mudar a URL sempre que o conteúdo muda, cada versão do conteúdo tem uma chave de cache própria e permanentemente válida — não é necessário invalidar nada, porque a URL antiga simplesmente para de ser referenciada e a nova URL, ainda não vista por nenhum edge, é buscada da origem na primeira requisição, sem depender de um purge distribuído que leva tempo para propagar por toda a rede de edges.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('e1000000-0000-4000-8000-000000000014', 'Porque cada versão do conteúdo tem uma URL própria e imutável, dispensando invalidação distribuída — a nova URL é simplesmente buscada da origem quando referenciada', true),
    ('e1000000-0000-4000-8000-000000000014', 'Porque URLs versionadas eliminam completamente a necessidade de qualquer camada de cache', false),
    ('e1000000-0000-4000-8000-000000000014', 'Porque o purge em CDNs é instantâneo e simultâneo em todos os edges, tornando essa técnica desnecessária', false),
    ('e1000000-0000-4000-8000-000000000014', 'Porque versionar URLs converte automaticamente a CDN em um balanceador de carga L7', false);

-- Concept 3
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('e1000000-0000-4000-8000-000000000015',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000003',
        'Por que abrir o circuito de um circuit breaker preventivamente — rejeitando novas chamadas para uma dependência degradada, inclusive algumas que teriam sucesso — é considerado uma boa prática, mesmo desperdiçando requisições potencialmente válidas?',
        'Continuar enviando chamadas para uma dependência já sobrecarregada ou falhando tende a piorar a situação (mais carga sobre um sistema já degradado, mais threads/conexões presas esperando timeout), podendo propagar a falha para o próprio sistema chamador e para outros serviços dele dependentes. Rejeitar rápido, mesmo perdendo algumas chamadas que teriam funcionado, protege o sistema chamador e dá tempo para a dependência se recuperar — evitando uma falha em cascata maior.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('e1000000-0000-4000-8000-000000000015', 'Porque continuar chamando uma dependência degradada tende a piorar a sobrecarga e pode propagar a falha em cascata para o próprio sistema chamador', true),
    ('e1000000-0000-4000-8000-000000000015', 'Porque rejeitar chamadas sempre aumenta o throughput medido do sistema chamador', false),
    ('e1000000-0000-4000-8000-000000000015', 'Porque circuit breakers substituem totalmente a necessidade de health checks na dependência', false),
    ('e1000000-0000-4000-8000-000000000015', 'Porque abrir o circuito converte automaticamente as chamadas síncronas em assíncronas', false);

-- Concept 4
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('e1000000-0000-4000-8000-000000000016',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000004',
        'Em um sistema com múltiplos índices em uma tabela, replicação síncrona para réplicas e particionamento por hash, por que o fator de write amplification tende a se multiplicar em vez de simplesmente somar entre essas camadas?',
        'Cada camada adiciona seu próprio multiplicador sobre a escrita original: cada índice gera uma escrita adicional por linha modificada, cada réplica síncrona exige que a mesma escrita seja replicada integralmente, e o particionamento pode exigir rotear e replicar a escrita dentro da partição correspondente. Como essas escritas adicionais acontecem em conjunto (a escrita original passa por todas as camadas), o efeito é multiplicativo — o volume final de I/O de escrita pode ser muitas vezes maior que o volume lógico gravado pela aplicação.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('e1000000-0000-4000-8000-000000000016', 'Porque cada camada (índices, réplicas, partição) adiciona seu próprio multiplicador sobre a mesma escrita original, e esses multiplicadores se combinam', true),
    ('e1000000-0000-4000-8000-000000000016', 'Porque write amplification só ocorre quando não há nenhum índice na tabela', false),
    ('e1000000-0000-4000-8000-000000000016', 'Porque réplicas síncronas eliminam a necessidade de atualizar índices', false),
    ('e1000000-0000-4000-8000-000000000016', 'Porque particionamento por hash sempre reduz o número de réplicas necessárias', false);

-- Concept 5
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('e1000000-0000-4000-8000-000000000017',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000005',
        'O que são "hedged requests" e qual o trade-off de usá-las para reduzir a latência de cauda (p99) de um sistema?',
        'Hedged requests consistem em enviar uma segunda requisição idêntica a outro nó/réplica caso a primeira não responda dentro de um tempo esperado, usando a resposta que chegar primeiro e descartando a outra. Isso reduz a chance de uma única requisição lenta afetar o p99 percebido, mas aumenta a carga total sobre o sistema (mais requisições processadas do que as estritamente necessárias), sendo um trade-off entre latência de cauda e throughput/custo de recursos.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('e1000000-0000-4000-8000-000000000017', 'Enviar uma segunda requisição a outro nó se a primeira demorar, usando a resposta mais rápida — reduz a latência de cauda, mas aumenta a carga total do sistema', true),
    ('e1000000-0000-4000-8000-000000000017', 'Enviar metade de cada requisição para dois nós diferentes, que juntam os resultados depois', false),
    ('e1000000-0000-4000-8000-000000000017', 'Armazenar em cache apenas as requisições que excederam o p99 histórico', false),
    ('e1000000-0000-4000-8000-000000000017', 'Rejeitar automaticamente qualquer requisição que ultrapasse o p95 de latência', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('e1000000-0000-4000-8000-000000000018',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000005',
        'Qual é a diferença conceitual entre rate limiting e backpressure como mecanismos de proteção contra sobrecarga?',
        'Rate limiting é aplicado na borda do sistema, limitando quantas requisições um cliente externo pode fazer em uma janela de tempo, geralmente rejeitando o excesso de forma explícita (ex.: HTTP 429). Backpressure é um mecanismo interno, entre componentes de um mesmo pipeline de processamento, em que um componente sobrecarregado sinaliza para o componente anterior (upstream) reduzir o ritmo de envio, propagando a pressão ao longo da cadeia em vez de simplesmente descartar ou rejeitar requisições de um cliente externo.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('e1000000-0000-4000-8000-000000000018', 'Rate limiting atua na borda, limitando clientes externos; backpressure é interno, sinalizando componentes upstream do próprio pipeline a reduzir o ritmo', true),
    ('e1000000-0000-4000-8000-000000000018', 'Rate limiting e backpressure são exatamente o mesmo mecanismo, apenas com nomes diferentes', false),
    ('e1000000-0000-4000-8000-000000000018', 'Backpressure só pode ser aplicado a clientes externos via código HTTP 429', false),
    ('e1000000-0000-4000-8000-000000000018', 'Rate limiting é sempre implementado dentro do banco de dados, nunca na camada de aplicação', false);
