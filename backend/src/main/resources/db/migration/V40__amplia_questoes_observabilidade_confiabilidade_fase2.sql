-- Ampliação do pool de Questions — Domínio Observabilidade e Confiabilidade (Fase 2)
-- Referência: docs/product/tickets/TICKET-content-expansion-questoes-fase2.md
-- Adiciona 18 Questions NOVAS (6 facil, 6 media, 6 dificil), somando às 36 já existentes
-- (18 em V19__seed_conteudo_observabilidade_confiabilidade.sql + 18 em
-- V31__amplia_questoes_observabilidade_confiabilidade.sql), totalizando 54 no domínio.
-- Nenhum Concept/Slide/Flashcard novo; reaproveita os 5 Concepts já existentes (UUIDs
-- 'a1a10000-0000-4000-8000-00000000000X' criados em V19).
-- content_version = 'v1' e status_revisao = 'rascunho', mesma regra dos lotes anteriores.
-- V19 e V31 foram lidos integralmente antes da escrita deste arquivo. Pontos já cobertos
-- pelas 36 questões existentes (não repetidos aqui): vantagem de log estruturado vs texto
-- livre, níveis de log padrão e DEBUG pontual, dados sensíveis em log, correlation_id e
-- reconstrução de jornada, logging excessivo em loop, tipos de métrica (counter/gauge/
-- histogram), coleta pull vs push (Prometheus, jobs de vida curta), quatro sinais de ouro,
-- saturação como sinal antecedente, média vs percentis de latência, span/trace/árvore de
-- execução, propagação de trace_id via cabeçalhos HTTP (W3C Trace Context), OpenTelemetry,
-- amostragem 1% + 100% em erro, amostragem uniforme perdendo outliers de erro, SLI centrado
-- no usuário, SLO e error budget (conceito e uso para decisão de risco), SLA vs SLO
-- (definição e margem), retries com timeout/backoff exponencial/jitter/tempestade de
-- retries, circuit breaker (propósito e estado meio-aberto), bulkhead (propósito e
-- complementaridade com circuit breaker), RTO/RPO (definição e decisão de negócio),
-- diagnóstico combinando métricas->traces->logs, diferença de propósito entre métricas/
-- logs/traces. As 18 questões abaixo cobrem ângulos novos: chaos engineering, degradação
-- graciosa, fadiga de alertas, disponibilidade em "noves" e cálculo de indisponibilidade
-- tolerada, centralização de logs, liveness/readiness probes, idempotência como requisito
-- de retry seguro, cardinalidade alta em métricas, amostragem head-based vs tail-based,
-- MTTR vs MTBF, vanity metrics em dashboards, propagação de trace context via fila
-- assíncrona, alerta por burn rate (multi-window multi-burn-rate) e rate limiting vs
-- circuit breaker, e canary/blue-green como redução de blast radius.
-- Question + suas 4 alternativas são inseridas na mesma transação de migração, conforme
-- exigido pelo trigger de constraint adiada trg_verificar_alternativas_question (V6).

-- =====================================================================================
-- QUESTIONS + ALTERNATIVAS (18 novas — 6 facil, 6 media, 6 dificil)
-- =====================================================================================

-- Q37 (facil) — Chaos engineering
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000037',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'O que é chaos engineering?',
        'Chaos engineering é a prática de injetar falhas controladas (ex.: derrubar uma instância, simular latência de rede) em um sistema para validar, de forma proativa, se os mecanismos de resiliência (retries, circuit breakers, redundância) realmente funcionam como esperado.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000037', 'A prática de injetar falhas controladas em um sistema para validar proativamente seus mecanismos de resiliência', true),
    ('a1a20000-0000-4000-8000-000000000037', 'Um algoritmo para ordenar aleatoriamente logs antes de armazená-los', false),
    ('a1a20000-0000-4000-8000-000000000037', 'A técnica de gerar dados de teste aleatórios para testes unitários', false),
    ('a1a20000-0000-4000-8000-000000000037', 'Um método para distribuir tráfego igualmente entre réplicas de um serviço', false);

