-- Ampliação do pool de Questions — Domínio Arquitetura (slug 'arquitetura').
-- Fase 1 do TICKET-content-expansion-questoes.md: adiciona 18 Questions novas (6 fácil /
-- 6 média / 6 difícil) + 72 alternativas (4 por Question) às 18 já existentes em
-- V14__seed_conteudo_arquitetura.sql, elevando o pool para 36 Questions neste domínio.
--
-- Regras (iguais às do V14, ver TICKET-content-database.md e TICKET-content-expansion-questoes.md):
-- - Não insere Domain nem Concept novos: reaproveita os 5 Concepts já semeados por V14
--   (UUIDs literais 'a2000000-0000-4000-8000-000000000001' a '...005').
-- - content_version = 'v1', status_revisao = 'rascunho'.
-- - Question e suas 4 alternativas na mesma migração, respeitando o trigger de constraint
--   adiada de V6 (trg_verificar_alternativas_question).
-- - Enunciados desta leva foram conferidos um a um contra os 18 enunciados de V14 (fáceis,
--   médias e difíceis) para garantir ausência de duplicação literal ou de reformulação que
--   testasse o mesmo ponto de forma indistinguível.

-- =====================================================================================
-- QUESTIONS + ALTERNATIVAS (18 novas: 6 fácil, 6 média, 6 difícil)
-- =====================================================================================

