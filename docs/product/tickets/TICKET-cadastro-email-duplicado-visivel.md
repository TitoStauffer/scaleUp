# TICKET — Erro visível de e-mail já cadastrado no fluxo de cadastro

**Status:** pronto para Engenharia.
**Ticket mestre de referência:** `docs/product/tickets/TICKET-autenticacao.md` — **leia primeiro**, em especial a seção 4 ("Cadastro de conta") e o AC-01. Este ticket **revoga e substitui** apenas a regra de anti-enumeração de e-mail no cadastro (seção 4 e AC-01 do ticket mestre), mantendo todo o resto do ticket mestre inalterado.
**Substitui:** o comportamento atual de `POST /api/auth/cadastro`, implementado em `backend/src/main/java/com/scaleup/studyplatform/identity/application/CadastrarContaService.java`, e a mensagem genérica `MENSAGEM_GENERICA` ali definida.
**Depende de:** nenhuma dependência externa. Não depende do ticket de "esqueci minha senha" (`docs/product/tickets/TICKET-esqueci-minha-senha.md`), embora os dois tenham sido identificados na mesma sessão de teste.

---

## 1. Contexto e motivação

O fluxo de cadastro foi desenhado no ticket mestre (seção 4, AC-01) com uma mensagem de sucesso **genérica e idêntica**, tanto para e-mail novo quanto para e-mail já cadastrado, por um princípio deliberado de anti-enumeração: evitar que alguém descubra, só testando o cadastro, quais e-mails já têm conta no sistema.

Na prática, esse princípio gerou um incidente real de UX. O Tito (founder/dono do produto) tentou se cadastrar com um e-mail que já existia e já estava **ativo** (confirmado dias antes, em outro teste). A resposta da API pareceu um cadastro bem-sucedido — a mesma mensagem genérica de "verifique seu e-mail" —, mas nenhum e-mail foi de fato enviado (comportamento correto, pela regra atual). Não havia nenhum sinal na tela indicando que a ação correta era simplesmente fazer login, não esperar por um e-mail que nunca chegaria. O usuário só entendeu o que aconteceu porque tem acesso direto ao banco de dados — algo que um usuário real do produto não tem.

**Decisão do Tito, tomada nesta sessão:** reverter deliberadamente a proteção de anti-enumeração **apenas no cadastro**, para que o erro de "e-mail já cadastrado" seja visível e amigável ao usuário, orientando a ação correta em cada caso (login, se já ativo; reenvio/confirmação, se pendente). O Tito está ciente do trade-off de segurança envolvido (seção 6 abaixo) e decidiu conscientemente que, neste estágio do produto, a clareza de UX vale mais do que a proteção contra enumeração de e-mail no cadastro. Não é papel deste ticket reabrir essa decisão — é formalizar a mudança de comportamento.

## 2. Objetivo

`POST /api/auth/cadastro` deve responder com um erro específico, visível e amigável quando o e-mail informado já existe no sistema, diferenciando o caso de conta já ativa (orientar login) do caso de conta ainda pendente de confirmação (orientar reenvio/confirmação de token). O frontend deve exibir essa mensagem de forma clara, próxima ao campo e-mail do formulário de cadastro.

## 3. Escopo

**Dentro:**
- Alterar `POST /api/auth/cadastro` para retornar um erro estruturado e distinto quando o e-mail já existe, com dois sub-casos:
  - conta já **ativa** → erro orientando a fazer login;
  - conta ainda **pendente** de confirmação → erro orientando a confirmar o cadastro ou solicitar reenvio de token (endpoint `POST /api/auth/reenviar-token`, já existente).
- Manter inalterado o comportamento de sucesso para e-mail novo (cria conta pendente, envia token, mesma mensagem de sucesso de hoje).
- Definir o formato de resposta HTTP do novo erro, reaproveitando o padrão já existente de erro estruturado do backend (`ApiErrorResponse`, ver seção 5).
- Atualizar a tela de cadastro do frontend (`frontend/src/pages/CadastroPage.tsx`) para exibir a nova mensagem de erro de forma amigável, próxima ao campo e-mail, distinguindo visualmente (ou ao menos textualmente) os dois sub-casos e oferecendo a ação sugerida (link para login, ou link/orientação para reenvio de token).
- Critérios de aceite Given/When/Then (seção 7).
- Registro explícito do trade-off de segurança aceito (seção 6).

