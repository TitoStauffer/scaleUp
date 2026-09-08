-- Seed de conteúdo — Domínio Segurança (slug: seguranca)
-- Origem: docs/product/tickets/content/TICKET-content-seguranca.md (+ ticket mestre
-- TICKET-content-database.md). Autoria assistida por IA, rascunho técnico, sujeito a
-- revisão humana obrigatória antes de status_revisao = 'revisado_aprovado'.
--
-- Não insere em domain (linha já existe via V13__seed_dominios.sql, slug 'seguranca');
-- todas as referências a domain_ref usam subquery por slug.
-- content_version = 'v1' e status_revisao = 'rascunho' em todas as linhas.
--
-- 5 Concepts, 15 Slides (3 por Concept, ordem 1..3 sem lacunas), 15 Flashcards,
-- 18 Questions (6 facil / 6 media / 6 dificil) com 4 alternativas cada (1 correta).
-- Question + suas 4 alternativas inseridas na mesma transação (migração Flyway já roda
-- em transação única), satisfazendo o trigger de constraint adiada de V6.

-- =====================================================================================
-- CONCEPTS
-- =====================================================================================

INSERT INTO concept (id, domain_ref, titulo, resumo, content_version, status_revisao)
VALUES
    ('a5000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'Autenticação e Autorização',
     'Diferenças entre autenticação (provar quem você é) e autorização (o que você pode fazer), e os principais protocolos usados para implementar cada uma em sistemas distribuídos, como OAuth2, OpenID Connect e JWT.',
     'v1', 'rascunho'),
    ('a5000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'Criptografia Aplicada',
     'Fundamentos de criptografia simétrica e assimétrica, hashing de senhas, assinaturas digitais e como esses mecanismos se combinam para proteger dados em repouso e em trânsito.',
     'v1', 'rascunho'),
    ('a5000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'TLS e Segurança em Trânsito',
     'Como o TLS estabelece um canal seguro entre cliente e servidor, o papel de certificados e autoridades certificadoras, e por que HTTPS é considerado padrão mínimo para tráfego na internet.',
     'v1', 'rascunho'),
    ('a5000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'Vulnerabilidades Comuns em Aplicações Web',
     'Principais classes de ataque contra aplicações web — injection, XSS, CSRF — como cada uma explora uma falha específica de confiança, e as defesas padrão usadas para mitigá-las.',
     'v1', 'rascunho'),
    ('a5000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'Defesa em Profundidade e Controle de Abuso',
     'Princípio do menor privilégio, defesa em camadas, rate limiting e proteção contra negação de serviço (DoS) como estratégias complementares para reduzir a superfície de ataque de um sistema.',
     'v1', 'rascunho')
ON CONFLICT (domain_ref, titulo) DO NOTHING;

-- =====================================================================================
-- SLIDES (3 por Concept, ordem sequencial 1..3)
-- =====================================================================================

-- Concept: Autenticação e Autorização
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a5000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'Autenticação vs. autorização: por que a confusão é perigosa',
     'Autenticação (AuthN) responde "quem é você?": o processo de verificar a identidade de um usuário ou sistema, tipicamente via senha, certificado, token ou biometria. Autorização (AuthZ) responde "o que você pode fazer?": o processo de decidir, já sabendo quem é o solicitante, se ele tem permissão para executar uma ação ou acessar um recurso específico. Tratar as duas como a mesma coisa é uma fonte comum de falhas de segurança: um sistema pode autenticar corretamente um usuário (ele realmente é quem diz ser) e ainda assim falhar catastroficamente se não checar autorização antes de cada operação sensível — por exemplo, permitir que um usuário autenticado acesse o pedido de outro usuário só porque ele "está logado". Em arquiteturas distribuídas, autenticação normalmente acontece uma vez (login) e gera uma credencial (sessão ou token) que é reapresentada a cada requisição; autorização, por outro lado, deve ser verificada a cada operação sensível, mesmo dentro da mesma sessão autenticada.',
     1, 'v1', 'rascunho'),
    ('a5000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'OAuth2: delegação de acesso sem compartilhar senha',
     'OAuth2 é um protocolo de autorização (não de autenticação, apesar do uso comum) que permite que uma aplicação (client) obtenha acesso limitado a um recurso protegido em nome de um usuário, sem que o usuário precise compartilhar sua senha com essa aplicação. O fluxo mais comum, Authorization Code, funciona assim: o usuário é redirecionado ao servidor de autorização (ex.: Google, GitHub), autentica-se lá, e autoriza explicitamente o escopo de acesso solicitado; o servidor de autorização devolve um código de autorização de uso único ao client, que o troca (em uma chamada servidor-a-servidor, fora do navegador) por um access token; esse token é então usado para chamar a API protegida em nome do usuário. Access tokens costumam ter vida curta e podem ser renovados via refresh token, reduzindo a janela de exposição caso um token vaze. Um erro comum é usar OAuth2 sozinho para autenticar o usuário na própria aplicação — para isso existe o OpenID Connect (OIDC), uma camada de identidade construída sobre o OAuth2 que adiciona o ID token (um JWT com informações verificáveis sobre quem o usuário é).',
     2, 'v1', 'rascunho'),
    ('a5000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'JWT na prática: estrutura, assinatura e armadilhas',
     'Um JSON Web Token (JWT) é composto por três partes separadas por ponto: header (algoritmo de assinatura e tipo), payload (claims — dados sobre o usuário e a sessão, como id, escopos e expiração) e signature (garante que o conteúdo não foi alterado desde a emissão). É importante entender que o payload de um JWT é apenas codificado em Base64, não criptografado — qualquer pessoa que intercepte o token consegue ler seu conteúdo; a assinatura protege contra adulteração, não contra leitura. Por isso, dados sensíveis (senhas, números de cartão) nunca devem ir no payload de um JWT. Armadilhas comuns em produção: (1) aceitar o algoritmo "none" ou permitir que o cliente escolha o algoritmo de verificação, abrindo brecha para forjar tokens; (2) não validar a expiração (`exp`) no servidor; (3) usar tokens de vida muito longa sem mecanismo de revogação — como o JWT é auto-contido (stateless), revogar um token antes de sua expiração natural exige uma lista de bloqueio (blocklist) ou reduzir drasticamente o tempo de vida e depender de refresh tokens para renovação.',
     3, 'v1', 'rascunho');

