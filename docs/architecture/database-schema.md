# Schema do banco de dados — ScaleUp (MVP)

**Status:** proposta pronta para implementação (próximo elo: Backend Engineer).
**Origem:** `docs/product/tickets/TICKET-content-database.md` (módulo Content) e `docs/architecture/initial-architecture.md` (Study, Assessment, Progress, Identity).
**Migrações:** `backend/src/main/resources/db/migration/V1__habilita_extensoes.sql` até `V12__cria_tabela_domain_progress.sql`, no formato Flyway. Todas as 12 migrações foram executadas de ponta a ponta contra um Postgres 16 real (container Docker descartável usado só para validação), incluindo cenários que exercitam os triggers e constraints descritos abaixo — não é uma leitura só de sintaxe.

---

## 1. Padrão de chave primária

**Decisão:** `uuid` gerado por `gen_random_uuid()` (extensão `pgcrypto`, habilitada em `V1`) em **todas** as tabelas do projeto, sem exceção.

**Por quê:**
- O conteúdo dos 7 domínios é produzido por **7 tickets em paralelo** (ver ticket mestre). Com `bigint identity`, qualquer script de seed rodando em paralelo ou fora de ordem exigiria coordenação de sequência; com `uuid`, cada gerador de seed cria IDs sem coordenação central.
- Seeds continuam **reproduzíveis** apesar do UUID ser não sequencial: a idempotência do seed deve usar a chave natural de cada entidade como alvo de `ON CONFLICT` (ex.: `domain.slug`, `concept(domain_ref, titulo)`, `question(domain_ref, enunciado)`), não o UUID em si. Isso já está garantido por constraints `UNIQUE` nessas colunas (ver seção 3).
- IDs não sequenciais não vazam contagem de linhas (ex.: quantos usuários existem) por inspeção de URL/ID.

**Trade-off aceito:** UUID ocupa mais espaço em índice que `bigint` (16 bytes vs 8) e é menos legível em debug manual. Irrelevante no volume esperado do MVP (dezenas de milhares de linhas, não milhões).

---

## 2. Visão geral por módulo

```text
Content
  Domain 1───N Concept 1───N Slide
  Domain 1───N Flashcard (N───0/1 Concept)
  Domain 1───N Question 1───4 QuestionAlternative (N───0/1 Concept)

Identity
  AppUser

Study
  AppUser 1───N StudySession (1 Domain)
  StudySession 1───N FlashcardReview (1 Flashcard)

Assessment
  StudySession 1───N QuizAttempt (mesmo Domain da sessão)
  QuizAttempt 1───N Answer (1 Question, 1 QuestionAlternative daquela Question)

Progress
  AppUser + Domain ──1:1── DomainProgress (1 NivelReferencia)
  ComponentePeso (config, sem FK — pesos por nome de componente)
  NivelReferencia (config, sem FK — thresholds dos 12 níveis)
```

Todas as tabelas vivem no schema `public` de um único banco Postgres. **Não** há separação por schema por módulo: a fronteira entre módulos (Content/Study/Assessment/Progress/Identity) é de responsabilidade da aplicação (repositórios por módulo, sem acesso direto a tabela de outro módulo), não do banco — coerente com a arquitetura de monólito modular já decidida, que evita introduzir complexidade de schemas cruzados sem necessidade real neste estágio.

---

## 3. Módulo Content

### Domain (`domain`)
`id, slug UNIQUE, nome, descricao, content_version, status_revisao, criado_em, atualizado_em`

Os 7 domínios do MVP são **dados**, nunca hardcode — a tabela é criada vazia pela migração; a carga dos 7 registros é responsabilidade do seed do Backend Engineer.

### Concept (`concept`)
`id, domain_ref → domain, titulo, resumo, content_version, status_revisao, criado_em, atualizado_em`

