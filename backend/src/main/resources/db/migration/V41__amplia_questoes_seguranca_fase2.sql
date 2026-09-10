-- Ampliação do pool de Questions — Domínio Segurança (Fase 2: 36 -> 54)
-- Origem: docs/product/tickets/TICKET-content-expansion-questoes-fase2.md (+ ticket mestre
-- TICKET-content-database.md + ticket da Fase 1 TICKET-content-expansion-questoes.md).
-- Autoria assistida por IA, rascunho técnico, sujeito a revisão humana obrigatória antes de
-- status_revisao = 'revisado_aprovado'.
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
-- domain_ref usa subquery por slug (mesmo padrão do V20/V32). content_version = 'v1' e
-- status_revisao = 'rascunho' em todas as linhas (mesma leva lógica, conforme OPEN
-- QUESTION-008 do ticket de Fase 2, resolvida a favor de reaproveitar 'v1').
--
-- Não-duplicação: V20 (18 Questions da seed) e V32 (18 Questions da Fase 1) foram lidos
-- integralmente antes de escrever este arquivo. As 18 Questions abaixo cobrem ângulos e
-- vulnerabilidades ainda não testados nesses 36 enunciados anteriores — nenhuma
-- reformulação disfarçada dos mesmos pontos (AuthN vs AuthZ genérico, OAuth2/OIDC/JWT já
-- detalhados, hashing de senha, TLS handshake/cadeia de confiança/mTLS/OCSP/forward
-- secrecy, SQL Injection/XSS/CSRF/SOP, rate limiting/circuit breaker/DDoS/least privilege
-- já cobertos anteriormente). Novos ângulos introduzidos nesta leva: IDOR/Broken Access
-- Control, gestão de segredos (hardcoded credentials), MFA, HSTS e downgrade attack,
-- Command Injection, atributo de cookie HttpOnly, criptografia em repouso vs trânsito,
-- Open Redirect, enumeração de contas, rate limiting vs account lockout, Insecure
-- Deserialization, SSRF, dependências vulneráveis desatualizadas, timing attack em
-- comparação de tokens, logging de segurança, e CORS mal configurado.
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
        'O que caracteriza uma vulnerabilidade de IDOR (Insecure Direct Object Reference)?',
        'IDOR ocorre quando uma aplicação expõe uma referência direta a um objeto interno (como um ID sequencial em uma URL) e permite que o usuário o acesse ou manipule sem verificar se ele realmente tem permissão sobre aquele recurso específico.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza uma vulnerabilidade de IDOR (Insecure Direct Object Reference)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Um recurso é acessado por meio de uma referência direta (como um ID na URL) sem que o servidor verifique se o solicitante tem permissão sobre aquele recurso específico.', true),
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza uma vulnerabilidade de IDOR (Insecure Direct Object Reference)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Um atacante injeta comandos SQL diretamente em um campo de formulário.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza uma vulnerabilidade de IDOR (Insecure Direct Object Reference)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Um certificado TLS é assinado por uma Autoridade Certificadora não confiável.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que caracteriza uma vulnerabilidade de IDOR (Insecure Direct Object Reference)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Um cookie de sessão é enviado sem o atributo Secure.', false);

