# TICKET — Módulo Assessment/Progress (quiz, pontuação, níveis, evolução)

**Status:** pronto para Engenharia, com 2 Open Questions explícitas pendentes de confirmação do Tito antes de iniciar a implementação (ver seção 9).
**Origem:** `docs/product/PRD-mvp.md` (requisitos funcionais 1, 5–10, seção "Regras de classificação"), `docs/architecture/initial-architecture.md` (módulos Study/Assessment/Progress), `docs/architecture/database-schema.md` e migrações `V8`–`V12` (schema físico já validado pelo DBA contra Postgres real — **não é reaberto por este ticket**).
**Depende de:** módulo Content já entregue (`Domain`, `Concept`, `Question`, `QuestionAlternative`, `Flashcard` — `backend/src/main/java/com/scaleup/studyplatform/content/`), cuja API de leitura (`DominioController`) já garante, por decisão de arquitetura, que `AlternativaDto.correta` e a `explicacao` da `Question` nunca são expostas antes da submissão do usuário. Este ticket herda e reforça essa regra — não a reabre.

---

## 1. Objetivo

Definir as regras de negócio, o comportamento esperado da API (em alto nível) e os critérios de aceite para: submissão de quiz, registro de revisão de flashcard, cálculo de pontuação por domínio (5 componentes), conversão em um dos 12 níveis, resultado geral do usuário e consulta de histórico/evolução.

## 2. Escopo

**Dentro:**
- Regras de negócio de submissão de quiz e revisão de flashcard.
- Fórmulas dos 5 componentes de pontuação e da agregação em `pontuacao_geral` do domínio.
- Regra de conversão pontuação → nível (12 níveis) e regra de anti-oscilação (volume mínimo de evidência).
- Regra de resultado geral do usuário (agregação entre domínios).
- Requisitos de consulta de histórico e evolução.
- Critérios de aceite Given/When/Then.
- Endpoints esperados, em alto nível (contrato detalhado é do Backend Engineer).

**Fora:**
- Desenho de schema — já entregue e validado pelo DBA (`V8`–`V12`). Lacunas reais encontradas são registradas como pendência ao DBA (seção 8), não resolvidas aqui.
- Contrato técnico detalhado de API (payloads, status HTTP exatos, DTOs).
- Algoritmo de seleção adaptativa de questões, repetição espaçada avançada ou qualquer coisa listada como não objetivo do MVP no PRD.
- Autenticação real (fora de escopo do MVP, conforme PRD).

## 3. Restrições já tomadas, que este ticket respeita

- A resposta correta e a explicação de uma `Question` **nunca** podem ser reveladas antes da submissão do quiz — regra de arquitetura já implementada no módulo Content, este ticket a estende para a submissão em si (a explicação só aparece na resposta da submissão, nunca antes).
- O schema físico de `study_session`, `flashcard_review`, `quiz_attempt`, `answer`, `nivel_referencia`, `componente_peso` e `domain_progress` já existe (`V9`–`V12`) e não deve ser alterado por este ticket, exceto pela lacuna registrada na seção 8.
- Pesos dos 5 componentes já estão seedados e não são reabertos: quiz 0,40 / flashcards 0,25 / questões novas 0,20 / consistência 0,10 / calibração de autoconfiança 0,05 (`componente_peso`, `V11`).
- `domain_progress` é um registro único por usuário/domínio, recalculado deterministicamente a partir das evidências brutas — não é uma tabela de histórico (decisão já registrada em `database-schema.md`).

---

## 4. Decisões tomadas nas 5 pendências (resumo executivo)

| # | Pendência | Decisão | Precisa de confirmação do Tito? |
|---|---|---|---|
| 1 | Cortes dos 12 níveis | Proposta de curva não-linear (progressão fica mais difícil nos níveis altos) — ver seção 5.1 | **Sim — Open Question OQ-A** |
| 2 | Fórmula de consistência (10%) e calibração (5%) | Fórmulas concretas e verificáveis definidas — ver seção 5.2 | Não, mas fica sujeita a ajuste após primeiro ciclo real de uso (ver seção 9) |
| 3 | Tamanho da sessão de quiz | 10 questões por `QuizAttempt`, fixo no MVP — ver seção 6.2 | Não |
| 4 | Formato de autoavaliação de flashcard | Confirmado: `'lembrei'` / `'nao_lembrei'` (binário), como o Backend já inferiu — ver seção 6.3 | Não |
| 5 | Volume mínimo de evidência (anti-oscilação) | Definido sem exigir coluna nova no schema — ver seção 5.4 | Não |