-- Q38 (facil) — Degradação graciosa
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000038',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'O que caracteriza a degradação graciosa (graceful degradation) de um sistema?',
        'Degradação graciosa é quando o sistema, diante da falha de uma parte não essencial, continua funcionando com funcionalidade reduzida (ex.: mostrar recomendações genéricas em vez de personalizadas) em vez de falhar completamente para o usuário.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000038', 'O sistema continua operando com funcionalidade reduzida quando uma parte não essencial falha, em vez de falhar por completo', true),
    ('a1a20000-0000-4000-8000-000000000038', 'O sistema reinicia automaticamente todos os serviços sempre que qualquer erro é detectado', false),
    ('a1a20000-0000-4000-8000-000000000038', 'O sistema reduz deliberadamente sua taxa de resposta para economizar recursos em horários de pico', false),
    ('a1a20000-0000-4000-8000-000000000038', 'O sistema descarta logs antigos automaticamente para liberar espaço em disco', false);

-- Q39 (facil) — Fadiga de alertas
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000039',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000002'),
        'O que é "alert fatigue" (fadiga de alertas) e por que é um problema de confiabilidade?',
        'Alert fatigue ocorre quando alertas disparam com frequência excessiva ou pouco relevante (falsos positivos, thresholds mal calibrados), levando a equipe a ignorar ou silenciar notificações — inclusive as que sinalizam um incidente real.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000039', 'É o efeito de alertas excessivos ou pouco relevantes levarem a equipe a ignorar notificações, incluindo as de incidentes reais', true),
    ('a1a20000-0000-4000-8000-000000000039', 'É a redução automática da frequência de coleta de métricas após um incidente', false),
    ('a1a20000-0000-4000-8000-000000000039', 'É o tempo que um alerta leva para ser processado pelo sistema de monitoramento', false),
    ('a1a20000-0000-4000-8000-000000000039', 'É o cansaço físico da equipe de plantão após um incidente longo, sem relação com configuração de alertas', false);

-- Q40 (facil) — "Três noves" de disponibilidade
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000040',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000004'),
        'Quando se diz que um serviço tem "três noves" de disponibilidade, a que valor isso se refere?',
        '"Três noves" é a forma coloquial de se referir a 99,9% de disponibilidade — quanto mais "noves" (99,99%, 99,999%), maior a disponibilidade exigida e menor a janela de indisponibilidade tolerada no período de referência.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000040', '99,9% de disponibilidade no período de referência', true),
    ('a1a20000-0000-4000-8000-000000000040', '99% de disponibilidade no período de referência', false),
    ('a1a20000-0000-4000-8000-000000000040', 'Três incidentes tolerados por mês antes de violar o SLA', false),
    ('a1a20000-0000-4000-8000-000000000040', 'Três réplicas mínimas exigidas para o serviço ser considerado disponível', false);

-- Q41 (facil) — Centralização de logs
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000041',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000001'),
        'Por que centralizar os logs de múltiplas instâncias e serviços em uma ferramenta única (ex.: Elasticsearch, Loki) é preferível a acessar cada servidor individualmente via SSH?',
        'Com múltiplas instâncias e serviços, acessar cada servidor manualmente para ler logs locais não escala e dificulta correlacionar eventos entre eles; uma ferramenta central de agregação permite buscar, filtrar e correlacionar logs de todo o sistema a partir de um único lugar.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000041', 'Permite buscar, filtrar e correlacionar logs de múltiplas instâncias e serviços a partir de um único lugar, sem acesso manual a cada servidor', true),
    ('a1a20000-0000-4000-8000-000000000041', 'Elimina completamente a necessidade de definir níveis de severidade nos logs', false),
    ('a1a20000-0000-4000-8000-000000000041', 'Garante que nenhum log conterá dados sensíveis, independentemente do que a aplicação registre', false),
    ('a1a20000-0000-4000-8000-000000000041', 'Reduz automaticamente a latência das requisições que geram os logs', false);

