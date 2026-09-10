-- Ampliação do pool de Questions — Domínio Arquitetura (slug 'arquitetura'), Fase 3.
-- TICKET-content-expansion-questoes-fase3.md: adiciona 18 Questions novas (6 fácil /
-- 6 média / 6 difícil) + 72 alternativas (4 por Question) às 54 já existentes em
-- V14__seed_conteudo_arquitetura.sql (18), V26__amplia_questoes_arquitetura.sql (18) e
-- V35__amplia_questoes_arquitetura_fase2.sql (18), elevando o pool para 72 Questions
-- neste domínio.
--
-- Regras (iguais às de V14/V26/V35, ver TICKET-content-database.md e
-- TICKET-content-expansion-questoes-fase3.md):
-- - Não insere Domain nem Concept novos: reaproveita os 5 Concepts já semeados por V14
--   (UUIDs literais 'a2000000-0000-4000-8000-000000000001' a '...005').
-- - content_version = 'v1', status_revisao = 'rascunho' (decisão fechada na Fase 3, ver ticket).
-- - Question e suas 4 alternativas na mesma migração, respeitando o trigger de constraint
--   adiada de V6 (trg_verificar_alternativas_question).
-- - Enunciados desta leva foram conferidos um a um contra os 18 enunciados de V14, os 18 de
--   V26 e os 18 de V35 (54 no total) para garantir ausência de duplicação literal ou de
--   reformulação que testasse o mesmo ponto de forma indistinguível. Cobrem ângulos ainda não
--   testados nas fases anteriores: Clean Architecture (regra de dependência), micro frontends,
--   service mesh, sidecar pattern, arquitetura serverless (FaaS e cold start), domain events
--   vs. integration events, contract testing, versionamento de API entre serviços, transactional
--   outbox pattern, backpressure entre serviços, aggregate root (DDD), anemic vs. rich domain
--   model e o problema de dual writes.

-- =====================================================================================
-- QUESTIONS + ALTERNATIVAS (18 novas: 6 fácil, 6 média, 6 difícil)
-- =====================================================================================

