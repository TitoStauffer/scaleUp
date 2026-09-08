-- Seed de conteúdo — Domínio Observabilidade e Confiabilidade (Backend Engineer)
-- Referencia o domínio já semeado em V13 (slug 'observabilidade-confiabilidade') via
-- subquery — nunca insere em domain (ver TICKET-content-database.md e
-- TICKET-content-observabilidade-confiabilidade.md).
-- content_version = 'v1' e status_revisao = 'rascunho' em todo o lote: conteúdo
-- rascunhado por IA, revisão humana ainda não realizada (Decisão 2 do ticket mestre).
-- Question + suas 4 alternativas são inseridas na mesma transação de migração, conforme
-- exigido pelo trigger de constraint adiada trg_verificar_alternativas_question (V6).

-- =====================================================================================
-- CONCEPTS (5)
-- =====================================================================================

INSERT INTO concept (id, domain_ref, titulo, resumo, content_version, status_revisao)
VALUES
    ('a1a10000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Logging estruturado',
     'Como registrar eventos de aplicação de forma estruturada (campos, não texto livre) para permitir busca, correlação e agregação eficientes em ferramentas de observabilidade.',
     'v1', 'rascunho'),
    ('a1a10000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Métricas e monitoramento',
     'Tipos de métricas (counter, gauge, histogram), coleta via pull/push, e como usar métricas para detectar degradação antes que vire incidente.',
     'v1', 'rascunho'),
    ('a1a10000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Tracing distribuído',
     'Como rastrear uma requisição através de múltiplos serviços usando spans e trace context, e por que logs e métricas isolados não bastam em arquiteturas distribuídas.',
     'v1', 'rascunho'),
    ('a1a10000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'SLIs, SLOs e SLAs',
     'Como definir e medir indicadores de confiabilidade centrados no usuário, estabelecer metas internas (SLO) e usar error budget para equilibrar velocidade e estabilidade.',
     'v1', 'rascunho'),
    ('a1a10000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Tolerância a falhas e recuperação',
     'Padrões para lidar com falhas transitórias e catastróficas: retries com backoff, circuit breaker, timeouts, bulkheads e estratégias de disaster recovery.',
     'v1', 'rascunho')
ON CONFLICT (domain_ref, titulo) DO NOTHING;

-- =====================================================================================
-- SLIDES (15 — 3 por Concept, ordem sequencial 1..3 dentro de cada Concept)
-- =====================================================================================

