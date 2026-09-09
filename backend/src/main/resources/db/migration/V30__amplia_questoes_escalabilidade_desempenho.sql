-- Ampliação do pool de Questions — Domínio: Escalabilidade e Desempenho (slug: escalabilidade-desempenho)
-- Fase 1 do TICKET-content-expansion-questoes.md (ver também TICKET-content-database.md).
--
-- Escopo: apenas Question + Alternativas. Nenhum Concept/Slide/Flashcard novo — reaproveita
-- os 5 Concepts já criados em V18__seed_conteudo_escalabilidade_desempenho.sql.
--
-- Conteúdo rascunhado por IA (autoria assistida), pendente de revisão humana antes de
-- produção — todo item usa content_version = 'v1' e status_revisao = 'rascunho', mesma
-- convenção do lote original (V18).
--
-- Não-duplicação: as 18 Questions abaixo foram escritas após leitura integral de
-- V18__seed_conteudo_escalabilidade_desempenho.sql (as 18 Questions já existentes daquele
-- domínio) e cobrem pontos distintos dos já testados por elas — nenhum enunciado repete,
-- literalmente ou como reformulação disfarçada, um ponto já coberto em V18. Distratores
-- mantidos tecnicamente plausíveis, sem o estilo "meta" (referência ao próprio quiz)
-- sinalizado pelo QA como destoante no lote original.
--
-- Volume entregue: 18 Questions novas (6 fácil, 6 média, 6 difícil) com 4 alternativas
-- cada, elevando o total do domínio de 18 para 36 Questions.

-- ---------- FÁCEIS (6) ----------

