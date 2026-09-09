-- Ampliação do pool de Questions do domínio APIs/Mensageria (Fase 1 — Ticket
-- TICKET-content-expansion-questoes.md), somando 18 Questions novas às 18 já
-- existentes em V17__seed_conteudo_apis_mensageria.sql (total: 36 no domínio).
-- content_version = 'v1' e status_revisao = 'rascunho', mesma regra do lote original
-- (autoria assistida por IA, revisão humana ainda não realizada).
-- Este arquivo NUNCA insere em domain, concept, slide ou flashcard — apenas
-- Question + suas 4 alternativas, reaproveitando os 5 Concepts já semeados em V17
-- (UUIDs a4000000-0000-4000-8000-000000000001 a ...05) e o Domain já semeado em V13
-- (via subquery por slug 'apis-mensageria').
-- Enunciados abaixo foram conferidos um a um contra os 18 já existentes em V17 para
-- garantir que nenhum repete, literal ou disfarçadamente, o mesmo ponto testado.

-- =====================================================================================
-- QUESTIONS + ALTERNATIVAS (18 novas: 6 facil, 6 media, 6 dificil)
-- =====================================================================================

-- Q19 (facil) — Design de contratos REST — PUT vs PATCH
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000001',
        'Qual é a diferença fundamental entre os verbos PUT e PATCH em uma API REST?',
        'PUT substitui o recurso inteiro pelo conteúdo enviado; PATCH aplica uma modificação parcial, alterando apenas os campos informados, mantendo os demais inalterados.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('PUT substitui o recurso inteiro; PATCH aplica uma modificação parcial sobre ele', true),
    ('Os dois verbos são sinônimos e podem ser usados de forma intercambiável em qualquer API', false),
    ('PATCH sempre remove o recurso antes de recriá-lo; PUT nunca altera o estado do servidor', false),
    ('PUT é usado apenas para leitura; PATCH é usado apenas para criação de recursos novos', false)
) AS alt(texto, correta);

-- Q20 (facil) — Design de contratos REST — header Location
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000001',
        'Qual é a finalidade do header `Location` retornado em uma resposta 201 Created?',
        'O header Location informa ao cliente a URL do recurso recém-criado, permitindo que ele acesse esse recurso diretamente em requisições futuras sem precisar descobrir o identificador de outra forma.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Indicar a URL onde o recurso recém-criado pode ser acessado', true),
    ('Informar o fuso horário do servidor que processou a requisição', false),
    ('Redirecionar automaticamente o navegador para a página de login', false),
    ('Definir o tempo máximo de cache da resposta em segundos', false)
) AS alt(texto, correta);

-- Q21 (facil) — Versionamento — depreciação
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000002',
        'O que significa, na prática, "depreciar" (deprecate) uma versão de API antes de removê-la?',
        'Depreciar significa sinalizar formalmente aos clientes que aquela versão será desativada em uma data futura, dando tempo para que migrem para a versão nova antes da remoção efetiva, em vez de removê-la sem aviso.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Remover a versão antiga imediatamente, sem aviso prévio aos clientes', false),
    ('Sinalizar aos clientes que a versão será desativada em uma data futura, dando tempo para migração', true),
    ('Renomear a versão antiga para que os clientes não a encontrem mais', false),
    ('Bloquear qualquer nova requisição à API até que todos os clientes migrem', false)
) AS alt(texto, correta);

-- Q22 (facil) — Idempotência — DELETE repetido
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000003',
        'Por que uma segunda chamada DELETE ao mesmo recurso, já removido pela primeira chamada, ainda é considerada idempotente, mesmo retornando 404 em vez de 204?',
        'Idempotência se refere ao estado final do sistema, não ao código de status retornado. Depois da primeira ou da segunda chamada, o recurso está igualmente ausente — o efeito é o mesmo, mesmo que a representação da resposta (404 vs 204) mude.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Porque o estado final do sistema (recurso ausente) é o mesmo, independentemente do código de status retornado', true),
    ('Porque o servidor sempre retorna 204 em qualquer chamada DELETE, nunca 404', false),
    ('Porque DELETE não é considerado idempotente pelo protocolo HTTP', false),
    ('Porque a segunda chamada recria o recurso automaticamente antes de removê-lo de novo', false)
) AS alt(texto, correta);

