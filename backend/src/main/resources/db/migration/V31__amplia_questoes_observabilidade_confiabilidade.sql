-- Ampliação do pool de Questions — Domínio Observabilidade e Confiabilidade (Fase 1)
-- Referência: docs/product/tickets/TICKET-content-expansion-questoes.md
-- Adiciona 18 Questions NOVAS (6 facil, 6 media, 6 dificil), somando às 18 já existentes
-- em V19__seed_conteudo_observabilidade_confiabilidade.sql (total: 36 no domínio).
-- Nenhum Concept/Slide/Flashcard novo; reaproveita os 5 Concepts já existentes (UUIDs
-- 'a1a10000-0000-4000-8000-00000000000X' criados em V19).
-- content_version = 'v1' e status_revisao = 'rascunho', mesma regra do lote original.
-- V19 foi lido integralmente antes da escrita deste arquivo: nenhum dos 18 enunciados
-- abaixo repete, literalmente ou por reformulação, os 18 enunciados de V19 (logging
-- estruturado, tipos de métrica, quatro sinais de ouro, span, SLI, timeout+retry,
-- correlation_id em falha intermitente, média vs. percentis, propagação de trace_id,
-- error budget, circuit breaker, bulkhead, amostragem, SLA vs. SLO, tempestade de
-- retries, RTO/RPO, diagnóstico métricas->traces->logs, diferença logs/métricas/traces).
-- Question + suas 4 alternativas são inseridas na mesma transação de migração, conforme
-- exigido pelo trigger de constraint adiada trg_verificar_alternativas_question (V6).

-- =====================================================================================
-- QUESTIONS + ALTERNATIVAS (18 novas — 6 facil, 6 media, 6 dificil)
-- =====================================================================================

-- Q19 (facil) — Logging estruturado / níveis de log
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000019',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000001'),
        'Em produção, qual é a prática mais recomendada em relação ao nível de log padrão de uma aplicação?',
        'Rodar com nível INFO ou WARN em produção reduz ruído e custo de armazenamento; o nível DEBUG deve ser elevado pontualmente apenas durante a investigação de um problema específico, não mantido permanentemente ligado.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000019', 'Manter o nível padrão em INFO ou WARN, elevando para DEBUG apenas ao investigar um problema pontual', true),
    ('a1a20000-0000-4000-8000-000000000019', 'Manter DEBUG ligado permanentemente em produção para nunca perder detalhes', false),
    ('a1a20000-0000-4000-8000-000000000019', 'Usar apenas o nível FATAL, já que os demais níveis são redundantes', false),
    ('a1a20000-0000-4000-8000-000000000019', 'Desativar todo logging em produção para reduzir custo de armazenamento', false);

-- Q20 (facil) — Dados sensíveis em log
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000020',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000001'),
        'Por que registrar senhas ou tokens de autenticação em texto claro nos logs de uma aplicação é considerado uma falha grave?',
        'O pipeline de logging costuma ter controles de acesso menos rígidos que o banco de dados principal; registrar dados sensíveis em texto claro nos logs cria um canal adicional de vazamento, muitas vezes menos protegido e monitorado.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000020', 'Porque o pipeline de logging costuma ter controles de acesso mais fracos, criando um canal extra de vazamento de dados', true),
    ('a1a20000-0000-4000-8000-000000000020', 'Porque logs em texto claro ocupam mais espaço em disco que logs estruturados', false),
    ('a1a20000-0000-4000-8000-000000000020', 'Porque ferramentas como Elasticsearch não conseguem indexar campos sensíveis', false),
    ('a1a20000-0000-4000-8000-000000000020', 'Porque isso impede a aplicação de níveis de severidade nos logs', false);

