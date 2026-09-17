# TICKET — Perfil do usuário logado (dados pessoais + estatísticas de uso)

**Status:** pronto para implementação imediata. Todas as decisões de produto necessárias para começar já estão fechadas nesta sessão (seção 5); não há Open Question bloqueante.
**Ticket mestre de referência:** `docs/product/tickets/TICKET-autenticacao.md` — **leia primeiro**. O cadastro real só pede e-mail e senha (seção 4 daquele ticket); `AppUser.nome` existe desde V33 mas nunca foi de fato preenchido ou exposto por nenhum endpoint. Este é o primeiro ticket que efetivamente usa esse campo.
**Ticket relacionado:** `docs/product/tickets/TICKET-alterar-senha.md` — mesmo padrão de tela de conta/perfil autenticada, mesma infraestrutura (`CurrentUserProvider`, `UsuarioController`, `GlobalExceptionHandler`). Este ticket não redefine alteração de senha nem alteração de e-mail (fora de escopo, ver seção 3).
**Depende de:** nenhuma dependência de conteúdo nova. Reaproveita `CurrentUserProvider`, `UsuarioController`, `AppUserRepository`, `DomainProgressRepository`, `QuizAttemptRepository`, `ConsultarResultadoGeralService` e o padrão `ApiErrorResponse`/`GlobalExceptionHandler` já implementados.

---

## 1. Contexto e motivação

Hoje não existe nenhuma tela de conta/perfil consolidada no frontend além do fluxo de alteração de senha (`TICKET-alterar-senha.md`). O único dado pessoal do usuário exposto é `GET /api/usuarios/atual` (`id`, `nome`, `email`), e `nome` nunca é de fato preenchido — não há campo de nome no cadastro (ticket mestre, seção 4) nem qualquer endpoint que permita editá-lo.

Além disso, o usuário não tem hoje uma visão consolidada do próprio uso da plataforma. Os dados existem, mas espalhados: `DashboardPage.tsx` mostra um resumo geral, `ProgressoPage.tsx` mostra progresso por domínio, `HistoricoPage.tsx` mostra o histórico de tentativas de quiz de um domínio por vez. Não existe uma tela única de "meu perfil" que junte identidade (quem eu sou) com atividade (o que eu fiz).

Este ticket fecha as duas lacunas de uma vez: permite ao usuário editar nome, definir data de nascimento (opcional, informativa) e uma foto de perfil, mantendo e-mail somente leitura; e consolida numa única tela um resumo de estatísticas de uso que já são calculadas/armazenadas hoje por outros módulos (Study, Progress) — sem criar nenhum tracking novo.

## 2. Objetivo

Entregar uma tela de "Perfil" para o usuário autenticado, com duas seções:
1. **Dados pessoais** — nome (editável), data de nascimento (editável, opcional), e-mail (somente leitura) e foto de perfil (upload/remoção), através de endpoints novos em `UsuarioController`.
2. **Estatísticas de uso** — resumo consolidado (geral + por domínio) de sessões de estudo, resultados médios de quiz e quantidade de tentativas de quiz, através de um endpoint novo de agregação que reaproveita `StudySessionRepository`, `DomainProgressRepository` e `QuizAttemptRepository`, sem duplicar nenhuma lógica de cálculo já existente em Progress.

## 3. Escopo

**Dentro:**
- Migração de banco nova (V50) adicionando `data_nascimento`, `foto_perfil` e `foto_perfil_content_type` a `app_user`.
- `GET /api/usuarios/atual` estendido com `dataNascimento` e `temFotoPerfil` (seção 6.1).
- `PUT /api/usuarios/atual/perfil` para editar nome e data de nascimento (seção 6.1).
- `POST /api/usuarios/atual/foto`, `GET /api/usuarios/atual/foto` e `DELETE /api/usuarios/atual/foto` para upload, leitura e remoção da foto de perfil (seção 6.2).
- Validação de tamanho (2MB) e tipo de arquivo (`image/jpeg`, `image/png`, `image/webp`) da foto, com erro claro no padrão `ApiErrorResponse`.
- Endpoint novo de agregação `GET /api/usuarios/atual/perfil/estatisticas` (seção 7), combinando dados já calculados por Study/Progress.
- Tela nova de frontend (`/perfil`), protegida por `ProtectedRoute`.
- Critérios de aceite Given/When/Then.
- Riscos e perguntas em aberto.

