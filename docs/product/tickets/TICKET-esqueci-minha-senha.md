# TICKET — Recuperação de senha ("esqueci minha senha")

**Status:** especificação apenas — nada deve ser implementado a partir deste ticket sem uma etapa explícita de priorização/kickoff técnico. Pronto para DBA/Engenharia avaliarem viabilidade e desenharem o schema quando priorizado.
**Ticket mestre de referência:** `docs/product/tickets/TICKET-autenticacao.md` — **leia primeiro**. Este ticket preenche uma lacuna deixada explicitamente fora de escopo lá (seção 2 e seção 11: "Recuperação de senha esquecida... fica para tickets futuros"). Não redefine login, cadastro, confirmação de cadastro ou JWT — só adiciona o fluxo novo de recuperação de senha.
**Ticket relacionado:** `docs/product/tickets/TICKET-cadastro-email-duplicado-visivel.md` — reverte anti-enumeração **só no cadastro**. Este ticket especifica um fluxo novo (recuperação de senha) e mantém o princípio de anti-enumeração do **login**, aplicado aqui também. Os dois tickets não se sobrepõem em escopo, mas ambos tratam do tema de "o que o usuário vê quando informa um e-mail que talvez não exista" — por isso a diferença de tratamento é justificada explicitamente na seção 5.
**Depende de:** nenhuma dependência de conteúdo. Depende da infraestrutura de e-mail assíncrono já existente (`identity.application.EmailSender`, `EmailAsyncConfig`) e do padrão de token de confirmação já implementado (`TokenConfirmacaoCadastro`).

---

## 1. Contexto e motivação

Hoje não existe nenhum mecanismo de recuperação de senha no sistema. Se um usuário esquece a senha, não há como recuperar acesso à própria conta pelo produto — a única saída seria intervenção manual direta no banco de dados.

Essa lacuna foi identificada como um problema real durante uma sessão de teste do Tito (founder/dono do produto): ao se deparar com uma conta já cadastrada cuja senha ele não lembrava, a única alternativa cogitada foi um `DELETE` manual do registro no banco para poder se recadastrar do zero — o que é uma solução de contorno inaceitável para qualquer usuário real do produto (que não tem acesso ao banco) e arriscada mesmo para o próprio dono (perda de dados associados à conta, como progresso de estudo, sem qualquer camada de confirmação).

Este ticket propõe o fluxo de recuperação de senha que fecha essa lacuna, seguindo o mesmo padrão de rigor e detalhamento já usado no ticket mestre de autenticação. **Este ticket é apenas especificação** — não há pedido de implementação neste momento; ele existe para que, quando o Tito priorizar esse trabalho, Engenharia e DBA tenham uma base pronta para começar.

## 2. Objetivo

Permitir que um usuário com conta existente e ativa recupere o acesso à própria conta definindo uma nova senha, através de um fluxo de duas etapas (solicitar recuperação → definir nova senha), autenticado por um token enviado por e-mail, seguindo os mesmos princípios de segurança já estabelecidos para o token de confirmação de cadastro (expiração curta, invalidação de tokens antigos, rate limiting), mas mantendo o princípio de anti-enumeração de e-mail que o cadastro (ver ticket relacionado) deixou de ter.

## 3. Escopo

**Dentro:**
- Fluxo de solicitação de recuperação de senha por e-mail.
- Geração, envio, expiração e invalidação de token de recuperação.
- Fluxo de definição de nova senha a partir de um token válido.
- Reaproveitamento (ou justificativa de não reaproveitamento) da infraestrutura de token/e-mail já existente.
- Regras de rate limiting, reaproveitando `RateLimiter` já existente.
- Regras de força de senha, reaproveitando `PasswordValidator` já existente.
- Endpoints propostos, formato de request/response, formato de erro (mesmo padrão `ApiErrorResponse` já usado no resto do módulo Identity).
- Decisão sobre o que fazer com sessões JWT ativas ao trocar a senha.
- Critérios de aceite Given/When/Then.
- Riscos e Open Questions.

