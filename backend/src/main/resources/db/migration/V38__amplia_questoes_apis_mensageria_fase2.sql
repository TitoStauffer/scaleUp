-- Ampliação do pool de Questions do domínio APIs/Mensageria (Fase 2 — Ticket
-- TICKET-content-expansion-questoes-fase2.md), somando 18 Questions novas às 36 já
-- existentes em V17__seed_conteudo_apis_mensageria.sql (18) e
-- V29__amplia_questoes_apis_mensageria.sql (18) — total: 54 no domínio.
-- content_version = 'v1' e status_revisao = 'rascunho', mesma regra dos lotes anteriores
-- (autoria assistida por IA, revisão humana ainda não realizada).
-- Este arquivo NUNCA insere em domain, concept, slide ou flashcard — apenas
-- Question + suas 4 alternativas, reaproveitando os 5 Concepts já semeados em V17
-- (UUIDs a4000000-0000-4000-8000-000000000001 a ...05) e o Domain já semeado em V13
-- (via subquery por slug 'apis-mensageria'). concept_ref fica NULL nas questões cujo
-- ponto testado (gRPC, GraphQL, webhooks) não corresponde com precisão a nenhum dos 5
-- Concepts existentes, em vez de forçar uma associação imprecisa (concept_ref é
-- recomendado, não obrigatório, conforme ticket mestre).
-- Enunciados abaixo foram conferidos um a um contra os 36 já existentes em V17 e V29
-- para garantir que nenhum repete, literal ou disfarçadamente, o mesmo ponto testado.

-- =====================================================================================
-- QUESTIONS + ALTERNATIVAS (18 novas: 6 facil, 6 media, 6 dificil)
-- =====================================================================================

-- Q37 (facil) — Design de contratos REST — métodos seguros (safe methods)
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000001',
        'O que caracteriza um método HTTP como "seguro" (safe), no vocabulário da especificação HTTP?',
        'Um método seguro é aquele que não deve produzir nenhum efeito colateral observável no servidor, servindo apenas para recuperar informação. GET é o exemplo clássico: um proxy ou cache pode reexecutá-lo livremente sem se preocupar em alterar o estado do sistema. Isso é diferente de idempotência: PUT e DELETE são idempotentes, mas não são seguros, pois alteram o estado do servidor.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Não produzir nenhum efeito colateral observável no servidor, servindo apenas para recuperar dados', true),
    ('Sempre exigir autenticação por token antes de ser executado', false),
    ('Nunca poder ser cacheado por proxies ou CDNs', false),
    ('Ser executado exclusivamente sobre conexões criptografadas (HTTPS)', false)
) AS alt(texto, correta);

-- Q38 (facil) — gRPC — contrato via Protocol Buffers e HTTP/2
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        NULL,
        'O que é gRPC e como ele costuma se diferenciar de uma API REST tradicional em termos de formato de contrato e transporte?',
        'gRPC é um framework de chamada remota (RPC) que define contratos em arquivos `.proto` (Protocol Buffers), um formato binário e fortemente tipado, e transporta as chamadas sobre HTTP/2. Isso contrasta com REST, que tipicamente usa JSON textual sobre HTTP/1.1, sem um schema de contrato obrigatório embutido no protocolo.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Define contratos em arquivos .proto (Protocol Buffers), um formato binário tipado, e transporta chamadas sobre HTTP/2', true),
    ('É uma extensão do protocolo SMTP usada exclusivamente para troca de e-mails entre serviços', false),
    ('Substitui totalmente a necessidade de um endereço de rede entre cliente e servidor', false),
    ('É um formato de banco de dados usado para armazenar filas de mensagens em disco', false)
) AS alt(texto, correta);

-- Q39 (facil) — GraphQL — cliente especifica os campos desejados
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        NULL,
        'Em uma API GraphQL, como o cliente controla exatamente quais campos de um recurso deseja receber na resposta?',
        'Em GraphQL, o cliente escreve uma query declarando exatamente os campos que quer, e o servidor retorna uma resposta com apenas esses campos, evitando tanto over-fetching (receber campos que não serão usados) quanto under-fetching (precisar de uma segunda chamada para completar os dados), problemas comuns em endpoints REST de formato fixo.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Declarando, na própria query, exatamente os campos desejados, e o servidor responde só com eles', true),
    ('O cliente não tem esse controle; o servidor sempre retorna o objeto completo do recurso', false),
    ('Configurando um header HTTP customizado que lista os campos, exatamente como em REST', false),
    ('Criando uma nova versão da API para cada combinação diferente de campos necessários', false)
) AS alt(texto, correta);

