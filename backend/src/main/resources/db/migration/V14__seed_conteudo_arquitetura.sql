-- Seed de conteúdo — Domínio Arquitetura (slug 'arquitetura').
-- Autoria assistida por IA, rascunho sujeito a revisão humana (TICKET-content-database.md,
-- Decisão 2). Todo registro deste lote usa content_version = 'v1' e status_revisao =
-- 'rascunho'. Este arquivo NUNCA insere em domain — apenas referencia a linha já semeada
-- por V13 via subquery em domain.slug.
--
-- Estrutura: 5 Concept, 15 Slide (3 por Concept), 15 Flashcard (3 por Concept),
-- 18 Question (6 fácil / 6 média / 6 difícil) + 72 alternativas (4 por Question).
--
-- Question e suas 4 alternativas são inseridas na mesma transação de migração (Flyway
-- executa cada arquivo em uma transação), respeitando o trigger de constraint adiada
-- criado em V6 (trg_verificar_alternativas_question).

-- =====================================================================================
-- CONCEPTS (5)
-- =====================================================================================

INSERT INTO concept (id, domain_ref, titulo, resumo, content_version, status_revisao)
VALUES
    ('a2000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Estilos Arquiteturais e Camadas',
     'Visão geral dos principais estilos arquiteturais (camadas, cliente-servidor, pipe-and-filter) e como a divisão em camadas organiza responsabilidades dentro de um sistema.',
     'v1', 'rascunho'),
    ('a2000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Monólito vs. Microsserviços',
     'Comparação entre arquitetura monolítica e microsserviços: trade-offs de complexidade operacional, autonomia de times, deploy e quando escolher cada abordagem.',
     'v1', 'rascunho'),
    ('a2000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Acoplamento, Coesão e Modularização',
     'Conceitos fundamentais de acoplamento e coesão como critérios para dividir um sistema em módulos, e como isso impacta manutenibilidade e evolução.',
     'v1', 'rascunho'),
    ('a2000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Padrões Arquiteturais',
     'Padrões usados para estruturar sistemas complexos: arquitetura hexagonal (ports and adapters), CQRS, event-driven architecture e seus cenários de uso.',
     'v1', 'rascunho'),
    ('a2000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Evolução de Arquitetura e Trade-offs',
     'Como arquiteturas evoluem ao longo do tempo, o papel de decisões arquiteturais documentadas (ADRs) e como justificar trade-offs em entrevistas técnicas.',
     'v1', 'rascunho')
ON CONFLICT (domain_ref, titulo) DO NOTHING;

-- =====================================================================================
-- SLIDES (3 por Concept = 15)
-- =====================================================================================

-- Concept: Estilos Arquiteturais e Camadas
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a2000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'O que é um estilo arquitetural',
     'Um estilo arquitetural é um conjunto de restrições e princípios que orientam como os componentes de um sistema se organizam e se comunicam. Ele não é uma implementação pronta, mas um vocabulário compartilhado: ao dizer "isso é uma arquitetura em camadas" ou "isso é pipe-and-filter", comunicamos rapidamente como o fluxo de dados e as responsabilidades estão distribuídos, sem precisar descrever cada detalhe. Exemplos comuns incluem arquitetura em camadas (layered), cliente-servidor, pipe-and-filter, orientada a eventos e microkernel. A escolha do estilo impacta diretamente atributos de qualidade como testabilidade, capacidade de evolução e desempenho.',
     1, 'v1', 'rascunho'),
    ('a2000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Arquitetura em camadas (layered architecture)',
     'Na arquitetura em camadas, o sistema é dividido em níveis horizontais — tipicamente apresentação, aplicação/serviço, domínio/negócio e persistência — em que cada camada só se comunica com a camada imediatamente abaixo (ou, em variações mais flexíveis, com qualquer camada inferior). Essa separação facilita substituir uma camada isoladamente (ex.: trocar o banco de dados sem afetar a camada de apresentação) e favorece testes por camada. O principal risco é a "camada anêmica que só repassa chamadas" (arquitetura em camadas mal aplicada vira apenas burocracia sem ganho real de separação de responsabilidades) e o acoplamento indireto quando camadas superiores conhecem detalhes de implementação das inferiores.',
     2, 'v1', 'rascunho'),
    ('a2000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Exemplo aplicado: API REST em camadas',
     'Considere uma API REST típica: um Controller recebe a requisição HTTP e faz apenas validação de formato e tradução para objetos de aplicação; um Service concentra a regra de negócio (ex.: calcular se um pedido pode ser cancelado); um Repository isola o acesso a dados (SQL, ORM). Se a regra de negócio migrar de "cancelamento permitido em até 24h" para "permitido até o pedido ser despachado", a mudança fica isolada no Service, sem tocar Controller nem Repository. Esse isolamento é o benefício prático mais citado em entrevistas: cada camada muda por um motivo diferente (princípio da responsabilidade única aplicado a nível arquitetural).',
     3, 'v1', 'rascunho');