-- Q23 (facil) — Filas e brokers — consumidores concorrentes
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000004',
        'Qual é a principal vantagem de ter múltiplos consumidores concorrentes (competing consumers) lendo da mesma fila ponto-a-ponto?',
        'Distribuir as mensagens entre vários workers em paralelo aumenta a capacidade de processamento (throughput) da fila, permitindo absorver um volume maior de mensagens no mesmo intervalo de tempo.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Aumentar a capacidade de processamento (throughput), distribuindo as mensagens entre os workers', true),
    ('Garantir ordenação total entre todas as mensagens processadas', false),
    ('Eliminar a necessidade de qualquer confirmação (ack) por parte dos consumidores', false),
    ('Transformar automaticamente a fila em um tópico pub/sub', false)
) AS alt(texto, correta);

-- Q24 (facil) — Garantias de entrega — at-most-once
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000005',
        'O que caracteriza a garantia de entrega "at-most-once" em um sistema de mensageria?',
        'At-most-once entrega uma mensagem zero ou uma vez: nunca duplica, mas pode perdê-la se o produtor ou o broker desistirem sem confirmação de recebimento.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('A mensagem é entregue no máximo uma vez, podendo ser perdida, mas nunca duplicada', true),
    ('A mensagem é sempre entregue pelo menos duas vezes, para garantir segurança', false),
    ('A mensagem nunca é perdida nem duplicada, sob nenhuma circunstância', false),
    ('A mensagem é entregue apenas quando o consumidor solicita explicitamente um reenvio', false)
) AS alt(texto, correta);

-- Q25 (media) — Design de contratos REST — 401 vs 403
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000001',
        'Qual é a diferença entre os códigos de status HTTP 401 e 403?',
        '401 Unauthorized indica que o cliente não está autenticado (ou a autenticação fornecida é inválida); 403 Forbidden indica que o cliente está autenticado, mas não tem permissão para realizar aquela ação específica.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('401 indica falta de autenticação; 403 indica autenticação válida, mas sem permissão para a ação', true),
    ('401 e 403 são sinônimos e podem ser usados de forma intercambiável', false),
    ('401 é usado apenas em respostas de sucesso; 403 é usado apenas em respostas de erro do servidor', false),
    ('403 indica que o recurso não existe; 401 indica que o servidor está fora do ar', false)
) AS alt(texto, correta);

-- Q26 (media) — Design de contratos REST — stateless
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000001',
        'O que significa dizer que uma API REST deve ser "stateless" (sem estado no servidor entre requisições)?',
        'Cada requisição deve conter, em si mesma, todas as informações necessárias para ser processada (ex.: credenciais, contexto), sem que o servidor dependa de um estado de sessão guardado a partir de requisições anteriores daquele cliente.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Cada requisição deve conter todas as informações necessárias para ser processada, sem depender de sessão armazenada no servidor entre chamadas', true),
    ('O servidor nunca pode persistir dados em um banco de dados', false),
    ('O cliente nunca pode enviar mais de uma requisição por minuto', false),
    ('A API não pode retornar nenhum dado que tenha sido calculado anteriormente', false)
) AS alt(texto, correta);

-- Q27 (media) — Versionamento — header de depreciação
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000002',
        'Qual mecanismo permite a um servidor comunicar formalmente, via HTTP, que um endpoint será desativado em uma data futura?',
        'Headers como `Deprecation` ou `Sunset` são usados para informar, de forma legível por máquina, que um endpoint está depreciado e/ou a data prevista de desativação, permitindo que clientes automatizem alertas antes da remoção.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Um header como Deprecation ou Sunset, informando a data prevista de desativação', true),
    ('Retornar imediatamente 410 Gone, sem qualquer aviso prévio', false),
    ('Alterar a versão do protocolo TLS usada pela API', false),
    ('Remover a documentação do endpoint sem alterar seu comportamento', false)
) AS alt(texto, correta);

-- Q28 (media) — Idempotência — chave reusada com payload diferente
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000003',
        'Um cliente reenvia uma requisição usando a mesma chave de idempotência (Idempotency-Key) de uma tentativa anterior, mas com um corpo (payload) diferente do original. Qual é o comportamento correto esperado do servidor?',
        'O servidor deve rejeitar a requisição (por exemplo, com um erro 409 ou 422), sinalizando uso inconsistente da chave — reutilizar a mesma chave para uma operação logicamente diferente é um erro do cliente, e não deve nem processar como operação nova nem simplesmente devolver a resposta antiga sem avisar da divergência.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Processar normalmente como se fosse uma operação totalmente nova, ignorando a chave repetida', false),
    ('Rejeitar a requisição, sinalizando que a chave já foi usada com um payload diferente do original', true),
    ('Sempre devolver a resposta da primeira tentativa, mesmo sem verificar se o payload mudou', false),
    ('Descartar silenciosamente a chave de idempotência e processar sem registrar nada', false)
) AS alt(texto, correta);