-- Q21 (facil) — Coleta pull vs push
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000021',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000002'),
        'No modelo de coleta "pull" de métricas, usado pelo Prometheus, como o sistema de monitoramento obtém os dados de cada serviço?',
        'No modelo pull, o sistema de monitoramento busca periodicamente ("faz scrape") as métricas expostas por cada serviço em um endpoint HTTP, em vez de esperar que o serviço as envie ativamente.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000021', 'O sistema de monitoramento busca periodicamente ("faz scrape") as métricas em um endpoint exposto pelo serviço', true),
    ('a1a20000-0000-4000-8000-000000000021', 'Cada serviço envia ativamente suas métricas para um coletor central, sem ser consultado', false),
    ('a1a20000-0000-4000-8000-000000000021', 'As métricas são lidas diretamente do banco de dados da aplicação', false),
    ('a1a20000-0000-4000-8000-000000000021', 'O usuário final envia as métricas manualmente através de um formulário', false);

-- Q22 (facil) — Contador de requisições
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000022',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000002'),
        'Qual tipo de métrica é o mais adequado para representar o total acumulado de requisições recebidas por uma API desde que ela iniciou?',
        'Counter é um valor que só cresce, apropriado para totais acumulados como número de requisições recebidas; a partir dele é possível calcular taxas (requisições/segundo) tomando a derivada no tempo.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000022', 'Counter', true),
    ('a1a20000-0000-4000-8000-000000000022', 'Gauge', false),
    ('a1a20000-0000-4000-8000-000000000022', 'Histogram', false),
    ('a1a20000-0000-4000-8000-000000000022', 'Span', false);

-- Q23 (facil) — OpenTelemetry
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000023',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000003'),
        'O que é o OpenTelemetry no contexto de observabilidade?',
        'OpenTelemetry é o padrão de facto, open source e vendor-neutral, para instrumentar aplicações e emitir traces, métricas e logs em formato compatível com múltiplos backends de observabilidade.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000023', 'Um padrão open source e vendor-neutral para instrumentar aplicações e emitir traces, métricas e logs', true),
    ('a1a20000-0000-4000-8000-000000000023', 'Um banco de dados especializado em armazenar apenas métricas do tipo gauge', false),
    ('a1a20000-0000-4000-8000-000000000023', 'Um protocolo de autenticação usado exclusivamente entre microsserviços', false),
    ('a1a20000-0000-4000-8000-000000000023', 'Uma linguagem de consulta para logs estruturados em JSON', false);

-- Q24 (facil) — SLA definição
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000024',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000004'),
        'O que caracteriza um SLA (Service Level Agreement)?',
        'SLA é um compromisso externo, geralmente contratual, firmado com clientes ou definido por um provedor, com consequências como créditos ou penalidades caso a meta não seja cumprida.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000024', 'É um compromisso externo, geralmente contratual, com consequências previstas em caso de descumprimento', true),
    ('a1a20000-0000-4000-8000-000000000024', 'É uma métrica interna de latência calculada a partir de histogramas', false),
    ('a1a20000-0000-4000-8000-000000000024', 'É o nome técnico dado ao span raiz de um trace distribuído', false),
    ('a1a20000-0000-4000-8000-000000000024', 'É um sinônimo de error budget usado apenas por equipes de SRE', false);

-- Q25 (media) — Correlação e ausência de correlation_id
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000025',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000001'),
        'Uma equipe investiga uma falha em um fluxo com múltiplos serviços, mas nenhum deles inclui um identificador comum nos logs. Qual é a principal consequência prática dessa ausência?',
        'Sem um identificador comum (correlation_id/trace_id) propagado entre os serviços, reconstruir a jornada de uma requisição específica vira um processo manual e impreciso, tipicamente por aproximação de timestamps entre logs de sistemas separados.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000025', 'A equipe precisa reconstruir a jornada da requisição manualmente, aproximando logs por timestamp entre sistemas separados', true),
    ('a1a20000-0000-4000-8000-000000000025', 'Os logs deixam de ser gravados em disco a partir desse ponto', false),
    ('a1a20000-0000-4000-8000-000000000025', 'As métricas de latência do serviço passam a ser calculadas incorretamente', false),
    ('a1a20000-0000-4000-8000-000000000025', 'O nível de severidade dos logs é automaticamente rebaixado para DEBUG', false);