-- Concept: Monólito vs. Microsserviços
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a2000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Monólito: definição e vantagens',
     'Um monólito é uma aplicação implantada como uma única unidade de deploy, ainda que internamente organizada em módulos ou camadas. Vantagens práticas: simplicidade operacional (um único processo para subir, monitorar e escalar), transações locais simples (uma transação de banco cobre múltiplas regras de negócio sem coordenação distribuída), e menor sobrecarga de comunicação (chamadas de método em vez de chamadas de rede). Para times pequenos ou produtos em fase inicial de validação, o monólito costuma ser a escolha mais pragmática: menos infraestrutura, menos pontos de falha, ciclo de desenvolvimento mais rápido.',
     1, 'v1', 'rascunho'),
    ('a2000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Microsserviços: definição e custos',
     'Microsserviços dividem o sistema em serviços independentes, cada um com seu próprio processo, deploy e frequentemente seu próprio banco de dados. O ganho principal é autonomia: times diferentes podem implantar seus serviços sem coordenar um release conjunto, e cada serviço pode escalar de forma independente conforme sua carga. O custo é real e não deve ser subestimado: comunicação em rede (mais lenta e falível que chamada local), necessidade de lidar com consistência eventual entre serviços, complexidade operacional (orquestração, observabilidade distribuída, versionamento de contratos) e testes de integração mais caros. Microsserviços resolvem um problema organizacional (times grandes demais para um único monólito) mais do que um problema puramente técnico.',
     2, 'v1', 'rascunho'),
    ('a2000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Como decidir e o caminho do monólito modular',
     'Em entrevistas, a resposta "depende" só tem valor se acompanhada dos critérios que fundamentam a decisão: tamanho e maturidade do time, necessidade real de escalar partes do sistema de forma independente, criticidade de deploys independentes, e capacidade da equipe de operar infraestrutura distribuída. Uma trilha comum e defensável é começar com um "monólito modular" — módulos com fronteiras de domínio bem definidas dentro de um único deploy — e extrair microsserviços apenas quando um módulo específico apresentar necessidade concreta de escalar ou ser implantado separadamente. Migrar de monólito bem modularizado para microsserviços é incremental; migrar de monólito com módulos emaranhados é uma reescrita.',
     3, 'v1', 'rascunho');

-- Concept: Acoplamento, Coesão e Modularização
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a2000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Acoplamento: o quanto um módulo depende de outro',
     'Acoplamento mede o grau de dependência entre módulos: quanto mais um módulo precisa conhecer sobre a implementação interna de outro para funcionar, mais acoplados eles estão. Alto acoplamento significa que uma mudança em um módulo frequentemente exige mudanças em outros, tornando o sistema frágil e caro de evoluir. Formas comuns de reduzir acoplamento incluem depender de interfaces/contratos em vez de implementações concretas (inversão de dependência), comunicação por eventos em vez de chamadas diretas, e encapsular detalhes internos atrás de uma API clara. Acoplamento zero não é o objetivo — algum grau de dependência é inevitável e necessário para o sistema funcionar; o objetivo é acoplamento controlado e explícito.',
     1, 'v1', 'rascunho'),
    ('a2000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Coesão: o quanto um módulo faz uma coisa só',
     'Coesão mede o quanto os elementos dentro de um módulo estão relacionados entre si e servem a um propósito comum. Um módulo altamente coeso agrupa responsabilidades que mudam pelos mesmos motivos e pelas mesmas razões de negócio. Baixa coesão é o sintoma clássico de uma classe ou serviço "faz-tudo" (God Object/God Service), que mistura responsabilidades não relacionadas e se torna difícil de entender, testar e evoluir sem efeitos colaterais em partes aparentemente não relacionadas. A regra prática usada em revisão de design: se ao descrever o que um módulo faz você precisa usar a palavra "e" repetidamente para responsabilidades sem relação entre si, é sinal de baixa coesão.',
     2, 'v1', 'rascunho'),
    ('a2000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Alta coesão, baixo acoplamento: por que os dois juntos',
     'O objetivo de design combina os dois: módulos internamente coesos (cada um resolve um problema bem definido) e fracamente acoplados entre si (dependem de contratos estáveis, não de detalhes internos uns dos outros). Esse par é a base para decidir limites de módulos (bounded contexts, em termos de Domain-Driven Design) tanto dentro de um monólito modular quanto entre microsserviços. Na prática de entrevista, é comum pedir para o candidato desenhar como dividiria um sistema de e-commerce em módulos: uma resposta forte identifica responsabilidades coesas (catálogo, pedidos, pagamento, envio) e explica por que a comunicação entre elas deveria ser via contratos bem definidos (API ou eventos), não acesso direto a tabelas de outro módulo.',
     3, 'v1', 'rascunho');

