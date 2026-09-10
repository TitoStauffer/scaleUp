# TICKET — Envio de e-mail assíncrono (cadastro e reenvio de token)

**Status:** pronto para Backend Engineer. Uma Open Question de arquitetura pendente de decisão do Tito (seção 7) — não bloqueia o início da implementação, apenas a escolha entre duas variantes válidas.
**Origem:** pedido direto do Tito — hoje o usuário fica com a tela travada em `POST /api/auth/cadastro` e `POST /api/auth/reenviar-token` enquanto o backend aguarda a chamada de rede síncrona ao SMTP do Gmail terminar.
**Depende de:** `TICKET-autenticacao.md` (já implementado — `CadastrarContaService`, `ReenviarTokenService`, `EmailSender`, `SmtpEmailSender`, `LogEmailSender` já existem em `backend/src/main/java/com/scaleup/studyplatform/identity/application/`).

---

## 1. Objetivo

Fazer o envio do e-mail de confirmação de cadastro (e de reenvio de token) parar de bloquear a resposta HTTP ao usuário. Hoje o request só retorna depois que `mailSender.send()` (chamada de rede real ao SMTP) termina — isso trava a tela de cadastro/confirmação no frontend enquanto o e-mail está sendo enviado.

**Restrição de solução, definida pelo Tito:** resolver com `@Async` do próprio Spring. Não é necessário fila, broker externo (RabbitMQ, Kafka, SQS etc.) nem sistema de eventos distribuído — a annotation já resolve o problema de UX.

## 2. Escopo

**Dentro:**
- Tornar o disparo do e-mail de confirmação de cadastro (`CadastrarContaService`) e de reenvio de token (`ReenviarTokenService`) não bloqueante para quem chama a API.
- Habilitar `@EnableAsync` no projeto (hoje não existe).
- Configurar um `ThreadPoolTaskExecutor` dedicado para os e-mails, com limites explícitos (não usar o executor default do Spring, que é ilimitado por design e não deve rodar em produção sem tuning).
- Decidir e implementar o ponto exato onde o `@Async` entra (método de envio vs. listener de evento pós-commit — ver seção 7).
- Garantir que falha no envio de e-mail continua não afetando a resposta HTTP nem a transação de cadastro/reenvio (comportamento já existente hoje, só precisa ser preservado).

**Fora:**
- Fila de mensageria, broker externo, ou qualquer mecanismo fora do processo da aplicação.
- Retry avançado de envio (backoff, DLQ, reprocessamento). Se o envio falhar, comportamento é o mesmo de hoje: loga e segue (usuário pode pedir reenvio manual).
- Qualquer outro tipo de e-mail além dos dois já existentes (confirmação de cadastro / reenvio de token) — não há outros e-mails no sistema hoje.
- Mudança de contrato de API (request/response de `POST /api/auth/cadastro` e `POST /api/auth/reenviar-token` continuam iguais).
- Métricas/observabilidade de fila de e-mails (fora de escopo — não há fila).

## 3. Contexto técnico (já investigado, não precisa reinvestigar)

- `EmailSender` (interface) — método único `enviarTokenConfirmacao(String destinatario, String token)`.
- `SmtpEmailSender` — implementação real via `JavaMailSender`, ativa com `email.provider=smtp`. Chama `mailSender.send(mensagem)` de forma síncrona; falha já é capturada em `try/catch` interno e só logada (`log.error`), não propaga exceção.
- `LogEmailSender` — implementação padrão (`email.provider=mock` ou ausente), só loga o token; já é praticamente instantânea (não é o gargalo).
- `CadastrarContaService.cadastrar()` — método `@Transactional`, chama `gerarEEnviarToken(conta)` (linha ~83-87), que chama `emailSender.enviarTokenConfirmacao(...)` de forma síncrona **dentro** da transação de cadastro.
- `ReenviarTokenService.reenviar()` — mesmo padrão, método `@Transactional`, chama `gerarEEnviarToken(conta)` (linha ~71-75) de forma síncrona **dentro** da transação de reenvio.
- Não há `@EnableAsync` nem `ThreadPoolTaskExecutor` configurado no projeto hoje.