**Fora:**
- Implementação de qualquer código — este ticket é especificação.
- Alteração de e-mail da conta (é um recurso diferente, não solicitado).
- Autenticação de dois fatores (MFA) como parte deste fluxo.
- Login social (OAuth) — sem relação com este ticket.
- Revisão da regra de anti-enumeração do cadastro — já tratada e revertida em `TICKET-cadastro-email-duplicado-visivel.md`; este ticket **não** aplica a mesma reversão aqui (ver seção 5).
- Desenho de schema físico (tabelas, índices, constraints) — é decisão do DBA, este ticket só descreve os dados necessários (seção 7), no mesmo padrão do ticket mestre (seção 9 daquele documento).

## 4. Fluxo proposto

```
1. Usuário esqueceu a senha, clica em "esqueci minha senha" na tela de login
2. Usuário informa o e-mail da conta
3. POST /api/auth/esqueci-senha { email }
   → resposta sempre genérica (anti-enumeração, seção 5)
   → se o e-mail existir e a conta estiver ativa: gera token de recuperação, envia por e-mail
   → se o e-mail não existir, ou existir mas estiver pendente de confirmação de cadastro:
     nenhuma ação, mesma resposta genérica
4. Usuário recebe e-mail com o token/link de recuperação
5. Usuário informa o token e a nova senha (+ confirmação, mesma UX do cadastro)
6. POST /api/auth/redefinir-senha { token, novaSenha, confirmacaoNovaSenha }
   → valida token (existe, não expirado, não consumido, não invalidado)
   → valida força da nova senha (PasswordValidator, mesma regra do cadastro)
   → atualiza a senha da conta (hash), marca o token como consumido
7. Usuário é redirecionado para login com a nova senha
```

**Conta pendente de confirmação de cadastro, tentando recuperar senha:** trata-se do mesmo caso do passo 3 acima — como a conta ainda não está confirmada, ela nem consegue logar de qualquer forma (ticket mestre, seção 7), então não faz sentido emitir um token de recuperação de senha para ela. A resposta continua genérica (não revela o estado da conta), mas nenhum e-mail de recuperação é enviado nesse caso — só o e-mail de confirmação de cadastro (já existente, via reenvio) resolveria essa situação, e esse fluxo já existe (`POST /api/auth/reenviar-token`).

## 5. Anti-enumeração: por que este fluxo mantém o princípio antigo, diferente do cadastro

O ticket `TICKET-cadastro-email-duplicado-visivel.md` reverteu deliberadamente a anti-enumeração **do cadastro**, por decisão consciente do Tito, para resolver uma confusão de UX real. Esse ticket também deixa explícito que login e recuperação de senha **não** foram revisitados por aquela decisão.

Este ticket mantém o princípio de anti-enumeração para "esqueci minha senha", pelo mesmo motivo já registrado no ticket mestre para o login (seção 7 de `TICKET-autenticacao.md`): a resposta de "solicitar recuperação" é o tipo de endpoint mais sensível a ataques de enumeração em massa, porque não exige nenhum conhecimento prévio (diferente do login, que já exige acertar a senha para revelar algo) — um endpoint de "esqueci minha senha" que responde diferente para e-mail existente/inexistente é um oráculo direto e barato de testar em massa (basta uma lista de e-mails candidatos, sem precisar adivinhar senha nenhuma). Por isso a mesma lógica que manteve o login genérico se aplica aqui, com ainda mais força.

**Resumindo a assimetria entre os três fluxos, para não gerar ambiguidade:**

| Fluxo | Anti-enumeração | Motivo |
|---|---|---|
| Cadastro (`POST /api/auth/cadastro`) | **Revertida** — erro específico e visível | Decisão consciente do Tito, ver `TICKET-cadastro-email-duplicado-visivel.md` |
| Login (`POST /api/auth/login`) | **Mantida** — mensagem genérica | Inalterado desde o ticket mestre, seção 7 |
| Esqueci minha senha (`POST /api/auth/esqueci-senha`) | **Mantida** — resposta genérica | Este ticket, mesmo princípio do login |

A resposta de `POST /api/auth/esqueci-senha` deve ser **sempre** a mesma, independentemente de o e-mail existir, estar ativo, estar pendente, ou não existir:

```json
{
  "mensagem": "se este e-mail estiver cadastrado e a conta ativa, você receberá instruções de recuperação em instantes"
}
```

Mesmo padrão de DTO já usado em `MensagemDto` (reenvio de token, cadastro).

## 6. Token de recuperação: reaproveitar infraestrutura existente ou criar entidade nova

