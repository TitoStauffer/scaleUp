-- Ampliação do pool de Slides — Domínio Observabilidade e Confiabilidade (slug 'observabilidade-confiabilidade'), Fase 1.
-- TICKET-content-expansion-slides-fase1.md: adiciona 2 Slides novos por Concept (ordem 4 =
-- erros comuns/armadilhas, ordem 5 = comparação com alternativa) às 3 já existentes em
-- V19__seed_conteudo_observabilidade_confiabilidade.sql, elevando o pool para 5 Slides por Concept / 25 no domínio.

-- Concept: Logging estruturado
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a1a10000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Erro comum: engolir a stack trace ao logar exceções',
     'Um erro comum é capturar uma exceção e logar apenas a mensagem (ex.: log.error(e.getMessage())), descartando o stack trace. Parece suficiente porque a mensagem costuma ser legível e descreve o problema em texto claro, mas sem o stack trace é impossível saber em qual linha, método ou chamada aninhada a exceção realmente ocorreu — especialmente em exceções encadeadas (causadas por outra exceção), onde a mensagem de topo às vezes nem menciona a causa raiz. A prática correta é sempre logar o objeto da exceção inteiro (ex.: log.error("mensagem", e)), preservando o stack trace completo para investigação posterior.',
     4, 'v1', 'rascunho'),
    ('a1a10000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Logging vs. métricas: qual cardinalidade cada um suporta',
     'Logging estruturado e métricas resolvem problemas parecidos — ambos monitoram o comportamento do sistema — mas não são substitutos: métricas são agregados numéricos pré-computados, baratos de armazenar e consultar mesmo em altíssimo volume, mas perdem o detalhe de qualquer evento individual. Logs preservam o contexto completo de um evento específico, mas custam caro em armazenamento e indexação quando o campo logado tem alta cardinalidade (ex.: user_id, request_id). O critério prático: use métricas para tendências e contagens agregadas (quantas requisições falharam na última hora) e reserve logs estruturados para os campos de alta cardinalidade que precisam ser buscáveis individualmente (qual requisição específica falhou, e por quê) — transformar toda métrica em uma label de alta cardinalidade normalmente estoura o custo do sistema de métricas.',
     5, 'v1', 'rascunho');

-- Concept: Métricas e monitoramento
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a1a10000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Erro comum: alertar em causa (CPU) em vez de sintoma (erro/latência)',
     'Um erro comum é configurar alertas diretamente sobre métricas de causa, como "CPU acima de 80%" ou "uso de memória acima de 90%", em vez de sintomas percebidos pelo usuário, como taxa de erro ou latência. Parece razoável porque CPU alta é um sinal real de que algo está sob pressão, mas nem toda CPU alta afeta o usuário (um serviço pode rodar a 95% de CPU e responder normalmente dentro do SLO) e nem todo problema real gera CPU alta (um serviço pode estar com 10% de CPU e ainda assim retornar 50% de erros por causa de uma dependência externa travada). Alertar por causa gera fadiga de alerta com falsos positivos frequentes; a prática recomendada é alertar por sintoma e usar métricas de causa apenas como dado de diagnóstico depois que o alerta de sintoma já disparou.',
     4, 'v1', 'rascunho'),
    ('a1a10000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Métricas vs. tracing: tendência agregada ou caminho individual',
     'Métricas e tracing distribuído são complementares, não concorrentes diretos, mas respondem perguntas diferentes: métricas mostram uma tendência agregada ao longo do tempo (a taxa de erro do serviço X subiu 3% na última hora), enquanto um trace mostra o caminho individual e o tempo gasto em cada etapa de uma requisição específica. O critério prático: métricas são o primeiro sinal — baratas de manter ligadas continuamente para todo o tráfego, e são o que dispara o alerta de que algo mudou; tracing é a ferramenta de investigação — mais cara por requisição mesmo com amostragem, usada depois que a métrica já indicou que existe um problema, para descobrir em qual serviço específico da cadeia ele está.',
     5, 'v1', 'rascunho');

