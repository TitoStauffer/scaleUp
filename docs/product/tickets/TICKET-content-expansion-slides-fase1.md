# TICKET — Ampliação do pool de Slides (Fase 1: 3 → 5 por Concept, 15 → 25 por domínio)

**Status:** rascunho — pronto para produção de conteúdo (autoria assistida por IA + revisão humana obrigatória antes de produção, mesma regra já vigente).
**Ticket mestre de referência:** `docs/product/tickets/TICKET-content-database.md` — **leia primeiro**. Este ticket **não redefine** estrutura de dados, regras de negócio, autoria ou fora-de-escopo já fixados lá; ele só define o volume adicional de Slide, a restrição de não-duplicação e a numeração de migração desta leva.
**Tickets de expansão de Questions (mesmo espírito, formato de referência):** `docs/product/tickets/TICKET-content-expansion-questoes.md`, `-fase2.md`, `-fase3.md`. Este ticket segue a mesma estrutura, rigor e formato de critérios de aceite, adaptados de `Question` para `Slide`.
**Nota importante:** diferente de Questions (que já tinha 3 fases de expansão), este é o **primeiro** ticket de expansão de Slide. Não existe "Fase 0" de expansão de Slide para comparar — a fonte de verdade do que já existe é diretamente o seed original (`V14`–`V20`), não uma fase anterior de expansão.

---

## Contexto e por que ampliar agora

Os 7 domínios do MVP têm hoje exatamente o mínimo original definido no ticket mestre: 5 Concepts, **15 Slides (3 por Concept)**, 15 Flashcards e (após 3 fases de expansão) 72 Questions cada, populados nas migrações `V14`–`V20` e validados por QA contra o ticket mestre. Confirmado por leitura direta de `V14__seed_conteudo_arquitetura.sql` (e mesmo padrão nas demais): cada Concept tem exatamente 3 Slides, com `ordem` 1, 2 e 3, seguindo a sequência "o que é / conceito central" → "explicação aprofundada" → "exemplo aplicado".

O ticket mestre já registrou essa sequência de 3 como o **mínimo** que sustenta a etapa "estudar slides" como material de aprendizado real (seção "Volume mínimo de conteúdo por domínio"): "3 por Concept é o menor número que permite introduzir, explicar e exemplificar um conceito, em vez de reduzir a etapa de estudo a um único parágrafo." Isso significa que 3 é um piso, não um teto pedagógico — uma sequência de estudo mais rica normalmente cobre também os erros mais comuns que um praticante comete e como o conceito se compara com abordagens alternativas, o que a sequência mínima de 3 slides não tem espaço para cobrir sem se tornar rasa.

O Tito pediu para ampliar o volume de conteúdo de Slides ("gerar mais massa de dados para os slides dos nossos domínios"). Diferente das expansões de Question (motivadas por variedade de pool de quiz para evitar repetição entre tentativas), o motivo aqui é outro: **profundidade e cobertura pedagógica** do material de estudo. Um usuário que revisita o mesmo Concept hoje sempre vê exatamente os mesmos 3 slides — não há material adicional para aprofundar, mesmo que ele já tenha dominado o básico coberto pelos 3 slides existentes.

Este ticket resolve isso ampliando o **pool de Slides** (não Concepts, Flashcards ou Questions — esses continuam com o volume atual, ver "Escopo" abaixo).

---

## Escopo

- **Somente Slide.** Nenhum Concept, Flashcard ou Question novo nesta leva.
- Os novos Slides devem referenciar, via `concept_ref` (**obrigatório**, mesma regra do ticket mestre para Slide — diferente de Flashcard/Question, cuja associação a Concept é apenas recomendada), os **Concepts já existentes** de cada domínio. Não é necessário criar Concepts novos.
- Cobre os 7 domínios do MVP, na mesma ordem já usada em todas as migrações anteriores: arquitetura, sistemas-distribuidos, bancos-de-dados, apis-mensageria, escalabilidade-desempenho, observabilidade-confiabilidade, seguranca.