**Fora:**
- Alteração de e-mail da conta — recurso diferente, não solicitado (mesma decisão já registrada em `TICKET-alterar-senha.md`).
- Alteração de senha — já coberta por `TICKET-alterar-senha.md`, não redefinida aqui.
- Qualquer tracking novo de uso (ex.: visualização de slide individual, tempo gasto por sessão) — decisão fechada: estatísticas usam exclusivamente dados já existentes.
- Storage externo (S3, blob storage) para a foto de perfil — decisão fechada: `bytea` no Postgres (seção 5.3).
- Crop/redimensionamento de imagem no backend — a foto é armazenada como recebida (validada por tamanho/tipo), sem processamento; redimensionamento client-side é decisão de UX do Frontend Engineer, não bloqueia este ticket.
- Autenticação de dois fatores (MFA), login social (OAuth) — sem relação com este ticket.

## 4. Fluxo proposto

```
Dados pessoais:
1. Usuário autenticado acessa /perfil
2. Frontend chama GET /api/usuarios/atual (nome, email, dataNascimento, temFotoPerfil)
   e, se temFotoPerfil, GET /api/usuarios/atual/foto para exibir a imagem
3. Usuário edita nome e/ou data de nascimento
4. PUT /api/usuarios/atual/perfil { nome, dataNascimento }
   → resolve a conta via CurrentUserProvider (nunca por parâmetro no corpo)
   → valida nome (seção 5.1) e data de nascimento (seção 5.2)
   → atualiza os campos
5. Usuário opcionalmente envia uma foto nova:
   POST /api/usuarios/atual/foto (multipart/form-data, campo "arquivo")
   → valida Content-Type (seção 5.3) e tamanho (seção 5.3)
   → persiste bytes + content-type em app_user
6. Usuário opcionalmente remove a foto: DELETE /api/usuarios/atual/foto
   → limpa foto_perfil e foto_perfil_content_type

Estatísticas de uso:
7. Frontend chama GET /api/usuarios/atual/perfil/estatisticas
   → retorna resumo geral (sessões totais, tentativas de quiz totais, pontuação média geral)
     e um item por domínio (sessões, tentativas de quiz, pontuação média do domínio)
8. Tela de perfil exibe o resumo — geral e por domínio
```

## 5. Decisões de produto

### 5.1 Nome — editável, opcional (mesma nulabilidade do schema atual)

`AppUser.nome` já é opcional desde V33 (`varchar(120)` nullable) porque o cadastro não o coleta. Este ticket não torna o campo obrigatório — exigir nome preenchido neste momento quebraria a experiência de qualquer conta cadastrada antes desta feature (nome sempre `null` até que o usuário abra o perfil e preencha). Validação proposta: se informado, não pode ser string vazia/só espaços (mesmo padrão de `@NotBlank` já usado em outros DTOs quando o campo é obrigatório) nem exceder 120 caracteres (limite da coluna). Campo pode ser enviado como `null`/omitido para "limpar" o nome já salvo — não há motivo de negócio para impedir isso.

### 5.2 Data de nascimento — opcional, sem regra de negócio associada

Decisão fechada com o Tito: puramente informativo, nenhuma regra de negócio (ex.: idade mínima, conteúdo por faixa etária) depende deste campo hoje. Validação proposta: se informado, deve ser uma data válida no passado (`LocalDate`, não pode ser data futura — validação simples de sanidade, não é uma regra de negócio nova, apenas evita erro de digitação óbvio como ano trocado). Campo pode ser enviado como `null` para limpar uma data já salva.

