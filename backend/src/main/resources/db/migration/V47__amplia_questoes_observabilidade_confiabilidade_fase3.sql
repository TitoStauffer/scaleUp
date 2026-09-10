-- Ampliação do pool de Questions — Domínio Observabilidade e Confiabilidade (Fase 3)
-- Referência: docs/product/tickets/TICKET-content-expansion-questoes-fase3.md
-- Adiciona 18 Questions NOVAS (6 facil, 6 media, 6 dificil), somando às 54 já existentes
-- (18 em V19__seed_conteudo_observabilidade_confiabilidade.sql + 18 em
-- V31__amplia_questoes_observabilidade_confiabilidade.sql + 18 em
-- V40__amplia_questoes_observabilidade_confiabilidade_fase2.sql), totalizando 72 no domínio.
-- Nenhum Concept/Slide/Flashcard novo; reaproveita os 5 Concepts já existentes (UUIDs
-- 'a1a10000-0000-4000-8000-00000000000X' criados em V19).
-- content_version = 'v1' e status_revisao = 'rascunho', mesma regra dos lotes anteriores
-- (decisão de content_version fechada por precedência no ticket da Fase 3).
-- V19, V31 e V40 foram lidos integralmente antes da escrita deste arquivo. Pontos já
-- cobertos pelas 54 questões existentes (não repetidos aqui): vantagem de log estruturado
-- vs texto livre, níveis de log padrão e DEBUG pontual, dados sensíveis em log,
-- correlation_id e reconstrução de jornada, logging excessivo em loop, centralização de
-- logs, tipos de métrica (counter/gauge/histogram), coleta pull vs push, quatro sinais de
-- ouro, saturação como sinal antecedente, cardinalidade alta em métricas, vanity metrics em
-- dashboards, média vs percentis de latência, span/trace/árvore de execução, propagação de
-- trace_id via cabeçalhos HTTP (W3C Trace Context) e via fila assíncrona, OpenTelemetry,
-- amostragem 1% + 100% em erro, amostragem uniforme perdendo outliers, amostragem head-based
-- vs tail-based, SLI centrado no usuário, SLO e error budget (conceito e uso para decisão de
-- risco), SLA vs SLO, cálculo de indisponibilidade tolerada ("noves"), MTTR vs MTBF, burn
-- rate (multi-window multi-burn-rate), retries com timeout/backoff exponencial/jitter/
-- tempestade de retries, idempotência como requisito de retry seguro, circuit breaker
-- (propósito e estado meio-aberto), rate limiting vs circuit breaker, bulkhead (propósito e
-- complementaridade com circuit breaker), RTO/RPO, liveness/readiness probes (propósito
-- básico), chaos engineering (definição e uso em produção), degradação graciosa, fadiga de
-- alertas, diagnóstico combinando métricas->traces->logs, diferença de propósito entre
-- métricas/logs/traces, canary/blast radius. As 18 questões abaixo cobrem ângulos ainda não
-- testados: health check raso vs profundo (e falha em cascata causada por health check
-- profundo), synthetic monitoring (e diferença para RUM), runbooks, postmortem sem culpa
-- (blameless) e fatores contribuintes vs causa raiz única, alertas acionáveis vs dashboards,
-- spans órfãos (definição e causa raiz em componente assíncrono), amostragem de logs em alto
-- volume, error budget policy formal (freeze de deploy), correlação de incidentes
-- multi-serviço via timeline de mudanças, escalonamento de plantão (on-call), toil (SRE),
-- alertas baseados em sintoma/SLO vs baseados em causa por componente, feature flag vs
-- rollback de deploy, e níveis de severidade de incidente (SEV).
-- Question + suas 4 alternativas são inseridas na mesma transação de migração, conforme
-- exigido pelo trigger de constraint adiada trg_verificar_alternativas_question (V6).

-- =====================================================================================
-- QUESTIONS + ALTERNATIVAS (18 novas — 6 facil, 6 media, 6 dificil)
-- =====================================================================================