`UNIQUE (id, domain_ref)` existe **só** para suportar as FKs compostas de Slide/Flashcard/Question (ver abaixo) — não é uma regra de negócio isolada.
`UNIQUE (domain_ref, titulo)` evita concepts duplicados dentro do mesmo domínio (chave natural útil para seed idempotente).

### Slide (`slide`)
`id, concept_ref NOT NULL, domain_ref NOT NULL, titulo, conteudo, ordem, content_version, status_revisao, criado_em, atualizado_em`

- `concept_ref` é **obrigatório** — decisão do PM, restrição herdada do ticket.
- `domain_ref` é mantido explícito na própria linha (recomendação do ticket, para evitar join com `concept` em toda consulta), mas sua consistência com o `domain_ref` do `Concept` pai é garantida por **FK composta**: `FOREIGN KEY (concept_ref, domain_ref) REFERENCES concept (id, domain_ref)`. Isso torna estruturalmente impossível um Slide apontar para um Concept de um domínio e carregar `domain_ref` de outro — testado (ver seção 8).
- **`ordem` única e sequencial dentro do Concept:** a unicidade é garantida por `UNIQUE (concept_ref, ordem)` (constraint de banco). A **ausência de lacunas** (1, 2, 3... sem pular números) **não** é garantida pelo banco — seria necessário um trigger de reindexação ou uma constraint de agregação bem mais cara para pouco ganho real, já que a aplicação (seed e futura tela de admin de conteúdo) é a única escritora de slides e pode gerar a sequência corretamente na inserção. Decisão: unicidade = banco, sequência sem lacunas = validação de aplicação/QA (já coberta pelos critérios de aceite do ticket mestre).

### Flashcard (`flashcard`)
`id, domain_ref NOT NULL, concept_ref NULL, frente, verso, dificuldade, content_version, status_revisao, criado_em, atualizado_em`

`dificuldade` é `CHECK (dificuldade IN ('facil','media','dificil'))` — não é tabela de referência à parte porque é um conjunto pequeno, estável e sem atributos próprios (ver Open Question resolvida abaixo sobre por que isso é diferente do caso dos níveis de proficiência).

### Question + QuestionAlternative (`question`, `question_alternative`)
`question`: `id, domain_ref NOT NULL, concept_ref NULL, enunciado, explicacao, dificuldade, content_version, status_revisao, criado_em, atualizado_em`.
`UNIQUE (domain_ref, enunciado)` impede enunciados duplicados no mesmo domínio (critério de aceite do QA).

`question_alternative`: `id, question_id → question, texto, correta, criado_em`. Não tem `content_version`/`status_revisao` próprios — é parte da versão da `Question` à qual pertence, não uma entidade versionada independente.

**Mecanismo de "exatamente 4 alternativas, exatamente 1 correta"** — decisão: **banco, com dois mecanismos complementares**, não confiar só na aplicação:

1. `CREATE UNIQUE INDEX ux_question_alternative_unica_correta ON question_alternative (question_id) WHERE correta;` — índice único parcial, **imediato**, garante que nunca existem 2 linhas com `correta = true` para a mesma Question. Sozinho não garante "pelo menos 1" nem "exatamente 4".
2. `CONSTRAINT TRIGGER trg_verificar_alternativas_question` — trigger de constraint **adiada** (`DEFERRABLE INITIALLY DEFERRED`), disparada em `INSERT/UPDATE/DELETE` de `question_alternative`, que ao final da transação conta as alternativas da Question afetada e falha se não forem exatamente 4 (ou se não houver exatamente 1 correta). É adiada porque a aplicação insere a Question e suas 4 alternativas em statements separados dentro da mesma transação — validar a cada `INSERT` individual quebraria esse fluxo. Se a própria Question estiver sendo removida (o `ON DELETE CASCADE` já apagou as alternativas), a checagem é pulada — não há mais Question para exigir 4 alternativas.