-- FÁCIL 2
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000005',
        'Por que armazenar credenciais e chaves de API diretamente no código-fonte (hardcoded), inclusive em repositórios privados, é considerado uma prática perigosa?',
        'Código-fonte costuma ser copiado, versionado em múltiplos ambientes e acessado por mais pessoas do que o necessário para conhecer um segredo; uma vez commitado, o segredo permanece no histórico do repositório mesmo após removido do arquivo atual, exigindo rotação da credencial (e não apenas exclusão da linha) caso vaze.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Por que armazenar credenciais e chaves de API diretamente no código-fonte (hardcoded), inclusive em repositórios privados, é considerado uma prática perigosa?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque o segredo fica exposto a qualquer pessoa com acesso ao repositório e permanece no histórico de versões mesmo depois de removido do arquivo atual.', true),
    ((SELECT id FROM question WHERE enunciado = 'Por que armazenar credenciais e chaves de API diretamente no código-fonte (hardcoded), inclusive em repositórios privados, é considerado uma prática perigosa?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque o compilador rejeita strings literais consideradas confidenciais.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que armazenar credenciais e chaves de API diretamente no código-fonte (hardcoded), inclusive em repositórios privados, é considerado uma prática perigosa?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque isso torna a aplicação incompatível com HTTPS.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que armazenar credenciais e chaves de API diretamente no código-fonte (hardcoded), inclusive em repositórios privados, é considerado uma prática perigosa?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque credenciais hardcoded fazem o build da aplicação falhar automaticamente.', false);

-- FÁCIL 3
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000001',
        'O que é autenticação multifator (MFA) e por que ela reduz o risco de uma conta ser comprometida mesmo se a senha vazar?',
        'MFA exige pelo menos dois fatores independentes de verificação (algo que o usuário sabe, como a senha; algo que possui, como um token ou app autenticador; ou algo que é, como biometria); um atacante que descobre apenas a senha ainda precisa comprometer o segundo fator para acessar a conta.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que é autenticação multifator (MFA) e por que ela reduz o risco de uma conta ser comprometida mesmo se a senha vazar?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'MFA exige mais de um fator independente de verificação, então descobrir apenas a senha não é suficiente para o atacante acessar a conta.', true),
    ((SELECT id FROM question WHERE enunciado = 'O que é autenticação multifator (MFA) e por que ela reduz o risco de uma conta ser comprometida mesmo se a senha vazar?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'MFA substitui completamente a necessidade de senha, exigindo apenas um token físico.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é autenticação multifator (MFA) e por que ela reduz o risco de uma conta ser comprometida mesmo se a senha vazar?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'MFA é a prática de exigir a mesma senha duas vezes seguidas no formulário de login.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é autenticação multifator (MFA) e por que ela reduz o risco de uma conta ser comprometida mesmo se a senha vazar?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'MFA cifra a senha do usuário com dois algoritmos diferentes antes de armazená-la.', false);

-- FÁCIL 4
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000003',
        'Qual é o propósito do cabeçalho HSTS (HTTP Strict Transport Security)?',
        'HSTS instrui o navegador a sempre se conectar ao domínio exclusivamente via HTTPS por um período determinado, mesmo que o usuário digite ou clique em um link http://, eliminando a janela de exposição de uma primeira requisição feita em texto claro que poderia ser interceptada.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual é o propósito do cabeçalho HSTS (HTTP Strict Transport Security)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Instruir o navegador a sempre usar HTTPS para aquele domínio, mesmo que o usuário tente acessá-lo via HTTP.', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o propósito do cabeçalho HSTS (HTTP Strict Transport Security)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Definir quais origens podem carregar scripts na página.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o propósito do cabeçalho HSTS (HTTP Strict Transport Security)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Aumentar automaticamente o tempo de expiração do certificado TLS do servidor.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o propósito do cabeçalho HSTS (HTTP Strict Transport Security)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Validar automaticamente a entrada do usuário contra SQL injection.', false);

-- FÁCIL 5
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000004',
        'O que é um ataque de Command Injection (injeção de comando de sistema operacional)?',
        'Command Injection ocorre quando uma aplicação repassa entrada do usuário, sem validação, para uma chamada de shell/sistema operacional, permitindo que o atacante encadeie comandos arbitrários que serão executados com os privilégios do processo da aplicação — é conceitualmente análogo ao SQL Injection, mas o "código" injetado é interpretado pelo shell, não pelo banco de dados.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que é um ataque de Command Injection (injeção de comando de sistema operacional)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'A execução de comandos arbitrários do sistema operacional a partir de entrada do usuário repassada sem validação a uma chamada de shell.', true),
    ((SELECT id FROM question WHERE enunciado = 'O que é um ataque de Command Injection (injeção de comando de sistema operacional)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'A substituição do certificado TLS do servidor por um certificado falso.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é um ataque de Command Injection (injeção de comando de sistema operacional)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'O envio de um volume excessivo de requisições para esgotar o rate limit de um endpoint.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é um ataque de Command Injection (injeção de comando de sistema operacional)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'A leitura do payload de um JWT interceptado em trânsito.', false);

-- FÁCIL 6
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000005',
        'Qual é o efeito do atributo de cookie HttpOnly?',
        'O atributo HttpOnly impede que o cookie seja acessado por JavaScript no navegador (via document.cookie), reduzindo o impacto de uma eventual vulnerabilidade de XSS, já que um script malicioso injetado na página não conseguiria ler e exfiltrar aquele cookie de sessão.',
        'facil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual é o efeito do atributo de cookie HttpOnly?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Impede que o cookie seja lido por JavaScript no navegador, reduzindo o impacto de XSS sobre esse cookie.', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o efeito do atributo de cookie HttpOnly?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Impede que o cookie seja enviado em requisições cross-site, prevenindo CSRF.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o efeito do atributo de cookie HttpOnly?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Cifra automaticamente o valor do cookie antes de enviá-lo ao navegador.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual é o efeito do atributo de cookie HttpOnly?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Faz o cookie expirar automaticamente após cada requisição.', false);

-- MÉDIA 1
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000004',
        'Em um endpoint GET /pedidos/{id}, um usuário autenticado consegue visualizar pedidos de outros usuários apenas trocando o valor de {id} na URL. Qual correção resolve essa falha de Broken Access Control?',
        'A causa raiz não é o formato da URL (usar IDs sequenciais ou não é irrelevante para a falha em si), mas a ausência de uma checagem no servidor de que o pedido solicitado pertence ao usuário autenticado da requisição; a correção é validar essa posse/permissão a cada acesso, antes de retornar o recurso.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Em um endpoint GET /pedidos/{id}, um usuário autenticado consegue visualizar pedidos de outros usuários apenas trocando o valor de {id} na URL. Qual correção resolve essa falha de Broken Access Control?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Verificar no servidor, a cada requisição, se o pedido solicitado pertence ao usuário autenticado antes de retorná-lo.', true),
    ((SELECT id FROM question WHERE enunciado = 'Em um endpoint GET /pedidos/{id}, um usuário autenticado consegue visualizar pedidos de outros usuários apenas trocando o valor de {id} na URL. Qual correção resolve essa falha de Broken Access Control?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Trocar os IDs sequenciais por UUIDs aleatórios, tornando-os impossíveis de adivinhar.', false),
    ((SELECT id FROM question WHERE enunciado = 'Em um endpoint GET /pedidos/{id}, um usuário autenticado consegue visualizar pedidos de outros usuários apenas trocando o valor de {id} na URL. Qual correção resolve essa falha de Broken Access Control?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Adicionar TLS ao endpoint para cifrar a URL da requisição.', false),
    ((SELECT id FROM question WHERE enunciado = 'Em um endpoint GET /pedidos/{id}, um usuário autenticado consegue visualizar pedidos de outros usuários apenas trocando o valor de {id} na URL. Qual correção resolve essa falha de Broken Access Control?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Aplicar rate limiting mais agressivo nesse endpoint.', false);

-- MÉDIA 2
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000002',
        'Por que cifrar dados sensíveis em repouso (at rest) no banco de dados continua sendo necessário mesmo quando toda a comunicação com a aplicação já usa TLS?',
        'TLS protege os dados apenas enquanto estão em trânsito na rede; uma vez armazenados, ficam expostos a quem tiver acesso direto ao disco, a um backup vazado ou a uma cópia indevida do banco — cenários em que o TLS não oferece nenhuma proteção, pois o canal de rede nem sequer está envolvido.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Por que cifrar dados sensíveis em repouso (at rest) no banco de dados continua sendo necessário mesmo quando toda a comunicação com a aplicação já usa TLS?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque TLS só protege dados em trânsito pela rede; dados armazenados ficam expostos em cenários como acesso direto ao disco ou vazamento de backup, onde o TLS não atua.', true),
    ((SELECT id FROM question WHERE enunciado = 'Por que cifrar dados sensíveis em repouso (at rest) no banco de dados continua sendo necessário mesmo quando toda a comunicação com a aplicação já usa TLS?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque o TLS torna as consultas SQL mais lentas, então a criptografia em repouso compensa esse custo de performance.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que cifrar dados sensíveis em repouso (at rest) no banco de dados continua sendo necessário mesmo quando toda a comunicação com a aplicação já usa TLS?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque o TLS não é compatível com bancos de dados relacionais.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que cifrar dados sensíveis em repouso (at rest) no banco de dados continua sendo necessário mesmo quando toda a comunicação com a aplicação já usa TLS?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque a criptografia em repouso substitui a necessidade de autenticação de usuários.', false);

-- MÉDIA 3
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000003',
        'Um site aceita conexões em HTTP e HTTPS, apenas redirecionando HTTP para HTTPS na resposta, sem cabeçalho HSTS. Por que essa configuração ainda deixa espaço para um ataque de downgrade (SSL stripping)?',
        'Um atacante posicionado na rede (ex.: Wi-Fi público comprometido) pode interceptar a primeira requisição em HTTP, antes do redirecionamento acontecer, e responder no lugar do servidor legítimo, mantendo a vítima presa em HTTP e nunca deixando o navegador migrar para HTTPS; o HSTS elimina essa janela ao fazer o próprio navegador recusar HTTP para aquele domínio desde a memória de visitas anteriores.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Um site aceita conexões em HTTP e HTTPS, apenas redirecionando HTTP para HTTPS na resposta, sem cabeçalho HSTS. Por que essa configuração ainda deixa espaço para um ataque de downgrade (SSL stripping)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Um atacante na rede pode interceptar a requisição HTTP inicial antes do redirecionamento e manter a vítima presa em HTTP, algo que o HSTS evitaria ao forçar o navegador a nunca tentar HTTP para aquele domínio.', true),
    ((SELECT id FROM question WHERE enunciado = 'Um site aceita conexões em HTTP e HTTPS, apenas redirecionando HTTP para HTTPS na resposta, sem cabeçalho HSTS. Por que essa configuração ainda deixa espaço para um ataque de downgrade (SSL stripping)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque redirecionamentos HTTP para HTTPS são proibidos pela especificação do protocolo TLS.', false),
    ((SELECT id FROM question WHERE enunciado = 'Um site aceita conexões em HTTP e HTTPS, apenas redirecionando HTTP para HTTPS na resposta, sem cabeçalho HSTS. Por que essa configuração ainda deixa espaço para um ataque de downgrade (SSL stripping)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque o redirecionamento HTTP para HTTPS invalida automaticamente o certificado do servidor.', false),
    ((SELECT id FROM question WHERE enunciado = 'Um site aceita conexões em HTTP e HTTPS, apenas redirecionando HTTP para HTTPS na resposta, sem cabeçalho HSTS. Por que essa configuração ainda deixa espaço para um ataque de downgrade (SSL stripping)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque sem HSTS o servidor é obrigado a aceitar apenas TLS 1.0.', false);

-- MÉDIA 4
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000004',
        'O que é um ataque de Open Redirect e por que ele é frequentemente explorado em campanhas de phishing?',
        'Open Redirect ocorre quando uma aplicação redireciona o usuário para uma URL informada em um parâmetro, sem validar se o destino pertence a uma lista de domínios confiáveis; atacantes exploram isso enviando links que começam no domínio legítimo (aumentando a confiança da vítima) mas terminam redirecionando para um site malicioso que imita a página de login real.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que é um ataque de Open Redirect e por que ele é frequentemente explorado em campanhas de phishing?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'A aplicação redireciona para uma URL controlada pelo atacante sem validá-la, permitindo links que parecem confiáveis mas levam a um site malicioso.', true),
    ((SELECT id FROM question WHERE enunciado = 'O que é um ataque de Open Redirect e por que ele é frequentemente explorado em campanhas de phishing?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'É a exploração de uma porta de rede deixada aberta por engano em um firewall.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é um ataque de Open Redirect e por que ele é frequentemente explorado em campanhas de phishing?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'É o reaproveitamento de um token de sessão expirado para acessar a conta de outro usuário.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é um ataque de Open Redirect e por que ele é frequentemente explorado em campanhas de phishing?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'É a injeção de comandos SQL por meio de um parâmetro de redirecionamento.', false);

-- MÉDIA 5
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000001',
        'Por que uma tela de login que responde "usuário não encontrado" quando o e-mail não existe e "senha incorreta" quando o e-mail existe facilita um ataque de enumeração de contas?',
        'A diferença de mensagem revela, sem querer, se um determinado e-mail está cadastrado no sistema; um atacante pode automatizar tentativas com uma lista de e-mails e usar essa diferença de resposta para descobrir quais contas existem, informação útil para phishing direcionado ou para focar um ataque de força bruta apenas nas contas confirmadas.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Por que uma tela de login que responde "usuário não encontrado" quando o e-mail não existe e "senha incorreta" quando o e-mail existe facilita um ataque de enumeração de contas?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque a diferença de mensagem revela se um e-mail está cadastrado, permitindo a um atacante mapear contas existentes de forma automatizada.', true),
    ((SELECT id FROM question WHERE enunciado = 'Por que uma tela de login que responde "usuário não encontrado" quando o e-mail não existe e "senha incorreta" quando o e-mail existe facilita um ataque de enumeração de contas?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque mensagens de erro distintas fazem o servidor expor a senha em texto puro na resposta.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que uma tela de login que responde "usuário não encontrado" quando o e-mail não existe e "senha incorreta" quando o e-mail existe facilita um ataque de enumeração de contas?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque isso desabilita automaticamente o hashing de senhas no backend.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que uma tela de login que responde "usuário não encontrado" quando o e-mail não existe e "senha incorreta" quando o e-mail existe facilita um ataque de enumeração de contas?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque essa diferença de mensagem só é visível para o próprio dono da conta.', false);

-- MÉDIA 6
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000005',
        'Qual a diferença entre rate limiting e bloqueio de conta (account lockout) após tentativas de login malsucedidas, e por que depender apenas do lockout pode criar um novo risco?',
        'Rate limiting restringe a frequência de requisições sem necessariamente impedir todo acesso legítimo futuro; account lockout bloqueia a própria conta após N tentativas falhas, o que um atacante pode abusar deliberadamente para negar acesso ao dono legítimo da conta (um ataque de negação de serviço direcionado), bastando errar a senha repetidamente sabendo apenas o e-mail da vítima.',
        'media', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Qual a diferença entre rate limiting e bloqueio de conta (account lockout) após tentativas de login malsucedidas, e por que depender apenas do lockout pode criar um novo risco?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Um atacante pode abusar do lockout propositalmente para negar acesso à conta do dono legítimo, apenas errando a senha repetidamente.', true),
    ((SELECT id FROM question WHERE enunciado = 'Qual a diferença entre rate limiting e bloqueio de conta (account lockout) após tentativas de login malsucedidas, e por que depender apenas do lockout pode criar um novo risco?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Rate limiting e account lockout são termos equivalentes para a mesma técnica de proteção.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual a diferença entre rate limiting e bloqueio de conta (account lockout) após tentativas de login malsucedidas, e por que depender apenas do lockout pode criar um novo risco?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Account lockout torna a senha do usuário visível ao administrador do sistema.', false),
    ((SELECT id FROM question WHERE enunciado = 'Qual a diferença entre rate limiting e bloqueio de conta (account lockout) após tentativas de login malsucedidas, e por que depender apenas do lockout pode criar um novo risco?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Rate limiting só se aplica a APIs internas, nunca a formulários de login públicos.', false);

-- DIFÍCIL 1
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000004',
        'Por que uma vulnerabilidade de Insecure Deserialization pode levar a execução remota de código (RCE), e não apenas a corrupção de dados?',
        'Quando uma aplicação desserializa dados vindos de uma fonte não confiável sem restringir quais classes podem ser instanciadas, um atacante pode construir um objeto serializado malicioso que, ao ser reconstruído, aciona métodos (como construtores ou callbacks de desserialização) de classes já presentes no classpath capazes de executar comandos arbitrários — o processo de "reconstruir o objeto" se torna, na prática, um vetor de execução de código.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Por que uma vulnerabilidade de Insecure Deserialization pode levar a execução remota de código (RCE), e não apenas a corrupção de dados?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque reconstruir um objeto malicioso pode acionar métodos de classes já presentes no classpath capazes de executar comandos, sem que a aplicação valide o que está sendo instanciado.', true),
    ((SELECT id FROM question WHERE enunciado = 'Por que uma vulnerabilidade de Insecure Deserialization pode levar a execução remota de código (RCE), e não apenas a corrupção de dados?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque a desserialização sempre exige que o servidor abra uma porta de rede adicional exposta à internet.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que uma vulnerabilidade de Insecure Deserialization pode levar a execução remota de código (RCE), e não apenas a corrupção de dados?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque objetos serializados são sempre transmitidos sem TLS, permitindo que o atacante os substitua em trânsito.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que uma vulnerabilidade de Insecure Deserialization pode levar a execução remota de código (RCE), e não apenas a corrupção de dados?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque a desserialização de dados é proibida por padrão em qualquer linguagem moderna, e contorná-la já é a falha em si.', false);

-- DIFÍCIL 2
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000004',
        'O que é um ataque SSRF (Server-Side Request Forgery) e por que ele é particularmente perigoso em ambientes de nuvem?',
        'SSRF ocorre quando um atacante induz o servidor a fazer, em nome dele, uma requisição HTTP para um destino escolhido pelo atacante (ex.: informando uma URL em um campo que a aplicação usa internamente para buscar um recurso); em nuvem, isso é especialmente grave porque o servidor pode ter acesso de rede a endpoints de metadados internos (ex.: 169.254.169.254) que expõem credenciais temporárias da instância, permitindo ao atacante escalar de uma simples requisição forjada para acesso a credenciais de infraestrutura.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'O que é um ataque SSRF (Server-Side Request Forgery) e por que ele é particularmente perigoso em ambientes de nuvem?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'O atacante induz o servidor a fazer requisições para um destino de sua escolha, podendo alcançar endpoints internos de metadados de nuvem e obter credenciais da instância.', true),
    ((SELECT id FROM question WHERE enunciado = 'O que é um ataque SSRF (Server-Side Request Forgery) e por que ele é particularmente perigoso em ambientes de nuvem?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'É a falsificação do certificado TLS apresentado por um servidor em nuvem.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é um ataque SSRF (Server-Side Request Forgery) e por que ele é particularmente perigoso em ambientes de nuvem?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'É um tipo de ataque de força bruta contra o painel de administração do provedor de nuvem.', false),
    ((SELECT id FROM question WHERE enunciado = 'O que é um ataque SSRF (Server-Side Request Forgery) e por que ele é particularmente perigoso em ambientes de nuvem?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'É a manipulação do cabeçalho Host de uma requisição para evitar rate limiting.', false);

-- DIFÍCIL 3
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000005',
        'Por que depender de bibliotecas e componentes de terceiros desatualizados, com vulnerabilidades conhecidas publicamente, é um risco real mesmo quando todo o código escrito pela própria equipe está livre de falhas?',
        'Vulnerabilidades conhecidas em dependências são documentadas publicamente (bancos como CVE), incluindo, muitas vezes, exemplos de exploração; um atacante não precisa encontrar uma falha nova no código próprio da aplicação, basta identificar quais versões de bibliotecas estão em uso (às vezes visível externamente, ex.: em cabeçalhos ou mensagens de erro) e aplicar um exploit já publicado contra aquela versão específica.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Por que depender de bibliotecas e componentes de terceiros desatualizados, com vulnerabilidades conhecidas publicamente, é um risco real mesmo quando todo o código escrito pela própria equipe está livre de falhas?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque vulnerabilidades conhecidas são documentadas publicamente, permitindo que um atacante use um exploit já pronto contra a versão da biblioteca em uso, sem precisar descobrir falha nova no código próprio.', true),
    ((SELECT id FROM question WHERE enunciado = 'Por que depender de bibliotecas e componentes de terceiros desatualizados, com vulnerabilidades conhecidas publicamente, é um risco real mesmo quando todo o código escrito pela própria equipe está livre de falhas?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque bibliotecas desatualizadas sempre desabilitam automaticamente o TLS da aplicação.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que depender de bibliotecas e componentes de terceiros desatualizados, com vulnerabilidades conhecidas publicamente, é um risco real mesmo quando todo o código escrito pela própria equipe está livre de falhas?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque o risco só existe se a biblioteca for de código aberto; bibliotecas comerciais fechadas são imunes a esse problema.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que depender de bibliotecas e componentes de terceiros desatualizados, com vulnerabilidades conhecidas publicamente, é um risco real mesmo quando todo o código escrito pela própria equipe está livre de falhas?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque a JVM (ou runtime equivalente) impede a atualização de dependências em produção por padrão.', false);

-- DIFÍCIL 4
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000001',
        'Um endpoint de redefinição de senha compara o token informado pelo usuário com o valor armazenado usando uma comparação ingênua de strings (parando na primeira diferença de caractere). Por que isso pode ser vulnerável a um timing attack?',
        'Uma comparação que retorna assim que encontra o primeiro caractere diferente responde ligeiramente mais rápido quanto mais cedo a divergência ocorrer; medindo repetidamente pequenas variações de tempo de resposta, um atacante pode inferir, caractere por caractere, qual prefixo do token está correto, reconstruindo o token válido sem precisar adivinhá-lo de uma vez. A defesa é usar uma função de comparação em tempo constante, que sempre leva o mesmo tempo independentemente de onde ocorre a diferença.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Um endpoint de redefinição de senha compara o token informado pelo usuário com o valor armazenado usando uma comparação ingênua de strings (parando na primeira diferença de caractere). Por que isso pode ser vulnerável a um timing attack?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque a pequena variação de tempo de resposta, conforme o prefixo correto aumenta, permite a um atacante inferir o token correto caractere por caractere.', true),
    ((SELECT id FROM question WHERE enunciado = 'Um endpoint de redefinição de senha compara o token informado pelo usuário com o valor armazenado usando uma comparação ingênua de strings (parando na primeira diferença de caractere). Por que isso pode ser vulnerável a um timing attack?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque comparações de string ingênuas sempre retornam o token em texto puro na resposta HTTP.', false),
    ((SELECT id FROM question WHERE enunciado = 'Um endpoint de redefinição de senha compara o token informado pelo usuário com o valor armazenado usando uma comparação ingênua de strings (parando na primeira diferença de caractere). Por que isso pode ser vulnerável a um timing attack?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque essa comparação ingênua impede o uso de HTTPS no endpoint.', false),
    ((SELECT id FROM question WHERE enunciado = 'Um endpoint de redefinição de senha compara o token informado pelo usuário com o valor armazenado usando uma comparação ingênua de strings (parando na primeira diferença de caractere). Por que isso pode ser vulnerável a um timing attack?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque o timing attack explora exclusivamente vulnerabilidades de SQL Injection, não de comparação de strings.', false);

-- DIFÍCIL 5
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000005',
        'Por que registrar (logar) tentativas de autenticação falhas e eventos de autorização negada é considerado parte essencial de defesa em profundidade, mesmo em um sistema que já bloqueia essas tentativas em tempo real?',
        'Bloquear uma tentativa maliciosa no momento não garante que o ataque tenha terminado nem revela seu padrão; logs de segurança permitem detectar tentativas distribuídas ou de baixa frequência que passam despercebidas individualmente, reconstruir a linha do tempo de um incidente após o fato, e alimentar alertas que identificam um ataque em andamento antes que ele tenha sucesso — prevenção sem visibilidade deixa a equipe cega a ataques que eventualmente contornam as defesas primárias.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Por que registrar (logar) tentativas de autenticação falhas e eventos de autorização negada é considerado parte essencial de defesa em profundidade, mesmo em um sistema que já bloqueia essas tentativas em tempo real?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque bloquear uma tentativa não garante visibilidade sobre o padrão do ataque; logs permitem detectar tentativas distribuídas, investigar incidentes após o fato e alimentar alertas.', true),
    ((SELECT id FROM question WHERE enunciado = 'Por que registrar (logar) tentativas de autenticação falhas e eventos de autorização negada é considerado parte essencial de defesa em profundidade, mesmo em um sistema que já bloqueia essas tentativas em tempo real?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque logs de segurança substituem completamente a necessidade de autenticação multifator.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que registrar (logar) tentativas de autenticação falhas e eventos de autorização negada é considerado parte essencial de defesa em profundidade, mesmo em um sistema que já bloqueia essas tentativas em tempo real?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque sem esses logs o servidor é legalmente impedido de bloquear qualquer tentativa de login.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que registrar (logar) tentativas de autenticação falhas e eventos de autorização negada é considerado parte essencial de defesa em profundidade, mesmo em um sistema que já bloqueia essas tentativas em tempo real?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque logar essas tentativas cifra automaticamente as credenciais envolvidas.', false);

-- DIFÍCIL 6
INSERT INTO question (domain_ref, concept_ref, enunciado, explicacao, dificuldade, content_version, status_revisao)
VALUES ((SELECT id FROM domain WHERE slug = 'seguranca'),
        'a5000000-0000-4000-8000-000000000004',
        'Por que a combinação de cabeçalhos CORS Access-Control-Allow-Origin: * com Access-Control-Allow-Credentials: true é considerada uma configuração perigosa (e, na prática, rejeitada pelos navegadores)?',
        'Access-Control-Allow-Credentials: true instrui o navegador a enviar cookies/credenciais na requisição cross-origin; combinado com um Allow-Origin que aceita qualquer origem (*), isso permitiria que qualquer site na internet fizesse requisições autenticadas em nome do usuário e lesse a resposta, efetivamente uma falha equivalente a CSRF combinada com vazamento de dados — por isso a especificação exige que, ao usar credentials, o Allow-Origin reflita uma origem específica e validada, nunca o coringa.',
        'dificil', 'v1', 'rascunho');
INSERT INTO question_alternative (question_id, texto, correta)
VALUES
    ((SELECT id FROM question WHERE enunciado = 'Por que a combinação de cabeçalhos CORS Access-Control-Allow-Origin: * com Access-Control-Allow-Credentials: true é considerada uma configuração perigosa (e, na prática, rejeitada pelos navegadores)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque permitiria que qualquer site fizesse requisições autenticadas com as credenciais do usuário e lesse a resposta, combinando efeito de CSRF com vazamento de dados.', true),
    ((SELECT id FROM question WHERE enunciado = 'Por que a combinação de cabeçalhos CORS Access-Control-Allow-Origin: * com Access-Control-Allow-Credentials: true é considerada uma configuração perigosa (e, na prática, rejeitada pelos navegadores)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque essa combinação desativa automaticamente o TLS da conexão.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que a combinação de cabeçalhos CORS Access-Control-Allow-Origin: * com Access-Control-Allow-Credentials: true é considerada uma configuração perigosa (e, na prática, rejeitada pelos navegadores)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque o navegador passaria a aceitar certificados TLS autoassinados de qualquer origem.', false),
    ((SELECT id FROM question WHERE enunciado = 'Por que a combinação de cabeçalhos CORS Access-Control-Allow-Origin: * com Access-Control-Allow-Credentials: true é considerada uma configuração perigosa (e, na prática, rejeitada pelos navegadores)?' AND domain_ref = (SELECT id FROM domain WHERE slug = 'seguranca')),
     'Porque essa combinação impede que a aplicação use cookies com atributo Secure.', false);
