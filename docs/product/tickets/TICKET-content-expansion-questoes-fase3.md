# TICKET — Ampliação do pool de Questions (Fase 3: 54 → 72 por domínio)

**Status:** rascunho — pronto para produção de conteúdo (autoria assistida por IA + revisão humana obrigatória antes de produção, mesma regra já vigente).
**Ticket mestre de referência:** `docs/product/tickets/TICKET-content-database.md` — **leia primeiro**. Este ticket **não redefine** estrutura de dados, regras de negócio, autoria ou fora-de-escopo já fixados lá.
**Tickets das fases anteriores (mesmo padrão, leia também):**
- Fase 1: `docs/product/tickets/TICKET-content-expansion-questoes.md`
- Fase 2: `docs/product/tickets/TICKET-content-expansion-questoes-fase2.md`

Este ticket segue exatamente a mesma estrutura, critérios de qualidade e formato de critérios de aceite das fases anteriores, ajustando apenas volume, fonte de não-duplicação e numeração de migração.

---

## Contexto e por que ampliar agora

As Fases 1 (`V26`–`V32`) e 2 (`V35`–`V41`) já elevaram o pool de Questions de 18 para 54 por domínio, nos 7 domínios do MVP (Arquitetura, Sistemas Distribuídos, Bancos de Dados, APIs/Mensageria, Escalabilidade/Desempenho, Observabilidade/Confiabilidade, Segurança). Contagem direta no banco confirma o total atual: **378 Questions (54 por domínio)**, com distribuição exata de 18 fácil / 18 média / 18 difícil por domínio, todas com exatamente 4 alternativas e exatamente 1 correta, sem enunciados duplicados dentro de cada domínio.

O Tito (founder/dono do produto) pediu para repetir o processo mais uma vez: mais uma rodada de expansão da base de perguntas e respostas, no mesmo padrão das fases anteriores.

O motivo de fundo é o mesmo já registrado desde a Fase 1 e ainda não resolvido (OPEN QUESTION-004 do ticket mestre): o tamanho de uma sessão de quiz não está definido, então não há como confirmar quantitativamente que 54 por domínio já é suficiente para evitar repetição percebida em múltiplas tentativas. Esta rodada aumenta ainda mais a margem de segurança sem esperar essa definição.

---

## Escopo

- **Somente Question + Alternativas.** Nenhum Concept, Slide ou Flashcard novo nesta leva (mesma regra das fases anteriores).
- As novas Questions devem referenciar, via `domain_ref` (obrigatório) e `concept_ref` (recomendado, não obrigatório), os **Concepts já existentes** de cada domínio. Não é necessário criar Concepts novos.
- Cobre os 7 domínios do MVP, na mesma ordem já usada em todas as migrações anteriores: arquitetura, sistemas-distribuidos, bancos-de-dados, apis-mensageria, escalabilidade-desempenho, observabilidade-confiabilidade, seguranca.

## Fora de escopo

- Concepts, Slides, Flashcards novos.
- Qualquer alteração de schema — `question` e `question_alternative` já suportam o volume adicional sem migração estrutural; as migrações desta leva são apenas `INSERT`, no mesmo padrão de `V14`–`V20`, `V26`–`V32` e `V35`–`V41`.
- Revisitar a decisão de 4 alternativas por Question, formato de campos, ou qualquer regra já fixada no ticket mestre.
- Redefinir `dificuldade` ou `status_revisao`.
- Redefinir `content_version` — ver seção "Decisão fechada: content_version" abaixo (fecha a Open Question herdada das duas fases anteriores).
- Definir o tamanho de uma sessão de quiz (OPEN QUESTION-004 do ticket mestre segue em aberto).
- Alterar migrações já aplicadas (`V1`–`V41`).

---

## Estrutura de dados das novas Questions (reaproveitada do ticket mestre, sem alteração)

Idêntica à das fases anteriores — ver `TICKET-content-expansion-questoes.md` e `TICKET-content-expansion-questoes-fase2.md`, seção "Estrutura de dados das novas Questions", que por sua vez referenciam `TICKET-content-database.md`:

