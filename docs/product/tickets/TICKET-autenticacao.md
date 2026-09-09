# TICKET — Autenticação real (cadastro, confirmação por e-mail, login, JWT)

**Status:** pronto para DBA/Engenharia. Regra de senha e parâmetros de token confirmados pelo Tito (seção 12). Credencial SMTP real ainda não provisionada — Backend implementa com abstração/mock de envio, trocável por SMTP real depois (seção 12, OPEN QUESTION-D).
**Origem:** decisão de negócio do Tito que substitui a suposição do PRD ("assumir usuário único/local no primeiro corte, salvo decisão contrária" — `docs/product/PRD-mvp.md`, seção "Dependências, riscos e perguntas abertas"). A decisão contrária está sendo tomada agora, por este ticket.
**Substitui:** o mecanismo descrito em `docs/architecture/initial-architecture.md` (módulo Identity como "abstração mínima de usuário local, preparada para autenticação futura") e a implementação atual em `backend/src/main/java/com/scaleup/studyplatform/identity/` (`AppUser`, `CurrentUserProvider`, `UsuarioController`), além do schema de `V8__cria_tabela_usuario.sql` e do seed `V24__seed_usuario_local.sql`.
**Depende de:** nenhuma dependência de conteúdo/produto. Depende de decisão técnica de infraestrutura para envio de e-mail (conta de e-mail/Workspace com senha de app do Google já disponível — ver seção 8, Open Question OQ-D).

---

## 1. Objetivo

Definir as regras de negócio, o comportamento esperado (em alto nível) e os critérios de aceite para substituir o usuário único/local fixo por autenticação real: cadastro de conta com e-mail e senha, confirmação de cadastro por token enviado por e-mail, login com emissão de JWT, e proteção de todas as rotas de conteúdo/estudo/quiz/progresso por esse JWT — sem quebrar os contratos já existentes dos módulos Study, Assessment e Progress, que continuam funcionando, agora por usuário real autenticado em vez de usuário fixo resolvido por `CurrentUserProvider`.

## 2. Escopo

**Dentro:**
- Regras de negócio de cadastro, confirmação de cadastro, reenvio de token, login e emissão de JWT.
- Regra de força mínima de senha.
- Regra de formato e expiração do token de confirmação, e fluxo de reenvio.
- Regra de proteção de rotas (o que acontece sem token, com token inválido/expirado, com token válido).
- Regra de substituição de "usuário atual": todo módulo que hoje depende de `CurrentUserProvider` passa a depender do usuário autenticado da requisição.
- Requisitos não funcionais de segurança mínima (hash de senha, anti-enumeração de e-mail, rate limiting).
- Descrição em alto nível dos dados que precisam existir, para o DBA desenhar o schema.
- Fluxo de telas do frontend, em alto nível (não componentes).
- Critérios de aceite Given/When/Then.

**Fora:**
- Desenho de schema (é do DBA — este ticket só descreve os dados necessários, seção 9).
- Biblioteca JWT específica, algoritmo de hash específico, mecanismo técnico exato de rate limiting (decisão do Backend).
- Código de qualquer camada.
- Recuperação de senha esquecida, login social (OAuth Google/GitHub), autenticação de dois fatores (MFA), alteração de e-mail/senha após login, papéis/permissões (admin vs. usuário comum) — tudo isso fica para tickets futuros (ver seção 7).
- Migração ou preservação de dado do usuário local atual — é descartável, por decisão do Tito.

## 3. Restrições já tomadas pelo Tito (não são Open Questions)

1. Login por e-mail + senha. E-mail é o identificador único de login.
2. JWT emitido pelo backend no login; frontend envia no header `Authorization`. Sem sessão de servidor (stateless).
3. Confirmação de cadastro por e-mail, com token de 6 caracteres, enviado via SMTP real (Gmail/Google Workspace, autenticação por senha de app, biblioteca Spring Mail).
4. Login obrigatório para usar qualquer parte do sistema — nenhuma rota de conteúdo/estudo é acessível sem autenticação. A tela inicial do frontend passa a ser login/cadastro.
5. O usuário local atual e todo histórico de teste gerado até agora são descartáveis — não é necessário migrar ou preservar nenhum dado do usuário semeado por `V24`.

---

## 4. Cadastro de conta