-- Concept: Padrões Arquiteturais
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a2000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Arquitetura hexagonal (ports and adapters)',
     'A arquitetura hexagonal isola a lógica de negócio (o "núcleo" da aplicação) de detalhes de infraestrutura como banco de dados, frameworks web ou filas de mensagem. O núcleo define "portas" (interfaces) que descrevem o que ele precisa (ex.: "salvar um pedido") ou o que ele oferece (ex.: "processar um pedido"); "adaptadores" implementam essas portas conectando o núcleo a tecnologias concretas (um adaptador de banco Postgres, um adaptador HTTP REST). O benefício central é testabilidade: a regra de negócio pode ser testada com adaptadores falsos (in-memory), sem subir banco de dados real, e trocar de tecnologia (ex.: Postgres por outro banco) não deveria exigir alterar a lógica de negócio, só escrever um novo adaptador.',
     1, 'v1', 'rascunho'),
    ('a2000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'CQRS: separando leitura e escrita',
     'CQRS (Command Query Responsibility Segregation) separa o modelo usado para escrever dados (comandos, que aplicam regras de negócio e validações) do modelo usado para ler dados (queries, otimizadas para o formato que a interface precisa exibir). Em sistemas simples, o mesmo modelo atende leitura e escrita sem problema. CQRS se justifica quando os padrões de leitura e escrita divergem muito — por exemplo, escrita transacional complexa versus leitura que precisa agregar dados de múltiplas fontes para um dashboard. O trade-off é complexidade adicional (dois modelos para manter, possível necessidade de sincronização entre eles) em troca de poder otimizar cada lado independentemente. Não é um padrão "padrão" para todo sistema — aplicar CQRS sem essa divergência real de necessidades é complexidade desnecessária.',
     2, 'v1', 'rascunho'),
    ('a2000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Event-driven architecture: comunicação por eventos',
     'Em uma arquitetura orientada a eventos, componentes se comunicam publicando e consumindo eventos (fatos que já aconteceram, como "PedidoCriado") em vez de fazerem chamadas diretas umas às outras. Isso reduz o acoplamento temporal: o produtor do evento não precisa saber quem vai consumi-lo, nem esperar a resposta do consumidor para continuar seu próprio trabalho. É especialmente útil para desacoplar microsserviços e para processar efeitos colaterais de forma assíncrona (ex.: enviar e-mail de confirmação após "PedidoCriado" sem bloquear a resposta ao usuário). O trade-off: consistência eventual em vez de imediata, e a necessidade de lidar com entrega de eventos duplicados, fora de ordem, ou não processados (exigindo idempotência no lado do consumidor).',
     3, 'v1', 'rascunho');

-- Concept: Evolução de Arquitetura e Trade-offs
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a2000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Arquitetura não é uma decisão única e definitiva',
     'Um erro comum é tratar a arquitetura como algo definido uma vez no início do projeto e nunca mais revisitado. Na prática, arquiteturas evoluem: um monólito modular pode dar origem a microsserviços conforme o time cresce; um estilo síncrono pode incorporar processamento assíncrono conforme a carga aumenta. A ideia de "arquitetura evolutiva" defende desenhar o sistema para que essas mudanças sejam possíveis com custo razoável — por exemplo, mantendo módulos coesos e fracamente acoplados desde o início, mesmo dentro de um único deploy, para que uma futura extração de serviço não exija reescrever a lógica de negócio, apenas mudar a fronteira de deploy.',
     1, 'v1', 'rascunho'),
    ('a2000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Registrando decisões: Architecture Decision Records (ADR)',
     'Um ADR é um documento curto que registra uma decisão arquitetural relevante: o contexto que motivou a decisão, as alternativas consideradas, a decisão tomada e suas consequências (inclusive as negativas). O valor de um ADR não é a decisão em si, mas o registro do raciocínio: meses depois, quando alguém questionar "por que usamos X e não Y", a resposta já está documentada, evitando decisões re-discutidas do zero ou revertidas sem entender o motivo original. Em entrevistas, mencionar ADRs (ou processo equivalente) demonstra maturidade: mostra que o candidato entende que toda decisão arquitetural tem trade-offs, não apenas vantagens, e que decisões merecem ser justificadas e revisitáveis.',
     2, 'v1', 'rascunho'),
    ('a2000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Como justificar trade-offs em uma entrevista de System Design',
     'Toda decisão arquitetural troca algo por algo: microsserviços trocam simplicidade operacional por autonomia de deploy; CQRS troca simplicidade de modelo único por capacidade de otimizar leitura e escrita separadamente; arquitetura em camadas troca um pouco de desempenho (indireção entre camadas) por manutenibilidade. Uma resposta forte em entrevista nomeia explicitamente o que está sendo trocado por quê, e conecta a escolha aos requisitos do problema (volume de dados, tamanho do time, criticidade de disponibilidade, prazo). Respostas que apresentam uma única opção como "a correta" sem mencionar o que se abre mão dela costumam ser um sinal de alerta para o entrevistador — a boa arquitetura é sempre uma escolha contextual, não uma verdade universal.',
     3, 'v1', 'rascunho');

-- =====================================================================================
-- FLASHCARDS (3 por Concept = 15)
-- =====================================================================================