## Fora de escopo

- Concepts, Flashcards, Questions novos (não é objeto deste ticket).
- Qualquer alteração de schema — a tabela `slide` já suporta o volume adicional sem migração estrutural; as migrações desta leva são apenas `INSERT`, no mesmo padrão de `V14`–`V20`.
- Revisitar a decisão de campos de `Slide` (`titulo`, `conteudo`, `ordem`, `concept_ref`), a obrigatoriedade de `concept_ref`, ou qualquer regra já fixada no ticket mestre.
- Redefinir `dificuldade` (Slide não tem esse campo — é exclusivo de Flashcard/Question), `content_version` ou `status_revisao` — usar exatamente as mesmas regras já estabelecidas.
- Alterar a `ordem` ou o conteúdo dos 3 Slides já existentes em cada Concept.
- Alterar migrações já aplicadas (`V1`–`V50`).
- Definir tamanho de sessão de quiz ou qualquer assunto relativo a Question/Assessment (não se aplica a este ticket).

---

## Estrutura de dados dos novos Slides (reaproveitada do ticket mestre, sem alteração)

Cada Slide novo segue **exatamente** os mesmos campos definidos em `TICKET-content-database.md`, seção "Estrutura de dados exigida" → `Slide`:

- `concept_ref`: referência **obrigatória** a um dos 5 Concepts já existentes daquele domínio (esta obrigatoriedade é específica de Slide, diferente de `Flashcard.concept_ref`/`Question.concept_ref`, que são apenas recomendados).
- `domain_ref`: pode ser derivado do Concept, mas mantido explícito no schema real (confirmado em `V14`: `INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)`).
- `titulo`: título do slide.
- `conteudo`: corpo/texto do material de estudo apresentado nesse slide.
- `ordem`: inteiro que continua a sequência já existente no Concept — ver seção "Ordem sequencial" abaixo.
- `content_version`: `v1` — mesmo identificador usado em todo o conteúdo existente (`Domain`, `Concept`, `Slide`, `Flashcard`, `Question` de `V14`–`V50` usam `v1` de forma consistente; sem motivo concreto para divergir aqui, mesmo raciocínio de precedência de fato já fechado para Questions na Fase 3).
- `status_revisao`: `rascunho` — mesma regra, nenhum Slide desta leva pode nascer como `revisado_aprovado`.

Nenhum campo novo. Nenhuma regra nova. Se qualquer um desses pontos parecer insuficiente durante a produção, o problema está no ticket mestre, não neste ticket — sinalize antes de inventar uma regra nova aqui.

---

## Ordem sequencial (regra crítica, específica de Slide)

Cada Concept hoje tem Slides com `ordem` 1, 2, 3 (confirmado em `V14`–`V20`). Os Slides novos desta leva **continuam essa sequência sem lacunas nem duplicatas**: os 2 Slides novos de cada Concept recebem `ordem` 4 e 5, nesta ordem, respeitando a regra já fixada no ticket mestre ("Estrutura de dados exigida" → `Slide.ordem`: "sequencial e sem lacunas nem duplicatas dentro do mesmo Concept") e no handoff ao DBA ("`Slide.ordem` deve ser único e sequencial dentro do mesmo Concept").

Isso não é uma decisão nova — é a aplicação direta de uma regra que já existia antes deste ticket ser criado.

---

## Volume da Fase 1: por que 2 Slides novos por Concept (não 1, não repetir os 3 originais)

**Decisão:** cada Concept ganha **2 Slides novos** (ordem 4 e 5), cobrindo dois ângulos pedagógicos que a sequência mínima original não tinha espaço para tratar:

1. **Erros comuns / armadilhas** (ordem 4): equívocos frequentes que um praticante comete ao aplicar o conceito, e por que parecem certos mas não são — algo que uma sequência de introdução → explicação → exemplo não cobre por natureza, já que seu objetivo é apresentar o conceito corretamente, não mapear onde ele costuma ser mal aplicado.
2. **Comparação com alternativa** (ordem 5): como o conceito se posiciona frente a uma abordagem concorrente ou complementar dentro do mesmo domínio, reforçando quando usar um e quando usar outro — uma habilidade central em entrevistas de System Design (justificar trade-offs), que os 3 slides originais tocam de forma indireta, mas sem dedicar um slide inteiro à comparação explícita.

**Justificativa do número (mesmo padrão de raciocínio da seção "Volume mínimo de conteúdo por domínio" do ticket mestre):** o ticket mestre já fundamentou que 3 slides é o **piso mínimo** que sustenta introdução, explicação e exemplo — não o teto do que é pedagogicamente útil. Adicionar **apenas 1** slide obrigaria a espremer "erros comuns" e "comparação com alternativa" em um único slide, produzindo um slide genérico demais para ensinar qualquer um dos dois pontos com profundidade real (o mesmo problema que motivou o mínimo de 3, aplicado de novo). Adicionar **mais de 2** (ex.: replicar a mesma estrutura de "mais um exemplo", "mais uma explicação") arriscaria infixar Concepts com conteúdo redundante ao que já existe, sem introduzir um ângulo pedagógico novo — o oposto do que este ticket busca. 2 slides novos, cada um com um ângulo distinto e não coberto pelos 3 originais, é o menor incremento que enriquece a sequência sem repeti-la.

Isto é uma **ASSUMPTION do PM**, no mesmo espírito do volume original de Slide no ticket mestre — não um número validado por dados de uso real. Se o Tito preferir um número diferente (ex.: só "erros comuns", sem "comparação"), isso deve ser revisitado antes da produção do conteúdo desta fase.

| Entidade | Quantidade nova por Concept (Fase 1) | Quantidade nova por domínio (5 Concepts) | Observação |
|---|---|---|---|
| Slide | 2 (`ordem` 4 = erros comuns/armadilhas; `ordem` 5 = comparação com alternativa) | 10 | soma aos 15 já existentes → **25 Slides por domínio no total** |

Total da Fase 1: **70 Slides novos** (7 domínios × 10) = 10 novos por domínio, elevando o total do produto de **105 para 175 Slides** (7 × 25).

**A Fase 1 é o critério de conclusão real e obrigatório deste ticket.** Nada além disso é exigido para este ticket ser considerado concluído.

---

## Restrição crítica: não-duplicação contra o lote já existente

Os 2 Slides novos de cada Concept **não podem duplicar** (literal ou disfarçadamente) o conteúdo já coberto pelos 3 Slides existentes daquele mesmo Concept. Como este é o primeiro ticket de expansão de Slide, a fonte de verdade é diretamente o seed original — não há fase anterior de expansão para consultar.

**Fonte de verdade do que já existe, por domínio** — quem for produzir a Fase 1 deve ler o arquivo de migração correspondente **antes de finalizar** o próprio lote, para conferir os 3 Slides já existentes em cada Concept (título, conteúdo e o que cada um já ensina):

| Domínio | Migração com Slides existentes |
|---|---|
| Arquitetura | `V14__seed_conteudo_arquitetura.sql` |
| Sistemas Distribuídos | `V15__seed_conteudo_sistemas_distribuidos.sql` |
| Bancos de Dados | `V16__seed_conteudo_bancos_de_dados.sql` |
| APIs/Mensageria | `V17__seed_conteudo_apis_mensageria.sql` |
| Escalabilidade/Desempenho | `V18__seed_conteudo_escalabilidade_desempenho.sql` |
| Observabilidade/Confiabilidade | `V19__seed_conteudo_observabilidade_confiabilidade.sql` |
| Segurança | `V20__seed_conteudo_seguranca.sql` |