- Campos: e-mail, senha, confirmação de senha.
- Conta é criada em estado **pendente de confirmação** — não pode logar enquanto não confirmar.
- **Regra de senha — decidido pelo Tito (não é mais Open Question):** mínimo de 8 caracteres, exigindo pelo menos 1 letra maiúscula, 1 letra minúscula, 1 número e 1 símbolo/caractere especial. Regra completa de complexidade, mais rígida que a proposta inicial do PM (que sugeria só letra+número) — o Tito optou explicitamente por exigir os 4 tipos de caractere.
- Confirmação de senha (campo duplicado) é validação de UX no cadastro (evitar erro de digitação), não medida de segurança — não é reconferida no backend além de bater com o campo senha.
- **Cadastro com e-mail já existente — anti-enumeração (decisão, ver seção 8):** a API deve responder com a mesma mensagem de sucesso genérica ("verifique seu e-mail para confirmar o cadastro") tanto para e-mail novo quanto para e-mail já cadastrado. Na prática:
  - Se o e-mail não existe: cria conta pendente e envia o e-mail de confirmação normalmente.
  - Se o e-mail já existe e está pendente de confirmação: reenvia um novo token de confirmação (mesmo comportamento do fluxo de reenvio, seção 6), sem revelar que a conta já existia.
  - Se o e-mail já existe e está ativo (já confirmado): **não** envia nenhum e-mail (evita spam para o dono legítimo da conta), mas responde a mesma mensagem genérica de sucesso ao chamador, para não diferenciar o comportamento observável entre "e-mail novo" e "e-mail já ativo".
  **Trade-off aceito:** quem tenta cadastrar um e-mail alheio já ativo recebe a mesma mensagem de sucesso e não descobre que a conta existe pela resposta da API — mas também não recebe e-mail nenhum, então não há como confirmar a suposição por essa via. Isso é intencional.

## 5. Confirmação de cadastro

- Token de exatamente 6 caracteres, enviado por e-mail via SMTP.
- **Formato do token — decisão, ver seção 10 (não bloqueante):** numérico (dígitos 0–9, ex. `482913`), não alfanumérico.
  **Justificativa:** um token numérico de 6 dígitos tem espaço de 1.000.000 combinações — suficiente para resistir a força bruta quando combinado com expiração curta (abaixo) e rate limiting (seção 8); é mais rápido e menos propenso a erro de digitação em teclado numérico de celular do que um alfanumérico (que introduz ambiguidade visual como `0`/`O`, `1`/`I`/`l`). Optar por alfanumérico aumentaria o espaço de tentativas, mas o ganho de segurança é marginal frente ao rate limiting, e o custo de usabilidade (confirmação de cadastro é uma etapa que o usuário quer vencer rápido) não compensa.
- **Prazo de expiração — decisão, ver seção 10 (não bloqueante):** 20 minutos a partir do envio.
  **Justificativa:** tempo suficiente para o usuário abrir o e-mail e digitar o token sem pressão (contas de e-mail podem ter latência de entrega de alguns minutos), mas curto o bastante para limitar a janela de um token interceptado ou de uma conta pendente esquecida. Alinhado ao intervalo comumente aceito (15–30 min) citado no ticket.
- Fluxos de confirmação:
  - **Token correto e dentro do prazo:** conta passa de "pendente" para "ativa"; passa a poder logar.
  - **Token errado:** rejeita com erro claro ("token inválido"), conta continua pendente, token original continua válido até expirar (não invalida por tentativa errada — isso é papel do rate limiting, seção 8, não da lógica de confirmação).
  - **Token expirado:** rejeita com erro específico orientando a solicitar reenvio (não a mesma mensagem genérica de "token inválido" — o usuário precisa saber que a ação certa é pedir um novo token, não tentar de novo o mesmo).
  - **Conta já confirmada:** se o usuário tentar confirmar uma conta que já está ativa (ex.: clicou duas vezes, ou usou um token antigo depois de já ter confirmado por outro), responde de forma idempotente com sucesso ("conta já confirmada, você já pode fazer login") — não é um erro.

## 6. Reenvio de token de confirmação

- Disponível para contas pendentes (token perdido, ou expirado).
- Reenviar **invalida o token anterior** (ao gerar um novo, o anterior deixa de ser aceito) — evita ambiguidade de qual token é o válido e reduz a superfície de tokens antigos ainda ativos. Isso implica que o schema precisa suportar mais de um token por conta ao longo do tempo (histórico), não só o token atual (ver seção 9).
- Reenvio para conta já ativa: resposta idempotente informando que a conta já está confirmada (mesmo padrão da seção 5), sem reenviar e-mail.
- Reenvio está sob o mesmo rate limiting de proteção contra spam de e-mail (seção 8).

