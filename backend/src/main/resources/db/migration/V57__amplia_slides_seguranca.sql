-- Ampliação do pool de Slides — Domínio Segurança (slug 'seguranca'), Fase 1.
-- TICKET-content-expansion-slides-fase1.md: adiciona 2 Slides novos por Concept (ordem 4 =
-- erros comuns/armadilhas, ordem 5 = comparação com alternativa) às 3 já existentes em
-- V20__seed_conteudo_seguranca.sql, elevando o pool para 5 Slides por Concept / 25 no domínio.

-- Concept: Autenticação e Autorização
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a5000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'O erro de autorizar só na interface: por que esconder um botão não protege nada',
     'Um erro conceitual comum é tratar a ocultação de elementos de UI (esconder um botão "Excluir" ou não renderizar um link administrativo) como se fosse a checagem de autorização em si. Parece suficiente porque, na prática, o usuário comum nunca vê a ação proibida e o fluxo "funciona" nos testes manuais. O problema é que o frontend roda inteiramente no dispositivo do usuário, que pode chamar a API diretamente (via curl, DevTools ou um cliente próprio) ignorando completamente a interface — se o endpoint no servidor não verificar de novo se aquele usuário tem permissão para aquela ação específica, a "proteção" era só estética. A regra correta é: toda decisão de autorização que importa deve ser reforçada no backend, a cada requisição; esconder a opção na UI é apenas uma melhoria de experiência, não uma camada de segurança.',
     4, 'v1', 'rascunho'),
    ('a5000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'Sessões server-side vs. tokens (JWT): critérios para escolher o modelo de autenticação',
     'Sessões server-side armazenam o estado de autenticação no servidor (tipicamente em memória ou em um cache como Redis) e entregam ao cliente apenas um identificador opaco (cookie de sessão); tokens como JWT armazenam o próprio estado (claims) no cliente, de forma auto-contida e verificável por assinatura, sem exigir consulta a um armazenamento central a cada requisição. O critério concreto de escolha é o trade-off entre revogação e escalabilidade: sessões são triviais de revogar instantaneamente (basta apagar a entrada no servidor), o que as torna preferíveis quando controle imediato de logout/banimento é crítico; tokens JWT são mais fáceis de escalar horizontalmente entre múltiplos serviços (qualquer serviço com a chave pública valida o token sem bater num armazenamento compartilhado), mas revogar um token antes de expirar exige mecanismos extras (blocklist, tempo de vida curto), tornando-os mais adequados quando a arquitetura já é distribuída e stateless por natureza.',
     5, 'v1', 'rascunho');

-- Concept: Criptografia Aplicada
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a5000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'Reutilizar IV/nonce: o erro sutil que quebra a segurança de cifras modernas',
     'Modos de operação de cifra de bloco amplamente usados em produção, como AES-GCM ou AES-CTR, exigem um IV (vetor de inicialização) ou nonce diferente a cada operação de cifragem feita com a mesma chave. Um erro recorrente é gerar esse valor de forma fixa, previsível ou reutilizá-lo entre mensagens diferentes — parece inofensivo porque o valor "não é secreto" e o código continua compilando e funcionando sem erro aparente, mas cifrar duas mensagens distintas com a mesma chave e o mesmo nonce permite que um atacante recupere informação sobre o conteúdo (no GCM, inclusive comprometer a autenticação da cifra, não só a confidencialidade). A prática correta é gerar o IV/nonce de forma aleatória (ou por contador estritamente não repetido) a cada cifragem e transmiti-lo junto com o texto cifrado — ele não precisa ser secreto, só nunca repetido para a mesma chave.',
     4, 'v1', 'rascunho'),
    ('a5000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'Hashing vs. criptografia reversível: qual usar para cada dado sensível',
     'A escolha entre hashing e criptografia (cifragem) depende de uma pergunta simples: o sistema algum dia precisa recuperar o valor original? Para senhas, a resposta é não — o sistema só precisa comparar o que foi digitado com o que foi armazenado, então hashing unidirecional (bcrypt/Argon2) é a escolha correta, e criptografar a senha de forma reversível seria um risco desnecessário (se a chave de cifragem vazar, todas as senhas viram texto puro de novo). Já para dados como número de cartão de crédito, CPF ou um endereço que a aplicação legitimamente precisa exibir de volta ao usuário em algum fluxo, hashing não serve — o dado precisa ser recuperável, então a escolha correta é criptografia simétrica reversível (com a chave gerenciada por um serviço dedicado, como um KMS). Tratar os dois casos com a mesma ferramenta é o erro mais comum: hashear um dado que precisa ser recuperado, ou cifrar de forma reversível algo que só precisa ser verificado.',
     5, 'v1', 'rascunho');

