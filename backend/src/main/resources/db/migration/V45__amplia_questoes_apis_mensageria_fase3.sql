-- Ampliação do pool de Questions do domínio APIs/Mensageria (Fase 3 — Ticket
-- TICKET-content-expansion-questoes-fase3.md), somando 18 Questions novas às 54 já
-- existentes em V17__seed_conteudo_apis_mensageria.sql (18), V29__amplia_questoes_apis_mensageria.sql
-- (18) e V38__amplia_questoes_apis_mensageria_fase2.sql (18) — total: 72 no domínio.
-- content_version = 'v1' (decisão fechada no ticket mestre da Fase 3, não reabrir) e
-- status_revisao = 'rascunho', mesma regra dos lotes anteriores (autoria assistida por
-- IA, revisão humana ainda não realizada).
-- Este arquivo NUNCA insere em domain, concept, slide ou flashcard — apenas
-- Question + suas 4 alternativas, reaproveitando os 5 Concepts já semeados em V17
-- (UUIDs a4000000-0000-4000-8000-000000000001 a ...05) e o Domain já semeado em V13
-- (via subquery por slug 'apis-mensageria'). concept_ref fica NULL nas questões cujo
-- ponto testado (circuit breaker, bulkhead, backoff/jitter, gRPC via browser) não
-- corresponde com precisão a nenhum dos 5 Concepts existentes, seguindo o mesmo
-- critério já usado em V38 (concept_ref é recomendado, não obrigatório, conforme
-- ticket mestre).
-- Enunciados abaixo foram conferidos um a um contra os 54 já existentes em V17, V29 e
-- V38 para garantir que nenhum repete, literal ou disfarçadamente, o mesmo ponto
-- testado. Ângulos novos cobertos nesta leva: circuit breaker, request-reply
-- assíncrono sobre fila (correlation id), rate limiting por cliente em API Gateway,
-- transactional outbox vs. two-phase commit (2PC), padrão 202 Accepted para operação
-- assíncrona longa, ETag/If-Match para concorrência otimista, bulkhead, retry com
-- backoff exponencial e jitter, endpoints de operação em lote (batch) e a limitação de
-- gRPC em navegadores (grpc-web).

-- =====================================================================================
-- QUESTIONS + ALTERNATIVAS (18 novas: 6 facil, 6 media, 6 dificil)
-- =====================================================================================

-- Q55 (facil) — Circuit breaker — propósito geral
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        NULL,
        'Qual é o propósito de um circuit breaker aplicado a chamadas de uma API externa?',
        'Um circuit breaker interrompe temporariamente as chamadas a uma dependência que está falhando repetidamente, evitando que o chamador continue gastando tempo e recursos em chamadas com alta chance de falhar, e dá tempo para a dependência se recuperar.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Interromper temporariamente as chamadas a uma dependência que está falhando repetidamente, evitando desperdiçar recursos em chamadas com alta chance de falhar', true),
    ('Aumentar automaticamente o número de instâncias do serviço chamador', false),
    ('Criptografar o tráfego entre cliente e servidor', false),
    ('Garantir que toda chamada HTTP seja idempotente', false)
) AS alt(texto, correta);

-- Q56 (media) — Circuit breaker — estados fechado/aberto/meio-aberto
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        NULL,
        'Quais são os três estados típicos de um circuit breaker e o que cada um representa?',
        'Fechado (closed): as chamadas passam normalmente e as falhas são contadas. Aberto (open): as chamadas são bloqueadas de imediato, sem tentar a dependência, retornando erro rápido. Meio-aberto (half-open): após um tempo de espera, permite um número limitado de chamadas de teste para verificar se a dependência se recuperou, decidindo se volta a fechado ou retorna a aberto.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Fechado (chamadas passam normalmente), aberto (chamadas bloqueadas de imediato) e meio-aberto (permite chamadas de teste limitadas para verificar recuperação)', true),
    ('Ativo, inativo e suspenso, controlados manualmente por um operador humano', false),
    ('Síncrono, assíncrono e híbrido, conforme o protocolo de transporte usado', false),
    ('Leitura, escrita e leitura-escrita, conforme o verbo HTTP da chamada', false)
) AS alt(texto, correta);