**Requisito explícito para o Backend Engineer:** inserir a Question e suas 4 alternativas **na mesma transação**. Se isso não acontecer, o `COMMIT` falha com uma mensagem de erro explicando exatamente quantas alternativas/corretas foram encontradas.

Ambos os mecanismos foram exercitados manualmente contra Postgres real durante esta análise (inserção válida, inserção com 3 alternativas, inserção com 2 corretas, edição de Question já publicada, deleção de Question em rascunho) — ver seção 8.

---

## 4. Resolução do OPEN QUESTION-003 (`concept_ref` opcional em Flashcard/Question)

**Decisão do DBA (dentro da autorização do ticket mestre para decidir):** `concept_ref` permanece **opcional (NULL permitido)** em `flashcard` e `question`, com FK composta `(concept_ref, domain_ref) → concept (id, domain_ref)` garantindo que, **quando presente**, o `concept_ref` aponta para um Concept do mesmo domínio informado (a FK composta não é validada quando `concept_ref IS NULL` — comportamento padrão `MATCH SIMPLE` do Postgres).

**Justificativa:**
- Nenhum critério de aceite do QA no ticket mestre exige `concept_ref` obrigatório em Flashcard/Question — todos os critérios de rastreabilidade usam `domain_ref` (direto ou via Concept, no caso específico de Slide).
- O próprio ticket já resolveu a dúvida de "categoria para força/fraqueza" a favor de `Domain` (via `DomainProgress`), não `Concept` — o único uso remanescente de `concept_ref` em Flashcard/Question é diagnóstico futuro de sub-tópicos, ainda não implementado em nenhum módulo.
- Tornar obrigatório agora exigiria que **todo** item de conteúdo dos 7 tickets de domínio (produção paralela, já em andamento/planejada) tivesse um Concept mapeado por item, aumentando o custo de autoria sem um consumidor funcional dessa informação ainda.
- Reverter depois (tornar `NOT NULL`) é uma migração aditiva segura desde que os dados existentes já tenham `concept_ref` preenchido — não é uma decisão irreversível.

**Não escala de volta ao PM como bloqueio** — o ticket já delegou essa decisão ao DBA. Fica registrado aqui como decisão tomada, não como pendência.

---

## 5. Imutabilidade de conteúdo publicado

**Decisão:** além da convenção "não faça UPDATE em conteúdo publicado", o banco **impõe** essa regra via trigger.

`bloquear_alteracao_conteudo_publicado()` (aplicado a `domain`, `concept`, `slide`, `flashcard`, `question`) bloqueia **qualquer** `UPDATE` ou `DELETE` em uma linha cujo `status_revisao` já é `revisado_aprovado`, lançando exceção. Enquanto `status_revisao = 'rascunho'`, a linha pode ser editada livremente, inclusive a própria transição para `revisado_aprovado`. `bloquear_alteracao_alternativa_publicada()` aplica a mesma regra a `question_alternative`, olhando o `status_revisao` da `Question` pai (a alternativa não tem status próprio).

**Por que trigger e não só disciplina de aplicação:** a arquitetura é explícita — "respostas devem guardar referência à versão do conteúdo usada, evitando que uma alteração posterior reescreva o histórico". Se o histórico de respostas (`answer.question_content_version`) depende de o conteúdo publicado nunca mudar sob o mesmo `id`, essa é uma garantia de integridade forte demais para deixar só na aplicação — um bug ou uma migração de dados mal feita no futuro poderia silenciosamente invalidar respostas históricas.

**O que isso NÃO faz:** não impede criar uma **nova versão** (nova linha, novo `content_version`) — isso é sempre um `INSERT`, nunca bloqueado. Também não impede `DELETE`/`UPDATE` em conteúdo ainda em rascunho, para não atrapalhar o fluxo normal de autoria/revisão antes da publicação.

