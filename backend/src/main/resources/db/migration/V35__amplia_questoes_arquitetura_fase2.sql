-- Ampliação do pool de Questions — Domínio Arquitetura (slug 'arquitetura'), Fase 2.
-- TICKET-content-expansion-questoes-fase2.md: adiciona 18 Questions novas (6 fácil /
-- 6 média / 6 difícil) + 72 alternativas (4 por Question) às 36 já existentes em
-- V14__seed_conteudo_arquitetura.sql (18) e V26__amplia_questoes_arquitetura.sql (18),
-- elevando o pool para 54 Questions neste domínio.
--
-- Regras (iguais às de V14/V26, ver TICKET-content-database.md e
-- TICKET-content-expansion-questoes-fase2.md):
-- - Não insere Domain nem Concept novos: reaproveita os 5 Concepts já semeados por V14
--   (UUIDs literais 'a2000000-0000-4000-8000-000000000001' a '...005').
-- - content_version = 'v1', status_revisao = 'rascunho'.
-- - Question e suas 4 alternativas na mesma migração, respeitando o trigger de constraint
--   adiada de V6 (trg_verificar_alternativas_question).
-- - Enunciados desta leva foram conferidos um a um contra os 18 enunciados de V14 e os 18
--   de V26 (36 no total) para garantir ausência de duplicação literal ou de reformulação
--   que testasse o mesmo ponto de forma indistinguível. Cobrem ângulos ainda não testados:
--   pipe-and-filter, microkernel, API Gateway, BFF, tipos de acoplamento/coesão (conteúdo,
--   dados, coincidental), SOA vs. microsserviços, Saga (coreografia vs. orquestração),
--   Strangler Fig, anti-corruption layer, vertical slice architecture, Lei de Conway,
--   big ball of mud, event sourcing e fitness functions (arquitetura evolutiva).

-- =====================================================================================
-- QUESTIONS + ALTERNATIVAS (18 novas: 6 fácil, 6 média, 6 difícil)
-- =====================================================================================