### 5.3 Foto de perfil — `bytea` no Postgres, limite de 2MB, tipos aceitos, suporte a remoção

- **Armazenamento:** decisão fechada — `bytea` direto em `app_user`, sem storage externo nem volume de disco separado. Aceitável para o estágio atual do produto; trade-off de crescimento do banco registrado como risco conhecido, não bloqueante (seção 10).
- **Limite de tamanho:** decisão fechada — até 2MB, validado no backend antes de persistir (`Content-Length` ou tamanho real do array de bytes lido, o que for mais confiável na implementação — decisão de implementação do Backend Engineer, não altera o contrato). Arquivo maior é rejeitado com erro claro, nenhuma escrita parcial.
- **Tipos aceitos:** `image/jpeg`, `image/png`, `image/webp` — cobre os formatos mais comuns de foto de perfil sem abrir para formatos que não fazem sentido nesse contexto (ex.: SVG, que pode carregar script; GIF animado, que não agrega valor a uma foto de perfil estática). Validado pelo `Content-Type` da parte multipart recebida.
- **Remoção da foto — decisão fechada: sim, suportar `DELETE /api/usuarios/atual/foto`.** Justificativa: é o comportamento simétrico esperado de qualquer upload de foto de perfil (todo usuário que já usou uma rede social espera poder "remover foto" e voltar ao estado sem foto) e o custo de implementação é mínimo — mesmo padrão de update dos dois campos (`foto_perfil`, `foto_perfil_content_type`) para `NULL`, sem lógica adicional. Não suportar isso forçaria o usuário a subir uma imagem em branco como contorno, o que é pior UX pelo mesmo esforço de engenharia.
- **Leitura da foto:** `GET /api/usuarios/atual/foto` retorna os bytes brutos com o `Content-Type` armazenado (`foto_perfil_content_type`), não um DTO JSON — mesmo padrão de servir binário direto, sem base64 (evita overhead de ~33% de payload). Se a conta não tem foto, `404` (ver tabela de erros, seção 6.2).

### 5.4 Estatísticas de uso — endpoint de agregação novo no backend, não composição no frontend

**Decisão: criar `GET /api/usuarios/atual/perfil/estatisticas`, um endpoint novo de agregação no backend**, em vez de o frontend montar a visão combinando múltiplas chamadas aos endpoints existentes de Progress.

**Justificativa:**
- "Quantas vezes acessou algum conteúdo" (contagem de `StudySession` por `domainRef` e geral) **não tem hoje nenhum endpoint que a exponha** — `StudySessionRepository` (`study/infra/StudySessionRepository.java`) hoje não declara nenhum método de consulta além dos herdados de `JpaRepository`, e não existe nenhum controller que liste ou conte sessões. Essa contagem precisa ser implementada de qualquer forma, backend, neste ticket — não é uma composição de dado já exposto.
- "Resultados médios do quiz" e "quantas vezes fez o quiz" por domínio **já existem** (`DomainProgress.pontuacaoQuiz` via `DomainProgressRepository`; contagem de `QuizAttempt` concluídas via o mesmo predicado já usado em `ConsultarHistoricoService`/`QuizAttemptRepository`), mas hoje só são acessíveis por domínio individual (`GET /dominios/{id}/progresso`, `GET /usuarios/{userId}/historico?dominioId=`) — montar a visão "geral + por domínio" no frontend exigiria 1 chamada por domínio (hoje 7 domínios fixos, mas não deveria ser um número hardcoded no frontend) mais uma chamada de resultado geral, um padrão N+1 que só piora à medida que mais domínios forem adicionados.
- Como a contagem de sessões já teria que ser um novo endpoint de qualquer forma, e as demais métricas já existem mas exigem N+1 chamadas para consolidar "geral + por domínio", a opção mais simples é um único endpoint novo que uma um `GROUP BY domain_ref` sobre `StudySession` com os dados já calculados de `DomainProgress`/`QuizAttempt` — sem duplicar a fórmula de cálculo de `pontuacaoQuiz` (que continua sendo calculada e persistida exclusivamente por `RecalcularDomainProgressService`, este ticket só lê o valor já calculado) nem a lógica de "tentativa concluída" (mesmo predicado já usado em `QuizAttemptRepository`/`ConsultarHistoricoService`, reaproveitado, não reescrito).
- Resultado geral agregado entre domínios reaproveita diretamente `ConsultarResultadoGeralService` já existente, sem recalcular a média.