## 7. Login

- E-mail + senha. Retorna JWT **somente se**: credenciais corretas **e** conta confirmada (ativa).
- Credenciais erradas (e-mail não encontrado, ou senha incorreta): mesma mensagem de erro genérica ("e-mail ou senha inválidos") nos dois casos — não diferenciar "e-mail não existe" de "senha errada", pelo mesmo princípio anti-enumeração da seção 4.
- Conta existe, credenciais corretas, mas **não confirmada**: erro específico e diferente do anterior, orientando a confirmar o cadastro (ex.: "confirme seu cadastro antes de entrar; reenviar token de confirmação"). Aqui a distinção é intencional e não fere o princípio anti-enumeração, porque exige já saber a senha correta — quem chega a esse erro já provou ser o dono da conta.
- Login bem-sucedido retorna o JWT; o frontend passa a enviá-lo no header `Authorization` em toda chamada subsequente.

## 8. Proteção de rotas e requisitos não funcionais de segurança

- Todas as rotas hoje existentes de conteúdo, estudo, quiz e progresso passam a exigir JWT válido no header `Authorization`.
- **Sem token, token malformado, token inválido ou token expirado:** resposta `401 Unauthorized`, uniforme, sem detalhar qual dos casos ocorreu (não é necessário diferenciar "expirado" de "inválido" para o cliente — o frontend reage igual nos dois casos, redirecionando para login).
- **Token válido:** requisição prossegue normalmente, resolvendo o usuário autenticado a partir do token (substituindo `CurrentUserProvider`).
- **Hash de senha (exigência de negócio, decisão técnica é do Backend):** senha nunca é armazenada em texto plano sob nenhuma circunstância — deve usar um algoritmo de hash adequado a senhas (ex. bcrypt ou equivalente moderno). Isto é não negociável, não é uma Open Question.
- **Anti-enumeração de e-mail:** já coberta nas seções 4 e 7 (mensagens genéricas de cadastro e de login).
- **Rate limiting (requisito não funcional, mecanismo técnico é do Backend):** login, cadastro e reenvio de token devem ter alguma forma de limitação de taxa por e-mail e/ou IP, para mitigar força bruta de senha, força bruta de token de confirmação, e spam de envio de e-mail (custo de SMTP e incômodo ao dono legítimo do e-mail). Não detalho janela ou limite numérico exato — fica a critério técnico do Backend, desde que exista.
- **`GET /api/usuarios/atual`:** endpoint já existente, deve continuar funcionando sem mudança de contrato observável pelo cliente, mas passa a resolver o usuário a partir do JWT da requisição, não mais do registro fixo semeado por `V24`.

## 9. Dados que precisam existir (para o DBA desenhar o schema — não é decisão deste ticket)

O schema atual de `usuario` (`V8__cria_tabela_usuario.sql`) e o seed (`V24__seed_usuario_local.sql`) estão **desatualizados para este objetivo** e precisam ser redesenhados pelo DBA — este ticket não tenta adaptá-los. Descrevo apenas os dados que precisam existir, não a estrutura de tabelas/colunas/índices:

- **Conta de usuário:** e-mail (único, obrigatório), senha em hash (nunca texto plano), status da conta (pendente de confirmação / ativa — considerar se vale um estado adicional para conta desativada, fora de escopo aqui), timestamps de criação/atualização.
- **Token de confirmação de cadastro:** valor do token (6 dígitos), a que conta pertence, data/hora de geração, data/hora de expiração, se já foi usado/consumido. Como a seção 6 exige invalidar o token anterior ao reenviar, o desenho precisa suportar histórico de tokens por conta (mais de um token ao longo do tempo, apenas o mais recente e não expirado é válido) — não apenas um único campo de token sobrescrito na conta, para permitir auditoria e evitar ambiguidade de concorrência entre "gerar novo" e "validar antigo".
- **Vínculo com os dados existentes de Study/Assessment/Progress:** a chave de usuário que hoje é usada por `StudySession`, `QuizAttempt`, `Answer`, `FlashcardReview`, `DomainProgress` deve continuar apontando para a mesma noção de "conta de usuário" (id), só que agora originada de uma conta real, não do registro fixo semeado. Não é necessário migrar dado nenhum do usuário local atual (descartável, por decisão do Tito) — mas o DBA deve confirmar se a chave estrangeira existente permanece compatível ou exige ajuste.
- **Fora do que este ticket pede ao DBA:** papéis/permissões, dados de OAuth, dados de recuperação de senha — nenhum desses é necessário agora (seção 2, fora de escopo).