-- Q26 (media) — Logging excessivo em loop
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000026',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000001'),
        'Um job processa um lote de 100 mil registros e registra um log por item processado. Qual é o problema típico dessa prática e a alternativa recomendada?',
        'Logar um evento por item em processamentos de alto volume pode saturar o pipeline de logging e elevar custo sem agregar valor de diagnóstico; a alternativa recomendada é logar um resumo agregado ao final do processamento (ex.: total processado, total de falhas).',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000026', 'Satura o pipeline de logging e eleva custo sem ganho real de diagnóstico; melhor logar um resumo agregado ao final', true),
    ('a1a20000-0000-4000-8000-000000000026', 'Não há problema, pois logging estruturado nunca tem custo de armazenamento', false),
    ('a1a20000-0000-4000-8000-000000000026', 'O problema é que logs por item impedem o uso de counters nas métricas', false),
    ('a1a20000-0000-4000-8000-000000000026', 'A alternativa recomendada é elevar o nível de log para DEBUG durante o processamento', false);

-- Q27 (media) — Push para jobs de vida curta
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000027',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000002'),
        'Por que o modelo de coleta "push" de métricas costuma ser mais adequado do que o "pull" para jobs batch de vida muito curta?',
        'Um job de vida curta pode terminar sua execução antes que o sistema de monitoramento tenha a chance de fazer scrape em seu endpoint de métricas; no modelo push, o próprio job envia as métricas ativamente, sem depender de estar "vivo" no momento da coleta.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000027', 'Porque o job pode terminar antes que qualquer scrape aconteça, e o push não depende do job estar ativo no momento da coleta', true),
    ('a1a20000-0000-4000-8000-000000000027', 'Porque métricas do tipo push nunca precisam de agregação por percentil', false),
    ('a1a20000-0000-4000-8000-000000000027', 'Porque o modelo pull não suporta métricas do tipo counter', false),
    ('a1a20000-0000-4000-8000-000000000027', 'Porque jobs batch não podem expor endpoints HTTP por restrição de infraestrutura', false);

-- Q28 (media) — Trace vs span
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000028',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000003'),
        'Qual é a relação estrutural entre um trace e os spans que o compõem?',
        'Um trace representa a jornada completa de uma requisição e é composto por vários spans; cada span tem um identificador próprio e referencia seu span pai, formando uma árvore de execução que compõe o trace inteiro.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000028', 'O trace é a jornada completa da requisição; os spans são unidades de trabalho que, referenciando seus pais, formam a árvore do trace', true),
    ('a1a20000-0000-4000-8000-000000000028', 'Trace e span são sinônimos usados por ferramentas diferentes para o mesmo conceito', false),
    ('a1a20000-0000-4000-8000-000000000028', 'Um span pode conter múltiplos traces completos dentro de si', false),
    ('a1a20000-0000-4000-8000-000000000028', 'O trace é gerado apenas ao final da requisição, sem relação com os spans individuais', false);

-- Q29 (media) — SLI centrado no usuário vs infraestrutura
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000029',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000004'),
        'Por que "uso de CPU abaixo de 80%" não é considerado, isoladamente, um bom SLI?',
        'Um bom SLI deve ser centrado na experiência do usuário; o usuário não sente diretamente o uso de CPU, mas sim latência e erros. Uso de CPU é um indicador de infraestrutura, não uma medida direta de experiência do usuário.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000029', 'Porque é um indicador de infraestrutura, e não uma medida direta da experiência do usuário com o serviço', true),
    ('a1a20000-0000-4000-8000-000000000029', 'Porque uso de CPU não pode ser coletado por ferramentas de monitoramento como gauge', false),
    ('a1a20000-0000-4000-8000-000000000029', 'Porque SLIs, por definição, só podem medir latência', false),
    ('a1a20000-0000-4000-8000-000000000029', 'Porque uso de CPU é sempre um valor constante e não varia ao longo do tempo', false);