-- Concept: Criptografia Aplicada
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a5000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'Criptografia simétrica vs. assimétrica',
     'Criptografia simétrica usa a mesma chave para cifrar e decifrar (ex.: AES). É rápida e eficiente para grandes volumes de dados, mas exige que as duas partes já compartilhem a chave secreta com segurança antes de trocar mensagens — o problema da "distribuição de chaves". Criptografia assimétrica (ex.: RSA, curvas elípticas) usa um par de chaves matematicamente relacionadas: uma pública (pode ser compartilhada livremente) e uma privada (mantida em segredo pelo dono). O que é cifrado com a chave pública só pode ser decifrado com a chave privada correspondente, e vice-versa para assinaturas. Isso resolve o problema de distribuição, mas é significativamente mais lento computacionalmente. Na prática, sistemas reais combinam as duas: TLS, por exemplo, usa criptografia assimétrica apenas na fase inicial de handshake para negociar com segurança uma chave simétrica efêmera, e depois usa criptografia simétrica (muito mais rápida) para cifrar o restante da comunicação — uma abordagem chamada criptografia híbrida.',
     1, 'v1', 'rascunho'),
    ('a5000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'Hashing de senhas: por que nunca armazenar em texto puro (nem cifrado)',
     'Senhas nunca devem ser armazenadas em texto puro nem cifradas de forma reversível — a resposta correta é usar uma função de hash unidirecional projetada especificamente para senhas (bcrypt, scrypt ou Argon2), não hashes genéricos de propósito geral como MD5 ou SHA-256 puro. A diferença crucial: hashes genéricos são rápidos por design (ótimos para verificar integridade de arquivos), o que os torna vulneráveis a ataques de força bruta e tabelas pré-computadas (rainbow tables) quando aplicados a senhas — um atacante com hardware moderno consegue testar bilhões de combinações por segundo. bcrypt/scrypt/Argon2 são deliberadamente lentos e configuráveis (fator de custo ajustável ao poder computacional disponível), e incorporam automaticamente um salt único por senha, evitando que duas senhas idênticas gerem o mesmo hash e neutralizando tabelas pré-computadas. Ao autenticar, o sistema nunca "decifra" o hash — ele aplica a mesma função de hash à senha informada no login e compara o resultado com o hash armazenado.',
     2, 'v1', 'rascunho'),
    ('a5000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'Assinaturas digitais e integridade de dados',
     'Uma assinatura digital usa criptografia assimétrica para garantir duas propriedades simultaneamente: integridade (o conteúdo não foi alterado desde a assinatura) e autenticidade/não-repúdio (a mensagem realmente veio de quem diz ter enviado, e essa parte não pode negar posteriormente que a enviou). O processo típico: o emissor calcula um hash do conteúdo e cifra esse hash com sua chave privada — o resultado é a assinatura, anexada à mensagem original (não cifrada). Qualquer receptor pode verificar a assinatura usando a chave pública do emissor (amplamente disponível): decifra a assinatura para obter o hash original e o compara com um hash recalculado sobre o conteúdo recebido; se baterem, a mensagem é íntegra e realmente veio do dono daquela chave privada. Esse mecanismo é a base de certificados TLS (a autoridade certificadora assina o certificado do site), de pacotes de software assinados e de tokens JWT assinados com algoritmos assimétricos (RS256), que permitem que qualquer serviço com a chave pública valide o token sem precisar conhecer a chave privada que o emitiu.',
     3, 'v1', 'rascunho');

-- Concept: TLS e Segurança em Trânsito
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a5000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'O que o TLS realmente garante',
     'TLS (Transport Layer Security, sucessor do SSL) é o protocolo que protege a comunicação entre cliente e servidor na internet — é o "S" de HTTPS. Ele garante três propriedades: confidencialidade (o conteúdo trafegado é cifrado, ilegível para quem interceptar o tráfego), integridade (qualquer adulteração dos dados em trânsito é detectável) e autenticidade do servidor (o cliente pode verificar que está de fato falando com o servidor esperado, não com um impostor). É importante frisar o que o TLS NÃO garante: ele não valida se o conteúdo da aplicação está correto, não impede vulnerabilidades como SQL injection ou XSS, e por padrão não autentica o cliente (apenas o servidor) — autenticação mútua com certificado de cliente existe (mTLS) mas é um caso mais específico, comum em comunicação servidor-a-servidor. TLS opera abaixo da camada de aplicação, então protege o "tubo" por onde os dados passam, não o conteúdo ou a lógica de negócio da aplicação.',
     1, 'v1', 'rascunho'),
    ('a5000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'Certificados digitais e a cadeia de confiança',
     'Um certificado digital vincula uma chave pública a uma identidade (por exemplo, um domínio como "banco.com"), e é assinado digitalmente por uma Autoridade Certificadora (CA) confiável. Quando um navegador se conecta a um site via HTTPS, o servidor apresenta seu certificado; o navegador verifica a assinatura da CA usando um conjunto de certificados-raiz que já vêm pré-instalados e confiáveis no sistema operacional/navegador. Essa é a "cadeia de confiança": o certificado do site é assinado por uma CA intermediária, que por sua vez foi certificada por uma CA raiz confiável — se qualquer elo dessa cadeia não puder ser validado, o navegador exibe um aviso de certificado inválido. Esse mecanismo resolve o problema de "como confiar na chave pública de alguém que você nunca conheceu antes" sem exigir troca manual de chaves. Certificados têm validade limitada (tipicamente 90 dias a 1 ano) e podem ser revogados antes do vencimento (via CRL ou OCSP) caso a chave privada correspondente seja comprometida.',
     2, 'v1', 'rascunho'),
    ('a5000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'Handshake TLS: da negociação à chave de sessão',
     'De forma simplificada, o handshake TLS acontece assim: (1) o cliente envia um "Client Hello" com as versões de TLS e conjuntos de cifras (cipher suites) que suporta; (2) o servidor responde com o cipher suite escolhido e seu certificado (contendo sua chave pública); (3) o cliente valida o certificado contra a cadeia de confiança e, usando a chave pública do servidor, participa da negociação de uma chave de sessão simétrica compartilhada (em TLS 1.3, via Diffie-Hellman efêmero, garantindo forward secrecy — mesmo que uma chave privada vaze no futuro, sessões passadas continuam protegidas); (4) a partir daí, toda a comunicação usa essa chave simétrica, muito mais rápida que criptografia assimétrica para o volume de dados de uma sessão real. TLS 1.3 (versão atual recomendada) reduziu o número de idas e voltas do handshake em relação ao TLS 1.2 e removeu suporte a algoritmos considerados fracos, sendo o padrão recomendado para novos sistemas — versões anteriores a TLS 1.2 são consideradas inseguras e não devem ser habilitadas.',
     3, 'v1', 'rascunho');

