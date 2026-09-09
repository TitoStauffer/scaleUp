# TICKET — Ampliação do pool de Questions (Fase 1: dobrar 18 → 36 por domínio)

**Status:** rascunho — pronto para produção de conteúdo (autoria assistida por IA + revisão humana obrigatória antes de produção, mesma regra já vigente).
**Ticket mestre de referência:** `docs/product/tickets/TICKET-content-database.md` — **leia primeiro**. Este ticket **não redefine** estrutura de dados, regras de negócio, autoria ou fora-de-escopo já fixados lá; ele só define o volume adicional, a restrição de não-duplicação e a numeração de migração desta leva.
**Tickets de domínio da leva original (fonte do que já existe):** `docs/product/tickets/content/TICKET-content-*.md` (7 arquivos) + migrações `V14`–`V20` (uma por domínio) + `V21` (ajuste de ordenação de `Concept`, não afeta Question).

---

## Contexto e por que ampliar agora

Os 7 domínios do MVP já têm o mínimo original: 5 Concepts, 15 Slides, 15 Flashcards e 18 Questions cada, populados nas migrações `V14`–`V20` e validados por QA contra o ticket mestre.

O próprio ticket mestre já registrou isso como uma **assumption em aberto, não validada** (seção "Volume mínimo de conteúdo por domínio" e OPEN QUESTION-004): 18 Questions por domínio foi dimensionado para sustentar múltiplas sessões de quiz sem repetição integral, mas o tamanho de uma sessão de quiz — e portanto se 18 é realmente suficiente — não estava definido naquele momento. Com o módulo Assessment já implementado (`IniciarQuizAttemptService`, `SubmeterQuizAttemptService`), um pool de 18 por domínio é pequeno o bastante para que um usuário que faz múltiplas tentativas veja as mesmas questões se repetirem com alta frequência — o que enfraquece o componente "questões novas" da pontuação (20% do peso, conforme PRD) e a percepção de variedade do produto.

Este ticket resolve isso ampliando o **pool de Questions** (não Concepts, Slides ou Flashcards — esses continuam com o volume original, ver "Escopo" abaixo).

---

## Escopo

- **Somente Question + Alternativas.** Nenhum Concept, Slide ou Flashcard novo nesta leva.
- As novas Questions devem referenciar, via `domain_ref` (obrigatório) e `concept_ref` (recomendado, não obrigatório — mesma regra do ticket mestre, OPEN QUESTION-003 segue sem alteração), os **Concepts já existentes** de cada domínio. Não é necessário criar Concepts novos para "encaixar" as questões adicionais.
- Cobre os 7 domínios do MVP, na mesma ordem já usada nas migrações originais: arquitetura, sistemas-distribuidos, bancos-de-dados, apis-mensageria, escalabilidade-desempenho, observabilidade-confiabilidade, seguranca.

## Fora de escopo

- Concepts, Slides, Flashcards novos (não é objeto deste ticket).
- Qualquer alteração de schema — as tabelas `question` e `question_alternative` já suportam o volume adicional sem migração estrutural; as migrações desta leva são apenas `INSERT`, no mesmo padrão de `V14`–`V20`.
- Revisitar a decisão de 4 alternativas por Question, o formato de campos, ou qualquer regra já fixada no ticket mestre.
- Redefinir `dificuldade`, `content_version` ou `status_revisao` — usar exatamente as mesmas regras já estabelecidas.
- Definir o tamanho de uma sessão de quiz (OPEN QUESTION-004 do ticket mestre segue em aberto; este ticket apenas amplia o pool, não fecha essa questão).

---

## Estrutura de dados das novas Questions (reaproveitada do ticket mestre, sem alteração)

Cada Question nova segue **exatamente** os mesmos campos definidos em `TICKET-content-database.md`, seção "Estrutura de dados exigida" → `Question (+ Alternativas)`:

- `domain_ref`: obrigatório, um dos 7 Domains já existentes.
- `concept_ref`: recomendado (não obrigatório), um dos 5 Concepts já existentes daquele domínio.
- `enunciado`: texto da pergunta.
- `alternativas`: exatamente 4, cada uma com `texto` e `correta` (booleano) — exatamente 1 `correta`, nenhuma com texto vazio, nenhuma duplicada dentro da mesma questão.
- `explicacao`: não vazia.
- `dificuldade`: `facil` | `media` | `dificil`.
- `content_version`: mesmo identificador de versão usado nas migrações originais para aquele domínio (ex.: `v1`), a menos que o Tito decida versionar esta leva separadamente (`v2`) — ver Open Question abaixo.
- `status_revisao`: `rascunho` — mesma regra, nenhuma Question desta leva pode nascer como `revisado_aprovado`.