-- Q57 (dificil) — Circuit breaker — half-open evita reabrir de vez e prevenir cascata
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        NULL,
        'Por que um circuit breaker no estado meio-aberto permite apenas um número limitado de chamadas de teste, em vez de voltar direto ao estado fechado e liberar todo o tráfego de uma vez, assim que o tempo de espera expira?',
        'Se toda a carga voltasse de uma vez para uma dependência que ainda está se recuperando (ex.: um serviço reiniciando, um cache sendo reconstruído), o volume repentino poderia sobrecarregá-la de novo antes que ela estabilize, derrubando-a outra vez e mantendo o ciclo de falha. Permitir só algumas chamadas de teste avalia a recuperação com risco controlado, sem replicar de imediato o mesmo volume que causou o problema original.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Para evitar que todo o tráfego volte de uma vez para uma dependência ainda se recuperando, o que poderia sobrecarregá-la de novo e reiniciar o ciclo de falha', true),
    ('Porque o protocolo HTTP limita a 1 requisição por segundo qualquer chamada após um erro 5xx', false),
    ('Porque o estado fechado só pode ser reativado manualmente por um operador humano, nunca automaticamente', false),
    ('Porque chamadas de teste não contam para as métricas de disponibilidade do serviço', false)
) AS alt(texto, correta);

-- Q58 (facil) — Request-reply sobre fila — conceito e correlation id
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000004',
        'O que caracteriza o padrão request-reply implementado sobre uma fila de mensagens, em vez de uma chamada HTTP síncrona?',
        'O cliente publica uma mensagem de requisição contendo, além do payload, um identificador de correlação e o destino de resposta desejado; o serviço processa a requisição de forma assíncrona e publica a resposta nesse destino, usando o mesmo identificador de correlação para que o cliente saiba a qual requisição aquela resposta pertence.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('O cliente publica uma mensagem de requisição com um identificador de correlação e um destino de resposta; o servidor processa e publica a resposta nesse destino, usando o mesmo identificador', true),
    ('O cliente abre uma conexão TCP direta com o servidor e espera bloqueado até a resposta chegar, sem usar nenhuma fila', false),
    ('O servidor responde imediatamente com um código 200 vazio, sem processar a requisição de fato', false),
    ('A fila descarta automaticamente a requisição caso o cliente não esteja conectado no momento da resposta', false)
) AS alt(texto, correta);

-- Q59 (dificil) — Request-reply — roteamento de resposta por correlation id
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000004',
        'Em uma implementação de request-reply sobre fila com múltiplos clientes concorrentes enviando requisições ao mesmo serviço, por que normalmente não basta usar uma única fila de resposta compartilhada por todos os clientes sem um identificador de correlação?',
        'Sem um identificador de correlação, qualquer cliente que ler da fila compartilhada de respostas poderia consumir uma resposta destinada a outro cliente, já que a fila apenas entrega mensagens sem saber a quem cada resposta pertence. O identificador de correlação, gerado pelo cliente na requisição e ecoado pelo servidor na resposta, permite que cada cliente filtre e reconheça apenas as respostas que lhe pertencem, mesmo compartilhando a mesma fila.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Porque, sem um identificador de correlação, um cliente poderia consumir a resposta destinada a outro cliente que também está usando a fila compartilhada', true),
    ('Porque filas de mensagens não suportam mais de um consumidor simultâneo, por definição de protocolo', false),
    ('Porque o broker rejeita automaticamente qualquer fila usada por mais de um cliente diferente', false),
    ('Porque isso tornaria a comunicação síncrona em vez de assíncrona, o que é proibido nesse padrão', false)
) AS alt(texto, correta);