Detalhamento de cada uma abaixo.

---

## 5. Cálculo de pontuação, nível e anti-oscilação

### 5.1 Conversão pontuação → nível (12 níveis) — **OPEN QUESTION-A**

**Por que isto é uma Open Question, não uma decisão fechada:** o PRD define os 12 nomes de nível, mas não define os cortes, e explicitamente registra que "não há linha de base definida ainda" para a métrica de evolução. Cortes de nível são uma decisão que molda a percepção de progresso do usuário (ex.: se "Sênior" é fácil ou difícil de alcançar) — decidir isso sem nenhum dado real de uso é uma aposta de produto, não uma dedução técnica. Por isso registro como Open Question com uma proposta defensável, em vez de fechar silenciosamente.

**Proposta inicial (defensável, não arbitrária):** faixas de largura crescente à medida que o nível sobe — refletindo que a diferença de domínio real entre "Júnior 1" e "Júnior 2" é meramente incremental, enquanto a diferença entre "Sênior 3" e "Especialista 1" deveria representar um salto de maturidade bem maior. O placeholder atual do DBA (faixas iguais de ~8,33 pontos) torna "Especialista" tão fácil de alcançar quanto "Júnior 2", o que provavelmente desalinha com a expectativa de um usuário estudando para entrevistas de nível sênior/especialista.

| Nível | Faixa (pontuação, 0–100) |
|---|---|
| Júnior 1 | [0, 15) |
| Júnior 2 | [15, 25) |
| Júnior 3 | [25, 35) |
| Pleno 1 | [35, 45) |
| Pleno 2 | [45, 55) |
| Pleno 3 | [55, 65) |
| Sênior 1 | [65, 73) |
| Sênior 2 | [73, 81) |
| Sênior 3 | [81, 89) |
| Especialista 1 | [89, 94) |
| Especialista 2 | [94, 97) |
| Especialista 3 | [97, 100] |

**Regra de fronteira:** cada faixa é fechada à esquerda e aberta à direita (`[mínima, máxima)`), exceto a última (`Especialista 3`), que é fechada nos dois extremos para incluir `100.00`. Ou seja, uma pontuação exatamente igual ao corte pertence ao nível **superior**. Esta regra deve ser aplicada de forma idêntica em toda consulta a `nivel_referencia` (é para isso que a tabela existe — thresholds configuráveis, não regra duplicada).

**Ação esperada do Backend:** os valores acima substituem o placeholder da migração `V11` via `UPDATE` em `nivel_referencia` (não uma nova migração de schema, conforme já indicado pelo DBA) — **somente após confirmação do Tito**.

### 5.2 Fórmula de consistência (10%) e calibração de autoconfiança (5%)

**Componente Consistência — mede regularidade de estudo e estabilidade de desempenho, não conhecimento em si.**

Calculado como média ponderada de dois sub-indicadores:

- **Regularidade (60% do componente):** proporção de dias distintos, nos últimos 30 dias corridos, em que houve pelo menos um `QuizAttempt` concluído ou `FlashcardReview` registrado no domínio, em relação a uma meta de 8 dias distintos.
  `regularidade = min(100, (dias_distintos_com_atividade / 8) * 100)`
- **Estabilidade (40% do componente):** baseada no desvio padrão amostral das pontuações (`pontuacao_obtida`) das últimas até 5 `QuizAttempt` concluídas no domínio.
  `estabilidade = max(0, 100 - desvio_padrao * 2)`
  (desvio padrão 0 → 100 pontos; desvio padrão ≥ 50 → 0 pontos)

`pontuacao_consistencia = round(0.6 * regularidade + 0.4 * estabilidade, 2)`

**Volume mínimo para calcular este componente:** pelo menos 2 dias distintos de atividade E pelo menos 3 eventos de evidência (quiz ou flashcard) no domínio nos últimos 30 dias. Abaixo disso, `pontuacao_consistencia = NULL` (ver regra de redistribuição de peso, seção 5.3).

**Componente Calibração de autoconfiança — mede o quão bem a confiança declarada pelo usuário (`confianca_declarada`, 1–5, em `Answer` e `FlashcardReview`) corresponde ao resultado real.**