Nenhum campo novo. Nenhuma regra nova. Se qualquer um desses pontos parecer insuficiente durante a produção, o problema está no ticket mestre, não neste ticket — sinalize antes de inventar uma regra nova aqui.

---

## Restrição crítica: não-duplicação contra o lote já existente

As novas 18 Questions de cada domínio **não podem duplicar** nenhum dos 18 `enunciado`s já existentes naquele mesmo domínio (mesma regra de unicidade de enunciado já exigida pelo ticket mestre, agora estendida para comparar contra o lote anterior, não só dentro do lote novo).

**Fonte de verdade do que já existe, por domínio** — quem for produzir a Fase 1 deve ler o arquivo de migração correspondente **antes de finalizar** o próprio lote, para conferir os enunciados já usados:

| Domínio | Migração com Questions existentes |
|---|---|
| Arquitetura | `V14__seed_conteudo_arquitetura.sql` |
| Sistemas Distribuídos | `V15__seed_conteudo_sistemas_distribuidos.sql` |
| Bancos de Dados | `V16__seed_conteudo_bancos_de_dados.sql` |
| APIs/Mensageria | `V17__seed_conteudo_apis_mensageria.sql` |
| Escalabilidade/Desempenho | `V18__seed_conteudo_escalabilidade_desempenho.sql` |
| Observabilidade/Confiabilidade | `V19__seed_conteudo_observabilidade_confiabilidade.sql` |
| Segurança | `V20__seed_conteudo_seguranca.sql` |

Isso vale tanto para duplicação literal (mesmo texto) quanto para duplicação disfarçada (mesma pergunta reescrita com sinônimos, testando o mesmo ponto de forma indistinguível) — o espírito da regra do ticket mestre é garantir variedade real de pool, não só unicidade de string.

---

## Volume da Fase 1 (escopo obrigatório deste ticket)

Para cada um dos 7 domínios, esta leva adiciona:

| Entidade | Quantidade nova (Fase 1) | Observação |
|---|---|---|
| Question | 18 por domínio (mínimo 6 fácil, 6 média, 6 difícil nesta leva) | soma às 18 já existentes → **36 por domínio no total** |

Total da Fase 1: **252 Questions novas** (7 domínios × 18) = 126 alternativas × ... na verdade 252 × 4 = 1008 alternativas novas.

A proporção mínima de dificuldade (6/6/6) se aplica **à leva nova**, não ao total acumulado — isso garante que o total de 36 por domínio mantenha, no mínimo, 12 fácil / 12 média / 12 difícil, preservando a proporção original de 1/3 por dificuldade.

**A Fase 1 é o critério de conclusão real e obrigatório deste ticket.** Nada além disso é exigido para este ticket ser considerado concluído.

---

## Convenção de arquivo de migração (Fase 1) — sem conflito entre domínios em paralelo

Schema atual no repositório termina em `V25__cria_tabela_quiz_attempt_question.sql`. Reserva-se, uma migração por domínio, na mesma ordem já usada em `V14`–`V20`:

| Versão | Domínio | Arquivo sugerido |
|---|---|---|
| V26 | Arquitetura | `V26__amplia_questoes_arquitetura.sql` |
| V27 | Sistemas Distribuídos | `V27__amplia_questoes_sistemas_distribuidos.sql` |
| V28 | Bancos de Dados | `V28__amplia_questoes_bancos_de_dados.sql` |
| V29 | APIs/Mensageria | `V29__amplia_questoes_apis_mensageria.sql` |
| V30 | Escalabilidade/Desempenho | `V30__amplia_questoes_escalabilidade_desempenho.sql` |
| V31 | Observabilidade/Confiabilidade | `V31__amplia_questoes_observabilidade_confiabilidade.sql` |
| V32 | Segurança | `V32__amplia_questoes_seguranca.sql` |

Cada agente/pessoa trabalhando em um domínio usa **apenas** o número reservado para o seu domínio — isso evita colisão de versão Flyway quando os 7 domínios são produzidos em paralelo. Cada migração faz apenas `INSERT` em `question` e `question_alternative`, referenciando os `Concept`s e o `Domain` já existentes (sem tocar em `V14`–`V25`).

---

## Fases de extensão (2, 3, ...) — não obrigatórias, mesmo padrão sob demanda

