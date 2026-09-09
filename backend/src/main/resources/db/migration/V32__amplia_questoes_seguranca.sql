-- Ampliação do pool de Questions — Domínio Segurança (Fase 1: 18 -> 36)
-- Origem: docs/product/tickets/TICKET-content-expansion-questoes.md (+ ticket mestre
-- TICKET-content-database.md). Autoria assistida por IA, rascunho técnico, sujeito a
-- revisão humana obrigatória antes de status_revisao = 'revisado_aprovado'.
--
-- Escopo desta migração: SOMENTE Question + Alternativas (nenhum Concept/Slide/Flashcard
-- novo). Reaproveita os 5 Concepts já existentes do domínio 'seguranca', inseridos em
-- V20__seed_conteudo_seguranca.sql (mesmos UUIDs literais):
--   a5000000-0000-4000-8000-000000000001 Autenticação e Autorização
--   a5000000-0000-4000-8000-000000000002 Criptografia Aplicada
--   a5000000-0000-4000-8000-000000000003 TLS e Segurança em Trânsito
--   a5000000-0000-4000-8000-000000000004 Vulnerabilidades Comuns em Aplicações Web
--   a5000000-0000-4000-8000-000000000005 Defesa em Profundidade e Controle de Abuso
--
-- domain_ref usa subquery por slug (mesmo padrão do V20). content_version = 'v1' e
-- status_revisao = 'rascunho' em todas as linhas (mesma leva lógica do lote original,
-- conforme decisão registrada no ticket de ampliação).
--
-- Não-duplicação: V20 foi lido integralmente antes de escrever este arquivo. As 18
-- Questions abaixo cobrem ângulos e mecanismos distintos dos 18 enunciados já existentes
-- naquele arquivo (nenhuma reformulação disfarçada do mesmo ponto) — ver detalhamento no
-- retorno da tarefa.
--
-- 18 Questions novas (6 facil / 6 media / 6 dificil) com 4 alternativas cada (1 correta).
-- Question + suas 4 alternativas inseridas na mesma transação (migração Flyway já roda em
-- transação única), satisfazendo o trigger de constraint adiada de V6.

-- =====================================================================================
-- QUESTIONS + ALTERNATIVAS (18 novas: 6 facil, 6 media, 6 dificil)
-- =====================================================================================