## 10. Fluxo de telas do frontend (alto nível — componentes são do Frontend Engineer)

- **Tela de login** — campos e-mail/senha. Estados de erro: credenciais inválidas (genérico), conta não confirmada (com ação de "reenviar token"/ir para confirmação).
- **Tela de cadastro** — campos e-mail/senha/confirmação de senha. Enquanto o usuário digita a senha, exibir em tempo real uma checklist dos requisitos (mínimo 8 caracteres, 1 maiúscula, 1 minúscula, 1 número, 1 símbolo), marcando cada item como atendido/pendente conforme o texto digitado — validação client-side apenas para UX (feedback imediato), o backend revalida a regra completa de qualquer forma (não confiar só no client-side). Estados de erro: senha fraca (client-side E backend), senha e confirmação não coincidem (client-side). Sucesso leva à tela de confirmação de token, com mensagem genérica de "verifique seu e-mail" (nunca revela se o e-mail já existia).
- **Tela de confirmação de token** — campo para os 6 dígitos. Estados: token errado, token expirado (com ação de reenviar), sucesso (redireciona para login, ou já loga automaticamente — decisão do Frontend Engineer, não é regra de negócio deste ticket).
- **Redirecionamento global:** qualquer rota do app, se o usuário não está autenticado (sem JWT válido em memória/armazenamento), cai na tela de login. Ao receber `401` de qualquer chamada de API durante o uso normal (token expirou em uso), o frontend também deve redirecionar para login — regra de comportamento, não de implementação.

## 11. Fora de escopo (registrado explicitamente, não é omissão)

- Recuperação de senha esquecida ("esqueci minha senha").
- Login social (Google/GitHub OAuth).
- Autenticação de dois fatores (MFA).
- Alteração de e-mail ou senha depois de logado.
- Papéis e permissões (admin vs. usuário comum).

Todos ficam para tickets futuros, quando houver demanda de negócio para priorizá-los.

---

## 12. Open Questions

```
OPEN QUESTION-C — RESOLVIDA

Regra de senha decidida pelo Tito: mínimo 8 caracteres, com maiúscula, minúscula,
número e símbolo (ver seção 4, atualizada). Formato/expiração do token (6 dígitos
numéricos, 20 minutos, seção 5) aceito como proposto pelo PM, sem alteração.
```

```
OPEN QUESTION-D — parcialmente resolvida, ainda bloqueia teste real de e-mail

Decisão do Tito: a credencial Gmail/Google Workspace (senha de app) ainda **não** está
provisionada. O Backend deve implementar o envio de e-mail com uma abstração que
permita usar um mock/stub de envio agora (para desenvolver e testar toda a lógica de
cadastro/confirmação/reenvio sem depender da credencial real), trocável depois por SMTP
real assim que a credencial existir — sem precisar alterar a lógica de negócio, só a
configuração/implementação do envio.

O teste de entrega real de e-mail (receber o token de verdade numa caixa de entrada)
fica pendente até o Tito provisionar a credencial — isso não bloqueia o restante da
implementação nem a validação dos critérios de aceite via mock.

Owner: Tito (provisionar a credencial quando disponível).
```

---

## 13. Critérios de aceite (Given/When/Then)

**AC-01 — Cadastro com e-mail já existente**
Dado um e-mail já cadastrado e ativo,
Quando alguém tenta se cadastrar novamente com esse e-mail,
Então a API responde a mesma mensagem genérica de sucesso ("verifique seu e-mail") usada para e-mail novo, sem enviar nenhum e-mail e sem revelar que a conta já existe.

**AC-02 — Cadastro com senha fraca**
Dado um cadastro com uma senha que não atenda a regra completa (ex.: `abcdefgh` — sem maiúscula, número ou símbolo; ou `Abc12345` — sem símbolo),
Quando o usuário submete o cadastro,
Então a API rejeita com erro claro indicando qual regra de senha não foi atendida (mínimo 8 caracteres com maiúscula, minúscula, número e símbolo), e nenhuma conta é criada.

**AC-03 — Confirmação com token certo**
Dado um token de confirmação válido, gerado há 5 minutos, para uma conta pendente,
Quando o usuário informa esse token,
Então a conta passa a "ativa" e o usuário pode fazer login em seguida.