O Tito pediu explicitamente a possibilidade de repetir este mesmo processo — "dobra, se sobrar token dobra de novo, até esgotar os tokens": cada fase adicional **dobra o total acumulado** de Questions por domínio, usando exatamente as mesmas regras de estrutura de dados, não-duplicação (agora contra **todas** as fases anteriores, não só a original) e critérios de aceite definidos aqui, só ajustando o número-base.

Isso é uma **extensão sob demanda**, limitada pela capacidade de execução disponível (orçamento de agentes/tempo) no momento em que for decidido rodar mais uma fase — **não é uma meta fixa de produto, e não é algo para o Backend/agentes de conteúdo decidirem sozinhos quando parar.** A decisão de executar a Fase 2 (ou além) é do Tito, tomada separadamente, quando houver orçamento disponível.

| Fase | Questions novas por domínio nesta fase | Total acumulado por domínio | Migrações reservadas |
|---|---|---|---|
| 1 (este ticket, obrigatória) | 18 | 36 | V26–V32 |
| 2 (extensão, sob demanda) | 36 | 72 | V33–V39 |
| 3 (extensão, sob demanda) | 72 | 144 | V40–V46 |
| ... | dobra da fase anterior | dobra do total anterior | próximo bloco de 7 |

Regras para qualquer fase futura, sem exceção:
- Mesma estrutura de dados de Question (nenhum campo novo).
- Mesma proporção mínima de dificuldade (1/3 fácil, 1/3 média, 1/3 difícil) aplicada à leva daquela fase.
- Não-duplicação de `enunciado` contra **todas** as fases anteriores do mesmo domínio (não só a imediatamente anterior).
- Um arquivo de migração por domínio, números reservados em sequência a partir do último já usado.
- `status_revisao = rascunho` e `content_version` seguindo a mesma convenção já em uso (ver Open Question abaixo sobre versionamento).
- Critérios de aceite Given/When/Then no mesmo formato da Fase 1 (ver abaixo), trocando apenas o volume-alvo total.

Se e quando o Tito decidir executar uma fase de extensão, ela deve gerar seu próprio registro de conclusão (não precisa de um novo arquivo de ticket do zero — pode ser um adendo a este mesmo arquivo, indicando quantas fases foram de fato executadas).

---

## Critérios de aceite (Fase 1) — Given/When/Then

Adaptados do ticket mestre, aplicados apenas à leva nova de 18 Questions por domínio, com o critério adicional de não-duplicação contra o lote existente.

**Volume da leva nova**
- Dado qualquer um dos 7 domínios, quando o QA conta as Questions **adicionadas nesta leva** (migrações V26–V32), então existem exatamente 18 novas por domínio.
- Dado qualquer domínio, quando o QA agrupa as Questions **novas** desse domínio por dificuldade, então existem no mínimo 6 `facil`, 6 `media` e 6 `dificil`.
- Dado qualquer domínio, quando o QA conta o total de Questions daquele domínio após esta leva (existentes + novas), então o total é no mínimo 36, com no mínimo 12 `facil`, 12 `media` e 12 `dificil`.

**Não-duplicação (critério novo desta leva)**
- Dado qualquer domínio, quando o QA compara os `enunciado` das 18 Questions novas contra os 18 `enunciado`s já existentes naquele domínio (migrações `V14`–`V20`), então não há nenhuma coincidência literal nem reformulação que teste o mesmo ponto de forma indistinguível.
- Dado qualquer domínio, quando o QA compara os `enunciado` das 18 Questions novas entre si, então não há dois enunciados idênicos dentro da própria leva nova (mesma regra de unicidade interna já aplicada ao lote original).

**Estrutura de Question e alternativas (mesma regra do ticket mestre, aplicada às novas)**
- Dado qualquer Question nova, quando o QA conta suas alternativas, então existem exatamente 4.
- Dado qualquer Question nova, quando o QA conta quantas alternativas estão marcadas como `correta`, então o resultado é exatamente 1.
- Dado qualquer Question nova, quando o QA verifica as 4 alternativas, então nenhuma tem texto vazio e não há duas com texto idêntico dentro da mesma questão.
- Dado qualquer Question nova, quando o QA verifica o campo `explicacao`, então ele não está vazio.