-- Q60 (facil) — API Gateway — rate limiting por cliente vs. global
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000001',
        'Por que é comum um API Gateway aplicar limites de requisições (rate limiting) por cliente ou chave de API, em vez de um único limite global compartilhado por todos os consumidores da API?',
        'Um limite por cliente garante que o comportamento de um único consumidor (uso legítimo intenso ou um bug gerando chamadas em excesso) não consuma a cota disponível para os demais clientes, isolando o impacto de cada consumidor individualmente em vez de deixar todos competirem pelo mesmo teto compartilhado.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Para isolar o impacto de cada cliente, evitando que o uso excessivo de um consumidor esgote a cota disponível para os demais', true),
    ('Porque o protocolo HTTP exige que cada chave de API tenha seu próprio limite, por especificação', false),
    ('Porque limites por cliente são sempre mais fáceis de implementar do que um limite global', false),
    ('Porque um limite global tornaria a API automaticamente incompatível com HTTPS', false)
) AS alt(texto, correta);

-- Q61 (media) — API Gateway — noisy neighbor com limite só global
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000001',
        'Um API Gateway aplica apenas um limite global de requisições por segundo para toda a API, sem diferenciar por cliente. Qual problema prático de "noisy neighbor" (vizinho barulhento) isso pode causar?',
        'Se um único cliente, por bug, uso indevido ou pico legítimo de tráfego, consumir uma fatia desproporcional do limite global, os demais clientes bem-comportados passam a receber 429 mesmo sem terem excedido individualmente nada, porque o teto é compartilhado e não isolado por consumidor.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Um único cliente que consome tráfego em excesso pode fazer os demais clientes bem-comportados receberem 429, mesmo sem terem excedido individualmente nada', true),
    ('O gateway trava permanentemente e precisa ser reiniciado manualmente sempre que o limite global é atingido', false),
    ('Todos os clientes passam a compartilhar a mesma chave de API automaticamente', false),
    ('O limite global faz o gateway ignorar completamente o código de status 429', false)
) AS alt(texto, correta);

-- Q62 (media) — Outbox vs. 2PC
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000004',
        'Por que a abordagem de two-phase commit (2PC) para coordenar uma escrita atômica entre o banco de dados de um serviço e um broker de mensagens é, na prática, menos usada do que o padrão transactional outbox em arquiteturas de microsserviços?',
        '2PC exige que ambos os participantes (banco e broker) suportem o protocolo de commit em duas fases e permaneçam coordenados por um coordenador central durante toda a transação, algo que a maioria dos brokers populares não suporta nativamente, além de acoplar fortemente a disponibilidade da operação à disponibilidade simultânea dos dois sistemas. O outbox evita essa dependência usando apenas a transação já existente do banco, gravando o evento na mesma transação do dado de negócio e publicando no broker depois, de forma assíncrona e desacoplada.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Porque 2PC exige suporte nativo ao protocolo de commit em duas fases pelos dois participantes e um coordenador central, algo que a maioria dos brokers populares não oferece, enquanto o outbox usa apenas a transação já existente do banco', true),
    ('Porque 2PC é proibido pelo padrão HTTP e não pode ser usado em nenhuma comunicação entre serviços', false),
    ('Porque o outbox é mais rápido de implementar por não exigir nenhuma tabela adicional no banco de dados', false),
    ('Porque 2PC só funciona quando os dois serviços envolvidos são escritos na mesma linguagem de programação', false)
) AS alt(texto, correta);