- Mapear `confianca_declarada` para probabilidade estimada: `p = (confianca_declarada - 1) / 4` (1→0,0 ; 5→1,0).
- Resultado real: `1` se acerto (`Answer.correta = true`) ou `resultado_autoavaliacao = 'lembrei'`; `0` caso contrário.
- Calcular o Brier score sobre as últimas até 30 declarações de confiança não nulas no domínio (somando `Answer` e `FlashcardReview`): `brier = média((p - resultado)²)`.
- `pontuacao_calibracao = round((1 - brier) * 100, 2)`

**Volume mínimo:** pelo menos 5 declarações de confiança não nulas no domínio. Abaixo disso, `pontuacao_calibracao = NULL`.

Ambas as fórmulas usam apenas colunas já existentes no schema (`study_session.iniciada_em`, `quiz_attempt.pontuacao_obtida`/`concluido_em`, `flashcard_review.revisado_em`, `confianca_declarada` em `answer` e `flashcard_review`) — nenhuma coluna nova é necessária.

### 5.3 Demais componentes (quiz, flashcards, questões novas) e agregação em `pontuacao_geral`

O ticket original que originou este trabalho pediu fórmula para os 5 componentes — os 3 abaixo não estavam listados como pendência explícita, mas o Backend não consegue implementar o cálculo de pontuação sem eles, então ficam definidos aqui também (não são Open Question — são inferências diretas e de baixo risco a partir do PRD/schema):

- **Quiz (40%):** `pontuacao_quiz = média das últimas até 3 QuizAttempt concluídas do domínio` (cada tentativa contribui com `acertos / total_questoes * 100`). Usar média de múltiplas tentativas, não só a última, é o mecanismo primário de anti-oscilação deste componente (ver 5.4). Requer ≥ 1 tentativa concluída para existir; `NULL` antes disso.
- **Flashcards (25%):** `pontuacao_flashcards = (quantidade de 'lembrei' / total) * 100`, sobre as últimas até 30 `FlashcardReview` do domínio. Requer ≥ 1 revisão; `NULL` antes disso.
- **Questões novas (20%):** mede desempenho especificamente em questões respondidas pela primeira vez pelo usuário (histórico completo, não só a tentativa atual) — distingue aprendizado de repetição. Uma `Answer` é "nova" se é a primeira resposta já registrada para aquele par (usuário, `question_id`). `pontuacao_questoes_novas = (acertos entre respostas novas / total de respostas novas) * 100`, sobre as últimas até 20 respostas novas (todo o histórico, não só a sessão atual). Requer ≥ 1 resposta nova; `NULL` antes disso.
  **Limitação conhecida, não bloqueante:** como o pool de questões por domínio é finito (mínimo 18, ver ticket de conteúdo), este componente estabiliza e para de se mover assim que o usuário já respondeu toda pergunta aprovada do domínio pelo menos uma vez. Isso é aceitável no MVP; registrar como nota para revisão quando houver mais conteúdo ou reposição de banco de questões.

**Agregação — `pontuacao_geral` do domínio:**
`pontuacao_geral = Σ(peso_i * pontuacao_i) / Σ(peso_i)`, somando apenas os componentes com valor não nulo (pesos renormalizados entre os componentes disponíveis). Isso evita que a ausência de um componente (ex.: usuário nunca declarou confiança) trave o cálculo geral. Arredondar para 2 casas decimais (`numeric(5,2)`, já é o tipo da coluna).

`pontuacao_geral` só é calculada e persistida (e `nivel_atual_id` só é atribuído) depois que o volume mínimo da seção 5.4 for atingido — antes disso, os componentes individuais podem já existir, mas `pontuacao_geral` e `nivel_atual_id` permanecem `NULL`.

### 5.4 Volume mínimo de evidência / anti-oscilação (pendência #5)

**Regra:** `domain_progress.volume_minimo_atingido = true` quando `volume_evidencia_quiz >= 3` **E** `volume_evidencia_flashcard >= 10` (tentativas de quiz concluídas e revisões de flashcard, cumulativas, no domínio). Antes disso, `nivel_atual_id` e `pontuacao_geral` permanecem `NULL` e a API deve sinalizar explicitamente "nível em avaliação, faltam N sessões/revisões" em vez de mostrar um nível calculado a partir de pouquíssima evidência.