**Rastreabilidade e associação**
- Dado qualquer Question nova, quando o QA verifica `domain_ref`, então ele referencia exatamente 1 dos 7 Domains válidos — o mesmo domínio da migração em que foi inserida.
- Dado qualquer Question nova com `concept_ref` preenchido, quando o QA verifica essa referência, então ela aponta para um Concept já existente do mesmo domínio (nenhum Concept novo criado nesta leva).
- Dado qualquer Question nova, quando o QA verifica `content_version`, então está preenchido com um identificador não vazio (ver Open Question sobre se reaproveita o `v1` original ou usa um novo identificador para esta leva).

**Status de revisão**
- Dado que esta leva foi rascunhada por IA, quando o QA verifica `status_revisao` de qualquer Question nova, então está preenchido e igual a `rascunho` — nenhuma Question desta leva pode estar `revisado_aprovado`.

**Migração**
- Dado o conjunto de 7 migrações desta leva (V26–V32), quando o Flyway as aplica em sequência, então nenhuma colide de número de versão com as migrações já existentes (`V1`–`V25`) nem entre si, e nenhuma altera dado ou schema fora de `INSERT` em `question`/`question_alternative`.

**Condição de aceite geral (Fase 1):** todos os cenários acima passam para os 7 domínios, sem exceção. A Fase 1 é considerada concluída quando isso ocorre — fases de extensão (2, 3, ...) são independentes e não bloqueiam a conclusão deste ticket.

---

## Riscos e perguntas em aberto

- **Risco — qualidade do conteúdo gerado por IA.** Mesmo risco já registrado no ticket mestre; mesma mitigação (revisão humana obrigatória antes de `revisado_aprovado`, ainda sem checklist definido — OPEN QUESTION-002 do ticket mestre segue em aberto e vale também para esta leva).
- **OPEN QUESTION-005 — `content_version` desta leva: reaproveita `v1` ou usa um novo identificador (`v2`)?** O ticket mestre trata `content_version` como imutável após publicação, com alterações de conteúdo gerando nova versão em vez de sobrescrever a existente. Esta leva é conteúdo **adicional**, não uma correção do lote `v1` — não está claro se isso conta como "mesma versão, mais itens" ou se deve levar um identificador de versão próprio. *Por que importa:* afeta se ferramentas futuras que filtram por `content_version` continuam enxergando o pool completo ou só o lote original. *Como responder:* Tito decide antes de os agentes de conteúdo escreverem os `INSERT`s — recomendo manter `v1` (mesmo lote lógico, só maior), mas é uma preferência de produto, não uma inferência técnica. *Owner:* Tito.
- **OPEN QUESTION-006 — critério de "reformulação que testa o mesmo ponto de forma indistinguível" na checagem de não-duplicação.** É uma checagem qualitativa (não só string matching), o que exige julgamento de quem revisa. *Por que importa:* sem esse cuidado, o pool "dobra" apenas em contagem, não em variedade real de avaliação. *Como responder:* cada agente de domínio deve ler os enunciados existentes antes de escrever os novos e evitar reformulações triviais; QA amostra e sinaliza se encontrar. *Owner:* quem produzir cada domínio, na Fase 1.
- Demais riscos e open questions gerais (idioma, revisão, obrigatoriedade de `concept_ref`, tamanho de sessão de quiz) permanecem os já registrados no ticket mestre, sem alteração.

---

## Retorno esperado deste ticket (handoff PM → produção de conteúdo por domínio)

- **Objetivo:** 18 Questions novas por domínio (252 no total), únicas em relação ao lote já existente e entre si, seguindo exatamente os campos e regras do ticket mestre, elevando o pool para 36 por domínio.
- **Escopo:** apenas Question + Alternativas, para os 7 domínios já existentes; nenhum Concept/Slide/Flashcard novo; nenhuma alteração de schema.
- **Restrições:** reaproveitar concepts existentes (via `concept_ref`, recomendado); não duplicar enunciados existentes (`V14`–`V20` como fonte de verdade) nem entre si; `status_revisao = rascunho`; migrações V26–V32 reservadas, uma por domínio, sem conflito entre trabalho paralelo.
- **Critério de conclusão:** todos os cenários Given/When/Then da seção "Critérios de aceite (Fase 1)" passam para os 7 domínios, verificados por QA.
- **Retorno:** este arquivo é o insumo para quem for produzir cada um dos 7 lotes de Questions novas. Fases de extensão (2, 3, ...) seguem descritas para uso futuro, mas não fazem parte do critério de conclusão deste ticket e só devem ser executadas mediante decisão explícita do Tito sobre orçamento disponível. OPEN QUESTION-005 (versionamento) precisa de resposta do Tito antes de os agentes de conteúdo escreverem os `INSERT`s, para evitar retrabalho.