-- Q42 (facil) — Liveness probe
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000042',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'O que um "liveness probe" tipicamente verifica em um serviço?',
        'Um liveness probe verifica se o processo da aplicação continua vivo e responsivo (não travado nem em deadlock); se falhar repetidamente, a plataforma de orquestração normalmente reinicia a instância, assumindo que ela não vai se recuperar sozinha.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000042', 'Se o processo da aplicação continua vivo e responsivo, para decidir se a instância deve ser reiniciada', true),
    ('a1a20000-0000-4000-8000-000000000042', 'Se o banco de dados usado pela aplicação está com backup atualizado', false),
    ('a1a20000-0000-4000-8000-000000000042', 'Se o código-fonte da aplicação foi assinado digitalmente antes do deploy', false),
    ('a1a20000-0000-4000-8000-000000000042', 'Se o usuário final está satisfeito com o tempo de resposta da aplicação', false);

-- Q43 (media) — Idempotência e retry seguro
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000043',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'Por que aplicar retry automaticamente só é seguro quando a operação repetida é idempotente?',
        'Se a operação não for idempotente (ex.: "debitar R$ 50 da conta"), repeti-la após uma falha de rede pode executar o efeito mais de uma vez mesmo que a primeira tentativa já tenha tido sucesso do lado do servidor — a resposta é que se perdeu, não a execução. Operações idempotentes (ex.: "definir saldo como R$ 950") produzem o mesmo resultado final independentemente de quantas vezes forem repetidas.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000043', 'Porque repetir uma operação não idempotente pode duplicar seu efeito (ex.: cobrar duas vezes) mesmo que só a resposta da primeira tentativa tenha se perdido', true),
    ('a1a20000-0000-4000-8000-000000000043', 'Porque operações não idempotentes sempre demoram mais tempo para responder do que as idempotentes', false),
    ('a1a20000-0000-4000-8000-000000000043', 'Porque apenas operações não idempotentes podem ser protegidas por circuit breaker', false),
    ('a1a20000-0000-4000-8000-000000000043', 'Porque retries em operações não idempotentes não podem usar backoff exponencial', false);

-- Q44 (media) — Cardinalidade em métricas
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000044',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000002'),
        'Por que adicionar um label como "user_id" (com milhões de valores distintos possíveis) a uma métrica em uma ferramenta como o Prometheus é geralmente desaconselhado?',
        'Cada combinação distinta de valores de labels cria uma série temporal separada internamente; um label de altíssima cardinalidade (como um identificador de usuário) multiplica o número de séries armazenadas, podendo esgotar memória e degradar a performance do sistema de métricas.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000044', 'Porque cada combinação de valores de label vira uma série temporal separada, e um label de alta cardinalidade explode o número de séries armazenadas', true),
    ('a1a20000-0000-4000-8000-000000000044', 'Porque o Prometheus não permite labels com valores numéricos, apenas texto fixo', false),
    ('a1a20000-0000-4000-8000-000000000044', 'Porque labels de alta cardinalidade transformam automaticamente a métrica em um histogram', false),
    ('a1a20000-0000-4000-8000-000000000044', 'Porque isso impede o uso do modelo de coleta pull para essa métrica específica', false);

-- Q45 (media) — Amostragem head-based vs tail-based
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000045',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000003'),
        'Qual é a diferença fundamental entre amostragem "head-based" e "tail-based" em tracing distribuído?',
        'Na amostragem head-based, a decisão de amostrar (registrar ou descartar) um trace é tomada logo no início da requisição, antes de saber como ela vai terminar. Na tail-based, a decisão é adiada até o fim do trace, permitindo priorizar a retenção de traces que terminaram em erro ou com latência anormal, algo que a decisão antecipada do head-based não consegue garantir.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000045', 'Head-based decide se amostra logo no início da requisição; tail-based adia a decisão até o fim, podendo priorizar traces com erro ou latência anormal', true),
    ('a1a20000-0000-4000-8000-000000000045', 'Head-based só funciona em ambientes on-premise, enquanto tail-based só funciona em nuvem pública', false),
    ('a1a20000-0000-4000-8000-000000000045', 'Tail-based descarta automaticamente 100% dos traces, sendo usada apenas em desenvolvimento', false),
    ('a1a20000-0000-4000-8000-000000000045', 'Head-based e tail-based são nomes alternativos para o mesmo algoritmo de amostragem uniforme', false);