-- Concept: Tracing distribuído
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a1a10000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Erro comum: trace quebrado em fronteiras assíncronas',
     'Um erro comum ao instrumentar tracing distribuído é assumir que a auto-instrumentação (ex.: agentes de OpenTelemetry) propaga o contexto do trace automaticamente em qualquer cenário. Isso é verdade para chamadas síncronas diretas (HTTP, gRPC), mas quebra em fronteiras assíncronas — publicar uma mensagem em uma fila (Kafka, SQS) ou despachar um job para um thread pool separado não propaga o trace_id por padrão, porque o contexto normalmente vive em uma variável thread-local que não atravessa a fronteira assíncrona. O resultado é um trace fragmentado em pedaços desconectados, cada um parecendo uma requisição nova — a instrumentação automática precisa ser complementada manualmente para injetar e extrair o contexto nesses pontos.',
     4, 'v1', 'rascunho'),
    ('a1a10000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Tracing vs. logs correlacionados: quando o correlation_id não basta',
     'Uma alternativa mais simples ao tracing distribuído completo é usar apenas logs correlacionados por um correlation_id comum entre serviços, sem estrutura formal de spans. Isso funciona bem para reconstruir que uma requisição passou pelos serviços A, B e C, mas não mostra a hierarquia (quem chamou quem) nem quanto tempo cada etapa individualmente consumiu dentro do tempo total — informação que só uma árvore de spans com timestamps de início/fim fornece. O critério prático: se a cadeia de chamadas é rasa (dois ou três serviços) e o objetivo é só juntar logs relacionados, o correlation_id já basta e é mais barato de manter; se a cadeia tem muitos saltos e a pergunta é "onde exatamente o tempo foi gasto", vale o custo adicional de instrumentar tracing completo com spans.',
     5, 'v1', 'rascunho');

-- Concept: SLIs, SLOs e SLAs
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a1a10000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Erro comum: medir o SLI no ponto errado da cadeia',
     'Um erro comum é medir o SLI no ponto errado da cadeia — por exemplo, calcular a taxa de sucesso a partir dos logs do próprio servidor de aplicação, contando apenas requisições que efetivamente chegaram até ele. Isso parece correto porque é o dado mais fácil de coletar (já está nos logs da aplicação), mas ignora falhas que acontecem antes de chegar ao servidor: timeout de conexão, erro de DNS ou rejeição no load balancer nunca aparecem nesse SLI, mesmo sendo falhas reais que o usuário sentiu. A medição mais correta captura o SLI o mais próximo possível do usuário (ex.: no load balancer, no CDN, ou via telemetria do cliente), para que falhas de rede e de infraestrutura anteriores ao servidor também sejam contabilizadas.',
     4, 'v1', 'rascunho'),
    ('a1a10000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'SLO realista vs. meta de 100% de disponibilidade',
     'Uma alternativa (na verdade, um erro de design frequente) ao SLO calibrado com error budget é definir a meta interna como 100% de disponibilidade. Parece a escolha mais segura — nenhum erro é "permitido" —, mas 100% é praticamente impossível de sustentar (mesmo provedores de nuvem têm SLAs abaixo de 100%) e, pior, remove qualquer margem de risco calculado: toda mudança vira uma ameaça à meta, o que trava a velocidade de deploys sem necessariamente entregar mais confiabilidade real ao usuário. O critério prático para escolher a meta: um SLO deve ficar levemente acima do que o usuário percebe como bom o suficiente (ex.: 99,9%, não 100%), definido a partir de dados reais de expectativa do usuário — não a partir da ambição de zero falhas.',
     5, 'v1', 'rascunho');

-- Concept: Tolerância a falhas e recuperação
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a1a10000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Erro comum: retry automático em operação não idempotente',
     'Um erro comum é aplicar retry automático indiscriminadamente a qualquer chamada que falhe, incluindo operações não idempotentes como um POST que cria um recurso ou processa um pagamento. Parece seguro porque "tentar de novo" é uma prática geral recomendada para lidar com falhas transitórias, mas se a primeira tentativa na verdade teve sucesso no servidor e só a resposta se perdeu na rede antes de chegar ao cliente, o retry cria um segundo recurso ou processa o pagamento duas vezes. A prática correta é só aplicar retry automático a operações idempotentes por natureza (GET, PUT que substitui o estado inteiro) ou usar uma chave de idempotência explícita que o servidor possa checar para descartar tentativas duplicadas da mesma operação.',
     4, 'v1', 'rascunho'),
    ('a1a10000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
     'Circuit breaker vs. load shedding: proteger quem chama ou quem é chamado',
     'Circuit breaker e load shedding (descarte de carga) são padrões de resiliência complementares, mas protegem lados diferentes da chamada: o circuit breaker protege quem está chamando uma dependência que está falhando, evitando desperdiçar recursos em chamadas fadadas ao fracasso. Load shedding (junto com rate limiting) protege o próprio serviço de ser sobrecarregado, rejeitando ou desacelerando requisições recebidas quando sua própria capacidade está no limite, independentemente da saúde de suas dependências. O critério prático: use circuit breaker quando o problema está em uma dependência downstream (banco, API externa) que o seu serviço chama; use load shedding/rate limiting quando o problema é volume de tráfego recebido excedendo a capacidade do próprio serviço.',
     5, 'v1', 'rascunho');
