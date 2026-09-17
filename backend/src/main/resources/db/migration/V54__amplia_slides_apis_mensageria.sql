-- Ampliação do pool de Slides — Domínio APIs e Mensageria (slug 'apis-mensageria'), Fase 1.
-- TICKET-content-expansion-slides-fase1.md: adiciona 2 Slides novos por Concept (ordem 4 =
-- erros comuns/armadilhas, ordem 5 = comparação com alternativa) às 3 já existentes em
-- V17__seed_conteudo_apis_mensageria.sql, elevando o pool para 5 Slides por Concept / 25 no domínio.

-- Concept: Design de contratos REST
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a4000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'O erro de aninhar recursos demais na URL',
     'Um erro comum é modelar todo relacionamento entre entidades como aninhamento profundo de URL, como `/clientes/{id}/pedidos/{id}/itens/{id}/pagamentos/{id}`. Parece "mais RESTful" porque reflete o relacionamento no banco, mas na prática acopla a URL à hierarquia interna dos dados: qualquer consulta que precise de um item sem passar por toda a cadeia (ex.: buscar um pagamento direto pelo seu id) fica forçada a montar uma URL artificialmente longa, e mudar a hierarquia de negócio exige mudar contratos de API já publicados. A prática mais robusta é aninhar no máximo um nível (o necessário para expressar posse direta, ex.: `/pedidos/{id}/itens`) e expor recursos de nível mais profundo também por um caminho direto e estável, como `/pagamentos/{id}`.',
     4, 'v1', 'rascunho'),
    ('a4000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'REST vs. RPC/gRPC: quando o modelo de recursos não é o melhor encaixe',
     'REST orientado a recursos compete com um modelo alternativo, RPC (ex.: gRPC), onde o contrato é uma lista explícita de operações (`CriarPedido`, `CancelarPedido`) em vez de recursos manipulados por verbos HTTP genéricos. REST tende a ser a escolha certa quando a API expõe dados consultáveis por múltiplos clientes heterogêneos (navegadores, apps de terceiros) e se beneficia de cache HTTP e da semântica dos verbos; RPC/gRPC tende a ganhar quando a comunicação é interna entre serviços do mesmo time, o volume de chamadas é alto e a performance de serialização binária (protobuf) e HTTP/2 importa mais do que a aderência a convenções REST. Forçar uma operação inerentemente não-CRUD (ex.: "recalcular frete") dentro do vocabulário de recursos costuma produzir endpoints artificiais como `POST /recalculos-de-frete`, quando uma chamada RPC nomeada expressaria a intenção de forma mais direta.',
     5, 'v1', 'rascunho');

-- Concept: Versionamento e evolução de APIs
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a4000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'O erro de versionar a API inteira em vez do contrato específico que mudou',
     'Uma armadilha comum é, ao precisar mudar um único endpoint, lançar uma versão nova de toda a API (ex.: `/v2/*` para tudo), obrigando os clientes a migrar endpoints que nem mudaram só para acompanhar a numeração. Isso parece disciplinado ("manter tudo na mesma versão"), mas na prática infla o custo de migração do cliente e do time mantenedor, que passa a sustentar `/v1/*` e `/v2/*` completos em paralelo mesmo quando 90% dos endpoints são idênticos entre as duas versões. A prática mais sustentável é versionar o recurso ou o campo que efetivamente quebrou contrato, mantendo o restante da API estável, ou usar mudanças aditivas sempre que possível para evitar precisar de uma versão nova.',
     4, 'v1', 'rascunho'),
    ('a4000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'Versionamento explícito vs. expansão apenas aditiva (never break userspace)',
     'A alternativa ao versionamento explícito (URL ou header) é a filosofia de nunca quebrar o contrato existente, expandindo apenas de forma aditiva e mantendo campos antigos funcionando indefinidamente (ou por um prazo muito longo), em vez de criar uma v2. Versionamento explícito compensa quando mudanças de ruptura são inevitáveis e o número de clientes é conhecido e gerenciável (ex.: apps mobile que o time controla, com processo de forçar atualização); a expansão apenas aditiva compensa quando a API tem consumidores externos numerosos e não rastreáveis, para os quais depreciar uma versão é operacionalmente inviável — nesse cenário, o custo de nunca poder remover um campo antigo é aceito em troca de nunca quebrar ninguém.',
     5, 'v1', 'rascunho');