-- Q46 (media) — MTTR vs MTBF
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000046',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000004'),
        'Qual é a diferença entre MTTR (Mean Time To Recovery/Repair) e MTBF (Mean Time Between Failures)?',
        'MTTR mede o tempo médio que um sistema leva para se recuperar depois que uma falha ocorre (quão rápido a equipe restaura o serviço); MTBF mede o tempo médio entre uma falha e a próxima (quão raramente o sistema falha). São métricas complementares: reduzir MTTR melhora a resposta a incidentes, aumentar MTBF melhora a prevenção deles.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000046', 'MTTR mede o tempo médio de recuperação após uma falha; MTBF mede o tempo médio entre uma falha e a próxima', true),
    ('a1a20000-0000-4000-8000-000000000046', 'MTTR e MTBF medem exatamente a mesma coisa, apenas com nomes diferentes usados por ferramentas distintas', false),
    ('a1a20000-0000-4000-8000-000000000046', 'MTTR mede a quantidade de dados perdidos em um desastre, e MTBF mede o tempo de restauração do serviço', false),
    ('a1a20000-0000-4000-8000-000000000046', 'MTBF só se aplica a hardware físico, nunca a software ou serviços em nuvem', false);

-- Q47 (media) — Readiness probe e remoção do balanceamento
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000047',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'Uma instância de um serviço está com o processo rodando normalmente, mas sua conexão com o banco de dados caiu. Por que um "readiness probe" que verifica essa dependência é mais adequado que apenas um liveness probe nesse cenário?',
        'O processo está vivo (liveness passaria), mas a instância não está apta a atender requisições corretamente sem o banco. Um readiness probe que checa a dependência detecta essa condição e remove a instância do balanceamento de carga até a dependência voltar, evitando enviar tráfego para uma instância que vai falhar as requisições.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000047', 'Porque o readiness probe pode detectar a dependência indisponível e remover a instância do balanceamento até ela se recuperar, mesmo com o processo ainda vivo', true),
    ('a1a20000-0000-4000-8000-000000000047', 'Porque o liveness probe sempre reinicia a instância automaticamente quando o banco de dados cai', false),
    ('a1a20000-0000-4000-8000-000000000047', 'Porque readiness probes substituem completamente a necessidade de circuit breaker para chamadas ao banco', false),
    ('a1a20000-0000-4000-8000-000000000047', 'Porque apenas o readiness probe é capaz de gerar métricas do tipo gauge', false);

-- Q48 (media) — Vanity metrics em dashboards
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000048',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000002'),
        'Por que um dashboard cheio de métricas "vaidosas" (vanity metrics) — números que parecem positivos mas não orientam nenhuma ação — pode prejudicar a observabilidade de um serviço?',
        'Métricas vaidosas ocupam espaço visual e atenção sem ajudar a diagnosticar problemas ou tomar decisões; um dashboard sobrecarregado com esse tipo de métrica dificulta que a equipe identifique rapidamente os sinais realmente relevantes (como os quatro sinais de ouro) durante um incidente.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000048', 'Porque essas métricas ocupam atenção e espaço visual sem orientar nenhuma ação, dificultando identificar os sinais realmente relevantes durante um incidente', true),
    ('a1a20000-0000-4000-8000-000000000048', 'Porque métricas vaidosas sempre corrompem os dados das métricas do tipo counter no mesmo painel', false),
    ('a1a20000-0000-4000-8000-000000000048', 'Porque dashboards com muitas métricas automaticamente violam o SLA definido para o serviço', false),
    ('a1a20000-0000-4000-8000-000000000048', 'Porque ferramentas de monitoramento limitam o número total de métricas exibíveis por conta técnica', false);