## 4. Decisões já tomadas (não são Open Questions)

1. **Mecanismo:** `@Async` do Spring Framework — nenhuma fila, broker ou sistema de eventos externo.
2. **Executor dedicado:** deve existir um `ThreadPoolTaskExecutor` nomeado (ex. `emailTaskExecutor`) configurado explicitamente para as tarefas de e-mail, com `corePoolSize`, `maxPoolSize` e `queueCapacity` definidos pelo Backend Engineer — não usar o `SimpleAsyncTaskExecutor` default do Spring (cria uma thread nova por chamada, sem limite, o que é inadequado mesmo em baixo volume, por não ter nenhum controle de saturação). Justificativa de negócio: volume de e-mail é baixo (cadastro/reenvio), mas o objetivo do ticket é eliminar bloqueio de UX com previsibilidade, não introduzir um novo vetor de esgotamento de threads.
3. **Falha de envio continua não propagando exceção** para quem chama — `SmtpEmailSender` já captura e loga; esse comportamento deve ser preservado (ou reforçado, se a versão assíncrona escolhida mudar onde a exceção pode vazar — ex.: exceção não tratada dentro de um método `@Async` vai para um `AsyncUncaughtExceptionHandler`, não para quem chamou; o Backend deve garantir que isso também só loga, nunca derruba a aplicação ou deixa erro silencioso sem log nenhum).
4. **`LogEmailSender` (modo mock/log) permanece síncrono.** Não há ganho de UX em tornar assíncrono um `log.info` que já é praticamente instantâneo (não faz chamada de rede); tornar assíncrono só adicionaria complexidade (troca de thread, possível reordenação de logs em teste) sem benefício. Se a decisão da seção 7 for aplicar `@Async` no nível do listener de evento (opção 2), o `LogEmailSender` também passaria por ele — nesse caso, aceitar a leve troca de contexto (não é um problema, só um detalhe a documentar no PR) em troca de manter as duas implementações de `EmailSender` com o mesmo caminho de código (evita duplicar lógica de "quando disparar o e-mail" entre implementações).

## 5. Requisitos funcionais e não funcionais

- O request HTTP de cadastro e de reenvio deve retornar ao cliente sem esperar o envio de e-mail terminar (nem sucesso, nem falha do envio deve atrasar a resposta).
- Falha no envio de e-mail (SMTP fora do ar, credencial inválida, timeout de rede) não pode:
  - fazer o endpoint retornar erro ao usuário (o cadastro/reenvio já foi persistido com sucesso antes do e-mail ser disparado);
  - reverter a transação de cadastro/reenvio;
  - lançar exceção não tratada que apareça em log como erro fatal da aplicação (deve ser logada como o `SmtpEmailSender` já faz hoje, ou de forma equivalente se a captura se mover).
- O pool de threads dedicado a e-mail deve ter limites configuráveis (idealmente via `application.properties`, mas valores fixos no código também são aceitáveis nesta entrega — decisão de implementação do Backend).
- Nenhuma mudança de contrato observável pelo frontend (mesmos endpoints, mesmos payloads, mesmas mensagens genéricas de sucesso já definidas em `TICKET-autenticacao.md`).

## 6. Regras de negócio que não mudam (herdadas do `TICKET-autenticacao.md`)

- Mensagens de resposta genéricas (anti-enumeração) continuam as mesmas.
- Falha de envio de e-mail não afeta se a conta é criada/token é gerado — isso já é verdade hoje e continua sendo, independente de síncrono ou assíncrono.
- Reenvio invalida o token anterior antes de gerar um novo — essa lógica é toda síncrona, dentro da transação; só o disparo do e-mail em si passa a ser assíncrono.

---

## 7. Open Question — onde exatamente aplicar `@Async`