-- Q30 (media) — Backoff exponencial isolado
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000030',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'O que significa, na prática, um mecanismo de retry usar "backoff exponencial"?',
        'Backoff exponencial significa esperar progressivamente mais tempo entre uma tentativa e a próxima (ex.: 1s, 2s, 4s, 8s), em vez de tentar novamente em intervalos fixos, dando mais tempo para a dependência falha se recuperar.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000030', 'O tempo de espera entre tentativas cresce progressivamente a cada nova tentativa (ex.: 1s, 2s, 4s, 8s)', true),
    ('a1a20000-0000-4000-8000-000000000030', 'O número de tentativas dobra a cada falha, sem limite máximo', false),
    ('a1a20000-0000-4000-8000-000000000030', 'O timeout da chamada é reduzido pela metade a cada nova tentativa', false),
    ('a1a20000-0000-4000-8000-000000000030', 'As tentativas passam a ser feitas em paralelo em vez de sequenciais', false);

-- Q31 (dificil) — Half-open circuit breaker
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000031',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'Depois que um circuit breaker abre o circuito para uma dependência instável, o que acontece no estado "meio-aberto" (half-open)?',
        'No estado meio-aberto, o circuit breaker permite passar um número limitado de chamadas de teste para verificar se a dependência já se recuperou; se essas chamadas tiverem sucesso, o circuito fecha e o tráfego normal é restabelecido, caso contrário ele volta a abrir.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000031', 'Permite algumas chamadas de teste; se tiverem sucesso, o circuito fecha, caso contrário volta a abrir', true),
    ('a1a20000-0000-4000-8000-000000000031', 'Bloqueia permanentemente qualquer nova chamada até uma intervenção manual do time', false),
    ('a1a20000-0000-4000-8000-000000000031', 'Redireciona automaticamente todo o tráfego para uma dependência secundária sem verificação', false),
    ('a1a20000-0000-4000-8000-000000000031', 'Aumenta o timeout de todas as chamadas subsequentes até o dobro do valor original', false);

-- Q32 (dificil) — Escolha de RTO/RPO como decisão de negócio
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000032',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'Por que definir RTO e RPO próximos de zero não é simplesmente "a melhor opção técnica" a ser adotada por padrão em qualquer sistema?',
        'RTO e RPO próximos de zero exigem alta disponibilidade e replicação síncrona multi-região, com custo de infraestrutura significativamente maior; a escolha do RTO/RPO adequado é uma decisão de negócio sobre risco tolerável em relação ao custo, não apenas uma questão técnica.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000032', 'Porque RTO/RPO próximos de zero custam significativamente mais em infraestrutura, tornando a escolha uma decisão de negócio sobre risco tolerável', true),
    ('a1a20000-0000-4000-8000-000000000032', 'Porque RTO e RPO não podem ser medidos com precisão em sistemas distribuídos', false),
    ('a1a20000-0000-4000-8000-000000000032', 'Porque reduzir RTO e RPO sempre aumenta a taxa de erro observada nas métricas', false),
    ('a1a20000-0000-4000-8000-000000000032', 'Porque apenas provedores de nuvem podem oferecer RTO/RPO baixos, nunca times internos', false);

-- Q33 (dificil) — Amostragem viesada perde outliers relevantes
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000033',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000003'),
        'Um time configura tracing com amostragem puramente aleatória e uniforme de 1%, sem nenhuma regra especial para erros. Qual é o principal risco dessa configuração ao investigar um incidente raro?',
        'Com amostragem uniforme sem priorização de erros, requisições que falham (tipicamente uma pequena fração do tráfego) têm alta chance de nunca serem capturadas, deixando o time sem traces justamente dos casos mais importantes para diagnosticar o incidente.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000033', 'Requisições com erro, por serem uma fração pequena do tráfego, têm alta chance de não serem capturadas pela amostragem uniforme', true),
    ('a1a20000-0000-4000-8000-000000000033', 'A amostragem uniforme sempre captura 100% das requisições, tornando o risco inexistente', false),
    ('a1a20000-0000-4000-8000-000000000033', 'A amostragem de 1% impede a coleta de métricas do tipo counter no mesmo serviço', false),
    ('a1a20000-0000-4000-8000-000000000033', 'O risco é que os spans capturados percam automaticamente o campo de timestamp', false);