Testado manualmente: publicar uma Question e tentar alterar seu enunciado falha; tentar editar uma alternativa de Question já publicada falha; apagar uma Question ainda em rascunho (com suas 4 alternativas) funciona sem disparar a checagem de "exatamente 4 alternativas" (porque a Question já não existe mais para exigir isso).

**Nota sobre `content_version` como identificador de lote:** conforme o ticket mestre, `content_version` é um identificador de **lote** compartilhado por todos os itens publicados juntos (ex.: todos `v1`), não um contador incremental por entidade. O schema não impõe (via constraint) que todas as linhas de uma mesma migração de conteúdo compartilhem o mesmo valor — isso é responsabilidade do processo de seed/publicação, já coberto pelos critérios de aceite do QA no ticket mestre.

---

## 6. Módulos Study, Assessment, Progress e Identity

Estes módulos não têm ticket de detalhamento de campos — só a descrição narrativa em `initial-architecture.md`. Os campos abaixo foram derivados dos requisitos funcionais 5–10 e da seção "Dados e instrumentação" do PRD.

### Identity — `app_user`
`id, email UNIQUE, nome, criado_em, atualizado_em`. Sem campo de senha/credencial: o PRD assume usuário único/local no MVP e a arquitetura trata autenticação real como decisão futura. Adicionar autenticação depois é uma migração aditiva (`ALTER TABLE ADD COLUMN ... NULL`), sem impacto retroativo.

### Study — `study_session`, `flashcard_review`
`study_session`: `id, user_id → app_user, domain_ref → domain, status, iniciada_em, concluida_em`. `UNIQUE (id, domain_ref)` existe só para suportar a FK composta de `quiz_attempt` (mesmo mecanismo usado em Slide/Concept).

`flashcard_review`: `id, study_session_id → study_session (CASCADE), flashcard_id → flashcard, flashcard_content_version, resultado_autoavaliacao ('lembrei'|'nao_lembrei'), confianca_declarada (1-5, nullable), revisado_em`.

`flashcard_content_version` captura a versão do Flashcard no momento da revisão, pelo mesmo princípio de rastreabilidade aplicado a `answer.question_content_version` — mesmo que o Flashcard nunca seja de fato editado após publicado (garantido pela seção 5), armazenar o snapshot deixa a evidência autocontida e auditável sem depender de o Flashcard continuar existindo com aquele conteúdo específico no futuro.

`resultado_autoavaliacao` e `confianca_declarada` são minha interpretação de "revisar flashcards" a partir da seção "Dados e instrumentação" do PRD ("confiança declarada" é mencionada de forma geral, aplicável a qualquer atividade). **Isto não está explicitamente especificado no PRD para flashcards** — é uma inferência razoável, mas se o PM tiver um formato diferente em mente (ex.: escala de dificuldade percebida em vez de lembrei/não lembrei), é uma migração aditiva simples de ajustar.

### Assessment — `quiz_attempt`, `answer`
`quiz_attempt`: `id, study_session_id, domain_ref, status, total_questoes, pontuacao_obtida, iniciado_em, concluido_em`. `domain_ref` é denormalizado a partir da sessão por conveniência de consulta, mas é garantido consistente via FK composta `(study_session_id, domain_ref) → study_session (id, domain_ref)`.

`answer`: `id, quiz_attempt_id → quiz_attempt (CASCADE), question_id → question, question_content_version, alternativa_selecionada_id, correta, confianca_declarada, respondido_em`. A FK composta `(alternativa_selecionada_id, question_id) → question_alternative (id, question_id)` garante, só com o banco, que a alternativa marcada como resposta pertence exatamente à Question respondida — testado explicitamente (seção 8): uma tentativa de gravar uma `answer` com uma alternativa que pertence a outra Question falha na FK, não silenciosamente.

`UNIQUE (quiz_attempt_id, question_id)` impede responder a mesma questão duas vezes na mesma tentativa.

### Progress — `nivel_referencia`, `componente_peso`, `domain_progress`