-- Q63 (dificil) — 2PC blocking problem
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000004',
        'No protocolo de two-phase commit (2PC), o que caracteriza o chamado "problema do bloqueio" (blocking problem) quando o coordenador da transação falha depois da fase de preparação, mas antes de enviar a decisão final de commit ou rollback aos participantes?',
        'Depois que um participante responde "pronto para commit" na fase de preparação, ele fica obrigado a manter seus recursos (ex.: locks, registros) travados até receber a decisão final do coordenador. Se o coordenador falhar exatamente nesse intervalo, os participantes ficam bloqueados indefinidamente, sem poder decidir sozinhos entre commit ou rollback, pois não sabem qual decisão os outros participantes já receberam — os recursos ficam retidos até o coordenador se recuperar ou até uma intervenção manual.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Os participantes que já responderam "pronto" ficam com seus recursos bloqueados indefinidamente, sem poder decidir sozinhos entre commit ou rollback, até o coordenador se recuperar', true),
    ('O coordenador automaticamente refaz a transação do zero em outro servidor, sem qualquer impacto nos participantes', false),
    ('Os participantes assumem automaticamente rollback após 1 segundo sem resposta do coordenador, sem risco de inconsistência', false),
    ('O bloqueio ocorre apenas na rede, nunca nos recursos de banco de dados dos participantes', false)
) AS alt(texto, correta);

-- Q64 (facil) — 202 Accepted para operação assíncrona longa
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000001',
        'Uma API recebe uma requisição para iniciar um processamento que leva vários minutos (ex.: gerar um relatório grande) e não quer manter o cliente esperando a resposta HTTP até o fim do processamento. Qual código de status e padrão de resposta é mais adequado nesse cenário?',
        '202 Accepted sinaliza que a requisição foi aceita para processamento, mas ainda não foi concluída, tipicamente acompanhado de uma URL (ex.: no header Location) que o cliente pode consultar depois para verificar o status ou obter o resultado quando pronto, em vez de manter a conexão HTTP aberta esperando a conclusão.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('202 Accepted, geralmente acompanhado de uma URL que o cliente pode consultar depois para verificar o status do processamento', true),
    ('200 OK, mantendo a conexão HTTP aberta até o processamento terminar, independentemente do tempo necessário', false),
    ('404 Not Found, até que o processamento seja concluído com sucesso', false),
    ('301 Moved Permanently, redirecionando o cliente para um servidor mais rápido', false)
) AS alt(texto, correta);

-- Q65 (facil) — ETag conceito
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000001',
        'O que é um ETag em uma resposta HTTP, e para que serve?',
        'ETag é um identificador, geralmente um hash, que representa uma versão específica de um recurso. O servidor o inclui na resposta e o cliente pode reenviá-lo em requisições futuras (ex.: no header If-None-Match para cache, ou If-Match para escrita condicional), permitindo ao servidor detectar se o recurso mudou desde a última vez que o cliente o obteve.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Um identificador que representa uma versão específica de um recurso, permitindo ao cliente e ao servidor detectar se ele mudou desde a última vez que foi obtido', true),
    ('Um token de autenticação obrigatório para qualquer requisição GET', false),
    ('O nome da tabela do banco de dados onde o recurso está armazenado', false),
    ('Um contador que indica quantos clientes estão conectados simultaneamente ao servidor', false)
) AS alt(texto, correta);

-- Q66 (media) — If-Match e concorrência otimista
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000001',
        'Como o uso do header If-Match com um ETag em uma requisição PUT/PATCH ajuda a evitar o problema de "lost update" (atualização perdida), quando dois clientes editam o mesmo recurso concorrentemente?',
        'O cliente envia, no header If-Match, o ETag que obteve na última leitura do recurso; o servidor só aplica a atualização se o ETag atual do recurso ainda coincidir com o enviado, retornando um erro (tipicamente 412 Precondition Failed) caso o recurso já tenha sido alterado por outra requisição entre a leitura e a escrita. Isso implementa controle de concorrência otimista, evitando que a escrita de um cliente sobrescreva silenciosamente uma mudança feita por outro.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('O servidor só aplica a atualização se o ETag enviado ainda coincidir com o ETag atual do recurso, rejeitando a escrita (ex.: 412 Precondition Failed) se o recurso mudou entre a leitura e a escrita', true),
    ('O header If-Match faz o servidor bloquear o recurso para todos os outros clientes até que a requisição atual termine', false),
    ('O ETag é recalculado a cada requisição e nunca é comparado com nenhum valor anterior', false),
    ('If-Match substitui a necessidade de autenticação nas requisições de escrita', false)
) AS alt(texto, correta);