- `domain_ref`: obrigatório, um dos 7 Domains já existentes.
- `concept_ref`: recomendado (não obrigatório), um dos 5 Concepts já existentes daquele domínio.
- `enunciado`: texto da pergunta.
- `alternativas`: exatamente 4, cada uma com `texto` e `correta` (booleano) — exatamente 1 `correta`, nenhuma com texto vazio, nenhuma duplicada dentro da mesma questão.
- `explicacao`: não vazia.
- `dificuldade`: `facil` | `media` | `dificil`.
- `content_version`: `v1` — ver "Decisão fechada: content_version" abaixo.
- `status_revisao`: `rascunho` — nenhuma Question desta leva pode nascer como `revisado_aprovado`.

Nenhum campo novo. Nenhuma regra nova.

---

## Decisão fechada: `content_version`

As Fases 1 e 2 registraram esta pendência como Open Question (OPEN QUESTION-005 na Fase 1, herdada como OPEN QUESTION-008 na Fase 2) e mesmo assim usaram `content_version = 'v1'` na prática, sem que o Tito tivesse formalmente respondido a pergunta até este ticket.

**Decisão, fechada nesta criação:** a Fase 3 mantém `content_version = 'v1'` para todas as Questions novas, por **precedência de fato** — é o valor já usado de forma consistente em `V14`–`V20`, `V26`–`V32` e `V35`–`V41`, cobrindo 100% do pool atual (378 Questions). Reabrir essa decisão agora, na quarta rodada de conteúdo, criaria inconsistência retroativa sem benefício conhecido (nenhuma ferramenta ou fluxo do produto hoje filtra ou segmenta por `content_version`).

Esta pendência está **fechada** a partir deste ticket. Ela não deve reaparecer como Open Question em fases futuras, salvo se surgir um motivo concreto e novo para versionar o conteúdo (ex.: necessidade real de filtrar/migrar por versão) — nesse caso, é uma decisão de produto nova, não uma reabertura da pendência antiga.

---

## Critérios de qualidade de questão (obrigatórios, mesmo padrão das fases anteriores)

- **Dificuldade balanceada:** cada leva de 18 por domínio deve ter no mínimo 6 `facil`, 6 `media`, 6 `dificil`.
- **Sem repetição de enunciados/conceitos já cobertos:** as novas Questions não podem duplicar, literal ou disfarçadamente (mesmo ponto testado com reformulação/sinônimos), nenhum `enunciado` já existente naquele domínio em **qualquer fase anterior** (Seed original `V14`–`V20`, Fase 1 `V26`–`V32` **e** Fase 2 `V35`–`V41`) — ver seção "Restrição crítica" abaixo para a fonte de verdade por domínio.
- **Alternativas plausíveis e não óbvias:** as 3 alternativas incorretas devem representar erros conceituais plausíveis (não devem ser absurdas, irrelevantes ou eliminável por eliminação óbvia de forma/tamanho de texto).
- **Explicação clara:** o campo `explicacao` deve justificar objetivamente por que a alternativa correta está certa e, quando útil, por que as principais alternativas incorretas induzem a erro.
- **Idioma e tom:** consistentes com o restante do pool (português técnico, mesmo nível de formalidade).

---

## Restrição crítica: não-duplicação contra os lotes já existentes

As novas 18 Questions de cada domínio **não podem duplicar** nenhum `enunciado` já existente naquele mesmo domínio, considerando **as três fases anteriores combinadas** (seed original + Fase 1 + Fase 2) — não apenas a fase imediatamente anterior.

**Fonte de verdade do que já existe, por domínio** — quem for produzir a Fase 3 deve ler **os três** arquivos de migração de cada domínio antes de finalizar o próprio lote:

| Domínio | Migração seed (Fase 0) | Migração Fase 1 | Migração Fase 2 |
|---|---|---|---|
| Arquitetura | `V14__seed_conteudo_arquitetura.sql` | `V26__amplia_questoes_arquitetura.sql` | `V35__amplia_questoes_arquitetura_fase2.sql` |
| Sistemas Distribuídos | `V15__seed_conteudo_sistemas_distribuidos.sql` | `V27__amplia_questoes_sistemas_distribuidos.sql` | `V36__amplia_questoes_sistemas_distribuidos_fase2.sql` |
| Bancos de Dados | `V16__seed_conteudo_bancos_de_dados.sql` | `V28__amplia_questoes_bancos_de_dados.sql` | `V37__amplia_questoes_bancos_de_dados_fase2.sql` |
| APIs/Mensageria | `V17__seed_conteudo_apis_mensageria.sql` | `V29__amplia_questoes_apis_mensageria.sql` | `V38__amplia_questoes_apis_mensageria_fase2.sql` |
| Escalabilidade/Desempenho | `V18__seed_conteudo_escalabilidade_desempenho.sql` | `V30__amplia_questoes_escalabilidade_desempenho.sql` | `V39__amplia_questoes_escalabilidade_desempenho_fase2.sql` |
| Observabilidade/Confiabilidade | `V19__seed_conteudo_observabilidade_confiabilidade.sql` | `V31__amplia_questoes_observabilidade_confiabilidade.sql` | `V40__amplia_questoes_observabilidade_confiabilidade_fase2.sql` |
| Segurança | `V20__seed_conteudo_seguranca.sql` | `V32__amplia_questoes_seguranca.sql` | `V41__amplia_questoes_seguranca_fase2.sql` |

Isso vale tanto para duplicação literal quanto para duplicação disfarçada (mesma pergunta reescrita testando o mesmo ponto de forma indistinguível) — o objetivo é variedade real de pool, não só unicidade de string.

---

## Volume da Fase 3 (escopo obrigatório deste ticket)

Para cada um dos 7 domínios, esta leva adiciona:

| Entidade | Quantidade nova (Fase 3) | Observação |
|---|---|---|
| Question | 18 por domínio (mínimo 6 fácil, 6 média, 6 difícil nesta leva) | soma às 54 já existentes (seed + Fase 1 + Fase 2) → **72 por domínio no total** |

Total da Fase 3: **126 Questions novas** (7 domínios × 18) = 504 alternativas novas (126 × 4).

Total acumulado do produto após esta fase: **504 Questions** (7 × 72), subindo de 378 para 504.

A proporção mínima de dificuldade (6/6/6) se aplica **à leva nova**, não ao total acumulado — isso garante que o total de 72 por domínio mantenha, no mínimo, 24 fácil / 24 média / 24 difícil, preservando a proporção original de 1/3 por dificuldade.

**A Fase 3 é o critério de conclusão real e obrigatório deste ticket.** Nada além disso é exigido para este ticket ser considerado concluído.

---

## Convenção de arquivo de migração (Fase 3) — sem conflito entre domínios em paralelo

Schema atual no repositório termina em `V41__amplia_questoes_seguranca_fase2.sql` (**confirmado por listagem direta do diretório de migrations nesta criação de ticket** — não há nenhuma migração `V42` ou posterior no repositório neste momento, então nenhum trabalho não relacionado a conteúdo consumiu números no meio do caminho desta vez, diferente do que ocorreu entre a Fase 1 e a Fase 2 com `V33`/`V34` de autenticação). Reserva-se, uma migração por domínio, na mesma ordem já usada em `V14`–`V20`, `V26`–`V32` e `V35`–`V41`:

| Versão | Domínio | Arquivo sugerido |
|---|---|---|
| V42 | Arquitetura | `V42__amplia_questoes_arquitetura_fase3.sql` |
| V43 | Sistemas Distribuídos | `V43__amplia_questoes_sistemas_distribuidos_fase3.sql` |
| V44 | Bancos de Dados | `V44__amplia_questoes_bancos_de_dados_fase3.sql` |
| V45 | APIs/Mensageria | `V45__amplia_questoes_apis_mensageria_fase3.sql` |
| V46 | Escalabilidade/Desempenho | `V46__amplia_questoes_escalabilidade_desempenho_fase3.sql` |
| V47 | Observabilidade/Confiabilidade | `V47__amplia_questoes_observabilidade_confiabilidade_fase3.sql` |
| V48 | Segurança | `V48__amplia_questoes_seguranca_fase3.sql` |