**Decisão proposta: criar uma entidade nova, `TokenRecuperacaoSenha`, espelhando a estrutura de `TokenConfirmacaoCadastro`, em vez de reaproveitar a tabela/entidade existente.**

**Justificativa:**
- `TokenConfirmacaoCadastro` está semanticamente amarrado à confirmação de cadastro (`ConfirmarCadastroService`, `ReenviarTokenService`) — seus métodos, nome de tabela (`token_confirmacao_cadastro`), e o índice único parcial `ux_token_confirmacao_aberto_por_conta` (V34) garantem no máximo um token de **confirmação de cadastro** em aberto por conta. Recuperação de senha é uma operação diferente, que pode legitimamente coexistir com um token de confirmação de cadastro em aberto (embora seja raro na prática, já que recuperação de senha só faz sentido para conta ativa) — misturar as duas responsabilidades na mesma tabela exigiria uma coluna de "tipo de token" e complicaria o índice único parcial, que precisaria ser refeito para considerar o tipo.
- Reaproveitar a **infraestrutura de e-mail assíncrono** (`EmailSender`, `EmailAsyncConfig`, mesma anotação `@Async` e mesma abstração trocável mock/SMTP real já usada) faz total sentido e deve ser reaproveitada — é infraestrutura de envio, não de domínio, e já está desenhada para ser reutilizável por qualquer fluxo que precise mandar e-mail.
- O **padrão de campos e comportamento** de `TokenConfirmacaoCadastro` (token, `gerado_em`, `expira_em`, `consumido_em`, `invalidado_em`, métodos `isExpirado`, `isAberto`, `consumir`, `invalidar`) deve ser espelhado quase 1:1 na entidade nova — é o mesmo padrão de token efêmero de uso único, testado e já em produção.

**O que o DBA precisa desenhar (mesmo nível de detalhe do ticket mestre, seção 9 — não é decisão deste ticket):**
- **Token de recuperação de senha:** valor do token, a qual conta pertence, data/hora de geração, data/hora de expiração, se já foi consumido, se foi invalidado (por reenvio ou por geração de um novo). Mesmo raciocínio do ticket mestre: precisa suportar histórico (mais de um token por conta ao longo do tempo), não sobrescrever um único campo.
- Considerar se vale a pena um índice único parcial equivalente a `ux_token_confirmacao_aberto_por_conta`, garantindo no máximo um token de recuperação em aberto por conta por vez — recomendado, pelo mesmo motivo (evita ambiguidade entre "gerar novo" e "validar antigo" concorrentes).
- Nenhuma alteração é necessária na tabela de `app_user` além do que já existe (e-mail, senha em hash, status).

## 7. Formato do token e regras de expiração/invalidação

- **Formato:** proposta — token opaco de alta entropia (ex.: UUID ou string aleatória de 32+ caracteres), enviado como parte de um link (`https://.../redefinir-senha?token=...`), **não** um código curto de 6 dígitos como o de confirmação de cadastro. Justificativa: o token de confirmação de 6 dígitos foi dimensionado para ser digitado manualmente pelo usuário em uma tela dedicada (ticket mestre, seção 5) — para recuperação de senha, o padrão de mercado e mais amigável é um link clicável que já carrega o token, sem exigir digitação, e por não ter as mesmas restrições de "poucos dígitos para digitar rápido", pode (e deve) ter uma entropia muito maior, já que este token concede a capacidade de trocar a senha de uma conta alheia se vazado — superfície de dano maior que o token de confirmação de cadastro, que só ativa uma conta.
- **Expiração — proposta, sujeita a validação do Tito (Open Question, seção 10):** 30 a 60 minutos. Mais curto que o de confirmação de cadastro (20 min, ticket mestre) não é necessário — na verdade, um pouco mais longo pode ser justificável, porque o e-mail de recuperação de senha tende a ser verificado com menos urgência imediata que um e-mail de confirmação de cadastro (o usuário já está "no meio" de um fluxo no caso do cadastro; no caso de recuperação, ele pode estar fazendo outra coisa e voltar depois). Não é uma decisão fechada — ver Open Question.
- **Invalidação de tokens antigos ao gerar um novo:** mesma regra do token de confirmação de cadastro (ticket mestre, seção 6) — se o usuário solicitar recuperação de senha mais de uma vez, o token anterior (se ainda em aberto) é invalidado ao gerar o novo, mesma técnica de índice único parcial + invalidação seguida de insert na mesma transação (mesmo cuidado de ordenação de flush documentado em `CadastrarContaService`/`ReenviarTokenService`).
- **Token já consumido:** se o usuário tentar reutilizar um token de recuperação já usado (ex.: clicou duas vezes, ou o link ficou salvo em algum lugar), a API deve rejeitar com um erro específico ("token inválido ou já utilizado"), sem revelar mais detalhes.
- **Rate limiting:** reaproveitar `RateLimiter` já existente, mesmo padrão de chave lógica (`"esqueci-senha:" + email`), aplicado tanto à solicitação de recuperação quanto à tentativa de redefinição (para mitigar força bruta de token, já que o token tem alta entropia mas ainda assim deve ter alguma proteção de taxa).