Isso vale tanto para duplicação literal (mesmo texto ou mesmo exemplo já usado) quanto para duplicação disfarçada (o slide de "erros comuns" apenas reafirma o mesmo parágrafo do slide de explicação central, com sinônimos, sem introduzir nenhum erro/armadilha que ainda não estava lá) — o espírito da regra do ticket mestre é garantir que a sequência de estudo de cada Concept, lida em ordem (1 a 5), avance em profundidade a cada slide, não que apenas repita o que já foi dito.

---

## Convenção de arquivo de migração (Fase 1) — sem conflito entre domínios em paralelo

Schema atual no repositório termina em `V50__estende_app_user_para_perfil.sql` (**confirmado por listagem direta do diretório `backend/src/main/resources/db/migration/` nesta criação de ticket** — não há nenhuma migração `V51` ou posterior no repositório neste momento). Reserva-se, uma migração por domínio, na mesma ordem já usada em `V14`–`V20`:

| Versão | Domínio | Arquivo sugerido |
|---|---|---|
| V51 | Arquitetura | `V51__amplia_slides_arquitetura.sql` |
| V52 | Sistemas Distribuídos | `V52__amplia_slides_sistemas_distribuidos.sql` |
| V53 | Bancos de Dados | `V53__amplia_slides_bancos_de_dados.sql` |
| V54 | APIs/Mensageria | `V54__amplia_slides_apis_mensageria.sql` |
| V55 | Escalabilidade/Desempenho | `V55__amplia_slides_escalabilidade_desempenho.sql` |
| V56 | Observabilidade/Confiabilidade | `V56__amplia_slides_observabilidade_confiabilidade.sql` |
| V57 | Segurança | `V57__amplia_slides_seguranca.sql` |

**Antes de qualquer agente de conteúdo começar a escrever os `INSERT`s, confirme novamente que `V51`–`V57` ainda estão livres** (nenhuma outra migração foi criada em paralelo por outra frente de trabalho) — mesmo cuidado já registrado nos tickets de expansão de Questions, onde a numeração especulada em um ticket já se mostrou desatualizada no ticket seguinte (`V33`/`V34` consumidos por trabalho de autenticação entre a Fase 1 e a Fase 2 de Questions).

Cada agente/pessoa trabalhando em um domínio usa **apenas** o número reservado para o seu domínio — isso evita colisão de versão Flyway quando os 7 domínios são produzidos em paralelo. Cada migração faz apenas `INSERT` em `slide`, referenciando os `Concept`s e o `Domain` já existentes (sem tocar em `V1`–`V50`).

---

## Fases de extensão (2, 3, ...) — não obrigatórias, mesmo padrão sob demanda

Mesmo princípio já estabelecido nas fases de Questions: qualquer rodada futura de expansão de Slide é uma **extensão sob demanda**, decidida separadamente pelo Tito quando houver orçamento de execução disponível — não é uma meta fixa de produto, e não é algo para o Backend/agentes de conteúdo decidirem sozinhos quando parar.

Regras para qualquer fase futura de Slide, sem exceção:
- Mesma estrutura de dados de Slide (nenhum campo novo).
- Mesmo tamanho fixo de leva desta Fase 1 (2 por Concept), salvo nova decisão explícita do Tito — não presumir dobra automática do total (mesmo aprendizado já registrado nas fases de Questions: a Fase 1 de Questions especulou uma progressão por dobra que a Fase 2 explicitamente abandonou em favor de tamanho fixo).
- `ordem` continua a sequência já existente no Concept (ex.: se a Fase 1 deixou o Concept com `ordem` 1–5, a Fase 2 começaria em `ordem` 6), sem lacunas nem duplicatas.
- Não-duplicação de conteúdo contra **todas** as fases anteriores do mesmo Concept (não só a imediatamente anterior).
- Um arquivo de migração por domínio, números confirmados como livres e reservados em sequência a partir do último já usado no repositório (não assumir a partir deste ticket sem checar o diretório de migrations primeiro).
- `status_revisao = rascunho` e `content_version = 'v1'`, mesma convenção já em uso.
- Critérios de aceite Given/When/Then no mesmo formato desta Fase 1, trocando apenas o volume-alvo total.