### 5.5 Autenticação e isolamento por conta

Mesmo padrão já usado em `AlterarSenhaService`/`UsuarioController`: todos os endpoints deste ticket resolvem a conta exclusivamente via `CurrentUserProvider` (JWT da requisição), nunca por identificador no corpo ou na URL — não há risco de IDOR porque não existe `{userId}` em nenhuma rota nova (diferente de `GET /usuarios/{userId}/resultado-geral`, que precisa desse parâmetro por compatibilidade de contrato anterior a este ticket).

## 6. Endpoints propostos — dados pessoais

### 6.1 Leitura e edição de nome/nascimento

| Método | Rota | Request | Response (sucesso) | Autenticação |
|---|---|---|---|---|
| `GET` | `/api/usuarios/atual` (estendido) | — | `{ "id": uuid, "nome": string\|null, "email": string, "dataNascimento": "YYYY-MM-DD"\|null, "temFotoPerfil": boolean }` | JWT obrigatório |
| `PUT` | `/api/usuarios/atual/perfil` | `{ "nome": string\|null, "dataNascimento": "YYYY-MM-DD"\|null }` | `{ "id": uuid, "nome": string\|null, "email": string, "dataNascimento": string\|null, "temFotoPerfil": boolean }` | JWT obrigatório |

`UsuarioAtualDto` ganha os dois campos novos (`dataNascimento`, `temFotoPerfil`); `email` continua somente leitura em ambos os endpoints — não existe campo `email` no request de `PUT .../perfil`, então não há como alterá-lo por esta rota (reforça a decisão de escopo, seção 3).

`temFotoPerfil` é um booleano derivado (`foto_perfil IS NOT NULL`), não os bytes — evita que `GET /api/usuarios/atual` fique pesado; o frontend busca a imagem separadamente em `GET /api/usuarios/atual/foto` só quando precisa exibi-la.

**Erros propostos** (`PUT /api/usuarios/atual/perfil`), mesmo padrão `ApiErrorResponse`/`GlobalExceptionHandler`:

| Situação | `erro` | status |
|---|---|---|
| Nome informado é string vazia/só espaços, ou excede 120 caracteres | `REQUISICAO_INVALIDA` (handler de `IllegalArgumentException`, mesmo padrão já usado em Identity) | 400 |
| Data de nascimento em formato inválido (não parseável como `LocalDate`) | `REQUISICAO_INVALIDA` (handler de `MethodArgumentNotValidException`, mesmo padrão de `@Valid` nos demais DTOs) | 400 |
| Data de nascimento no futuro | `REQUISICAO_INVALIDA` | 400 |
| Sem JWT válido | — (401 padrão do filtro de autenticação, nenhum handler novo) | 401 |

### 6.2 Upload, leitura e remoção de foto de perfil

| Método | Rota | Request | Response (sucesso) | Autenticação |
|---|---|---|---|---|
| `POST` | `/api/usuarios/atual/foto` | `multipart/form-data`, campo `arquivo` | `{ "mensagem": "foto de perfil atualizada com sucesso" }` | JWT obrigatório |
| `GET` | `/api/usuarios/atual/foto` | — | bytes da imagem, `Content-Type` = `foto_perfil_content_type` armazenado | JWT obrigatório |
| `DELETE` | `/api/usuarios/atual/foto` | — | `{ "mensagem": "foto de perfil removida com sucesso" }` | JWT obrigatório |