-- Concept: TLS e Segurança em Trânsito
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a5000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'Desabilitar a verificação de certificado "só para resolver o erro": o atalho que anula o TLS',
     'Um erro frequente, especialmente sob pressão para "fazer a integração funcionar", é desabilitar a verificação do certificado do servidor no cliente HTTP (flags como verify=False, InsecureSkipVerify ou aceitar qualquer certificado autoassinado) para eliminar um erro de handshake em desenvolvimento — e essa configuração acaba esquecida em produção. Parece uma solução razoável porque a conexão continua cifrada e "funciona" sem erros visíveis, mas desabilitar a verificação remove justamente a propriedade de autenticidade do servidor que o TLS existe para garantir: sem validar a cadeia de confiança, o cliente não tem como distinguir o servidor legítimo de um atacante em man-in-the-middle apresentando qualquer certificado. A correção correta para erros de certificado em desenvolvimento é usar uma CA interna confiável ou um certificado de teste válido, nunca desligar a verificação.',
     4, 'v1', 'rascunho'),
    ('a5000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'TLS padrão vs. mTLS: quando exigir certificado também do cliente',
     'No TLS padrão, apenas o servidor apresenta certificado e prova sua identidade — o cliente permanece anônimo do ponto de vista criptográfico, o que é adequado para tráfego público (um navegador acessando um site não tem um certificado próprio para apresentar). Em mTLS (TLS mútuo), ambas as partes apresentam e validam certificados, autenticando também o cliente na camada de transporte. O critério concreto para escolher mTLS é o contexto de comunicação: ele se aplica bem a chamadas servidor-a-servidor dentro de uma infraestrutura controlada (comunicação entre microsserviços num service mesh, ou integrações B2B com um parceiro conhecido), onde é viável emitir e rotacionar certificados de cliente para um conjunto finito de participantes; é inviável para tráfego público de usuários finais, onde não há como distribuir certificados de cliente para milhões de navegadores anônimos — nesse caso a autenticação do usuário continua sendo resolvida na camada de aplicação (login, token), não no TLS.',
     5, 'v1', 'rascunho');

-- Concept: Vulnerabilidades Comuns em Aplicações Web
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a5000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'Validação no client-side como defesa: por que o servidor precisa revalidar tudo',
     'Um erro conceitual que atravessa SQL injection, XSS e CSRF é tratar validação feita em JavaScript no navegador (campos obrigatórios, formato de e-mail, escaping antes de exibir) como uma camada de segurança. Parece suficiente porque, testando pela própria interface, os dados realmente chegam validados ao servidor — mas o atacante não está obrigado a usar a interface: ele pode chamar o endpoint diretamente, alterando ou removendo qualquer validação de JavaScript no caminho, já que todo o código client-side é visível e manipulável por definição. Validação client-side é uma otimização de experiência (feedback imediato ao usuário, menos round-trips), nunca uma garantia de segurança; toda checagem que protege o sistema contra dado malicioso — sanitização, parametrização de queries, verificação de token CSRF — precisa ser reexecutada no servidor, que é a única parte da arquitetura que o atacante não controla.',
     4, 'v1', 'rascunho'),
    ('a5000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'WAF vs. correção no código: mitigação de borda não substitui corrigir a causa raiz',
     'Um Web Application Firewall (WAF) é uma camada que inspeciona requisições HTTP na borda da rede e bloqueia padrões conhecidos de ataque (assinaturas de SQL injection, payloads típicos de XSS) antes que cheguem à aplicação. O critério concreto para usá-lo é temporal e complementar, não substitutivo: um WAF é adequado como mitigação imediata enquanto uma vulnerabilidade real no código é corrigida (por exemplo, reduzir a exposição de um endpoint vulnerável recém-descoberto até o patch ser deployado), ou como camada adicional de defesa em profundidade contra ataques ainda desconhecidos pela equipe. Ele não deve ser tratado como a correção definitiva, porque opera por reconhecimento de padrões e pode ser contornado por payloads que fogem das assinaturas conhecidas (encoding alternativo, técnicas de ofuscação); a causa raiz — entrada não sanitizada, query não parametrizada, saída não escapada — continua existindo no código até ser corrigida ali, independentemente de quanto tráfego malicioso o WAF filtre na borda.',
     5, 'v1', 'rascunho');

-- Concept: Defesa em Profundidade e Controle de Abuso
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a5000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'Rate limiting só por IP: por que essa defesa isolada é insuficiente',
     'Um erro comum ao implementar rate limiting é aplicá-lo exclusivamente por endereço IP, assumindo que isso contém tanto abuso individual quanto ataques distribuídos. Parece razoável porque IP é o identificador mais simples de capturar em qualquer requisição, sem exigir autenticação prévia — mas múltiplos usuários legítimos frequentemente compartilham o mesmo IP público (NAT corporativo, redes móveis, proxies), fazendo com que um limite agressivo por IP penalize usuários inocentes; e, na direção oposta, um atacante com uma botnet distribui as requisições entre milhares de IPs diferentes, cada um bem abaixo do limite individual, driblando completamente a defesa. A mitigação real combina múltiplas dimensões de identificação — IP, conta de usuário autenticado e, quando aplicável, impressão digital do dispositivo ou padrão de comportamento — em vez de depender de uma única dimensão isolada.',
     4, 'v1', 'rascunho'),
    ('a5000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'seguranca'),
     'Rate limiting vs. circuit breaker: protegendo o servidor ou protegendo o chamador',
     'Rate limiting e circuit breaker são frequentemente confundidos por operarem em contextos parecidos (controle de tráfego sob estresse), mas resolvem problemas opostos. Rate limiting protege um servidor contra um volume excessivo de requisições vindas de fora, rejeitando o excedente para preservar a capacidade do sistema para os demais clientes — é uma defesa do lado de quem recebe a chamada. Circuit breaker protege o lado de quem faz a chamada: quando uma dependência externa começa a falhar ou responder lentamente, o circuit breaker para de chamá-la temporariamente, evitando que threads/conexões do chamador fiquem presas esperando uma dependência degradada e evitando que a falha se propague em cascata para o resto do sistema. O critério de escolha é direcional: use rate limiting para conter quem consome sua API; use circuit breaker para se proteger de APIs e serviços que você consome — sistemas robustos em produção normalmente precisam dos dois, em pontos diferentes da arquitetura.',
     5, 'v1', 'rascunho');