-- Concept: Vulnerabilidades Comuns em Aplicações Web
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a5000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'SQL Injection: quando dado vira código',
     'SQL Injection ocorre quando uma aplicação concatena entrada do usuário diretamente em uma query SQL, permitindo que o atacante injete comandos SQL arbitrários. Exemplo clássico: uma query construída concatenando diretamente a entrada do usuário na cláusula WHERE permite que um atacante digite, no campo de e-mail, uma condição do tipo OR 1 igual a 1, transformando a condição em sempre verdadeira e potencialmente retornando todos os usuários, ou pior, encadeando comandos destrutivos. A defesa padrão e praticamente obrigatória é o uso de prepared statements (queries parametrizadas), onde a entrada do usuário é sempre tratada como dado, nunca interpretada como parte da sintaxe SQL, independentemente do que ela contenha — o driver do banco cuida do escaping de forma segura. ORMs como Hibernate/JPA usam prepared statements por padrão quando se utilizam suas APIs de consulta corretamente (JPQL com parâmetros nomeados/posicionais), mas ainda é possível reintroduzir a vulnerabilidade se o desenvolvedor concatenar strings manualmente para montar uma query nativa. Validação de entrada e lista de permissões (allowlist) são camadas complementares, mas não substituem queries parametrizadas.',
     1, 'v1', 'rascunho'),
    ('a5000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'Cross-Site Scripting (XSS): executando código no navegador de outra pessoa',
     'XSS ocorre quando uma aplicação inclui, sem a devida sanitização, conteúdo controlado pelo atacante dentro de uma página HTML servida a outros usuários — o navegador da vítima então executa esse conteúdo como se fosse parte legítima do site. Existem três variantes principais: XSS refletido (o payload malicioso vem de um parâmetro da própria requisição, ex.: um link malicioso compartilhado com a vítima), XSS armazenado/persistente (o payload é salvo no servidor — ex.: em um comentário — e servido a qualquer usuário que visualizar aquele conteúdo depois, sendo geralmente mais grave por atingir múltiplas vítimas), e XSS baseado em DOM (a vulnerabilidade está inteiramente no código JavaScript do lado do cliente, manipulando o DOM com dado não confiável). A defesa central é escapar (encode) qualquer dado dinâmico antes de inseri-lo no HTML — frameworks modernos (React, Angular) fazem isso automaticamente por padrão ao renderizar texto, mas perdem essa proteção quando o desenvolvedor usa explicitamente APIs que inserem HTML bruto (`dangerouslySetInnerHTML` no React, por exemplo). Content Security Policy (CSP) é uma camada de defesa adicional que restringe de quais origens scripts podem ser carregados/executados.',
     2, 'v1', 'rascunho'),
    ('a5000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'Cross-Site Request Forgery (CSRF): abusando de uma sessão já autenticada',
     'CSRF explora o fato de que o navegador anexa automaticamente cookies de sessão a qualquer requisição feita para o domínio dono do cookie, mesmo que a requisição tenha sido disparada por uma página maliciosa em outro domínio. Exemplo: a vítima está autenticada em `banco.com` (tem um cookie de sessão válido); ela visita um site malicioso que contém um formulário oculto que submete automaticamente uma requisição POST para `banco.com/transferir?valor=1000&para=atacante`; como o navegador anexa o cookie de sessão válido a essa requisição, o banco a processa como se fosse uma ação legítima da vítima. A defesa padrão é o uso de um CSRF token: um valor único, imprevisível, gerado pelo servidor e exigido em toda requisição que altera estado (POST/PUT/DELETE), embutido no formulário/página e nunca acessível a um site de terceiros por causa da Same-Origin Policy. Cookies com atributo `SameSite=Strict` ou `SameSite=Lax` também mitigam CSRF ao impedir que o navegador envie o cookie em requisições disparadas por outros sites. APIs que usam tokens em cabeçalho `Authorization` (em vez de cookies) são naturalmente menos vulneráveis a CSRF, já que o navegador não anexa esse cabeçalho automaticamente.',
     3, 'v1', 'rascunho');

-- Concept: Defesa em Profundidade e Controle de Abuso
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a5000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'Princípio do menor privilégio',
     'O princípio do menor privilégio (Principle of Least Privilege) estabelece que qualquer usuário, processo ou serviço deve ter acesso apenas ao mínimo necessário para desempenhar sua função — nada além disso. Na prática, isso se traduz em decisões concretas: um serviço que só lê dados de um banco não deveria ter uma credencial com permissão de escrita; uma função serverless que processa imagens não deveria ter acesso à tabela de pagamentos; um desenvolvedor depurando um incidente não deveria receber acesso permanente de administrador quando um acesso temporário e auditado resolveria o problema. O benefício central é limitar o "raio de explosão" (blast radius) de qualquer comprometimento: se uma credencial de privilégio mínimo vazar ou for comprometida, o dano possível é proporcionalmente menor do que se ela tivesse acesso irrestrito. Isso se aplica tanto a permissões de usuários finais (RBAC — Role-Based Access Control, atribuindo permissões por papel em vez de individualmente) quanto a credenciais de serviços e infraestrutura (IAM roles específicas por função, chaves de API com escopo restrito).',
     1, 'v1', 'rascunho'),
    ('a5000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'Rate limiting: contendo abuso e picos de tráfego',
     'Rate limiting é a prática de restringir quantas requisições um cliente (identificado por IP, usuário autenticado, chave de API, etc.) pode fazer em uma janela de tempo. Serve a dois propósitos complementares: proteger o sistema contra abuso deliberado (força bruta em login, scraping agressivo, tentativas de enumerar recursos) e proteger contra picos de tráfego legítimo que poderiam sobrecarregar recursos compartilhados. Algoritmos comuns incluem token bucket (um "balde" de tokens é reabastecido a taxa constante; cada requisição consome um token, e requisições sem token disponível são rejeitadas ou enfileiradas) e sliding window (conta requisições dentro de uma janela de tempo móvel, mais precisa que janelas fixas para evitar picos nas bordas da janela). Rate limiting deve ser aplicado em múltiplos níveis quando possível: por IP (contém ataques distribuídos de forma limitada), por conta de usuário (contém abuso de uma conta específica) e por endpoint (endpoints sensíveis como login ou reset de senha merecem limites mais agressivos que uma listagem pública). Respostas de rate limiting devem usar o código HTTP 429 (Too Many Requests) e, idealmente, cabeçalhos indicando quando o cliente pode tentar novamente.',
     2, 'v1', 'rascunho'),
    ('a5000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'Negação de serviço (DoS/DDoS) e defesa em camadas',
     'Um ataque de negação de serviço (DoS) visa tornar um sistema indisponível para usuários legítimos, geralmente sobrecarregando algum recurso finito (banda de rede, conexões, CPU, memória, conexões de banco de dados). Quando o ataque é distribuído entre múltiplas origens (tipicamente uma botnet de máquinas comprometidas), é chamado DDoS (Distributed DoS), muito mais difícil de mitigar apenas bloqueando IPs individuais. Defesa eficaz contra DoS/DDoS raramente é uma única medida — é defesa em profundidade (defense in depth): camadas independentes de proteção, de modo que a falha de uma não comprometa o sistema inteiro. Camadas típicas incluem: mitigação na borda da rede via CDN/WAF (filtra tráfego malicioso antes de chegar à infraestrutura própria), rate limiting nas camadas de aplicação e de API gateway, timeouts e circuit breakers para evitar que uma dependência lenta esgote threads/conexões em cascata, autoscaling para absorver picos legítimos, e separação de recursos críticos (ex.: pool de conexões de banco dedicado para operações essenciais, isolado de operações menos críticas). O princípio geral de defesa em profundidade — nenhuma medida isolada é suficiente, a segurança vem da combinação de várias camadas independentes — se aplica igualmente a autenticação, autorização e proteção de dados, não só a disponibilidade.',
     3, 'v1', 'rascunho');