-- Q67 (media) — Bulkhead conceito
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        NULL,
        'O que propõe o padrão bulkhead (anteparo) aplicado a chamadas para múltiplas dependências externas de um serviço?',
        'Bulkhead isola os recursos, como pools de conexão, threads ou filas de chamadas, usados para se comunicar com cada dependência externa, de forma que um problema em uma dependência (lentidão, esgotamento) não consuma os recursos compartilhados que seriam necessários para chamar as demais dependências saudáveis — nome inspirado nos anteparos que isolam compartimentos de um navio, para que um alagamento não afunde o casco inteiro.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Isolar os recursos (pools de conexão, threads) usados para chamar cada dependência externa, para que um problema em uma delas não consuma os recursos necessários para chamar as demais', true),
    ('Agrupar todas as chamadas a dependências externas em uma única fila compartilhada, para simplificar o monitoramento', false),
    ('Criptografar automaticamente todo o tráfego entre o serviço e suas dependências externas', false),
    ('Substituir a necessidade de qualquer timeout nas chamadas a dependências externas', false)
) AS alt(texto, correta);

-- Q68 (dificil) — Bulkhead — pool compartilhado esgotando por dependência lenta
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        NULL,
        'Um serviço usa um único pool de threads compartilhado para chamar tanto uma dependência A (rápida e estável) quanto uma dependência B (que começou a responder muito lentamente). Sem isolamento (bulkhead) entre elas, qual efeito concreto a lentidão de B pode causar sobre as chamadas a A, mesmo A continuando saudável?',
        'Como as threads do pool compartilhado ficam ocupadas esperando as respostas lentas de B, o número de threads disponíveis para processar chamadas a A também diminui, podendo esgotar o pool inteiro e fazer as chamadas a A também começarem a enfileirar ou expirar por timeout, mesmo que A, isoladamente, esteja respondendo normalmente. Isolar os pools por dependência evita que a degradação de uma se propague para as demais através do recurso compartilhado.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('As threads do pool compartilhado ficam presas esperando B, esgotando o pool e fazendo as chamadas a A também enfileirarem ou expirarem, mesmo A estando saudável', true),
    ('Nenhum efeito, pois threads dedicadas a uma dependência nunca afetam chamadas a outra, com ou sem isolamento', false),
    ('As chamadas a A são automaticamente redirecionadas para um servidor de backup, sem qualquer impacto perceptível', false),
    ('O pool de threads se expande automaticamente sem limite para acomodar a lentidão de B', false)
) AS alt(texto, correta);

-- Q69 (facil) — Retry com backoff exponencial
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        NULL,
        'O que caracteriza uma estratégia de retry com backoff exponencial ao tentar novamente uma chamada de API que falhou?',
        'Em vez de tentar novamente de imediato ou em intervalos fixos, o tempo de espera entre cada nova tentativa cresce exponencialmente (ex.: 1s, 2s, 4s, 8s...), dando cada vez mais tempo para que uma falha transitória, como uma sobrecarga momentânea do servidor, se resolva antes da próxima tentativa, em vez de insistir repetidamente em alta frequência sobre um sistema que já está com dificuldade.',
        'facil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('O tempo de espera entre tentativas sucessivas cresce exponencialmente, dando cada vez mais tempo para a falha transitória se resolver', true),
    ('Cada tentativa é feita em um servidor diferente, escolhido aleatoriamente entre todos os disponíveis', false),
    ('O número de tentativas é sempre fixo em duas, independentemente do tipo de erro', false),
    ('O intervalo entre tentativas diminui a cada nova tentativa, para resolver o problema mais rápido', false)
) AS alt(texto, correta);