-- Concept: Logging estruturado
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ((SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000001'),
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Por que logging estruturado?',
     'Logs de texto livre (ex.: "Usuario 123 fez login as 10:32") são fáceis de escrever, mas difíceis de consultar em escala: exigem parsing frágil com regex para extrair campos. Logging estruturado registra cada evento como um objeto com campos nomeados (ex.: JSON: {"evento":"login","usuario_id":123,"timestamp":"..."}). Isso permite indexar, filtrar e agregar por campo em ferramentas como Elasticsearch, Loki ou CloudWatch Logs Insights sem depender de parsing ad-hoc, e é a base para correlacionar logs com métricas e traces do mesmo evento.',
     1, 'v1', 'rascunho'),
    ((SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000001'),
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Níveis de log e correlação',
     'Níveis de log (DEBUG, INFO, WARN, ERROR, FATAL) indicam severidade e permitem filtrar ruído em produção — tipicamente roda-se com nível INFO ou WARN, elevando para DEBUG apenas ao investigar um problema. Igualmente importante é a correlação: incluir um correlation_id (ou trace_id) em todo log de uma mesma requisição permite reconstruir a jornada completa de uma chamada através de múltiplos serviços, mesmo quando os logs de cada serviço ficam em armazenamentos separados. Sem esse identificador comum, depurar um fluxo distribuído vira garimpo manual por timestamp.',
     2, 'v1', 'rascunho'),
    ((SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000001'),
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Exemplo prático: o que não logar',
     'Logging estruturado também exige disciplina sobre o que registrar. Nunca logar dados sensíveis em texto claro (senhas, tokens, números de cartão, CPF) — isso é vazamento de dados via um canal frequentemente menos protegido que o banco principal. Também deve-se evitar logar em excesso dentro de loops de alta frequência (ex.: um log por item em um lote de 100 mil registros), o que pode saturar o pipeline de logging e aumentar custo de armazenamento sem agregar valor de diagnóstico — nesses casos, prefira logar um resumo agregado ao final do processamento.',
     3, 'v1', 'rascunho');

-- Concept: Métricas e monitoramento
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ((SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000002'),
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Tipos de métricas',
     'Counter é um valor que só cresce (ex.: total de requisições recebidas), útil para calcular taxas (requisições/segundo) via derivada no tempo. Gauge é um valor que sobe e desce livremente (ex.: uso de memória atual, conexões abertas no pool). Histogram distribui observações em buckets para calcular percentis (ex.: latência p50/p95/p99 de uma API) — essencial porque a média esconde outliers: uma média de 100ms pode conviver com 5% das requisições levando 3 segundos, e é exatamente esse 5% que geralmente afeta a experiência do usuário mais sensível.',
     1, 'v1', 'rascunho'),
    ((SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000002'),
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Coleta pull vs. push',
     'No modelo pull (usado pelo Prometheus), o sistema de monitoramento periodicamente busca ("faz scrape") as métricas expostas por cada serviço em um endpoint HTTP (ex.: /metrics). No modelo push (usado por StatsD ou CloudWatch em alguns casos), a própria aplicação envia as métricas ativamente para um coletor central. Pull facilita saber se um serviço está fora do ar (a ausência de scrape bem-sucedido já é um sinal) e centraliza a configuração de frequência de coleta; push é mais adequado para processos de vida curta (ex.: jobs batch) que podem terminar antes de qualquer scrape acontecer.',
     2, 'v1', 'rascunho'),
    ((SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000002'),
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Os quatro sinais de ouro',
     'Google SRE popularizou quatro sinais essenciais para monitorar qualquer serviço: latência (tempo de resposta, separando requisições com sucesso das com erro), tráfego (volume de demanda, ex.: requisições/segundo), erros (taxa de falhas, explícitas como HTTP 500 ou implícitas como respostas incorretas) e saturação (o quão "cheio" o sistema está em relação à sua capacidade, ex.: uso de CPU/memória/filas). Um painel de monitoramento que cobre esses quatro sinais para cada serviço crítico já detecta a maioria dos incidentes antes que o usuário reclame.',
     3, 'v1', 'rascunho');

-- Concept: Tracing distribuído
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ((SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000003'),
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'O problema que o tracing resolve',
     'Em uma arquitetura de microsserviços, uma única requisição do usuário pode atravessar dezenas de serviços antes de retornar uma resposta. Se essa requisição fica lenta ou falha, logs e métricas isolados de cada serviço não dizem, sozinhos, qual serviço específico na cadeia causou o problema nem quanto tempo cada etapa consumiu. Tracing distribuído resolve isso encadeando todas as chamadas de uma mesma requisição em uma única árvore de execução, visualizável do início ao fim, mostrando exatamente onde o tempo foi gasto e onde ocorreu a falha.',
     1, 'v1', 'rascunho'),
    ((SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000003'),
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Trace, span e contexto de propagação',
     'Um trace representa a jornada completa de uma requisição; ele é composto por vários spans, cada um representando uma unidade de trabalho (ex.: uma chamada HTTP, uma query no banco). Cada span tem um span_id próprio e referencia seu span pai, formando uma árvore. Para que os spans de serviços diferentes sejam agrupados no mesmo trace, o trace_id precisa ser propagado entre serviços, tipicamente via cabeçalhos HTTP (ex.: o padrão W3C Trace Context, com os cabeçalhos traceparent/tracestate). Sem essa propagação, cada serviço geraria um trace isolado e desconectado dos demais.',
     2, 'v1', 'rascunho'),
    ((SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000003'),
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'OpenTelemetry e amostragem',
     'OpenTelemetry é hoje o padrão de facto (open source, vendor-neutral) para instrumentar aplicações e emitir traces, métricas e logs em formato compatível com múltiplos backends (Jaeger, Zipkin, Grafana Tempo, entre outros). Como capturar 100% das requisições em um sistema de altíssimo volume tem custo de armazenamento e processamento relevante, é comum aplicar amostragem (sampling): registrar detalhadamente apenas uma fração das requisições (ex.: 1% do tráfego normal), mas sempre capturar 100% das requisições com erro ou latência anormal — essas são as que mais importam para diagnóstico.',
     3, 'v1', 'rascunho');

-- Concept: SLIs, SLOs e SLAs
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ((SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000004'),
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'SLI: o que medir',
     'Service Level Indicator (SLI) é uma métrica quantitativa que mede um aspecto da experiência do usuário com o serviço — por exemplo, a proporção de requisições HTTP respondidas com sucesso em menos de 300ms, ou a proporção de leituras que retornam dado atualizado. Um bom SLI é centrado no usuário, não na infraestrutura: "CPU abaixo de 80%" não é um SLI útil por si só, porque o usuário não sente CPU, sente latência e erros. O SLI é a base numérica sobre a qual todo o resto (SLO, error budget, alertas) é construído.',
     1, 'v1', 'rascunho'),
    ((SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000004'),
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'SLO e error budget',
     'Service Level Objective (SLO) é a meta interna de confiabilidade para um SLI, definida como um intervalo de tempo e um alvo (ex.: "99,9% das requisições respondidas com sucesso em 30 dias"). O complemento do SLO — os 0,1% restantes no exemplo acima — é o error budget: a quantidade de falha que o sistema pode ter sem violar a meta. O error budget é uma ferramenta de decisão: enquanto ele não estiver esgotado, a equipe pode assumir mais risco (deploys mais frequentes, experimentos); quando se esgota, a prioridade muda para estabilidade até o orçamento se recompor no próximo período.',
     2, 'v1', 'rascunho'),
    ((SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000004'),
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'SLA: a diferença contratual',
     'Service Level Agreement (SLA) é um compromisso externo, geralmente contratual, com consequências (créditos, reembolsos, penalidades) caso não seja cumprido — normalmente firmado com clientes ou definido por um provedor de nuvem. Por prudência, o SLA costuma ser definido com uma margem folgada em relação ao SLO interno (ex.: SLO interno de 99,95%, SLA externo de 99,9%), porque o SLA tem custo real de descumprimento e o SLO serve exatamente para dar essa margem de segurança antes de um problema virar violação contratual.',
     3, 'v1', 'rascunho');

-- Concept: Tolerância a falhas e recuperação
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ((SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Retries com backoff e timeouts',
     'Falhas transitórias (uma conexão de rede momentaneamente instável, um serviço reiniciando) frequentemente se resolvem sozinhas em segundos — por isso, tentar novamente (retry) é uma estratégia válida. Mas retries sem cuidado podem piorar um incidente: retentar imediatamente e sem limite, em massa, gera uma "tempestade de retries" que sobrecarrega ainda mais um serviço já degradado. Por isso, retries devem ter número máximo de tentativas, backoff exponencial (esperar progressivamente mais entre tentativas) e idealmente jitter (variação aleatória no tempo de espera) para evitar que múltiplos clientes retentem exatamente no mesmo instante. Retries sempre devem ser combinados com um timeout: sem timeout, uma chamada pode ficar presa indefinidamente esperando uma resposta que nunca chega.',
     1, 'v1', 'rascunho'),
    ((SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Circuit breaker e bulkhead',
     'Circuit breaker é um padrão que interrompe chamadas a uma dependência que está falhando repetidamente, "abrindo o circuito" e retornando erro imediatamente (ou uma resposta alternativa) por um período, em vez de continuar tentando e desperdiçando recursos (threads, conexões) em chamadas fadadas a falhar. Após esse período, o circuito entra em estado "meio-aberto" e permite algumas chamadas de teste; se voltarem a funcionar, o circuito fecha e o tráfego normal é restabelecido. Bulkhead é um padrão complementar: isola recursos (ex.: pools de threads ou conexões separados por dependência) para que a falha ou lentidão de uma dependência não esgote os recursos compartilhados e derrube também as chamadas a dependências saudáveis — o nome vem dos compartimentos estanques de um navio, que impedem que um alagamento afunde o casco inteiro.',
     2, 'v1', 'rascunho'),
    ((SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Disaster recovery: RTO e RPO',
     'Disaster recovery trata de como o sistema se recupera de falhas catastróficas (perda de um datacenter inteiro, corrupção grave de dados). Dois indicadores centrais orientam a estratégia: RTO (Recovery Time Objective) é o tempo máximo aceitável para restaurar o serviço após um desastre; RPO (Recovery Point Objective) é a quantidade máxima aceitável de dados perdidos, medida em tempo (ex.: "no máximo 5 minutos de dados perdidos" implica backups ou replicação com essa frequência). RTO e RPO próximos de zero (alta disponibilidade, replicação síncrona multi-região) custam significativamente mais caro em infraestrutura do que RTO/RPO de horas — a escolha é uma decisão de negócio sobre risco tolerável, não apenas uma decisão técnica.',
     3, 'v1', 'rascunho');

-- =====================================================================================
-- FLASHCARDS (15 — 3 por Concept)
-- =====================================================================================

INSERT INTO flashcard (domain_ref, concept_ref, frente, verso, dificuldade, content_version, status_revisao)
VALUES
    ((SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000001'),
     'O que é logging estruturado?',
     'Registrar eventos como dados com campos nomeados (ex.: JSON), em vez de texto livre, permitindo busca, filtro e agregação eficientes em ferramentas de observabilidade.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000001'),
     'Para que serve um correlation_id (ou trace_id) nos logs?',
     'Para conectar todos os logs gerados por uma mesma requisição, mesmo que ela atravesse múltiplos serviços, permitindo reconstruir a jornada completa da chamada durante uma investigação.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000001'),
     'Cite dois cuidados importantes sobre o que logar.',
     'Nunca logar dados sensíveis em texto claro (senhas, tokens, dados pessoais) e evitar logging excessivo em loops de alta frequência, preferindo resumos agregados.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000002'),
     'Qual a diferença entre counter e gauge?',
     'Counter só cresce (ex.: total de requisições); gauge sobe e desce livremente (ex.: uso de memória atual, conexões abertas).',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000002'),
     'Por que usar percentis (p95/p99) em vez de média para latência?',
     'Porque a média esconde outliers: uma média baixa pode conviver com uma fração relevante de requisições muito lentas, que são exatamente as que mais afetam a experiência do usuário.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000002'),
     'Quais são os quatro sinais de ouro do monitoramento (Google SRE)?',
     'Latência, tráfego, erros e saturação.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000003'),
     'O que é um span em tracing distribuído?',
     'Uma unidade de trabalho dentro de um trace (ex.: uma chamada HTTP ou uma query de banco), com identificador próprio e referência ao span pai, formando uma árvore de execução.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000003'),
     'Como o trace_id é propagado entre serviços diferentes?',
     'Tipicamente via cabeçalhos HTTP propagados de serviço a serviço, seguindo um padrão como o W3C Trace Context (cabeçalhos traceparent/tracestate).',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000003'),
     'Por que aplicar amostragem (sampling) em tracing?',
     'Porque capturar 100% das requisições tem custo alto de armazenamento e processamento em sistemas de grande volume; amostra-se uma fração do tráfego normal, mas preserva-se 100% das requisições com erro ou latência anormal.',
     'dificil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000004'),
     'O que é um SLI?',
     'Service Level Indicator: uma métrica quantitativa e centrada no usuário que mede um aspecto da experiência com o serviço (ex.: proporção de requisições bem-sucedidas em menos de 300ms).',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000004'),
     'O que é error budget e para que serve na prática?',
     'É a margem de falha permitida por um SLO (ex.: 0,1% se o SLO é 99,9%). Enquanto não esgotado, a equipe pode assumir mais risco em deploys; quando esgotado, a prioridade muda para estabilidade.',
     'dificil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000004'),
     'Qual a diferença principal entre SLO e SLA?',
     'SLO é uma meta interna de confiabilidade; SLA é um compromisso externo/contratual, geralmente com penalidades em caso de descumprimento, e costuma ter margem mais folgada que o SLO interno.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
     'Por que retries devem usar backoff exponencial e jitter, não intervalo fixo?',
     'Para evitar uma "tempestade de retries" que sobrecarrega ainda mais um serviço já degradado; o backoff espaça as tentativas progressivamente e o jitter evita que múltiplos clientes retentem no mesmo instante.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
     'O que faz um circuit breaker quando está "aberto"?',
     'Interrompe chamadas à dependência que está falhando repetidamente, retornando erro imediato (ou fallback) sem tentar de fato a chamada, até um período de espera terminar e permitir chamadas de teste.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
     'O que medem RTO e RPO em disaster recovery?',
     'RTO (Recovery Time Objective) mede o tempo máximo aceitável para restaurar o serviço; RPO (Recovery Point Objective) mede a quantidade máxima aceitável de dados perdidos, tipicamente em tempo.',
     'dificil', 'v1', 'rascunho');

-- =====================================================================================
-- QUESTIONS + ALTERNATIVAS (18 — 6 facil, 6 media, 6 dificil)
-- =====================================================================================

-- Q1 (facil) — Logging estruturado
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000001',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000001'),
        'Qual é a principal vantagem do logging estruturado (ex.: JSON) em relação a logs de texto livre?',
        'Logs estruturados registram campos nomeados, o que permite indexar, filtrar e agregar diretamente em ferramentas de observabilidade, sem depender de parsing frágil com regex sobre texto livre.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000001', 'Permite busca, filtro e agregação eficientes por campo, sem parsing frágil', true),
    ('a1a20000-0000-4000-8000-000000000001', 'Reduz automaticamente o tamanho em disco de todos os arquivos de log', false),
    ('a1a20000-0000-4000-8000-000000000001', 'Elimina a necessidade de definir níveis de severidade (INFO, WARN, ERROR)', false),
    ('a1a20000-0000-4000-8000-000000000001', 'Garante que o log nunca conterá dados sensíveis', false);

-- Q2 (facil) — Métricas
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000002',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000002'),
        'Qual tipo de métrica é mais adequado para representar o número de conexões atualmente abertas em um pool?',
        'Gauge representa um valor que sobe e desce livremente ao longo do tempo, exatamente o comportamento do número de conexões abertas em um dado instante.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000002', 'Gauge', true),
    ('a1a20000-0000-4000-8000-000000000002', 'Counter', false),
    ('a1a20000-0000-4000-8000-000000000002', 'Histogram', false),
    ('a1a20000-0000-4000-8000-000000000002', 'Trace', false);

-- Q3 (facil) — Métricas / quatro sinais de ouro
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000003',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000002'),
        'Segundo o modelo dos "quatro sinais de ouro" do Google SRE, quais são os sinais recomendados para monitorar um serviço?',
        'Os quatro sinais de ouro são latência, tráfego, erros e saturação — juntos, cobrem a maior parte dos sintomas relevantes de um incidente em produção.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000003', 'Latência, tráfego, erros e saturação', true),
    ('a1a20000-0000-4000-8000-000000000003', 'CPU, memória, disco e rede', false),
    ('a1a20000-0000-4000-8000-000000000003', 'Uptime, versão, ambiente e região', false),
    ('a1a20000-0000-4000-8000-000000000003', 'Logs, métricas, traces e alertas', false);

-- Q4 (facil) — Tracing
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000004',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000003'),
        'Em tracing distribuído, o que representa um "span"?',
        'Um span representa uma unidade de trabalho dentro de um trace, como uma chamada HTTP ou uma query de banco; múltiplos spans, ligados por referência ao pai, formam a árvore de execução do trace.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000004', 'Uma unidade de trabalho dentro do trace, como uma chamada HTTP ou uma query', true),
    ('a1a20000-0000-4000-8000-000000000004', 'O identificador único de um usuário autenticado na requisição', false),
    ('a1a20000-0000-4000-8000-000000000004', 'Um arquivo de configuração do coletor de métricas', false),
    ('a1a20000-0000-4000-8000-000000000004', 'A média de latência de todos os serviços em um período', false);