-- Q49 (dificil) — Cálculo de indisponibilidade tolerada (99,9% -> 99,99%)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000049',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000004'),
        'Uma equipe eleva o SLO mensal de disponibilidade de 99,9% para 99,99%. Em termos de indisponibilidade tolerada em um mês de 30 dias, o que essa mudança representa aproximadamente?',
        'Em um mês de 30 dias (43.200 minutos), 99,9% tolera cerca de 43 minutos de indisponibilidade, enquanto 99,99% tolera cerca de 4,3 minutos — ou seja, cada "nove" adicional reduz a indisponibilidade tolerada em aproximadamente dez vezes, exigindo uma arquitetura de resiliência proporcionalmente mais rigorosa.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000049', 'Reduz a indisponibilidade tolerada de cerca de 43 minutos para cerca de 4,3 minutos no mês, uma redução de aproximadamente dez vezes', true),
    ('a1a20000-0000-4000-8000-000000000049', 'Reduz a indisponibilidade tolerada pela metade, de 43 minutos para cerca de 21 minutos no mês', false),
    ('a1a20000-0000-4000-8000-000000000049', 'Não altera a indisponibilidade tolerada, apenas o valor exibido no relatório de SLA', false),
    ('a1a20000-0000-4000-8000-000000000049', 'Aumenta a indisponibilidade tolerada, já que SLOs mais altos permitem mais margem de erro', false);

-- Q50 (dificil) — Chaos engineering em produção
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000050',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'Por que experimentos de chaos engineering, quando maduros, costumam ser aplicados de forma controlada diretamente em produção, e não apenas em ambiente de teste?',
        'Ambientes de teste raramente reproduzem fielmente a escala, o tráfego real e as interações complexas entre serviços de produção; testar resiliência apenas em ambiente de teste pode dar falsa confiança. Aplicar experimentos controlados (com blast radius limitado e capacidade de abortar rapidamente) em produção valida se as premissas de resiliência realmente seguram sob condições reais.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000050', 'Porque ambientes de teste raramente reproduzem fielmente a escala e as interações reais de produção, e testar só ali pode gerar falsa confiança na resiliência', true),
    ('a1a20000-0000-4000-8000-000000000050', 'Porque ferramentas de chaos engineering só funcionam quando conectadas ao banco de dados de produção', false),
    ('a1a20000-0000-4000-8000-000000000050', 'Porque testar em produção é sempre mais barato do que manter um ambiente de teste separado', false),
    ('a1a20000-0000-4000-8000-000000000050', 'Porque times de SRE são obrigados por contrato a validar resiliência apenas com usuários reais', false);

-- Q51 (dificil) — Propagação de trace context via fila assíncrona
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000051',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000003'),
        'Uma requisição HTTP síncrona publica uma mensagem em uma fila, que é processada de forma assíncrona por outro serviço minutos depois. Por que o trace_id dessa requisição não é propagado automaticamente para o processamento da mensagem, e o que é necessário para manter o tracing encadeado?',
        'Ao contrário de chamadas HTTP diretas, onde o trace context viaja em cabeçalhos padronizados, uma mensagem em fila não carrega esse contexto por padrão — é preciso que o publisher inclua explicitamente o trace context (ex.: como metadados/atributos da mensagem) e que o consumer o leia e o use para continuar o mesmo trace ao processar a mensagem, em vez de iniciar um trace novo e desconectado.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000051', 'Porque mensagens em fila não carregam cabeçalhos HTTP por padrão; o publisher precisa incluir o trace context como metadado da mensagem e o consumer precisa lê-lo para continuar o mesmo trace', true),
    ('a1a20000-0000-4000-8000-000000000051', 'Porque filas de mensagens não podem ser instrumentadas com OpenTelemetry em nenhuma circunstância', false),
    ('a1a20000-0000-4000-8000-000000000051', 'Porque o trace_id expira automaticamente após alguns segundos e nunca pode ser reaproveitado', false),
    ('a1a20000-0000-4000-8000-000000000051', 'Porque processamento assíncrono sempre gera spans do tipo gauge, incompatíveis com spans síncronos', false);