INSERT INTO flashcard (domain_ref, concept_ref, frente, verso, dificuldade, content_version, status_revisao)
VALUES
    -- Estilos Arquiteturais e Camadas
    ((SELECT id FROM domain WHERE slug = 'arquitetura'),
     'a2000000-0000-4000-8000-000000000001',
     'O que é um estilo arquitetural?',
     'Um conjunto de restrições e princípios que orientam como os componentes de um sistema se organizam e se comunicam (ex.: camadas, cliente-servidor, pipe-and-filter, event-driven).',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'arquitetura'),
     'a2000000-0000-4000-8000-000000000001',
     'Na arquitetura em camadas, cada camada deve se comunicar com quais outras camadas?',
     'Tipicamente apenas com a camada imediatamente inferior (ou, em variações mais flexíveis, com qualquer camada inferior) — nunca pulando para detalhes de implementação de camadas não adjacentes.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'arquitetura'),
     'a2000000-0000-4000-8000-000000000001',
     'Qual o risco de uma camada "anêmica" em uma arquitetura em camadas?',
     'Ela apenas repassa chamadas para a camada seguinte sem agregar nenhuma responsabilidade real, tornando a separação em camadas burocracia sem ganho efetivo.',
     'media', 'v1', 'rascunho'),

    -- Monólito vs. Microsserviços
    ((SELECT id FROM domain WHERE slug = 'arquitetura'),
     'a2000000-0000-4000-8000-000000000002',
     'Qual a principal vantagem operacional de um monólito frente a microsserviços?',
     'Simplicidade: uma única unidade de deploy, transações locais simples e sem sobrecarga de comunicação em rede entre módulos.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'arquitetura'),
     'a2000000-0000-4000-8000-000000000002',
     'Microsserviços resolvem, antes de tudo, que tipo de problema?',
     'Um problema organizacional — permitir que times grandes e múltiplos trabalhem e implantem de forma independente — mais do que um problema puramente técnico.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'arquitetura'),
     'a2000000-0000-4000-8000-000000000002',
     'O que é um "monólito modular" e por que é um caminho de migração comum?',
     'Um monólito com módulos internos organizados por domínio e fronteiras bem definidas; permite extrair microsserviços de forma incremental quando necessário, ao contrário de um monólito com módulos emaranhados.',
     'dificil', 'v1', 'rascunho'),

    -- Acoplamento, Coesão e Modularização
    ((SELECT id FROM domain WHERE slug = 'arquitetura'),
     'a2000000-0000-4000-8000-000000000003',
     'O que é acoplamento entre módulos?',
     'O grau de dependência de um módulo em relação a detalhes de implementação de outro; quanto maior o acoplamento, mais uma mudança em um módulo obriga mudanças em outros.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'arquitetura'),
     'a2000000-0000-4000-8000-000000000003',
     'O que é coesão em um módulo?',
     'O quanto os elementos internos de um módulo estão relacionados entre si e servem a um propósito comum; alta coesão significa que o módulo tem uma responsabilidade bem definida.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'arquitetura'),
     'a2000000-0000-4000-8000-000000000003',
     'Qual o objetivo combinado de design entre acoplamento e coesão?',
     'Alta coesão dentro de cada módulo (cada um resolve um problema bem definido) e baixo acoplamento entre módulos (dependência via contratos estáveis, não via detalhes internos).',
     'media', 'v1', 'rascunho'),

    -- Padrões Arquiteturais
    ((SELECT id FROM domain WHERE slug = 'arquitetura'),
     'a2000000-0000-4000-8000-000000000004',
     'Na arquitetura hexagonal, o que são "portas" e "adaptadores"?',
     'Portas são interfaces que descrevem o que o núcleo de negócio precisa ou oferece; adaptadores implementam essas interfaces conectando o núcleo a tecnologias concretas (banco, HTTP, filas).',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'arquitetura'),
     'a2000000-0000-4000-8000-000000000004',
     'Quando faz sentido aplicar CQRS?',
     'Quando os padrões de leitura e escrita divergem muito e cada lado se beneficia de um modelo otimizado separadamente — não deve ser aplicado por padrão em todo sistema.',
     'dificil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'arquitetura'),
     'a2000000-0000-4000-8000-000000000004',
     'Qual o principal trade-off de uma arquitetura orientada a eventos (event-driven)?',
     'Reduz acoplamento temporal entre componentes, mas troca consistência imediata por consistência eventual e exige lidar com eventos duplicados, fora de ordem ou não processados.',
     'dificil', 'v1', 'rascunho'),

    -- Evolução de Arquitetura e Trade-offs
    ((SELECT id FROM domain WHERE slug = 'arquitetura'),
     'a2000000-0000-4000-8000-000000000005',
     'O que registra um ADR (Architecture Decision Record)?',
     'O contexto de uma decisão arquitetural, as alternativas consideradas, a decisão tomada e suas consequências (inclusive as negativas).',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'arquitetura'),
     'a2000000-0000-4000-8000-000000000005',
     'Por que arquitetura não deve ser tratada como uma decisão única e definitiva?',
     'Porque sistemas evoluem com o tempo (crescimento de time, mudança de carga); desenhar módulos coesos e fracamente acoplados desde o início reduz o custo de futuras mudanças estruturais.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'arquitetura'),
     'a2000000-0000-4000-8000-000000000005',
     'O que uma resposta forte sobre decisão arquitetural deve sempre explicitar em uma entrevista?',
     'O que está sendo trocado por quê (o trade-off) e como a escolha se conecta aos requisitos concretos do problema, não apenas as vantagens da opção escolhida.',
     'media', 'v1', 'rascunho');

-- =====================================================================================
-- QUESTIONS + ALTERNATIVAS (18: 6 fácil, 6 média, 6 difícil)
-- =====================================================================================