**`nivel_referencia`** (12 linhas, uma por nível) e **`componente_peso`** (5 linhas, uma por componente de pontuação) existem porque o PRD exige explicitamente que thresholds e pesos sejam **configuráveis, não codificados em múltiplas telas ou regras duplicadas**. Tratar os 12 níveis e os 5 pesos como dados (mesmo princípio já aplicado a `Domain`) é a forma mais direta de cumprir esse requisito sem duplicar números mágicos em código de aplicação e frontend.

- `componente_peso` já é seedado com os valores exatos do PRD (quiz 0.40, flashcards 0.25, questões novas 0.20, consistência 0.10, calibração 0.05) — **não são placeholder**, vêm do requisito funcional 7. A soma (1.000) não é validada por constraint de banco (validar soma de um subconjunto de linhas é uma constraint de agregação cara para um requisito que muda raramente); recomendo ao Backend Engineer um teste automatizado que valide `SUM(peso) = 1` sempre que a tabela for alterada.
- `nivel_referencia` **é seedada com thresholds placeholder (faixas de largura igual, ~8.33 pontos cada)** — **isto é uma pendência para o PM**, não uma decisão de banco. O PRD define os 12 nomes de nível mas não os cortes de pontuação entre eles. Os valores inseridos pela migração `V11` servem só para o sistema funcionar de ponta a ponta; devem ser ajustados via `UPDATE` nessa tabela assim que o PM definir os cortes reais — nunca via nova migração destrutiva ou hardcode em código.

**`domain_progress`**: `id, user_id, domain_ref (UNIQUE juntos), pontuacao_quiz, pontuacao_flashcards, pontuacao_questoes_novas, pontuacao_consistencia, pontuacao_calibracao, pontuacao_geral, nivel_atual_id → nivel_referencia, volume_evidencia_quiz, volume_evidencia_flashcard, volume_minimo_atingido, ultima_avaliacao_em, atualizado_em`.

**Por que `domain_progress` não é uma tabela de histórico:** a arquitetura descreve `DomainProgress` no singular — "mantém pontuação por componente, nível atual, volume mínimo e **data da última avaliação**" (data no singular, não uma lista de avaliações). Um registro por usuário/domínio, recalculado deterministicamente a partir das evidências brutas (`study_session`, `quiz_attempt`, `answer`, `flashcard_review`), como a própria arquitetura pede: "a classificação pode ser recalculada de forma determinística a partir das evidências; não armazenar somente um valor sem origem explicável".

O requisito funcional 10 ("consultar histórico recente de sessões e **evolução por domínio**") é satisfeito de duas formas sem precisar de uma tabela de snapshot de progresso:
1. Histórico de sessões: consulta direta em `study_session`/`quiz_attempt` por `user_id`/`domain_ref`, ordenado por data (índice `ix_study_session_user_domain` já cobre isso).
2. Evolução do domínio ao longo do tempo: cada `quiz_attempt` já carrega `pontuacao_obtida` + `concluido_em`, o que já dá uma série temporal suficiente para um gráfico de evolução sem duplicar o dado em outra tabela.

Se, na prática, o produto precisar de snapshots do **`pontuacao_geral` agregado** (não só de tentativas de quiz individuais) ao longo do tempo, isso é uma tabela `domain_progress_snapshot` (append-only) adicionável depois de forma aditiva — não foi criada agora porque a arquitetura não a descreve e não há um consumidor definido para ela ainda (evitar estrutura para necessidade hipotética).

**Resultado geral (req. funcional 9 — média ponderada dos domínios):** não tem tabela própria. É uma agregação em tempo de consulta sobre as linhas de `domain_progress` de um usuário (média simples no MVP, já que "os domínios têm peso igual"). Não há necessidade de persistir um valor derivável trivialmente a cada consulta.