-- ---- FÁCEIS (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000001',
    'Na Clean Architecture (Robert C. Martin), qual é a regra de dependência entre as camadas concêntricas (entidades, casos de uso, interface, infraestrutura)?',
    'A regra de dependência da Clean Architecture exige que o código-fonte de camadas externas dependa de camadas internas, e nunca o inverso; as camadas internas (entidades, casos de uso) não conhecem detalhes de infraestrutura ou frameworks.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Na Clean Architecture (Robert C. Martin), qual é a regra de dependência entre as camadas concêntricas (entidades, casos de uso, interface, infraestrutura)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Dependências de código-fonte devem sempre apontar para dentro, em direção às camadas mais internas, nunca o contrário', true),
    ((SELECT id FROM question WHERE enunciado = 'Na Clean Architecture (Robert C. Martin), qual é a regra de dependência entre as camadas concêntricas (entidades, casos de uso, interface, infraestrutura)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Camadas externas e internas podem depender livremente umas das outras, sem restrição de direção', false),
    ((SELECT id FROM question WHERE enunciado = 'Na Clean Architecture (Robert C. Martin), qual é a regra de dependência entre as camadas concêntricas (entidades, casos de uso, interface, infraestrutura)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Apenas a camada de infraestrutura pode depender das demais camadas', false),
    ((SELECT id FROM question WHERE enunciado = 'Na Clean Architecture (Robert C. Martin), qual é a regra de dependência entre as camadas concêntricas (entidades, casos de uso, interface, infraestrutura)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A camada de casos de uso deve depender diretamente de frameworks e bibliotecas externas', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000002',
    'O que é a arquitetura de micro frontends?',
    'Micro frontends aplicam ao frontend o mesmo princípio de autonomia de deploy e times independentes dos microsserviços, permitindo compor uma aplicação a partir de partes desenvolvidas separadamente.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que é a arquitetura de micro frontends?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma abordagem que divide uma aplicação frontend em partes menores e independentes, desenvolvidas e implantadas separadamente por diferentes times', true),
    ((SELECT id FROM question WHERE enunciado = 'O que é a arquitetura de micro frontends?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um framework CSS que reduz o tamanho dos arquivos de frontend', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é a arquitetura de micro frontends?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma técnica de compressão de imagens para acelerar o carregamento de páginas', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é a arquitetura de micro frontends?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um padrão exclusivo para aplicações mobile nativas, sem uso em aplicações web', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'O que é um service mesh em uma arquitetura de microsserviços?',
    'Um service mesh move preocupações de comunicação entre serviços (como retries, timeouts e mTLS) para uma camada de infraestrutura dedicada, tipicamente implementada com proxies, tirando essa responsabilidade do código de cada serviço.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que é um service mesh em uma arquitetura de microsserviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma camada de infraestrutura dedicada a gerenciar a comunicação entre serviços, tipicamente via proxies implantados ao lado de cada serviço', true),
    ((SELECT id FROM question WHERE enunciado = 'O que é um service mesh em uma arquitetura de microsserviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um banco de dados distribuído usado exclusivamente para armazenar logs de aplicação', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é um service mesh em uma arquitetura de microsserviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um framework de frontend para construir interfaces reativas', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é um service mesh em uma arquitetura de microsserviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma ferramenta de CI/CD para automatizar o deploy de containers', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'No padrão sidecar, como uma funcionalidade auxiliar (ex.: proxy de rede, coleta de métricas) é normalmente implantada em relação ao serviço principal?',
    'O padrão sidecar implanta a funcionalidade auxiliar como um processo/container separado que acompanha o serviço principal na mesma unidade de deploy, permitindo adicionar capacidades (proxy, métricas) sem alterar o código do serviço.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'No padrão sidecar, como uma funcionalidade auxiliar (ex.: proxy de rede, coleta de métricas) é normalmente implantada em relação ao serviço principal?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Como um processo ou container separado, implantado junto ao serviço principal na mesma unidade de deploy, compartilhando seu ciclo de vida', true),
    ((SELECT id FROM question WHERE enunciado = 'No padrão sidecar, como uma funcionalidade auxiliar (ex.: proxy de rede, coleta de métricas) é normalmente implantada em relação ao serviço principal?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Como parte do mesmo binário do serviço principal, compilada junto ao código de negócio', false),
    ((SELECT id FROM question WHERE enunciado = 'No padrão sidecar, como uma funcionalidade auxiliar (ex.: proxy de rede, coleta de métricas) é normalmente implantada em relação ao serviço principal?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Como um serviço completamente independente, implantado em outro cluster sem qualquer relação de ciclo de vida', false),
    ((SELECT id FROM question WHERE enunciado = 'No padrão sidecar, como uma funcionalidade auxiliar (ex.: proxy de rede, coleta de métricas) é normalmente implantada em relação ao serviço principal?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Como uma biblioteca estática vinculada em tempo de compilação ao serviço principal', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000001',
    'O que caracteriza a arquitetura serverless (Function as a Service)?',
    'Em arquitetura serverless, o provedor de nuvem gerencia o provisionamento e escalonamento automático da infraestrutura, executando o código em funções efêmeras cobradas por execução — o time não precisa administrar servidores diretamente.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza a arquitetura serverless (Function as a Service)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O código é executado em funções efêmeras gerenciadas pelo provedor de nuvem, que provisiona e escala a infraestrutura automaticamente conforme a demanda', true),
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza a arquitetura serverless (Function as a Service)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A aplicação é executada permanentemente em um único servidor dedicado, sem qualquer intervenção do provedor de nuvem', false),
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza a arquitetura serverless (Function as a Service)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Elimina completamente a necessidade de qualquer código de backend', false),
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza a arquitetura serverless (Function as a Service)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Exige que o time gerencie manualmente o número de servidores físicos em produção', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'Qual é a principal diferença entre um domain event e um integration event em uma arquitetura orientada a eventos?',
    'Domain events comunicam mudanças dentro das fronteiras de um mesmo módulo/domínio, enquanto integration events são publicados intencionalmente para consumo por outros serviços, geralmente exigindo maior cuidado com estabilidade de contrato e compatibilidade.',
    'facil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual é a principal diferença entre um domain event e um integration event em uma arquitetura orientada a eventos?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um domain event é interno a um módulo/serviço, enquanto um integration event é publicado deliberadamente para comunicar outros serviços', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual é a principal diferença entre um domain event e um integration event em uma arquitetura orientada a eventos?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Domain events são sempre síncronos, enquanto integration events são sempre assíncronos', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é a principal diferença entre um domain event e um integration event em uma arquitetura orientada a eventos?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Não existe diferença prática entre os dois termos, são sinônimos usados de forma intercambiável', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é a principal diferença entre um domain event e um integration event em uma arquitetura orientada a eventos?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Integration events só podem ser usados dentro do mesmo processo, nunca entre serviços diferentes', false);

-- ---- MÉDIAS (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000005',
    'O que é contract testing (teste de contrato) no contexto de comunicação entre serviços?',
    'Contract testing (frequentemente consumer-driven) permite verificar, de forma automatizada e isolada, se um serviço provedor continua atendendo às expectativas de seus consumidores, detectando quebras de contrato antes de chegarem à produção.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que é contract testing (teste de contrato) no contexto de comunicação entre serviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma prática em que o consumidor define expectativas sobre a resposta de um provedor, verificadas automaticamente contra o provedor real, sem exigir um ambiente de integração completo', true),
    ((SELECT id FROM question WHERE enunciado = 'O que é contract testing (teste de contrato) no contexto de comunicação entre serviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um teste manual realizado apenas uma vez, antes da assinatura de um contrato comercial entre empresas', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é contract testing (teste de contrato) no contexto de comunicação entre serviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Um teste que substitui completamente a necessidade de testes unitários no serviço provedor', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é contract testing (teste de contrato) no contexto de comunicação entre serviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Uma verificação de performance que mede apenas o tempo de resposta de uma API', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000005',
    'Ao evoluir uma API consumida por múltiplos serviços, qual prática reduz o risco de quebrar consumidores existentes?',
    'Versionar a API e manter a versão anterior disponível durante um período de transição permite que consumidores migrem no próprio ritmo, evitando quebras inesperadas causadas por mudanças incompatíveis aplicadas diretamente na versão em uso.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Ao evoluir uma API consumida por múltiplos serviços, qual prática reduz o risco de quebrar consumidores existentes?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Introduzir mudanças incompatíveis em uma nova versão da API, mantendo a versão anterior disponível até que todos os consumidores migrem', true),
    ((SELECT id FROM question WHERE enunciado = 'Ao evoluir uma API consumida por múltiplos serviços, qual prática reduz o risco de quebrar consumidores existentes?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Alterar o formato de campos existentes na mesma versão da API já publicada, sem aviso prévio aos consumidores', false),
    ((SELECT id FROM question WHERE enunciado = 'Ao evoluir uma API consumida por múltiplos serviços, qual prática reduz o risco de quebrar consumidores existentes?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Remover endpoints antigos imediatamente após publicar uma nova versão, sem período de transição', false),
    ((SELECT id FROM question WHERE enunciado = 'Ao evoluir uma API consumida por múltiplos serviços, qual prática reduz o risco de quebrar consumidores existentes?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Deixar de documentar mudanças de API para simplificar o processo de release', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'Qual problema o padrão transactional outbox resolve ao integrar a escrita em banco de dados com a publicação de um evento?',
    'O outbox pattern grava o evento a ser publicado na mesma transação local que a mudança de estado (em uma tabela de outbox), e um processo separado garante a publicação posterior, evitando o problema de dual writes entre banco de dados e broker de mensagens.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual problema o padrão transactional outbox resolve ao integrar a escrita em banco de dados com a publicação de um evento?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A inconsistência que ocorre quando a escrita no banco é bem-sucedida mas a publicação do evento falha (ou vice-versa), pois ambas não fazem parte da mesma transação atômica', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual problema o padrão transactional outbox resolve ao integrar a escrita em banco de dados com a publicação de um evento?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A necessidade de criptografar dados sensíveis antes de armazená-los no banco de dados', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual problema o padrão transactional outbox resolve ao integrar a escrita em banco de dados com a publicação de um evento?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A lentidão de consultas complexas em tabelas com muitos índices', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual problema o padrão transactional outbox resolve ao integrar a escrita em banco de dados com a publicação de um evento?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A duplicação de código entre camadas de apresentação e persistência', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000001',
    'O que é backpressure em uma comunicação entre serviços, e por que é relevante arquiteturalmente?',
    'Backpressure é o mecanismo de controle de fluxo em que o consumidor comunica sua capacidade real de processamento ao produtor, evitando sobrecarga; sua ausência é uma causa comum de falhas em cascata em sistemas com comunicação assíncrona ou streaming.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que é backpressure em uma comunicação entre serviços, e por que é relevante arquiteturalmente?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'É o mecanismo pelo qual um serviço consumidor sinaliza ao produtor que não consegue processar dados na taxa em que estão sendo enviados, evitando sobrecarga', true),
    ((SELECT id FROM question WHERE enunciado = 'O que é backpressure em uma comunicação entre serviços, e por que é relevante arquiteturalmente?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'É a técnica de armazenar em cache todas as respostas de um serviço para reduzir chamadas futuras', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é backpressure em uma comunicação entre serviços, e por que é relevante arquiteturalmente?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'É o processo de reverter automaticamente um deploy quando uma métrica de erro ultrapassa um limite', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é backpressure em uma comunicação entre serviços, e por que é relevante arquiteturalmente?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'É a criptografia aplicada ao tráfego de rede entre dois serviços', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000003',
    'No contexto de Domain-Driven Design, qual é o papel de um aggregate root dentro de um agregado?',
    'O aggregate root é o ponto de entrada único de um agregado, garantindo que as invariantes de negócio do conjunto de entidades relacionadas sejam respeitadas; acessar entidades internas do agregado diretamente, sem passar pela raiz, quebra essa garantia de consistência.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'No contexto de Domain-Driven Design, qual é o papel de um aggregate root dentro de um agregado?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'É a única entidade do agregado acessível externamente, responsável por garantir a consistência das regras de negócio internas ao agregado', true),
    ((SELECT id FROM question WHERE enunciado = 'No contexto de Domain-Driven Design, qual é o papel de um aggregate root dentro de um agregado?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'É a entidade do agregado com o maior número de atributos', false),
    ((SELECT id FROM question WHERE enunciado = 'No contexto de Domain-Driven Design, qual é o papel de um aggregate root dentro de um agregado?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'É um componente de infraestrutura responsável por persistir todas as entidades do sistema', false),
    ((SELECT id FROM question WHERE enunciado = 'No contexto de Domain-Driven Design, qual é o papel de um aggregate root dentro de um agregado?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'É a camada responsável por autenticação de usuários dentro de um módulo', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000003',
    'O que caracteriza um "anemic domain model" (modelo de domínio anêmico), considerado um antipadrão em Domain-Driven Design?',
    'No modelo anêmico, entidades viram apenas estruturas de dados, e a lógica de negócio migra para services externos; isso é considerado um antipadrão porque separa dados e comportamento, enfraquecendo a coesão do domínio.',
    'media', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza um "anemic domain model" (modelo de domínio anêmico), considerado um antipadrão em Domain-Driven Design?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'As classes de domínio contêm apenas dados (getters/setters), enquanto toda a lógica de negócio fica concentrada em classes de serviço externas', true),
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza um "anemic domain model" (modelo de domínio anêmico), considerado um antipadrão em Domain-Driven Design?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'As classes de domínio contêm tanto dados quanto as regras de negócio que operam sobre eles, sem depender de serviços externos', false),
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza um "anemic domain model" (modelo de domínio anêmico), considerado um antipadrão em Domain-Driven Design?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O modelo de domínio não possui nenhuma classe, apenas tabelas de banco de dados', false),
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza um "anemic domain model" (modelo de domínio anêmico), considerado um antipadrão em Domain-Driven Design?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'As classes de domínio são implementadas exclusivamente como funções puras sem estado', false);

-- ---- DIFÍCEIS (6) ----

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'Um serviço grava um novo pedido em seu banco de dados e, na sequência, faz uma chamada separada para publicar um evento "PedidoCriado" em um broker de mensagens. Depois de o banco confirmar a escrita, a aplicação cai antes de publicar o evento. Qual é o nome desse problema e qual é uma mitigação arquitetural comum?',
    'Escrever em dois sistemas distintos (banco e broker) sem uma transação que cubra ambos é o problema de dual writes: uma das duas escritas pode falhar isoladamente, gerando inconsistência. O outbox pattern resolve isso tornando a escrita do evento parte da mesma transação local, publicando-o de forma assíncrona e confiável depois.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Um serviço grava um novo pedido em seu banco de dados e, na sequência, faz uma chamada separada para publicar um evento "PedidoCriado" em um broker de mensagens. Depois de o banco confirmar a escrita, a aplicação cai antes de publicar o evento. Qual é o nome desse problema e qual é uma mitigação arquitetural comum?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O problema é conhecido como dual writes; uma mitigação comum é o padrão transactional outbox, que grava o evento na mesma transação local da escrita de negócio', true),
    ((SELECT id FROM question WHERE enunciado = 'Um serviço grava um novo pedido em seu banco de dados e, na sequência, faz uma chamada separada para publicar um evento "PedidoCriado" em um broker de mensagens. Depois de o banco confirmar a escrita, a aplicação cai antes de publicar o evento. Qual é o nome desse problema e qual é uma mitigação arquitetural comum?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O problema é a violação de acoplamento de conteúdo, mitigado adotando CQRS entre o banco e o broker', false),
    ((SELECT id FROM question WHERE enunciado = 'Um serviço grava um novo pedido em seu banco de dados e, na sequência, faz uma chamada separada para publicar um evento "PedidoCriado" em um broker de mensagens. Depois de o banco confirmar a escrita, a aplicação cai antes de publicar o evento. Qual é o nome desse problema e qual é uma mitigação arquitetural comum?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O problema é uma falha de coesão do serviço, mitigado dividindo-o em mais microsserviços', false),
    ((SELECT id FROM question WHERE enunciado = 'Um serviço grava um novo pedido em seu banco de dados e, na sequência, faz uma chamada separada para publicar um evento "PedidoCriado" em um broker de mensagens. Depois de o banco confirmar a escrita, a aplicação cai antes de publicar o evento. Qual é o nome desse problema e qual é uma mitigação arquitetural comum?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O problema é causado exclusivamente por uma arquitetura em camadas mal aplicada, mitigado eliminando a camada de Service', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'Em um sistema com múltiplos microsserviços que já usa um API Gateway para tráfego externo, qual é a principal diferença de escopo ao adicionar também um service mesh?',
    'API Gateway e service mesh atuam em escopos diferentes e complementares: o gateway concentra o tráfego que entra no sistema vindo de fora (norte-sul), enquanto o service mesh gerencia a comunicação entre serviços internos (leste-oeste), com preocupações como retries, mTLS e observabilidade distribuída.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Em um sistema com múltiplos microsserviços que já usa um API Gateway para tráfego externo, qual é a principal diferença de escopo ao adicionar também um service mesh?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O API Gateway cuida do tráfego norte-sul (de clientes externos para dentro do sistema), enquanto o service mesh cuida do tráfego leste-oeste (entre os serviços internos)', true),
    ((SELECT id FROM question WHERE enunciado = 'Em um sistema com múltiplos microsserviços que já usa um API Gateway para tráfego externo, qual é a principal diferença de escopo ao adicionar também um service mesh?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Os dois cumprem exatamente a mesma função, tornando um deles sempre redundante e descartável', false),
    ((SELECT id FROM question WHERE enunciado = 'Em um sistema com múltiplos microsserviços que já usa um API Gateway para tráfego externo, qual é a principal diferença de escopo ao adicionar também um service mesh?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O service mesh substitui a necessidade de qualquer comunicação em rede entre serviços, tornando-a local', false),
    ((SELECT id FROM question WHERE enunciado = 'Em um sistema com múltiplos microsserviços que já usa um API Gateway para tráfego externo, qual é a principal diferença de escopo ao adicionar também um service mesh?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O API Gateway é responsável apenas por armazenar dados, enquanto o service mesh cuida de toda a lógica de negócio', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000001',
    'Em um sistema estruturado com Clean Architecture, uma classe de caso de uso (camada de aplicação) importa diretamente uma classe de entidade do ORM pertencente à camada de infraestrutura, para simplificar o código. Qual princípio da Clean Architecture essa prática viola?',
    'A regra de dependência da Clean Architecture exige que o fluxo de dependências aponte sempre das camadas externas para as internas; quando um caso de uso depende diretamente de uma classe de infraestrutura, essa direção é invertida, acoplando a lógica de aplicação a um detalhe técnico que deveria estar isolado atrás de uma interface.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Em um sistema estruturado com Clean Architecture, uma classe de caso de uso (camada de aplicação) importa diretamente uma classe de entidade do ORM pertencente à camada de infraestrutura, para simplificar o código. Qual princípio da Clean Architecture essa prática viola?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A regra de dependência: camadas internas não devem depender de detalhes de camadas externas, apenas o contrário, via uma interface definida pela camada interna', true),
    ((SELECT id FROM question WHERE enunciado = 'Em um sistema estruturado com Clean Architecture, uma classe de caso de uso (camada de aplicação) importa diretamente uma classe de entidade do ORM pertencente à camada de infraestrutura, para simplificar o código. Qual princípio da Clean Architecture essa prática viola?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O princípio de responsabilidade única, pois um caso de uso não pode depender de nenhuma outra classe', false),
    ((SELECT id FROM question WHERE enunciado = 'Em um sistema estruturado com Clean Architecture, uma classe de caso de uso (camada de aplicação) importa diretamente uma classe de entidade do ORM pertencente à camada de infraestrutura, para simplificar o código. Qual princípio da Clean Architecture essa prática viola?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A separação entre leitura e escrita definida pelo CQRS, que é obrigatória em toda Clean Architecture', false),
    ((SELECT id FROM question WHERE enunciado = 'Em um sistema estruturado com Clean Architecture, uma classe de caso de uso (camada de aplicação) importa diretamente uma classe de entidade do ORM pertencente à camada de infraestrutura, para simplificar o código. Qual princípio da Clean Architecture essa prática viola?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'O padrão Strangler Fig, que exige migração incremental de qualquer dependência de infraestrutura', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000004',
    'Uma equipe adota o padrão sidecar para adicionar proxy de rede e coleta de métricas a centenas de instâncias de serviços em produção. Qual é um custo real e frequentemente citado dessa abordagem?',
    'Como o sidecar roda como um processo/container adicional ao lado de cada instância do serviço principal, seu custo de CPU e memória se multiplica pelo número de instâncias em produção — um trade-off real que cresce com a escala do sistema, mesmo trazendo benefícios de padronização de rede e observabilidade.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Uma equipe adota o padrão sidecar para adicionar proxy de rede e coleta de métricas a centenas de instâncias de serviços em produção. Qual é um custo real e frequentemente citado dessa abordagem?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Overhead de recursos computacionais (CPU e memória) multiplicado pelo número de instâncias, já que cada sidecar roda como um processo adicional', true),
    ((SELECT id FROM question WHERE enunciado = 'Uma equipe adota o padrão sidecar para adicionar proxy de rede e coleta de métricas a centenas de instâncias de serviços em produção. Qual é um custo real e frequentemente citado dessa abordagem?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A impossibilidade de coletar métricas de rede, já que o sidecar não tem acesso ao tráfego do serviço principal', false),
    ((SELECT id FROM question WHERE enunciado = 'Uma equipe adota o padrão sidecar para adicionar proxy de rede e coleta de métricas a centenas de instâncias de serviços em produção. Qual é um custo real e frequentemente citado dessa abordagem?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A obrigatoriedade de reescrever toda a lógica de negócio dos serviços em uma nova linguagem', false),
    ((SELECT id FROM question WHERE enunciado = 'Uma equipe adota o padrão sidecar para adicionar proxy de rede e coleta de métricas a centenas de instâncias de serviços em produção. Qual é um custo real e frequentemente citado dessa abordagem?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'A eliminação completa da necessidade de qualquer observabilidade adicional no sistema', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000002',
    'Uma função serverless que processa requisições de um endpoint crítico apresenta latência elevada nas primeiras chamadas após um período sem uso, mas latência normal em chamadas subsequentes. Qual conceito explica esse comportamento e é um trade-off conhecido da arquitetura serverless?',
    'Cold start é o tempo adicional gasto pelo provedor para inicializar um novo ambiente de execução quando não há instância pré-aquecida disponível; é um trade-off conhecido de arquiteturas serverless, especialmente relevante para endpoints com latência crítica e picos de uso intermitentes.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Uma função serverless que processa requisições de um endpoint crítico apresenta latência elevada nas primeiras chamadas após um período sem uso, mas latência normal em chamadas subsequentes. Qual conceito explica esse comportamento e é um trade-off conhecido da arquitetura serverless?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Cold start: quando não há instância da função já aquecida, o provedor precisa provisionar um novo ambiente de execução antes de processar a requisição', true),
    ((SELECT id FROM question WHERE enunciado = 'Uma função serverless que processa requisições de um endpoint crítico apresenta latência elevada nas primeiras chamadas após um período sem uso, mas latência normal em chamadas subsequentes. Qual conceito explica esse comportamento e é um trade-off conhecido da arquitetura serverless?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Backpressure: o provedor está sinalizando que a função está recebendo mais requisições do que pode processar', false),
    ((SELECT id FROM question WHERE enunciado = 'Uma função serverless que processa requisições de um endpoint crítico apresenta latência elevada nas primeiras chamadas após um período sem uso, mas latência normal em chamadas subsequentes. Qual conceito explica esse comportamento e é um trade-off conhecido da arquitetura serverless?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Dual writes: a função está tentando escrever em dois bancos de dados diferentes na mesma chamada', false),
    ((SELECT id FROM question WHERE enunciado = 'Uma função serverless que processa requisições de um endpoint crítico apresenta latência elevada nas primeiras chamadas após um período sem uso, mas latência normal em chamadas subsequentes. Qual conceito explica esse comportamento e é um trade-off conhecido da arquitetura serverless?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Acoplamento de conteúdo: a função depende de detalhes internos de outra função serverless', false);

INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES (
    (SELECT id FROM domain WHERE slug = 'arquitetura'),
    'a2000000-0000-4000-8000-000000000005',
    'Um serviço provedor remove um campo de sua resposta JSON considerado "não utilizado", sem consultar os times consumidores. Dias depois, um serviço consumidor quebra em produção porque dependia justamente desse campo. Qual prática, se adotada previamente, teria mais chance de detectar essa quebra antes do deploy do provedor?',
    'Contract testing existe exatamente para esse cenário: ao rodar, no pipeline do provedor, os testes que expressam as expectativas reais dos consumidores, uma mudança que quebra um contrato existente é detectada antes de chegar à produção, sem exigir um ambiente de integração completo com todos os consumidores.',
    'dificil', 'v1', 'rascunho'
);
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Um serviço provedor remove um campo de sua resposta JSON considerado "não utilizado", sem consultar os times consumidores. Dias depois, um serviço consumidor quebra em produção porque dependia justamente desse campo. Qual prática, se adotada previamente, teria mais chance de detectar essa quebra antes do deploy do provedor?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Contract testing: os testes de contrato definidos pelos consumidores, executados no pipeline do provedor, teriam falhado ao detectar que o campo removido ainda era esperado por um consumidor', true),
    ((SELECT id FROM question WHERE enunciado = 'Um serviço provedor remove um campo de sua resposta JSON considerado "não utilizado", sem consultar os times consumidores. Dias depois, um serviço consumidor quebra em produção porque dependia justamente desse campo. Qual prática, se adotada previamente, teria mais chance de detectar essa quebra antes do deploy do provedor?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Arquitetura em camadas: adicionar mais uma camada entre provedor e consumidor teria evitado a quebra automaticamente', false),
    ((SELECT id FROM question WHERE enunciado = 'Um serviço provedor remove um campo de sua resposta JSON considerado "não utilizado", sem consultar os times consumidores. Dias depois, um serviço consumidor quebra em produção porque dependia justamente desse campo. Qual prática, se adotada previamente, teria mais chance de detectar essa quebra antes do deploy do provedor?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'CQRS: separar o modelo de leitura do de escrita no provedor eliminaria a necessidade desse campo', false),
    ((SELECT id FROM question WHERE enunciado = 'Um serviço provedor remove um campo de sua resposta JSON considerado "não utilizado", sem consultar os times consumidores. Dias depois, um serviço consumidor quebra em produção porque dependia justamente desse campo. Qual prática, se adotada previamente, teria mais chance de detectar essa quebra antes do deploy do provedor?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'arquitetura')),
     'Sidecar: adicionar um proxy de rede ao lado do serviço provedor teria impedido a remoção do campo', false);
