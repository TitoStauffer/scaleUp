-- Ampliação do pool de Questions — Domínio Segurança (Fase 3: 54 -> 72)
-- Origem: docs/product/tickets/TICKET-content-expansion-questoes-fase3.md (+ ticket mestre
-- TICKET-content-database.md + tickets das Fases 1 e 2 TICKET-content-expansion-questoes.md
-- e TICKET-content-expansion-questoes-fase2.md). Autoria assistida por IA, rascunho técnico,
-- sujeito a revisão humana obrigatória antes de status_revisao = 'revisado_aprovado'.
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
-- domain_ref usa subquery por slug (mesmo padrão do V20/V32/V41). content_version = 'v1'
-- (decisão fechada nesta Fase 3, sem reabrir a pendência) e status_revisao = 'rascunho'
-- em todas as linhas.
--
-- Não-duplicação: V20 (seed, 18 Questions), V32 (Fase 1, 18 Questions) e V41 (Fase 2, 18
-- Questions) foram lidos integralmente antes de escrever este arquivo — 54 enunciados
-- combinados conferidos. As 18 Questions abaixo cobrem ângulos ainda não testados nesse
-- conjunto (AuthN vs AuthZ, OAuth2 Authorization Code/Client Credentials, OIDC, JWT
-- header/payload/alg none/HS256 vs RS256/revogação, hashing de senha e salt, criptografia
-- simétrica/assimétrica/híbrida, assinatura digital, TLS handshake/cadeia de
-- confiança/mTLS/OCSP/forward secrecy, SQLi, XSS refletido/armazenado, CSRF/SOP/SameSite,
-- rate limiting (código HTTP/multi-nível/token bucket/sliding window/lockout), circuit
-- breaker, DDoS, RBAC, menor privilégio, IDOR, secrets hardcoded, MFA, HSTS/SSL stripping,
-- command injection, HttpOnly, CSP, encryption at rest/transit, open redirect, account
-- enumeration, insecure deserialization, SSRF, dependências vulneráveis desatualizadas,
-- timing attack, logging de segurança, CORS wildcard+credentials já cobertos anteriormente).
-- Novos ângulos introduzidos nesta leva: X-Frame-Options/clickjacking, rotação de segredos,
-- API key (definição e trade-off arquitetural frente a OAuth2 client credentials), security
-- misconfiguration (debug mode em produção e bucket de armazenamento público), tokenização
-- de dados sensíveis, certificate pinning (definição e trade-off operacional), Zero Trust
-- Architecture (princípio geral e insuficiência de segmentação de rede sem mTLS entre
-- serviços), session fixation, escalonamento de privilégio horizontal vs. vertical, logs de
-- auditoria imutáveis para compliance, gestão de segredos dinâmicos com lease vs. credencial
-- estática compartilhada, race condition/TOCTOU, ataque de supply chain via dependency
-- confusion, e tokens de proof-of-possession (DPoP) vs. bearer token.
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
        'a5000000-0000-4000-8000-000000000004',
        'Qual é o propósito do cabeçalho HTTP X-Frame-Options (ou da diretiva frame-ancestors do CSP)?',
        'Esse cabeçalho impede que a página seja embutida em um <iframe> de outro site, mitigando ataques de clickjacking, em que o usuário é induzido a clicar em algo disfarçado por uma camada invisível sobreposta à página legítima.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual é o propósito do cabeçalho HTTP X-Frame-Options (ou da diretiva frame-ancestors do CSP)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Impedir que a página seja embutida em um iframe de outro site, mitigando ataques de clickjacking.', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o propósito do cabeçalho HTTP X-Frame-Options (ou da diretiva frame-ancestors do CSP)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Cifrar o conteúdo da página antes de enviá-lo ao navegador.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o propósito do cabeçalho HTTP X-Frame-Options (ou da diretiva frame-ancestors do CSP)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Definir de quais origens o navegador pode carregar scripts.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o propósito do cabeçalho HTTP X-Frame-Options (ou da diretiva frame-ancestors do CSP)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Forçar o uso exclusivo de HTTPS para o domínio.', false);