-- Q5 (facil) — SLI/SLO
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000005',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000004'),
        'O que é um SLI (Service Level Indicator)?',
        'SLI é uma métrica quantitativa, centrada na experiência do usuário, que mede um aspecto da confiabilidade do serviço — por exemplo, a proporção de requisições respondidas com sucesso em menos de 300ms.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000005', 'Uma métrica quantitativa que mede um aspecto da experiência do usuário com o serviço', true),
    ('a1a20000-0000-4000-8000-000000000005', 'Um contrato externo com penalidades financeiras por descumprimento', false),
    ('a1a20000-0000-4000-8000-000000000005', 'A quantidade máxima de dados que um sistema pode perder em um desastre', false),
    ('a1a20000-0000-4000-8000-000000000005', 'O tempo máximo aceitável para restaurar um serviço após uma falha', false);

-- Q6 (facil) — Tolerância a falhas
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000006',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'Por que uma chamada com retry deve sempre ser combinada com um timeout?',
        'Sem timeout, uma chamada pode ficar presa indefinidamente esperando uma resposta que nunca chega, impedindo inclusive que o mecanismo de retry seja acionado a tempo.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000006', 'Para evitar que a chamada fique presa indefinidamente esperando uma resposta que nunca chega', true),
    ('a1a20000-0000-4000-8000-000000000006', 'Para reduzir o número de logs gerados pela aplicação', false),
    ('a1a20000-0000-4000-8000-000000000006', 'Porque timeouts eliminam a necessidade de circuit breakers', false),
    ('a1a20000-0000-4000-8000-000000000006', 'Para garantir que a resposta seja sempre bem-sucedida na segunda tentativa', false);