-- ---- FÁCEIS (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000001',
    'O que melhor define um "estilo arquitetural"?',
    'Um estilo arquitetural é um conjunto de restrições e princípios (não uma implementação pronta) que orienta como componentes se organizam e se comunicam, como camadas, cliente-servidor ou event-driven.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que melhor define um "estilo arquitetural"?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um conjunto de restrições e princípios que orienta como os componentes de um sistema se organizam e se comunicam', true),
    ((SELECT id FROM question WHERE enunciado = 'O que melhor define um "estilo arquitetural"?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma biblioteca específica de código reutilizável entre projetos', false),
    ((SELECT id FROM question WHERE enunciado = 'O que melhor define um "estilo arquitetural"?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um framework obrigatório para implementar APIs REST', false),
    ((SELECT id FROM question WHERE enunciado = 'O que melhor define um "estilo arquitetural"?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma ferramenta de versionamento de banco de dados', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000002',
    'Qual é uma vantagem prática de uma arquitetura monolítica em relação a microsserviços?',
    'O monólito é implantado como uma única unidade, o que simplifica operação, permite transações locais simples e evita a sobrecarga de chamadas em rede entre módulos.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual é uma vantagem prática de uma arquitetura monolítica em relação a microsserviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Simplicidade operacional, com deploy único e transações locais sem coordenação distribuída', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual é uma vantagem prática de uma arquitetura monolítica em relação a microsserviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Permite que cada módulo escale de forma totalmente independente dos demais', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é uma vantagem prática de uma arquitetura monolítica em relação a microsserviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Elimina a necessidade de testes de integração', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é uma vantagem prática de uma arquitetura monolítica em relação a microsserviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Garante consistência eventual entre todos os módulos automaticamente', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000003',
    'O que é acoplamento entre dois módulos de um sistema?',
    'Acoplamento mede o grau de dependência de um módulo em relação aos detalhes de implementação de outro; quanto maior, mais mudanças em um módulo forçam mudanças no outro.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que é acoplamento entre dois módulos de um sistema?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O grau de dependência de um módulo em relação à implementação interna de outro', true),
    ((SELECT id FROM question WHERE enunciado = 'O que é acoplamento entre dois módulos de um sistema?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A quantidade de linhas de código de um módulo', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é acoplamento entre dois módulos de um sistema?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O número de desenvolvedores responsáveis por um módulo', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é acoplamento entre dois módulos de um sistema?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A velocidade de resposta de uma API', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000003',
    'O que caracteriza um módulo com alta coesão?',
    'Alta coesão significa que os elementos internos do módulo estão fortemente relacionados e servem a um propósito comum bem definido, em oposição a um módulo que mistura responsabilidades não relacionadas.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza um módulo com alta coesão?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Seus elementos internos estão fortemente relacionados e servem a um propósito comum', true),
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza um módulo com alta coesão?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Ele depende de muitos outros módulos para funcionar', false),
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza um módulo com alta coesão?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Ele expõe todos os seus detalhes internos publicamente', false),
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza um módulo com alta coesão?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Ele é implantado separadamente dos demais módulos do sistema', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'Na arquitetura hexagonal, qual é o papel de um "adaptador"?',
    'Um adaptador implementa uma porta (interface) definida pelo núcleo de negócio, conectando-o a uma tecnologia concreta, como um banco de dados ou um endpoint HTTP.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Na arquitetura hexagonal, qual é o papel de um "adaptador"?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Implementar uma porta definida pelo núcleo, conectando-o a uma tecnologia concreta', true),
    ((SELECT id FROM question WHERE enunciado = 'Na arquitetura hexagonal, qual é o papel de um "adaptador"?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Definir as regras de negócio centrais do sistema', false),
    ((SELECT id FROM question WHERE enunciado = 'Na arquitetura hexagonal, qual é o papel de um "adaptador"?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Substituir a necessidade de testes automatizados', false),
    ((SELECT id FROM question WHERE enunciado = 'Na arquitetura hexagonal, qual é o papel de um "adaptador"?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Armazenar configurações de ambiente da aplicação', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000005',
    'O que é um Architecture Decision Record (ADR)?',
    'Um ADR é um documento curto que registra o contexto, as alternativas consideradas, a decisão tomada e as consequências de uma decisão arquitetural relevante.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que é um Architecture Decision Record (ADR)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um documento que registra contexto, alternativas, decisão tomada e consequências de uma decisão arquitetural', true),
    ((SELECT id FROM question WHERE enunciado = 'O que é um Architecture Decision Record (ADR)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um log técnico gerado automaticamente pelo servidor de aplicação', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é um Architecture Decision Record (ADR)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um relatório de performance de banco de dados', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é um Architecture Decision Record (ADR)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um contrato de nível de serviço (SLA) entre equipes', false);

-- ---- MÉDIAS (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000001',
    'Em uma API REST organizada em camadas (Controller, Service, Repository), qual mudança deveria ficar isolada apenas na camada de Service?',
    'A camada de Service concentra a regra de negócio; uma mudança na regra (ex.: novo critério para cancelamento de pedido) deve ser isolada ali, sem exigir alterações em Controller ou Repository.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Em uma API REST organizada em camadas (Controller, Service, Repository), qual mudança deveria ficar isolada apenas na camada de Service?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma mudança no critério de negócio que define se um pedido pode ser cancelado', true),
    ((SELECT id FROM question WHERE enunciado = 'Em uma API REST organizada em camadas (Controller, Service, Repository), qual mudança deveria ficar isolada apenas na camada de Service?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma mudança no formato JSON aceito na requisição HTTP', false),
    ((SELECT id FROM question WHERE enunciado = 'Em uma API REST organizada em camadas (Controller, Service, Repository), qual mudança deveria ficar isolada apenas na camada de Service?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma troca do driver de conexão do banco de dados', false),
    ((SELECT id FROM question WHERE enunciado = 'Em uma API REST organizada em camadas (Controller, Service, Repository), qual mudança deveria ficar isolada apenas na camada de Service?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma mudança no esquema da tabela usada para persistência', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000002',
    'Qual problema os microsserviços resolvem, antes de qualquer outro, segundo a justificativa mais defensável em uma entrevista de System Design?',
    'Microsserviços resolvem principalmente um problema organizacional — permitir que múltiplos times grandes desenvolvam e implantem de forma independente — mais do que um problema técnico isolado.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual problema os microsserviços resolvem, antes de qualquer outro, segundo a justificativa mais defensável em uma entrevista de System Design?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um problema organizacional: permitir que times grandes implantem de forma independente', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual problema os microsserviços resolvem, antes de qualquer outro, segundo a justificativa mais defensável em uma entrevista de System Design?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A eliminação total da necessidade de monitoramento em produção', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual problema os microsserviços resolvem, antes de qualquer outro, segundo a justificativa mais defensável em uma entrevista de System Design?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A garantia automática de consistência forte entre serviços', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual problema os microsserviços resolvem, antes de qualquer outro, segundo a justificativa mais defensável em uma entrevista de System Design?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A redução do número total de linhas de código do sistema', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000003',
    'Qual das técnicas a seguir é uma forma eficaz de reduzir o acoplamento entre dois módulos?',
    'Depender de uma interface/contrato estável (inversão de dependência) em vez de depender diretamente da implementação concreta reduz o acoplamento, pois isola quem consome de detalhes internos de quem implementa.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual das técnicas a seguir é uma forma eficaz de reduzir o acoplamento entre dois módulos?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Depender de uma interface/contrato estável em vez da implementação concreta do outro módulo', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual das técnicas a seguir é uma forma eficaz de reduzir o acoplamento entre dois módulos?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Fazer um módulo acessar diretamente as tabelas internas do banco de dados do outro módulo', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual das técnicas a seguir é uma forma eficaz de reduzir o acoplamento entre dois módulos?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Concentrar toda a lógica de negócio em uma única classe compartilhada por todos os módulos', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual das técnicas a seguir é uma forma eficaz de reduzir o acoplamento entre dois módulos?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Remover toda documentação de contratos entre módulos para simplificar a comunicação', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'Qual cenário melhor justifica a adoção de CQRS em um sistema?',
    'CQRS se justifica quando os padrões de leitura e escrita divergem muito, permitindo otimizar cada modelo separadamente; aplicá-lo sem essa divergência real é complexidade desnecessária.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual cenário melhor justifica a adoção de CQRS em um sistema?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Quando os padrões de leitura e escrita divergem muito e se beneficiam de modelos otimizados separadamente', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual cenário melhor justifica a adoção de CQRS em um sistema?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Quando o sistema é pequeno e tem apenas um tipo de usuário', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual cenário melhor justifica a adoção de CQRS em um sistema?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Quando se quer eliminar completamente a necessidade de um banco de dados', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual cenário melhor justifica a adoção de CQRS em um sistema?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Quando todo o sistema é implantado como um único monólito sem módulos', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'Em uma arquitetura orientada a eventos, o que a comunicação por eventos reduz entre produtor e consumidor?',
    'A comunicação por eventos reduz o acoplamento temporal: o produtor publica o evento e segue seu processamento sem esperar (nem conhecer) o consumidor.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Em uma arquitetura orientada a eventos, o que a comunicação por eventos reduz entre produtor e consumidor?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O acoplamento temporal — o produtor não precisa esperar nem conhecer o consumidor', true),
    ((SELECT id FROM question WHERE enunciado = 'Em uma arquitetura orientada a eventos, o que a comunicação por eventos reduz entre produtor e consumidor?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A necessidade de qualquer tipo de contrato entre produtor e consumidor', false),
    ((SELECT id FROM question WHERE enunciado = 'Em uma arquitetura orientada a eventos, o que a comunicação por eventos reduz entre produtor e consumidor?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A necessidade de consistência de dados entre os serviços', false),
    ((SELECT id FROM question WHERE enunciado = 'Em uma arquitetura orientada a eventos, o que a comunicação por eventos reduz entre produtor e consumidor?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O tempo de processamento interno do próprio produtor', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000005',
    'Por que projetar módulos coesos e fracamente acoplados desde o início de um monólito facilita uma futura extração de microsserviços?',
    'Fronteiras de módulo bem definidas significam que a lógica de negócio já está isolada; extrair um módulo para um serviço próprio se torna uma mudança de fronteira de deploy, não uma reescrita de regra de negócio.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Por que projetar módulos coesos e fracamente acoplados desde o início de um monólito facilita uma futura extração de microsserviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Porque a lógica de negócio já está isolada, tornando a extração uma mudança de fronteira de deploy, não uma reescrita', true),
    ((SELECT id FROM question WHERE enunciado = 'Por que projetar módulos coesos e fracamente acoplados desde o início de um monólito facilita uma futura extração de microsserviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Porque elimina completamente a necessidade de testes automatizados', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que projetar módulos coesos e fracamente acoplados desde o início de um monólito facilita uma futura extração de microsserviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Porque garante desempenho superior independentemente da carga do sistema', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que projetar módulos coesos e fracamente acoplados desde o início de um monólito facilita uma futura extração de microsserviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Porque converte automaticamente transações locais em transações distribuídas', false);

-- ---- DIFÍCEIS (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000002',
    'Um time pequeno, em fase de validação de produto, insiste em adotar microsserviços "para já nascer escalável". Qual é o risco arquitetural mais provável dessa decisão?',
    'Sem fronteiras de domínio maduras (que só se revelam com o uso real do produto), o time provavelmente vai errar a divisão dos serviços e pagar o custo de comunicação distribuída e complexidade operacional sem ainda ter o problema de escala que justificaria isso — um caso clássico de complexidade prematura.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Um time pequeno, em fase de validação de produto, insiste em adotar microsserviços "para já nascer escalável". Qual é o risco arquitetural mais provável dessa decisão?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Pagar o custo de complexidade distribuída e provavelmente errar a divisão dos serviços antes de conhecer bem o domínio', true),
    ((SELECT id FROM question WHERE enunciado = 'Um time pequeno, em fase de validação de produto, insiste em adotar microsserviços "para já nascer escalável". Qual é o risco arquitetural mais provável dessa decisão?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Nenhum risco relevante, pois microsserviços sempre escalam melhor que monólitos independentemente do estágio do produto', false),
    ((SELECT id FROM question WHERE enunciado = 'Um time pequeno, em fase de validação de produto, insiste em adotar microsserviços "para já nascer escalável". Qual é o risco arquitetural mais provável dessa decisão?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O sistema ficará automaticamente mais fácil de testar do que um monólito', false),
    ((SELECT id FROM question WHERE enunciado = 'Um time pequeno, em fase de validação de produto, insiste em adotar microsserviços "para já nascer escalável". Qual é o risco arquitetural mais provável dessa decisão?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A necessidade de observabilidade distribuída desaparece por o sistema ser novo', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000003',
    'Dois módulos de um sistema (Catálogo e Pedidos) precisam trocar informação sobre preço de produtos. Qual abordagem preserva melhor baixo acoplamento e alta coesão entre eles?',
    'Pedidos consultar o preço via uma API ou evento publicado pelo Catálogo preserva a coesão de cada módulo (cada um mantém sua responsabilidade) e mantém o acoplamento baixo e explícito via contrato, ao contrário de acessar diretamente a tabela interna do outro módulo.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Dois módulos de um sistema (Catálogo e Pedidos) precisam trocar informação sobre preço de produtos. Qual abordagem preserva melhor baixo acoplamento e alta coesão entre eles?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Pedidos consulta o preço via uma API ou evento publicado pelo módulo Catálogo, sem acessar suas tabelas diretamente', true),
    ((SELECT id FROM question WHERE enunciado = 'Dois módulos de um sistema (Catálogo e Pedidos) precisam trocar informação sobre preço de produtos. Qual abordagem preserva melhor baixo acoplamento e alta coesão entre eles?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Pedidos faz uma consulta SQL diretamente na tabela de produtos do módulo Catálogo', false),
    ((SELECT id FROM question WHERE enunciado = 'Dois módulos de um sistema (Catálogo e Pedidos) precisam trocar informação sobre preço de produtos. Qual abordagem preserva melhor baixo acoplamento e alta coesão entre eles?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Os dois módulos são fundidos em um único módulo para eliminar a comunicação', false),
    ((SELECT id FROM question WHERE enunciado = 'Dois módulos de um sistema (Catálogo e Pedidos) precisam trocar informação sobre preço de produtos. Qual abordagem preserva melhor baixo acoplamento e alta coesão entre eles?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Pedidos duplica manualmente e sem sincronização os dados de preço em seu próprio código-fonte', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'Em uma arquitetura hexagonal, ao trocar o banco de dados de Postgres para outro banco, o que idealmente NÃO deveria precisar mudar?',
    'A lógica de negócio no núcleo da aplicação depende apenas das portas (interfaces); trocar a tecnologia de persistência deveria exigir apenas um novo adaptador, sem alterar as regras de negócio.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Em uma arquitetura hexagonal, ao trocar o banco de dados de Postgres para outro banco, o que idealmente NÃO deveria precisar mudar?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A lógica de negócio no núcleo da aplicação', true),
    ((SELECT id FROM question WHERE enunciado = 'Em uma arquitetura hexagonal, ao trocar o banco de dados de Postgres para outro banco, o que idealmente NÃO deveria precisar mudar?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O adaptador de persistência que implementa a porta de acesso a dados', false),
    ((SELECT id FROM question WHERE enunciado = 'Em uma arquitetura hexagonal, ao trocar o banco de dados de Postgres para outro banco, o que idealmente NÃO deveria precisar mudar?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'As queries específicas usadas para acessar o novo banco', false),
    ((SELECT id FROM question WHERE enunciado = 'Em uma arquitetura hexagonal, ao trocar o banco de dados de Postgres para outro banco, o que idealmente NÃO deveria precisar mudar?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'As configurações de conexão com o banco de dados', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'Um sistema orientado a eventos processa "PedidoCriado" para enviar e-mail de confirmação, mas ocasionalmente recebe o mesmo evento duas vezes devido a reentrega do broker. Qual característica o consumidor precisa ter para lidar com isso corretamente?',
    'Idempotência: o consumidor precisa garantir que processar o mesmo evento mais de uma vez produza o mesmo efeito de processá-lo uma única vez (ex.: não enviar o e-mail duplicado), já que reentrega e duplicação são esperadas em sistemas orientados a eventos.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Um sistema orientado a eventos processa "PedidoCriado" para enviar e-mail de confirmação, mas ocasionalmente recebe o mesmo evento duas vezes devido a reentrega do broker. Qual característica o consumidor precisa ter para lidar com isso corretamente?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Idempotência no processamento do evento, evitando efeitos colaterais duplicados como reenvio do e-mail', true),
    ((SELECT id FROM question WHERE enunciado = 'Um sistema orientado a eventos processa "PedidoCriado" para enviar e-mail de confirmação, mas ocasionalmente recebe o mesmo evento duas vezes devido a reentrega do broker. Qual característica o consumidor precisa ter para lidar com isso corretamente?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um esquema de camadas mais rígido entre Controller e Service', false),
    ((SELECT id FROM question WHERE enunciado = 'Um sistema orientado a eventos processa "PedidoCriado" para enviar e-mail de confirmação, mas ocasionalmente recebe o mesmo evento duas vezes devido a reentrega do broker. Qual característica o consumidor precisa ter para lidar com isso corretamente?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A adoção de CQRS para separar leitura e escrita do e-mail', false),
    ((SELECT id FROM question WHERE enunciado = 'Um sistema orientado a eventos processa "PedidoCriado" para enviar e-mail de confirmação, mas ocasionalmente recebe o mesmo evento duas vezes devido a reentrega do broker. Qual característica o consumidor precisa ter para lidar com isso corretamente?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A conversão do monólito em microsserviços', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000005',
    'Em uma entrevista de System Design, um candidato defende microsserviços como "sempre superiores" ao monólito, sem mencionar nenhuma desvantagem. Por que isso é considerado um sinal de alerta para o entrevistador?',
    'Toda decisão arquitetural envolve trade-offs; apresentar uma opção como universalmente superior, sem reconhecer o que se abre mão dela (ex.: simplicidade operacional, transações locais), sinaliza falta de maturidade em avaliar arquitetura de forma contextual.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Em uma entrevista de System Design, um candidato defende microsserviços como "sempre superiores" ao monólito, sem mencionar nenhuma desvantagem. Por que isso é considerado um sinal de alerta para o entrevistador?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Porque ignora que toda decisão arquitetural envolve trade-offs, sugerindo falta de avaliação contextual do problema', true),
    ((SELECT id FROM question WHERE enunciado = 'Em uma entrevista de System Design, um candidato defende microsserviços como "sempre superiores" ao monólito, sem mencionar nenhuma desvantagem. Por que isso é considerado um sinal de alerta para o entrevistador?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Porque microsserviços são, de fato, sempre a escolha tecnicamente incorreta', false),
    ((SELECT id FROM question WHERE enunciado = 'Em uma entrevista de System Design, um candidato defende microsserviços como "sempre superiores" ao monólito, sem mencionar nenhuma desvantagem. Por que isso é considerado um sinal de alerta para o entrevistador?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Porque entrevistadores nunca aceitam a opção de microsserviços como resposta válida', false),
    ((SELECT id FROM question WHERE enunciado = 'Em uma entrevista de System Design, um candidato defende microsserviços como "sempre superiores" ao monólito, sem mencionar nenhuma desvantagem. Por que isso é considerado um sinal de alerta para o entrevistador?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Porque a pergunta exige obrigatoriamente uma resposta sobre bancos de dados', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000001',
    'Uma equipe percebe que uma requisição crítica atravessa cinco camadas rígidas (Controller, Service, Facade, Gateway, Repository), cada uma apenas repassando a chamada adiante, e o overhead de indireção está afetando a latência. Qual é a interpretação arquitetural mais correta desse cenário?',
    'Camadas devem agregar responsabilidade real (validação, regra de negócio, tradução de modelo); quando existem apenas para repassar chamadas sem transformar ou decidir nada, elas geram overhead de indireção sem o benefício de separação de responsabilidades — é o antipadrão da "camada anêmica" citado como risco da arquitetura em camadas.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Uma equipe percebe que uma requisição crítica atravessa cinco camadas rígidas (Controller, Service, Facade, Gateway, Repository), cada uma apenas repassando a chamada adiante, e o overhead de indireção está afetando a latência. Qual é a interpretação arquitetural mais correta desse cenário?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'As camadas intermediárias que só repassam chamadas sem agregar responsabilidade real são um antipadrão de camada anêmica, e podem ser eliminadas ou consolidadas sem perda de separação de responsabilidades', true),
    ((SELECT id FROM question WHERE enunciado = 'Uma equipe percebe que uma requisição crítica atravessa cinco camadas rígidas (Controller, Service, Facade, Gateway, Repository), cada uma apenas repassando a chamada adiante, e o overhead de indireção está afetando a latência. Qual é a interpretação arquitetural mais correta desse cenário?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Toda arquitetura em camadas deve ter exatamente cinco camadas para ser considerada correta', false),
    ((SELECT id FROM question WHERE enunciado = 'Uma equipe percebe que uma requisição crítica atravessa cinco camadas rígidas (Controller, Service, Facade, Gateway, Repository), cada uma apenas repassando a chamada adiante, e o overhead de indireção está afetando a latência. Qual é a interpretação arquitetural mais correta desse cenário?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O problema só pode ser resolvido migrando o sistema inteiro para microsserviços', false),
    ((SELECT id FROM question WHERE enunciado = 'Uma equipe percebe que uma requisição crítica atravessa cinco camadas rígidas (Controller, Service, Facade, Gateway, Repository), cada uma apenas repassando a chamada adiante, e o overhead de indireção está afetando a latência. Qual é a interpretação arquitetural mais correta desse cenário?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Latência não tem relação nenhuma com o número de camadas atravessadas por uma requisição', false);