**Fora:**
- Qualquer mudança no comportamento de anti-enumeração do **login** (`POST /api/auth/login`) — a mensagem genérica "e-mail ou senha inválidos" (seção 7 do ticket mestre) permanece exatamente como está. Este ticket não a revisita.
- Qualquer mudança no comportamento de anti-enumeração do fluxo de "esqueci minha senha" — ver `docs/product/tickets/TICKET-esqueci-minha-senha.md`, que especifica esse fluxo novo e mantém o princípio de anti-enumeração de login/recuperação de senha.
- Qualquer mudança em `POST /api/auth/reenviar-token` — esse endpoint já existe, já é usado internamente pelo novo comportamento de cadastro (orientação ao usuário), e seu próprio contrato/anti-enumeração não muda neste ticket.
- Regra de senha, formato/expiração de token de confirmação, rate limiting — inalterados, já definidos no ticket mestre.
- Recuperação de senha esquecida — é outro ticket (`TICKET-esqueci-minha-senha.md`), só referenciado aqui.

## 4. Comportamento novo de `POST /api/auth/cadastro`

| Situação do e-mail | Comportamento hoje (revogado) | Comportamento novo |
|---|---|---|
| E-mail novo | Cria conta pendente, envia token, mensagem genérica de sucesso | **Inalterado** — cria conta pendente, envia token, mensagem de sucesso |
| E-mail já existe, conta **ativa** | Nenhuma ação, mesma mensagem genérica de sucesso (nenhum e-mail enviado) | Erro específico: `EMAIL_JA_CADASTRADO_ATIVO`, orientando a fazer login |
| E-mail já existe, conta **pendente** | Reenvia token silenciosamente, mesma mensagem genérica de sucesso | Erro específico: `EMAIL_JA_CADASTRADO_PENDENTE`, orientando a confirmar o cadastro ou solicitar reenvio de token — **sem reenviar automaticamente** (ver decisão abaixo) |
| E-mail mal formado | Rejeitado por `@Email` do Bean Validation, erro `REQUISICAO_INVALIDA` | Inalterado — já coberto, sem mudança necessária |
| Senha fraca / confirmação divergente | Erro claro (AC-02 do ticket mestre) | Inalterado |

**Decisão de produto — conta pendente não deve reenviar token automaticamente no cadastro:** diferente do comportamento atual (que reenvia silenciosamente), o novo comportamento **não** deve disparar um novo e-mail como efeito colateral de uma tentativa de cadastro. O motivo é consistência de UX: se o erro é "essa conta já existe e está pendente", a ação de reenviar token deve ser uma escolha explícita do usuário (clicar em "reenviar token" ou ir para a tela de confirmação), não algo que acontece silenciosamente no bastidor de uma chamada que ele nem sabe que teve esse efeito. Isso também evita spam de e-mail para quem testa e-mails de terceiros repetidamente tentando cadastro (mesmo já sem anti-enumeração — não há motivo para reintroduzir esse vetor de spam). O reenvio continua disponível, sob demanda explícita do usuário, via `POST /api/auth/reenviar-token` (endpoint já existente, com seu próprio rate limiting).

Isso é uma mudança de comportamento em relação ao `CadastrarContaService` atual (que hoje chama `reenviarTokenParaContaPendente` silenciosamente) — quem implementar deve remover esse efeito colateral, não apenas trocar a mensagem de resposta.

## 5. Formato da resposta de erro

O backend já tem um padrão estruturado de erro (`backend/src/main/java/com/scaleup/studyplatform/shared/ApiErrorResponse.java`), usado por todas as exceções de autenticação hoje (`CREDENCIAIS_INVALIDAS`, `CONTA_NAO_CONFIRMADA`, `TOKEN_INVALIDO`, `TOKEN_EXPIRADO`, `RATE_LIMIT_EXCEDIDO`, tratadas em `backend/src/main/java/com/scaleup/studyplatform/shared/GlobalExceptionHandler.java`). Este ticket reaproveita exatamente esse padrão, sem inventar um formato novo:

```json
{
  "timestamp": "2026-09-17T14:32:00Z",
  "status": 409,
  "erro": "EMAIL_JA_CADASTRADO_ATIVO",
  "mensagem": "este e-mail já possui uma conta ativa, faça login",
  "caminho": "/api/auth/cadastro"
}
```

```json
{
  "timestamp": "2026-09-17T14:32:00Z",
  "status": 409,
  "erro": "EMAIL_JA_CADASTRADO_PENDENTE",
  "mensagem": "este e-mail já possui um cadastro pendente de confirmação, confirme o token recebido ou solicite reenvio",
  "caminho": "/api/auth/cadastro"
}
```

**Status HTTP:** `409 Conflict` para os dois novos casos — é o mesmo status já usado no padrão existente para "o recurso já existe em um estado que conflita com a operação pedida" (ver `EstadoInvalidoException` → `409` em `GlobalExceptionHandler`, ainda que semanticamente distinto; `409` é mais correto aqui do que `400`, porque a requisição em si é válida, o conflito é de estado do recurso).