-- Q7 (media) — Logging
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000007',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000001'),
        'Um usuário reporta uma falha intermitente que atravessa três microsserviços. Qual prática de logging mais ajudaria a reconstruir a jornada completa dessa requisição?',
        'Incluir um correlation_id (ou trace_id) comum em todos os logs gerados pela mesma requisição, em todos os serviços, permite reconstruir a jornada completa correlacionando os registros por esse identificador.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000007', 'Incluir um correlation_id comum em todos os logs gerados pela mesma requisição', true),
    ('a1a20000-0000-4000-8000-000000000007', 'Aumentar o nível de log para DEBUG permanentemente em produção', false),
    ('a1a20000-0000-4000-8000-000000000007', 'Consolidar todos os logs de todos os serviços em um único arquivo de texto livre', false),
    ('a1a20000-0000-4000-8000-000000000007', 'Registrar apenas logs de nível ERROR, ignorando INFO e WARN', false);

-- Q8 (media) — Métricas
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000008',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000002'),
        'Por que confiar apenas na latência média de uma API pode esconder um problema real de experiência do usuário?',
        'A média pode ser baixa mesmo com uma fração relevante de requisições muito lentas (outliers), porque valores altos e baixos se compensam na média; percentis como p95/p99 revelam esses outliers, que costumam afetar diretamente a experiência do usuário mais sensível.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000008', 'A média pode esconder outliers: uma parcela de requisições pode estar muito lenta sem alterar muito a média geral', true),
    ('a1a20000-0000-4000-8000-000000000008', 'A latência média sempre é medida em uma unidade diferente da latência real', false),
    ('a1a20000-0000-4000-8000-000000000008', 'Ferramentas de monitoramento não conseguem calcular a média corretamente', false),
    ('a1a20000-0000-4000-8000-000000000008', 'A latência média não pode ser coletada via modelo pull', false);