-- Q40 (facil) — Webhooks — inversão de controle vs polling
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        NULL,
        'O que é um webhook e em que ele difere de um cliente que faz polling periódico (ex.: chamar a API a cada 30 segundos) para saber se algo mudou?',
        'Um webhook inverte o controle: o cliente registra previamente uma URL de callback, e é o servidor quem faz uma requisição HTTP para essa URL no momento em que o evento de interesse ocorre. Isso elimina o desperdício de chamadas repetidas do polling (a maioria delas retornando "nada mudou") e reduz a latência entre o evento acontecer e o cliente ser notificado.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('No webhook, o servidor chama uma URL de callback registrada pelo cliente assim que o evento ocorre, em vez do cliente perguntar repetidamente se algo mudou', true),
    ('Webhook e polling são termos sinônimos para a mesma técnica de sincronização', false),
    ('No webhook, o cliente precisa manter uma conexão TCP permanentemente aberta com o servidor', false),
    ('Webhook só pode ser usado para notificações de erro, nunca para eventos de sucesso', false)
) AS alt(texto, correta);

-- Q41 (facil) — Rate limiting — 429 Too Many Requests
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000001',
        'Qual código de status HTTP uma API deve retornar quando um cliente excede o limite de requisições permitido em um intervalo de tempo (rate limiting)?',
        '429 Too Many Requests é o código dedicado a sinalizar que o cliente excedeu a cota de requisições permitida, geralmente acompanhado do header `Retry-After`, indicando quanto tempo o cliente deve esperar antes de tentar novamente.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('400 Bad Request', false),
    ('429 Too Many Requests', true),
    ('503 Service Unavailable', false),
    ('204 No Content', false)
) AS alt(texto, correta);

-- Q42 (facil) — Filas e brokers — modelo de consumer group (Kafka)
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000004',
        'Em um broker como o Kafka, o que acontece quando duas aplicações diferentes assinam o mesmo tópico, cada uma usando um `consumer group` próprio, e um terceiro consumidor entra no mesmo grupo de uma delas?',
        'Cada consumer group recebe sua própria cópia completa de cada mensagem publicada no tópico (comportamento equivalente a pub/sub entre grupos). Dentro de um mesmo grupo, porém, cada mensagem é entregue a apenas um dos consumidores daquele grupo (comportamento equivalente a uma fila ponto-a-ponto). Por isso, adicionar um consumidor ao mesmo grupo distribui a carga entre eles, sem duplicar o processamento dentro do grupo.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Cada consumer group recebe sua própria cópia da mensagem; dentro de um mesmo grupo, apenas um consumidor processa cada mensagem', true),
    ('Todas as mensagens são entregues apenas ao consumer group criado primeiro, e os demais ficam ociosos', false),
    ('Adicionar um consumidor a um grupo existente faz cada mensagem ser processada duas vezes dentro daquele grupo', false),
    ('Consumer groups servem apenas para autenticação, sem nenhum efeito sobre a distribuição de mensagens', false)
) AS alt(texto, correta);

-- Q43 (media) — Design de contratos REST — HATEOAS
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000001',
        'O que propõe o princípio HATEOAS (Hypermedia as the Engine of Application State) aplicado a uma API REST?',
        'HATEOAS propõe que a resposta de um recurso inclua links descrevendo as ações/transições possíveis a partir daquele estado (ex.: um pedido "pendente" traz um link para "cancelar"), permitindo que o cliente navegue pela API descobrindo dinamicamente o que pode fazer em seguida, em vez de ter essas URLs e regras de transição hardcoded de antemão.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Incluir na resposta links que descrevem as ações/transições possíveis a partir do estado atual do recurso', true),
    ('Armazenar o estado completo da sessão do cliente no servidor entre requisições', false),
    ('Exigir que toda API REST seja versionada obrigatoriamente na URL', false),
    ('Substituir o uso de códigos de status HTTP por mensagens de erro em texto livre', false)
) AS alt(texto, correta);

