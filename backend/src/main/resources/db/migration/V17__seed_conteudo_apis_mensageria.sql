-- Seed de conteúdo do domínio APIs/Mensageria (Backend Engineer).
-- Fonte: docs/product/tickets/content/TICKET-content-apis-mensageria.md (ticket de domínio)
-- e docs/product/tickets/TICKET-content-database.md (ticket mestre, regras comuns).
-- content_version = 'v1' e status_revisao = 'rascunho' em tudo: autoria assistida por IA,
-- revisão humana obrigatória ainda não realizada (Decisão 2 do ticket mestre).
-- Este arquivo NUNCA insere em domain — referencia a linha já semeada em V13 via subquery
-- por slug ('apis-mensageria'), conforme orientado no cabeçalho de V13.
-- Question + suas 4 alternativas são inseridas na mesma transação (migração Flyway =
-- 1 transação), respeitando o trigger de constraint adiada de V6.

-- =====================================================================================
-- CONCEPTS (5)
-- =====================================================================================

INSERT INTO concept (id, domain_ref, titulo, resumo, content_version, status_revisao)
VALUES
    ('a4000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'Design de contratos REST',
     'Como modelar recursos, verbos HTTP, códigos de status e formatos de payload para expor uma API REST previsível e fácil de evoluir.',
     'v1', 'rascunho'),
    ('a4000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'Versionamento e evolução de APIs',
     'Estratégias para mudar contratos de API sem quebrar clientes existentes: versionamento na URL, em header, campos aditivos e políticas de depreciação.',
     'v1', 'rascunho'),
    ('a4000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'Idempotência em APIs',
     'Por que operações repetidas (retries de rede, timeouts) exigem que o servidor produza o mesmo efeito colateral uma única vez, e como implementar isso na prática.',
     'v1', 'rascunho'),
    ('a4000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'Filas e brokers de mensagens',
     'Conceitos fundamentais de mensageria assíncrona: filas ponto-a-ponto, tópicos pub/sub, consumidores, e o papel de um broker como intermediário durável entre serviços.',
     'v1', 'rascunho'),
    ('a4000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'Garantias de entrega e ordenação',
     'As diferenças entre at-most-once, at-least-once e exactly-once, o que causa duplicidade e fora de ordem, e como dead-letter queues isolam mensagens problemáticas.',
     'v1', 'rascunho')
ON CONFLICT (domain_ref, titulo) DO NOTHING;

-- =====================================================================================
-- SLIDES (3 por Concept = 15)
-- =====================================================================================

-- Concept: Design de contratos REST
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a4000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'Recursos, não ações',
     'REST modela o mundo como recursos (substantivos) acessados por URLs, e usa os verbos HTTP (GET, POST, PUT, PATCH, DELETE) para expressar a ação sobre esse recurso. Em vez de `/criarPedido` ou `/getUsuario`, prefira `/pedidos` (POST para criar, GET para listar) e `/usuarios/{id}` (GET para buscar um específico). Essa convenção reduz o número de endpoints distintos que o cliente precisa memorizar, porque a semântica do verbo HTTP já carrega parte do significado da operação.',
     1, 'v1', 'rascunho'),
    ('a4000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'Códigos de status como contrato',
     'O código de status HTTP não é detalhe cosmético — é parte do contrato que o cliente programa contra. 200 (sucesso com corpo), 201 (recurso criado, geralmente com header Location), 204 (sucesso sem corpo, comum em DELETE), 400 (erro do cliente, ex.: payload inválido), 401/403 (autenticação/autorização), 404 (recurso inexistente), 409 (conflito, ex.: violação de unicidade) e 5xx (erro do servidor) formam um vocabulário que bibliotecas HTTP já sabem interpretar (retry automático em 5xx, mas não em 4xx, por exemplo). Retornar sempre 200 com um campo "erro" no corpo joga fora essa infraestrutura já existente no protocolo.',
     2, 'v1', 'rascunho'),
    ('a4000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'Paginação e filtros como parte do contrato',
     'Listar recursos sem paginação funciona em ambiente de teste e falha em produção quando a tabela cresce. Um contrato de listagem robusto define, desde o início, como o cliente pagina (ex.: `?page=2&size=20` ou paginação por cursor com `?cursor=abc123`), como filtra (`?status=ativo`) e como ordena (`?sort=criado_em,desc`). Cursor-based pagination é preferível a offset-based em coleções que mudam com frequência, porque evita itens pulados ou duplicados quando linhas são inseridas/removidas entre duas páginas consecutivas.',
     3, 'v1', 'rascunho');