**Erros propostos**, mesmo padrão `ApiErrorResponse`:

| Situação | `erro` | status |
|---|---|---|
| Arquivo maior que 2MB | `ARQUIVO_MUITO_GRANDE` | 400 |
| `Content-Type` do arquivo não está entre `image/jpeg`, `image/png`, `image/webp` | `TIPO_ARQUIVO_NAO_SUPORTADO` | 400 |
| Requisição sem parte `arquivo`, ou parte vazia | `REQUISICAO_INVALIDA` | 400 |
| `GET`/`DELETE .../foto` quando a conta não tem foto salva | `RECURSO_NAO_ENCONTRADO` (reaproveita `RecursoNaoEncontradoException`/handler já existente) | 404 |
| Sem JWT válido | — (401 padrão) | 401 |

`ARQUIVO_MUITO_GRANDE` e `TIPO_ARQUIVO_NAO_SUPORTADO` são exceptions novas (`ArquivoMuitoGrandeException`, `TipoArquivoNaoSuportadoException`), com handlers novos em `GlobalExceptionHandler`, mesmo padrão dos handlers já existentes (`SenhaAtualIncorretaException`, `TokenRecuperacaoInvalidoException`, etc.) — cada uma mapeando para seu próprio código de erro e status.

## 7. Endpoint proposto — estatísticas de uso consolidadas

| Método | Rota | Request | Response (sucesso) | Autenticação |
|---|---|---|---|---|
| `GET` | `/api/usuarios/atual/perfil/estatisticas` | — | ver estrutura abaixo | JWT obrigatório |

```json
{
  "geral": {
    "totalSessoesEstudo": 42,
    "totalTentativasQuiz": 15,
    "resultadoGeralAvaliado": true,
    "pontuacaoGeralMedia": 78.50
  },
  "porDominio": [
    {
      "domainRef": "uuid",
      "nomeDominio": "Sistemas Distribuídos",
      "totalSessoesEstudo": 10,
      "totalTentativasQuiz": 4,
      "volumeMinimoAtingido": true,
      "pontuacaoQuizMedia": 82.00
    }
  ]
}
```

- `geral.resultadoGeralAvaliado`/`pontuacaoGeralMedia` reaproveitam diretamente `ResultadoGeralDto` (`ConsultarResultadoGeralService`, já existente) — mesmo significado de "ainda não avaliado" (`resultadoGeralAvaliado=false`, `pontuacaoGeralMedia=null`) quando nenhum domínio atingiu volume mínimo (AC-09 daquele serviço).
- `porDominio[].pontuacaoQuizMedia`/`volumeMinimoAtingido` vêm de `DomainProgress` (mesmos campos de `DomainProgressDto`), sem recalcular nada.
- `porDominio[].totalTentativasQuiz` é a contagem de `QuizAttempt` concluídas por domínio, mesmo predicado de `ConsultarHistoricoService`/`QuizAttemptRepository` (`findAllConcludedByUserAndDomainOrderByConcluidoEmDesc(...).size()`, ou um `count` dedicado equivalente — decisão de implementação do Backend Engineer).
- `porDominio[].totalSessoesEstudo` é uma contagem nova — `StudySessionRepository` precisa de um método novo (ex.: `countByUserIdAndDomainRef(UUID userId, UUID domainRef)` e `countByUserId(UUID userId)` para o total geral), já que hoje o repositório não expõe nenhuma consulta além das herdadas de `JpaRepository` (seção 5.4).
- `porDominio` inclui todos os domínios existentes (`DomainRepository.findAll()`, já usado em outros pontos do módulo Content), não só os que o usuário já interagiu — domínio sem nenhuma sessão/tentativa aparece com contadores em `0` e `pontuacaoQuizMedia=null`, mesmo espírito de "estado explícito" já usado em `DomainProgressDto`/`ResultadoGeralDto` (nunca omitir silenciosamente, nunca inventar zero como "avaliado").