---

## Critérios de qualidade do conteúdo do Slide (adaptação de Question para Slide)

Adaptados dos critérios de qualidade já usados para Question nas fases de expansão (idioma/tom, sem repetição), com os pontos específicos de um material de estudo em formato de slide:

- **Título específico, não genérico:** o `titulo` deve diferenciar claramente o slide dos outros 4 do mesmo Concept — títulos como "Mais sobre [Conceito]" ou "Detalhes adicionais" não são aceitáveis; o título deve nomear o ângulo específico do slide (ex.: "Erros comuns ao aplicar sharding por hash" em vez de "Sharding — parte 2").
- **Conteúdo concreto, não um resumo vago:** o `conteudo` deve ensinar algo específico e verificável — um erro real com explicação de por que ocorre, ou uma comparação com critérios concretos de quando escolher cada lado —, não um parágrafo genérico que poderia ser aplicado a qualquer Concept do domínio trocando apenas o nome do conceito.
- **Slide de "erros comuns/armadilhas" (ordem 4):** deve descrever pelo menos um erro conceitual específico e explicar por que ele parece razoável mas está errado ou é subótimo — não apenas listar "cuidado ao usar X" sem explicar o raciocínio da armadilha.
- **Slide de "comparação com alternativa" (ordem 5):** deve nomear explicitamente a alternativa comparada e apresentar pelo menos um critério concreto para decidir entre as duas — não apenas "ambas têm vantagens e desvantagens" sem detalhar quais.
- **Coerência pedagógica da sequência completa:** lidos em ordem (1 a 5), os 5 Slides de um Concept devem formar uma progressão que faz sentido — introdução → explicação central → exemplo aplicado → erros comuns → comparação com alternativa —, sem que um slide contradiga ou repita literalmente o anterior.
- **Idioma e tom:** português técnico (PT-BR), com termos técnicos consagrados em inglês mantidos como termos quando fizer sentido (mesma decisão já fechada no ticket mestre), consistente com o nível de formalidade dos 3 Slides já existentes no mesmo Concept.

---

## Critérios de aceite (Fase 1) — Given/When/Then

Adaptados do template do ticket mestre e do formato já usado nas fases de expansão de Questions, aplicados à leva nova de 2 Slides por Concept.

**Volume da leva nova**
- Dado qualquer um dos 7 domínios, quando o QA conta os Slides **adicionados nesta leva** (migrações V51–V57), então existem exatamente 10 novos por domínio (2 por Concept × 5 Concepts).
- Dado qualquer Concept, quando o QA conta os Slides adicionados nesta leva associados a ele, então existem exatamente 2.
- Dado qualquer domínio, quando o QA conta o total de Slides daquele domínio após esta leva (existentes + novos), então o total é exatamente 25 (5 Concepts × 5 Slides).
- Dado o total de todos os 7 domínios após esta leva, quando o QA soma os Slides, então o total é 175.

**Ordem sequencial**
- Dado qualquer Concept, quando o QA ordena todos os Slides associados a ele (existentes + novos) pelo campo `ordem`, então os valores são sequenciais, únicos e vão de 1 a 5, sem lacunas nem duplicatas.
- Dado qualquer Slide novo desta leva, quando o QA verifica seu `ordem`, então é 4 (para o slide de erros comuns/armadilhas) ou 5 (para o slide de comparação com alternativa), nunca sobrescrevendo `ordem` 1, 2 ou 3 já existentes.

