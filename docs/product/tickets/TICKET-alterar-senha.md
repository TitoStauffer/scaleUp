# TICKET — Alterar senha (usuário autenticado)

**Status:** pronto para implementação imediata. Diferente do ticket irmão de recuperação de senha (`TICKET-esqueci-minha-senha.md`, que é apenas especificação), este ticket **deve ser implementado nesta mesma sessão**, junto com aquele. Todas as decisões de produto necessárias para começar já estão fechadas (seção 5); não há Open Question bloqueante.
**Ticket mestre de referência:** `docs/product/tickets/TICKET-autenticacao.md` — **leia primeiro**. Este ticket preenche outra lacuna deixada explicitamente fora de escopo lá (seção 2 e seção 11: "alteração de e-mail/senha após login... fica para tickets futuros"). Não redefine cadastro, confirmação de cadastro, login ou JWT.
**Ticket relacionado:** `docs/product/tickets/TICKET-esqueci-minha-senha.md` — fluxo irmão, mas para usuário **deslogado** que não sabe a senha atual, autenticado por token de e-mail. Este ticket é para usuário **já logado**, que sabe a senha atual e quer trocá-la por vontade própria. Os dois fluxos não se sobrepõem, mas compartilham a mesma pendência técnica de sessões JWT ativas (seção 8, referenciando OPEN QUESTION-003 daquele ticket) e a mesma regra de força de senha (`PasswordValidator`).
**Depende de:** nenhuma dependência de conteúdo nova. Reaproveita infraestrutura já implementada: `PasswordValidator`, `PasswordEncoder` (`BCryptPasswordEncoder`), `CurrentUserProvider`, `RateLimiter`, `UsuarioController`, `ProtectedRoute` (frontend).

---

## 1. Contexto e motivação

Hoje, um usuário autenticado não tem nenhuma forma de trocar a própria senha pelo produto. O único endpoint existente em `UsuarioController` é `GET /api/usuarios/atual`, somente leitura. Não existe nenhuma tela de conta/perfil no frontend — o header (`App.tsx`) só tem navegação de estudo e o botão "Sair".

Essa lacuna é diferente da resolvida por `TICKET-esqueci-minha-senha.md`: aquele fluxo cobre quem **esqueceu** a senha e está deslogado (autenticado por token de e-mail, prova de identidade por posse da caixa de entrada). Este ticket cobre quem **lembra** a senha atual, está logado (prova de identidade pela sessão JWT válida), e quer trocá-la por rotina de segurança pessoal ou por desconfiar que a senha vazou — um caso de uso comum e independente do primeiro.

Sem este fluxo, a única forma de um usuário trocar a senha sabendo a atual seria deslogar, usar o fluxo de "esqueci minha senha" (que não foi desenhado para esse caso) ou pedir intervenção manual — nenhuma das duas é uma experiência razoável para uma ação tão básica de segurança de conta.

## 2. Objetivo

Permitir que um usuário autenticado troque a própria senha, informando a senha atual (para provar posse, já que a sessão sozinha não é suficiente — ver seção 5.1) e a nova senha (com confirmação), através de um endpoint novo em `UsuarioController` e uma tela nova de conta/perfil no frontend, reaproveitando toda a infraestrutura de validação de senha, hash e rate limiting já existente no módulo Identity.

## 3. Escopo

**Dentro:**
- Endpoint `POST /api/usuarios/atual/senha`, protegido por JWT, resolvendo a conta a partir de `CurrentUserProvider` (nunca por parâmetro/request).
- Exigência de senha atual correta como pré-condição para a troca.
- Reaproveitamento de `PasswordValidator` para a nova senha (mesma regra do cadastro).
- Reaproveitamento de `PasswordEncoder`/`RateLimiter` já existentes.
- Erro específico e claro para senha atual incorreta.
- Decisão sobre nova senha igual à atual (seção 5.4).
- Tela nova de frontend (`/conta` ou rota equivalente) com formulário de senha atual, nova senha, confirmação de nova senha, protegida por `ProtectedRoute`.
- Ponto de entrada na navegação (proposta + Open Question fina de posicionamento exato, seção 9).
- Critérios de aceite Given/When/Then.
- Riscos e perguntas em aberto.

**Fora:**
- Alteração de e-mail da conta — recurso diferente, não solicitado.
- Recuperação de senha para usuário deslogado — já coberta por `TICKET-esqueci-minha-senha.md`.
- Autenticação de dois fatores (MFA).
- Login social (OAuth).
- Histórico/bloqueio de reuso de senhas anteriores — mesma decisão já tomada no ticket irmão (não há infraestrutura de histórico de senha hoje; criar uma só para este caso é over-engineering neste estágio).
- Notificação por e-mail avisando que a senha foi alterada — não solicitado; pode ser considerado em iteração futura (registrado como nota na seção 9, não bloqueia este ticket).
- Resolução definitiva de invalidação de sessões JWT ativas — depende de OPEN QUESTION-003 do ticket irmão (seção 8).