**Fórmula de consistência:** o PRD já registra como risco aberto que "a fórmula de consistência e estabilidade precisa de especificação técnica antes da implementação". O schema **não** tenta adivinhar essa fórmula — `pontuacao_consistencia` existe como um componente de pontuação genérico (0–100), alimentado pela lógica de aplicação que ainda será definida pelo PM/Assessment, usando os timestamps já disponíveis em `study_session`/`quiz_attempt`/`flashcard_review` como matéria-prima. Nenhuma coluna específica de "streak" ou "dias consecutivos" foi criada, para não fixar no schema uma fórmula que ainda não foi decidida.

---

## 7. Tipos e convenções

- **Datas/horas:** `timestamptz` em toda parte (nunca `timestamp` sem timezone), padrão idiomático do Postgres para evitar ambiguidade de fuso.
- **Enums pequenos e estáveis** (`status_revisao`, `dificuldade`, `status` de sessão/tentativa, `resultado_autoavaliacao`): `varchar` + `CHECK`, não `CREATE TYPE ... AS ENUM`. Motivo: alterar um `CHECK` é uma migração aditiva trivial (`DROP CONSTRAINT` + `ADD CONSTRAINT` numa nova migração); evoluir um `enum` nativo do Postgres tem mais atrito histórico (não dá para remover valor, `ALTER TYPE ... ADD VALUE` tem restrições dentro de transação em versões mais antigas do Postgres).
- **Config numérica que muda por decisão de produto** (níveis, pesos): tabela de dados, não `CHECK`/enum/constante — só assim fica de fato "configurável" sem depender de deploy de código.
- **Textos obrigatórios não vazios:** `CHECK (length(btrim(coluna)) > 0)` em vez de confiar só em `NOT NULL` — string vazia (`''`) passa por `NOT NULL` mas não representa um valor de negócio válido para título, enunciado, etc.
- **FKs compostas para herdar consistência do pai:** usadas em `slide`, `flashcard`, `question` (contra `concept`), `quiz_attempt` (contra `study_session`) e `answer` (contra `question_alternative`) sempre que uma coluna denormalizada (`domain_ref` numa tabela filha) precisa necessariamente bater com o valor do registro pai. Preferido a um trigger de validação customizado: é declarativo, mais barato de manter e o otimizador do Postgres já sabe lidar com ele.

---

## 8. Evidência de validação

As 12 migrações foram aplicadas em sequência contra um Postgres 16 real (container Docker temporário, descartado ao final desta análise) e os seguintes cenários foram exercitados com dados reais, não apenas revisados visualmente:

| Cenário | Resultado esperado | Resultado observado |
|---|---|---|
| Slide com `domain_ref` que não bate com o `domain_ref` do Concept pai | Falha na FK composta | Falhou (`fk_slide_concept_domain`) |
| Slide com `domain_ref` consistente | Sucesso | Sucesso |
| Dois Slides com mesma `ordem` no mesmo Concept | Falha na constraint única | Falhou (`uq_slide_concept_ordem`) |
| Question + 4 alternativas (1 correta) na mesma transação | Sucesso | Sucesso |
| Question + apenas 3 alternativas | Falha no commit (trigger adiado) | Falhou com mensagem explicando a contagem |
| Question com 2 alternativas marcadas como corretas | Falha imediata (índice único parcial) | Falhou (`ux_question_alternative_unica_correta`) |
| `UPDATE` em Question já `revisado_aprovado` | Falha (trigger de imutabilidade) | Falhou |
| `UPDATE` em alternativa de Question já `revisado_aprovado` | Falha (trigger de imutabilidade) | Falhou |
| `DELETE` de Question ainda em rascunho, com suas 4 alternativas | Sucesso, sem disparar erro de contagem | Sucesso |
| `Answer` apontando uma alternativa que pertence a outra Question | Falha na FK composta | Falhou (`fk_answer_alternativa_question`) |
| `Answer` com Question e alternativa consistentes | Sucesso | Sucesso |