-- Q55 (facil) — Health check raso vs profundo
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000055',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'Qual é a diferença entre um health check "raso" (shallow) e um health check "profundo" (deep)?',
        'O health check raso verifica apenas se o processo da aplicação está respondendo (ex.: retorna 200 sem checar mais nada); o profundo também verifica dependências críticas, como conexão com banco de dados, cache ou filas, antes de reportar o serviço como saudável.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000055', 'O raso verifica apenas se o processo está respondendo; o profundo também verifica dependências críticas, como banco de dados e filas', true),
    ('a1a20000-0000-4000-8000-000000000055', 'O raso verifica dependências externas e o profundo verifica apenas o processo, na ordem inversa', false),
    ('a1a20000-0000-4000-8000-000000000055', 'A diferença está apenas no timeout configurado para a resposta do check', false),
    ('a1a20000-0000-4000-8000-000000000055', 'Health checks profundos só podem ser executados em ambiente de staging, nunca em produção', false);

-- Q56 (facil) — Synthetic monitoring
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000056',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000002'),
        'O que é "synthetic monitoring" (monitoramento sintético)?',
        'Synthetic monitoring simula periodicamente ações de usuário através de requisições programadas ("probes") contra o sistema em produção, permitindo detectar falhas ou lentidão antes que usuários reais sejam afetados, mesmo em horários de baixo tráfego real.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000056', 'Simular periodicamente ações de usuário através de requisições programadas contra o sistema em produção', true),
    ('a1a20000-0000-4000-8000-000000000056', 'Coletar métricas exclusivamente a partir de usuários reais durante o uso normal da aplicação', false),
    ('a1a20000-0000-4000-8000-000000000056', 'Gerar dados fictícios para popular um ambiente de testes antes de um deploy', false),
    ('a1a20000-0000-4000-8000-000000000056', 'Executar uma única verificação manual no momento exato do deploy de uma nova versão', false);

-- Q57 (facil) — Runbook
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000057',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'O que é um runbook em operação de sistemas?',
        'Runbook é um documento com passo a passo operacional para diagnosticar e responder a um tipo específico de incidente ou alerta, reduzindo o tempo de resposta e a dependência do conhecimento tácito de uma única pessoa da equipe.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000057', 'Um documento com passo a passo operacional para diagnosticar e responder a um tipo específico de incidente', true),
    ('a1a20000-0000-4000-8000-000000000057', 'O registro automático de todas as chamadas HTTP trocadas entre serviços', false),
    ('a1a20000-0000-4000-8000-000000000057', 'Um changelog técnico listando as versões já publicadas de um serviço', false),
    ('a1a20000-0000-4000-8000-000000000057', 'Um dashboard consolidado exclusivamente com métricas de negócio', false);

-- Q58 (facil) — Postmortem sem culpa (blameless)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000058',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'O que caracteriza um postmortem "sem culpa" (blameless) após um incidente?',
        'Um postmortem blameless foca em entender as causas sistêmicas e processuais do incidente, em vez de atribuir culpa a indivíduos, incentivando relatos honestos e completos por parte de quem esteve envolvido, sem medo de retaliação.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000058', 'Focar em entender causas sistêmicas do incidente em vez de atribuir culpa a indivíduos, incentivando relatos honestos', true),
    ('a1a20000-0000-4000-8000-000000000058', 'Um documento anônimo em que ninguém assina o relatório final do incidente', false),
    ('a1a20000-0000-4000-8000-000000000058', 'Um processo que dispensa qualquer análise técnica detalhada do que ocorreu', false),
    ('a1a20000-0000-4000-8000-000000000058', 'Uma reunião realizada apenas quando o incidente chega a violar um SLA contratual', false);

-- Q59 (facil) — Alertas acionáveis vs dashboards
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000059',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000002'),
        'Segundo a prática recomendada de observabilidade, o que deve diferenciar um bom alerta de uma informação que deveria estar apenas em um dashboard?',
        'Um alerta deve ser acionável: sua existência deve exigir alguma ação humana imediata. Informação que é apenas "bom saber", sem ação clara associada, deve permanecer em um dashboard consultável, sem gerar notificação e interromper a equipe.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000059', 'Um alerta deve exigir ação humana imediata; informação sem ação associada deve ficar em dashboard, não gerar notificação', true),
    ('a1a20000-0000-4000-8000-000000000059', 'Alertas só podem ser configurados sobre métricas do tipo counter, nunca gauge ou histogram', false),
    ('a1a20000-0000-4000-8000-000000000059', 'Um dashboard não pode exibir a mesma métrica que já é usada em um alerta configurado', false),
    ('a1a20000-0000-4000-8000-000000000059', 'Alertas devem sempre ser enviados por e-mail, nunca por outro canal de notificação', false);