**Novas exceções propostas** (mesmo padrão de `CredenciaisInvalidasException`, `ContaNaoConfirmadaException` etc., uma classe simples de `RuntimeException` em `identity.application`, mais um handler em `GlobalExceptionHandler`):
- `EmailJaCadastradoAtivoException` → `erro: "EMAIL_JA_CADASTRADO_ATIVO"`, status `409`.
- `EmailJaCadastradoPendenteException` → `erro: "EMAIL_JA_CADASTRADO_PENDENTE"`, status `409`.

O texto exato de `mensagem` é decisão de copy do Frontend/PM na implementação final — os textos acima são propostos, não travados.

**No frontend:** o cliente HTTP (`frontend/src/api/client.ts`) já propaga `mensagem` e `erro` (código) de qualquer resposta de erro estruturada via `ApiError.message` / `ApiError.code` — nenhuma mudança é necessária nesse cliente. A tela de cadastro (`CadastroPage.tsx`) deve:
- capturar o erro no `catch` do `handleSubmit` (já existe essa estrutura);
- exibir a mensagem próxima ao campo e-mail (hoje o erro genérico aparece num bloco `role="alert"` no rodapé do formulário — mover ou complementar para ficar associado ao campo e-mail via `aria-describedby`, no mesmo padrão já usado para o erro de confirmação de senha divergente, linhas 91–99 do arquivo atual);
- quando `ApiError.code === 'EMAIL_JA_CADASTRADO_ATIVO'`: exibir a mensagem com um link para `/login`;
- quando `ApiError.code === 'EMAIL_JA_CADASTRADO_PENDENTE'`: exibir a mensagem com um link para a tela de confirmação (`/confirmar`, já existente) ou para o reenvio de token — decisão de UX de qual das duas ações oferecer (ou as duas) fica com o Frontend Engineer na implementação, desde que oriente uma ação concreta, não apenas informe o estado.

## 6. Trade-off de segurança formalizado

**O que se perde:** anti-enumeração de e-mail no cadastro. Depois desta mudança, qualquer pessoa pode descobrir se um e-mail específico já tem conta no sistema (e se essa conta está ativa ou pendente) simplesmente tentando cadastrá-lo e lendo a resposta. Isso é uma regressão de segurança em relação ao desenho original do ticket mestre (seção 4 e AC-01), que evitava exatamente esse vazamento de informação.

**Por que foi aceito:** decisão consciente do Tito, dono do produto, feita nesta sessão, após um incidente real de confusão de UX que ele mesmo viveu tentando recadastrar um e-mail já ativo. No estágio atual do produto (early-stage, sem grande base de usuários, sem histórico de abuso conhecido), o custo de UX de uma mensagem opaca supera o risco de enumeração de e-mail via cadastro. Este ticket não reabre essa decisão — apenas a registra e a implementa.

**O que continua protegido, sem alteração:**
- Anti-enumeração de **login** (seção 7 do ticket mestre): mensagem genérica "e-mail ou senha inválidos" continua idêntica para e-mail inexistente e senha errada. Não é possível descobrir se um e-mail tem conta só tentando login com senha errada.
- Anti-enumeração de **recuperação de senha** (`TICKET-esqueci-minha-senha.md`, quando implementado): a resposta de "solicitar recuperação" deve continuar genérica, pelo mesmo princípio do login — ver justificativa nesse ticket.
- Senha nunca é armazenada em texto plano, rate limiting de cadastro/login/reenvio continuam valendo (seção 8 do ticket mestre, inalterada).

Em outras palavras: um atacante que queira descobrir e-mails cadastrados agora pode fazê-lo via `POST /api/auth/cadastro`, mas **não** via `POST /api/auth/login` nem via o futuro `POST /api/auth/esqueci-senha`. Essa assimetria é intencional — cadastro é uma ação de baixo custo/baixo dano por tentativa (não revela senha, não permite acesso), enquanto login e recuperação de senha são vetores mais sensíveis onde o princípio original permanece.

## 7. Critérios de aceite (Given/When/Then)

**AC-01 (revisado) — Cadastro com e-mail novo**
Dado um e-mail que ainda não existe no sistema,
Quando alguém se cadastra com esse e-mail e senha válida,
Então a API cria a conta em estado pendente, envia o token de confirmação por e-mail, e responde com a mensagem de sucesso — comportamento inalterado em relação ao ticket mestre.

**AC-02 — Cadastro com e-mail já ativo**
Dado um e-mail já cadastrado e com conta **ativa** (confirmada),
Quando alguém tenta se cadastrar novamente com esse e-mail,
Então a API responde `409 Conflict` com `erro: "EMAIL_JA_CADASTRADO_ATIVO"` e uma mensagem orientando a fazer login, nenhuma conta nova é criada, e nenhum e-mail é enviado.