## 4. Fluxo proposto

```
1. Usuário autenticado acessa a tela de conta/perfil (ver seção 9, ponto de entrada)
2. Usuário informa: senha atual, nova senha, confirmação de nova senha
3. POST /api/usuarios/atual/senha { senhaAtual, novaSenha, confirmacaoNovaSenha }
   → resolve a conta a partir do JWT da requisição (CurrentUserProvider), nunca de um
     parâmetro no corpo da requisição
   → valida que senhaAtual bate com o hash armazenado (PasswordEncoder.matches)
     → se não bater: rejeita com SENHA_ATUAL_INCORRETA, nenhuma alteração é feita
   → valida força da nova senha (PasswordValidator, mesma regra do cadastro)
   → valida que novaSenha == confirmacaoNovaSenha (mesma lógica de UX do cadastro)
   → valida que novaSenha é diferente de senhaAtual (seção 5.4)
   → atualiza o hash da senha da conta
4. Usuário recebe confirmação de sucesso na própria tela (sem precisar relogar,
   ver seção 8 sobre a sessão atual continuar válida)
```

## 5. Decisões de produto

### 5.1 Exigir senha atual para trocar — sim, sempre

Diferente do "esqueci minha senha" (onde a prova de identidade é a posse da caixa de entrada, via token), aqui a sessão JWT sozinha **não é prova suficiente** de que quem está fazendo a requisição é o dono legítimo da conta. Um JWT pode ter sido copiado de uma sessão deixada aberta (navegador compartilhado, dispositivo emprestado, token vazado de um log ou de um ataque XSS) sem que o atacante saiba a senha original. Se bastasse estar logado para trocar a senha, esse cenário permitiria a um atacante "sequestrar" a conta definitivamente — trocando a senha, ele bloqueia o dono legítimo de recuperar o acesso por login normal, forçando-o a passar pelo fluxo de recuperação por e-mail (que ainda funciona, mas é um incômodo evitável). Exigir a senha atual reduz drasticamente essa superfície: um JWT roubado sem a senha não é suficiente para tomar a conta.

### 5.2 Erro para senha atual incorreta — específico e visível

Diferente da anti-enumeração aplicada a login e a "esqueci minha senha" (onde a resposta precisa ser genérica porque quem pergunta **ainda não provou nada**), aqui o requisitante **já está autenticado por JWT válido** — já é, por definição, quem tem acesso à conta. Não há ganho de segurança em esconder se a senha atual informada está certa ou errada, porque não há um cenário de enumeração em massa possível (o atacante precisaria de um JWT válido daquela conta específica para sequer chegar a esse endpoint). Mesma lógica já aplicada a `ContaNaoConfirmadaException`/`CredenciaisInvalidasException` no login: "quem já se provou dono pode receber mensagens de erro mais específicas". Código de erro proposto: `SENHA_ATUAL_INCORRETA`.

### 5.3 Sessões ativas ao trocar a senha — mesma pendência do ticket irmão

Esta é exatamente a mesma pendência técnica já registrada como **OPEN QUESTION-003** em `TICKET-esqueci-minha-senha.md` (seção 10): JWT stateless, sem mecanismo de revogação, então qualquer token emitido antes da troca continua válido até expirar (até 24h). Não duplico a decisão aqui — referencio a mesma Open Question. O importante registrado neste ticket: **se e quando** OPEN QUESTION-003 for resolvida, a solução deve cobrir os dois fluxos (recuperação de senha e alteração de senha) de forma consistente — não faria sentido invalidar sessões antigas só quando a senha é trocada via "esqueci minha senha" e não quando é trocada por este fluxo (ou vice-versa), já que o resultado final (senha trocada) é o mesmo e o risco residual (sessão antiga ainda válida) é idêntico nos dois casos.

### 5.4 Nova senha igual à atual — rejeitar

Diferente da recuperação de senha (onde permitir reuso foi aceito, porque ali o objetivo é só restaurar acesso, não é um evento de segurança), aqui faz sentido rejeitar: o usuário está ativamente decidindo "trocar de senha" — se a nova senha informada é idêntica à atual, é, no melhor caso, um erro de digitação (ex.: colou a senha errada no campo errado) e, no pior caso, uma falsa sensação de segurança para quem está tentando esse fluxo justamente por desconfiar de vazamento (trocar "por trocar" sem de fato mudar nada não resolve o motivo que trouxe o usuário até aqui). Rejeitar com erro claro custa pouco e evita essa confusão. Não é tratado como falha de segurança, apenas como validação de entrada — mesmo padrão de `REQUISICAO_INVALIDA`.