**Erros propostos:**

| Situação | `erro` | status |
|---|---|---|
| Sem JWT válido | — (401 padrão) | 401 |

Nenhum outro erro é esperado — é um endpoint somente leitura, sem parâmetros de entrada além do JWT.

## 8. Migração de banco (V50)

Próximo número disponível confirmado em `backend/src/main/resources/db/migration/` (mais recente hoje: V49__cria_tabela_token_recuperacao_senha.sql).

```sql
-- V50__estende_app_user_para_perfil.sql
ALTER TABLE app_user
    ADD COLUMN data_nascimento date NULL,
    ADD COLUMN foto_perfil bytea NULL,
    ADD COLUMN foto_perfil_content_type varchar(50) NULL;

ALTER TABLE app_user
    ADD CONSTRAINT ck_app_user_foto_perfil_content_type
        CHECK (foto_perfil_content_type IS NULL
            OR foto_perfil_content_type IN ('image/jpeg', 'image/png', 'image/webp'));

-- Garante consistência entre os dois campos: não existe imagem sem content-type
-- nem content-type sem imagem.
ALTER TABLE app_user
    ADD CONSTRAINT ck_app_user_foto_perfil_consistente
        CHECK ((foto_perfil IS NULL) = (foto_perfil_content_type IS NULL));
```

Todas as colunas são aditivas e `NULL`-able — nenhum backfill necessário, nenhuma migração de dado existente, mesmo padrão já usado em V33 para `nome`/`senha_hash`. Nenhum índice novo é necessário (nenhuma consulta filtra por `data_nascimento` ou `foto_perfil`).

## 9. Frontend

- **Rota nova:** `/perfil`, protegida por `ProtectedRoute`, mesmo padrão já usado nas demais rotas autenticadas (incluindo a proposta de `/conta` em `TICKET-alterar-senha.md` — as duas rotas podem coexistir, ou a de alteração de senha pode ser um link dentro de `/perfil`; decisão de posicionamento fina do Frontend Engineer, não bloqueia este ticket).
- **Seção "Dados pessoais":** formulário com nome (texto), data de nascimento (date picker), e-mail (somente leitura, mesmo estilo visual de campo desabilitado), foto de perfil (preview + input de arquivo + botão "remover foto", visível só quando há foto).
- **Seção "Estatísticas de uso":** bloco de resumo geral (sessões totais, tentativas de quiz totais, pontuação geral média) seguido de uma lista/tabela por domínio, consumindo o endpoint único da seção 7 — sem lógica de agregação no frontend.
- **Estados de erro:** nome inválido, data futura, arquivo grande demais, tipo de arquivo não suportado — mensagens específicas por campo, client-side quando possível (tamanho/tipo do arquivo podem ser checados antes do upload, reduzindo round-trip desnecessário) e sempre confirmadas pelo erro do backend.
- **Estado de sucesso:** atualização de nome/nascimento e de foto são ações independentes (chamadas de API separadas, seção 6), cada uma com sua própria confirmação visual — não é necessário salvar tudo em uma única submissão.

## 10. Critérios de aceite (Given/When/Then)

**AC-01 — Editar nome com sucesso**
Dado um usuário autenticado sem nome preenchido,
Quando ele informa um nome válido e envia `PUT /api/usuarios/atual/perfil`,
Então a API responde com sucesso, e `GET /api/usuarios/atual` passa a retornar o nome informado.

**AC-02 — Editar nome com valor vazio**
Dado um usuário autenticado,
Quando ele envia `PUT /api/usuarios/atual/perfil` com `nome` como string vazia/só espaços,
Então a API rejeita com `REQUISICAO_INVALIDA`, e o nome anterior não é alterado.