-- Q44 (media) — gRPC — tipagem forte e geração de código
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        NULL,
        'Qual vantagem prática o contrato fortemente tipado do gRPC (definido em `.proto`) oferece em relação a uma API REST/JSON sem schema formal obrigatório?',
        'Como o contrato é definido em `.proto` e usado para gerar automaticamente código cliente e servidor (stubs) em cada linguagem, incompatibilidades de tipo ou de campo entre as partes tendem a ser detectadas em tempo de compilação/geração de código, antes de chegar a produção — diferente de um contrato REST/JSON informal, em que divergências de schema só aparecem em tempo de execução, quando uma chamada real falha ou retorna dado inesperado.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Incompatibilidades de contrato tendem a ser detectadas na geração de código/compilação, antes de chegar a produção', true),
    ('O gRPC elimina completamente a necessidade de versionar contratos entre serviços', false),
    ('O gRPC torna desnecessário qualquer teste de integração entre cliente e servidor', false),
    ('O gRPC garante automaticamente que todas as chamadas sejam idempotentes', false)
) AS alt(texto, correta);

-- Q45 (media) — GraphQL — problema de N+1 queries
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        NULL,
        'Uma query GraphQL pede uma lista de 50 pedidos, cada um trazendo o nome do cliente associado. Se o resolver de "cliente" fizer uma consulta ao banco separada para cada pedido, individualmente, que problema de desempenho isso caracteriza?',
        'Esse é o clássico problema de N+1 queries: 1 consulta para buscar a lista de pedidos, mais N consultas adicionais (uma por pedido) para resolver o campo aninhado "cliente", resultando em 51 consultas ao banco em vez de, idealmente, 2 (uma para os pedidos, outra buscando todos os clientes envolvidos de uma vez, ex.: com um `IN`). Técnicas como batching/dataloader existem justamente para agrupar essas resoluções aninhadas.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('O problema de N+1 queries: uma consulta para a lista, mais uma consulta adicional por item para resolver o campo aninhado', true),
    ('Um deadlock de banco de dados causado exclusivamente pelo uso de GraphQL', false),
    ('Uma violação do princípio de idempotência, pois a mesma query é executada mais de uma vez', false),
    ('Um erro de versionamento de schema, pois o campo "cliente" não deveria existir na query', false)
) AS alt(texto, correta);

-- Q46 (media) — Filas e brokers — outbox pattern
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000004',
        'Um serviço grava um pedido no banco de dados e, em seguida, publica uma mensagem "pedido criado" no broker. Qual problema o padrão outbox resolve nesse cenário, e como?',
        'Gravar no banco e publicar no broker são duas operações contra sistemas diferentes, que não compartilham uma transação atômica: o processo pode cair entre as duas, causando um pedido salvo sem mensagem publicada (ou vice-versa) — o chamado "dual-write problem". O padrão outbox resolve isso gravando o evento em uma tabela outbox na MESMA transação do banco que grava o pedido, e um processo separado (ex.: um poller ou CDC) lê essa tabela depois e publica no broker de forma confiável, garantindo que a publicação só "perca" caso a própria escrita no banco também tenha revertido.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('O dual-write problem: gravar no banco e publicar no broker são operações não atômicas entre si; o outbox grava o evento na mesma transação do banco e publica depois de forma confiável', true),
    ('O outbox elimina totalmente a necessidade de um broker de mensagens no sistema', false),
    ('O outbox garante que o consumidor da mensagem nunca precise ser idempotente', false),
    ('O outbox serve apenas para criptografar mensagens antes de publicá-las no broker', false)
) AS alt(texto, correta);

-- Q47 (media) — Idempotência — idempotente vs seguro (PUT)
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000003',
        'PUT é considerado idempotente, mas não é considerado um método "seguro" (safe). Como essas duas propriedades diferem nesse caso?',
        'Idempotência diz respeito ao efeito de repetir a chamada: repetir o mesmo PUT várias vezes resulta no mesmo estado final que executá-lo uma única vez. Já "seguro" significa não ter efeito colateral algum. PUT altera o estado do servidor (substitui o recurso) mesmo na primeira chamada, então não é seguro — apesar de ser idempotente, porque repetir a mesma substituição não muda o resultado final além do que já ocorreu na primeira vez.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Idempotência trata do efeito de repetir a chamada (mesmo estado final); seguro trata de não ter efeito colateral algum, o que PUT não satisfaz por alterar o recurso', true),
    ('Não há diferença real; os dois termos descrevem exatamente a mesma propriedade', false),
    ('PUT só é considerado idempotente quando usado junto com uma chave de idempotência no header', false),
    ('Um método só pode ser idempotente se também for seguro, então a premissa da pergunta está incorreta', false)
) AS alt(texto, correta);