**Por que isto satisfaz "o nível não deve oscilar por uma única sessão" sem exigir nova coluna no schema:** o mecanismo de anti-oscilação não é um estado de "nível candidato" separado (que exigiria uma coluna nova, fora do que o schema já oferece) — é estrutural, embutido nas próprias fórmulas dos componentes: `pontuacao_quiz` usa a média das últimas 3 tentativas, `pontuacao_flashcards` usa as últimas 30 revisões. Uma tentativa isolada atípica (ex.: uma sessão muito ruim por distração) é diluída pelas tentativas anteriores, em vez de substituir o valor anterior integralmente. Isso usa apenas as colunas já existentes (`volume_evidencia_quiz`, `volume_evidencia_flashcard`, `volume_minimo_atingido`) em `domain_progress` (`V12`).

### 5.5 Resultado geral do usuário (requisito funcional 9)

`resultado_geral = média aritmética simples de pontuacao_geral entre os domínios com volume_minimo_atingido = true`. Domínios ainda não avaliados **não entram** na média (nem como zero, nem excluídos arbitrariamente — simplesmente ainda não têm `pontuacao_geral`). Se nenhum domínio do usuário atingiu volume mínimo, o resultado geral deve ser um estado explícito ("ainda não avaliado"), nunca `0`.

---

## 6. Regras de submissão e sessão

### 6.1 Submissão de quiz

- O usuário só pode submeter um `QuizAttempt` quando **todas** as N questões da tentativa tiverem uma resposta selecionada (envio único, "tudo ou nada" — sem submissão parcial no MVP, para evitar estado intermediário complexo).
- Ao submeter, o sistema calcula acerto/erro por questão comparando a alternativa selecionada com a alternativa marcada `correta = true` (dado já disponível no banco, nunca exposto antes deste momento), grava `Answer.correta`, marca `quiz_attempt.status = 'concluida'` e `concluido_em`, e só **então** retorna, por questão: se acertou/errou, a alternativa correta e a `explicacao` da `Question`.
- Após a submissão, o módulo Progress recalcula os componentes de pontuação do domínio afetado (síncrono, dentro da mesma operação lógica — a arquitetura já exige atomicidade dentro do módulo de aplicação).
- Uma tentativa `abandonada` (nunca submetida) não contribui para nenhum componente de pontuação.

### 6.2 Tamanho da sessão de quiz (pendência #3)

**Decisão:** 10 questões por `QuizAttempt`, fixo no MVP (`quiz_attempt.total_questoes = 10`). Com o mínimo de 18 questões aprovadas por domínio (já definido no ticket de conteúdo), isso permite pelo menos uma tentativa inteira sem repetição, mais parte de uma segunda, antes de o pool começar a se repetir — compatível com o mecanismo de "questões novas" (seção 5.3).

**Regra de seleção (necessária para o componente "questões novas" fazer sentido):** ao montar uma tentativa, o sistema deve priorizar questões que o usuário ainda não respondeu nenhuma vez nesse domínio; se não houver 10 questões novas disponíveis, completa aleatoriamente com questões já respondidas anteriormente. Não há repetição de questão dentro da mesma tentativa (já garantido por `UNIQUE (quiz_attempt_id, question_id)`).

### 6.3 Formato de autoavaliação de flashcard (pendência #4)

**Confirmado:** `'lembrei'` / `'nao_lembrei'`, como o Backend já modelou em `flashcard_review.resultado_autoavaliacao`. É suficiente para o MVP — uma escala mais granular de dificuldade percebida é uma melhoria futura, coerente com o não objetivo "algoritmo avançado de repetição espaçada" já registrado no PRD. `confianca_declarada` (1–5) continua opcional, usada apenas pelo componente de calibração.

---

## 7. Endpoints esperados (alto nível — contrato detalhado é do Backend)

- `POST /dominios/{dominioId}/sessoes` — inicia uma `StudySession`.
- `POST /sessoes/{sessaoId}/quiz-attempts` — inicia um `QuizAttempt` (sorteia as 10 questões conforme 6.2).
- `POST /quiz-attempts/{attemptId}/submissao` — recebe as 10 respostas, retorna acertos/erros/explicações/pontuação da tentativa e o estado atualizado de `domain_progress`.
- `POST /sessoes/{sessaoId}/flashcard-reviews` — registra uma autoavaliação de flashcard.
- `GET /dominios/{dominioId}/progresso` — retorna os componentes de pontuação, `pontuacao_geral`, nível atual (ou "em avaliação") e `volume_minimo_atingido`.
- `GET /usuarios/{userId}/resultado-geral` — retorna a média entre domínios avaliados (ou "ainda não avaliado").
- `GET /usuarios/{userId}/historico?dominioId=` — lista `StudySession`/`QuizAttempt` ordenados por data, com `pontuacao_obtida` por tentativa (série temporal de evolução).