-- Q34 (dificil) — Decisão baseada em error budget esgotado
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000034',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000004'),
        'Uma equipe percebe que o error budget do mês já foi totalmente consumido, ainda faltando duas semanas para o fechamento do período. Qual decisão é mais consistente com o uso pretendido do error budget como ferramenta de gestão de risco?',
        'Quando o error budget se esgota, o uso pretendido é mudar a prioridade da equipe para estabilidade (reduzir deploys arriscados, focar em correções) até o orçamento se recompor no próximo período, em vez de continuar assumindo o mesmo nível de risco.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000034', 'Priorizar estabilidade e reduzir a frequência de deploys arriscados até o orçamento se recompor no próximo período', true),
    ('a1a20000-0000-4000-8000-000000000034', 'Redefinir o SLO para um valor mais baixo imediatamente, sem revisão, para "zerar" o error budget', false),
    ('a1a20000-0000-4000-8000-000000000034', 'Ignorar o esgotamento, já que error budget é apenas um número histórico sem efeito prático', false),
    ('a1a20000-0000-4000-8000-000000000034', 'Acelerar o ritmo de deploys para compensar o tempo perdido antes do fechamento do período', false);

-- Q35 (dificil) — Bulkhead vs circuit breaker (diferença de propósito)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000035',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'Uma aplicação já usa circuit breaker para uma dependência instável, mas ainda assim a lentidão dessa dependência consome todas as threads do pool compartilhado e afeta chamadas a outras dependências saudáveis. Qual padrão complementar resolveria especificamente esse problema?',
        'Bulkhead isola pools de recursos (threads, conexões) por dependência; mesmo com circuit breaker configurado, se todas as dependências compartilham o mesmo pool, uma dependência lenta ainda pode esgotá-lo antes que o circuito abra. Isolar os recursos por dependência evita que esse esgotamento se propague para chamadas saudáveis.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000035', 'Bulkhead, isolando pools de threads/conexões por dependência para impedir que uma esgote os recursos das demais', true),
    ('a1a20000-0000-4000-8000-000000000035', 'Aumentar o timeout da dependência instável até ela parar de falhar', false),
    ('a1a20000-0000-4000-8000-000000000035', 'Substituir o circuit breaker por retries com backoff exponencial', false),
    ('a1a20000-0000-4000-8000-000000000035', 'Reduzir a amostragem de tracing para liberar recursos de CPU', false);

-- Q36 (dificil) — Métricas de saturação como sinal antecipado
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000036',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000002'),
        'Um serviço ainda não apresenta aumento de erros nem de latência, mas sua métrica de saturação (ex.: uso de fila de threads) está subindo de forma constante. Por que monitorar saturação separadamente de erros e latência é valioso nesse cenário?',
        'Saturação alta é frequentemente um sinal antecedente de degradação: o sistema ainda "aguenta" a carga atual, mas está próximo do limite de capacidade, e erros/latência tendem a piorar em seguida. Monitorar saturação isoladamente permite agir antes que o incidente se manifeste nos outros sinais.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000036', 'Porque saturação alta costuma ser um sinal antecedente de degradação, permitindo agir antes que erros e latência piorem', true),
    ('a1a20000-0000-4000-8000-000000000036', 'Porque saturação é a única métrica que pode ser coletada no modelo pull', false),
    ('a1a20000-0000-4000-8000-000000000036', 'Porque erros e latência só podem ser medidos depois que a saturação chega a 100%', false),
    ('a1a20000-0000-4000-8000-000000000036', 'Porque saturação substitui a necessidade de configurar SLOs para o serviço', false);