-- Concept: Versionamento e evolução de APIs
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a4000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'Por que versionar',
     'Uma API com clientes externos (ou múltiplos times internos publicando/consumindo no seu próprio ritmo) não pode assumir que todo cliente é atualizado no mesmo instante que o servidor. Versionamento existe para permitir que o contrato evolua sem forçar todos os consumidores a migrar simultaneamente. O objetivo não é versionar por versionar, e sim dar tempo para uma migração controlada, com depreciação anunciada e prazo, em vez de uma mudança quebrando clientes em produção sem aviso.',
     1, 'v1', 'rascunho'),
    ('a4000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'Onde colocar a versão',
     'As três estratégias mais comuns são: versão na URL (`/v1/pedidos`, `/v2/pedidos`) — mais visível e fácil de rotear, mas "vaza" a versão para todo lugar que guarda a URL; versão em header customizado (`X-API-Version: 2`) ou no header `Accept` (content negotiation, ex.: `Accept: application/vnd.empresa.v2+json`) — mantém a URL estável, mas exige que o cliente configure o header corretamente, o que é mais fácil de esquecer. Nenhuma é universalmente "certa"; a escolha comum na indústria costuma pesar mais a simplicidade operacional de rotear por URL do que a "pureza" de manter a URL como identificador estável do recurso.',
     2, 'v1', 'rascunho'),
    ('a4000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'Mudanças compatíveis vs. quebras de contrato',
     'Nem toda mudança exige nova versão. Adicionar um campo novo e opcional na resposta, ou aceitar um campo novo e opcional na requisição, é geralmente uma mudança compatível (clientes bem escritos ignoram campos desconhecidos). Já remover um campo, renomear um campo, mudar o tipo de um campo (de string para número) ou tornar um campo antes opcional em obrigatório são mudanças que quebram contrato e exigem uma nova versão, ou pelo menos um período de transição em que ambos os formatos coexistem.',
     3, 'v1', 'rascunho');

-- Concept: Idempotência em APIs
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a4000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'O problema do retry às cegas',
     'Quando um cliente faz uma requisição e a rede falha antes da resposta chegar (timeout, conexão derrubada), o cliente não sabe se o servidor processou a operação ou não. A resposta ingênua — "tentar de novo" — é perigosa em operações com efeito colateral: reenviar um POST de criação de pedido pode criar dois pedidos idênticos, e reenviar uma cobrança pode cobrar o cliente duas vezes. Idempotência é a propriedade de uma operação que, executada múltiplas vezes com os mesmos parâmetros, produz o mesmo efeito de tê-la executado uma única vez.',
     1, 'v1', 'rascunho'),
    ('a4000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'Idempotência natural dos verbos HTTP',
     'GET, PUT e DELETE são idempotentes por definição do protocolo HTTP: repetir um GET não altera estado; repetir um PUT com o mesmo corpo substitui o recurso pelo mesmo valor de novo; repetir um DELETE do mesmo recurso deixa o sistema no mesmo estado final (já removido) mesmo que a segunda chamada retorne 404 em vez de 204. POST, por natureza, não é idempotente — cada POST bem-sucedido tipicamente cria um novo recurso, e é exatamente por isso que POST é o verbo que mais precisa de um mecanismo explícito de idempotência quando envolve criação de recursos sensíveis a duplicação (pagamentos, pedidos).',
     2, 'v1', 'rascunho'),
    ('a4000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'Chave de idempotência',
     'O padrão prático para tornar um POST seguro contra retry é a chave de idempotência (idempotency key): o cliente gera um identificador único (ex.: UUID) por tentativa lógica de operação e o envia em um header (ex.: `Idempotency-Key: <uuid>`). O servidor guarda, associado a essa chave, o resultado da primeira execução; se a mesma chave chegar de novo (retry do cliente), o servidor retorna a resposta já registrada em vez de reprocessar a operação. A chave precisa ser gerada pelo cliente antes da primeira tentativa (não a cada retry), e o servidor precisa persistir essa associação de forma atômica com a própria operação, geralmente numa mesma transação de banco, para evitar uma janela de corrida em que duas requisições concorrentes com a mesma chave processem a operação duas vezes.',
     3, 'v1', 'rascunho');