## 8. Regras de senha nova

- Reaproveitar `PasswordValidator` já existente, exatamente a mesma regra do cadastro (mínimo 8 caracteres, 1 maiúscula, 1 minúscula, 1 número, 1 símbolo) — sem criar uma regra paralela.
- Campo de confirmação de nova senha (`confirmacaoNovaSenha`), mesma lógica de UX do cadastro: validação client-side de "bate com a senha", não é medida de segurança, backend não reconfere além de bater com o campo `novaSenha`.
- Nova senha **pode** ser igual à senha anterior — este ticket não propõe impedir reuso de senha (não há infraestrutura de histórico de senhas hoje, e criar uma para este caso é over-engineering neste estágio; ver Open Question se isso for considerado relevante depois).

## 9. Endpoints propostos

| Método | Rota | Request | Response (sucesso) | Autenticação |
|---|---|---|---|---|
| `POST` | `/api/auth/esqueci-senha` | `{ "email": string }` | `{ "mensagem": string }` (sempre genérica, seção 5) | Público |
| `POST` | `/api/auth/redefinir-senha` | `{ "token": string, "novaSenha": string, "confirmacaoNovaSenha": string }` | `{ "mensagem": string }` (ex.: "senha redefinida com sucesso, faça login") | Público (autenticado pelo token, não por JWT) |

Ambos os endpoints devem ser adicionados à lista de rotas públicas (`permitAll`) em `backend/src/main/java/com/scaleup/studyplatform/shared/security/SecurityConfig.java`, no mesmo grupo dos demais endpoints de `/api/auth/**`.

**Erros propostos**, mesmo padrão `ApiErrorResponse` já usado no resto do módulo:

| Situação | `erro` | status |
|---|---|---|
| Token de redefinição inválido, expirado ou já consumido | `TOKEN_RECUPERACAO_INVALIDO` | 400 |
| Nova senha não atende aos requisitos | `REQUISICAO_INVALIDA` (reaproveita o handler de `IllegalArgumentException` já existente, mesmo padrão do AC-02 do cadastro) | 400 |
| Nova senha e confirmação não coincidem | `REQUISICAO_INVALIDA` | 400 |
| Rate limit excedido | `RATE_LIMIT_EXCEDIDO` (reaproveita `RateLimitExcedidoException` já existente) | 429 |

Não é necessário (nem desejável, pela anti-enumeração) um erro distinto para "e-mail não encontrado" em `POST /api/auth/esqueci-senha` — essa rota nunca retorna erro por causa do e-mail, sempre a mesma resposta de sucesso genérica.

## 10. Sessões ativas ao trocar a senha — Open Question

Hoje o sistema usa JWT stateless, sem refresh token, com expiração fixa de 24 horas (`AUTH_JWT_EXPIRATION_MINUTES`, `backend/src/main/resources/application.yml`). Isso significa que, ao trocar a senha via este fluxo, **qualquer JWT emitido antes da troca continua válido até expirar por conta própria** (até 24h depois) — não há mecanismo de invalidação/revogação de token hoje, porque o backend não mantém nenhum estado de sessão para revogar.

Isso é relevante especificamente para "esqueci minha senha", porque o cenário mais comum de uso desse fluxo é justamente um dispositivo/sessão comprometida ou indesejada (ex.: usuário suspeita que outra pessoa tem acesso à conta) — nesse cenário, o usuário trocaria a senha esperando "derrubar" qualquer sessão que não seja a dele, mas o desenho atual não permite isso.