**AC-03 — Editar e limpar data de nascimento**
Dado um usuário autenticado sem data de nascimento preenchida,
Quando ele informa uma data de nascimento válida no passado e depois envia novamente `PUT /api/usuarios/atual/perfil` com `dataNascimento: null`,
Então a primeira requisição salva a data e a segunda a remove — `GET /api/usuarios/atual` reflete `dataNascimento: null` ao final.

**AC-04 — Editar data de nascimento com data futura**
Dado um usuário autenticado,
Quando ele envia `PUT /api/usuarios/atual/perfil` com `dataNascimento` no futuro,
Então a API rejeita com `REQUISICAO_INVALIDA`, e a data anterior não é alterada.

**AC-05 — E-mail não é editável**
Dado um usuário autenticado,
Quando ele consulta `GET /api/usuarios/atual`,
Então o e-mail retornado é o mesmo da conta, e nenhum endpoint deste ticket aceita um campo `email` no corpo da requisição para alterá-lo.

**AC-06 — Upload de foto válida**
Dado um usuário autenticado sem foto de perfil,
Quando ele envia `POST /api/usuarios/atual/foto` com um arquivo `image/png` de 500KB,
Então a API responde com sucesso, `GET /api/usuarios/atual` passa a retornar `temFotoPerfil: true`, e `GET /api/usuarios/atual/foto` retorna os bytes da imagem com `Content-Type: image/png`.

**AC-07 — Upload de foto maior que o limite**
Dado um usuário autenticado,
Quando ele envia `POST /api/usuarios/atual/foto` com um arquivo de 3MB,
Então a API rejeita com `ARQUIVO_MUITO_GRANDE`, e nenhuma foto é persistida (se já havia uma foto anterior, ela permanece inalterada).

**AC-08 — Upload de tipo de arquivo não aceito**
Dado um usuário autenticado,
Quando ele envia `POST /api/usuarios/atual/foto` com um arquivo `image/gif`,
Então a API rejeita com `TIPO_ARQUIVO_NAO_SUPORTADO`, e nenhuma foto é persistida.

**AC-09 — Remover foto de perfil**
Dado um usuário autenticado com uma foto de perfil já salva (AC-06),
Quando ele envia `DELETE /api/usuarios/atual/foto`,
Então a API responde com sucesso, `GET /api/usuarios/atual` passa a retornar `temFotoPerfil: false`, e `GET /api/usuarios/atual/foto` passa a responder `RECURSO_NAO_ENCONTRADO` (404).

**AC-10 — Remover foto quando não há foto salva**
Dado um usuário autenticado sem foto de perfil,
Quando ele envia `DELETE /api/usuarios/atual/foto`,
Então a API rejeita com `RECURSO_NAO_ENCONTRADO` (404).

**AC-11 — Leitura das estatísticas consolidadas (geral e por domínio)**
Dado um usuário autenticado com sessões de estudo e tentativas de quiz concluídas em mais de um domínio,
Quando ele consulta `GET /api/usuarios/atual/perfil/estatisticas`,
Então a API responde com o bloco `geral` refletindo os totais agregados de todos os domínios (mesmo valor de `ConsultarResultadoGeralService` para pontuação geral), e o bloco `porDominio` com um item por domínio existente no sistema, cada um com suas próprias contagens de sessões e tentativas de quiz.

**AC-12 — Estatísticas para usuário sem nenhuma atividade**
Dado um usuário autenticado recém-cadastrado, sem nenhuma sessão de estudo ou tentativa de quiz,
Quando ele consulta `GET /api/usuarios/atual/perfil/estatisticas`,
Então a API responde com sucesso, `geral.totalSessoesEstudo`/`totalTentativasQuiz` em `0`, `geral.resultadoGeralAvaliado: false`, `geral.pontuacaoGeralMedia: null`, e `porDominio` com todos os domínios existentes, cada um com contadores em `0` e `pontuacaoQuizMedia: null`.