-- Concept: Filas e brokers de mensagens
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a4000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'Por que comunicação assíncrona',
     'Numa chamada síncrona (ex.: REST request/response), o serviço chamador fica bloqueado esperando o chamado responder, e ambos precisam estar disponíveis ao mesmo tempo. Mensageria assíncrona desacopla essa dependência temporal: o produtor publica uma mensagem e segue seu trabalho sem esperar o consumidor processá-la; o consumidor lê a mensagem quando estiver disponível, mesmo que isso seja segundos ou minutos depois. Isso é especialmente útil para operações que não precisam de resposta imediata (envio de e-mail, geração de relatório, atualização de índice de busca) e para absorver picos de carga sem derrubar o serviço consumidor.',
     1, 'v1', 'rascunho'),
    ('a4000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'Fila ponto-a-ponto vs. tópico pub/sub',
     'Numa fila ponto-a-ponto (queue), cada mensagem é entregue a exatamente um consumidor dentre um grupo de consumidores concorrentes — útil para distribuir trabalho (ex.: processar pedidos), onde cada pedido deve ser tratado uma única vez por algum worker. Num tópico pub/sub, cada mensagem publicada é entregue a todos os assinantes (subscribers) daquele tópico, cada um recebendo sua própria cópia — útil quando múltiplos serviços independentes precisam reagir ao mesmo evento (ex.: "pedido criado" disparando notificação, atualização de estoque e faturamento, cada um em um serviço diferente).',
     2, 'v1', 'rascunho'),
    ('a4000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'O papel do broker',
     'O broker (ex.: RabbitMQ, Apache Kafka, Amazon SQS) é o componente que recebe mensagens dos produtores, as armazena de forma durável (geralmente em disco, sobrevivendo a reinícios) e as entrega aos consumidores, resolvendo problemas que o produtor e o consumidor não deveriam resolver sozinhos: buffer entre velocidades de produção e consumo diferentes, redistribuição de carga entre múltiplos consumidores, e retenção de mensagens enquanto o consumidor está indisponível. Sem um broker, o produtor precisaria conhecer, contatar e esperar diretamente por cada consumidor — voltando ao acoplamento síncrono que a mensageria tenta evitar.',
     3, 'v1', 'rascunho');

-- Concept: Garantias de entrega e ordenação
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a4000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'At-most-once, at-least-once e exactly-once',
     'At-most-once entrega uma mensagem zero ou uma vez — nunca duplica, mas pode perder mensagens em caso de falha (o produtor ou o broker desiste após enviar, sem confirmar recebimento). At-least-once entrega uma mensagem uma ou mais vezes — nunca perde, mas pode duplicar quando o consumidor processa a mensagem e falha antes de confirmar (ack) ao broker, fazendo o broker reenviá-la a outro consumidor. Exactly-once (entrega exatamente uma vez, sem perda nem duplicação) é a garantia mais forte e mais cara de implementar de ponta a ponta; na prática, a maioria dos sistemas reais opera com at-least-once no transporte e obtém o efeito de "exactly-once" através de idempotência no processamento do consumidor, não do broker sozinho.',
     1, 'v1', 'rascunho'),
    ('a4000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'Ordenação de mensagens',
     'A maioria dos brokers só garante ordem dentro de uma partição/fila específica, não globalmente entre partições. Kafka, por exemplo, garante ordem de mensagens dentro de uma mesma partição, mas mensagens em partições diferentes podem ser consumidas fora de ordem relativa entre si. Por isso, quando a ordem importa para um conjunto de eventos relacionados (ex.: todos os eventos de um mesmo pedido), a prática comum é usar uma chave de particionamento (ex.: `pedido_id`) que garante que todas as mensagens daquele pedido caiam sempre na mesma partição, e portanto sejam consumidas na ordem em que foram produzidas.',
     2, 'v1', 'rascunho'),
    ('a4000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'Dead-letter queues (DLQ)',
     'Quando um consumidor falha repetidamente ao processar uma mensagem (erro de desserialização, exceção de negócio, dependência externa indisponível), reentregar essa mensagem indefinidamente trava a fila e pode bloquear o processamento de mensagens saudáveis atrás dela. Uma dead-letter queue é uma fila separada para onde o broker (ou o próprio consumidor) move mensagens que excederam um número máximo de tentativas de processamento, isolando-as do fluxo normal. Isso permite que o consumo principal continue avançando enquanto as mensagens "envenenadas" ficam disponíveis para inspeção manual, reprocessamento após correção do bug, ou descarte deliberado.',
     3, 'v1', 'rascunho');