-- FÁCIL 2
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000005',
        'Por que é considerada boa prática rotacionar periodicamente segredos como chaves de API e credenciais de banco de dados, mesmo quando não há indício de vazamento?',
        'A rotação periódica limita o tempo em que uma credencial comprometida sem detecção (ex.: exposta acidentalmente em um log, cópia de configuração ou por um ex-funcionário) permanece válida, reduzindo a janela de exposição mesmo quando o vazamento não é percebido de imediato.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Por que é considerada boa prática rotacionar periodicamente segredos como chaves de API e credenciais de banco de dados, mesmo quando não há indício de vazamento?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque limita o tempo em que uma credencial comprometida sem detecção permanece válida, reduzindo a janela de exposição.', true),
    ((SELECT id FROM question WHERE enunciado = 'Por que é considerada boa prática rotacionar periodicamente segredos como chaves de API e credenciais de banco de dados, mesmo quando não há indício de vazamento?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque segredos rotacionados nunca precisam ser armazenados de forma segura.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que é considerada boa prática rotacionar periodicamente segredos como chaves de API e credenciais de banco de dados, mesmo quando não há indício de vazamento?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque rotação de segredos substitui a necessidade de TLS na comunicação.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que é considerada boa prática rotacionar periodicamente segredos como chaves de API e credenciais de banco de dados, mesmo quando não há indício de vazamento?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque bancos de dados rejeitam automaticamente credenciais usadas por mais de 24 horas.', false);

-- FÁCIL 3
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000001',
        'O que é uma API key, no contexto de autenticação entre sistemas (ex.: integrações entre serviços)?',
        'Uma API key é um valor secreto e geralmente estático, associado a um cliente/aplicação, enviado em cada requisição (em um header ou query param) para identificar e autenticar quem está chamando a API — diferente de um token OAuth2, tipicamente não expira automaticamente nem carrega escopos granulares por padrão.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que é uma API key, no contexto de autenticação entre sistemas (ex.: integrações entre serviços)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Um valor secreto e geralmente estático, associado a um cliente, enviado em cada requisição para identificar e autenticar quem está chamando a API.', true),
    ((SELECT id FROM question WHERE enunciado = 'O que é uma API key, no contexto de autenticação entre sistemas (ex.: integrações entre serviços)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Um certificado digital assinado por uma Autoridade Certificadora, usado exclusivamente em conexões mTLS.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é uma API key, no contexto de autenticação entre sistemas (ex.: integrações entre serviços)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Um token de curta duração emitido automaticamente após o handshake TLS.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é uma API key, no contexto de autenticação entre sistemas (ex.: integrações entre serviços)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Um hash da senha do usuário gerado a cada login.', false);

-- FÁCIL 4
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000004',
        'Por que deixar o modo de depuração (debug mode) de um framework web habilitado em ambiente de produção é considerado um risco de segurança?',
        'O modo debug tipicamente expõe stack traces detalhados, variáveis de ambiente, versões de bibliotecas e, às vezes, até um console interativo — informações que ajudam um atacante a mapear a aplicação e planejar um ataque mais preciso.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Por que deixar o modo de depuração (debug mode) de um framework web habilitado em ambiente de produção é considerado um risco de segurança?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque geralmente expõe stack traces, configurações internas e detalhes da aplicação que ajudam um atacante a planejar um ataque.', true),
    ((SELECT id FROM question WHERE enunciado = 'Por que deixar o modo de depuração (debug mode) de um framework web habilitado em ambiente de produção é considerado um risco de segurança?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque o modo debug desabilita automaticamente o TLS do servidor.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que deixar o modo de depuração (debug mode) de um framework web habilitado em ambiente de produção é considerado um risco de segurança?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque o modo debug impede o uso de prepared statements nas queries.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que deixar o modo de depuração (debug mode) de um framework web habilitado em ambiente de produção é considerado um risco de segurança?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque o modo debug substitui a autenticação por uma senha padrão fixa.', false);

-- FÁCIL 5
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000002',
        'O que é tokenização de dados sensíveis, como um número de cartão de crédito, em um sistema de pagamentos?',
        'Tokenização substitui o dado sensível por um identificador (token) sem valor explorável fora do sistema que fez a substituição, mantendo o dado real armazenado separadamente em um cofre seguro — sistemas que só precisam referenciar o cartão, sem processá-lo diretamente, nunca manipulam o número real.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que é tokenização de dados sensíveis, como um número de cartão de crédito, em um sistema de pagamentos?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Substituir o dado sensível por um identificador sem valor fora do sistema de tokenização, mantendo o dado real isolado em um cofre seguro.', true),
    ((SELECT id FROM question WHERE enunciado = 'O que é tokenização de dados sensíveis, como um número de cartão de crédito, em um sistema de pagamentos?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Cifrar o número do cartão com a chave pública do usuário antes de exibi-lo na tela.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é tokenização de dados sensíveis, como um número de cartão de crédito, em um sistema de pagamentos?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Truncar o número do cartão para os últimos 4 dígitos permanentemente no banco de dados, sem guardar o restante em nenhum lugar.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é tokenização de dados sensíveis, como um número de cartão de crédito, em um sistema de pagamentos?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Aplicar hash irreversível ao número do cartão para permitir apenas validação de posse, nunca cobrança.', false);

-- FÁCIL 6
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000003',
        'O que é certificate pinning (fixação de certificado) em um aplicativo móvel ou cliente HTTP?',
        'A aplicação é configurada para confiar apenas em um certificado (ou chave pública) específico esperado para aquele servidor, em vez de aceitar qualquer certificado validado pela cadeia de confiança padrão do sistema operacional — reduz o risco de um certificado fraudulento emitido por uma CA comprometida ser aceito.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que é certificate pinning (fixação de certificado) em um aplicativo móvel ou cliente HTTP?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'A aplicação só confia em um certificado ou chave pública específica esperada para o servidor, em vez de aceitar qualquer certificado validado pela cadeia de confiança padrão.', true),
    ((SELECT id FROM question WHERE enunciado = 'O que é certificate pinning (fixação de certificado) em um aplicativo móvel ou cliente HTTP?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'A prática de nunca renovar o certificado TLS do servidor, mantendo o mesmo para sempre.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é certificate pinning (fixação de certificado) em um aplicativo móvel ou cliente HTTP?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Um mecanismo que cifra a chave privada do servidor com uma senha fixa.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é certificate pinning (fixação de certificado) em um aplicativo móvel ou cliente HTTP?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'A obrigação de o cliente apresentar seu próprio certificado ao servidor (equivalente a mTLS).', false);

-- MÉDIA 1
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000005',
        'Qual é o princípio central da arquitetura Zero Trust, em contraste com o modelo tradicional de segurança de perímetro ("castelo e fosso")?',
        'Zero Trust assume que nenhuma requisição deve ser confiada automaticamente só por vir de dentro da rede corporativa/VPN — toda solicitação de acesso deve ser autenticada e autorizada explicitamente, independentemente de origem, sob o princípio "nunca confie, sempre verifique". O modelo de perímetro, por outro lado, confia implicitamente em qualquer tráfego que já esteja dentro da rede interna.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual é o princípio central da arquitetura Zero Trust, em contraste com o modelo tradicional de segurança de perímetro ("castelo e fosso")?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Nenhuma requisição é confiada automaticamente por estar dentro da rede interna; toda solicitação deve ser autenticada e autorizada explicitamente, sempre.', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o princípio central da arquitetura Zero Trust, em contraste com o modelo tradicional de segurança de perímetro ("castelo e fosso")?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Basta reforçar o firewall de borda para que o tráfego interno não precise mais de autenticação.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o princípio central da arquitetura Zero Trust, em contraste com o modelo tradicional de segurança de perímetro ("castelo e fosso")?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Zero Trust elimina a necessidade de autenticação, substituindo-a inteiramente por segmentação de rede.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o princípio central da arquitetura Zero Trust, em contraste com o modelo tradicional de segurança de perímetro ("castelo e fosso")?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Zero Trust é aplicável apenas a redes que não usam VPN.', false);

-- MÉDIA 2
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000001',
        'O que é um ataque de session fixation, e por que gerar um novo identificador de sessão logo após o login é uma defesa eficaz contra ele?',
        'No session fixation, o atacante induz a vítima a usar um identificador de sessão que ele já conhece (ex.: enviando um link com um session ID predefinido) antes do login; se a aplicação continuar usando esse mesmo ID após a autenticação, o atacante pode usá-lo para assumir a sessão já autenticada da vítima. Gerar um ID novo no momento do login invalida qualquer ID pré-existente conhecido pelo atacante.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que é um ataque de session fixation, e por que gerar um novo identificador de sessão logo após o login é uma defesa eficaz contra ele?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'O atacante faz a vítima autenticar-se usando um ID de sessão que ele já conhece; gerar um novo ID no login invalida esse ID previamente conhecido pelo atacante.', true),
    ((SELECT id FROM question WHERE enunciado = 'O que é um ataque de session fixation, e por que gerar um novo identificador de sessão logo após o login é uma defesa eficaz contra ele?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'É um ataque em que o atacante intercepta o tráfego TLS para capturar a sessão em trânsito.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é um ataque de session fixation, e por que gerar um novo identificador de sessão logo após o login é uma defesa eficaz contra ele?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'É a reutilização proposital de senhas antigas armazenadas em um hash não salgado.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é um ataque de session fixation, e por que gerar um novo identificador de sessão logo após o login é uma defesa eficaz contra ele?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'É a manipulação do cabeçalho Host para forçar redirecionamentos maliciosos.', false);

-- MÉDIA 3
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000004',
        'Qual a diferença entre escalonamento de privilégio horizontal e vertical em uma falha de controle de acesso?',
        'No escalonamento horizontal, um usuário acessa dados ou recursos de outro usuário do mesmo nível de privilégio (ex.: um IDOR entre contas comuns); no escalonamento vertical, um usuário de privilégio menor consegue executar ações reservadas a um nível superior, como um usuário comum conseguindo executar uma ação exclusiva de administrador por falta de checagem de papel/role no servidor.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual a diferença entre escalonamento de privilégio horizontal e vertical em uma falha de controle de acesso?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Horizontal: acessar dados de outro usuário do mesmo nível de privilégio; vertical: obter permissões de um nível de privilégio superior ao que deveria ter.', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual a diferença entre escalonamento de privilégio horizontal e vertical em uma falha de controle de acesso?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Horizontal se refere a ataques de rede; vertical se refere exclusivamente a ataques de criptografia.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual a diferença entre escalonamento de privilégio horizontal e vertical em uma falha de controle de acesso?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Não há diferença; os dois termos descrevem exatamente a mesma falha, apenas com nomes distintos.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual a diferença entre escalonamento de privilégio horizontal e vertical em uma falha de controle de acesso?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Horizontal ocorre apenas em APIs REST; vertical ocorre apenas em aplicações GraphQL.', false);

-- MÉDIA 4
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000005',
        'Além de registrar eventos para detecção de incidentes, por que logs de auditoria usados para fins de compliance (conformidade regulatória) precisam ser armazenados de forma imutável (append-only/write-once), inclusive protegidos contra alteração por administradores do próprio sistema?',
        'Para servir como evidência confiável em uma auditoria ou investigação, o log precisa garantir não-repúdio e integridade — se qualquer pessoa, inclusive um administrador comprometido ou mal-intencionado, puder editar ou apagar entradas, o log perde valor probatório, pois não há garantia de que reflete os eventos reais ocorridos.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Além de registrar eventos para detecção de incidentes, por que logs de auditoria usados para fins de compliance (conformidade regulatória) precisam ser armazenados de forma imutável (append-only/write-once), inclusive protegidos contra alteração por administradores do próprio sistema?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque um log alterável perde valor como evidência confiável em auditoria, já que não garante que reflete fielmente os eventos reais ocorridos.', true),
    ((SELECT id FROM question WHERE enunciado = 'Além de registrar eventos para detecção de incidentes, por que logs de auditoria usados para fins de compliance (conformidade regulatória) precisam ser armazenados de forma imutável (append-only/write-once), inclusive protegidos contra alteração por administradores do próprio sistema?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque logs imutáveis ocupam menos espaço em disco que logs regulares.', false),
    ((SELECT id FROM question WHERE enunciado = 'Além de registrar eventos para detecção de incidentes, por que logs de auditoria usados para fins de compliance (conformidade regulatória) precisam ser armazenados de forma imutável (append-only/write-once), inclusive protegidos contra alteração por administradores do próprio sistema?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque a imutabilidade é exigida apenas para logs de erro de aplicação, nunca para logs de segurança.', false),
    ((SELECT id FROM question WHERE enunciado = 'Além de registrar eventos para detecção de incidentes, por que logs de auditoria usados para fins de compliance (conformidade regulatória) precisam ser armazenados de forma imutável (append-only/write-once), inclusive protegidos contra alteração por administradores do próprio sistema?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque logs append-only aumentam automaticamente a velocidade de resposta da aplicação.', false);

-- MÉDIA 5
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000002',
        'Qual a vantagem de um sistema de gestão de segredos que emite credenciais dinâmicas de banco de dados, com prazo de validade curto (lease), em vez de uma única credencial estática de longa duração compartilhada entre serviços?',
        'Credenciais dinâmicas com lease expiram automaticamente e podem ser emitidas de forma única por serviço/instância, reduzindo o blast radius de um vazamento (a credencial vazada expira sozinha e não é compartilhada entre todos os consumidores) e permitindo rastrear qual instância usou qual credencial — uma credencial estática compartilhada, se vazar, compromete todos os consumidores indefinidamente até rotação manual.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual a vantagem de um sistema de gestão de segredos que emite credenciais dinâmicas de banco de dados, com prazo de validade curto (lease), em vez de uma única credencial estática de longa duração compartilhada entre serviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Credenciais dinâmicas expiram automaticamente e são exclusivas por instância, reduzindo o impacto de um vazamento e permitindo rastreabilidade — diferente de uma credencial estática compartilhada, que compromete todos os consumidores até rotação manual.', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual a vantagem de um sistema de gestão de segredos que emite credenciais dinâmicas de banco de dados, com prazo de validade curto (lease), em vez de uma única credencial estática de longa duração compartilhada entre serviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Credenciais dinâmicas eliminam a necessidade de o banco de dados exigir qualquer autenticação.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual a vantagem de um sistema de gestão de segredos que emite credenciais dinâmicas de banco de dados, com prazo de validade curto (lease), em vez de uma única credencial estática de longa duração compartilhada entre serviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Credenciais dinâmicas são sempre mais rápidas de validar do que uma senha estática.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual a vantagem de um sistema de gestão de segredos que emite credenciais dinâmicas de banco de dados, com prazo de validade curto (lease), em vez de uma única credencial estática de longa duração compartilhada entre serviços?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Credenciais estáticas compartilhadas são mais seguras porque reduzem o número de segredos distintos armazenados.', false);

-- MÉDIA 6
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000004',
        'Em um endpoint de resgate de cupom de desconto, duas requisições simultâneas para o mesmo cupom, enviadas propositalmente ao mesmo tempo por um atacante, conseguem resgatá-lo duas vezes, mesmo havendo uma checagem prévia de "cupom ainda não utilizado" antes de marcá-lo como usado. Que tipo de vulnerabilidade é essa?',
        'É uma condição de corrida (race condition), especificamente um problema de TOCTOU (time-of-check to time-of-use) — o tempo entre verificar que o cupom está disponível e marcá-lo como usado permite que duas requisições concorrentes passem pela checagem antes que qualquer uma delas atualize o estado, resgatando o mesmo cupom mais de uma vez. A defesa exige uma operação atômica (ex.: constraint de banco de dados ou lock) que combine checagem e atualização em uma única etapa indivisível.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Em um endpoint de resgate de cupom de desconto, duas requisições simultâneas para o mesmo cupom, enviadas propositalmente ao mesmo tempo por um atacante, conseguem resgatá-lo duas vezes, mesmo havendo uma checagem prévia de "cupom ainda não utilizado" antes de marcá-lo como usado. Que tipo de vulnerabilidade é essa?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Uma condição de corrida (race condition/TOCTOU): o intervalo entre checar e marcar o cupom como usado permite que requisições concorrentes passem pela checagem antes de qualquer atualização de estado.', true),
    ((SELECT id FROM question WHERE enunciado = 'Em um endpoint de resgate de cupom de desconto, duas requisições simultâneas para o mesmo cupom, enviadas propositalmente ao mesmo tempo por um atacante, conseguem resgatá-lo duas vezes, mesmo havendo uma checagem prévia de "cupom ainda não utilizado" antes de marcá-lo como usado. Que tipo de vulnerabilidade é essa?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Um ataque de SQL Injection, já que duas requisições simultâneas sempre indicam concatenação insegura de queries.', false),
    ((SELECT id FROM question WHERE enunciado = 'Em um endpoint de resgate de cupom de desconto, duas requisições simultâneas para o mesmo cupom, enviadas propositalmente ao mesmo tempo por um atacante, conseguem resgatá-lo duas vezes, mesmo havendo uma checagem prévia de "cupom ainda não utilizado" antes de marcá-lo como usado. Que tipo de vulnerabilidade é essa?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Um ataque de CSRF, porque a vítima não percebeu que autorizou duas requisições.', false),
    ((SELECT id FROM question WHERE enunciado = 'Em um endpoint de resgate de cupom de desconto, duas requisições simultâneas para o mesmo cupom, enviadas propositalmente ao mesmo tempo por um atacante, conseguem resgatá-lo duas vezes, mesmo havendo uma checagem prévia de "cupom ainda não utilizado" antes de marcá-lo como usado. Que tipo de vulnerabilidade é essa?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Um problema de rate limiting mal configurado, resolvido apenas reduzindo o limite de requisições por IP.', false);

-- DIFÍCIL 1
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000001',
        'Em uma integração servidor-a-servidor de alto risco (ex.: acesso a dados financeiros), por que um token OAuth2 de curta duração obtido via client credentials costuma ser preferível a uma API key estática de longa duração, mesmo que ambos autentiquem o mesmo serviço cliente?',
        'Uma API key estática, se vazar, permanece válida indefinidamente até ser manualmente revogada/rotacionada, e tipicamente não carrega escopo granular nem expiração embutida; um token OAuth2 obtido via client credentials tem vida curta por padrão, minimizando a janela de exposição caso vaze, e pode carregar escopos específicos, permitindo expiração automática sem intervenção manual coordenada entre todos os consumidores.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Em uma integração servidor-a-servidor de alto risco (ex.: acesso a dados financeiros), por que um token OAuth2 de curta duração obtido via client credentials costuma ser preferível a uma API key estática de longa duração, mesmo que ambos autentiquem o mesmo serviço cliente?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque o token OAuth2 tem vida curta e expira automaticamente, minimizando a janela de exposição em caso de vazamento, enquanto uma API key estática permanece válida indefinidamente até rotação manual.', true),
    ((SELECT id FROM question WHERE enunciado = 'Em uma integração servidor-a-servidor de alto risco (ex.: acesso a dados financeiros), por que um token OAuth2 de curta duração obtido via client credentials costuma ser preferível a uma API key estática de longa duração, mesmo que ambos autentiquem o mesmo serviço cliente?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque API keys não podem ser transmitidas via HTTPS, apenas tokens OAuth2 podem.', false),
    ((SELECT id FROM question WHERE enunciado = 'Em uma integração servidor-a-servidor de alto risco (ex.: acesso a dados financeiros), por que um token OAuth2 de curta duração obtido via client credentials costuma ser preferível a uma API key estática de longa duração, mesmo que ambos autentiquem o mesmo serviço cliente?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque tokens OAuth2 nunca podem ser interceptados em trânsito, diferente de API keys.', false),
    ((SELECT id FROM question WHERE enunciado = 'Em uma integração servidor-a-servidor de alto risco (ex.: acesso a dados financeiros), por que um token OAuth2 de curta duração obtido via client credentials costuma ser preferível a uma API key estática de longa duração, mesmo que ambos autentiquem o mesmo serviço cliente?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque API keys são sempre mais longas em número de caracteres, o que as torna mais lentas de validar.', false);

-- DIFÍCIL 2
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000002',
        'O que caracteriza um ataque de dependency confusion contra o processo de build de uma aplicação, e por que ele é uma forma de ataque à cadeia de suprimentos de software (supply chain attack)?',
        'O atacante publica, em um repositório público de pacotes, um pacote malicioso com o mesmo nome de uma dependência interna/privada da empresa, mas com um número de versão mais alto; se o gerenciador de pacotes não for configurado para priorizar explicitamente o registro privado, ele pode baixar e executar o pacote malicioso público durante o build — comprometendo a aplicação sem que nenhuma vulnerabilidade tenha sido explorada no código próprio, apenas confiança mal configurada na origem das dependências.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza um ataque de dependency confusion contra o processo de build de uma aplicação, e por que ele é uma forma de ataque à cadeia de suprimentos de software (supply chain attack)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'O atacante publica um pacote público malicioso com o mesmo nome de uma dependência privada e versão mais alta, fazendo o build baixá-lo em vez do pacote interno legítimo.', true),
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza um ataque de dependency confusion contra o processo de build de uma aplicação, e por que ele é uma forma de ataque à cadeia de suprimentos de software (supply chain attack)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'É a exploração de uma vulnerabilidade conhecida (CVE) documentada em uma biblioteca desatualizada específica.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza um ataque de dependency confusion contra o processo de build de uma aplicação, e por que ele é uma forma de ataque à cadeia de suprimentos de software (supply chain attack)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'É a interceptação do tráfego HTTPS entre o servidor de build e o registro de pacotes.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza um ataque de dependency confusion contra o processo de build de uma aplicação, e por que ele é uma forma de ataque à cadeia de suprimentos de software (supply chain attack)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'É a injeção de comandos SQL durante a etapa de testes automatizados do pipeline de CI.', false);

-- DIFÍCIL 3
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000003',
        'Qual é o principal risco operacional de implementar certificate pinning de forma rígida (fixando o certificado exato, não apenas a chave pública da CA raiz) em um aplicativo móvel amplamente distribuído?',
        'Quando o certificado do servidor precisa ser renovado (rotina, já que certificados têm validade limitada), qualquer versão do aplicativo com o pin antigo passa a rejeitar a nova conexão como não confiável, quebrando a comunicação até que os usuários atualizem o aplicativo — um risco operacional real, já que nem todos os usuários atualizam aplicativos imediatamente. Mitigações incluem fixar a chave pública da CA intermediária (que muda com menos frequência) ou manter múltiplos pins válidos simultaneamente durante a transição.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual é o principal risco operacional de implementar certificate pinning de forma rígida (fixando o certificado exato, não apenas a chave pública da CA raiz) em um aplicativo móvel amplamente distribuído?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Quando o certificado do servidor é renovado, versões do app com o pin antigo passam a rejeitar a conexão, quebrando a comunicação até que os usuários atualizem o aplicativo.', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o principal risco operacional de implementar certificate pinning de forma rígida (fixando o certificado exato, não apenas a chave pública da CA raiz) em um aplicativo móvel amplamente distribuído?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Certificate pinning torna a comunicação mais lenta do que uma conexão sem TLS.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o principal risco operacional de implementar certificate pinning de forma rígida (fixando o certificado exato, não apenas a chave pública da CA raiz) em um aplicativo móvel amplamente distribuído?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Certificate pinning impede que o aplicativo funcione em redes Wi-Fi públicas.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o principal risco operacional de implementar certificate pinning de forma rígida (fixando o certificado exato, não apenas a chave pública da CA raiz) em um aplicativo móvel amplamente distribuído?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Certificate pinning elimina permanentemente a necessidade de o servidor renovar certificados.', false);

-- DIFÍCIL 4
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000005',
        'Por que, sob o princípio Zero Trust, segmentar a rede interna em sub-redes isoladas (ex.: VLANs) não é considerado suficiente, exigindo também autenticação mútua (como mTLS) entre serviços dentro da mesma sub-rede?',
        'Segmentação de rede reduz o alcance de um atacante que já comprometeu um host, mas não impede que ele se passe por um serviço legítimo dentro do mesmo segmento se a comunicação interna não exigir autenticação — sob Zero Trust, a confiança nunca deve depender apenas da localização de rede; cada serviço deve verificar a identidade do outro lado da comunicação independentemente de estarem no mesmo segmento, o que mTLS entre serviços viabiliza.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Por que, sob o princípio Zero Trust, segmentar a rede interna em sub-redes isoladas (ex.: VLANs) não é considerado suficiente, exigindo também autenticação mútua (como mTLS) entre serviços dentro da mesma sub-rede?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque a confiança sob Zero Trust nunca deve depender apenas da localização de rede; sem autenticação mútua, um host comprometido no mesmo segmento pode se passar por um serviço legítimo.', true),
    ((SELECT id FROM question WHERE enunciado = 'Por que, sob o princípio Zero Trust, segmentar a rede interna em sub-redes isoladas (ex.: VLANs) não é considerado suficiente, exigindo também autenticação mútua (como mTLS) entre serviços dentro da mesma sub-rede?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque VLANs são tecnicamente incompatíveis com qualquer protocolo de criptografia.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que, sob o princípio Zero Trust, segmentar a rede interna em sub-redes isoladas (ex.: VLANs) não é considerado suficiente, exigindo também autenticação mútua (como mTLS) entre serviços dentro da mesma sub-rede?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque segmentação de rede já implementa automaticamente autenticação mútua entre todos os hosts do segmento.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que, sob o princípio Zero Trust, segmentar a rede interna em sub-redes isoladas (ex.: VLANs) não é considerado suficiente, exigindo também autenticação mútua (como mTLS) entre serviços dentro da mesma sub-rede?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque Zero Trust proíbe o uso de qualquer segmentação de rede, substituindo-a inteiramente por mTLS.', false);

-- DIFÍCIL 5
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000004',
        'Um bucket de armazenamento em nuvem contendo backups de banco de dados é deixado com permissão de leitura pública por engano (configuração padrão não revisada). Por que esse tipo de falha de configuração é frequentemente citado como uma das causas mais comuns de vazamento de dados em larga escala, apesar de não envolver nenhuma vulnerabilidade de código?',
        'A falha não explora nenhum bug de código-fonte — é um erro de configuração de infraestrutura que expõe diretamente o dado a qualquer pessoa com o link/identificador do recurso, sem exigir nenhuma técnica de invasão; ferramentas automatizadas de varredura da internet conseguem localizar buckets mal configurados em escala, tornando esse tipo de exposição rapidamente descoberto e explorado mesmo sem um atacante direcionado.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Um bucket de armazenamento em nuvem contendo backups de banco de dados é deixado com permissão de leitura pública por engano (configuração padrão não revisada). Por que esse tipo de falha de configuração é frequentemente citado como uma das causas mais comuns de vazamento de dados em larga escala, apesar de não envolver nenhuma vulnerabilidade de código?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque expõe o dado diretamente a qualquer pessoa com o link do recurso, sem exigir nenhuma técnica de invasão, e ferramentas automatizadas conseguem localizar esse tipo de exposição em escala.', true),
    ((SELECT id FROM question WHERE enunciado = 'Um bucket de armazenamento em nuvem contendo backups de banco de dados é deixado com permissão de leitura pública por engano (configuração padrão não revisada). Por que esse tipo de falha de configuração é frequentemente citado como uma das causas mais comuns de vazamento de dados em larga escala, apesar de não envolver nenhuma vulnerabilidade de código?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque buckets públicos sempre desabilitam automaticamente a criptografia em repouso dos arquivos armazenados.', false),
    ((SELECT id FROM question WHERE enunciado = 'Um bucket de armazenamento em nuvem contendo backups de banco de dados é deixado com permissão de leitura pública por engano (configuração padrão não revisada). Por que esse tipo de falha de configuração é frequentemente citado como uma das causas mais comuns de vazamento de dados em larga escala, apesar de não envolver nenhuma vulnerabilidade de código?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque esse tipo de falha só afeta arquivos menores que 1 MB, mas backups completos estão imunes.', false),
    ((SELECT id FROM question WHERE enunciado = 'Um bucket de armazenamento em nuvem contendo backups de banco de dados é deixado com permissão de leitura pública por engano (configuração padrão não revisada). Por que esse tipo de falha de configuração é frequentemente citado como uma das causas mais comuns de vazamento de dados em larga escala, apesar de não envolver nenhuma vulnerabilidade de código?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque provedores de nuvem removem automaticamente qualquer bucket configurado como público em até 24 horas.', false);

-- DIFÍCIL 6
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000001',
        'Um access token bearer, se interceptado ou vazado, pode ser usado por qualquer pessoa que o possua para se autenticar como o cliente legítimo, sem nenhuma prova adicional. Como um mecanismo de proof-of-possession (ex.: DPoP — Demonstrating Proof-of-Possession) reduz esse risco em relação a um token bearer tradicional?',
        'Em um token bearer, a posse do token por si só é suficiente para uso — não há verificação de que quem apresenta o token é o mesmo cliente a quem ele foi emitido. Em um esquema de proof-of-possession, o token é vinculado criptograficamente a uma chave privada que o cliente original possui; a cada uso, o cliente precisa demonstrar posse dessa chave (ex.: assinando parte da requisição), então um token interceptado sozinho não é suficiente para um atacante reutilizá-lo, pois ele não possui a chave privada associada.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Um access token bearer, se interceptado ou vazado, pode ser usado por qualquer pessoa que o possua para se autenticar como o cliente legítimo, sem nenhuma prova adicional. Como um mecanismo de proof-of-possession (ex.: DPoP — Demonstrating Proof-of-Possession) reduz esse risco em relação a um token bearer tradicional?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'O token é vinculado a uma chave privada que o cliente original possui, e a cada uso o cliente precisa demonstrar posse dessa chave — um token interceptado sozinho não é suficiente para reutilização.', true),
    ((SELECT id FROM question WHERE enunciado = 'Um access token bearer, se interceptado ou vazado, pode ser usado por qualquer pessoa que o possua para se autenticar como o cliente legítimo, sem nenhuma prova adicional. Como um mecanismo de proof-of-possession (ex.: DPoP — Demonstrating Proof-of-Possession) reduz esse risco em relação a um token bearer tradicional?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'DPoP substitui a necessidade de TLS entre cliente e servidor.', false),
    ((SELECT id FROM question WHERE enunciado = 'Um access token bearer, se interceptado ou vazado, pode ser usado por qualquer pessoa que o possua para se autenticar como o cliente legítimo, sem nenhuma prova adicional. Como um mecanismo de proof-of-possession (ex.: DPoP — Demonstrating Proof-of-Possession) reduz esse risco em relação a um token bearer tradicional?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'DPoP torna o token permanentemente válido, eliminando a necessidade de expiração.', false),
    ((SELECT id FROM question WHERE enunciado = 'Um access token bearer, se interceptado ou vazado, pode ser usado por qualquer pessoa que o possua para se autenticar como o cliente legítimo, sem nenhuma prova adicional. Como um mecanismo de proof-of-possession (ex.: DPoP — Demonstrating Proof-of-Possession) reduz esse risco em relação a um token bearer tradicional?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'DPoP cifra o payload do token, impedindo que qualquer parte o leia, inclusive o servidor de recursos.', false);