-- Q9 (media) — Tracing
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000009',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000003'),
        'Como o trace_id de uma requisição é tipicamente propagado entre serviços diferentes em uma arquitetura de microsserviços?',
        'A propagação normalmente ocorre via cabeçalhos HTTP passados de serviço a serviço, seguindo um padrão como o W3C Trace Context (cabeçalhos traceparent/tracestate), permitindo que todos os spans da requisição sejam agrupados no mesmo trace.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000009', 'Via cabeçalhos HTTP propagados entre serviços, seguindo um padrão como o W3C Trace Context', true),
    ('a1a20000-0000-4000-8000-000000000009', 'Via variável de ambiente configurada manualmente em cada servidor', false),
    ('a1a20000-0000-4000-8000-000000000009', 'O trace_id é gerado independentemente por cada serviço e nunca precisa ser compartilhado', false),
    ('a1a20000-0000-4000-8000-000000000009', 'Através do corpo (body) da resposta HTTP de cada serviço', false);

-- Q10 (media) — SLO / error budget
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000010',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000004'),
        'Uma equipe define um SLO de 99,9% de disponibilidade em 30 dias. O que representa o "error budget" nesse cenário?',
        'O error budget é o complemento do SLO — no exemplo, os 0,1% de falha tolerada em 30 dias — e funciona como orçamento de risco: enquanto não esgotado, a equipe pode assumir mais risco em deploys; quando se esgota, a prioridade muda para estabilizar o serviço.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000010', 'A quantidade de falha tolerada (0,1% no exemplo) que a equipe pode "gastar" assumindo mais risco em deploys', true),
    ('a1a20000-0000-4000-8000-000000000010', 'O valor em dinheiro reembolsado ao cliente quando o SLA é violado', false),
    ('a1a20000-0000-4000-8000-000000000010', 'O tempo máximo que a equipe de plantão pode levar para responder a um alerta', false),
    ('a1a20000-0000-4000-8000-000000000010', 'A quantidade de logs que podem ser descartados antes de afetar o diagnóstico', false);