-- =====================================================================================
-- FLASHCARDS (15, ~3 por Concept)
-- =====================================================================================

INSERT INTO flashcard (domain_ref, concept_ref, frente, verso, dificuldade, content_version, status_revisao)
VALUES
    ((SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'a4000000-0000-4000-8000-000000000001',
     'Em REST, o que deve ser modelado como URL: ações ou recursos?',
     'Recursos (substantivos), ex.: `/pedidos`. As ações são expressas pelo verbo HTTP (GET, POST, PUT, DELETE), não por um verbo na URL.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'a4000000-0000-4000-8000-000000000001',
     'Qual código de status HTTP é o mais adequado para uma criação de recurso bem-sucedida?',
     '201 Created, geralmente acompanhado do header Location apontando para o novo recurso.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'a4000000-0000-4000-8000-000000000001',
     'Por que paginação por cursor costuma ser preferível a paginação por offset em coleções que mudam com frequência?',
     'Porque offset-based pagination pode pular ou duplicar itens quando linhas são inseridas/removidas entre duas páginas consecutivas; cursor-based não sofre desse problema.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'a4000000-0000-4000-8000-000000000002',
     'Cite duas estratégias comuns de onde colocar a versão de uma API.',
     'Versão na URL (ex.: `/v1/pedidos`) e versão em header (ex.: `X-API-Version` ou content negotiation via `Accept`).',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'a4000000-0000-4000-8000-000000000002',
     'Adicionar um campo novo e opcional na resposta de uma API exige uma nova versão?',
     'Normalmente não — é considerada uma mudança compatível, desde que clientes bem escritos ignorem campos desconhecidos.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'a4000000-0000-4000-8000-000000000002',
     'Dê um exemplo de mudança que quebra contrato e normalmente exige nova versão de API.',
     'Remover um campo, renomear um campo, mudar o tipo de um campo, ou tornar um campo antes opcional em obrigatório.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'a4000000-0000-4000-8000-000000000003',
     'O que significa dizer que uma operação é idempotente?',
     'Executá-la múltiplas vezes com os mesmos parâmetros produz o mesmo efeito de executá-la uma única vez.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'a4000000-0000-4000-8000-000000000003',
     'Quais verbos HTTP são idempotentes por definição do protocolo?',
     'GET, PUT e DELETE. POST não é idempotente por natureza.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'a4000000-0000-4000-8000-000000000003',
     'Como funciona o padrão de chave de idempotência (idempotency key) para tornar um POST seguro contra retry?',
     'O cliente gera um identificador único por tentativa lógica e o envia em um header; o servidor guarda o resultado da primeira execução associado a essa chave e, em retries com a mesma chave, retorna a resposta já registrada em vez de reprocessar.',
     'dificil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'a4000000-0000-4000-8000-000000000004',
     'Qual a diferença entre uma fila ponto-a-ponto e um tópico pub/sub?',
     'Na fila ponto-a-ponto, cada mensagem vai para exatamente um consumidor de um grupo; no tópico pub/sub, cada mensagem é entregue a todos os assinantes do tópico.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'a4000000-0000-4000-8000-000000000004',
     'Qual problema um broker de mensagens resolve que a comunicação direta produtor-consumidor não resolveria sozinha?',
     'Buffer entre velocidades diferentes de produção e consumo, redistribuição de carga entre consumidores e retenção durável de mensagens enquanto o consumidor está indisponível.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'a4000000-0000-4000-8000-000000000005',
     'Qual a diferença entre at-least-once e at-most-once na entrega de mensagens?',
     'At-least-once nunca perde mensagens, mas pode duplicá-las; at-most-once nunca duplica, mas pode perder mensagens.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'a4000000-0000-4000-8000-000000000005',
     'Na prática, como a maioria dos sistemas obtém o efeito de "exactly-once" processing?',
     'Operando com at-least-once no transporte e aplicando idempotência no processamento do consumidor, em vez de depender do broker sozinho para garantir exactly-once de ponta a ponta.',
     'dificil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'a4000000-0000-4000-8000-000000000005',
     'Para que serve uma dead-letter queue (DLQ)?',
     'Isolar mensagens que falharam repetidamente no processamento, evitando que travem a fila principal, e permitindo inspeção, reprocessamento ou descarte manual posterior.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'a4000000-0000-4000-8000-000000000005',
     'Como um sistema costuma garantir ordenação de eventos relacionados (ex.: eventos de um mesmo pedido) num broker particionado como o Kafka?',
     'Usando uma chave de particionamento (ex.: pedido_id) que garante que todas as mensagens relacionadas caiam sempre na mesma partição, preservando a ordem de produção dentro dela.',
     'dificil', 'v1', 'rascunho');

-- =====================================================================================
-- QUESTIONS + ALTERNATIVAS (18: 6 facil, 6 media, 6 dificil)
-- =====================================================================================

-- Q1 (facil) — Design de contratos REST
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000001',
        'Em uma API REST, qual é a prática recomendada para representar recursos nas URLs?',
        'REST modela o mundo como recursos (substantivos), como `/pedidos` ou `/usuarios/{id}`. A ação sobre o recurso é expressa pelo verbo HTTP (GET, POST, PUT, DELETE), não por um verbo dentro da própria URL.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Usar substantivos que representam recursos, como /pedidos, e deixar a ação a cargo do verbo HTTP', true),
    ('Usar verbos na URL, como /criarPedido e /listarPedidos', false),
    ('Usar sempre o verbo HTTP POST para todas as operações, independente do efeito', false),
    ('Incluir o nome do banco de dados na URL para facilitar o roteamento', false)
) AS alt(texto, correta);