**Antes de qualquer agente de conteúdo começar a escrever os `INSERT`s, confirme novamente que `V42`–`V48` ainda estão livres** (nenhuma outra migração foi criada em paralelo por outra frente de trabalho, como aconteceu com `V33`/`V34` entre a Fase 1 e a Fase 2). Esta é uma checagem obrigatória de execução, não apenas de planejamento — a numeração aqui reflete o estado do diretório no momento da criação deste ticket, que pode mudar até a execução real.

Cada agente/pessoa trabalhando em um domínio usa **apenas** o número reservado para o seu domínio. Cada migração faz apenas `INSERT` em `question` e `question_alternative`, referenciando os `Concept`s e o `Domain` já existentes (sem tocar em `V1`–`V41`).

Sufixo `_fase3` no nome do arquivo (mesmo padrão de sufixo por fase adotado a partir da Fase 2), deixando claro, só pelo nome do arquivo, a qual leva de expansão cada migração pertence.

---

## Fases de extensão futuras (4, ...) — não obrigatórias, mesmo padrão sob demanda

Mantém-se o mesmo princípio das fases anteriores: qualquer rodada futura é uma extensão sob demanda, decidida separadamente pelo Tito quando houver orçamento de execução disponível, não uma meta fixa de produto. Mesmo tamanho fixo de leva das Fases 1 e 2 (18 por domínio), não o dobro do total acumulado.

Regras para qualquer fase futura, sem exceção:
- Mesma estrutura de dados de Question (nenhum campo novo).
- Mesma proporção mínima de dificuldade (1/3 fácil, 1/3 média, 1/3 difícil) aplicada à leva daquela fase.
- Não-duplicação de `enunciado` contra **todas** as fases anteriores do mesmo domínio.
- Um arquivo de migração por domínio, números confirmados como livres e reservados em sequência a partir do último já usado no repositório (não assumir a partir de um ticket anterior sem checar o diretório de migrations primeiro — mesmo cuidado que evitou divergência nesta Fase 3 e que corrigiu a numeração especulada na Fase 2).
- `status_revisao = rascunho` e `content_version = 'v1'`, seguindo a decisão fechada nesta Fase 3 (sem reabrir a pendência).
- Critérios de aceite Given/When/Then no mesmo formato desta Fase 3, trocando apenas o volume-alvo total.

---

## Critérios de aceite (Fase 3) — Given/When/Then

Adaptados das fases anteriores, aplicados à leva nova de 18 Questions por domínio, com não-duplicação estendida às três fases anteriores.

**Volume da leva nova**
- Dado qualquer um dos 7 domínios, quando o QA conta as Questions **adicionadas nesta leva** (migrações V42–V48), então existem exatamente 18 novas por domínio.
- Dado qualquer domínio, quando o QA agrupa as Questions **novas** desse domínio por dificuldade, então existem no mínimo 6 `facil`, 6 `media` e 6 `dificil`.
- Dado qualquer domínio, quando o QA conta o total de Questions daquele domínio após esta leva (seed + Fase 1 + Fase 2 + Fase 3), então o total é no mínimo 72, com no mínimo 24 `facil`, 24 `media` e 24 `dificil`.
- Dado o total de todos os 7 domínios após esta leva, quando o QA soma as Questions, então o total é 504.

**Não-duplicação (contra as três fases anteriores)**
- Dado qualquer domínio, quando o QA compara os `enunciado` das 18 Questions novas contra os 54 `enunciado`s já existentes naquele domínio (migrações `V14`–`V20`, `V26`–`V32` e `V35`–`V41` combinadas), então não há nenhuma coincidência literal nem reformulação que teste o mesmo ponto de forma indistinguível.
- Dado qualquer domínio, quando o QA compara os `enunciado` das 18 Questions novas entre si, então não há dois enunciados idênticos dentro da própria leva nova.

**Estrutura de Question e alternativas**
- Dado qualquer Question nova, quando o QA conta suas alternativas, então existem exatamente 4.
- Dado qualquer Question nova, quando o QA conta quantas alternativas estão marcadas como `correta`, então o resultado é exatamente 1.
- Dado qualquer Question nova, quando o QA verifica as 4 alternativas, então nenhuma tem texto vazio e não há duas com texto idêntico dentro da mesma questão.
- Dado qualquer Question nova, quando o QA verifica o campo `explicacao`, então ele não está vazio e justifica objetivamente a alternativa correta.