**Não-duplicação (contra o lote existente)**
- Dado qualquer Concept, quando o QA compara o `titulo` e o `conteudo` dos 2 Slides novos contra os 3 Slides já existentes naquele Concept (migrações `V14`–`V20`), então não há nenhuma coincidência literal nem reformulação que ensine o mesmo ponto de forma indistinguível.
- Dado qualquer Concept, quando o QA compara os 2 Slides novos entre si, então eles cobrem ângulos distintos (erros comuns vs. comparação com alternativa) e não há sobreposição literal de conteúdo entre eles.

**Estrutura de Slide (mesma regra do ticket mestre, aplicada aos novos)**
- Dado qualquer Slide novo, quando o QA verifica os campos `titulo` e `conteudo`, então nenhum dos dois está vazio.
- Dado qualquer Slide novo, quando o QA verifica o campo `concept_ref`, então ele referencia exatamente 1 Concept existente do mesmo domínio — nenhum Concept novo criado nesta leva, nenhum Slide órfão.

**Critérios de qualidade**
- Dado qualquer Slide novo com `ordem = 4`, quando o QA lê o `conteudo`, então ele descreve pelo menos um erro/armadilha conceitual específico, com explicação de por que ele ocorre.
- Dado qualquer Slide novo com `ordem = 5`, quando o QA lê o `conteudo`, então ele nomeia explicitamente uma alternativa e apresenta pelo menos um critério concreto de comparação.
- Dado qualquer Concept, quando o QA lê seus 5 Slides em sequência (`ordem` 1 a 5), então a leitura forma uma progressão pedagógica coerente, sem contradição ou repetição literal entre slides.

**Rastreabilidade e versionamento**
- Dado qualquer Slide novo, quando o QA verifica `domain_ref`, então ele referencia exatamente 1 dos 7 Domains válidos — o mesmo domínio da migração em que foi inserido, e o mesmo domínio do `Concept` referenciado por `concept_ref`.
- Dado qualquer Slide novo, quando o QA verifica `content_version`, então está preenchido com o valor `v1`.

**Status de revisão**
- Dado que esta leva foi rascunhada por IA, quando o QA verifica `status_revisao` de qualquer Slide novo, então está preenchido e igual a `rascunho` — nenhum Slide desta leva pode estar `revisado_aprovado`.

**Migração**
- Dado o conjunto de 7 migrações desta leva (V51–V57), quando o Flyway as aplica em sequência, então nenhuma colide de número de versão com as migrações já existentes (`V1`–`V50`) nem entre si, e nenhuma altera dado ou schema fora de `INSERT` em `slide`.

**Condição de aceite geral (Fase 1):** todos os cenários acima passam para os 7 domínios, sem exceção. Fases de extensão (2, 3, ...) são independentes e não bloqueiam a conclusão deste ticket.

---

## Riscos e perguntas em aberto