---

## 8. Lacuna real de schema encontrada — pendência para o DBA

**Não é resolvida por este ticket.** Ao especificar a regra "o usuário não pode responder uma questão de outro domínio dentro de uma tentativa", percebi que o schema atual **não impõe isso no banco**:

- `quiz_attempt.domain_ref` existe e é validado contra `study_session` via FK composta.
- `answer.question_id` referencia `question`, e a FK composta `(alternativa_selecionada_id, question_id)` garante que a alternativa pertence à questão — mas **nada** garante que o `domain_ref` da `Question` referenciada por uma `Answer` bate com o `domain_ref` do `quiz_attempt` ao qual ela pertence.
- Ou seja: hoje é estruturalmente possível, a nível de banco, inserir uma `Answer` para uma `Question` de "Segurança" dentro de um `QuizAttempt` cujo `domain_ref` é "Bancos de dados", e o banco não rejeitaria.

**Não estou propondo a solução de schema** (isso é decisão do DBA), só registrando a lacuna com uma sugestão de direção, seguindo o mesmo padrão já usado em `slide`/`question` (FK composta contra o pai): provavelmente exigiria denormalizar `domain_ref` em `answer` (como já feito em `quiz_attempt`) e adicionar uma FK composta contra `question (id, domain_ref)`, análoga à que já existe entre `slide` e `concept`.

**Enquanto isso não for resolvido no banco:** a aplicação **deve** validar isso antes de persistir (rejeitar com erro claro), como controle compensatório. Isso está coberto explicitamente nos critérios de aceite (AC-03) para não depender apenas do banco.

---

## 9. Open Questions

```
OPEN QUESTION-A

Question: Os cortes de pontuação dos 12 níveis propostos na seção 5.1 são os corretos,
ou o Tito quer ajustar a curva (ex.: mais dura, mais suave, ou alinhada a algum
benchmark externo de entrevistas)?

Why It Matters: Isso define a percepção de progresso do usuário desde o primeiro dia de
uso — cortes errados fazem o produto parecer fácil demais ou impossível demais de
progredir, sem nenhum dado real ainda para calibrar (o próprio PRD registra "não há
linha de base definida ainda").

How To Answer: Confirmação direta do Tito sobre a tabela da seção 5.1, ou uma tabela
alternativa. Não bloqueia o início da implementação do resto do ticket — bloqueia
apenas o UPDATE final em `nivel_referencia`.

Owner: Tito
```

```
OPEN QUESTION-B

Question: As fórmulas de consistência e calibração (seção 5.2) e os parâmetros de
volume mínimo (seção 5.4) foram definidos sem nenhum dado real de uso — eles são
razoáveis o suficiente para lançar, sabendo que serão recalibrados depois do primeiro
ciclo de uso real?

Why It Matters: São fórmulas inteiramente novas, sem baseline. Diferente da OPEN
QUESTION-A (que é puramente uma escolha de produto), aqui existe risco técnico de a
fórmula produzir números que não fazem sentido intuitivo em algum caso de borda ainda
não imaginado.

How To Answer: Aceitar como está para a primeira entrega, com uma revisão agendada no
`product-review` após as primeiras sessões reais de uso (não uma pergunta bloqueante
antes do Backend começar, ao contrário da OQ-A).

Owner: Tito (revisão, não aprovação prévia obrigatória)
```

---

## 10. Critérios de aceite (Given/When/Then)

**AC-01 — Submissão de quiz completo**
Dado um `QuizAttempt` com 10 questões, todas respondidas,
Quando o usuário submete o quiz,
Então o sistema retorna, para cada questão, se foi acerto/erro, a alternativa correta e a explicação; marca a tentativa como `concluida`; e atualiza `domain_progress` do domínio.

**AC-02 — Submissão com resposta faltando**
Dado um `QuizAttempt` com 10 questões, apenas 9 respondidas,
Quando o usuário tenta submeter,
Então o sistema rejeita com erro claro indicando a questão pendente; a tentativa permanece `em_andamento`; nenhuma alternativa correta ou explicação é revelada.

**AC-03 — Resposta a questão de outro domínio**
Dado um `QuizAttempt` do domínio "Bancos de dados",
Quando a aplicação tenta registrar uma `Answer` referenciando uma `Question` do domínio "Segurança",
Então o sistema rejeita a operação antes de persistir (validação de aplicação, já que o banco não impõe isso — ver seção 8).