```
OPEN QUESTION-E

Question: O `@Async` deve ser aplicado (A) diretamente no método de envio de e-mail
(ex. em `SmtpEmailSender.enviarTokenConfirmacao`), ou (B) num listener de evento de
domínio disparado via `ApplicationEventPublisher` do Spring, anotado com
`@TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)` + `@Async`?

Why It Matters: `enviarTokenConfirmacao` é chamado de dentro de um método `@Transactional`
(`CadastrarContaService.cadastrar()` e `ReenviarTokenService.reenviar()`). Como `EmailSender`
é injetado como bean separado (não é self-invocation), o proxy `@Async` funciona
normalmente nas duas opções — não há o problema clássico de "`@Async` não funciona porque é
chamado de dentro da mesma classe". A diferença real entre as opções é sobre GARANTIA DE
ORDEM, não sobre a annotation funcionar ou não:

  - Opção A (`@Async` direto no método de envio): a chamada assíncrona é agendada no
    momento em que o código executa `emailSender.enviarTokenConfirmacao(...)`, que ainda
    está DENTRO da transação (antes do commit). Como o método fica assíncrono, o Spring
    devolve o controle imediatamente à thread principal e a thread separada pode, na
    prática, disparar o e-mail antes, durante ou depois do commit — não há garantia. Se o
    commit falhar por qualquer motivo depois desse ponto (ex.: erro de banco na sequência
    do método, antes do fim da transação), o e-mail já pode ter sido enviado para uma
    conta/token que nunca chegou a existir de fato no banco.
  - Opção B (evento + `@TransactionalEventListener(AFTER_COMMIT)` + `@Async`): o e-mail só
    é disparado depois que a transação realmente commitou. Isso é Spring puro (não é a
    "fila e evento" que o Tito pediu para evitar — não introduz broker, não introduz
    sistema de mensageria externo, é só o mecanismo padrão do `ApplicationEventPublisher`
    já embutido no Spring Framework, rodando no mesmo processo). Continua podendo ser
    `@Async` no listener, preservando o objetivo de não bloquear a resposta HTTP.

  Este risco (enviar e-mail para algo que não commitou) já existe hoje, de forma mais sutil,
  mesmo com envio síncrono: nada impede uma falha depois do `mailSender.send()` mas antes do
  fim da transação. A diferença é que, hoje, a janela é menor (execução sequencial na mesma
  thread) e, com `@Async` direto (opção A), a janela pode se tornar mais perceptível, porque
  a thread de e-mail pode correr em paralelo com o restante da transação.

Recommendation: Opção A (mais simples), com uma ressalva. Given o volume de escrita restante
depois de `gerarEEnviarToken()` nos dois services é mínimo (o e-mail é a última operação
relevante do método, não há mais nenhuma escrita no banco depois dele em nenhum dos dois
fluxos), o risco prático de "e-mail enviado para algo que não commitou" é baixo — e o próprio
Tito já aceita esse risco como pré-existente. A opção A atende literalmente o pedido original
("a annotation já resolve") com a menor mudança de código: uma annotation no método de envio
mais a configuração do executor, sem introduzir publicação/consumo de evento. A opção B é
tecnicamente mais correta e ainda cabe dentro da restrição do Tito (é Spring puro, sem fila),
mas adiciona uma classe de evento, um listener e mais uma camada de indireção para eliminar um
risco que hoje é teórico (não há relato de e-mail fantasma nem isso foi identificado como
problema real em produção). Se o Tito preferir eliminar o risco por
completo desde já (ex.: por já prever crescimento do método com mais escritas depois do envio
de e-mail no futuro), a opção B é a escolha correta e este ticket já contém contexto
suficiente para o Backend implementá-la sem retrabalho de descoberta.

How To Answer: Tito escolhe A ou B. Não bloqueia o início da implementação — o Backend pode
começar por `@EnableAsync` + o `ThreadPoolTaskExecutor` (comum às duas opções) enquanto aguarda
a decisão, e só o ponto de aplicação do `@Async` muda entre as duas.

Owner: Tito
```

---