-- Q60 (facil) — Span órfão
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000060',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000003'),
        'O que é um "span órfão" (orphan span) em tracing distribuído?',
        'Um span órfão é um span que chega ao backend de tracing referenciando um span pai que nunca foi recebido ou registrado, ficando desconectado da árvore de execução do trace ao qual deveria pertencer.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000060', 'Um span que referencia um span pai que nunca foi recebido pelo backend de tracing, ficando desconectado da árvore do trace', true),
    ('a1a20000-0000-4000-8000-000000000060', 'Um span gerado por um serviço que ainda não foi instrumentado com OpenTelemetry', false),
    ('a1a20000-0000-4000-8000-000000000060', 'Um span duplicado, emitido duas vezes pelo mesmo serviço para a mesma operação', false),
    ('a1a20000-0000-4000-8000-000000000060', 'Um span que não possui nenhuma informação de latência associada', false);

-- Q61 (media) — Amostragem de logs em alto volume
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000061',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000001'),
        'Um serviço de altíssimo tráfego gera um volume de logs de nível INFO tão grande que o custo de armazenamento se torna proibitivo. Qual estratégia de amostragem de logs preserva melhor a capacidade de diagnóstico?',
        'A estratégia recomendada é amostrar apenas uma fração dos logs de nível INFO, mas manter 100% dos logs de WARN/ERROR e dos logs correlacionados a requisições com falha — de forma análoga à amostragem usada em tracing, priorizando o que mais importa para diagnóstico.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000061', 'Amostrar apenas uma fração dos logs de nível INFO, mas manter 100% dos logs de WARN/ERROR e dos correlacionados a falhas', true),
    ('a1a20000-0000-4000-8000-000000000061', 'Reduzir uniformemente todos os níveis de log, incluindo ERROR, na mesma proporção', false),
    ('a1a20000-0000-4000-8000-000000000061', 'Armazenar apenas o log mais recente de cada serviço, descartando todo o histórico anterior', false),
    ('a1a20000-0000-4000-8000-000000000061', 'Desativar o logging estruturado e voltar a logs em texto livre para reduzir o tamanho médio de cada linha', false);

-- Q62 (media) — Error budget policy formal (freeze de deploy)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000062',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000004'),
        'O que é uma "error budget policy" formal, e por que registrá-la previamente é mais eficaz do que decidir a reação ao esgotamento do error budget caso a caso?',
        'Error budget policy é um acordo documentado previamente, definindo as ações automáticas quando o error budget se esgota (ex.: freeze de deploys não essenciais, priorização de correções). Defini-la antes evita decisões ad-hoc negociadas sob pressão durante um incidente e garante consistência entre diferentes ocasiões.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000062', 'É um acordo documentado previamente sobre as ações automáticas (ex.: freeze de deploys) tomadas quando o error budget se esgota, evitando decisões ad-hoc sob pressão', true),
    ('a1a20000-0000-4000-8000-000000000062', 'É o valor em dinheiro reservado para pagar multas contratuais previstas em um SLA', false),
    ('a1a20000-0000-4000-8000-000000000062', 'É a política que fixa o tamanho do error budget sempre em exatamente 1% do SLO', false),
    ('a1a20000-0000-4000-8000-000000000062', 'É um relatório gerado automaticamente apenas para fins de auditoria externa, sem efeito operacional', false);