**AC-04 — Confirmação com token errado**
Dado uma conta pendente com um token válido gerado,
Quando o usuário informa um token diferente do gerado,
Então a API rejeita com "token inválido", a conta permanece pendente, e o token original continua válido até expirar ou ser reenviado.

**AC-05 — Confirmação com token expirado**
Dado um token de confirmação gerado há mais de 20 minutos,
Quando o usuário informa esse token (mesmo que correto),
Então a API rejeita com um erro específico orientando a solicitar reenvio, distinto do erro de "token errado".

**AC-06 — Reenvio de token**
Dado uma conta pendente cujo token expirou,
Quando o usuário solicita reenvio,
Então um novo token de 6 dígitos é gerado e enviado por e-mail, o token anterior deixa de ser válido, e o novo token tem novo prazo de expiração de 20 minutos.

**AC-07 — Login antes de confirmar conta**
Dado uma conta pendente de confirmação com credenciais corretas,
Quando o usuário tenta fazer login,
Então a API rejeita com um erro específico orientando a confirmar o cadastro (não o erro genérico de credenciais inválidas), e nenhum JWT é emitido.

**AC-08 — Login com credenciais erradas**
Dado um e-mail não cadastrado, ou um e-mail cadastrado com senha incorreta,
Quando o usuário tenta fazer login,
Então a API rejeita com a mesma mensagem genérica de erro ("e-mail ou senha inválidos") nos dois casos, e nenhum JWT é emitido.

**AC-09 — Login correto retornando JWT**
Dado uma conta ativa com credenciais corretas,
Quando o usuário faz login,
Então a API retorna um JWT válido, e `GET /api/usuarios/atual` usando esse JWT retorna os dados dessa conta.

**AC-10 — Acesso a rota protegida sem token**
Dado qualquer rota de conteúdo/estudo/quiz/progresso,
Quando uma requisição chega sem header `Authorization`,
Então a API responde `401 Unauthorized`.

**AC-11 — Acesso a rota protegida com token expirado ou inválido**
Dado um JWT expirado, ou um JWT malformado/adulterado,
Quando uma requisição chega com esse token no header `Authorization`,
Então a API responde `401 Unauthorized`, sem distinguir os dois casos na resposta.

**AC-12 — Acesso a rota protegida com token válido — fluxo de estudo continua funcionando**
Dado um usuário autenticado com JWT válido,
Quando ele executa o fluxo completo de estudo (consultar domínio, iniciar sessão, revisar flashcard, responder e submeter quiz, consultar progresso),
Então todas as operações funcionam exatamente como hoje, associadas ao usuário real resolvido a partir do JWT, sem depender de `CurrentUserProvider` fixo.

**AC-13 — Confirmação de conta já confirmada (idempotência)**
Dado uma conta já ativa,
Quando alguém tenta confirmá-la novamente com um token (mesmo que originalmente válido),
Então a API responde de forma idempotente informando que a conta já está confirmada, sem erro.

**AC-14 — Reenvio para conta já ativa**
Dado uma conta já ativa,
Quando alguém solicita reenvio de token de confirmação para essa conta,
Então a API responde de forma idempotente informando que a conta já está confirmada, sem enviar e-mail.

---

## 14. Retorno esperado deste handoff

- **Objetivo:** ticket de autenticação real definido, cobrindo cadastro, confirmação por e-mail, login, JWT e proteção de rotas, substituindo o usuário fixo local.
- **Escopo:** `docs/product/tickets/TICKET-autenticacao.md` (este arquivo). Fora: schema físico (DBA), biblioteca JWT/hash específica (Backend), componentes de frontend (Frontend Engineer).
- **Restrições:** respeita as 5 decisões já tomadas pelo Tito (login por e-mail+senha, JWT, token de 6 caracteres por SMTP, login obrigatório, dado local descartável); não inventa MFA, OAuth, papéis ou recuperação de senha.
- **Critério de conclusão:** DBA consegue desenhar o schema a partir da seção 9 sem precisar deste ticket resolver a estrutura; Backend consegue implementar as regras das seções 4–8 sem ambiguidade; critérios de aceite da seção 13 são verificáveis.
- **Bloqueios:** OPEN QUESTION-C (parâmetros de senha/token — não bloqueia início, só o valor final) e OPEN QUESTION-D (credencial SMTP disponível quando).