**AC-04 — Primeira tentativa de um domínio**
Dado um usuário sem nenhuma evidência prévia no domínio "Arquitetura",
Quando ele conclui sua primeira `QuizAttempt`,
Então `pontuacao_quiz` é calculada e persistida, mas `pontuacao_geral` e `nivel_atual_id` permanecem `NULL`, e a API retorna um estado explícito de "em avaliação, faltam N sessões/revisões" (2 tentativas de quiz e 10 revisões de flashcard, conforme 5.4).

**AC-05 — Domínio atinge volume mínimo pela primeira vez**
Dado um domínio com `volume_evidencia_quiz = 2` e `volume_evidencia_flashcard = 10`,
Quando o usuário conclui sua 3ª `QuizAttempt`,
Então `volume_minimo_atingido` passa a `true`, `pontuacao_geral` é calculada pela primeira vez e um `nivel_atual_id` é atribuído conforme a tabela da seção 5.1.

**AC-06 — Nível não oscila por uma tentativa isolada e atípica**
Dado um domínio já avaliado, com nível "Pleno 2" sustentado pelas últimas 3 tentativas de quiz com desempenho consistente (~50 pontos),
Quando o usuário conclui uma nova tentativa com desempenho muito abaixo do padrão (ex.: 10 pontos, por distração),
Então `pontuacao_quiz` se move proporcionalmente (é a média das últimas 3 tentativas, incluindo a nova), mas não despenca o suficiente para trocar de nível numa única sessão, pelo mecanismo descrito em 5.4 — o teste deve construir números concretos que comprovem essa diluição, não apenas afirmar o comportamento.

**AC-07 — Fronteira exata entre níveis**
Dado que a pontuação geral calculada de um domínio é exatamente `65.00`,
Quando o nível é determinado,
Então o domínio é classificado como "Sênior 1" (fronteira pertence ao nível superior, faixas `[mínima, máxima)`), não "Pleno 3".

**AC-08 — Componente ausente não trava o cálculo geral**
Dado um domínio com `pontuacao_quiz`, `pontuacao_flashcards` e `pontuacao_questoes_novas` calculados, mas `pontuacao_calibracao = NULL` (usuário nunca declarou confiança),
Quando `pontuacao_geral` é recalculada,
Então o peso de 5% da calibração é redistribuído proporcionalmente entre os componentes disponíveis, e o cálculo não falha nem trata o componente ausente como zero.

**AC-09 — Resultado geral sem nenhum domínio avaliado**
Dado um usuário cujos domínios não atingiram `volume_minimo_atingido = true` em nenhum deles,
Quando ele consulta o resultado geral,
Então a API retorna um estado explícito de "ainda não avaliado", nunca `0`.

**AC-10 — Autoavaliação de flashcard inválida**
Dado um payload de revisão de flashcard com `resultado_autoavaliacao = "talvez"`,
Quando o usuário envia,
Então a aplicação rejeita antes de chegar ao banco, com um erro claro (não deve depender só do `CHECK` do Postgres para dar um retorno compreensível).

**AC-11 — Histórico e evolução**
Dado um usuário com 5 `QuizAttempt` concluídas em um domínio ao longo de 3 semanas,
Quando ele consulta o histórico do domínio,
Então a API retorna as tentativas ordenadas da mais recente para a mais antiga, cada uma com sua `pontuacao_obtida` e `concluido_em`, permitindo montar uma série temporal de evolução sem nenhuma tabela adicional de snapshot.

**AC-12 — "Questões novas" esgotadas**
Dado um domínio em que o usuário já respondeu, ao menos uma vez, todas as questões aprovadas disponíveis,
Quando ele conclui uma nova `QuizAttempt` (necessariamente com questões repetidas),
Então `pontuacao_questoes_novas` permanece com o último valor calculado (não se torna `NULL` nem trava outros componentes) — comportamento esperado, documentado como limitação conhecida (seção 5.3), não um bug.

**AC-13 — Explicação nunca vaza antes da submissão**
Dado um `QuizAttempt` em andamento,
Quando o frontend consulta as questões da tentativa (antes de submeter),
Então a resposta não contém `correta` em nenhuma alternativa nem a `explicacao` da questão — mesma garantia já validada no módulo Content, agora também coberta no fluxo de sessão de quiz.