-- Q63 (media) — Correlação de incidentes multi-serviço via timeline de mudanças
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000063',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        NULL,
        'Durante um incidente que afeta múltiplos serviços simultaneamente, qual prática ajuda mais rapidamente a identificar se a causa é uma mudança recente comum a todos eles (ex.: deploy, alteração de configuração, migração de infraestrutura)?',
        'Manter uma timeline centralizada de mudanças (deploys, feature flags, configurações, migrações) e cruzar o horário dessas mudanças com o início dos sintomas permite checar rapidamente "o que mudou perto desse horário", em vez de investigar cada serviço isoladamente do zero.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000063', 'Consultar uma timeline centralizada de mudanças (deploys, configurações, migrações) e cruzar o horário dessas mudanças com o início dos sintomas', true),
    ('a1a20000-0000-4000-8000-000000000063', 'Reiniciar todos os serviços afetados simultaneamente antes de qualquer investigação', false),
    ('a1a20000-0000-4000-8000-000000000063', 'Aumentar a amostragem de tracing para 100% em todos os serviços do sistema', false),
    ('a1a20000-0000-4000-8000-000000000063', 'Aguardar que cada serviço afetado produza um postmortem individual antes de comparar causas', false);

-- Q64 (media) — Synthetic monitoring vs RUM
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000064',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000002'),
        'Qual é a principal diferença entre synthetic monitoring e RUM (Real User Monitoring)?',
        'Synthetic monitoring executa transações simuladas e programadas de forma consistente, independente de haver tráfego real, útil inclusive para detectar indisponibilidade em horários de baixo uso; RUM coleta dados de desempenho e comportamento a partir de usuários reais durante o uso normal, refletindo fielmente a experiência real, mas dependendo de haver tráfego suficiente para ser representativo.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000064', 'Synthetic monitoring executa transações simuladas de forma consistente e independente de tráfego real; RUM coleta dados de usuários reais durante o uso normal', true),
    ('a1a20000-0000-4000-8000-000000000064', 'RUM só pode ser usado em aplicações mobile, e synthetic monitoring apenas em APIs de backend', false),
    ('a1a20000-0000-4000-8000-000000000064', 'Synthetic monitoring substitui completamente a necessidade de métricas de taxa de erro', false),
    ('a1a20000-0000-4000-8000-000000000064', 'RUM é executado apenas antes do deploy, e synthetic monitoring apenas depois', false);

-- Q65 (media) — Escalonamento de plantão (on-call)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000065',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'Qual é o objetivo de uma política de escalonamento (escalation policy) em um sistema de plantão (on-call)?',
        'A política de escalonamento garante que, se a pessoa primária de plantão não reconhecer ou responder a um alerta crítico dentro de um tempo definido, o alerta seja automaticamente escalado para outra pessoa ou nível seguinte, evitando que um incidente crítico fique sem resposta por indisponibilidade de uma única pessoa.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000065', 'Garantir que um alerta crítico não respondido pela pessoa primária dentro de um tempo definido seja automaticamente escalado para outra pessoa ou nível', true),
    ('a1a20000-0000-4000-8000-000000000065', 'Definir a ordem em que os serviços devem ser reiniciados durante uma manutenção programada', false),
    ('a1a20000-0000-4000-8000-000000000065', 'Aumentar automaticamente a severidade de todo alerta após 24 horas, mesmo já resolvido', false),
    ('a1a20000-0000-4000-8000-000000000065', 'Substituir a necessidade de runbooks documentados para incidentes recorrentes', false);

-- Q66 (media) — Toil (SRE)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000066',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'No vocabulário de SRE (Site Reliability Engineering), o que é "toil" e por que reduzi-lo é considerado importante para a confiabilidade a longo prazo?',
        'Toil é trabalho operacional manual, repetitivo e automatizável que não agrega valor duradouro (ex.: reiniciar manualmente um serviço toda vez que trava). Reduzir toil libera tempo da equipe para trabalho de engenharia que efetivamente melhora a confiabilidade (automação, correção de causa raiz), em vez de consumir a capacidade da equipe apenas reagindo a sintomas repetidos.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000066', 'É trabalho manual, repetitivo e automatizável que não agrega valor duradouro; reduzi-lo libera tempo da equipe para melhorias estruturais de confiabilidade', true),
    ('a1a20000-0000-4000-8000-000000000066', 'É o tempo total que um sistema fica fora do ar ao longo de um mês', false),
    ('a1a20000-0000-4000-8000-000000000066', 'É o nome dado ao processo de escrever testes automatizados antes de cada deploy', false),
    ('a1a20000-0000-4000-8000-000000000066', 'É a métrica que mede a satisfação da equipe de plantão em pesquisas internas', false);