### 5.5 Rate limiting

Reaproveitar `RateLimiter` já existente, mesma lógica de chave por ação, agora por usuário autenticado em vez de e-mail (ex.: `"alterar-senha:" + userId`, já que aqui a conta é resolvida por `CurrentUserProvider`, não por e-mail no request). Mitiga força bruta da senha atual (um JWT válido sozinho não deveria permitir tentar senhas atuais indefinidamente até acertar).

## 6. Endpoint proposto

| Método | Rota | Request | Response (sucesso) | Autenticação |
|---|---|---|---|---|
| `POST` | `/api/usuarios/atual/senha` | `{ "senhaAtual": string, "novaSenha": string, "confirmacaoNovaSenha": string }` | `{ "mensagem": "senha alterada com sucesso" }` | JWT obrigatório (rota já cai em `anyRequest().authenticated()`, nenhuma configuração nova em `SecurityConfig`) |

**Erros propostos**, mesmo padrão `ApiErrorResponse` já usado no resto do módulo (`GlobalExceptionHandler`):

| Situação | `erro` | status |
|---|---|---|
| Senha atual informada não bate com o hash armazenado | `SENHA_ATUAL_INCORRETA` | 401 |
| Nova senha não atende aos requisitos de força (`PasswordValidator`) | `REQUISICAO_INVALIDA` (reaproveita o handler de `IllegalArgumentException`, mesmo padrão do AC-02 do cadastro) | 400 |
| Nova senha e confirmação não coincidem | `REQUISICAO_INVALIDA` | 400 |
| Nova senha igual à senha atual | `REQUISICAO_INVALIDA` | 400 |
| Rate limit excedido | `RATE_LIMIT_EXCEDIDO` (reaproveita `RateLimitExcedidoException` já existente) | 429 |

Nenhuma rota nova precisa ser adicionada a `permitAll` em `SecurityConfig` — `/api/usuarios/atual/senha` já cai na regra padrão de autenticação exigida.

## 7. Frontend

- **Rota nova:** `/conta` (ou nome equivalente a critério do Frontend Engineer), protegida por `ProtectedRoute`, mesmo padrão já usado nas demais rotas autenticadas.
- **Página nova:** formulário com três campos — senha atual, nova senha, confirmação de nova senha. Mesma UX de checklist em tempo real dos requisitos de senha já usada na tela de cadastro (ticket mestre, seção 10), reaproveitando a mesma lógica de validação client-side.
- **Estados de erro:** senha atual incorreta (mensagem específica, ver 5.2), nova senha fraca (client-side e backend), confirmação não coincide (client-side), nova senha igual à atual (backend).
- **Estado de sucesso:** mensagem de confirmação na própria página; a sessão atual continua válida (ver seção 8), não é necessário redirecionar para login.

## 8. Sessão atual após a troca

Diferente de uma eventual invalidação de sessões *outras* (OPEN QUESTION-003, ainda não resolvida), a sessão que **fez a própria troca** deve continuar funcionando normalmente até o JWT expirar por conta própria — não há motivo para deslogar o usuário que acabou de provar conhecer a senha atual e trocá-la com sucesso. O frontend não precisa forçar logout/relogin após o sucesso deste fluxo.

## 9. Ponto de entrada na navegação (proposta + Open Question fina)

**Proposta:** adicionar um link "Minha conta" (ou ícone equivalente) no header (`App.tsx`), próximo ao botão "Sair", visível apenas quando autenticado — mesmo padrão de visibilidade condicional já usado para o botão "Sair" hoje.

```
OPEN QUESTION-005

Pergunta: o link "Minha conta" deve ficar como item de texto direto no header
(mesmo nível visual do "Sair" e da navegação de estudo), ou atrás de um menu
suspenso (dropdown) com o e-mail/nome do usuário, deixando espaço para itens
futuros de conta (ex.: alterar e-mail, se algum dia for implementado)?

Por que importa: é uma decisão pequena de UX, não bloqueia a implementação do
endpoint nem da página — o Frontend Engineer pode decidir no momento da
implementação com base no espaço disponível no header atual.

Como responder: decisão rápida do Frontend Engineer ou do Tito ao revisar a
implementação; não precisa de investigação.

Owner: Frontend Engineer, na implementação.
```

## 10. Critérios de aceite (Given/When/Then)

**AC-01 — Alterar senha com senha atual correta e nova senha válida**
Dado um usuário autenticado com JWT válido, que informa a senha atual correta e uma nova senha que atende aos requisitos de força, com confirmação coincidente,
Quando ele envia a requisição de alteração de senha,
Então a senha da conta é atualizada (em hash), a API responde com sucesso, e o usuário consegue fazer login com a nova senha em seguida.