-- Q11 (media) — Circuit breaker
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000011',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'Qual é o objetivo principal de um circuit breaker ao detectar falhas repetidas em uma dependência externa?',
        'O circuit breaker interrompe (abre o circuito) as chamadas para essa dependência, retornando erro imediato ou uma resposta alternativa, evitando desperdiçar recursos em chamadas fadadas a falhar e dando tempo para a dependência se recuperar.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000011', 'Interromper as chamadas à dependência com falha, evitando desperdiçar recursos em tentativas fadadas a falhar', true),
    ('a1a20000-0000-4000-8000-000000000011', 'Aumentar automaticamente o número de retries até a chamada ter sucesso', false),
    ('a1a20000-0000-4000-8000-000000000011', 'Registrar métricas de latência com maior granularidade durante o incidente', false),
    ('a1a20000-0000-4000-8000-000000000011', 'Redirecionar todo o tráfego para uma nova versão da aplicação (canary release)', false);

-- Q12 (media) — Bulkhead
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000012',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'Qual problema o padrão bulkhead (isolamento de recursos por dependência) busca evitar?',
        'Bulkhead isola pools de recursos (threads, conexões) por dependência, evitando que a lentidão ou falha de uma dependência esgote recursos compartilhados e derrube também chamadas a dependências saudáveis.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000012', 'Que a falha ou lentidão de uma dependência esgote recursos compartilhados e afete dependências saudáveis', true),
    ('a1a20000-0000-4000-8000-000000000012', 'Que dois serviços diferentes usem a mesma versão de uma biblioteca', false),
    ('a1a20000-0000-4000-8000-000000000012', 'Que logs de serviços diferentes fiquem armazenados no mesmo banco de dados', false),
    ('a1a20000-0000-4000-8000-000000000012', 'Que métricas de CPU e memória sejam coletadas com frequências diferentes', false);