---

## 9. Rastreamento das restrições do handoff

| Restrição do ticket | Como foi atendida |
|---|---|
| 7 domínios como dados, nunca hardcode | Tabela `domain`, sem enum/valores fixos no schema |
| `content_version` obrigatório e imutável após publicação nas 5 entidades | Coluna `NOT NULL` + trigger de imutabilidade (seção 5) |
| `status_revisao` obrigatório e filtrável | Coluna `NOT NULL` + `CHECK` + índice em cada tabela de conteúdo |
| `slide.concept_ref` obrigatório | `NOT NULL` |
| `flashcard.concept_ref`/`question.concept_ref` — OPEN QUESTION-003 | Resolvida: opcional, com FK composta quando presente (seção 4) |
| `slide.ordem` único e sequencial no Concept | Unicidade por constraint; sequência sem lacunas por aplicação (seção 3) |
| Question com exatamente 4 alternativas, exatamente 1 correta | Índice único parcial + trigger de constraint adiada (seção 3) |
| Migrações versionadas e aditivas | 12 arquivos `V1`...`V12`, nenhum `DROP`/alteração destrutiva |
| Convenções idiomáticas Postgres | `uuid` + `timestamptz` em todo o schema (seção 1 e 7) |
| Não decidir prioridade de negócio/regra ambígua sozinho | Thresholds de nível marcados como placeholder e devolvidos ao PM (seção 6); fórmula de consistência deliberadamente não modelada em detalhe (seção 6) |

---

## 10. Pendências e notas para os próximos elos

**Para o PM:**
- **Thresholds reais dos 12 níveis** (`nivel_referencia.pontuacao_minima/maxima`) — hoje são um placeholder de faixas iguais. Preciso dos cortes reais para atualizar via `UPDATE` (não é migração de schema).
- **Formato de autoavaliação de Flashcard** (`flashcard_review.resultado_autoavaliacao`) — modelei como `'lembrei'|'nao_lembrei'` por inferência da seção "Dados e instrumentação" do PRD; confirmar se é esse o formato desejado ou se há uma escala diferente em mente.
- OPEN QUESTION-004 (tamanho de sessão de quiz) segue em aberto, como já indicado no ticket — não bloqueia este schema; se a sessão usar poucas questões por domínio, o volume mínimo de conteúdo (18 questões/domínio) pode precisar ser revisto, mas isso é decisão de conteúdo/produto, não de schema.

**Para o Backend Engineer:**
- Adicionar a dependência do Flyway ao `pom.xml` e configurar `spring.flyway.*`/datasource no `application.yml` (fora do meu escopo, mas necessário para as migrações rodarem).
- **Inserir Question + suas 4 alternativas na mesma transação** — o trigger de constraint adiada depende disso; inserir alternativas em transações separadas da Question vai falhar no commit da própria transação das alternativas.
- **Nunca fazer `UPDATE` em conteúdo com `status_revisao = 'revisado_aprovado'`** — o banco vai rejeitar; para alterar, criar uma nova linha com novo `content_version`.
- Seed dos 7 domínios, conceitos, slides, flashcards e questões é responsabilidade do Backend Engineer (não populado por esta migração).
- Ao publicar conteúdo (`status_revisao: rascunho → revisado_aprovado`), lembrar que essa é a **única** transição de UPDATE ainda permitida numa linha — qualquer outra alteração simultânea nesse mesmo `UPDATE` também será persistida (o trigger só bloqueia updates em linhas que **já estavam** aprovadas, não valida o conteúdo do `UPDATE` de transição). Recomendo que a aplicação trate a publicação como um `UPDATE` que só toca a coluna `status_revisao`, nunca junto de outras mudanças de conteúdo.
- Testar a soma dos pesos em `componente_peso` (`SUM(peso) = 1`) como parte da suíte de testes, já que o banco não valida isso.