-- Q67 (dificil) — Causa raiz de spans órfãos
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000067',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000003'),
        'Um sistema de tracing distribuído passa a exibir uma quantidade crescente de spans órfãos logo após a introdução de um novo componente que processa mensagens de forma assíncrona entre dois serviços já instrumentados. Qual é a causa mais provável?',
        'A causa mais provável é que o novo componente assíncrono não propaga o trace context (trace_id/span_id) ao publicar ou consumir a mensagem — de forma análoga ao que ocorre com filas sem instrumentação adequada — então o span criado do lado do consumidor não referencia corretamente o span pai do lado do publisher, quebrando a cadeia de propagação.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000067', 'O novo componente assíncrono não propaga o trace context entre publisher e consumer, então os spans do consumidor não referenciam corretamente o span pai', true),
    ('a1a20000-0000-4000-8000-000000000067', 'O backend de tracing atingiu o limite de cardinalidade de métricas e começou a descartar spans aleatoriamente', false),
    ('a1a20000-0000-4000-8000-000000000067', 'Os dois serviços originais pararam de emitir logs estruturados após a introdução do novo componente', false),
    ('a1a20000-0000-4000-8000-000000000067', 'O aumento de spans órfãos indica, por si só, que o SLO de disponibilidade do sistema foi violado', false);

-- Q68 (dificil) — Alertas por sintoma (SLO) vs por causa (componente)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000068',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000004'),
        'Uma equipe mantém dezenas de alertas de baixo nível por componente (ex.: "CPU do serviço X acima de 90%", "fila Y com mais de 1000 mensagens") além de alertas baseados em SLO/burn rate. Qual é a principal vantagem de priorizar alertas baseados em sintoma (SLO) como gatilho primário de acionamento da equipe, em vez dos alertas de causa por componente?',
        'Alertas por sintoma só disparam quando a experiência do usuário é de fato afetada (violação de SLO), reduzindo o ruído de oscilações internas que não necessariamente impactam o usuário. Os alertas de causa por componente continuam úteis, mas como contexto de diagnóstico após o alerta de sintoma disparar, não como gatilho primário.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000068', 'Alertas por sintoma só disparam quando o usuário é de fato afetado, reduzindo ruído de oscilações internas; os de causa seguem úteis como contexto de diagnóstico', true),
    ('a1a20000-0000-4000-8000-000000000068', 'Alertas por sintoma eliminam completamente a necessidade de qualquer alerta por componente na infraestrutura', false),
    ('a1a20000-0000-4000-8000-000000000068', 'Alertas por causa não podem ser configurados em ferramentas que também calculam SLO', false),
    ('a1a20000-0000-4000-8000-000000000068', 'Alertas por sintoma são sempre calculados com menor frequência de coleta, reduzindo custo de armazenamento', false);

-- Q69 (dificil) — Health check profundo causando falha em cascata
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000069',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'Um serviço usa um readiness probe "profundo" que verifica, a cada poucos segundos, se consegue completar uma query real no banco de dados. Durante um pico de carga no banco, esse readiness probe começa a falhar em várias instâncias simultaneamente, removendo todas do balanceamento ao mesmo tempo e piorando o incidente. Qual é o problema de design nesse cenário?',
        'O health check profundo, ao depender de uma condição compartilhada (a mesma sobrecarga no banco), falha de forma correlacionada em todas as instâncias ao mesmo tempo, removendo toda a capacidade do sistema do balanceamento justamente quando mais se precisa dela — amplificando o incidente em vez de isolá-lo.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000069', 'O health check profundo, ao falhar em todas as instâncias simultaneamente sob a mesma condição, remove toda a capacidade do sistema do balanceamento ao mesmo tempo, amplificando o incidente', true),
    ('a1a20000-0000-4000-8000-000000000069', 'O problema é que readiness probes nunca devem verificar dependências externas, apenas liveness deve fazer isso', false),
    ('a1a20000-0000-4000-8000-000000000069', 'O problema é que o readiness probe deveria rodar com frequência maior que o liveness probe, nunca igual', false),
    ('a1a20000-0000-4000-8000-000000000069', 'O problema é que health checks profundos não são suportados por ferramentas modernas de orquestração', false);