-- Q13 (dificil) — Amostragem em tracing
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000013',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000003'),
        'Um sistema de altíssimo volume aplica amostragem de 1% em tracing distribuído para controlar custo. Qual estratégia preserva melhor a capacidade de diagnóstico sem eliminar a amostragem?',
        'A estratégia recomendada é amostrar apenas uma fração do tráfego normal (ex.: 1%), mas sempre capturar 100% das requisições com erro ou latência anormal, já que são as que mais importam para diagnosticar um problema.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000013', 'Manter a amostragem de 1% no tráfego normal, mas capturar 100% das requisições com erro ou latência anormal', true),
    ('a1a20000-0000-4000-8000-000000000013', 'Desativar completamente a amostragem sempre que o tráfego ultrapassar um limiar', false),
    ('a1a20000-0000-4000-8000-000000000013', 'Aumentar a amostragem para 100% apenas em ambiente de desenvolvimento', false),
    ('a1a20000-0000-4000-8000-000000000013', 'Substituir o tracing por logging estruturado quando o volume for muito alto', false);

-- Q14 (dificil) — SLA vs SLO
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000014',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000004'),
        'Por que uma empresa normalmente define um SLA externo (ex.: 99,9%) mais folgado que seu SLO interno (ex.: 99,95%) para o mesmo serviço?',
        'O SLO interno serve como margem de segurança: como o SLA tem consequências contratuais (créditos, penalidades) em caso de violação, manter um SLO interno mais rígido dá à equipe tempo de reagir a uma degradação antes que ela chegue a violar o compromisso externo.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000014', 'Para dar margem de segurança: o SLA tem penalidades contratuais, e o SLO mais rígido permite agir antes de violá-lo', true),
    ('a1a20000-0000-4000-8000-000000000014', 'Porque o SLA é medido com uma ferramenta menos precisa do que o SLO', false),
    ('a1a20000-0000-4000-8000-000000000014', 'Porque o SLO não pode, por definição, ser mais rígido que o SLA', false),
    ('a1a20000-0000-4000-8000-000000000014', 'Porque o SLA é sempre definido pelo mesmo time que define os SLIs', false);