**AC-03 — Cadastro com e-mail já pendente de confirmação**
Dado um e-mail já cadastrado, com conta em estado **pendente** de confirmação,
Quando alguém tenta se cadastrar novamente com esse e-mail,
Então a API responde `409 Conflict` com `erro: "EMAIL_JA_CADASTRADO_PENDENTE"` e uma mensagem orientando a confirmar o cadastro ou solicitar reenvio de token, nenhuma conta nova é criada, e **nenhum e-mail é enviado automaticamente** (o token existente permanece válido até expirar; reenvio só ocorre se o usuário solicitar explicitamente via `POST /api/auth/reenviar-token`).

**AC-04 — Cadastro com e-mail mal formado**
Dado um valor de e-mail que não segue o formato válido (ex.: `"nao-e-email"`),
Quando alguém tenta se cadastrar com esse valor,
Então a API rejeita com `400 Bad Request` e `erro: "REQUISICAO_INVALIDA"` — comportamento já existente via `@Email` do Bean Validation, sem mudança necessária, apenas confirmado como não afetado por este ticket.

**AC-05 — Frontend exibe erro de e-mail já ativo com ação de login**
Dado que o usuário submete o formulário de cadastro com um e-mail já ativo,
Quando a API responde `EMAIL_JA_CADASTRADO_ATIVO`,
Então a tela de cadastro exibe a mensagem de erro associada ao campo e-mail, com uma ação (link/botão) levando para a tela de login.

**AC-06 — Frontend exibe erro de e-mail já pendente com ação de confirmação/reenvio**
Dado que o usuário submete o formulário de cadastro com um e-mail já pendente de confirmação,
Quando a API responde `EMAIL_JA_CADASTRADO_PENDENTE`,
Então a tela de cadastro exibe a mensagem de erro associada ao campo e-mail, com uma ação levando para a tela de confirmação de token ou para o reenvio.

**AC-07 — Login não é afetado**
Dado um e-mail cadastrado (ativo ou pendente) e uma tentativa de login com senha incorreta, ou um e-mail inexistente,
Quando o usuário tenta fazer login,
Então a API continua respondendo a mesma mensagem genérica "e-mail ou senha inválidos" nos dois casos — comportamento do ticket mestre, seção 7, inalterado por este ticket.

## 8. Riscos e perguntas em aberto

```
OPEN QUESTION-001

Pergunta: o texto exato das mensagens de erro (`mensagem` no corpo da resposta, e o
texto exibido na tela de cadastro) foi proposto na seção 5, mas não foi validado com o
Tito palavra por palavra.

Por que importa: mensagens mal calibradas podem ainda confundir o usuário, mesmo sendo
tecnicamente mais informativas que a mensagem genérica anterior.

Como responder: Frontend/PM revisam o copy final antes ou durante a implementação;
não bloqueia o início do trabalho técnico (exceções, endpoint, formato de erro).

Owner: Frontend Engineer + Tito (revisão de copy).
```

```
OPEN QUESTION-002

Pergunta: ao receber EMAIL_JA_CADASTRADO_PENDENTE, o frontend deve oferecer diretamente
um botão "reenviar token" que já dispara a chamada a POST /api/auth/reenviar-token, ou
apenas um link para a tela de confirmação (onde o usuário já tem essa opção)?

Por que importa: afeta quantos cliques o usuário precisa dar para se recuperar da
situação — é uma decisão de UX, não de regra de negócio.

Como responder: decisão do Frontend Engineer na implementação, dentro do critério de
aceite AC-06 (a ação precisa existir, a forma exata é livre).

Owner: Frontend Engineer.
```

**Risco — regressão de segurança aceita.** Já formalizado na seção 6; não é uma pendência, é uma decisão fechada, registrada aqui para rastreabilidade caso o produto cresça e precise ser revisitada no futuro (ex.: se o volume de uso ou um incidente de abuso justificar reintroduzir alguma proteção, como rate limiting mais agressivo especificamente no cadastro — o rate limiting geral da seção 8 do ticket mestre já se aplica e não é alterado aqui).

**Risco — inconsistência entre o comportamento revogado e testes/documentação existentes.** O ticket mestre (`TICKET-autenticacao.md`) e possíveis testes automatizados de `CadastrarContaService` (`backend/src/test/...`, não inspecionado neste ticket) referenciam o comportamento antigo de anti-enumeração (AC-01 original, mensagem genérica). Quem implementar deve atualizar/remover os testes que validam o comportamento revogado, e idealmente adicionar uma nota no ticket mestre (seção 4) apontando para este ticket como a decisão que o substitui — este ticket não edita `TICKET-autenticacao.md` diretamente, mas a relação de substituição deve ficar rastreável.