-- Q48 (media) — Filas e brokers — evolução de schema de mensagens
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000004',
        'Um produtor precisa adicionar um novo campo ao formato das mensagens que publica em um tópico, mas alguns consumidores ainda não foram atualizados para reconhecer esse campo. Qual prática de evolução de schema evita quebrar esses consumidores mais antigos?',
        'Adicionar o campo como opcional (aditivo), sem remover ou alterar o tipo de campos existentes, mantém compatibilidade retroativa: consumidores antigos simplesmente ignoram o campo novo que não reconhecem, enquanto consumidores atualizados já podem consumi-lo. Isso evita a necessidade de coordenar um deploy simultâneo entre produtor e todos os consumidores.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Adicionar o campo novo como opcional, sem remover ou alterar campos existentes, mantendo compatibilidade com consumidores antigos', true),
    ('Remover todos os campos antigos da mensagem para simplificar o schema imediatamente', false),
    ('Publicar as mensagens em dois formatos totalmente incompatíveis simultaneamente, sem nenhuma relação entre eles', false),
    ('Exigir que todos os consumidores façam deploy no mesmo instante exato em que o produtor muda o formato', false)
) AS alt(texto, correta);

-- Q49 (dificil) — gRPC — streaming bidirecional
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        NULL,
        'Diferente do modelo request/response de uma chamada REST comum, o gRPC suporta streaming bidirecional. O que isso significa, e que tipo de cenário se beneficia dele?',
        'Streaming bidirecional permite que cliente e servidor troquem múltiplas mensagens continuamente sobre a mesma conexão HTTP/2 aberta, em qualquer ordem, sem que cada mensagem precise esperar uma resposta completa antes de enviar a próxima. Isso beneficia cenários como chat em tempo real, telemetria contínua de sensores ou colaboração ao vivo, em que ambas as partes precisam enviar e receber dados continuamente, algo que forçaria REST a recorrer a polling ou WebSockets separados.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Cliente e servidor trocam múltiplas mensagens continuamente sobre a mesma conexão, útil para cenários como chat em tempo real ou telemetria contínua', true),
    ('Significa que cada chamada gRPC precisa ser repetida duas vezes, uma para cada direção da comunicação', false),
    ('É um mecanismo que substitui integralmente a necessidade de definir um contrato .proto', false),
    ('Refere-se à capacidade de duplicar automaticamente cada mensagem para dois consumidores distintos', false)
) AS alt(texto, correta);

-- Q50 (dificil) — GraphQL — ataque de profundidade/complexidade de query
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        NULL,
        'Por que uma API GraphQL exposta sem nenhum limite de profundidade ou de complexidade de query é vulnerável a um tipo de ataque de negação de serviço que não existe da mesma forma em endpoints REST de formato fixo?',
        'Como o cliente monta livremente a query, incluindo aninhamentos profundos entre entidades relacionadas (ex.: pedido → cliente → outros pedidos → itens → ...), um cliente malicioso pode construir uma única query artificialmente profunda ou complexa que força o servidor a executar um número explosivo de resoluções internas, consumindo CPU/memória desproporcionalmente a uma única requisição HTTP. Limitar profundidade máxima e calcular um "custo" estimado da query antes de executá-la são mitigações comuns, algo que não é necessário em REST porque cada endpoint já tem uma forma de resposta fixa e previsível.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Porque o cliente monta livremente a query, podendo criar aninhamentos profundos que forçam um número explosivo de resoluções internas em uma única requisição', true),
    ('Porque toda API GraphQL é obrigatoriamente pública e não pode exigir autenticação', false),
    ('Porque o protocolo GraphQL não roda sobre HTTP e por isso ignora qualquer rate limiting', false),
    ('Porque GraphQL não permite paginação, forçando sempre o retorno da coleção inteira', false)
) AS alt(texto, correta);

-- Q51 (dificil) — gRPC — propagação de deadlines
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        NULL,
        'O serviço A chama o serviço B via gRPC com um deadline de 2 segundos; B, por sua vez, chama o serviço C para completar o pedido de A. Por que é importante que B propague ao C um deadline coerente com o tempo restante do deadline original de A, em vez de usar um deadline fixo e independente para a chamada a C?',
        'Se B ignorar o deadline de A e usar, por exemplo, um deadline fixo de 5 segundos para chamar C, B pode continuar esperando a resposta de C mesmo depois que o deadline de A já expirou — desperdiçando trabalho em uma cadeia de chamadas cujo resultado final já não será mais aproveitado por A (que já desistiu ou tratou a chamada como falha). Propagar o tempo restante evita esse desperdício em cascata: cada salto na cadeia respeita o orçamento de tempo real que ainda resta até o deadline original.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Para evitar que B continue trabalhando em uma chamada a C cujo resultado já não será aproveitado, pois o deadline original de A já teria expirado', true),
    ('Porque o protocolo gRPC rejeita automaticamente qualquer chamada que não use exatamente o mesmo valor de deadline em toda a cadeia', false),
    ('Porque deadlines em gRPC só podem ser definidos uma única vez, na primeira chamada da cadeia inteira', false),
    ('Porque isso é obrigatório apenas quando as chamadas usam streaming bidirecional, nunca em chamadas unárias', false)
) AS alt(texto, correta);