-- Q15 (dificil) — Retries em cascata
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000015',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'Um serviço já degradado começa a receber uma onda de retries imediatos e sem limite vindos de múltiplos clientes simultaneamente. Qual combinação de práticas mais reduziria o risco de essa onda piorar o incidente?',
        'Backoff exponencial espaça progressivamente as tentativas, jitter evita que múltiplos clientes retentem exatamente no mesmo instante, e um número máximo de tentativas evita retries indefinidos — juntas, essas práticas reduzem a pressão adicional sobre um serviço já degradado.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000015', 'Backoff exponencial com jitter e número máximo de tentativas', true),
    ('a1a20000-0000-4000-8000-000000000015', 'Remover completamente qualquer timeout para permitir que as chamadas sempre terminem', false),
    ('a1a20000-0000-4000-8000-000000000015', 'Aumentar o número de threads do cliente para paralelizar ainda mais as tentativas', false),
    ('a1a20000-0000-4000-8000-000000000015', 'Reduzir o intervalo entre tentativas para acelerar a recuperação', false);

-- Q16 (dificil) — RTO/RPO
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000016',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'Uma empresa define RPO de 5 minutos para seu banco de dados principal. O que essa definição exige, na prática, da estratégia de backup/replicação?',
        'Um RPO de 5 minutos implica que, no pior caso, no máximo 5 minutos de dados podem ser perdidos em um desastre — o que exige backups ou replicação com frequência igual ou menor que esse intervalo (ex.: replicação contínua ou backups incrementais a cada poucos minutos).',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000016', 'Backups ou replicação com frequência igual ou menor que 5 minutos, para limitar a perda máxima de dados nesse intervalo', true),
    ('a1a20000-0000-4000-8000-000000000016', 'O sistema deve ser restaurado em, no máximo, 5 minutos após o desastre', false),
    ('a1a20000-0000-4000-8000-000000000016', 'O time de plantão deve responder a qualquer alerta em até 5 minutos', false),
    ('a1a20000-0000-4000-8000-000000000016', 'A aplicação deve reiniciar automaticamente a cada 5 minutos para evitar corrupção', false);

-- Q17 (dificil) — Diagnóstico combinando pilares de observabilidade
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000017',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        NULL,
        'Um painel de métricas mostra um aumento na taxa de erro de um serviço, mas não indica a causa. Qual é o próximo passo mais eficiente para identificar a causa raiz, assumindo que logging e tracing estão instrumentados com correlation_id e trace_id compartilhados?',
        'Métricas indicam "que" algo está errado (sintoma agregado), mas não "por quê". O próximo passo eficiente é usar traces das requisições com erro para identificar em qual serviço/etapa a falha ocorre, e então cruzar com os logs correlacionados pelo mesmo trace_id daquele span específico para obter o detalhe (ex.: exceção, payload) do erro.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000017', 'Investigar traces das requisições com erro para localizar o serviço/etapa problemática e cruzar com os logs correlacionados por trace_id', true),
    ('a1a20000-0000-4000-8000-000000000017', 'Aumentar o nível de log para DEBUG em todos os serviços permanentemente', false),
    ('a1a20000-0000-4000-8000-000000000017', 'Reiniciar todos os serviços da arquitetura para eliminar o estado corrompido', false),
    ('a1a20000-0000-4000-8000-000000000017', 'Reduzir a frequência de coleta de métricas até a taxa de erro normalizar', false);

-- Q18 (dificil) — Diferença logs/métricas/traces
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000018',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        NULL,
        'Qual das alternativas descreve corretamente a diferença fundamental de propósito entre métricas, logs e traces em observabilidade?',
        'Métricas são agregados numéricos ao longo do tempo (bons para detectar "que" algo mudou e disparar alertas); logs são eventos discretos com contexto detalhado de um acontecimento específico; traces mostram o caminho e a duração de uma requisição através de múltiplos serviços. Os três são complementares, não substitutos entre si.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000018', 'Métricas agregam tendências ao longo do tempo, logs registram eventos discretos detalhados, e traces mostram o caminho de uma requisição entre serviços', true),
    ('a1a20000-0000-4000-8000-000000000018', 'Métricas, logs e traces são formatos alternativos e intercambiáveis para o mesmo tipo de dado', false),
    ('a1a20000-0000-4000-8000-000000000018', 'Logs substituem métricas em sistemas de pequeno porte, tornando-as desnecessárias', false),
    ('a1a20000-0000-4000-8000-000000000018', 'Traces são usados apenas em ambiente de desenvolvimento, nunca em produção', false);