```
OPEN QUESTION-003

Pergunta: ao redefinir a senha com sucesso, deveríamos invalidar todas as sessões (JWT)
ativas da conta, forçando novo login em todos os dispositivos? Se sim, como, dado que
hoje não há nenhum estado de sessão do lado do servidor (JWT puramente stateless)?

Por que importa: sem isso, alguém que tenha acesso não autorizado a uma sessão ativa
mantém esse acesso por até 24h mesmo depois do dono legítimo trocar a senha — o cenário
mais provável de uso deste fluxo é justamente tentar se proteger desse tipo de acesso
indevido.

Como responder: opções possíveis, a serem avaliadas com o Backend/Software Architect
quando este ticket for priorizado:
  (a) aceitar o risco residual de até 24h — é o comportamento mais simples, consistente
      com a decisão original de JWT stateless sem refresh token (ticket mestre, seção 3);
  (b) introduzir uma coluna de versão/timestamp de "senha alterada em" no app_user, e
      validar no filtro JWT se o token foi emitido antes dessa marca (invalida qualquer
      JWT anterior à última troca de senha) — exige tocar no filtro de autenticação
      atual e adicionar esse dado ao claim ou consultar o usuário a cada requisição
      (custo de performance a avaliar);
  (c) reduzir a expiração do JWT de forma geral (não só para este fluxo) — mudança mais
      ampla, fora do escopo pontual deste ticket.
Não é uma decisão de produto pura — depende de viabilidade técnica, por isso fica como
Open Question em vez de decisão fechada.

Owner: Tito + Backend/Software Architect, no momento da priorização deste ticket.
```

```
OPEN QUESTION-004

Pergunta: qual o prazo de expiração exato do token de recuperação de senha (seção 7
propõe 30–60 minutos, sem fechar o valor)?

Por que importa: mesmo trade-off já resolvido para o token de confirmação de cadastro
(usabilidade vs. janela de exposição) — precisa da mesma decisão explícita aqui.

Como responder: decisão de produto simples, o Tito pode fechar isso rapidamente quando
este ticket for priorizado, sem necessidade de investigação adicional.

Owner: Tito.
```

## 11. Critérios de aceite (Given/When/Then)

**AC-01 — Solicitar recuperação com e-mail existente e ativo**
Dado um e-mail cadastrado com conta ativa,
Quando o usuário solicita recuperação de senha para esse e-mail,
Então a API responde com a mensagem genérica de sucesso, e um e-mail com o token de recuperação é enviado para esse endereço.

**AC-02 — Solicitar recuperação com e-mail inexistente**
Dado um e-mail que não existe no sistema,
Quando alguém solicita recuperação de senha para esse e-mail,
Então a API responde com a mesma mensagem genérica de sucesso do AC-01, e nenhum e-mail é enviado.

**AC-03 — Solicitar recuperação com e-mail de conta pendente de confirmação**
Dado um e-mail cadastrado, mas com conta ainda pendente de confirmação de cadastro,
Quando alguém solicita recuperação de senha para esse e-mail,
Então a API responde com a mesma mensagem genérica de sucesso, e nenhum e-mail de recuperação é enviado (a conta não pode logar de qualquer forma até confirmar o cadastro).

**AC-04 — Redefinir senha com token válido**
Dado um token de recuperação de senha válido, não expirado e não consumido,
Quando o usuário informa esse token com uma nova senha que atende aos requisitos e confirmação coincidente,
Então a senha da conta é atualizada (em hash), o token é marcado como consumido, e o usuário consegue fazer login com a nova senha em seguida.

**AC-05 — Redefinir senha com token expirado**
Dado um token de recuperação gerado há mais tempo que o prazo de expiração definido (Open Question-004),
Quando o usuário tenta usá-lo para redefinir a senha,
Então a API rejeita com `TOKEN_RECUPERACAO_INVALIDO`, e a senha da conta não é alterada.

**AC-06 — Redefinir senha com token já consumido**
Dado um token de recuperação que já foi usado com sucesso uma vez,
Quando alguém tenta reutilizá-lo,
Então a API rejeita com `TOKEN_RECUPERACAO_INVALIDO`, e a senha da conta não é alterada.