-- FÁCIL 1
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000001',
        'O que é armazenado no header de um JWT?',
        'O header de um JWT contém metadados sobre o próprio token, como o algoritmo de assinatura usado e o tipo do token — não contém dados do usuário (isso fica no payload) nem a assinatura em si (isso fica na terceira parte).',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que é armazenado no header de um JWT?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Metadados como o algoritmo de assinatura usado e o tipo do token.', true),
    ((SELECT id FROM question WHERE enunciado = 'O que é armazenado no header de um JWT?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'A senha do usuário, cifrada com a chave privada do servidor.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é armazenado no header de um JWT?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'A lista completa de permissões do usuário no sistema.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é armazenado no header de um JWT?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'O certificado TLS do servidor que emitiu o token.', false);

-- FÁCIL 2
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000002',
        'Qual das opções abaixo é um exemplo de algoritmo de criptografia simétrica?',
        'AES (Advanced Encryption Standard) é um algoritmo de criptografia simétrica amplamente usado, onde a mesma chave é usada para cifrar e decifrar os dados.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual das opções abaixo é um exemplo de algoritmo de criptografia simétrica?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'AES.', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual das opções abaixo é um exemplo de algoritmo de criptografia simétrica?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'RSA.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual das opções abaixo é um exemplo de algoritmo de criptografia simétrica?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Curvas elípticas (ECC).', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual das opções abaixo é um exemplo de algoritmo de criptografia simétrica?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Diffie-Hellman.', false);

-- FÁCIL 3
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000002',
        'Qual o propósito de adicionar um salt único a cada senha antes de aplicar a função de hash?',
        'O salt garante que duas senhas idênticas gerem hashes diferentes, neutralizando o uso de tabelas pré-computadas (rainbow tables) contra o banco de hashes armazenado.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual o propósito de adicionar um salt único a cada senha antes de aplicar a função de hash?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Evitar que senhas idênticas gerem o mesmo hash, neutralizando tabelas pré-computadas.', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual o propósito de adicionar um salt único a cada senha antes de aplicar a função de hash?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Tornar o hash reversível para permitir recuperação da senha original.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual o propósito de adicionar um salt único a cada senha antes de aplicar a função de hash?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Reduzir o tamanho do hash armazenado no banco de dados.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual o propósito de adicionar um salt único a cada senha antes de aplicar a função de hash?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Permitir que o servidor decifre a senha durante o login.', false);

-- FÁCIL 4
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000003',
        'O que HTTPS adiciona, em termos práticos, em relação ao HTTP simples?',
        'HTTPS é HTTP transportado sobre uma camada TLS, que cifra a comunicação entre cliente e servidor e autentica o servidor por meio de um certificado — o protocolo de aplicação (HTTP) em si não muda.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que HTTPS adiciona, em termos práticos, em relação ao HTTP simples?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Uma camada TLS que cifra a comunicação e autentica o servidor via certificado.', true),
    ((SELECT id FROM question WHERE enunciado = 'O que HTTPS adiciona, em termos práticos, em relação ao HTTP simples?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Um formato de mensagem totalmente diferente do HTTP, incompatível com navegadores antigos.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que HTTPS adiciona, em termos práticos, em relação ao HTTP simples?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Validação automática do conteúdo da aplicação contra XSS e SQL injection.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que HTTPS adiciona, em termos práticos, em relação ao HTTP simples?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Compressão obrigatória do corpo da resposta para reduzir latência.', false);

-- FÁCIL 5
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000004',
        'Qual é o propósito de uma Content Security Policy (CSP)?',
        'CSP é um cabeçalho HTTP que declara de quais origens o navegador pode carregar e executar scripts (e outros recursos), funcionando como uma camada de defesa adicional contra XSS ao restringir o que pode rodar na página mesmo se um payload malicioso for injetado.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual é o propósito de uma Content Security Policy (CSP)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Restringir de quais origens o navegador pode carregar e executar scripts, mitigando XSS.', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o propósito de uma Content Security Policy (CSP)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Cifrar o tráfego HTTP entre cliente e servidor.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o propósito de uma Content Security Policy (CSP)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Impedir ataques de força bruta contra o formulário de login.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o propósito de uma Content Security Policy (CSP)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Validar automaticamente queries SQL antes de serem executadas no banco.', false);

-- FÁCIL 6
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000005',
        'O que é RBAC (Role-Based Access Control)?',
        'RBAC é um modelo de controle de acesso em que permissões são atribuídas a papéis (roles), e usuários recebem papéis — em vez de atribuir permissões individualmente a cada usuário, o que facilita a aplicação consistente do princípio do menor privilégio em larga escala.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que é RBAC (Role-Based Access Control)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Um modelo em que permissões são atribuídas a papéis, e usuários recebem papéis, em vez de permissões individuais.', true),
    ((SELECT id FROM question WHERE enunciado = 'O que é RBAC (Role-Based Access Control)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Um protocolo de criptografia assimétrica usado para autenticação de servidores.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é RBAC (Role-Based Access Control)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Um algoritmo de rate limiting baseado em janelas deslizantes.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é RBAC (Role-Based Access Control)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Uma técnica de cifragem de senhas alternativa ao bcrypt.', false);

-- MÉDIA 1
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000001',
        'Qual a principal diferença entre o fluxo Client Credentials e o fluxo Authorization Code do OAuth2?',
        'Client Credentials é usado para comunicação máquina-a-máquina, sem um usuário final envolvido — a própria aplicação se autentica diretamente com o servidor de autorização usando suas próprias credenciais. Authorization Code, por outro lado, é usado quando há um usuário que precisa autenticar-se e autorizar explicitamente o acesso.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual a principal diferença entre o fluxo Client Credentials e o fluxo Authorization Code do OAuth2?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Client Credentials é para comunicação máquina-a-máquina sem usuário final; Authorization Code envolve um usuário que autentica e autoriza o acesso.', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual a principal diferença entre o fluxo Client Credentials e o fluxo Authorization Code do OAuth2?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Client Credentials sempre gera tokens de vida útil infinita, enquanto Authorization Code gera tokens que expiram em segundos.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual a principal diferença entre o fluxo Client Credentials e o fluxo Authorization Code do OAuth2?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Client Credentials é exclusivo do OpenID Connect e não faz parte da especificação do OAuth2.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual a principal diferença entre o fluxo Client Credentials e o fluxo Authorization Code do OAuth2?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Authorization Code não permite emissão de access tokens, apenas de refresh tokens.', false);

-- MÉDIA 2
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000001',
        'Qual é o papel de um refresh token em um sistema que usa access tokens de vida curta?',
        'O refresh token permite obter um novo access token sem exigir que o usuário refaça todo o processo de login — ele é trocado por um novo access token quando o anterior expira, mantendo a sessão efetivamente ativa com uma janela de exposição menor para o access token em si.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual é o papel de um refresh token em um sistema que usa access tokens de vida curta?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Permitir obter um novo access token sem exigir que o usuário refaça o login completo.', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o papel de um refresh token em um sistema que usa access tokens de vida curta?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Substituir a necessidade de qualquer autenticação inicial do usuário.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o papel de um refresh token em um sistema que usa access tokens de vida curta?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Cifrar o payload do access token para que ele não possa ser lido.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o papel de um refresh token em um sistema que usa access tokens de vida curta?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Aumentar automaticamente os escopos de permissão concedidos ao usuário.', false);

-- MÉDIA 3
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000002',
        'Em criptografia assimétrica, por que a chave pública pode ser distribuída livremente, mas a chave privada precisa permanecer secreta?',
        'A segurança do esquema depende de ser computacionalmente inviável derivar a chave privada a partir da chave pública correspondente; qualquer um pode usar a chave pública para cifrar dados destinados ao dono, ou verificar assinaturas feitas por ele, mas apenas quem possui a chave privada consegue decifrar esses dados ou gerar assinaturas válidas.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Em criptografia assimétrica, por que a chave pública pode ser distribuída livremente, mas a chave privada precisa permanecer secreta?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque é computacionalmente inviável derivar a chave privada a partir da chave pública correspondente.', true),
    ((SELECT id FROM question WHERE enunciado = 'Em criptografia assimétrica, por que a chave pública pode ser distribuída livremente, mas a chave privada precisa permanecer secreta?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque a chave pública é apenas um identificador textual, sem nenhuma relação matemática com a privada.', false),
    ((SELECT id FROM question WHERE enunciado = 'Em criptografia assimétrica, por que a chave pública pode ser distribuída livremente, mas a chave privada precisa permanecer secreta?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque a chave privada é sempre mais curta que a chave pública e por isso mais fácil de adivinhar.', false),
    ((SELECT id FROM question WHERE enunciado = 'Em criptografia assimétrica, por que a chave pública pode ser distribuída livremente, mas a chave privada precisa permanecer secreta?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque ambas as chaves são idênticas, e a distinção entre pública e privada é apenas uma convenção de nomenclatura.', false);

-- MÉDIA 4
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000003',
        'O que o mTLS (TLS mútuo) adiciona em relação ao uso padrão do TLS?',
        'No TLS padrão, apenas o servidor apresenta um certificado e é autenticado pelo cliente. No mTLS, o cliente também apresenta um certificado, e o servidor o valida — autenticando ambas as partes da comunicação, um padrão comum em comunicação servidor-a-servidor.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que o mTLS (TLS mútuo) adiciona em relação ao uso padrão do TLS?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Exige que o cliente também apresente um certificado, autenticando ambas as partes da comunicação.', true),
    ((SELECT id FROM question WHERE enunciado = 'O que o mTLS (TLS mútuo) adiciona em relação ao uso padrão do TLS?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Dobra a velocidade de transmissão de dados cifrados.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que o mTLS (TLS mútuo) adiciona em relação ao uso padrão do TLS?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Elimina a necessidade de Autoridades Certificadoras para o certificado do servidor.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que o mTLS (TLS mútuo) adiciona em relação ao uso padrão do TLS?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Permite que a conexão seja estabelecida sem nenhum tipo de certificado.', false);

-- MÉDIA 5
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000004',
        'Uma aplicação usa JPQL com parâmetros nomeados na maior parte do código, mas em um relatório específico monta uma query nativa concatenando um filtro informado pelo usuário diretamente na string SQL. Essa aplicação está protegida contra SQL Injection?',
        'Não integralmente: usar um ORM com prepared statements por padrão não elimina o risco se, em algum ponto, o desenvolvedor concatenar entrada do usuário manualmente em uma query nativa — a vulnerabilidade é reintroduzida exatamente nesse trecho, independentemente do restante do código estar seguro.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Uma aplicação usa JPQL com parâmetros nomeados na maior parte do código, mas em um relatório específico monta uma query nativa concatenando um filtro informado pelo usuário diretamente na string SQL. Essa aplicação está protegida contra SQL Injection?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Não, a concatenação manual na query nativa reintroduz a vulnerabilidade nesse trecho específico.', true),
    ((SELECT id FROM question WHERE enunciado = 'Uma aplicação usa JPQL com parâmetros nomeados na maior parte do código, mas em um relatório específico monta uma query nativa concatenando um filtro informado pelo usuário diretamente na string SQL. Essa aplicação está protegida contra SQL Injection?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Sim, porque o uso de um ORM em qualquer parte do sistema protege automaticamente todas as queries.', false),
    ((SELECT id FROM question WHERE enunciado = 'Uma aplicação usa JPQL com parâmetros nomeados na maior parte do código, mas em um relatório específico monta uma query nativa concatenando um filtro informado pelo usuário diretamente na string SQL. Essa aplicação está protegida contra SQL Injection?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Sim, porque queries nativas nunca são executadas diretamente contra o banco de dados.', false),
    ((SELECT id FROM question WHERE enunciado = 'Uma aplicação usa JPQL com parâmetros nomeados na maior parte do código, mas em um relatório específico monta uma query nativa concatenando um filtro informado pelo usuário diretamente na string SQL. Essa aplicação está protegida contra SQL Injection?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Não, mas apenas porque JPQL é uma linguagem insegura por definição.', false);

-- MÉDIA 6
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000005',
        'Qual a diferença central entre os algoritmos de rate limiting token bucket e sliding window?',
        'Token bucket reabastece um "balde" de tokens a uma taxa constante, e cada requisição consome um token disponível; sliding window conta requisições dentro de uma janela de tempo móvel, evitando o problema de picos concentrados exatamente na borda entre duas janelas fixas consecutivas.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual a diferença central entre os algoritmos de rate limiting token bucket e sliding window?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Token bucket reabastece tokens a taxa constante; sliding window conta requisições em uma janela de tempo móvel, evitando picos na borda de janelas fixas.', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual a diferença central entre os algoritmos de rate limiting token bucket e sliding window?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Token bucket só funciona para tráfego HTTPS, enquanto sliding window só funciona para HTTP.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual a diferença central entre os algoritmos de rate limiting token bucket e sliding window?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Sliding window bloqueia permanentemente o cliente após o primeiro excesso, enquanto token bucket nunca bloqueia.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual a diferença central entre os algoritmos de rate limiting token bucket e sliding window?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Não há diferença prática entre os dois algoritmos; são apenas nomes alternativos para a mesma técnica.', false);

-- DIFÍCIL 1
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000001',
        'Uma aplicação usa o access token do OAuth2, emitido por um provedor de terceiros, para identificar diretamente quem é o usuário logado na própria aplicação, sem usar OpenID Connect. Por que essa prática é arriscada?',
        'O OAuth2 é um protocolo de autorização, e o access token não possui um formato ou garantia padronizada de que representa de forma verificável a identidade do usuário; ele foi desenhado para autorizar acesso a um recurso, não para autenticar identidade. O OIDC existe justamente para resolver isso, adicionando o ID token, um JWT assinado com claims de identidade verificáveis pela própria aplicação.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Uma aplicação usa o access token do OAuth2, emitido por um provedor de terceiros, para identificar diretamente quem é o usuário logado na própria aplicação, sem usar OpenID Connect. Por que essa prática é arriscada?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque o access token não foi desenhado para autenticar identidade de forma verificável, apenas para autorizar acesso a um recurso.', true),
    ((SELECT id FROM question WHERE enunciado = 'Uma aplicação usa o access token do OAuth2, emitido por um provedor de terceiros, para identificar diretamente quem é o usuário logado na própria aplicação, sem usar OpenID Connect. Por que essa prática é arriscada?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque access tokens do OAuth2 sempre expiram em menos de um minuto.', false),
    ((SELECT id FROM question WHERE enunciado = 'Uma aplicação usa o access token do OAuth2, emitido por um provedor de terceiros, para identificar diretamente quem é o usuário logado na própria aplicação, sem usar OpenID Connect. Por que essa prática é arriscada?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque access tokens nunca podem ser transmitidos por HTTPS.', false),
    ((SELECT id FROM question WHERE enunciado = 'Uma aplicação usa o access token do OAuth2, emitido por um provedor de terceiros, para identificar diretamente quem é o usuário logado na própria aplicação, sem usar OpenID Connect. Por que essa prática é arriscada?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque não é possível revogar um access token em nenhuma circunstância.', false);

-- DIFÍCIL 2
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000002',
        'Por que reutilizar o mesmo par de chaves RSA tanto para cifrar dados quanto para assinar mensagens é considerado uma prática arriscada em criptografia aplicada?',
        'Usar a mesma chave para propósitos diferentes (cifragem e assinatura) pode expor o sistema a ataques que exploram a interação entre as duas operações matemáticas, permitindo em certos cenários que um atacante manipule uma operação para comprometer a outra; a prática recomendada é usar pares de chaves distintos e dedicados a cada finalidade.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Por que reutilizar o mesmo par de chaves RSA tanto para cifrar dados quanto para assinar mensagens é considerado uma prática arriscada em criptografia aplicada?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque a interação entre as duas operações matemáticas pode ser explorada, comprometendo uma operação através da outra; recomenda-se pares de chaves dedicados a cada finalidade.', true),
    ((SELECT id FROM question WHERE enunciado = 'Por que reutilizar o mesmo par de chaves RSA tanto para cifrar dados quanto para assinar mensagens é considerado uma prática arriscada em criptografia aplicada?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque o RSA não suporta assinatura digital, apenas cifragem de dados.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que reutilizar o mesmo par de chaves RSA tanto para cifrar dados quanto para assinar mensagens é considerado uma prática arriscada em criptografia aplicada?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque chaves RSA usadas para assinatura expiram automaticamente após uma única operação de cifragem.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que reutilizar o mesmo par de chaves RSA tanto para cifrar dados quanto para assinar mensagens é considerado uma prática arriscada em criptografia aplicada?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque isso obriga o uso de criptografia simétrica em paralelo, o que é incompatível com RSA.', false);

-- DIFÍCIL 3
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000003',
        'Qual o principal trade-off entre verificar revogação de certificado via OCSP (Online Certificate Status Protocol) em vez de baixar uma CRL (Certificate Revocation List) completa?',
        'OCSP consulta o status de revogação de um certificado específico em tempo real junto à CA, evitando baixar uma lista potencialmente grande de todos os certificados revogados (como faz a CRL), mas introduz uma dependência de disponibilidade e latência de rede a cada verificação — se o respondedor OCSP estiver indisponível, a validação pode falhar ou (dependendo da configuração) ser ignorada, o que é uma preocupação de segurança por si só.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual o principal trade-off entre verificar revogação de certificado via OCSP (Online Certificate Status Protocol) em vez de baixar uma CRL (Certificate Revocation List) completa?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'OCSP evita baixar uma lista completa, mas introduz dependência de disponibilidade e latência de rede a cada verificação individual.', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual o principal trade-off entre verificar revogação de certificado via OCSP (Online Certificate Status Protocol) em vez de baixar uma CRL (Certificate Revocation List) completa?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'OCSP elimina completamente a necessidade de Autoridades Certificadoras.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual o principal trade-off entre verificar revogação de certificado via OCSP (Online Certificate Status Protocol) em vez de baixar uma CRL (Certificate Revocation List) completa?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'CRL é sempre mais rápida que OCSP porque não depende de rede alguma.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual o principal trade-off entre verificar revogação de certificado via OCSP (Online Certificate Status Protocol) em vez de baixar uma CRL (Certificate Revocation List) completa?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'OCSP substitui integralmente o handshake TLS, tornando-o desnecessário.', false);

-- DIFÍCIL 4
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000004',
        'Por que a Same-Origin Policy (SOP), sozinha, não é suficiente para impedir ataques CSRF, exigindo uma defesa dedicada como o CSRF token?',
        'A SOP impede que um site malicioso leia a resposta de uma requisição feita a outro domínio, mas não impede que ele envie a requisição em si — o navegador ainda despacha a requisição (com os cookies de sessão anexados automaticamente) mesmo que o script malicioso nunca consiga ler o retorno. Como o CSRF depende apenas de a ação ser executada no servidor (não de ler a resposta), a SOP não protege contra ele; é necessário um mecanismo que valide a origem/intenção da requisição, como o CSRF token.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Por que a Same-Origin Policy (SOP), sozinha, não é suficiente para impedir ataques CSRF, exigindo uma defesa dedicada como o CSRF token?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque a SOP impede a leitura da resposta cross-site, mas não impede o envio da requisição, que é tudo que o CSRF precisa para ter efeito no servidor.', true),
    ((SELECT id FROM question WHERE enunciado = 'Por que a Same-Origin Policy (SOP), sozinha, não é suficiente para impedir ataques CSRF, exigindo uma defesa dedicada como o CSRF token?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque a SOP se aplica apenas a requisições GET, nunca a POST ou DELETE.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que a Same-Origin Policy (SOP), sozinha, não é suficiente para impedir ataques CSRF, exigindo uma defesa dedicada como o CSRF token?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque navegadores modernos desativaram a SOP por padrão para melhorar performance.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que a Same-Origin Policy (SOP), sozinha, não é suficiente para impedir ataques CSRF, exigindo uma defesa dedicada como o CSRF token?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque a SOP exige que o atacante conheça previamente o CSRF token, o que a torna redundante.', false);

-- DIFÍCIL 5
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000005',
        'Durante um pico de sobrecarga em uma dependência externa, como um circuit breaker ajuda a conter o impacto em cascata sobre o restante do sistema, complementando o rate limiting?',
        'Um circuit breaker monitora as falhas/timeouts de chamadas a uma dependência e, ao ultrapassar um limiar, "abre o circuito", passando a rejeitar novas chamadas imediatamente (sem tentar de fato chamar a dependência lenta) por um período — isso evita que threads/conexões fiquem presas esperando uma dependência degradada, o que poderia esgotar recursos e derrubar também os serviços que dependem dela, mesmo que eles próprios não estejam sobrecarregados.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Durante um pico de sobrecarga em uma dependência externa, como um circuit breaker ajuda a conter o impacto em cascata sobre o restante do sistema, complementando o rate limiting?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Rejeitando rapidamente novas chamadas à dependência degradada, evitando que threads/conexões fiquem presas e esgotem recursos em cascata.', true),
    ((SELECT id FROM question WHERE enunciado = 'Durante um pico de sobrecarga em uma dependência externa, como um circuit breaker ajuda a conter o impacto em cascata sobre o restante do sistema, complementando o rate limiting?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Aumentando automaticamente o número de conexões simultâneas permitidas para a dependência degradada.', false),
    ((SELECT id FROM question WHERE enunciado = 'Durante um pico de sobrecarga em uma dependência externa, como um circuit breaker ajuda a conter o impacto em cascata sobre o restante do sistema, complementando o rate limiting?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Cifrando o tráfego adicional gerado pela dependência sobrecarregada.', false),
    ((SELECT id FROM question WHERE enunciado = 'Durante um pico de sobrecarga em uma dependência externa, como um circuit breaker ajuda a conter o impacto em cascata sobre o restante do sistema, complementando o rate limiting?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Bloqueando permanentemente o IP de origem de todas as requisições recebidas.', false);

-- DIFÍCIL 6
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000001',
        'Vários microsserviços validam JWTs assinados com HS256 usando o mesmo segredo compartilhado entre todos eles. Qual é o risco arquitetural dessa decisão, em comparação a usar RS256?',
        'Com HS256, a mesma chave secreta é usada tanto para assinar quanto para verificar o token — qualquer serviço que precisa validar o token também precisa conhecer o segredo, e portanto também é capaz de forjar tokens válidos para todos os demais. Se um único serviço com o segredo for comprometido, um atacante pode emitir tokens forjados aceitos por toda a malha de serviços. Com RS256, apenas o emissor detém a chave privada para assinar, e os demais serviços só precisam da chave pública para verificar, sem capacidade de forjar tokens.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Vários microsserviços validam JWTs assinados com HS256 usando o mesmo segredo compartilhado entre todos eles. Qual é o risco arquitetural dessa decisão, em comparação a usar RS256?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Qualquer serviço que conhece o segredo compartilhado é capaz de forjar tokens válidos para todos os demais, ampliando o impacto de um único serviço comprometido.', true),
    ((SELECT id FROM question WHERE enunciado = 'Vários microsserviços validam JWTs assinados com HS256 usando o mesmo segredo compartilhado entre todos eles. Qual é o risco arquitetural dessa decisão, em comparação a usar RS256?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'HS256 não é um algoritmo de assinatura válido para JWT, apenas para cifragem de payload.', false),
    ((SELECT id FROM question WHERE enunciado = 'Vários microsserviços validam JWTs assinados com HS256 usando o mesmo segredo compartilhado entre todos eles. Qual é o risco arquitetural dessa decisão, em comparação a usar RS256?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'RS256 exige que todos os serviços compartilhem a mesma chave privada, tornando-o igualmente arriscado.', false),
    ((SELECT id FROM question WHERE enunciado = 'Vários microsserviços validam JWTs assinados com HS256 usando o mesmo segredo compartilhado entre todos eles. Qual é o risco arquitetural dessa decisão, em comparação a usar RS256?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Não há diferença de risco entre HS256 e RS256; a escolha do algoritmo é puramente uma questão de performance.', false);