**AC-13 — Estatísticas não misturam dados de outra conta**
Dado dois usuários distintos autenticados (contas A e B), cada um com atividade própria,
Quando o usuário da conta A consulta `GET /api/usuarios/atual/perfil/estatisticas`,
Então os totais retornados refletem exclusivamente a atividade da conta A — a conta consultada é sempre resolvida pelo JWT da requisição (`CurrentUserProvider`), nunca por um identificador na URL ou no corpo.

**AC-14 — Acesso sem autenticação**
Dado uma requisição sem JWT válido no header `Authorization`,
Quando ela chega em qualquer um dos endpoints deste ticket (`GET/PUT .../perfil`, `POST/GET/DELETE .../foto`, `GET .../perfil/estatisticas`),
Então a API responde `401 Unauthorized`, mesmo comportamento padrão já aplicado a qualquer rota protegida.

## 11. Riscos e perguntas em aberto

- **Risco — crescimento do banco por fotos em `bytea`.** Decisão consciente do Tito (seção 5.3): aceitável no estágio atual do produto. Se o volume de usuários/fotos crescer significativamente, migrar para storage externo (S3 ou equivalente) é um trabalho futuro razoável, mas não está no escopo deste ticket. Mitigado parcialmente pelo limite de 2MB por arquivo.
- **Risco — leitura de `GET /api/usuarios/atual` fica mais pesada se `temFotoPerfil` for calculado ingenuamente.** Mitigado por já ser um booleano derivado de `foto_perfil IS NOT NULL` (não carrega os bytes nessa consulta) — decisão de implementação do Backend Engineer deve evitar trazer a coluna `bytea` inteira só para checar nulidade (ex.: projeção específica ou consulta separada, se o ORM não otimizar isso automaticamente).
- **Nota (fora de escopo, não bloqueia):** compressão/redimensionamento de imagem no upload (para reduzir o tamanho armazenado) não foi solicitado; pode ser considerado em iteração futura se o crescimento do banco (risco acima) se tornar um problema real.
- **Nota (fora de escopo, não bloqueia):** cache/CDN para servir a foto de perfil não foi solicitado; `GET /api/usuarios/atual/foto` serve diretamente do Postgres a cada requisição — aceitável para o volume atual, revisitar se necessário.

---

## 12. Retorno esperado deste ticket

- **Objetivo:** fechar duas lacunas hoje inexistentes — edição de dados pessoais (nome, nascimento, foto) e uma visão consolidada de estatísticas de uso — através de endpoints novos em `UsuarioController` (mais um controller/service novo de estatísticas), reaproveitando `CurrentUserProvider`, `DomainProgressRepository`, `QuizAttemptRepository` e `ConsultarResultadoGeralService` já existentes.
- **Escopo:** migração V50 (três colunas novas em `app_user`); dois endpoints de dados pessoais (`GET`/`PUT /api/usuarios/atual/perfil`... na prática `GET /api/usuarios/atual` estendido + `PUT` novo); três endpoints de foto (`POST`/`GET`/`DELETE /api/usuarios/atual/foto`); um endpoint novo de agregação (`GET /api/usuarios/atual/perfil/estatisticas`); uma rota e página novas de frontend (`/perfil`), protegida por `ProtectedRoute`.
- **Restrições:** não introduz nenhum tracking novo de uso; não altera fluxo de alteração de e-mail ou senha; não introduz storage externo para a foto.
- **Critério de conclusão:** Backend consegue implementar os endpoints a partir das seções 5–8 sem ambiguidade; DBA consegue aplicar a migração da seção 8 diretamente; Frontend consegue implementar a página a partir da seção 9; critérios de aceite da seção 10 são verificáveis assim que implementado.
- **Bloqueios:** nenhum bloqueio para implementação imediata.