**AC-07 — Redefinir senha com token inexistente ou malformado**
Dado um valor de token que não corresponde a nenhum token gerado,
Quando alguém tenta redefinir a senha com esse valor,
Então a API rejeita com `TOKEN_RECUPERACAO_INVALIDO`.

**AC-08 — Redefinir senha com nova senha fraca**
Dado um token de recuperação válido,
Quando o usuário informa uma nova senha que não atende aos requisitos de força (mesma regra do cadastro),
Então a API rejeita com erro claro indicando os requisitos não atendidos, e a senha da conta não é alterada.

**AC-09 — Nova solicitação de recuperação invalida token anterior**
Dado uma conta com um token de recuperação já gerado e ainda em aberto,
Quando o usuário solicita recuperação de senha novamente para a mesma conta,
Então um novo token é gerado e enviado, e o token anterior deixa de ser válido (mesmo se ainda dentro do prazo de expiração original).

**AC-10 — Rate limiting de solicitação de recuperação**
Dado múltiplas solicitações de recuperação de senha para o mesmo e-mail em um curto intervalo, excedendo o limite configurado,
Quando uma nova solicitação chega,
Então a API rejeita com `RATE_LIMIT_EXCEDIDO`, mesmo padrão já usado em cadastro/login/reenvio.

## 12. Riscos e perguntas em aberto

- **OPEN QUESTION-003** (sessões ativas ao trocar senha) — seção 10, não bloqueia especificação, mas deve ser resolvida antes da implementação.
- **OPEN QUESTION-004** (prazo de expiração exato do token) — seção 10, decisão simples pendente do Tito.
- **Risco — link de recuperação por e-mail pode ser interceptado.** Mesma classe de risco já aceita para o token de confirmação de cadastro (ticket mestre); mitigado por token de alta entropia + expiração curta + uso único (consumo), mesmo padrão.
- **Risco — SMTP real ainda não provisionado.** Mesma pendência já registrada no ticket mestre (OPEN QUESTION-D, seção 12 de `TICKET-autenticacao.md`) — este fluxo depende da mesma infraestrutura de e-mail, então herda a mesma limitação: pode ser implementado e testado com o mock/stub de envio já existente, mas o teste de entrega real depende da mesma credencial pendente.
- **Risco — link de front-end para o token.** O e-mail de recuperação precisa conter um link para uma URL do frontend (ex.: `/redefinir-senha?token=...`), que precisa existir como rota nova no frontend — não detalhado aqui (é decisão de implementação do Frontend Engineer), mas registrado para não ser esquecido: este ticket especifica os endpoints de backend, a tela/rota de frontend correspondente ainda precisa ser criada quando este ticket for implementado.

---

## 13. Retorno esperado deste ticket

- **Objetivo:** fechar a lacuna de recuperação de senha, hoje inexistente, através de um fluxo de duas etapas (solicitar → redefinir), com token de alta entropia dedicado (`TokenRecuperacaoSenha`, entidade nova, não reaproveitando `TokenConfirmacaoCadastro`), mantendo anti-enumeração de e-mail (diferente do cadastro, que já a perdeu por decisão própria).
- **Escopo:** dois endpoints novos (`POST /api/auth/esqueci-senha`, `POST /api/auth/redefinir-senha`), reaproveitando `PasswordValidator`, `RateLimiter` e a infraestrutura de e-mail assíncrono já existentes; schema físico é decisão do DBA a partir da seção 6.
- **Restrições:** este é um ticket de especificação — **nenhuma implementação deve começar a partir dele sem priorização explícita**. Não reabre a decisão de anti-enumeração do cadastro (já resolvida em outro ticket) nem introduz MFA, OAuth, ou histórico de senhas.
- **Critério de conclusão (da especificação):** DBA consegue avaliar viabilidade do schema a partir da seção 6; Backend consegue estimar esforço a partir das seções 4, 7–9; critérios de aceite da seção 11 são verificáveis assim que implementado.
- **Bloqueios:** OPEN QUESTION-003 (sessões ativas) precisa de decisão técnica antes da implementação; OPEN QUESTION-004 (prazo de expiração) é decisão simples e rápida do Tito; credencial SMTP real (herdada do ticket mestre) não bloqueia a implementação, só o teste de entrega real.