-- Concept: Idempotência em APIs
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a4000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'O erro de achar que PUT é sempre seguro para reenviar sem revalidar',
     'Um equívoco frequente é assumir que, por PUT ser idempotente por definição do protocolo, basta reenviá-lo sem cuidado adicional em caso de dúvida sobre o resultado da primeira tentativa. Isso é verdade apenas quando o corpo da requisição representa o estado final completo e não depende de um valor lido antes (ex.: "defina o saldo como R$100"); se o PUT for usado para aplicar um incremento relativo (ex.: "some R$10 ao saldo atual", implementado incorretamente como PUT), repetir a chamada aplica o incremento mais de uma vez, quebrando a idempotência mesmo usando o verbo "certo". A idempotência do verbo HTTP é uma garantia sobre a semântica da operação, não uma garantia automática sobre qualquer lógica de negócio implementada por trás dele.',
     4, 'v1', 'rascunho'),
    ('a4000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'Chave de idempotência vs. deduplicação por identificador natural do domínio',
     'Uma alternativa à chave de idempotência gerada pelo cliente é deduplicar usando um identificador natural que já existe no domínio (ex.: número de pedido do sistema de origem, ou hash determinístico do payload). A chave de idempotência gerada pelo cliente é preferível quando o mesmo conteúdo pode legitimamente repetir (ex.: dois pedidos idênticos de compra do mesmo produto, na mesma quantidade, em momentos diferentes, que devem ser tratados como operações distintas); o identificador natural ou hash do payload é preferível quando o próprio conteúdo da requisição já identifica unicamente a operação de negócio (ex.: importação de um arquivo com um id de lote), tornando desnecessário exigir que o cliente gerencie e envie uma chave à parte.',
     5, 'v1', 'rascunho');

-- Concept: Filas e brokers de mensagens
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a4000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'O erro de tratar a fila como garantia de processamento imediato',
     'Um engano comum é assumir que, por a mensagem ter sido publicada com sucesso na fila, ela será processada em instantes, e desenhar o restante do sistema (ex.: uma tela que espera o resultado) como se a latência fosse desprezível. Isso parece razoável porque o broker geralmente entrega rápido em condições normais, mas mensageria assíncrona não dá nenhuma garantia de tempo de processamento: se os consumidores ficarem indisponíveis, lentos, ou a fila acumular um pico de mensagens à frente, o atraso pode chegar a minutos ou horas sem que isso seja uma falha do sistema. Fluxos que exigem confirmação em tempo real para o usuário não devem depender de uma fila no caminho síncrono da resposta; a fila serve para desacoplar trabalho que pode esperar, não para acelerar trabalho que não pode.',
     4, 'v1', 'rascunho'),
    ('a4000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'Mensageria assíncrona vs. chamada síncrona (REST/RPC) direta',
     'A alternativa a publicar em uma fila é o serviço chamador fazer uma chamada síncrona direta (REST ou RPC) ao serviço que fará o trabalho. A chamada síncrona é preferível quando o chamador precisa do resultado imediatamente para decidir o próximo passo (ex.: validar um CPF antes de prosseguir um cadastro) e quando um pequeno acoplamento de disponibilidade entre os dois serviços é aceitável; a fila é preferível quando o trabalho pode ser concluído depois (ex.: gerar um relatório, enviar um e-mail), quando múltiplos consumidores independentes precisam reagir ao mesmo evento, ou quando é necessário absorver picos de carga sem que uma indisponibilidade temporária do consumidor derrube o produtor.',
     5, 'v1', 'rascunho');

-- Concept: Garantias de entrega e ordenação
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a4000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'O erro de dar ack antes de terminar de processar a mensagem',
     'Uma armadilha frequente é confirmar (ack) a mensagem ao broker logo após lê-la da fila, antes de concluir o processamento, para "liberar" a fila mais rápido ou simplificar o código do consumidor. Isso parece inofensivo, mas transforma a garantia de at-least-once em algo mais fraco na prática: se o consumidor falhar entre o ack e a conclusão do processamento (ex.: crash no meio de uma chamada a outro serviço), a mensagem já foi dada como entregue pelo broker e nunca será reenviada, resultando em perda silenciosa de uma operação que o sistema acreditava ter concluído. O ack deve ocorrer somente depois que o efeito colateral da mensagem estiver persistido com sucesso, para que uma falha no meio do caminho realmente resulte em reentrega.',
     4, 'v1', 'rascunho'),
    -- OPEN QUESTION-009: "comparação com alternativa" não se encaixa naturalmente neste Concept
    -- (garantias de entrega não têm uma alternativa concorrente única a nomear); trocado por
    -- "impacto em escala/produção", mantendo um 5º ângulo distinto dos 4 slides anteriores.
    ('a4000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'apis-mensageria'),
     'Impacto em produção: throughput vs. garantias mais fortes',
     'Garantias mais fortes de entrega e ordenação não são gratuitas em produção: exigir ordenação estrita através de uma única partição, ou reduzir a janela de duplicação com acks síncronos mais frequentes, reduz o paralelismo possível e, portanto, o throughput máximo do sistema, porque menos mensagens podem ser processadas concorrentemente sem violar a garantia pedida. Em escala, times costumam relaxar deliberadamente a ordenação (aceitando ordem só dentro de uma chave de particionamento, não globalmente) e aceitar at-least-once com idempotência no consumidor, em vez de perseguir exactly-once nativo, justamente porque o ganho de throughput obtido ao permitir mais paralelismo costuma superar o custo de implementar idempotência uma única vez no código do consumidor.',
     5, 'v1', 'rascunho');