-- ---- FÁCEIS (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000001',
    'Além da arquitetura em camadas, qual das opções a seguir é um exemplo de estilo arquitetural?',
    'Cliente-servidor é um estilo arquitetural, assim como camadas, pipe-and-filter, orientado a eventos e microkernel; injeção de dependência, Repository e normalização de banco são técnicas/padrões de nível mais baixo, não estilos arquiteturais.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Além da arquitetura em camadas, qual das opções a seguir é um exemplo de estilo arquitetural?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Cliente-servidor', true),
    ((SELECT id FROM question WHERE enunciado = 'Além da arquitetura em camadas, qual das opções a seguir é um exemplo de estilo arquitetural?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Injeção de dependência', false),
    ((SELECT id FROM question WHERE enunciado = 'Além da arquitetura em camadas, qual das opções a seguir é um exemplo de estilo arquitetural?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Padrão Repository', false),
    ((SELECT id FROM question WHERE enunciado = 'Além da arquitetura em camadas, qual das opções a seguir é um exemplo de estilo arquitetural?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Normalização de banco de dados', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000002',
    'Em uma arquitetura de microsserviços, é comum que cada serviço tenha:',
    'Cada microsserviço tipicamente possui seu próprio banco de dados, o que reforça sua autonomia de deploy e evolução, mas exige lidar com consistência eventual entre os dados de serviços diferentes.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Em uma arquitetura de microsserviços, é comum que cada serviço tenha:' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Seu próprio banco de dados, gerenciado de forma independente', true),
    ((SELECT id FROM question WHERE enunciado = 'Em uma arquitetura de microsserviços, é comum que cada serviço tenha:' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Acesso direto e irrestrito ao banco de dados de todos os outros serviços', false),
    ((SELECT id FROM question WHERE enunciado = 'Em uma arquitetura de microsserviços, é comum que cada serviço tenha:' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma única thread compartilhada com os demais serviços', false),
    ((SELECT id FROM question WHERE enunciado = 'Em uma arquitetura de microsserviços, é comum que cada serviço tenha:' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O mesmo processo de deploy que os demais serviços do sistema', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000003',
    'O que caracteriza o antipadrão conhecido como "God Object" (ou "God Service")?',
    '"God Object"/"God Service" é o sintoma clássico de baixa coesão: o módulo faz-tudo mistura responsabilidades sem relação entre si, tornando-se difícil de entender, testar e evoluir sem efeitos colaterais.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza o antipadrão conhecido como "God Object" (ou "God Service")?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma classe ou serviço que concentra responsabilidades não relacionadas, misturando múltiplas razões de mudança em um único lugar', true),
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza o antipadrão conhecido como "God Object" (ou "God Service")?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um módulo que implementa apenas uma responsabilidade bem definida', false),
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza o antipadrão conhecido como "God Object" (ou "God Service")?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um serviço que se comunica exclusivamente por eventos assíncronos', false),
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza o antipadrão conhecido como "God Object" (ou "God Service")?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma classe que implementa uma interface pública bem documentada', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'O que significa a sigla CQRS?',
    'CQRS (Command Query Responsibility Segregation) separa o modelo usado para escrever dados (comandos) do modelo usado para lê-los (queries), permitindo otimizar cada lado de forma independente.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que significa a sigla CQRS?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Command Query Responsibility Segregation — separação entre o modelo de escrita e o modelo de leitura', true),
    ((SELECT id FROM question WHERE enunciado = 'O que significa a sigla CQRS?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Centralized Query Routing System — um sistema de roteamento centralizado de queries', false),
    ((SELECT id FROM question WHERE enunciado = 'O que significa a sigla CQRS?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Consistent Query Replication Strategy — uma estratégia de replicação consistente de dados', false),
    ((SELECT id FROM question WHERE enunciado = 'O que significa a sigla CQRS?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Command Queue Retry Service — um serviço de reprocessamento de comandos', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'Em uma arquitetura orientada a eventos, o que representa um evento como "PedidoCriado"?',
    'Um evento representa um fato já ocorrido; o produtor publica o evento e segue seu processamento sem esperar (nem conhecer) quem vai consumi-lo, o que é a base do desacoplamento temporal em arquiteturas orientadas a eventos.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Em uma arquitetura orientada a eventos, o que representa um evento como "PedidoCriado"?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um fato que já aconteceu, publicado para que outros componentes reajam a ele de forma assíncrona', true),
    ((SELECT id FROM question WHERE enunciado = 'Em uma arquitetura orientada a eventos, o que representa um evento como "PedidoCriado"?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma chamada síncrona que bloqueia o produtor até a resposta do consumidor', false),
    ((SELECT id FROM question WHERE enunciado = 'Em uma arquitetura orientada a eventos, o que representa um evento como "PedidoCriado"?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma tabela do banco de dados usada exclusivamente para leitura', false),
    ((SELECT id FROM question WHERE enunciado = 'Em uma arquitetura orientada a eventos, o que representa um evento como "PedidoCriado"?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um contrato de API REST que substitui a necessidade de mensageria', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000005',
    'O que defende a ideia de "arquitetura evolutiva"?',
    'Arquitetura evolutiva defende desenhar o sistema — por exemplo, mantendo módulos coesos e fracamente acoplados — para que mudanças estruturais futuras (como extrair um serviço) tenham custo razoável, em vez de tratar a arquitetura inicial como definitiva.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que defende a ideia de "arquitetura evolutiva"?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Que o sistema deve ser desenhado para permitir mudanças estruturais futuras com custo razoável, em vez de tratar a arquitetura como uma decisão definitiva tomada uma única vez', true),
    ((SELECT id FROM question WHERE enunciado = 'O que defende a ideia de "arquitetura evolutiva"?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Que toda arquitetura deve ser reescrita do zero a cada nova versão do produto', false),
    ((SELECT id FROM question WHERE enunciado = 'O que defende a ideia de "arquitetura evolutiva"?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Que decisões arquiteturais nunca devem ser documentadas, pois vão mudar de qualquer forma', false),
    ((SELECT id FROM question WHERE enunciado = 'O que defende a ideia de "arquitetura evolutiva"?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Que microsserviços são a única arquitetura capaz de evoluir ao longo do tempo', false);

-- ---- MÉDIAS (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000001',
    'Em uma variação mais flexível de arquitetura em camadas (camadas "abertas"), uma camada superior pode se comunicar com:',
    'Em variações mais flexíveis da arquitetura em camadas, uma camada pode se comunicar com qualquer camada inferior, não só com a imediatamente abaixo — diferente do modelo estrito, em que a comunicação ocorre apenas entre camadas adjacentes.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Em uma variação mais flexível de arquitetura em camadas (camadas "abertas"), uma camada superior pode se comunicar com:' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Qualquer camada inferior, não apenas a imediatamente abaixo', true),
    ((SELECT id FROM question WHERE enunciado = 'Em uma variação mais flexível de arquitetura em camadas (camadas "abertas"), uma camada superior pode se comunicar com:' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Apenas com camadas superiores a ela', false),
    ((SELECT id FROM question WHERE enunciado = 'Em uma variação mais flexível de arquitetura em camadas (camadas "abertas"), uma camada superior pode se comunicar com:' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Exclusivamente com o banco de dados, ignorando as demais camadas', false),
    ((SELECT id FROM question WHERE enunciado = 'Em uma variação mais flexível de arquitetura em camadas (camadas "abertas"), uma camada superior pode se comunicar com:' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Nenhuma outra camada, pois cada camada deve ser totalmente isolada', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000002',
    'Qual dos itens a seguir é um custo real, que não deve ser subestimado, ao adotar microsserviços?',
    'Microsserviços trazem custos reais como consistência eventual entre serviços, comunicação em rede mais lenta e falível, e maior complexidade operacional (orquestração, observabilidade distribuída, versionamento de contratos) — esses custos não devem ser subestimados.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual dos itens a seguir é um custo real, que não deve ser subestimado, ao adotar microsserviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A necessidade de lidar com consistência eventual entre serviços e a complexidade de observabilidade distribuída', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual dos itens a seguir é um custo real, que não deve ser subestimado, ao adotar microsserviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A eliminação total de qualquer necessidade de comunicação entre times', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual dos itens a seguir é um custo real, que não deve ser subestimado, ao adotar microsserviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A garantia automática de menor latência em toda chamada entre serviços', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual dos itens a seguir é um custo real, que não deve ser subestimado, ao adotar microsserviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A simplificação da infraestrutura necessária para operar o sistema', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000003',
    'No contexto de dividir um sistema em módulos, o que representa um "bounded context" (termo de Domain-Driven Design)?',
    'Um bounded context delimita onde um modelo de domínio é consistente e coeso; é usado como base para decidir limites de módulos (dentro de um monólito modular) ou de microsserviços, alinhando fronteiras técnicas às fronteiras reais do negócio.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'No contexto de dividir um sistema em módulos, o que representa um "bounded context" (termo de Domain-Driven Design)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um limite dentro do qual um modelo de domínio é consistente e coeso, usado como critério para definir fronteiras de módulos ou serviços', true),
    ((SELECT id FROM question WHERE enunciado = 'No contexto de dividir um sistema em módulos, o que representa um "bounded context" (termo de Domain-Driven Design)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um limite de taxa de requisições aplicado a uma API pública', false),
    ((SELECT id FROM question WHERE enunciado = 'No contexto de dividir um sistema em módulos, o que representa um "bounded context" (termo de Domain-Driven Design)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma restrição de schema que impede alterações em uma tabela específica', false),
    ((SELECT id FROM question WHERE enunciado = 'No contexto de dividir um sistema em módulos, o que representa um "bounded context" (termo de Domain-Driven Design)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um tipo de teste automatizado que valida os limites de um sistema', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'Qual é o principal benefício de testabilidade trazido pela arquitetura hexagonal?',
    'Como o núcleo de negócio depende apenas de portas (interfaces), é possível testá-lo com adaptadores falsos (in-memory) no lugar de banco de dados ou serviços externos reais, tornando os testes mais rápidos e independentes de infraestrutura.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual é o principal benefício de testabilidade trazido pela arquitetura hexagonal?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A lógica de negócio pode ser testada com adaptadores falsos (in-memory), sem precisar subir infraestrutura real como banco de dados', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o principal benefício de testabilidade trazido pela arquitetura hexagonal?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Ela elimina completamente a necessidade de escrever testes automatizados', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o principal benefício de testabilidade trazido pela arquitetura hexagonal?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Ela garante que testes de integração nunca sejam necessários', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o principal benefício de testabilidade trazido pela arquitetura hexagonal?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Ela obriga que todos os testes sejam executados diretamente em produção', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'Qual é o principal custo de adotar CQRS em um sistema?',
    'CQRS exige manter e evoluir dois modelos distintos — um para comandos, outro para queries —, o que pode incluir sincronização entre eles; esse custo só se justifica quando os padrões de leitura e escrita realmente divergem o suficiente para compensar a complexidade adicional.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual é o principal custo de adotar CQRS em um sistema?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Manter dois modelos separados (leitura e escrita), com possível necessidade de sincronização entre eles', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o principal custo de adotar CQRS em um sistema?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A impossibilidade de usar bancos de dados relacionais', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o principal custo de adotar CQRS em um sistema?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A obrigatoriedade de migrar todo o sistema para microsserviços', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o principal custo de adotar CQRS em um sistema?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A perda de qualquer garantia de consistência dos dados', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000005',
    'Segundo a prática recomendada, qual é o valor central de registrar um ADR (Architecture Decision Record)?',
    'O valor de um ADR não está na decisão em si, mas no registro do raciocínio: meses depois, alguém pode entender por que uma alternativa foi escolhida em vez de outra, evitando decisões re-discutidas do zero ou revertidas sem entender o motivo original.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Segundo a prática recomendada, qual é o valor central de registrar um ADR (Architecture Decision Record)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Documentar o raciocínio por trás da decisão — contexto, alternativas consideradas e consequências —, não apenas a decisão final em si', true),
    ((SELECT id FROM question WHERE enunciado = 'Segundo a prática recomendada, qual é o valor central de registrar um ADR (Architecture Decision Record)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Garantir que a decisão nunca mais poderá ser revisitada ou alterada', false),
    ((SELECT id FROM question WHERE enunciado = 'Segundo a prática recomendada, qual é o valor central de registrar um ADR (Architecture Decision Record)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Substituir a necessidade de testes automatizados sobre o código', false),
    ((SELECT id FROM question WHERE enunciado = 'Segundo a prática recomendada, qual é o valor central de registrar um ADR (Architecture Decision Record)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Registrar exclusivamente métricas de performance do sistema em produção', false);

-- ---- DIFÍCEIS (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000001',
    'Em um sistema estruturado em camadas, o Controller importa diretamente classes de entidade do ORM (camada de persistência) para montar a resposta HTTP, pulando a camada de Service. Qual é o problema arquitetural mais provável dessa prática?',
    'Quando a camada de apresentação depende diretamente de detalhes da camada de persistência, uma mudança no esquema do banco pode se propagar até o Controller, quebrando exatamente o isolamento que a divisão em camadas deveria garantir.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Em um sistema estruturado em camadas, o Controller importa diretamente classes de entidade do ORM (camada de persistência) para montar a resposta HTTP, pulando a camada de Service. Qual é o problema arquitetural mais provável dessa prática?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma mudança no esquema de persistência passa a poder quebrar diretamente a camada de apresentação, esvaziando o propósito de isolamento da divisão em camadas', true),
    ((SELECT id FROM question WHERE enunciado = 'Em um sistema estruturado em camadas, o Controller importa diretamente classes de entidade do ORM (camada de persistência) para montar a resposta HTTP, pulando a camada de Service. Qual é o problema arquitetural mais provável dessa prática?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Nenhum, pois pular camadas sempre melhora o desempenho sem custo arquitetural', false),
    ((SELECT id FROM question WHERE enunciado = 'Em um sistema estruturado em camadas, o Controller importa diretamente classes de entidade do ORM (camada de persistência) para montar a resposta HTTP, pulando a camada de Service. Qual é o problema arquitetural mais provável dessa prática?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O sistema automaticamente se torna orientado a eventos', false),
    ((SELECT id FROM question WHERE enunciado = 'Em um sistema estruturado em camadas, o Controller importa diretamente classes de entidade do ORM (camada de persistência) para montar a resposta HTTP, pulando a camada de Service. Qual é o problema arquitetural mais provável dessa prática?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A camada de Service deixa de precisar existir em qualquer cenário futuro', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000002',
    'Uma equipe decide extrair microsserviços a partir de um monólito cujos módulos internos são fortemente acoplados e compartilham tabelas de banco de dados entre si. Qual é a consequência mais provável dessa extração?',
    'Migrar de um monólito bem modularizado para microsserviços é incremental; migrar de um monólito com módulos emaranhados e tabelas compartilhadas é, na prática, uma reescrita, pois as fronteiras de dados e de lógica de negócio precisam ser criadas do zero.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Uma equipe decide extrair microsserviços a partir de um monólito cujos módulos internos são fortemente acoplados e compartilham tabelas de banco de dados entre si. Qual é a consequência mais provável dessa extração?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A extração se torna, na prática, uma reescrita, pois a lógica de negócio e os dados não estão isolados o suficiente para virarem serviços independentes', true),
    ((SELECT id FROM question WHERE enunciado = 'Uma equipe decide extrair microsserviços a partir de um monólito cujos módulos internos são fortemente acoplados e compartilham tabelas de banco de dados entre si. Qual é a consequência mais provável dessa extração?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A extração ocorre sem nenhum esforço adicional, pois microsserviços resolvem automaticamente acoplamento de dados', false),
    ((SELECT id FROM question WHERE enunciado = 'Uma equipe decide extrair microsserviços a partir de um monólito cujos módulos internos são fortemente acoplados e compartilham tabelas de banco de dados entre si. Qual é a consequência mais provável dessa extração?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O compartilhamento de tabelas entre módulos deixa de ser um problema assim que cada módulo vira um serviço separado', false),
    ((SELECT id FROM question WHERE enunciado = 'Uma equipe decide extrair microsserviços a partir de um monólito cujos módulos internos são fortemente acoplados e compartilham tabelas de banco de dados entre si. Qual é a consequência mais provável dessa extração?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A equipe pode ignorar completamente as fronteiras de dados, pois isso é responsabilidade exclusiva do banco de dados', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000003',
    'Ao desenhar os módulos de um sistema de e-commerce, um time decide colocar "Catálogo" e "Pagamento" no mesmo módulo, justificando que ambos "lidam com produtos e dinheiro". Qual princípio de design essa decisão viola mais diretamente?',
    'Catálogo e Pagamento têm propósitos e motivos de mudança diferentes; agrupá-los no mesmo módulo por uma semelhança superficial ("produtos e dinheiro") fere a alta coesão, tornando o módulo resultante um candidato a "faz-tudo" difícil de manter.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Ao desenhar os módulos de um sistema de e-commerce, um time decide colocar "Catálogo" e "Pagamento" no mesmo módulo, justificando que ambos "lidam com produtos e dinheiro". Qual princípio de design essa decisão viola mais diretamente?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Alta coesão — as duas responsabilidades não têm propósito comum nem mudam pelos mesmos motivos, sendo agrupadas de forma artificial', true),
    ((SELECT id FROM question WHERE enunciado = 'Ao desenhar os módulos de um sistema de e-commerce, um time decide colocar "Catálogo" e "Pagamento" no mesmo módulo, justificando que ambos "lidam com produtos e dinheiro". Qual princípio de design essa decisão viola mais diretamente?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Baixo acoplamento — o problema é que os dois módulos passam a se comunicar por eventos', false),
    ((SELECT id FROM question WHERE enunciado = 'Ao desenhar os módulos de um sistema de e-commerce, um time decide colocar "Catálogo" e "Pagamento" no mesmo módulo, justificando que ambos "lidam com produtos e dinheiro". Qual princípio de design essa decisão viola mais diretamente?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Arquitetura em camadas — o problema é a ausência de uma camada de apresentação', false),
    ((SELECT id FROM question WHERE enunciado = 'Ao desenhar os módulos de um sistema de e-commerce, um time decide colocar "Catálogo" e "Pagamento" no mesmo módulo, justificando que ambos "lidam com produtos e dinheiro". Qual princípio de design essa decisão viola mais diretamente?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'CQRS — o problema é não separar leitura e escrita dentro do módulo', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'Um sistema construído com arquitetura hexagonal recebe uma nova exigência: registrar cada operação de negócio para fins de auditoria, sem acoplar essa responsabilidade ao núcleo do domínio. Qual abordagem é mais consistente com os princípios da arquitetura hexagonal?',
    'A arquitetura hexagonal isola o núcleo de detalhes de infraestrutura; adicionar uma nova responsabilidade transversal como auditoria deve ser feito via um novo adaptador (possivelmente reagindo a um evento de domínio), sem acoplar o núcleo a essa preocupação específica.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Um sistema construído com arquitetura hexagonal recebe uma nova exigência: registrar cada operação de negócio para fins de auditoria, sem acoplar essa responsabilidade ao núcleo do domínio. Qual abordagem é mais consistente com os princípios da arquitetura hexagonal?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Publicar um evento de domínio a cada operação relevante e implementar um novo adaptador que o consome para registrar a auditoria, sem alterar a lógica central', true),
    ((SELECT id FROM question WHERE enunciado = 'Um sistema construído com arquitetura hexagonal recebe uma nova exigência: registrar cada operação de negócio para fins de auditoria, sem acoplar essa responsabilidade ao núcleo do domínio. Qual abordagem é mais consistente com os princípios da arquitetura hexagonal?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Inserir chamadas diretas ao serviço de auditoria dentro das classes de regra de negócio do núcleo', false),
    ((SELECT id FROM question WHERE enunciado = 'Um sistema construído com arquitetura hexagonal recebe uma nova exigência: registrar cada operação de negócio para fins de auditoria, sem acoplar essa responsabilidade ao núcleo do domínio. Qual abordagem é mais consistente com os princípios da arquitetura hexagonal?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Reescrever o núcleo de domínio para depender diretamente do driver de banco de dados usado pela auditoria', false),
    ((SELECT id FROM question WHERE enunciado = 'Um sistema construído com arquitetura hexagonal recebe uma nova exigência: registrar cada operação de negócio para fins de auditoria, sem acoplar essa responsabilidade ao núcleo do domínio. Qual abordagem é mais consistente com os princípios da arquitetura hexagonal?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Migrar todo o sistema para uma arquitetura em camadas antes de implementar a auditoria', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'Uma aplicação interna pequena, usada por poucos usuários e com padrões de leitura e escrita muito parecidos, adota CQRS porque "é uma boa prática usada por grandes empresas". Qual é a crítica mais adequada a essa decisão?',
    'CQRS se justifica quando os padrões de leitura e escrita divergem o suficiente para compensar manter dois modelos; aplicá-lo apenas por ser uma prática usada em outros contextos, sem essa divergência real, é complexidade desnecessária.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Uma aplicação interna pequena, usada por poucos usuários e com padrões de leitura e escrita muito parecidos, adota CQRS porque "é uma boa prática usada por grandes empresas". Qual é a crítica mais adequada a essa decisão?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'CQRS foi aplicado sem a divergência real entre leitura e escrita que justificaria a complexidade adicional, tornando-se complexidade desnecessária', true),
    ((SELECT id FROM question WHERE enunciado = 'Uma aplicação interna pequena, usada por poucos usuários e com padrões de leitura e escrita muito parecidos, adota CQRS porque "é uma boa prática usada por grandes empresas". Qual é a crítica mais adequada a essa decisão?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'CQRS nunca deveria ser usado em nenhum tipo de aplicação, independentemente do contexto', false),
    ((SELECT id FROM question WHERE enunciado = 'Uma aplicação interna pequena, usada por poucos usuários e com padrões de leitura e escrita muito parecidos, adota CQRS porque "é uma boa prática usada por grandes empresas". Qual é a crítica mais adequada a essa decisão?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A aplicação deveria ter adotado microsserviços antes de considerar CQRS', false),
    ((SELECT id FROM question WHERE enunciado = 'Uma aplicação interna pequena, usada por poucos usuários e com padrões de leitura e escrita muito parecidos, adota CQRS porque "é uma boa prática usada por grandes empresas". Qual é a crítica mais adequada a essa decisão?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'CQRS é incompatível com qualquer aplicação que use banco de dados relacional', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000005',
    'Dois times de um mesmo produto tomaram decisões arquiteturais conflitantes (um adotou comunicação síncrona, outro assíncrona, para problemas semelhantes) sem nenhum registro do contexto ou das alternativas consideradas em cada caso. Qual prática poderia ter evitado essa divergência silenciosa?',
    'ADRs registram o raciocínio por trás de decisões arquiteturais relevantes; sem esse registro, times diferentes podem tomar decisões conflitantes para problemas semelhantes sem perceber, pois não há como consultar o contexto e as alternativas já avaliadas por outra equipe.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Dois times de um mesmo produto tomaram decisões arquiteturais conflitantes (um adotou comunicação síncrona, outro assíncrona, para problemas semelhantes) sem nenhum registro do contexto ou das alternativas consideradas em cada caso. Qual prática poderia ter evitado essa divergência silenciosa?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Manter ADRs documentando contexto, alternativas e consequências de cada decisão, permitindo que os times consultassem e alinhassem escolhas anteriores', true),
    ((SELECT id FROM question WHERE enunciado = 'Dois times de um mesmo produto tomaram decisões arquiteturais conflitantes (um adotou comunicação síncrona, outro assíncrona, para problemas semelhantes) sem nenhum registro do contexto ou das alternativas consideradas em cada caso. Qual prática poderia ter evitado essa divergência silenciosa?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Proibir qualquer comunicação assíncrona entre serviços do produto', false),
    ((SELECT id FROM question WHERE enunciado = 'Dois times de um mesmo produto tomaram decisões arquiteturais conflitantes (um adotou comunicação síncrona, outro assíncrona, para problemas semelhantes) sem nenhum registro do contexto ou das alternativas consideradas em cada caso. Qual prática poderia ter evitado essa divergência silenciosa?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Centralizar toda a lógica de negócio dos dois times em um único módulo monolítico', false),
    ((SELECT id FROM question WHERE enunciado = 'Dois times de um mesmo produto tomaram decisões arquiteturais conflitantes (um adotou comunicação síncrona, outro assíncrona, para problemas semelhantes) sem nenhum registro do contexto ou das alternativas consideradas em cada caso. Qual prática poderia ter evitado essa divergência silenciosa?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Eliminar completamente a documentação técnica para acelerar as entregas', false);