-- Q52 (dificil) — Garantias de entrega — saga pattern
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000005',
        'Uma operação de negócio (ex.: fechar um pedido) precisa coordenar mudanças de estado em três serviços diferentes, cada um com seu próprio banco de dados, comunicando-se por eventos assíncronos. Não existe uma transação distribuída que garanta tudo-ou-nada entre eles. Qual padrão trata esse cenário, e como ele lida com uma falha no meio do fluxo?',
        'O padrão saga coordena a operação como uma sequência de passos locais, cada um publicando um evento que dispara o próximo passo em outro serviço. Se um passo falhar depois que passos anteriores já foram aplicados, a saga executa transações compensatórias — ações que revertem o efeito dos passos já concluídos (ex.: estornar um pagamento já debitado) — em vez de depender de um rollback distribuído atômico, que não existe nesse cenário.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('O padrão saga, que trata falhas no meio do fluxo executando transações compensatórias que revertem o efeito dos passos já concluídos', true),
    ('O padrão outbox, que impede que qualquer um dos três serviços processe o evento mais de uma vez', false),
    ('A chave de idempotência, que sozinha garante que os três bancos de dados fiquem sempre consistentes entre si', false),
    ('O padrão dead-letter queue, que reverte automaticamente mudanças já persistidas nos bancos de dados envolvidos', false)
) AS alt(texto, correta);

-- Q53 (dificil) — Rate limiting — fixed window vs token bucket
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000001',
        'Um rate limiter implementado com o algoritmo de "janela fixa" (fixed window) permite 100 requisições por minuto. Por que um cliente pode, na prática, conseguir enviar até quase 200 requisições em um intervalo de 2 segundos ao redor da virada de um minuto para o outro, e como o algoritmo de token bucket evita esse problema?',
        'Na janela fixa, o contador zera exatamente no início de cada minuto. Um cliente pode enviar 100 requisições nos últimos instantes de uma janela e outras 100 nos primeiros instantes da janela seguinte, totalizando quase 200 requisições em poucos segundos ao redor da virada, mesmo respeitando o limite de cada janela isoladamente. O token bucket evita esse efeito de rajada na borda porque os tokens são repostos continuamente a uma taxa constante, e não "resetados" em blocos de tempo fixos, suavizando o limite ao longo do tempo em vez de por janela discreta.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Porque a janela fixa zera o contador em blocos de tempo discretos, permitindo rajadas na borda entre janelas; token bucket repõe tokens continuamente, suavizando o limite', true),
    ('Porque a janela fixa não é compatível com o código de status 429, então nenhuma requisição extra é sequer contabilizada', false),
    ('Porque token bucket elimina totalmente qualquer limite de requisições após a primeira rajada', false),
    ('Porque janela fixa e token bucket produzem exatamente o mesmo comportamento, sem diferença prática entre eles', false)
) AS alt(texto, correta);

-- Q54 (dificil) — Filas e brokers — rebalanceamento de consumer group
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000004',
        'Em um consumer group do Kafka, o que ocorre quando um dos consumidores trava inesperadamente ou um novo consumidor entra no grupo, e por que esse evento pode causar uma pausa temporária no processamento de mensagens?',
        'Esse evento dispara um rebalanceamento: o broker redistribui as partições do tópico entre os consumidores restantes (ou entre todos, incluindo o novo). Durante o rebalanceamento, o consumo é temporariamente pausado enquanto as novas atribuições de partição são calculadas e comunicadas, porque nenhum consumidor deve processar uma partição que está no meio da reatribuição — evitando que duas instâncias processem a mesma partição simultaneamente por um instante.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Um rebalanceamento: as partições são redistribuídas entre os consumidores do grupo, pausando temporariamente o consumo até a nova atribuição ser concluída', true),
    ('O tópico inteiro é apagado e recriado automaticamente pelo broker para evitar inconsistência', false),
    ('Todas as mensagens já consumidas anteriormente são reenviadas do zero para o novo consumidor, duplicando todo o histórico', false),
    ('O grupo é dissolvido permanentemente e um novo grupo precisa ser criado manualmente pelo time responsável', false)
) AS alt(texto, correta);