-- Q2 (facil) — Design de contratos REST
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000001',
        'Qual código de status HTTP é mais adequado para uma requisição que tentou criar um recurso já existente, violando uma regra de unicidade?',
        '409 Conflict é o código indicado para sinalizar que a requisição não pôde ser completada devido a um conflito com o estado atual do recurso, como uma violação de unicidade.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('200 OK', false),
    ('404 Not Found', false),
    ('409 Conflict', true),
    ('500 Internal Server Error', false)
) AS alt(texto, correta);

-- Q3 (facil) — Versionamento
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000002',
        'Qual é o principal objetivo de versionar uma API?',
        'Versionamento permite que o contrato evolua sem forçar todos os consumidores a migrar simultaneamente, dando tempo para uma transição controlada com depreciação anunciada.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Permitir que clientes migrem de forma controlada, sem serem forçados a atualizar no mesmo instante do servidor', true),
    ('Aumentar o número de servidores necessários para atender requisições', false),
    ('Eliminar a necessidade de documentação da API', false),
    ('Garantir que a API nunca precise de testes automatizados', false)
) AS alt(texto, correta);

-- Q4 (facil) — Idempotência
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000003',
        'O que caracteriza uma operação idempotente?',
        'Uma operação idempotente produz o mesmo efeito colateral independentemente de ser executada uma ou várias vezes com os mesmos parâmetros.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Executá-la múltiplas vezes com os mesmos parâmetros produz o mesmo efeito de executá-la uma única vez', true),
    ('Ela sempre retorna uma resposta diferente a cada chamada', false),
    ('Ela nunca pode ser usada em operações de criação de recursos', false),
    ('Ela só pode ser implementada usando o verbo GET', false)
) AS alt(texto, correta);

-- Q5 (facil) — Filas e brokers
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000004',
        'Em um modelo de tópico pub/sub, o que acontece quando uma mensagem é publicada e existem 3 assinantes (subscribers) diferentes inscritos no tópico?',
        'No modelo pub/sub, cada mensagem publicada é entregue a todos os assinantes do tópico, cada um recebendo sua própria cópia da mensagem.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('A mensagem é entregue a apenas um dos 3 assinantes, escolhido aleatoriamente', false),
    ('A mensagem é entregue a todos os 3 assinantes, cada um recebendo sua própria cópia', true),
    ('A mensagem é descartada, pois pub/sub exige exatamente 1 assinante', false),
    ('A mensagem é entregue apenas ao assinante que se inscreveu primeiro', false)
) AS alt(texto, correta);