-- Q70 (dificil) — Feature flag vs rollback de deploy
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000070',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'Uma funcionalidade nova, controlada por um feature flag, começa a causar erros em produção logo após ser habilitada para 100% dos usuários. Por que desativar o feature flag costuma ser uma resposta de mitigação mais rápida e confiável do que reverter o deploy (rollback do binário/imagem)?',
        'Desativar um feature flag é uma mudança de configuração quase instantânea, sem precisar reconstruir, testar e reimplantar um artefato anterior; um rollback de deploy depende do pipeline de deploy, que pode levar minutos e carrega seu próprio risco de falha, enquanto o toggle do flag reverte o comportamento imediatamente sem tocar no artefato em execução.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000070', 'Porque desativar o flag é uma mudança de configuração quase instantânea, sem depender do pipeline de deploy para reimplantar uma versão anterior', true),
    ('a1a20000-0000-4000-8000-000000000070', 'Porque feature flags eliminam completamente a necessidade de testes antes do lançamento de uma funcionalidade', false),
    ('a1a20000-0000-4000-8000-000000000070', 'Porque um rollback de deploy sempre exige um novo ciclo de aprovação contratual de SLA com o cliente', false),
    ('a1a20000-0000-4000-8000-000000000070', 'Porque feature flags só podem ser usados em serviços que não possuem circuit breaker configurado', false);

-- Q71 (dificil) — Fatores contribuintes vs causa raiz única em postmortem
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000071',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'Uma cultura madura de postmortem evita concluir um incidente complexo apontando uma única "causa raiz" (ex.: "o desenvolvedor esqueceu de validar um campo"). Por que buscar múltiplos fatores contribuintes é considerado uma prática melhor em sistemas distribuídos?',
        'Incidentes em sistemas complexos geralmente resultam da combinação de várias condições (ex.: falta de validação, ausência de teste automatizado cobrindo o caso, alerta que não disparou, documentação desatualizada). Atribuir o incidente a um único fator, frequentemente humano, mascara as demais falhas sistêmicas que também precisam ser corrigidas e tende a gerar correções superficiais.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000071', 'Porque incidentes complexos geralmente resultam da combinação de várias condições, e focar em um único fator mascara outras falhas sistêmicas que também precisam ser corrigidas', true),
    ('a1a20000-0000-4000-8000-000000000071', 'Porque toda causa raiz única, por definição, é tecnicamente impossível de ser identificada', false),
    ('a1a20000-0000-4000-8000-000000000071', 'Porque a presença de múltiplos fatores contribuintes sempre indica que o SLA contratual foi violado', false),
    ('a1a20000-0000-4000-8000-000000000071', 'Porque postmortems com apenas um fator identificado não podem ser compartilhados com outras equipes', false);

-- Q72 (dificil) — Níveis de severidade de incidente (SEV) e urgência de resposta
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000072',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        NULL,
        'Por que classificar um incidente por nível de severidade (ex.: SEV1 a SEV4) logo no início da resposta é uma prática importante de confiabilidade operacional, além de apenas documentar o impacto?',
        'A severidade padroniza a urgência de resposta esperada — por exemplo, SEV1 pode exigir acionamento imediato de múltiplas equipes e comunicação a stakeholders, enquanto SEV4 pode ser tratado em horário comercial — evitando que a intensidade da resposta dependa do julgamento individual de quem primeiro percebeu o problema, e orientando quando escalar e quando comunicar externamente.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000072', 'Porque a severidade padroniza a urgência de resposta esperada (quem aciona, quão rápido, quando comunicar), em vez de depender do julgamento individual de quem percebeu o problema primeiro', true),
    ('a1a20000-0000-4000-8000-000000000072', 'Porque a severidade determina automaticamente qual desenvolvedor será responsabilizado pelo incidente', false),
    ('a1a20000-0000-4000-8000-000000000072', 'Porque incidentes de severidade baixa nunca precisam gerar um postmortem, em nenhuma circunstância', false),
    ('a1a20000-0000-4000-8000-000000000072', 'Porque a severidade é calculada exclusivamente a partir do RPO definido para o serviço', false);