-- Q70 (dificil) — Jitter no backoff e thundering herd
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        NULL,
        'Por que adicionar um componente aleatório (jitter) ao tempo de espera de um backoff exponencial é recomendado quando muitos clientes podem estar retentando a mesma chamada simultaneamente após uma falha compartilhada, como uma instabilidade momentânea do servidor?',
        'Sem jitter, todos os clientes que falharam ao mesmo tempo calculam exatamente os mesmos intervalos de espera (1s, 2s, 4s...) e retentam de forma sincronizada, recriando picos de carga simultâneos a cada nova tentativa — o chamado "thundering herd". Adicionar aleatoriedade ao tempo de espera de cada cliente espalha as novas tentativas ao longo do tempo, evitando que todas cheguem ao servidor no mesmo instante e o sobrecarreguem de novo logo após ele começar a se recuperar.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Para evitar o "thundering herd": sem jitter, todos os clientes retentam nos mesmos instantes sincronizados, recriando picos de carga simultâneos no servidor', true),
    ('Porque o protocolo HTTP exige um valor aleatório em qualquer header de retry', false),
    ('Porque jitter elimina completamente a necessidade de um limite máximo de tentativas', false),
    ('Porque sem jitter as requisições deixam de ser idempotentes', false)
) AS alt(texto, correta);

-- Q71 (media) — Endpoint de operação em lote (batch)
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        'a4000000-0000-4000-8000-000000000001',
        'Uma API expõe um endpoint de operação em lote (ex.: POST /pedidos/batch para criar até 100 pedidos em uma única requisição) em vez de exigir 100 chamadas individuais. Qual trade-off de design essa API precisa resolver em relação ao tratamento de erros?',
        'Diferente de uma chamada individual, que falha ou tem sucesso como um todo, um lote precisa decidir e comunicar claramente o que acontece quando alguns itens do lote são processados com sucesso e outros falham, por exemplo retornando um status por item dentro da resposta (sucesso ou erro individual), em vez de um único código de status para o lote inteiro, que não conseguiria expressar um resultado parcial.',
        'media', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Comunicar claramente o resultado individual de cada item do lote (sucesso ou erro por item), já que um único código de status para a resposta inteira não expressa um resultado parcial', true),
    ('Garantir que o lote inteiro seja sempre processado em uma única transação de banco, sem exceção', false),
    ('Impedir que qualquer item do lote seja processado se pelo menos um outro item for inválido, sem exceção', false),
    ('Eliminar completamente a necessidade de validação de cada item individual do lote', false)
) AS alt(texto, correta);

-- Q72 (dificil) — gRPC — limitação de suporte em navegadores
WITH nova_question AS (
    INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
    VALUES (
        (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
        NULL,
        'Por que uma aplicação web rodando diretamente no navegador normalmente não consegue chamar um serviço gRPC da mesma forma direta que um cliente backend consegue, exigindo uma camada adicional como o grpc-web com um proxy?',
        'gRPC depende de recursos do HTTP/2, como streams e trailers, que as APIs de rede expostas pelos navegadores (ex.: fetch, XMLHttpRequest) não dão acesso de baixo nível suficiente para implementar o protocolo gRPC completo. O grpc-web resolve isso traduzindo chamadas do navegador para um formato compatível, encaminhadas por um proxy que fala gRPC "de verdade" com o serviço backend — diferente de REST/JSON sobre HTTP/1.1, que o navegador suporta nativamente sem nenhuma camada extra.',
        'dificil', 'v1', 'rascunho'
    ) RETURNING id
)
INSERT INTO question_alternative (question_id, texto, correta)
SELECT id, texto, correta FROM nova_question, (VALUES
    ('Porque o navegador não expõe, por suas APIs de rede padrão, acesso de baixo nível suficiente aos recursos de HTTP/2 que o gRPC usa, exigindo uma tradução via grpc-web e um proxy', true),
    ('Porque o protocolo gRPC não pode ser usado com nenhuma linguagem de programação interpretada, como JavaScript', false),
    ('Porque navegadores bloqueiam por padrão qualquer requisição que use Protocol Buffers, por razões de segurança do JavaScript', false),
    ('Porque o gRPC exige que o navegador tenha uma licença paga para decodificar mensagens binárias', false)
) AS alt(texto, correta);