-- Concept 1: Escalabilidade horizontal vs. vertical
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('c1000000-0000-4000-8000-000000000001',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000001',
        'O que caracteriza a escalabilidade horizontal (scale out) de um sistema?',
        'Escalabilidade horizontal consiste em adicionar mais máquinas que dividem a carga de trabalho entre si, em vez de aumentar a capacidade de uma única máquina.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c1000000-0000-4000-8000-000000000001', 'Adicionar mais máquinas que dividem a carga de trabalho entre si', true),
    ('c1000000-0000-4000-8000-000000000001', 'Aumentar a memória RAM de uma única máquina existente', false),
    ('c1000000-0000-4000-8000-000000000001', 'Reduzir o número de instâncias em execução para economizar custos', false),
    ('c1000000-0000-4000-8000-000000000001', 'Migrar o banco de dados para um único servidor mais potente', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('c1000000-0000-4000-8000-000000000002',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000001',
        'Qual é uma vantagem da escalabilidade vertical em relação à complexidade de implementação?',
        'Escalar verticalmente não exige que a aplicação seja redesenhada para rodar em múltiplas instâncias, ao contrário da escalabilidade horizontal, que exige externalizar estado e balancear carga.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c1000000-0000-4000-8000-000000000002', 'Não exige mudanças na arquitetura da aplicação para funcionar', true),
    ('c1000000-0000-4000-8000-000000000002', 'Elimina completamente o risco de a máquina ser um ponto único de falha', false),
    ('c1000000-0000-4000-8000-000000000002', 'Permite crescimento de capacidade praticamente ilimitado', false),
    ('c1000000-0000-4000-8000-000000000002', 'Dispensa qualquer monitoramento de uso de recursos', false);

-- Concept 2: Caching e estratégias de invalidação
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('c1000000-0000-4000-8000-000000000003',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000002',
        'O que é uma CDN, no contexto de camadas de cache?',
        'Uma CDN (Content Delivery Network) é uma camada de cache distribuída geograficamente, que mantém cópias de conteúdo mais próximas do usuário final para reduzir latência.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c1000000-0000-4000-8000-000000000003', 'Uma camada de cache distribuída geograficamente, mais próxima do usuário final', true),
    ('c1000000-0000-4000-8000-000000000003', 'Um banco de dados relacional otimizado para escrita', false),
    ('c1000000-0000-4000-8000-000000000003', 'Um algoritmo de balanceamento de carga entre instâncias', false),
    ('c1000000-0000-4000-8000-000000000003', 'Um protocolo de comunicação entre microsserviços', false);

-- Concept 3: Balanceamento de carga
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('c1000000-0000-4000-8000-000000000004',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000003',
        'O que um load balancer verifica ao realizar "health checks" em suas instâncias?',
        'Health checks verificam se cada instância está saudável e apta a receber tráfego; instâncias que falham no health check deixam de receber requisições.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c1000000-0000-4000-8000-000000000004', 'Se cada instância está saudável e apta a receber tráfego', true),
    ('c1000000-0000-4000-8000-000000000004', 'Se cada instância está usando a versão mais recente do sistema operacional', false),
    ('c1000000-0000-4000-8000-000000000004', 'Se o cache de cada instância está sincronizado com as demais', false),
    ('c1000000-0000-4000-8000-000000000004', 'Se os dados do banco estão particionados corretamente', false);

-- Concept 4: Particionamento e distribuição de tráfego
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('c1000000-0000-4000-8000-000000000005',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000004',
        'O que é necessário para rotear corretamente uma requisição de leitura ou escrita em um sistema com dados particionados?',
        'Cada requisição precisa ser roteada para a partição correta com base na chave de partição do dado que ela acessa; sem esse roteamento, o particionamento não funciona.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c1000000-0000-4000-8000-000000000005', 'Determinar, com base na chave de partição, qual partição contém o dado desejado', true),
    ('c1000000-0000-4000-8000-000000000005', 'Consultar todas as partições simultaneamente a cada requisição, sempre', false),
    ('c1000000-0000-4000-8000-000000000005', 'Aguardar que o load balancer escolha uma partição aleatoriamente', false),
    ('c1000000-0000-4000-8000-000000000005', 'Migrar o dado para uma partição diferente antes de cada leitura', false);

-- Concept 5: Otimização de latência, throughput e rate limiting
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('c1000000-0000-4000-8000-000000000006',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000005',
        'Qual é a definição de throughput em um sistema?',
        'Throughput é a quantidade de requisições (ou trabalho) que um sistema consegue processar em um determinado período de tempo, diferente de latência, que mede o tempo de uma única requisição.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c1000000-0000-4000-8000-000000000006', 'A quantidade de requisições que o sistema consegue processar em um período de tempo', true),
    ('c1000000-0000-4000-8000-000000000006', 'O tempo que uma única requisição leva para ser respondida', false),
    ('c1000000-0000-4000-8000-000000000006', 'A quantidade de memória RAM disponível em uma instância', false),
    ('c1000000-0000-4000-8000-000000000006', 'O número de réplicas de leitura configuradas no banco de dados', false);

-- ---------- MÉDIAS (6) ----------

-- Concept 1
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('c1000000-0000-4000-8000-000000000007',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000001',
        'Ao adotar escalabilidade horizontal, para onde o estado de sessão de um usuário deve ser movido, em vez de permanecer na memória local de uma instância?',
        'Estado que precisa persistir entre requisições (como sessão de usuário) deve ser movido para um armazenamento compartilhado entre as instâncias, como um cache distribuído ou banco de dados, permitindo que qualquer instância atenda qualquer requisição.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c1000000-0000-4000-8000-000000000007', 'Para um armazenamento compartilhado entre as instâncias, como um cache distribuído ou banco de dados', true),
    ('c1000000-0000-4000-8000-000000000007', 'Para o disco local de cada instância individualmente', false),
    ('c1000000-0000-4000-8000-000000000007', 'Para variáveis estáticas dentro do processo da aplicação', false),
    ('c1000000-0000-4000-8000-000000000007', 'Para o load balancer, que passa a armazenar o estado de cada usuário', false);

-- Concept 2
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('c1000000-0000-4000-8000-000000000008',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000002',
        'Na estratégia de cache "write-through", o que acontece a cada escrita?',
        'Em write-through, toda escrita é feita simultaneamente no cache e na fonte de dados original, mantendo os dois sempre sincronizados, ao custo de maior latência de escrita.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c1000000-0000-4000-8000-000000000008', 'A escrita é feita simultaneamente no cache e na fonte de dados original', true),
    ('c1000000-0000-4000-8000-000000000008', 'A escrita é feita apenas no cache, sem nunca atualizar a fonte original', false),
    ('c1000000-0000-4000-8000-000000000008', 'A escrita é enfileirada e só ocorre uma vez por dia', false),
    ('c1000000-0000-4000-8000-000000000008', 'A escrita é rejeitada até que o cache seja esvaziado manualmente', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('c1000000-0000-4000-8000-000000000009',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000002',
        'Qual é a principal desvantagem da estratégia de cache "write-through" em comparação com "write-behind"?',
        'Write-through só confirma a escrita depois de gravar tanto no cache quanto na fonte, o que aumenta a latência de escrita em comparação com write-behind, que confirma a escrita assim que grava no cache.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c1000000-0000-4000-8000-000000000009', 'Maior latência de escrita, já que a operação só é confirmada após gravar no cache e na fonte', true),
    ('c1000000-0000-4000-8000-000000000009', 'Maior risco de perda de dados em caso de falha do cache', false),
    ('c1000000-0000-4000-8000-000000000009', 'Impossibilidade de ser usada em conjunto com TTL nas entradas', false),
    ('c1000000-0000-4000-8000-000000000009', 'Necessidade obrigatória de um balanceador de carga L7', false);

-- Concept 3
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('c1000000-0000-4000-8000-000000000010',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000003',
        'Qual é uma desvantagem de adicionar múltiplas camadas de balanceamento de carga (DNS/CDN, borda, interno) em um sistema distribuído?',
        'Cada camada adicional de balanceamento aumenta a resiliência a falhas localizadas, mas também introduz mais um salto de rede, aumentando a latência total da requisição.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c1000000-0000-4000-8000-000000000010', 'Cada camada adicional introduz um salto de rede a mais, aumentando a latência total', true),
    ('c1000000-0000-4000-8000-000000000010', 'Reduz automaticamente a disponibilidade geral do sistema', false),
    ('c1000000-0000-4000-8000-000000000010', 'Impede o uso de health checks nas instâncias internas', false),
    ('c1000000-0000-4000-8000-000000000010', 'Torna obrigatório o uso do algoritmo round-robin em todas as camadas', false);

-- Concept 4
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('c1000000-0000-4000-8000-000000000011',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000004',
        'O que significa dizer que uma chave de partição tem "alta cardinalidade e distribuição uniforme"?',
        'Significa que existem muitos valores possíveis para a chave e que eles se distribuem de forma equilibrada entre as partições, evitando que uma partição concentre carga desproporcional.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c1000000-0000-4000-8000-000000000011', 'Que existem muitos valores possíveis para a chave e eles se distribuem de forma equilibrada entre as partições', true),
    ('c1000000-0000-4000-8000-000000000011', 'Que a chave é sempre um número inteiro sequencial gerado pelo banco', false),
    ('c1000000-0000-4000-8000-000000000011', 'Que a chave nunca pode se repetir em todo o histórico do sistema', false),
    ('c1000000-0000-4000-8000-000000000011', 'Que todas as partições armazenam exatamente a mesma quantidade de bytes', false);

-- Concept 5
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('c1000000-0000-4000-8000-000000000012',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000005',
        'Por que a paralelização de chamadas independentes dentro de uma requisição reduz a latência total percebida pelo usuário?',
        'Ao executar chamadas independentes simultaneamente em vez de uma esperar a outra terminar (encadeamento sequencial), o tempo total de espera se aproxima do tempo da chamada mais lenta, em vez da soma de todas.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c1000000-0000-4000-8000-000000000012', 'Porque as chamadas ocorrem simultaneamente em vez de uma esperar a outra terminar', true),
    ('c1000000-0000-4000-8000-000000000012', 'Porque paralelizar chamadas reduz automaticamente o throughput do sistema', false),
    ('c1000000-0000-4000-8000-000000000012', 'Porque cada chamada paralela é sempre processada por um balanceador de carga diferente', false),
    ('c1000000-0000-4000-8000-000000000012', 'Porque paralelizar elimina a necessidade de qualquer chamada de rede', false);

-- ---------- DIFÍCEIS (6) ----------

-- Concept 1
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('c1000000-0000-4000-8000-000000000013',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000001',
        'Uma equipe decide combinar escalabilidade vertical e horizontal em camadas diferentes do mesmo sistema (por exemplo, um banco vertical robusto atendendo uma camada de aplicação horizontal). Por que essa combinação é comum na prática?',
        'Componentes diferentes de um sistema têm limites e características distintas — um banco de dados pode ser mais difícil de escalar horizontalmente para escrita do que a camada de aplicação —, então a estratégia de escala mais eficaz varia conforme o componente, tornando combinações mistas comuns.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c1000000-0000-4000-8000-000000000013', 'Porque cada componente do sistema tem limites e características diferentes, e a estratégia de escala mais eficaz varia conforme o componente', true),
    ('c1000000-0000-4000-8000-000000000013', 'Porque todo sistema distribuído é obrigado a usar as duas abordagens simultaneamente', false),
    ('c1000000-0000-4000-8000-000000000013', 'Porque escalar verticalmente sempre torna a escalabilidade horizontal desnecessária', false),
    ('c1000000-0000-4000-8000-000000000013', 'Porque combinar as duas abordagens elimina a necessidade de balanceamento de carga', false);

-- Concept 2
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('c1000000-0000-4000-8000-000000000014',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000002',
        'Por que "versionamento de chaves" (mudar a chave do cache quando o dado de origem muda) é considerada uma estratégia de invalidação, mesmo sem remover explicitamente a entrada antiga do cache?',
        'A chave antiga se torna naturalmente inacessível para novas leituras, já que a aplicação passa a buscar pela nova chave — ainda que a entrada obsoleta continue fisicamente ocupando espaço no cache até ser limpa posteriormente.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c1000000-0000-4000-8000-000000000014', 'Porque a chave antiga se torna naturalmente inacessível para novas leituras, mesmo que a entrada obsoleta ainda ocupe espaço até ser limpa depois', true),
    ('c1000000-0000-4000-8000-000000000014', 'Porque o versionamento apaga fisicamente a entrada antiga do cache no mesmo instante', false),
    ('c1000000-0000-4000-8000-000000000014', 'Porque versionar chaves converte automaticamente a estratégia em write-through', false),
    ('c1000000-0000-4000-8000-000000000014', 'Porque a chave versionada nunca expira, eliminando qualquer necessidade de TTL', false);

-- Concept 3
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('c1000000-0000-4000-8000-000000000015',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000003',
        'Um sistema troca seu balanceamento de L4 para L7 para poder rotear requisições com base no path da URL, mas passa a notar latência adicional perceptível. Por que esse aumento de latência é esperado?',
        'Balanceamento L7 precisa inspecionar o conteúdo da requisição (como headers e path) para decidir o roteamento, o que exige mais processamento do que o L4, que roteia apenas com base em informações de transporte como IP e porta.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c1000000-0000-4000-8000-000000000015', 'Porque o L7 precisa inspecionar o conteúdo da requisição, exigindo mais processamento do que o roteamento por IP/porta do L4', true),
    ('c1000000-0000-4000-8000-000000000015', 'Porque balanceamento L7 só pode ser executado em hardware dedicado, nunca em software', false),
    ('c1000000-0000-4000-8000-000000000015', 'Porque L7 elimina a necessidade de health checks, o que torna o roteamento mais lento', false),
    ('c1000000-0000-4000-8000-000000000015', 'Porque L7 sempre distribui tráfego apenas por round-robin, sem outras opções de algoritmo', false);

-- Concept 4
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('c1000000-0000-4000-8000-000000000016',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000004',
        'O que é rebalanceamento em um sistema particionado, e por que suportá-lo sem downtime é considerado desejável?',
        'Rebalanceamento é mover partições entre nós conforme a carga muda ao longo do tempo, reequilibrando a distribuição; fazer isso sem downtime evita interromper o atendimento aos dados que estão sendo movidos durante o processo.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c1000000-0000-4000-8000-000000000016', 'É mover partições entre nós conforme a carga muda; fazer isso sem downtime evita interromper o atendimento durante a movimentação', true),
    ('c1000000-0000-4000-8000-000000000016', 'É reduzir o número de réplicas de leitura para liberar recursos do cluster', false),
    ('c1000000-0000-4000-8000-000000000016', 'É aumentar automaticamente o TTL das entradas de cache do sistema', false),
    ('c1000000-0000-4000-8000-000000000016', 'É trocar o algoritmo de balanceamento de carga de L4 para L7', false);

INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('c1000000-0000-4000-8000-000000000017',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000004',
        'Por que evitar fan-out (consultar todas as partições a cada requisição) é um objetivo importante ao escolher uma chave de partição?',
        'Se toda consulta precisa varrer todas as partições, boa parte do ganho de desempenho do particionamento se perde, já que cada requisição passa a depender de múltiplos nós em vez de apenas um.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c1000000-0000-4000-8000-000000000017', 'Porque consultar todas as partições a cada requisição anula boa parte do ganho de desempenho do particionamento', true),
    ('c1000000-0000-4000-8000-000000000017', 'Porque fan-out é proibido pelo protocolo HTTP em requisições do tipo GET', false),
    ('c1000000-0000-4000-8000-000000000017', 'Porque fan-out sempre causa perda permanente e irreversível de dados', false),
    ('c1000000-0000-4000-8000-000000000017', 'Porque fan-out impede completamente o uso de réplicas de leitura', false);

-- Concept 5
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('c1000000-0000-4000-8000-000000000018',
        (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
        'a1000000-0000-4000-8000-000000000005',
        'Um sistema de negociação financeira de alta frequência prioriza latência mínima por requisição, mesmo que isso limite o throughput total. Por que essa priorização faz sentido para esse caso de uso?',
        'O valor de cada operação individual depende de uma resposta extremamente rápida, tornando inaceitável o atraso que técnicas como batching introduziriam em troca de maior throughput agregado.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('c1000000-0000-4000-8000-000000000018', 'Porque o valor de cada operação depende de resposta extremamente rápida, tornando inaceitável o atraso de técnicas como batching', true),
    ('c1000000-0000-4000-8000-000000000018', 'Porque sistemas de alta frequência nunca processam mais de uma requisição por segundo', false),
    ('c1000000-0000-4000-8000-000000000018', 'Porque throughput e latência são sempre exatamente proporcionais entre si', false),
    ('c1000000-0000-4000-8000-000000000018', 'Porque priorizar latência elimina automaticamente a necessidade de rate limiting', false);