-- =====================================================================================
-- FLASHCARDS (15, ~3 por Concept)
-- =====================================================================================

INSERT INTO flashcard (domain_ref, concept_ref, frente, verso, dificuldade, content_version, status_revisao)
VALUES
    ((SELECT id FROM domain WHERE slug = 'seguranca'),
     'a5000000-0000-4000-8000-000000000001',
     'Qual a diferença entre autenticação e autorização?',
     'Autenticação verifica quem o usuário é (identidade); autorização decide o que esse usuário, já identificado, tem permissão para fazer.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'seguranca'),
     'a5000000-0000-4000-8000-000000000001',
     'Para que serve o OpenID Connect (OIDC) além do OAuth2?',
     'OIDC adiciona uma camada de autenticação/identidade sobre o OAuth2 (que é um protocolo de autorização), introduzindo o ID token para informar de forma verificável quem é o usuário.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'seguranca'),
     'a5000000-0000-4000-8000-000000000001',
     'O payload de um JWT é criptografado?',
     'Não. É apenas codificado em Base64 e protegido por uma assinatura contra adulteração — qualquer um que interceptar o token consegue ler seu conteúdo, então dados sensíveis não devem ir no payload.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'seguranca'),
     'a5000000-0000-4000-8000-000000000002',
     'Por que criptografia híbrida (assimétrica + simétrica) é usada no TLS?',
     'Porque a assimétrica resolve o problema de distribuição de chaves com segurança, mas é lenta; a simétrica é rápida, então é usada para o volume real de dados após a chave ser negociada com segurança via criptografia assimétrica.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'seguranca'),
     'a5000000-0000-4000-8000-000000000002',
     'Por que não usar SHA-256 puro para armazenar senhas?',
     'Porque é rápido por design, o que facilita ataques de força bruta e tabelas pré-computadas. Para senhas, usa-se bcrypt, scrypt ou Argon2, que são deliberadamente lentos e incorporam salt único por senha.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'seguranca'),
     'a5000000-0000-4000-8000-000000000002',
     'O que uma assinatura digital garante?',
     'Integridade (o conteúdo não foi alterado) e autenticidade/não-repúdio (a mensagem veio de quem tem a chave privada correspondente, e essa parte não pode negar o envio).',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'seguranca'),
     'a5000000-0000-4000-8000-000000000003',
     'O TLS protege contra SQL injection ou XSS?',
     'Não. TLS garante confidencialidade, integridade e autenticidade do servidor no transporte dos dados, mas não valida nem protege o conteúdo/lógica da aplicação contra vulnerabilidades como SQL injection ou XSS.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'seguranca'),
     'a5000000-0000-4000-8000-000000000003',
     'O que é a "cadeia de confiança" de um certificado TLS?',
     'A sequência de assinaturas que liga o certificado do site a uma Autoridade Certificadora raiz confiável, pré-instalada no sistema/navegador, permitindo validar a autenticidade do certificado sem troca manual de chaves.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'seguranca'),
     'a5000000-0000-4000-8000-000000000003',
     'O que é "forward secrecy" no TLS 1.3?',
     'Propriedade que garante que, mesmo se uma chave privada for comprometida no futuro, sessões passadas cifradas com chaves de sessão efêmeras (negociadas via Diffie-Hellman) continuam protegidas.',
     'dificil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'seguranca'),
     'a5000000-0000-4000-8000-000000000004',
     'Qual é a defesa padrão contra SQL Injection?',
     'Prepared statements (queries parametrizadas), que tratam a entrada do usuário sempre como dado, nunca como parte da sintaxe SQL, independentemente do conteúdo digitado.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'seguranca'),
     'a5000000-0000-4000-8000-000000000004',
     'Qual a diferença entre XSS refletido e XSS armazenado?',
     'No refletido, o payload malicioso vem de um parâmetro da própria requisição (ex.: link malicioso); no armazenado, o payload é salvo no servidor e servido a qualquer usuário que acessar aquele conteúdo depois, atingindo mais vítimas.',
     'media', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'seguranca'),
     'a5000000-0000-4000-8000-000000000004',
     'Como o atributo de cookie SameSite ajuda a mitigar CSRF?',
     'Impede que o navegador envie automaticamente o cookie de sessão em requisições disparadas por sites de terceiros, quebrando o mecanismo que o CSRF explora.',
     'dificil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'seguranca'),
     'a5000000-0000-4000-8000-000000000005',
     'O que é o princípio do menor privilégio?',
     'Cada usuário, processo ou serviço deve ter acesso apenas ao mínimo necessário para desempenhar sua função, limitando o dano possível caso uma credencial seja comprometida.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'seguranca'),
     'a5000000-0000-4000-8000-000000000005',
     'Qual código HTTP deve ser retornado quando um cliente excede o rate limit?',
     '429 (Too Many Requests), idealmente acompanhado de cabeçalhos indicando quando o cliente pode tentar novamente.',
     'facil', 'v1', 'rascunho'),
    ((SELECT id FROM domain WHERE slug = 'seguranca'),
     'a5000000-0000-4000-8000-000000000005',
     'Por que "defesa em profundidade" é preferível a uma única medida de segurança forte?',
     'Porque nenhuma medida isolada é infalível; camadas independentes (rede, aplicação, autenticação, monitoramento) garantem que a falha de uma camada não comprometa o sistema inteiro.',
     'dificil', 'v1', 'rascunho');