-- Q6 (facil) — Garantias de entrega
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000005',
        'Qual garantia de entrega prioriza nunca perder uma mensagem, ao custo de possivelmente entregá-la mais de uma vez?',
        'At-least-once garante que a mensagem será entregue uma ou mais vezes, priorizando não perder a mensagem, o que pode causar duplicação quando o ack do consumidor falha após o processamento.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('At-most-once', false),
    ('At-least-once', true),
    ('Zero-delivery', false),
    ('Fire-and-forget garantido', false)
) AS alt(texto, correta);

-- Q7 (media) — Design de contratos REST
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000001',
        'Por que paginação baseada em cursor costuma ser preferível a paginação baseada em offset em coleções com escrita frequente?',
        'Paginação por offset pode pular ou duplicar itens quando linhas são inseridas ou removidas entre duas requisições de página consecutivas, porque a posição numérica de cada item muda; a paginação por cursor referencia um ponto estável na coleção e não sofre desse problema.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Porque cursor é sempre mais rápido de implementar no frontend', false),
    ('Porque offset-based pagination pode pular ou duplicar itens quando a coleção é alterada entre duas páginas consecutivas', true),
    ('Porque paginação por offset não é suportada pelo protocolo HTTP', false),
    ('Porque cursor elimina a necessidade de qualquer filtro na consulta', false)
) AS alt(texto, correta);

-- Q8 (media) — Design de contratos REST
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000001',
        'Por que usar corretamente os códigos de status HTTP (em vez de sempre retornar 200 com um campo de erro no corpo) é importante para os clientes de uma API?',
        'Bibliotecas HTTP e infraestrutura (proxies, gateways, clientes) já sabem interpretar códigos de status, por exemplo aplicando retry automático em respostas 5xx mas não em 4xx. Retornar sempre 200 descarta essa infraestrutura já existente no protocolo, obrigando o cliente a inspecionar o corpo para saber se houve erro.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Porque o corpo da resposta HTTP não pode conter informações de erro', false),
    ('Porque clientes e infraestrutura HTTP já interpretam códigos de status para decisões como retry automático, o que se perde se tudo retornar 200', true),
    ('Porque o protocolo HTTP exige que toda resposta de erro tenha corpo vazio', false),
    ('Porque usar 200 sempre é mais rápido para o servidor processar', false)
) AS alt(texto, correta);

-- Q9 (media) — Versionamento
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000002',
        'Qual das mudanças abaixo é considerada, em geral, uma mudança compatível que não exige nova versão de uma API?',
        'Adicionar um campo novo e opcional na resposta é tipicamente compatível, pois clientes bem escritos ignoram campos desconhecidos. Já remover, renomear, mudar o tipo de um campo, ou tornar um campo opcional em obrigatório costuma quebrar contrato.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Remover um campo que estava presente na resposta', false),
    ('Adicionar um campo novo e opcional na resposta', true),
    ('Renomear um campo já existente na resposta', false),
    ('Tornar obrigatório um campo que antes era opcional na requisição', false)
) AS alt(texto, correta);

-- Q10 (media) — Idempotência
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000003',
        'Dos verbos HTTP a seguir, qual NÃO é idempotente por definição do protocolo?',
        'POST tipicamente cria um novo recurso a cada chamada bem-sucedida, então repetir um POST pode criar múltiplos recursos. GET, PUT e DELETE são idempotentes por definição: repeti-los produz o mesmo estado final que executá-los uma vez.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('GET', false),
    ('PUT', false),
    ('POST', true),
    ('DELETE', false)
) AS alt(texto, correta);