-- Q29 (media) — Filas e brokers — durabilidade
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000004',
        'O que significa dizer que um broker de mensagens armazena mensagens de forma "durável"?',
        'Armazenamento durável significa que as mensagens são persistidas (tipicamente em disco) e sobrevivem a reinícios ou falhas do broker, em vez de existirem apenas em memória e serem perdidas caso o processo do broker seja reiniciado.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('As mensagens são persistidas, tipicamente em disco, e sobrevivem a reinícios do broker', true),
    ('As mensagens são mantidas apenas em memória, e são perdidas se o broker reiniciar', false),
    ('As mensagens são criptografadas automaticamente antes de qualquer entrega', false),
    ('As mensagens só podem ser lidas uma única vez por qualquer consumidor, em qualquer sistema', false)
) AS alt(texto, correta);

-- Q30 (media) — Garantias de entrega — hot partition
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000005',
        'Se uma chave de particionamento mal escolhida faz com que a maioria das mensagens caia sempre na mesma partição, qual problema prático isso tende a causar?',
        'Isso cria uma "hot partition": o consumidor responsável por aquela partição fica sobrecarregado enquanto os consumidores das demais partições ficam ociosos, reduzindo o paralelismo real do consumo mesmo havendo capacidade disponível no cluster.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Uma "hot partition": o consumidor daquela partição fica sobrecarregado enquanto os demais ficam ociosos', true),
    ('O broker rejeita automaticamente todas as mensagens com chave de particionamento repetida', false),
    ('As mensagens passam a ser entregues fora de ordem apenas dentro dessa partição específica', false),
    ('O sistema converte automaticamente a fila em um tópico pub/sub para compensar o desbalanceamento', false)
) AS alt(texto, correta);

-- Q31 (dificil) — Design de contratos REST — PATCH não idempotente por semântica
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000001',
        'Um endpoint expõe `PATCH /contas/{id}` para aplicar `{"incrementar_saldo": 10}`, somando 10 ao saldo atual a cada chamada recebida. Mesmo usando o verbo PATCH, essa operação específica é idempotente?',
        'Não. Repetir a mesma chamada soma 10 novamente ao saldo a cada execução, alterando o efeito final acumulado. O verbo HTTP usado não garante idempotência por si só — isso depende da semântica da operação implementada pelo endpoint, e um PATCH que aplica um incremento relativo não é idempotente, ainda que outros usos de PATCH (como substituir um campo por um valor absoluto) possam ser.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Sim, porque o protocolo HTTP garante que toda chamada PATCH é sempre idempotente', false),
    ('Não, porque repetir a chamada soma 10 novamente a cada execução; o verbo HTTP não garante idempotência por si só, isso depende da semântica da operação', true),
    ('Sim, porque qualquer operação que envolva apenas números inteiros é idempotente por definição', false),
    ('Não, mas apenas porque o payload está em formato JSON em vez de texto plano', false)
) AS alt(texto, correta);

-- Q32 (dificil) — Versionamento — custo de manter múltiplas versões
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000002',
        'Uma equipe decide manter simultaneamente em produção as versões v1 e v2 de uma API por tempo indeterminado, sem nunca definir uma data de desativação de v1. Qual é o principal risco técnico dessa decisão?',
        'O custo de manutenção cresce indefinidamente: toda nova regra de negócio ou correção precisa ser replicada e testada em ambas as versões, sem que a superfície de código a manter jamais diminua — o oposto do objetivo original do versionamento, que é permitir uma transição controlada, não uma coexistência permanente sem prazo.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('O custo de manutenção cresce indefinidamente, pois mudanças precisam ser replicadas e testadas em ambas as versões, sem redução da superfície de código', true),
    ('A API para de aceitar requisições HTTP até que uma das versões seja removida manualmente', false),
    ('O banco de dados passa a exigir uma tabela separada para cada versão da API, por exigência do protocolo REST', false),
    ('Não há nenhum risco real, pois manter múltiplas versões indefinidamente é a prática recomendada por padrão', false)
) AS alt(texto, correta);