-- Q52 (dificil) — Alerta por burn rate (multi-window multi-burn-rate)
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000052',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000004'),
        'Por que alertar apenas quando o error budget mensal chega a zero é insuficiente para uma resposta ágil a incidentes, e o que uma estratégia de alerta por "burn rate" (taxa de consumo) resolve?',
        'Esperar o error budget mensal se esgotar por completo significa que o alerta só dispara tarde, quando boa parte do orçamento já foi consumida. Alertar pela taxa de consumo (burn rate) — o quão rápido o error budget está sendo gasto em relação ao esperado — permite detectar, em janelas curtas, que o ritmo atual de falhas vai esgotar o orçamento muito antes do previsto, possibilitando reação antecipada.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000052', 'Porque esperar o esgotamento total do orçamento atrasa o alerta; alertar pela velocidade de consumo detecta cedo que o ritmo atual vai estourar o orçamento antes do previsto', true),
    ('a1a20000-0000-4000-8000-000000000052', 'Porque error budget mensal não pode ser calculado automaticamente, exigindo cálculo manual diário', false),
    ('a1a20000-0000-4000-8000-000000000052', 'Porque alertar por burn rate elimina completamente a necessidade de definir um SLO', false),
    ('a1a20000-0000-4000-8000-000000000052', 'Porque o error budget mensal só pode ser usado para relatórios, nunca para alertas em tempo real', false);

-- Q53 (dificil) — Rate limiting vs circuit breaker
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000053',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        (SELECT id FROM concept WHERE id = 'a1a10000-0000-4000-8000-000000000005'),
        'Qual é a diferença de propósito entre rate limiting e circuit breaker como mecanismos de proteção de um serviço?',
        'Rate limiting protege um serviço limitando proativamente quantas requisições ele aceita processar em um intervalo, independentemente de haver falha (evita sobrecarga por excesso de demanda legítima ou abusiva). Circuit breaker reage a falhas já observadas em uma dependência, interrompendo chamadas a ela para evitar desperdiçar recursos em tentativas fadadas a falhar. Um limita entrada de tráfego; o outro protege contra uma dependência que já está falhando.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000053', 'Rate limiting limita proativamente o volume de requisições aceitas para evitar sobrecarga; circuit breaker reage a falhas já observadas em uma dependência', true),
    ('a1a20000-0000-4000-8000-000000000053', 'Rate limiting e circuit breaker são termos alternativos para o mesmo mecanismo em bibliotecas diferentes', false),
    ('a1a20000-0000-4000-8000-000000000053', 'Circuit breaker só pode ser aplicado no lado do cliente, e rate limiting apenas no lado do servidor', false),
    ('a1a20000-0000-4000-8000-000000000053', 'Rate limiting substitui completamente a necessidade de qualquer timeout nas chamadas', false);

-- Q54 (dificil) — Canary/blue-green e redução de blast radius
INSERT INTO question (id, domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ('a1a20000-0000-4000-8000-000000000054',
        (SELECT id FROM domain WHERE slug = 'observabilidade-confiabilidade'),
        NULL,
        'Como uma estratégia de deploy canary (liberar uma nova versão para uma pequena fração do tráfego antes de expandir) contribui para a confiabilidade geral do sistema?',
        'Ao expor a nova versão a apenas uma fração pequena de usuários inicialmente, o canary reduz o "blast radius" de um defeito não detectado em testes: se as métricas de erro/latência dessa fração piorarem, a equipe pode reverter afetando poucos usuários, em vez de já ter exposto 100% do tráfego a uma versão com problema.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta) VALUES
    ('a1a20000-0000-4000-8000-000000000054', 'Reduz o "blast radius" de um defeito: se a nova versão degradar métricas na fração inicial de tráfego, poucos usuários são afetados antes da reversão', true),
    ('a1a20000-0000-4000-8000-000000000054', 'Elimina completamente a necessidade de monitorar métricas após o deploy, pois o canary já garante ausência de bugs', false),
    ('a1a20000-0000-4000-8000-000000000054', 'Garante que o RTO do sistema seja sempre igual a zero durante o processo de deploy', false),
    ('a1a20000-0000-4000-8000-000000000054', 'Substitui a necessidade de definir SLOs para a nova versão até que ela atinja 100% do tráfego', false);