-- =====================================================================================
-- QUESTIONS + ALTERNATIVAS (18: 6 facil, 6 media, 6 dificil)
-- =====================================================================================

-- FÁCIL 1
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000001',
        'Em um sistema web, qual das opções abaixo descreve corretamente o papel da autorização, em contraste com a autenticação?',
        'Autenticação verifica identidade ("quem é você"); autorização verifica permissão ("o que você pode fazer"), e deve ser checada a cada operação sensível, mesmo dentro de uma sessão já autenticada.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Em um sistema web, qual das opções abaixo descreve corretamente o papel da autorização, em contraste com a autenticação?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Autorização decide se um usuário já identificado tem permissão para executar uma ação específica.', true),
    ((SELECT id FROM question WHERE enunciado = 'Em um sistema web, qual das opções abaixo descreve corretamente o papel da autorização, em contraste com a autenticação?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Autorização é o processo de verificar a senha do usuário no momento do login.', false),
    ((SELECT id FROM question WHERE enunciado = 'Em um sistema web, qual das opções abaixo descreve corretamente o papel da autorização, em contraste com a autenticação?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Autorização e autenticação são sinônimos e podem ser usadas indistintamente.', false),
    ((SELECT id FROM question WHERE enunciado = 'Em um sistema web, qual das opções abaixo descreve corretamente o papel da autorização, em contraste com a autenticação?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Autorização só precisa ser verificada uma vez, no login, e vale para toda a sessão.', false);

-- FÁCIL 2
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000002',
        'Por que senhas de usuários não devem ser armazenadas usando um hash genérico rápido como SHA-256 puro?',
        'Hashes genéricos rápidos facilitam ataques de força bruta e tabelas pré-computadas; funções como bcrypt, scrypt e Argon2 são deliberadamente lentas e usam salt, tornando esses ataques inviáveis na prática.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Por que senhas de usuários não devem ser armazenadas usando um hash genérico rápido como SHA-256 puro?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque hashes rápidos facilitam ataques de força bruta e tabelas pré-computadas contra senhas.', true),
    ((SELECT id FROM question WHERE enunciado = 'Por que senhas de usuários não devem ser armazenadas usando um hash genérico rápido como SHA-256 puro?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque o SHA-256 não é compatível com bancos de dados relacionais.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que senhas de usuários não devem ser armazenadas usando um hash genérico rápido como SHA-256 puro?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque o SHA-256 criptografa a senha de forma reversível, permitindo que qualquer pessoa a recupere.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que senhas de usuários não devem ser armazenadas usando um hash genérico rápido como SHA-256 puro?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque o SHA-256 exige que a senha seja enviada em texto puro pela rede.', false);

-- FÁCIL 3
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000003',
        'O uso de HTTPS (TLS) em uma aplicação web é suficiente para proteger a aplicação contra SQL injection?',
        'TLS protege a comunicação em trânsito (confidencialidade, integridade e autenticidade do servidor), mas não valida nem protege a lógica da aplicação — SQL injection exige defesas próprias, como prepared statements.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O uso de HTTPS (TLS) em uma aplicação web é suficiente para proteger a aplicação contra SQL injection?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Não, TLS protege o transporte dos dados, não a lógica da aplicação contra SQL injection.', true),
    ((SELECT id FROM question WHERE enunciado = 'O uso de HTTPS (TLS) em uma aplicação web é suficiente para proteger a aplicação contra SQL injection?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Sim, o TLS cifra as queries SQL antes de chegarem ao banco de dados.', false),
    ((SELECT id FROM question WHERE enunciado = 'O uso de HTTPS (TLS) em uma aplicação web é suficiente para proteger a aplicação contra SQL injection?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Sim, porque o TLS impede qualquer alteração no conteúdo da requisição HTTP.', false),
    ((SELECT id FROM question WHERE enunciado = 'O uso de HTTPS (TLS) em uma aplicação web é suficiente para proteger a aplicação contra SQL injection?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Sim, desde que o certificado seja emitido por uma Autoridade Certificadora confiável.', false);

-- FÁCIL 4
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000004',
        'Qual é a defesa padrão e mais eficaz contra SQL Injection?',
        'Prepared statements (queries parametrizadas) tratam a entrada do usuário sempre como dado, nunca como parte da sintaxe SQL, eliminando a possibilidade de injeção independentemente do conteúdo informado.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual é a defesa padrão e mais eficaz contra SQL Injection?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Uso de prepared statements (queries parametrizadas).', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual é a defesa padrão e mais eficaz contra SQL Injection?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Concatenar a entrada do usuário diretamente na query, mas em letras minúsculas.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é a defesa padrão e mais eficaz contra SQL Injection?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Habilitar TLS na conexão entre aplicação e banco de dados.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é a defesa padrão e mais eficaz contra SQL Injection?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Aumentar o rate limiting do endpoint que recebe a entrada.', false);

-- FÁCIL 5
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000005',
        'O que estabelece o princípio do menor privilégio?',
        'O princípio do menor privilégio determina que usuários, processos e serviços devem ter apenas o acesso mínimo necessário para sua função, reduzindo o dano possível em caso de comprometimento.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que estabelece o princípio do menor privilégio?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Que cada usuário ou serviço deve ter apenas o acesso mínimo necessário para desempenhar sua função.', true),
    ((SELECT id FROM question WHERE enunciado = 'O que estabelece o princípio do menor privilégio?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Que todo usuário autenticado deve ter acesso de administrador por padrão.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que estabelece o princípio do menor privilégio?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Que credenciais de serviços nunca devem expirar, para evitar interrupções.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que estabelece o princípio do menor privilégio?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Que apenas o time de segurança pode ter qualquer tipo de acesso ao sistema.', false);

-- FÁCIL 6
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000005',
        'Qual código de status HTTP é o padrão para indicar que um cliente excedeu o limite de requisições (rate limiting)?',
        'O código 429 (Too Many Requests) é o padrão HTTP para indicar que o cliente enviou requisições demais em um determinado período de tempo.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual código de status HTTP é o padrão para indicar que um cliente excedeu o limite de requisições (rate limiting)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     '429 (Too Many Requests).', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual código de status HTTP é o padrão para indicar que um cliente excedeu o limite de requisições (rate limiting)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     '403 (Forbidden).', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual código de status HTTP é o padrão para indicar que um cliente excedeu o limite de requisições (rate limiting)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     '500 (Internal Server Error).', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual código de status HTTP é o padrão para indicar que um cliente excedeu o limite de requisições (rate limiting)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     '408 (Request Timeout).', false);

-- MÉDIA 1
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000001',
        'No fluxo Authorization Code do OAuth2, qual é o propósito de trocar o código de autorização por um access token em uma chamada servidor-a-servidor, em vez de já devolver o token diretamente ao navegador?',
        'Essa troca acontece fora do navegador para evitar que o access token fique exposto na URL ou no histórico do navegador; o código de autorização, de uso único e curto, é o único artefato exposto ao cliente até a troca segura.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'No fluxo Authorization Code do OAuth2, qual é o propósito de trocar o código de autorização por um access token em uma chamada servidor-a-servidor, em vez de já devolver o token diretamente ao navegador?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Evitar expor o access token diretamente no navegador, reduzindo o risco de vazamento via URL, histórico ou logs.', true),
    ((SELECT id FROM question WHERE enunciado = 'No fluxo Authorization Code do OAuth2, qual é o propósito de trocar o código de autorização por um access token em uma chamada servidor-a-servidor, em vez de já devolver o token diretamente ao navegador?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Reduzir o número de requisições HTTP totais do fluxo de autenticação.', false),
    ((SELECT id FROM question WHERE enunciado = 'No fluxo Authorization Code do OAuth2, qual é o propósito de trocar o código de autorização por um access token em uma chamada servidor-a-servidor, em vez de já devolver o token diretamente ao navegador?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Permitir que o servidor de autorização evite implementar TLS.', false),
    ((SELECT id FROM question WHERE enunciado = 'No fluxo Authorization Code do OAuth2, qual é o propósito de trocar o código de autorização por um access token em uma chamada servidor-a-servidor, em vez de já devolver o token diretamente ao navegador?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Substituir a necessidade de o usuário se autenticar no servidor de autorização.', false);

-- MÉDIA 2
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000002',
        'Por que o TLS utiliza criptografia híbrida (assimétrica no handshake, simétrica no restante da sessão), em vez de usar apenas criptografia assimétrica para toda a comunicação?',
        'Criptografia assimétrica é significativamente mais lenta computacionalmente; ela é usada só para negociar com segurança uma chave simétrica efêmera, e a comunicação de fato usa criptografia simétrica, muito mais rápida para grandes volumes de dados.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Por que o TLS utiliza criptografia híbrida (assimétrica no handshake, simétrica no restante da sessão), em vez de usar apenas criptografia assimétrica para toda a comunicação?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque a criptografia assimétrica é muito mais lenta, então é usada só para negociar a chave simétrica que cifra o restante da sessão.', true),
    ((SELECT id FROM question WHERE enunciado = 'Por que o TLS utiliza criptografia híbrida (assimétrica no handshake, simétrica no restante da sessão), em vez de usar apenas criptografia assimétrica para toda a comunicação?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque a criptografia assimétrica não é suportada pela maioria dos navegadores modernos.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que o TLS utiliza criptografia híbrida (assimétrica no handshake, simétrica no restante da sessão), em vez de usar apenas criptografia assimétrica para toda a comunicação?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque criptografia simétrica garante autenticidade do servidor e a assimétrica não.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que o TLS utiliza criptografia híbrida (assimétrica no handshake, simétrica no restante da sessão), em vez de usar apenas criptografia assimétrica para toda a comunicação?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque certificados digitais só podem ser validados usando criptografia simétrica.', false);

-- MÉDIA 3
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000003',
        'O que significa dizer que um certificado TLS faz parte de uma "cadeia de confiança"?',
        'Significa que o certificado do site é assinado por uma CA intermediária, que por sua vez foi certificada por uma CA raiz confiável e pré-instalada no sistema/navegador — se qualquer elo da cadeia não puder ser validado, o certificado é rejeitado.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que significa dizer que um certificado TLS faz parte de uma "cadeia de confiança"?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'O certificado do site é validado por meio de uma sequência de assinaturas até uma CA raiz confiável e pré-instalada.', true),
    ((SELECT id FROM question WHERE enunciado = 'O que significa dizer que um certificado TLS faz parte de uma "cadeia de confiança"?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'O certificado é compartilhado manualmente entre servidor e cliente antes de cada conexão.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que significa dizer que um certificado TLS faz parte de uma "cadeia de confiança"?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'O certificado nunca expira, garantindo confiança permanente no domínio.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que significa dizer que um certificado TLS faz parte de uma "cadeia de confiança"?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'O navegador confia em qualquer certificado autoassinado apresentado pelo servidor.', false);

-- MÉDIA 4
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000004',
        'Qual a principal diferença entre XSS refletido e XSS armazenado (persistente)?',
        'No refletido, o payload malicioso vem de um parâmetro da própria requisição (ex.: um link malicioso); no armazenado, o payload é salvo no servidor e servido a qualquer usuário que visualizar aquele conteúdo depois, geralmente afetando mais vítimas.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual a principal diferença entre XSS refletido e XSS armazenado (persistente)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'O XSS refletido depende de um parâmetro na requisição, enquanto o armazenado persiste no servidor e atinge múltiplos usuários.', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual a principal diferença entre XSS refletido e XSS armazenado (persistente)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'O XSS refletido só ocorre em APIs REST, enquanto o armazenado só ocorre em aplicações server-side rendered.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual a principal diferença entre XSS refletido e XSS armazenado (persistente)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'O XSS refletido explora o banco de dados, enquanto o armazenado explora apenas cookies.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual a principal diferença entre XSS refletido e XSS armazenado (persistente)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Não há diferença prática; são apenas nomes alternativos para o mesmo ataque.', false);

-- MÉDIA 5
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000004',
        'Como um ataque CSRF consegue executar uma ação em nome de uma vítima já autenticada em outro site?',
        'O navegador anexa automaticamente cookies de sessão a requisições feitas para o domínio dono do cookie, mesmo quando a requisição é disparada por uma página maliciosa em outro domínio, fazendo o servidor tratar a ação como legítima.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Como um ataque CSRF consegue executar uma ação em nome de uma vítima já autenticada em outro site?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Explorando o envio automático de cookies de sessão pelo navegador em requisições disparadas por outro site.', true),
    ((SELECT id FROM question WHERE enunciado = 'Como um ataque CSRF consegue executar uma ação em nome de uma vítima já autenticada em outro site?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Roubando diretamente a senha da vítima por meio de um formulário falso.', false),
    ((SELECT id FROM question WHERE enunciado = 'Como um ataque CSRF consegue executar uma ação em nome de uma vítima já autenticada em outro site?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Interceptando o tráfego TLS entre a vítima e o servidor legítimo.', false),
    ((SELECT id FROM question WHERE enunciado = 'Como um ataque CSRF consegue executar uma ação em nome de uma vítima já autenticada em outro site?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Injetando comandos SQL diretamente na sessão ativa da vítima.', false);

-- MÉDIA 6
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000005',
        'Por que rate limiting é frequentemente aplicado em múltiplos níveis (por IP, por conta de usuário e por endpoint), em vez de um único limite global?',
        'Cada nível contém um tipo diferente de abuso: por IP contém ataques distribuídos de forma limitada, por conta contém abuso de uma conta específica, e por endpoint permite limites mais agressivos em rotas sensíveis (como login), sem afetar rotas públicas de baixo risco.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Por que rate limiting é frequentemente aplicado em múltiplos níveis (por IP, por conta de usuário e por endpoint), em vez de um único limite global?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque cada nível contém um tipo diferente de abuso, permitindo limites mais agressivos em endpoints sensíveis sem penalizar rotas de baixo risco.', true),
    ((SELECT id FROM question WHERE enunciado = 'Por que rate limiting é frequentemente aplicado em múltiplos níveis (por IP, por conta de usuário e por endpoint), em vez de um único limite global?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque um único limite global é proibido pelas especificações do protocolo HTTP.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que rate limiting é frequentemente aplicado em múltiplos níveis (por IP, por conta de usuário e por endpoint), em vez de um único limite global?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque múltiplos níveis eliminam completamente a necessidade de autenticação.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que rate limiting é frequentemente aplicado em múltiplos níveis (por IP, por conta de usuário e por endpoint), em vez de um único limite global?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque cada nível de rate limiting substitui a necessidade de TLS.', false);

-- DIFÍCIL 1
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000001',
        'Um sistema usa JWTs com vida útil de 30 dias e nenhum mecanismo de revogação. Qual é o principal risco arquitetural dessa decisão?',
        'Como o JWT é stateless (o servidor não consulta uma tabela de sessões para validá-lo), não há como invalidar um token comprometido antes de sua expiração natural sem introduzir um mecanismo adicional (blocklist ou redução do tempo de vida com refresh tokens), o que anula parte da vantagem de escalabilidade do JWT.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Um sistema usa JWTs com vida útil de 30 dias e nenhum mecanismo de revogação. Qual é o principal risco arquitetural dessa decisão?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Um token comprometido continua válido por até 30 dias, já que não há como revogá-lo antes da expiração natural sem mecanismo adicional.', true),
    ((SELECT id FROM question WHERE enunciado = 'Um sistema usa JWTs com vida útil de 30 dias e nenhum mecanismo de revogação. Qual é o principal risco arquitetural dessa decisão?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'O JWT deixará de funcionar automaticamente após 24 horas, independentemente da configuração.', false),
    ((SELECT id FROM question WHERE enunciado = 'Um sistema usa JWTs com vida útil de 30 dias e nenhum mecanismo de revogação. Qual é o principal risco arquitetural dessa decisão?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Tokens com vida longa impedem a validação da assinatura pelo servidor.', false),
    ((SELECT id FROM question WHERE enunciado = 'Um sistema usa JWTs com vida útil de 30 dias e nenhum mecanismo de revogação. Qual é o principal risco arquitetural dessa decisão?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Nenhum risco relevante, já que o payload do JWT é sempre criptografado.', false);

-- DIFÍCIL 2
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000002',
        'Um serviço assina mensagens cifrando o hash do conteúdo com sua chave privada e anexando a assinatura à mensagem original (não cifrada). Por que isso garante integridade e autenticidade, mas não confidencialidade?',
        'A mensagem original permanece legível por qualquer um (não confidencial); a assinatura só garante que o conteúdo não foi alterado e que veio do dono da chave privada, pois qualquer receptor pode recalcular o hash e verificar com a chave pública. Para confidencialidade seria necessário cifrar também o conteúdo, não apenas assiná-lo.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Um serviço assina mensagens cifrando o hash do conteúdo com sua chave privada e anexando a assinatura à mensagem original (não cifrada). Por que isso garante integridade e autenticidade, mas não confidencialidade?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque a mensagem original permanece legível por qualquer um; só o hash é protegido pela assinatura, não o conteúdo em si.', true),
    ((SELECT id FROM question WHERE enunciado = 'Um serviço assina mensagens cifrando o hash do conteúdo com sua chave privada e anexando a assinatura à mensagem original (não cifrada). Por que isso garante integridade e autenticidade, mas não confidencialidade?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque a chave privada usada na assinatura é a mesma usada para cifrar dados simétricos.', false),
    ((SELECT id FROM question WHERE enunciado = 'Um serviço assina mensagens cifrando o hash do conteúdo com sua chave privada e anexando a assinatura à mensagem original (não cifrada). Por que isso garante integridade e autenticidade, mas não confidencialidade?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque assinaturas digitais nunca usam funções de hash, apenas cifragem direta do conteúdo.', false),
    ((SELECT id FROM question WHERE enunciado = 'Um serviço assina mensagens cifrando o hash do conteúdo com sua chave privada e anexando a assinatura à mensagem original (não cifrada). Por que isso garante integridade e autenticidade, mas não confidencialidade?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque a chave pública do emissor nunca pode ser usada por terceiros para verificar a assinatura.', false);

-- DIFÍCIL 3
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000003',
        'O que "forward secrecy" (usada no TLS 1.3 via chaves de sessão efêmeras) protege especificamente, que uma negociação de chave estática não protegeria?',
        'Forward secrecy garante que, mesmo que a chave privada de longo prazo do servidor seja comprometida no futuro, um atacante que gravou tráfego cifrado de sessões passadas não consegue decifrá-las retroativamente, pois cada sessão usou uma chave efêmera descartada ao final, nunca derivável só a partir da chave privada estática.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que "forward secrecy" (usada no TLS 1.3 via chaves de sessão efêmeras) protege especificamente, que uma negociação de chave estática não protegeria?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Sessões passadas continuam protegidas mesmo que a chave privada de longo prazo do servidor seja comprometida depois.', true),
    ((SELECT id FROM question WHERE enunciado = 'O que "forward secrecy" (usada no TLS 1.3 via chaves de sessão efêmeras) protege especificamente, que uma negociação de chave estática não protegeria?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Impede qualquer ataque de força bruta contra a senha do usuário.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que "forward secrecy" (usada no TLS 1.3 via chaves de sessão efêmeras) protege especificamente, que uma negociação de chave estática não protegeria?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Garante que o certificado do servidor nunca expira.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que "forward secrecy" (usada no TLS 1.3 via chaves de sessão efêmeras) protege especificamente, que uma negociação de chave estática não protegeria?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Elimina a necessidade de Autoridades Certificadoras na cadeia de confiança.', false);

-- DIFÍCIL 4
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000004',
        'Uma API que autentica exclusivamente via token em cabeçalho Authorization (sem uso de cookies) é, por padrão, menos vulnerável a CSRF do que uma aplicação baseada em sessão via cookie. Por quê?',
        'CSRF depende do navegador anexar automaticamente uma credencial (cookie) a requisições disparadas por outro site. Como o navegador não anexa cabeçalhos customizados como Authorization automaticamente a requisições cross-site, um site malicioso não consegue forjar uma requisição autenticada sem já possuir o token, o que normalmente não é o caso.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Uma API que autentica exclusivamente via token em cabeçalho Authorization (sem uso de cookies) é, por padrão, menos vulnerável a CSRF do que uma aplicação baseada em sessão via cookie. Por quê?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque o navegador não anexa automaticamente cabeçalhos customizados a requisições cross-site, ao contrário do que faz com cookies.', true),
    ((SELECT id FROM question WHERE enunciado = 'Uma API que autentica exclusivamente via token em cabeçalho Authorization (sem uso de cookies) é, por padrão, menos vulnerável a CSRF do que uma aplicação baseada em sessão via cookie. Por quê?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque tokens em cabeçalho Authorization são sempre cifrados com TLS mútuo.', false),
    ((SELECT id FROM question WHERE enunciado = 'Uma API que autentica exclusivamente via token em cabeçalho Authorization (sem uso de cookies) é, por padrão, menos vulnerável a CSRF do que uma aplicação baseada em sessão via cookie. Por quê?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque tokens em cabeçalho nunca expiram, eliminando a superfície de ataque.', false),
    ((SELECT id FROM question WHERE enunciado = 'Uma API que autentica exclusivamente via token em cabeçalho Authorization (sem uso de cookies) é, por padrão, menos vulnerável a CSRF do que uma aplicação baseada em sessão via cookie. Por quê?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque essas APIs são imunes a XSS, o que elimina indiretamente o CSRF.', false);

-- DIFÍCIL 5
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000005',
        'Por que mitigar um ataque DDoS raramente é resolvido bloqueando os IPs de origem, ao contrário de um ataque de força bruta partindo de uma única máquina?',
        'Um DDoS é distribuído entre múltiplas origens, tipicamente uma botnet de máquinas comprometidas; bloquear IPs individuais não escala e pode não acompanhar o volume de origens distintas, exigindo defesa em camadas (CDN/WAF na borda, rate limiting, autoscaling) em vez de uma única lista de bloqueio.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Por que mitigar um ataque DDoS raramente é resolvido bloqueando os IPs de origem, ao contrário de um ataque de força bruta partindo de uma única máquina?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque o tráfego malicioso vem de múltiplas origens distribuídas, tornando bloqueio individual de IP ineficaz em escala.', true),
    ((SELECT id FROM question WHERE enunciado = 'Por que mitigar um ataque DDoS raramente é resolvido bloqueando os IPs de origem, ao contrário de um ataque de força bruta partindo de uma única máquina?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque ataques DDoS sempre usam o mesmo IP de origem repetidamente, o que impede o bloqueio.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que mitigar um ataque DDoS raramente é resolvido bloqueando os IPs de origem, ao contrário de um ataque de força bruta partindo de uma única máquina?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque bloquear IPs é proibido pelas normas de neutralidade de rede.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que mitigar um ataque DDoS raramente é resolvido bloqueando os IPs de origem, ao contrário de um ataque de força bruta partindo de uma única máquina?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque ataques DDoS não utilizam o protocolo IP, apenas camadas de aplicação.', false);

-- DIFÍCIL 6
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000001',
        'Por que aceitar o algoritmo "none" (ou permitir que o cliente escolha o algoritmo de verificação) na validação de um JWT é considerado uma falha grave de segurança?',
        'Se o servidor confia no algoritmo declarado pelo próprio token, um atacante pode forjar um token com o algoritmo "none" (sem assinatura) ou trocar o algoritmo esperado por um mais fraco, fazendo o servidor aceitar um token adulterado como válido. O algoritmo de verificação deve sempre ser fixado no lado do servidor, nunca decidido a partir do próprio token recebido.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Por que aceitar o algoritmo "none" (ou permitir que o cliente escolha o algoritmo de verificação) na validação de um JWT é considerado uma falha grave de segurança?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque um atacante pode forjar um token sem assinatura válida e o servidor o aceitaria como legítimo se confiar no algoritmo declarado pelo próprio token.', true),
    ((SELECT id FROM question WHERE enunciado = 'Por que aceitar o algoritmo "none" (ou permitir que o cliente escolha o algoritmo de verificação) na validação de um JWT é considerado uma falha grave de segurança?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque o algoritmo "none" torna o token maior e mais lento de transmitir.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que aceitar o algoritmo "none" (ou permitir que o cliente escolha o algoritmo de verificação) na validação de um JWT é considerado uma falha grave de segurança?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque tokens com algoritmo "none" não podem ser codificados em Base64.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que aceitar o algoritmo "none" (ou permitir que o cliente escolha o algoritmo de verificação) na validação de um JWT é considerado uma falha grave de segurança?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque esse algoritmo é incompatível com o padrão de três partes (header, payload, signature) do JWT.', false);