-- Q33 (dificil) — Idempotência — expiração de chaves
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000003',
        'Por que chaves de idempotência (Idempotency-Key) armazenadas pelo servidor normalmente não devem ser retidas indefinidamente, e sim expirar após um TTL (tempo de vida)?',
        'Reter chaves para sempre faz o armazenamento crescer sem limite e não reflete a janela de tempo realista em que um cliente ainda tentaria um retry legítimo da mesma operação; um TTL razoável (ex.: 24h) libera espaço e evita reter dados além do necessário, sem comprometer a proteção contra os retries que de fato importam.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Porque o protocolo HTTP proíbe o armazenamento de headers por mais de 24 horas', false),
    ('Porque reter chaves indefinidamente faz o armazenamento crescer sem limite e não reflete a janela realista de retry de um cliente, daí a necessidade de um TTL', true),
    ('Porque bancos de dados relacionais não suportam colunas com data de expiração', false),
    ('Porque isso tornaria automaticamente o endpoint POST idempotente por definição do protocolo', false)
) AS alt(texto, correta);

-- Q34 (dificil) — Filas e brokers — backpressure
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000004',
        'O que é "backpressure" em um sistema de mensageria, e como uma fila posicionada entre produtor e consumidor ajuda a mitigá-lo?',
        'Backpressure é a pressão gerada quando o produtor gera mensagens mais rápido do que o consumidor consegue processar. A fila atua como buffer, absorvendo temporariamente esse excesso, permitindo que o produtor continue publicando no seu próprio ritmo sem bloquear, e que o consumidor processe as mensagens acumuladas quando tiver capacidade, em vez de as duas partes precisarem operar exatamente na mesma velocidade.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('É a pressão gerada quando o produtor gera mensagens mais rápido que o consumidor processa; a fila absorve esse excesso como buffer temporário', true),
    ('É um mecanismo de compressão de mensagens usado para reduzir o tráfego de rede entre produtor e broker', false),
    ('É a rejeição automática de mensagens duplicadas pelo broker, sem envolver velocidade de processamento', false),
    ('É a criptografia obrigatória de mensagens em trânsito entre produtor e consumidor', false)
) AS alt(texto, correta);

-- Q35 (dificil) — Garantias de entrega — trade-off ordenação vs throughput
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000005',
        'Um time decide usar uma única partição para garantir ordenação estrita de todos os eventos de um tópico Kafka. Qual é o principal trade-off dessa decisão?',
        'Dentro de um mesmo grupo de consumidores, apenas um consumidor pode processar uma dada partição por vez — usar uma única partição para o tópico inteiro limita o paralelismo de consumo a um único consumidor ativo, reduzindo o throughput máximo possível em troca da ordenação estrita entre todos os eventos.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('O paralelismo de consumo fica limitado a um único consumidor por vez naquela partição, reduzindo o throughput máximo possível', true),
    ('O broker passa a garantir automaticamente exactly-once delivery para todas as mensagens do tópico', false),
    ('As mensagens deixam de ser persistidas de forma durável quando há apenas uma partição', false),
    ('Torna-se impossível ter mais de um produtor publicando no mesmo tópico', false)
) AS alt(texto, correta);

-- Q36 (dificil) — Garantias de entrega / Filas — DLQ crescente indica problema sistêmico
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000004',
        'Uma equipe percebe que o volume de mensagens movidas para a dead-letter queue (DLQ) cresce continuamente ao longo do dia, em vez de ser um evento raro e isolado. O que esse padrão normalmente indica?',
        'Um crescimento contínuo de mensagens na DLQ costuma indicar um problema sistêmico (ex.: bug de processamento, incompatibilidade de esquema de mensagem, ou dependência externa persistentemente indisponível), não uma falha transitória isolada — merece investigação da causa raiz, e não apenas reprocessamento manual repetido das mensagens.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Um comportamento esperado e sem importância, já que toda fila deve enviar parte do tráfego para a DLQ continuamente', false),
    ('Um problema sistêmico no processamento ou em uma dependência externa, que merece investigação em vez de apenas reprocessar as mensagens', true),
    ('Que o broker está prestes a perder mensagens da fila principal de forma irreversível', false),
    ('Que a fila principal foi convertida automaticamente em um tópico pub/sub pelo broker', false)
) AS alt(texto, correta);