- **Risco — qualidade e viés do conteúdo gerado por IA.** Mesmo risco já registrado no ticket mestre e nas fases de expansão de Questions; mesma mitigação (revisão humana obrigatória antes de `revisado_aprovado`, ainda sem checklist definido — OPEN QUESTION-002 do ticket mestre segue em aberto e vale também para esta leva).
- **Risco — os 2 slides novos podem, na prática, ficar rasos se o Concept não tiver "erro comum" ou "alternativa" claros.** Nem todo Concept dos 7 domínios necessariamente tem um erro conceitual amplamente reconhecido ou uma alternativa direta de comparação (ex.: alguns Concepts são mais "definicionais" do que "decisórios"). *Mitigação sugerida:* quem produzir cada domínio deve avaliar Concept a Concept se os dois ângulos fazem sentido; se um Concept específico não comportar naturalmente um dos dois ângulos, sinalizar antes de forçar um slide artificial só para bater a contagem.
- **OPEN QUESTION-009 — o ângulo "comparação com alternativa" pode não se aplicar a todo Concept.** Alguns Concepts (ex.: "O que é consistência eventual") podem não ter uma alternativa única e natural para comparar, enquanto outros (ex.: "SQL vs. NoSQL") já são inerentemente comparativos e podem tornar o slide de comparação redundante com o que os 3 slides originais já cobrem. *Por que importa:* forçar o mesmo par de ângulos (erros comuns + comparação) para todos os 35 Concepts pode gerar slides fracos em alguns casos. *Como responder:* quem produzir o conteúdo tem liberdade para adaptar o segundo ângulo (ex.: trocar "comparação com alternativa" por "quando NÃO usar este conceito" ou "impacto em escala/produção") quando a comparação não for natural, desde que o ângulo escolhido não duplique os 3 slides originais nem o slide de erros comuns — a intenção pedagógica (introduzir uma quarta e quinta perspectiva distintas) importa mais que a rotulação exata. *Owner:* quem produzir cada domínio, sinalizando ao Tito se um padrão alternativo for necessário com frequência.
- **OPEN QUESTION-010 — critério de "progressão pedagógica coerente" na checagem de qualidade.** É uma checagem qualitativa (não só ausência de string duplicada), o que exige julgamento de quem revisa, no mesmo espírito da OPEN QUESTION-006 já registrada para Questions. *Por que importa:* sem esse cuidado, o pool "cresce" apenas em contagem de linhas, não em valor real de estudo. *Como responder:* cada agente de domínio deve reler os 3 Slides existentes de cada Concept antes de escrever os 2 novos, e ler os 5 em sequência ao final para confirmar que fazem sentido como uma trilha única; QA amostra e sinaliza se encontrar quebra de coerência. *Owner:* quem produzir cada domínio, na Fase 1.
- Demais riscos e open questions gerais do ticket mestre (idioma — já resolvida, revisão humana, obrigatoriedade de `concept_ref` em Flashcard/Question, tamanho de sessão de quiz) permanecem os já registrados, sem alteração — nenhum deles é reaberto por este ticket.

---

## Retorno esperado deste ticket (handoff PM → produção de conteúdo por domínio)

- **Objetivo:** 2 Slides novos por Concept (10 por domínio, 70 no total), cobrindo os ângulos "erros comuns/armadilhas" e "comparação com alternativa", sem duplicar o conteúdo já coberto pelos 3 Slides existentes de cada Concept, seguindo exatamente os campos e regras de `Slide` já fixados no ticket mestre, elevando o pool de 15 para 25 Slides por domínio (total do produto: 175).
- **Escopo:** apenas Slide, para os 7 domínios e 35 Concepts já existentes; nenhum Concept/Flashcard/Question novo; nenhuma alteração de schema.
- **Restrições:** `concept_ref` obrigatório apontando para Concept já existente; `ordem` continua a sequência 1–3 já existente, com os novos recebendo 4 e 5, sem lacunas nem duplicatas; não duplicar título/conteúdo já existente (`V14`–`V20` como fonte de verdade, já que não há fase anterior de expansão de Slide) nem entre os dois novos slides do mesmo Concept; `content_version = 'v1'`; `status_revisao = rascunho`; migrações V51–V57 reservadas, uma por domínio — **confirmar que continuam livres no momento de execução**, antes de escrever qualquer `INSERT`.
- **Critério de conclusão:** todos os cenários Given/When/Then da seção "Critérios de aceite (Fase 1)" passam para os 7 domínios, verificados por QA.
- **Retorno:** este arquivo é o insumo para quem for produzir cada um dos 7 lotes de Slides novos. OPEN QUESTION-009 (flexibilidade do segundo ângulo quando "comparação com alternativa" não for natural para um Concept específico) deve ser resolvida caso a caso durante a produção, sinalizando ao Tito se um padrão alternativo for necessário com frequência maior que pontual. Fases de extensão (2, 3, ...) seguem descritas para uso futuro, mas não fazem parte do critério de conclusão deste ticket e só devem ser executadas mediante decisão explícita do Tito sobre orçamento disponível.