**AC-02 — Alterar senha com senha atual incorreta**
Dado um usuário autenticado que informa uma senha atual que não bate com a armazenada,
Quando ele envia a requisição,
Então a API rejeita com `SENHA_ATUAL_INCORRETA`, e a senha da conta não é alterada.

**AC-03 — Alterar senha com nova senha fraca**
Dado um usuário autenticado com senha atual correta, que informa uma nova senha que não atende aos requisitos de força (mesma regra do cadastro),
Quando ele envia a requisição,
Então a API rejeita com `REQUISICAO_INVALIDA` indicando os requisitos não atendidos, e a senha da conta não é alterada.

**AC-04 — Alterar senha com confirmação não coincidente**
Dado um usuário autenticado com senha atual correta, que informa nova senha e confirmação diferentes entre si,
Quando ele envia a requisição,
Então a API rejeita com `REQUISICAO_INVALIDA`, e a senha da conta não é alterada.

**AC-05 — Alterar senha para o mesmo valor da senha atual**
Dado um usuário autenticado com senha atual correta, que informa uma nova senha idêntica à senha atual,
Quando ele envia a requisição,
Então a API rejeita com `REQUISICAO_INVALIDA`, e a senha da conta não é alterada.

**AC-06 — Tentativa sem autenticação**
Dado uma requisição sem JWT válido no header `Authorization`,
Quando ela chega em `POST /api/usuarios/atual/senha`,
Então a API responde `401 Unauthorized`, mesmo comportamento padrão já aplicado a qualquer rota protegida.

**AC-07 — Rate limiting de tentativas**
Dado múltiplas tentativas de alteração de senha para a mesma conta em um curto intervalo, excedendo o limite configurado,
Quando uma nova tentativa chega,
Então a API rejeita com `RATE_LIMIT_EXCEDIDO`, mesmo padrão já usado em login/cadastro/recuperação.

**AC-08 — Sessão atual continua válida após a troca**
Dado um usuário que troca a senha com sucesso (AC-01),
Quando ele continua navegando na aplicação usando o mesmo JWT que já tinha antes da troca,
Então as requisições continuam funcionando normalmente até o JWT expirar por conta própria (sem necessidade de relogin imediato).

**AC-09 — Alteração não afeta outra conta**
Dado dois usuários distintos autenticados (contas A e B),
Quando o usuário da conta A envia uma requisição de alteração de senha,
Então apenas a senha da conta A é alterada — a conta a ser alterada é sempre resolvida pelo JWT da requisição (`CurrentUserProvider`), nunca por um identificador no corpo da requisição.

## 11. Riscos e perguntas em aberto

- **OPEN QUESTION-003** (herdada de `TICKET-esqueci-minha-senha.md`, seção 10) — sessões JWT antigas continuam válidas após a troca de senha por até 24h. Não bloqueia a implementação deste ticket; se resolvida no futuro, deve cobrir os dois fluxos (recuperação e alteração) de forma consistente, conforme seção 5.3.
- **OPEN QUESTION-005** (seção 9) — posicionamento exato do link "Minha conta" no header. Não bloqueia a implementação do endpoint nem da página.
- **Risco — força bruta de senha atual via sessão comprometida.** Mitigado por `RateLimiter` (seção 5.5) — um JWT roubado sozinho não permite tentar senhas atuais indefinidamente.
- **Nota (fora de escopo, não bloqueia):** notificação por e-mail avisando o dono da conta que a senha foi alterada (mesmo sem ser ele quem alterou) seria uma camada adicional de segurança razoável para iteração futura, mas não foi solicitada e não está no escopo deste ticket.

---

## 12. Retorno esperado deste ticket

- **Objetivo:** fechar a lacuna de alteração de senha para usuário autenticado, hoje inexistente, com endpoint novo (`POST /api/usuarios/atual/senha`) exigindo senha atual, reaproveitando `PasswordValidator`, `PasswordEncoder`, `CurrentUserProvider` e `RateLimiter` já existentes, mais uma tela nova de conta no frontend.
- **Escopo:** um endpoint de backend em `UsuarioController`, uma rota e página novas de frontend (`/conta`), protegida por `ProtectedRoute`; nenhuma alteração de schema é necessária (reaproveita `AppUser.senhaHash` já existente).
- **Restrições:** não resolve OPEN QUESTION-003 (sessões ativas), apenas referencia; não implementa histórico de senha, MFA, OAuth ou alteração de e-mail.
- **Critério de conclusão:** Backend consegue implementar o endpoint a partir das seções 5–6 sem ambiguidade; Frontend consegue implementar a página a partir da seção 7; critérios de aceite da seção 10 são verificáveis assim que implementado.
- **Bloqueios:** nenhum bloqueio para implementação imediata. OPEN QUESTION-005 é uma decisão fina de UX que pode ser resolvida durante a própria implementação.