**Rastreabilidade e associação**
- Dado qualquer Question nova, quando o QA verifica `domain_ref`, então ele referencia exatamente 1 dos 7 Domains válidos — o mesmo domínio da migração em que foi inserida.
- Dado qualquer Question nova com `concept_ref` preenchido, quando o QA verifica essa referência, então ela aponta para um Concept já existente do mesmo domínio (nenhum Concept novo criado nesta leva).
- Dado qualquer Question nova, quando o QA verifica `content_version`, então está preenchido com o valor `v1`.

**Status de revisão**
- Dado que esta leva foi rascunhada por IA, quando o QA verifica `status_revisao` de qualquer Question nova, então está preenchido e igual a `rascunho`.

**Migração**
- Dado o conjunto de 7 migrações desta leva (V42–V48), quando o Flyway as aplica em sequência, então nenhuma colide de número de versão com as migrações já existentes (`V1`–`V41`) nem entre si, e nenhuma altera dado ou schema fora de `INSERT` em `question`/`question_alternative`.

**Condição de aceite geral (Fase 3):** todos os cenários acima passam para os 7 domínios, sem exceção.

---

## Riscos e perguntas em aberto

- **Risco — qualidade do conteúdo gerado por IA.** Mesmo risco já registrado no ticket mestre e nas fases anteriores; mesma mitigação (revisão humana obrigatória antes de `revisado_aprovado`).
- **Risco — esforço de checagem de não-duplicação cresce a cada fase.** Com 54 enunciados existentes por domínio (em vez de 36 na Fase 2), a checagem manual de "reformulação disfarçada" fica ainda mais trabalhosa. *Mitigação sugerida:* nenhuma automatizada definida ainda; recomenda-se que quem produzir cada domínio liste os 54 enunciados existentes antes de escrever os 18 novos, não apenas releia por cima.
- **OPEN QUESTION-008 (herdada das Fases 1 e 2) — `content_version`: FECHADA nesta Fase 3.** Ver seção "Decisão fechada: content_version" acima. Não deve ser reaberta em fases futuras salvo motivo concreto novo.
- **OPEN QUESTION-007 (Fase 2) — tamanho fixo de leva (18) vs. progressão por dobra.** Segue confirmada: esta Fase 3 mantém o tamanho fixo de 18 por rodada, consistente com a Fase 2. Nenhuma mudança de padrão nesta criação.
- Demais riscos e open questions gerais (idioma, revisão, obrigatoriedade de `concept_ref`, tamanho de sessão de quiz — OPEN QUESTION-004 do ticket mestre) permanecem os já registrados, sem alteração.

---

## Retorno esperado deste ticket (handoff PM → produção de conteúdo por domínio)

- **Objetivo:** 18 Questions novas por domínio (126 no total), únicas em relação aos lotes já existentes (seed + Fase 1 + Fase 2) e entre si, seguindo exatamente os campos e regras do ticket mestre, elevando o pool de 54 para 72 por domínio (total do produto: 504).
- **Escopo:** apenas Question + Alternativas, para os 7 domínios já existentes; nenhum Concept/Slide/Flashcard novo; nenhuma alteração de schema.
- **Restrições:** reaproveitar concepts existentes (via `concept_ref`, recomendado); não duplicar enunciados existentes em nenhuma fase anterior (`V14`–`V20`, `V26`–`V32` e `V35`–`V41` como fonte de verdade) nem entre si; `status_revisao = rascunho`; `content_version = 'v1'` (decisão fechada, não reabrir); migrações V42–V48 reservadas, uma por domínio — **confirmar que continuam livres no momento de execução**, antes de escrever qualquer `INSERT`.
- **Critério de conclusão:** todos os cenários Given/When/Then da seção "Critérios de aceite (Fase 3)" passam para os 7 domínios, verificados por QA.
- **Retorno:** este arquivo é o insumo para quem for produzir cada um dos 7 lotes de Questions novas desta fase. Diferente das fases anteriores, não há Open Question de versionamento pendente para resolver antes de começar — `content_version = 'v1'` já está decidido.