-- ---- FÁCEIS (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000001',
    'Qual estilo arquitetural organiza o processamento como uma sequência de etapas independentes, em que cada etapa transforma os dados recebidos e repassa o resultado para a etapa seguinte, de forma semelhante a comandos encadeados por pipe em um terminal Unix?',
    'Pipe-and-filter organiza o sistema como uma cadeia de "filtros" independentes conectados por "pipes" que transportam dados de uma etapa para a próxima; cada filtro não precisa conhecer os demais, apenas o formato de entrada e saída esperado.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual estilo arquitetural organiza o processamento como uma sequência de etapas independentes, em que cada etapa transforma os dados recebidos e repassa o resultado para a etapa seguinte, de forma semelhante a comandos encadeados por pipe em um terminal Unix?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Pipe-and-filter', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual estilo arquitetural organiza o processamento como uma sequência de etapas independentes, em que cada etapa transforma os dados recebidos e repassa o resultado para a etapa seguinte, de forma semelhante a comandos encadeados por pipe em um terminal Unix?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Arquitetura em camadas', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual estilo arquitetural organiza o processamento como uma sequência de etapas independentes, em que cada etapa transforma os dados recebidos e repassa o resultado para a etapa seguinte, de forma semelhante a comandos encadeados por pipe em um terminal Unix?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Arquitetura cliente-servidor', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual estilo arquitetural organiza o processamento como uma sequência de etapas independentes, em que cada etapa transforma os dados recebidos e repassa o resultado para a etapa seguinte, de forma semelhante a comandos encadeados por pipe em um terminal Unix?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'CQRS', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'Em um sistema com vários microsserviços, qual componente é comumente adotado como ponto único de entrada para clientes externos, roteando cada requisição ao serviço interno apropriado?',
    'Um API Gateway centraliza o ponto de entrada externo, cuidando de roteamento, e frequentemente de preocupações transversais como autenticação e agregação de respostas, evitando que o cliente precise conhecer o endereço de cada microsserviço individualmente.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Em um sistema com vários microsserviços, qual componente é comumente adotado como ponto único de entrada para clientes externos, roteando cada requisição ao serviço interno apropriado?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'API Gateway', true),
    ((SELECT id FROM question WHERE enunciado = 'Em um sistema com vários microsserviços, qual componente é comumente adotado como ponto único de entrada para clientes externos, roteando cada requisição ao serviço interno apropriado?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Repository compartilhado entre todos os serviços', false),
    ((SELECT id FROM question WHERE enunciado = 'Em um sistema com vários microsserviços, qual componente é comumente adotado como ponto único de entrada para clientes externos, roteando cada requisição ao serviço interno apropriado?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'ORM único compartilhado por todos os serviços', false),
    ((SELECT id FROM question WHERE enunciado = 'Em um sistema com vários microsserviços, qual componente é comumente adotado como ponto único de entrada para clientes externos, roteando cada requisição ao serviço interno apropriado?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma tabela de banco de dados compartilhada por todos os serviços', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000003',
    'Qual é considerado o tipo de acoplamento mais forte (pior) entre dois módulos, caracterizado por um módulo alterar diretamente dados ou comportamento internos de outro módulo?',
    'Acoplamento de conteúdo ocorre quando um módulo depende ou modifica diretamente elementos internos de outro (ex.: acessar variáveis privadas ou tabelas internas), sem passar por uma interface pública — é o tipo de acoplamento mais forte e mais frágil a mudanças.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual é considerado o tipo de acoplamento mais forte (pior) entre dois módulos, caracterizado por um módulo alterar diretamente dados ou comportamento internos de outro módulo?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Acoplamento de conteúdo', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual é considerado o tipo de acoplamento mais forte (pior) entre dois módulos, caracterizado por um módulo alterar diretamente dados ou comportamento internos de outro módulo?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Acoplamento de dados', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é considerado o tipo de acoplamento mais forte (pior) entre dois módulos, caracterizado por um módulo alterar diretamente dados ou comportamento internos de outro módulo?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Ausência total de acoplamento', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é considerado o tipo de acoplamento mais forte (pior) entre dois módulos, caracterizado por um módulo alterar diretamente dados ou comportamento internos de outro módulo?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Acoplamento por mensagem assíncrona', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'O que é um Backend for Frontend (BFF)?',
    'Um BFF é uma camada de backend dedicada às necessidades específicas de um tipo de cliente (ex.: aplicativo mobile, aplicação web), agregando e formatando dados de diferentes serviços de acordo com o que aquele cliente específico precisa, em vez de forçar um único backend genérico a atender todos os clientes da mesma forma.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que é um Backend for Frontend (BFF)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma camada de backend dedicada a atender as necessidades específicas de um tipo de cliente', true),
    ((SELECT id FROM question WHERE enunciado = 'O que é um Backend for Frontend (BFF)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um framework de frontend que substitui a necessidade de qualquer backend', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é um Backend for Frontend (BFF)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um banco de dados otimizado exclusivamente para leitura pelo frontend', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é um Backend for Frontend (BFF)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um protocolo de comunicação que substitui HTTP entre cliente e servidor', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000001',
    'No estilo arquitetural microkernel (também chamado plug-in architecture), qual é o papel do núcleo (core system)?',
    'No estilo microkernel, o núcleo fornece apenas as funcionalidades mínimas essenciais para o sistema funcionar; funcionalidades adicionais ou específicas são incorporadas por meio de plug-ins que se conectam ao núcleo, permitindo estender o sistema sem alterar seu núcleo.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'No estilo arquitetural microkernel (também chamado plug-in architecture), qual é o papel do núcleo (core system)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Fornecer as funcionalidades mínimas essenciais, permitindo que funcionalidades adicionais sejam incorporadas via plug-ins', true),
    ((SELECT id FROM question WHERE enunciado = 'No estilo arquitetural microkernel (também chamado plug-in architecture), qual é o papel do núcleo (core system)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Concentrar toda a lógica de negócio e todas as funcionalidades do sistema, sem possibilidade de extensão', false),
    ((SELECT id FROM question WHERE enunciado = 'No estilo arquitetural microkernel (também chamado plug-in architecture), qual é o papel do núcleo (core system)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Substituir a necessidade de qualquer banco de dados no sistema', false),
    ((SELECT id FROM question WHERE enunciado = 'No estilo arquitetural microkernel (também chamado plug-in architecture), qual é o papel do núcleo (core system)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Orquestrar exclusivamente a comunicação entre bancos de dados distribuídos', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000005',
    'O que afirma a Lei de Conway sobre a relação entre estrutura organizacional e arquitetura de software?',
    'A Lei de Conway observa que sistemas tendem a refletir a estrutura de comunicação das equipes que os constroem: se os times são organizados de determinada forma, a arquitetura resultante tende a espelhar essas fronteiras organizacionais, para o bem ou para o mal.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que afirma a Lei de Conway sobre a relação entre estrutura organizacional e arquitetura de software?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Sistemas tendem a refletir a estrutura de comunicação das equipes que os constroem', true),
    ((SELECT id FROM question WHERE enunciado = 'O que afirma a Lei de Conway sobre a relação entre estrutura organizacional e arquitetura de software?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A arquitetura de um sistema nunca é influenciada pela forma como as equipes estão organizadas', false),
    ((SELECT id FROM question WHERE enunciado = 'O que afirma a Lei de Conway sobre a relação entre estrutura organizacional e arquitetura de software?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Toda equipe de software deve ter exatamente o mesmo tamanho para garantir boa arquitetura', false),
    ((SELECT id FROM question WHERE enunciado = 'O que afirma a Lei de Conway sobre a relação entre estrutura organizacional e arquitetura de software?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Microsserviços eliminam qualquer influência da estrutura organizacional sobre a arquitetura', false);

-- ---- MÉDIAS (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000003',
    'Um módulo agrupa funções sem nenhuma relação lógica entre si, apenas porque foram escritas na mesma época do projeto ou colocadas juntas por conveniência. Qual tipo de coesão — considerado o mais fraco — esse módulo apresenta?',
    'Coesão coincidental é o grau mais fraco de coesão: os elementos do módulo não têm relação funcional entre si, estando agrupados apenas por acaso ou conveniência, o que torna o módulo difícil de entender e reutilizar de forma isolada.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Um módulo agrupa funções sem nenhuma relação lógica entre si, apenas porque foram escritas na mesma época do projeto ou colocadas juntas por conveniência. Qual tipo de coesão — considerado o mais fraco — esse módulo apresenta?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Coesão coincidental', true),
    ((SELECT id FROM question WHERE enunciado = 'Um módulo agrupa funções sem nenhuma relação lógica entre si, apenas porque foram escritas na mesma época do projeto ou colocadas juntas por conveniência. Qual tipo de coesão — considerado o mais fraco — esse módulo apresenta?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Coesão funcional', false),
    ((SELECT id FROM question WHERE enunciado = 'Um módulo agrupa funções sem nenhuma relação lógica entre si, apenas porque foram escritas na mesma época do projeto ou colocadas juntas por conveniência. Qual tipo de coesão — considerado o mais fraco — esse módulo apresenta?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Acoplamento de dados', false),
    ((SELECT id FROM question WHERE enunciado = 'Um módulo agrupa funções sem nenhuma relação lógica entre si, apenas porque foram escritas na mesma época do projeto ou colocadas juntas por conveniência. Qual tipo de coesão — considerado o mais fraco — esse módulo apresenta?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Alta coesão sequencial', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'Um fluxo de negócio precisa coordenar uma operação que abrange múltiplos microsserviços (ex.: reservar estoque, cobrar pagamento, agendar envio), sem usar uma transação distribuída ACID entre eles. Qual padrão permite compor essa operação como uma sequência de transações locais, cada uma com uma ação de compensação em caso de falha em uma etapa posterior?',
    'O padrão Saga compõe uma operação de negócio distribuída como uma sequência de transações locais independentes; se uma etapa falhar, ações de compensação desfazem (de forma lógica) o efeito das etapas já concluídas, evitando a necessidade de uma transação distribuída bloqueante.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Um fluxo de negócio precisa coordenar uma operação que abrange múltiplos microsserviços (ex.: reservar estoque, cobrar pagamento, agendar envio), sem usar uma transação distribuída ACID entre eles. Qual padrão permite compor essa operação como uma sequência de transações locais, cada uma com uma ação de compensação em caso de falha em uma etapa posterior?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Saga', true),
    ((SELECT id FROM question WHERE enunciado = 'Um fluxo de negócio precisa coordenar uma operação que abrange múltiplos microsserviços (ex.: reservar estoque, cobrar pagamento, agendar envio), sem usar uma transação distribuída ACID entre eles. Qual padrão permite compor essa operação como uma sequência de transações locais, cada uma com uma ação de compensação em caso de falha em uma etapa posterior?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'CQRS', false),
    ((SELECT id FROM question WHERE enunciado = 'Um fluxo de negócio precisa coordenar uma operação que abrange múltiplos microsserviços (ex.: reservar estoque, cobrar pagamento, agendar envio), sem usar uma transação distribuída ACID entre eles. Qual padrão permite compor essa operação como uma sequência de transações locais, cada uma com uma ação de compensação em caso de falha em uma etapa posterior?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Arquitetura hexagonal', false),
    ((SELECT id FROM question WHERE enunciado = 'Um fluxo de negócio precisa coordenar uma operação que abrange múltiplos microsserviços (ex.: reservar estoque, cobrar pagamento, agendar envio), sem usar uma transação distribuída ACID entre eles. Qual padrão permite compor essa operação como uma sequência de transações locais, cada uma com uma ação de compensação em caso de falha em uma etapa posterior?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Arquitetura em camadas', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'Qual padrão é usado para migrar incrementalmente um sistema legado para uma nova arquitetura, substituindo funcionalidades gradualmente enquanto o sistema antigo continua em produção, até que ele possa ser desligado por completo?',
    'O padrão Strangler Fig (cipó-estrangulador) propõe substituir um sistema legado peça por peça, roteando gradualmente o tráfego de cada funcionalidade migrada para o novo sistema, reduzindo o risco de uma reescrita completa e arriscada de uma só vez.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual padrão é usado para migrar incrementalmente um sistema legado para uma nova arquitetura, substituindo funcionalidades gradualmente enquanto o sistema antigo continua em produção, até que ele possa ser desligado por completo?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Strangler Fig', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual padrão é usado para migrar incrementalmente um sistema legado para uma nova arquitetura, substituindo funcionalidades gradualmente enquanto o sistema antigo continua em produção, até que ele possa ser desligado por completo?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Event sourcing', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual padrão é usado para migrar incrementalmente um sistema legado para uma nova arquitetura, substituindo funcionalidades gradualmente enquanto o sistema antigo continua em produção, até que ele possa ser desligado por completo?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'CQRS', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual padrão é usado para migrar incrementalmente um sistema legado para uma nova arquitetura, substituindo funcionalidades gradualmente enquanto o sistema antigo continua em produção, até que ele possa ser desligado por completo?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Arquitetura pipe-and-filter', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000002',
    'Qual é uma diferença comumente citada entre SOA (Service-Oriented Architecture) tradicional e microsserviços?',
    'SOA tradicional costuma concentrar orquestração, transformação de mensagens e regras de roteamento em um barramento de serviço corporativo (ESB) centralizado; microsserviços favorecem serviços mais autônomos e leves, com comunicação direta e menos lógica centralizada no meio de transporte.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual é uma diferença comumente citada entre SOA (Service-Oriented Architecture) tradicional e microsserviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'SOA tradicional costuma centralizar orquestração e roteamento em um barramento de serviço corporativo (ESB), enquanto microsserviços favorecem comunicação mais direta e leve entre serviços', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual é uma diferença comumente citada entre SOA (Service-Oriented Architecture) tradicional e microsserviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'SOA nunca usa serviços, apenas chamadas de função locais', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é uma diferença comumente citada entre SOA (Service-Oriented Architecture) tradicional e microsserviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Microsserviços exigem obrigatoriamente um único banco de dados compartilhado entre todos os serviços', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é uma diferença comumente citada entre SOA (Service-Oriented Architecture) tradicional e microsserviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'SOA elimina completamente a necessidade de comunicação em rede entre serviços', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000003',
    'O que é uma anti-corruption layer (camada de anticorrupção), termo de Domain-Driven Design usado na integração entre dois módulos ou sistemas com modelos de domínio diferentes?',
    'Uma anti-corruption layer é uma camada de tradução colocada na fronteira entre dois modelos de domínio distintos, isolando o modelo interno das particularidades do modelo externo e evitando que conceitos ou estruturas de fora "vazem" e corrompam o modelo de domínio interno.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que é uma anti-corruption layer (camada de anticorrupção), termo de Domain-Driven Design usado na integração entre dois módulos ou sistemas com modelos de domínio diferentes?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma camada de tradução que isola o modelo de domínio interno das particularidades do modelo externo, evitando que ele "vaze" para dentro do sistema', true),
    ((SELECT id FROM question WHERE enunciado = 'O que é uma anti-corruption layer (camada de anticorrupção), termo de Domain-Driven Design usado na integração entre dois módulos ou sistemas com modelos de domínio diferentes?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma camada de segurança responsável exclusivamente por autenticação de usuários', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é uma anti-corruption layer (camada de anticorrupção), termo de Domain-Driven Design usado na integração entre dois módulos ou sistemas com modelos de domínio diferentes?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um mecanismo de cache que evita chamadas repetidas a um serviço externo', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é uma anti-corruption layer (camada de anticorrupção), termo de Domain-Driven Design usado na integração entre dois módulos ou sistemas com modelos de domínio diferentes?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma validação de esquema que impede a inserção de dados nulos no banco', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000001',
    'O que caracteriza a "arquitetura por fatias verticais" (vertical slice architecture), em contraste com a divisão horizontal tradicional por camadas técnicas?',
    'Na arquitetura por fatias verticais, o código é organizado por funcionalidade ou caso de uso de ponta a ponta (do ponto de entrada até a persistência), em vez de agrupar por tipo técnico (todos os controllers juntos, todos os repositories juntos), o que reduz a necessidade de tocar em múltiplas pastas técnicas para implementar uma única funcionalidade.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza a "arquitetura por fatias verticais" (vertical slice architecture), em contraste com a divisão horizontal tradicional por camadas técnicas?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Organiza o código por funcionalidade/caso de uso de ponta a ponta, em vez de agrupar por tipo técnico', true),
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza a "arquitetura por fatias verticais" (vertical slice architecture), em contraste com a divisão horizontal tradicional por camadas técnicas?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Elimina completamente a necessidade de qualquer camada de persistência', false),
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza a "arquitetura por fatias verticais" (vertical slice architecture), em contraste com a divisão horizontal tradicional por camadas técnicas?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Obriga que cada funcionalidade seja implantada como um microsserviço separado', false),
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza a "arquitetura por fatias verticais" (vertical slice architecture), em contraste com a divisão horizontal tradicional por camadas técnicas?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Impede que o sistema tenha mais de uma funcionalidade', false);

-- ---- DIFÍCEIS (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'Uma equipe implementa um Saga usando coreografia (cada serviço publica e reage a eventos, sem um coordenador central) para um fluxo de negócio com muitas etapas. Qual é a desvantagem mais citada dessa abordagem em comparação a uma Saga orquestrada?',
    'Na coreografia, a lógica de coordenação fica implicitamente espalhada entre os serviços que reagem a eventos uns dos outros; à medida que o número de etapas cresce, fica mais difícil visualizar, depurar e alterar o fluxo completo do processo de negócio, pois não existe um único lugar que o descreva. Uma Saga orquestrada concentra esse fluxo em um coordenador explícito, ao custo de introduzir um ponto central de coordenação.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Uma equipe implementa um Saga usando coreografia (cada serviço publica e reage a eventos, sem um coordenador central) para um fluxo de negócio com muitas etapas. Qual é a desvantagem mais citada dessa abordagem em comparação a uma Saga orquestrada?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Fica mais difícil visualizar e depurar o fluxo completo, pois a lógica de coordenação fica implicitamente espalhada entre os serviços', true),
    ((SELECT id FROM question WHERE enunciado = 'Uma equipe implementa um Saga usando coreografia (cada serviço publica e reage a eventos, sem um coordenador central) para um fluxo de negócio com muitas etapas. Qual é a desvantagem mais citada dessa abordagem em comparação a uma Saga orquestrada?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A coreografia elimina totalmente a necessidade de ações de compensação em caso de falha', false),
    ((SELECT id FROM question WHERE enunciado = 'Uma equipe implementa um Saga usando coreografia (cada serviço publica e reage a eventos, sem um coordenador central) para um fluxo de negócio com muitas etapas. Qual é a desvantagem mais citada dessa abordagem em comparação a uma Saga orquestrada?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A coreografia exige obrigatoriamente uma transação distribuída ACID entre todos os serviços', false),
    ((SELECT id FROM question WHERE enunciado = 'Uma equipe implementa um Saga usando coreografia (cada serviço publica e reage a eventos, sem um coordenador central) para um fluxo de negócio com muitas etapas. Qual é a desvantagem mais citada dessa abordagem em comparação a uma Saga orquestrada?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A coreografia garante que todos os serviços envolvidos sejam sempre implantados juntos, como um único deploy', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000003',
    'Dois módulos trocam apenas os dados estritamente necessários por meio de parâmetros simples (ex.: um identificador ou um valor numérico), em vez de passar uma estrutura inteira com campos que o módulo receptor sequer utiliza. Que tipo de acoplamento essa prática busca alcançar, considerado mais saudável do que passar estruturas completas desnecessárias?',
    'Acoplamento de dados (data coupling) ocorre quando módulos trocam apenas os dados elementares e necessários entre si; é considerado o tipo de acoplamento mais fraco entre módulos que precisam se comunicar, ao contrário do acoplamento de estampa (stamp coupling), em que uma estrutura inteira é passada mesmo que o receptor use só parte dela, aumentando a dependência desnecessária.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Dois módulos trocam apenas os dados estritamente necessários por meio de parâmetros simples (ex.: um identificador ou um valor numérico), em vez de passar uma estrutura inteira com campos que o módulo receptor sequer utiliza. Que tipo de acoplamento essa prática busca alcançar, considerado mais saudável do que passar estruturas completas desnecessárias?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Acoplamento de dados (data coupling)', true),
    ((SELECT id FROM question WHERE enunciado = 'Dois módulos trocam apenas os dados estritamente necessários por meio de parâmetros simples (ex.: um identificador ou um valor numérico), em vez de passar uma estrutura inteira com campos que o módulo receptor sequer utiliza. Que tipo de acoplamento essa prática busca alcançar, considerado mais saudável do que passar estruturas completas desnecessárias?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Acoplamento de conteúdo (content coupling)', false),
    ((SELECT id FROM question WHERE enunciado = 'Dois módulos trocam apenas os dados estritamente necessários por meio de parâmetros simples (ex.: um identificador ou um valor numérico), em vez de passar uma estrutura inteira com campos que o módulo receptor sequer utiliza. Que tipo de acoplamento essa prática busca alcançar, considerado mais saudável do que passar estruturas completas desnecessárias?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Acoplamento comum (common coupling) via variáveis globais compartilhadas', false),
    ((SELECT id FROM question WHERE enunciado = 'Dois módulos trocam apenas os dados estritamente necessários por meio de parâmetros simples (ex.: um identificador ou um valor numérico), em vez de passar uma estrutura inteira com campos que o módulo receptor sequer utiliza. Que tipo de acoplamento essa prática busca alcançar, considerado mais saudável do que passar estruturas completas desnecessárias?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Coesão coincidental', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000001',
    'Um sistema evoluiu por vários anos sem que nenhuma fronteira de camada ou módulo fosse respeitada: qualquer parte do código pode chamar diretamente qualquer outra, sem contratos claros. Como esse cenário é conhecido na literatura de arquitetura de software, e qual é sua consequência mais direta para mudanças futuras?',
    '"Big ball of mud" descreve um sistema sem estrutura arquitetural reconhecível, em que dependências se espalham livremente entre todas as partes; a consequência mais direta é que qualquer mudança local se torna arriscada, pois não há como prever com segurança quais outras partes do sistema serão afetadas por ela.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Um sistema evoluiu por vários anos sem que nenhuma fronteira de camada ou módulo fosse respeitada: qualquer parte do código pode chamar diretamente qualquer outra, sem contratos claros. Como esse cenário é conhecido na literatura de arquitetura de software, e qual é sua consequência mais direta para mudanças futuras?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     '"Big ball of mud"; qualquer mudança local se torna arriscada, pois não há como prever o alcance dos efeitos colaterais', true),
    ((SELECT id FROM question WHERE enunciado = 'Um sistema evoluiu por vários anos sem que nenhuma fronteira de camada ou módulo fosse respeitada: qualquer parte do código pode chamar diretamente qualquer outra, sem contratos claros. Como esse cenário é conhecido na literatura de arquitetura de software, e qual é sua consequência mais direta para mudanças futuras?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     '"Arquitetura evolutiva"; o sistema se torna automaticamente mais fácil de manter com o tempo', false),
    ((SELECT id FROM question WHERE enunciado = 'Um sistema evoluiu por vários anos sem que nenhuma fronteira de camada ou módulo fosse respeitada: qualquer parte do código pode chamar diretamente qualquer outra, sem contratos claros. Como esse cenário é conhecido na literatura de arquitetura de software, e qual é sua consequência mais direta para mudanças futuras?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     '"Monólito modular"; o sistema ganha fronteiras de domínio bem definidas automaticamente', false),
    ((SELECT id FROM question WHERE enunciado = 'Um sistema evoluiu por vários anos sem que nenhuma fronteira de camada ou módulo fosse respeitada: qualquer parte do código pode chamar diretamente qualquer outra, sem contratos claros. Como esse cenário é conhecido na literatura de arquitetura de software, e qual é sua consequência mais direta para mudanças futuras?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     '"Arquitetura hexagonal"; o núcleo de negócio fica automaticamente isolado de infraestrutura', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000002',
    'Uma empresa organiza suas equipes em squads por camada técnica (um squad de frontend, um de backend, um de banco de dados), mas deseja adotar microsserviços organizados por domínio de negócio (catálogo, pedidos, pagamento). Segundo a Lei de Conway, qual é o risco mais provável dessa incompatibilidade?',
    'Como a arquitetura tende a espelhar a estrutura de comunicação das equipes, squads organizados por camada técnica tendem a produzir serviços acoplados por camada (não por domínio de negócio), exigindo coordenação entre múltiplos squads para entregar uma única funcionalidade completa — justamente o oposto da autonomia de deploy que os microsserviços deveriam trazer.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Uma empresa organiza suas equipes em squads por camada técnica (um squad de frontend, um de backend, um de banco de dados), mas deseja adotar microsserviços organizados por domínio de negócio (catálogo, pedidos, pagamento). Segundo a Lei de Conway, qual é o risco mais provável dessa incompatibilidade?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Os serviços tendem a ficar acoplados por camada técnica em vez de por domínio, exigindo coordenação entre squads para entregar uma única funcionalidade de negócio', true),
    ((SELECT id FROM question WHERE enunciado = 'Uma empresa organiza suas equipes em squads por camada técnica (um squad de frontend, um de backend, um de banco de dados), mas deseja adotar microsserviços organizados por domínio de negócio (catálogo, pedidos, pagamento). Segundo a Lei de Conway, qual é o risco mais provável dessa incompatibilidade?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Nenhum risco, pois a estrutura das equipes nunca influencia a arquitetura resultante', false),
    ((SELECT id FROM question WHERE enunciado = 'Uma empresa organiza suas equipes em squads por camada técnica (um squad de frontend, um de backend, um de banco de dados), mas deseja adotar microsserviços organizados por domínio de negócio (catálogo, pedidos, pagamento). Segundo a Lei de Conway, qual é o risco mais provável dessa incompatibilidade?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Os microsserviços passam a escalar automaticamente de forma independente, resolvendo o problema organizacional', false),
    ((SELECT id FROM question WHERE enunciado = 'Uma empresa organiza suas equipes em squads por camada técnica (um squad de frontend, um de backend, um de banco de dados), mas deseja adotar microsserviços organizados por domínio de negócio (catálogo, pedidos, pagamento). Segundo a Lei de Conway, qual é o risco mais provável dessa incompatibilidade?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O sistema deixa de precisar de qualquer comunicação entre squads, independentemente da divisão de serviços', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'Diferente de simplesmente publicar eventos para notificar outros serviços sobre algo que aconteceu (event-driven architecture), o padrão event sourcing propõe que:',
    'Em event sourcing, os eventos não são apenas notificações descartáveis: eles são a fonte de verdade do estado de uma entidade, que é reconstruído reproduzindo (replay) sequencialmente todos os eventos já ocorridos sobre ela, em vez de armazenar apenas o estado atual em uma tabela.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Diferente de simplesmente publicar eventos para notificar outros serviços sobre algo que aconteceu (event-driven architecture), o padrão event sourcing propõe que:' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O estado de uma entidade seja reconstruído pelo replay sequencial de todos os eventos já ocorridos sobre ela, sendo os eventos a fonte de verdade', true),
    ((SELECT id FROM question WHERE enunciado = 'Diferente de simplesmente publicar eventos para notificar outros serviços sobre algo que aconteceu (event-driven architecture), o padrão event sourcing propõe que:' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Os eventos sejam descartados imediatamente após serem consumidos por um único serviço', false),
    ((SELECT id FROM question WHERE enunciado = 'Diferente de simplesmente publicar eventos para notificar outros serviços sobre algo que aconteceu (event-driven architecture), o padrão event sourcing propõe que:' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Nenhum estado precise ser armazenado em lugar nenhum do sistema', false),
    ((SELECT id FROM question WHERE enunciado = 'Diferente de simplesmente publicar eventos para notificar outros serviços sobre algo que aconteceu (event-driven architecture), o padrão event sourcing propõe que:' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Toda comunicação entre serviços passe a ser obrigatoriamente síncrona', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000005',
    'O que são "fitness functions" no contexto de arquitetura evolutiva?',
    'Fitness functions são mecanismos automatizados (testes, métricas ou regras de lint arquitetural) que verificam continuamente se a arquitetura ainda atende a atributos de qualidade desejados (ex.: limites de acoplamento entre módulos, tempo de resposta), permitindo detectar erosão arquitetural ao longo do tempo em vez de descobri-la só quando já é tarde para corrigir com baixo custo.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que são "fitness functions" no contexto de arquitetura evolutiva?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Mecanismos automatizados que verificam continuamente se a arquitetura ainda atende a atributos de qualidade desejados', true),
    ((SELECT id FROM question WHERE enunciado = 'O que são "fitness functions" no contexto de arquitetura evolutiva?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Funções matemáticas usadas exclusivamente para calcular o custo de infraestrutura em nuvem', false),
    ((SELECT id FROM question WHERE enunciado = 'O que são "fitness functions" no contexto de arquitetura evolutiva?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Testes manuais de aceitação executados uma única vez antes do primeiro deploy', false),
    ((SELECT id FROM question WHERE enunciado = 'O que são "fitness functions" no contexto de arquitetura evolutiva?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um algoritmo de balanceamento de carga entre instâncias de um serviço', false);