## 8. Critérios de aceite (Given/When/Then)

**AC-01 — Cadastro não espera o envio de e-mail terminar**
Dado um cadastro válido com `email.provider=smtp` configurado e o envio de e-mail simulado com uma latência artificial perceptível (ex.: alguns segundos, via teste com um `EmailSender`/`JavaMailSender` de teste que introduz delay),
Quando o cliente chama `POST /api/auth/cadastro`,
Então a resposta HTTP retorna antes do tempo de latência artificial ter decorrido (não bloqueia esperando o envio).

**AC-02 — Reenvio não espera o envio de e-mail terminar**
Mesmo cenário do AC-01, mas para `POST /api/auth/reenviar-token`.

**AC-03 — Falha no envio de e-mail não derruba a resposta HTTP nem a transação**
Dado um cadastro válido com o envio de e-mail configurado para lançar exceção (simulando falha de SMTP),
Quando o cliente chama `POST /api/auth/cadastro`,
Então a API responde normalmente com a mensagem genérica de sucesso, a conta e o token de confirmação são persistidos no banco, e a falha de envio aparece apenas logada (não propaga para o cliente nem para o chamador da transação).

**AC-04 — Exceção assíncrona não tratada não derruba a aplicação**
Dado o cenário do AC-03,
Quando a exceção ocorre na thread assíncrona responsável pelo envio,
Então ela é tratada por um `AsyncUncaughtExceptionHandler` (ou captura equivalente) que apenas loga o erro, sem propagar para outras partes da aplicação nem deixar a thread do pool em estado inconsistente.

**AC-05 — Pool de threads de e-mail tem limites explícitos**
Dado o contexto do Spring inicializado,
Quando se inspeciona o `TaskExecutor` usado pelo(s) método(s) anotado(s) com `@Async` para envio de e-mail,
Então ele é um `ThreadPoolTaskExecutor` configurado explicitamente (não o `SimpleAsyncTaskExecutor` default), com `corePoolSize`, `maxPoolSize` e `queueCapacity` definidos.

**AC-06 — `LogEmailSender` continua síncrono (ou, se a Open Question-E for resolvida como opção B, segue o mesmo caminho do listener)**
Dado `email.provider=mock` (ou ausente),
Quando um cadastro é realizado,
Então o comportamento observável de log do token permanece imediato e determinístico o suficiente para os testes existentes de cadastro/confirmação continuarem passando sem alteração de asserts relacionados a tempo (ajustar apenas se a mudança de thread introduzir flakiness real, documentando o motivo).

**AC-07 — Comportamento funcional de cadastro/confirmação/reenvio não muda**
Dado os critérios de aceite já definidos em `TICKET-autenticacao.md` (AC-01 a AC-14),
Quando a suíte de testes existente para cadastro, confirmação e reenvio é executada após a mudança para `@Async`,
Então todos continuam passando sem alteração de regra de negócio — a única mudança observável é o tempo de resposta do endpoint, não o resultado funcional.

---

## 9. Retorno esperado deste handoff

- **Objetivo:** eliminar o bloqueio de tela do usuário durante `POST /api/auth/cadastro` e `POST /api/auth/reenviar-token`, usando `@Async` do Spring, sem fila ou broker externo.
- **Escopo:** `docs/product/tickets/TICKET-envio-email-assincrono.md` (este arquivo). Fora: fila/broker, retry avançado, outros e-mails, mudança de contrato de API.
- **Restrições:** `@Async` puro do Spring (restrição do Tito); executor dedicado com limites explícitos, não o default do Spring.
- **Critério de conclusão:** Backend consegue implementar sem ambiguidade a partir das seções 4–6, decidindo entre as opções A/B da seção 7 (ou aguardando a decisão do Tito, que não bloqueia o início); critérios de aceite da seção 8 são verificáveis em teste automatizado.
- **Bloqueios:** OPEN QUESTION-E (escolha entre opção A e B) — não bloqueia o início da implementação, apenas o ponto exato de aplicação do `@Async`.