-- Q11 (media) — Filas e brokers
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000004',
        'Qual problema um broker de mensagens resolve que a comunicação direta (síncrona) entre produtor e consumidor não resolveria por conta própria?',
        'O broker atua como intermediário durável: absorve diferenças de velocidade entre produção e consumo, redistribui carga entre múltiplos consumidores e retém mensagens enquanto o consumidor está indisponível, sem exigir que produtor e consumidor estejam disponíveis ao mesmo tempo.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Buffer entre velocidades diferentes de produção/consumo e retenção durável de mensagens enquanto o consumidor está indisponível', true),
    ('Eliminar totalmente a necessidade de tratamento de erros no consumidor', false),
    ('Garantir que o produtor sempre saiba o resultado exato do processamento de cada mensagem em tempo real', false),
    ('Substituir a necessidade de qualquer forma de autenticação entre serviços', false)
) AS alt(texto, correta);

-- Q12 (media) — Garantias de entrega
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000005',
        'Para que serve uma dead-letter queue (DLQ) em um sistema de mensageria?',
        'A DLQ isola mensagens que falharam repetidamente no processamento, evitando que fiquem travando a fila principal e bloqueando mensagens saudáveis atrás delas, permitindo inspeção e reprocessamento posterior.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Armazenar mensagens que falharam repetidamente no processamento, isolando-as do fluxo normal da fila principal', true),
    ('Aumentar a velocidade de processamento de mensagens bem-sucedidas', false),
    ('Substituir a necessidade de um broker de mensagens', false),
    ('Garantir ordenação global entre todas as partições de um tópico', false)
) AS alt(texto, correta);

-- Q13 (dificil) — Idempotência
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000003',
        'Ao implementar idempotência via chave de idempotência (idempotency key) em um endpoint de criação de pagamento, por que é importante persistir a chave e o resultado da operação na MESMA transação de banco que grava o pagamento?',
        'Se a chave for gravada em uma transação separada da operação de negócio, existe uma janela de corrida em que duas requisições concorrentes com a mesma chave podem passar pela checagem de "chave já existe" antes de qualquer uma delas terminar de persistir o resultado, levando ambas a processar o pagamento. Persistir na mesma transação garante atomicidade entre "registrar que essa chave foi processada" e o efeito colateral em si.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Porque transações separadas são sempre mais lentas de executar', false),
    ('Para evitar uma janela de corrida em que requisições concorrentes com a mesma chave processem a operação mais de uma vez antes que o resultado seja registrado', true),
    ('Porque o banco de dados não permite duas tabelas diferentes na mesma transação', false),
    ('Porque isso elimina a necessidade de o cliente gerar a chave de idempotência antes da primeira tentativa', false)
) AS alt(texto, correta);

-- Q14 (dificil) — Filas e brokers
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000004',
        'Um sistema usa uma fila ponto-a-ponto com múltiplos workers concorrentes consumindo a mesma fila para processar pedidos. Qual é a implicação direta desse modelo em relação à ordem de processamento dos pedidos?',
        'Como diferentes workers processam mensagens em paralelo e em velocidades potencialmente diferentes, a ordem de conclusão do processamento não é garantida, mesmo que a ordem de chegada na fila seja preservada. Se ordem estrita for necessária, é preciso ou usar um único consumidor, ou particionar por uma chave que agrupe mensagens relacionadas no mesmo worker.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('A ordem de processamento entre pedidos distintos não é garantida, mesmo que a ordem de chegada na fila seja preservada', true),
    ('A fila garante automaticamente que os pedidos sejam processados na ordem exata de chegada, independentemente do número de workers', false),
    ('Múltiplos workers concorrentes tornam a fila incapaz de garantir at-least-once delivery', false),
    ('Esse modelo elimina a necessidade de qualquer mecanismo de ack entre worker e broker', false)
) AS alt(texto, correta);

-- Q15 (dificil) — Garantias de entrega
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000005',
        'Por que a maioria dos sistemas reais que precisam de semântica "exactly-once" implementa isso combinando at-least-once no transporte com idempotência no consumidor, em vez de depender de um broker que prometa exactly-once nativo de ponta a ponta?',
        'Garantir exactly-once verdadeiro de ponta a ponta (produtor → broker → consumidor → efeito colateral externo) exigiria coordenação transacional distribuída entre sistemas que frequentemente não compartilham a mesma transação (ex.: broker e banco de dados do consumidor), o que é caro e complexo. Na prática, é mais simples aceitar que mensagens podem ser duplicadas no transporte (at-least-once) e tornar o processamento do consumidor idempotente, obtendo o mesmo efeito observável de exactly-once sem a complexidade de uma garantia nativa fim a fim.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Porque brokers modernos não conseguem armazenar mensagens de forma durável', false),
    ('Porque garantir exactly-once nativo fim a fim exigiria coordenação transacional cara entre sistemas independentes; é mais simples aceitar duplicação no transporte e tornar o consumidor idempotente', true),
    ('Porque at-least-once é o único modo suportado pelo protocolo HTTP', false),
    ('Porque idempotência no consumidor substitui a necessidade de qualquer confirmação (ack) ao broker', false)
) AS alt(texto, correta);

-- Q16 (dificil) — Versionamento
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000002',
        'Uma equipe decide versionar sua API usando content negotiation via header Accept (ex.: Accept: application/vnd.empresa.v2+json) em vez de versionar na URL. Qual é uma desvantagem prática dessa escolha em comparação a versionar na URL?',
        'Versionar via header mantém a URL do recurso estável entre versões, o que é conceitualmente mais alinhado a REST, mas exige que todo cliente configure corretamente o header em cada requisição — algo mais fácil de esquecer, mais difícil de testar manualmente em um navegador, e mais difícil de rotear em alguns proxies/gateways que decidem a rota olhando só a URL.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Exige que o cliente configure corretamente o header em toda requisição, o que é mais fácil de esquecer e mais difícil de rotear em alguns proxies baseados só na URL', true),
    ('Torna impossível ter mais de duas versões da API simultaneamente', false),
    ('Impede o uso do verbo HTTP GET em qualquer endpoint versionado dessa forma', false),
    ('É proibido pelo protocolo HTTP para APIs REST', false)
) AS alt(texto, correta);

-- Q17 (dificil) — Design de contratos REST
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000001',
        'Um endpoint de listagem `/pedidos` usa paginação por offset (`?page=N&size=20`) e um cliente está percorrendo todas as páginas enquanto novos pedidos são inseridos continuamente no topo da listagem (ordenada por mais recente primeiro). Qual efeito colateral concreto esse cliente pode observar?',
        'Como cada nova inserção desloca a posição (offset) de todos os itens mais antigos, um item que estava na posição 21 (início da página 2) pode ser empurrado para a posição 22 antes de o cliente pedir a página 2, fazendo esse item aparecer duas vezes (uma vez no fim da página 1, se já tiver sido lido antes do deslocamento, e de novo no início da página 2) ou, dependendo do padrão de inserção, ser pulado inteiramente.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('O cliente pode ver itens duplicados entre páginas ou itens pulados, porque novas inserções deslocam a posição (offset) dos itens já existentes', true),
    ('O servidor rejeita automaticamente a paginação com código 409 Conflict quando há inserções concorrentes', false),
    ('A API para de responder até que todas as inserções concorrentes terminem', false),
    ('Não há nenhum efeito observável, pois paginação por offset é imune a inserções concorrentes', false)
) AS alt(texto, correta);

-- Q18 (dificil) — Filas e brokers / Garantias de entrega (integração)
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000004',
        'Um consumidor lê uma mensagem de uma fila at-least-once, processa a operação de negócio com sucesso (ex.: debita saldo de uma conta), mas falha ao enviar o ack ao broker antes de travar. O que acontece em seguida e como o sistema deve se proteger do efeito colateral disso?',
        'Como o broker nunca recebeu o ack, ele considera a mensagem não processada e a reentrega (a um novo consumidor ou ao mesmo após reiniciar), mesmo que o débito já tenha ocorrido de fato. Sem proteção adicional, isso causaria um débito duplicado. A defesa correta não é tentar eliminar a duplicação no transporte (que é o comportamento esperado de at-least-once), e sim tornar o processamento do consumidor idempotente, por exemplo registrando o identificador da mensagem já processada e ignorando reprocessamentos da mesma mensagem.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('O broker reentrega a mensagem por não ter recebido o ack, podendo causar reprocessamento; a defesa correta é tornar o consumidor idempotente, não tentar evitar a reentrega em si', true),
    ('O broker descarta a mensagem definitivamente, pois já foi processada uma vez, mesmo sem ack', false),
    ('A ausência de ack faz o broker promover automaticamente a mensagem para exactly-once', false),
    ('O sistema deve trocar o broker por um banco de dados relacional para resolver esse problema', false)
) AS alt(texto, correta);
