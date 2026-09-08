# TICKET MESTRE — Base de conteúdo de estudo (Domain, Concept, Slide, Flashcard, Question+Alternativas)

**Status:** ticket mestre pronto para o próximo elo (DBA); execução do conteúdo dividida em 7 tickets de domínio (ver "Estrutura da entrega" abaixo).
**Histórico de revisão:**
- v1 cobria Domain, Concept, Flashcard e Question, com Slide explicitamente fora de escopo.
- v2 incluiu Slide como quinta entidade, por decisão do Tito, para manter coerência com o passo 3 do plano de implementação, que já previa slides no seed inicial.
- v3: tentou tornar `Question.concept_ref` obrigatório e propôs uma tabela nova `ConceptProgress`, sob a premissa de que "categoria da pergunta" = `Concept`. Também ampliou o handoff ao DBA para o schema completo (todos os módulos) — essa parte da v3 **permanece válida**.
- v4 (esta versão): **reverte a premissa da v3.** O Tito esclareceu que "categoria da pergunta" é sinônimo do `Domain` já existente (ex.: "Bancos de Dados", "Arquitetura"), não do `Concept`. Como `Question.domain_ref` já é obrigatório desde a v1, o requisito de identificar pontos fortes/fracos por categoria **já é satisfeito** pelo `DomainProgress` que a arquitetura já descreve — não há necessidade de `ConceptProgress` nem de tornar `Question.concept_ref` obrigatório. `Question.concept_ref` volta a ser recomendado (não obrigatório), `Concept` permanece apenas como organizador de conteúdo dentro do `Domain` (agrupa Slides/Flashcards/Questions para fins de estudo, não como mecanismo de categorização de força/fraqueza). A seção "Requisito descoberto..." e as menções a `ConceptProgress` foram removidas. Esta versão também **reestrutura o ticket**: este arquivo passa a ser o ticket mestre (regras comuns às 5 entidades e aos 7 domínios) e o conteúdo específico de cada domínio passa a viver em 7 tickets próprios em `docs/product/tickets/content/`, para permitir desenvolvimento paralelo por domínio.
**Origem:** `docs/product/PRD-mvp.md` (requisitos funcionais 2, 3, 4; seção "Dependências, riscos e perguntas abertas" — "Conteúdo inicial: precisa ser criado e revisado; responsável e formato ainda serão definidos")
**Arquitetura de referência:** `docs/architecture/initial-architecture.md` (módulo Content; modelo de domínio: `Domain` agrega `Concept`, `Slide`, `Flashcard`, `Question`)
**Plano de implementação de referência:** `docs/architecture/implementation-plan-mvp.md`, passo 3

---

## Contexto e problema

O ScaleUp não tem hoje nenhum conteúdo de estudo. Sem conteúdo, nenhum outro módulo pode ser validado de ponta a ponta: Study não tem o que apresentar, Assessment não tem questões para pontuar, Progress não tem evidência para classificar. O PRD já registrava essa lacuna como pendência aberta ("Conteúdo inicial: precisa ser criado e revisado; responsável e formato ainda serão definidos") sem responsável nem formato definidos.

Este ticket fecha essa lacuna para a fatia de conteúdo mais crítica para o ciclo de estudo — **perguntas de quiz com alternativas** — e para toda a estrutura da qual elas dependem para compor o ciclo completo de estudo descrito no PRD (estudar slides → revisar flashcards → responder quiz), já que no modelo de domínio uma `Question` pertence a um `Domain` e o PRD trata conteúdo como uma unidade coesa (conceitos + slides + flashcards + questões), não como itens isolados.

## Objetivo

Ter, ao final deste ticket, um **conjunto de conteúdo estruturado e versionado** (ainda como rascunho, não como dado de produção) cobrindo os 7 domínios do MVP, com `Domain`, `Concept`, `Slide`, `Flashcard` e `Question`+alternativas em formato pronto para dois usos:

1. servir de insumo para o DBA desenhar o schema real (próximo elo da cadeia);
2. ser convertido em seed reproduzível pelo Backend Engineer depois que o schema existir.

Este ticket **não** entrega dado em produção nem schema de banco — entrega o **conteúdo em si** (texto) já estruturado nos campos definidos abaixo, para os próximos elos consumirem.

---

## Estrutura da entrega: ticket mestre + tickets de domínio

Este é o **ticket mestre** desta iniciativa de conteúdo. Ele concentra tudo que é comum aos 7 domínios: decisões e premissas, estrutura de dados das 5 entidades, volume mínimo por domínio, o template de critérios de aceite, riscos/perguntas em aberto gerais e o handoff ao DBA. O handoff ao DBA depende **apenas deste arquivo** (mais a arquitetura) — os tickets de domínio abaixo não são insumo para ele.

A produção do conteúdo em si (os textos de Concepts, Slides, Flashcards e Questions) foi dividida em **7 tickets independentes, um por domínio**, para permitir trabalho em paralelo — por pessoas ou agentes diferentes, cada um responsável por um domínio:

- `docs/product/tickets/content/TICKET-content-arquitetura.md`
- `docs/product/tickets/content/TICKET-content-sistemas-distribuidos.md`
- `docs/product/tickets/content/TICKET-content-bancos-de-dados.md`
- `docs/product/tickets/content/TICKET-content-apis-mensageria.md`
- `docs/product/tickets/content/TICKET-content-escalabilidade-desempenho.md`
- `docs/product/tickets/content/TICKET-content-observabilidade-confiabilidade.md`
- `docs/product/tickets/content/TICKET-content-seguranca.md`

Cada ticket de domínio referencia este ticket mestre para as regras gerais (não as repete) e traz os critérios de aceite já **instanciados** para aquele domínio específico — permitindo que ele seja produzido, revisado e marcado como concluído de forma independente dos outros 6. Este ticket mestre só é considerado totalmente concluído quando os 7 tickets de domínio estiverem concluídos.

---

## Decisões e premissas documentadas

Estas três decisões já foram tomadas com o Tito (dono do produto) e são tratadas aqui como restrição, não como algo em aberto para este ticket:

1. **Escopo de domínios — os 7, não um piloto.** Cobrir os 7 domínios hipotéticos já listados no PRD: Arquitetura, Sistemas Distribuídos, Bancos de Dados, APIs/Mensageria, Escalabilidade/Desempenho, Observabilidade/Confiabilidade e Segurança. Nenhum domínio pode ficar sem conteúdo nesta entrega.

2. **Autoria do conteúdo — rascunho por IA, com revisão humana obrigatória antes de produção.** O texto de perguntas, alternativas, explicações, flashcards e conceitos desta primeira leva será **rascunhado por IA** como conteúdo de exemplo/placeholder, com o objetivo de validar o pipeline técnico (estrutura de dados, seed, fluxo completo) — não de já publicar conteúdo final para usuários reais. Nenhum item pode ser tratado como "aprovado para produção" nesta entrega; todo item deve carregar um status explícito de revisão (ver critérios de aceite).
   - **Distinção importante a registrar:** isso não conflita com o não-objetivo do PRD "geração automática de conteúdo ou questões por IA". Aquele não-objetivo se refere a uma **feature do produto em runtime** — o aplicativo gerando conteúdo sozinho, ao vivo, para o usuário final. O que este ticket descreve é **autoria assistida por IA durante o desenvolvimento**, um processo editorial offline, sujeito a revisão humana antes de ir ao ar, análogo a um redator usando IA como rascunho. São conceitos diferentes e não devem ser confundidos por quem ler este ticket depois.

3. **Cadeia de handoff.** Este é o primeiro ticket de uma sequência: PM (este ticket, define conteúdo e estrutura de dados) → DBA (desenha schema completo do banco, todos os módulos) → Backend Engineer (implementa e popula o seed) → QA (valida contra os critérios de aceite abaixo). Desenho de schema, índices, constraints físicas e implementação de API **não são escopo deste ticket**.

---

## Escopo

- Criação do conteúdo (texto) para os 7 domínios listados acima.
- Estrutura mínima de `Domain` e `Concept` como agregadores necessários para `Slide`, `Question` e `Flashcard` existirem de forma organizada.
- Estrutura completa de `Slide` (título, corpo/conteúdo, ordem dentro do conceito), cobrindo a etapa "estudar slides" do fluxo principal.
- Estrutura completa de `Flashcard` (frente/verso/dificuldade).
- Estrutura completa de `Question` com alternativas de múltipla escolha, resposta correta e explicação.
- Definição do volume mínimo de itens por domínio (quantidade).
- Definição dos campos obrigatórios de cada entidade (formato/estrutura de dados que o schema do DBA precisa suportar).
- Template de critérios de aceite verificáveis por QA, instanciado em cada um dos 7 tickets de domínio.
- Divisão do trabalho de produção de conteúdo em 7 tickets independentes por domínio (ver "Estrutura da entrega").

## Fora de escopo

- **Desenho de schema de banco de dados** (tabelas, tipos de coluna, constraints, índices, migrações) — responsabilidade do próximo elo (DBA).
- **Implementação de API** de consulta de conteúdo — responsabilidade do Backend Engineer.
- **Testes automatizados** sobre esse conteúdo ou sobre a API — responsabilidade do Backend Engineer / QA.
- **Interface de administração de conteúdo** — decisão já registrada no PRD como pendência futura, não deste ticket.
- **Cálculo de pontuação/nível** (pesos, thresholds, fórmula de consistência) — já especificado no PRD/arquitetura, não é objeto deste ticket.
- **Definição de quantos itens compõem uma sessão de quiz** — é uma decisão do módulo Assessment/Study ainda não tomada; este ticket apenas garante volume de pool suficiente para ela (ver seção de riscos).
- **Associação obrigatória `Question`→`Concept` ou `Flashcard`→`Concept` a nível de schema** — ver Open Question abaixo; este ticket recomenda o campo, mas não impõe obrigatoriedade de schema (isso é decisão do DBA em conjunto com o PM).

---

## Estrutura de dados exigida (campos obrigatórios por entidade)

Esta seção define o **formato de conteúdo**, não o schema físico. O DBA decide tipos de coluna, constraints e índices; o PM define quais campos precisam existir e suas regras de negócio.

### Domain
- `slug` / identificador único e estável (ex.: `arquitetura`, `sistemas-distribuidos`).
- `nome` de exibição.
- `descricao` curta (usada na tela de seleção de domínio).
- `content_version`: identificador da versão do lote de conteúdo (ex.: `v1`).
- `status_revisao`: `rascunho` | `revisado_aprovado` (ver Decisão 2).

### Concept
- `domain_ref`: referência ao `Domain` ao qual pertence.
- `titulo`.
- `resumo`: texto curto (visão geral do conceito; o conteúdo de estudo detalhado vive nos `Slide`s associados).
- `content_version`.
- `status_revisao`: `rascunho` | `revisado_aprovado`.

### Slide
- `concept_ref`: referência **obrigatória** ao `Concept` ao qual pertence (diferente de `Flashcard`/`Question`, cuja associação a `Concept` é recomendada mas não obrigatória — ver Open Question-003). `domain_ref` pode ser derivado do `Concept`, mas recomenda-se manter explícito para facilitar consultas.
- `titulo`: título do slide.
- `conteudo`: corpo/texto do material de estudo apresentado nesse slide.
- `ordem`: inteiro que define a posição do slide dentro do `Concept`, começando em 1, sequencial e sem lacunas nem duplicatas dentro do mesmo `Concept`.
- `content_version`.
- `status_revisao`: `rascunho` | `revisado_aprovado`.

### Flashcard
- `domain_ref`.
- `concept_ref` (recomendado; ver Open Question sobre obrigatoriedade).
- `frente`: pergunta/prompt curto.
- `verso`: resposta.
- `dificuldade`: `facil` | `media` | `dificil` (dificuldade editorial, conforme PRD).
- `content_version`.
- `status_revisao`: `rascunho` | `revisado_aprovado`.

### Question (+ Alternativas)
- `domain_ref`: referência **obrigatória** ao `Domain`. É esta referência — não `concept_ref` — que serve de base para o `DomainProgress` já descrito na arquitetura identificar pontos fortes e fracos do usuário por categoria (categoria = Domain, não Concept; ver histórico de revisão).
- `concept_ref` (recomendado; ver Open Question).
- `enunciado`: texto da pergunta.
- `alternativas`: lista de exatamente 4 alternativas, cada uma com `texto` e `correta` (booleano).
- `explicacao`: texto explicando por que a resposta correta está certa.
- `dificuldade`: `facil` | `media` | `dificil`.
- `content_version`.
- `status_revisao`: `rascunho` | `revisado_aprovado`.

**Decisão de PM:** cada `Question` terá **4 alternativas** (1 correta + 3 incorretas), não 3. Justificativa: reduz a chance de acerto por chute aleatório (25% vs. 33%) e segue o padrão comum de avaliações técnicas de múltipla escolha. Se o Tito preferir 3 alternativas para reduzir esforço de autoria, isso deve ser revisitado antes do DBA fixar a estrutura de alternativas no schema.

---

## Volume mínimo de conteúdo por domínio

Para cada um dos 7 domínios, o lote de conteúdo desta entrega deve conter, no mínimo:

| Entidade | Quantidade mínima | Observação |
|---|---|---|
| Concept | 5 por domínio | cobre os principais subtemas do domínio |
| Slide | 3 por Concept (mínimo 15 por domínio) | uma sequência mínima de contexto → explicação central → exemplo/aplicação; menos que isso não sustenta a etapa "estudar slides" como material de aprendizado real, e não apenas um rótulo |
| Flashcard | 15 por domínio | ~3 por conceito |
| Question | 18 por domínio | no mínimo 6 de cada dificuldade (fácil/média/difícil) |

**Isto é uma ASSUMPTION do PM, não um número já validado por dados de uso** — está fundamentado na necessidade de existir um pool de questões grande o bastante para suportar múltiplas sessões de quiz sem repetição integral (relevante para o componente "questões novas" de 20% do peso da pontuação) e para o princípio já registrado no PRD de que "o nível não deve oscilar por uma única sessão", o que exige volume mínimo de evidência. O mesmo raciocínio de "volume mínimo para sustentar uma etapa real do fluxo" foi aplicado a Slide: 3 por Concept é o menor número que permite introduzir, explicar e exemplificar um conceito, em vez de reduzir a etapa de estudo a um único parágrafo. O tamanho exato de uma sessão de quiz ainda não foi definido (ver Riscos), então o número de Question pode precisar de ajuste depois que essa decisão for tomada.

Total mínimo agregado (7 domínios): 35 Concepts, 105 Slides, 105 Flashcards, 126 Questions (504 alternativas) — 371 itens de conteúdo, além dos 7 registros de Domain.

---

## Critérios de aceite (template comum aos 7 domínios)

Estes cenários são o **template** aplicado a cada um dos 7 domínios — não estão repetidos aqui 7 vezes. Cada ticket de domínio em `docs/product/tickets/content/` traz esses mesmos cenários **já instanciados** com o nome daquele domínio específico, para permitir validação e conclusão independentes por domínio. Verificáveis objetivamente por QA sobre o conteúdo entregue (arquivo de seed, planilha ou dataset — formato de entrega a combinar com o Backend Engineer).

**Cobertura de domínios**
- Dado o conjunto de conteúdo entregue, quando o QA lista os domínios presentes, então os 7 domínios do PRD (Arquitetura, Sistemas Distribuídos, Bancos de Dados, APIs/Mensageria, Escalabilidade/Desempenho, Observabilidade/Confiabilidade, Segurança) estão todos presentes.
- Dado qualquer um dos 7 domínios, quando o QA verifica se ele possui pelo menos 1 Concept, 1 Slide, 1 Flashcard e 1 Question, então isso é verdade para todos — nenhum domínio fica sem conteúdo.

**Volume mínimo**
- Dado qualquer um dos 7 domínios, quando o QA conta os itens desse domínio, então existem no mínimo 5 Concepts, 15 Slides, 15 Flashcards e 18 Questions.
- Dado qualquer domínio, quando o QA agrupa as Questions desse domínio por dificuldade, então existem no mínimo 6 questões `facil`, 6 `media` e 6 `dificil`.

**Estrutura de Slide**
- Dado qualquer Concept, quando o QA conta os Slides associados a esse Concept, então existem no mínimo 3.
- Dado qualquer Concept, quando o QA ordena os Slides associados pelo campo `ordem`, então os valores são sequenciais, únicos e começam em 1 (sem lacunas nem duplicatas) dentro daquele Concept.
- Dado qualquer Slide, quando o QA verifica os campos `titulo` e `conteudo`, então nenhum dos dois está vazio.

**Estrutura de Question e alternativas**
- Dado qualquer Question, quando o QA conta suas alternativas, então existem exatamente 4.
- Dado qualquer Question, quando o QA conta quantas alternativas estão marcadas como `correta`, então o resultado é exatamente 1 (nunca 0, nunca mais de 1).
- Dado qualquer Question, quando o QA verifica as 4 alternativas, então nenhuma tem texto vazio e não há duas com texto idêntico dentro da mesma questão.
- Dado qualquer Question, quando o QA verifica o campo `explicacao`, então ele não está vazio.
- Dado qualquer domínio, quando o QA compara os `enunciado` de todas as Questions desse domínio, então não há dois enunciados idênticos.

**Estrutura de Flashcard**
- Dado qualquer Flashcard, quando o QA verifica `frente` e `verso`, então nenhum dos dois está vazio.
- Dado qualquer Flashcard ou Question, quando o QA verifica o campo `dificuldade`, então o valor é exatamente um entre `facil`, `media`, `dificil`.

**Rastreabilidade e associação**
- Dado qualquer Concept, Slide, Flashcard ou Question, quando o QA verifica sua associação de domínio (direta ou via `Concept`, no caso de Slide), então ela referencia exatamente 1 dos 7 Domains válidos — nenhum item órfão ou associado a um domínio inexistente.
- Dado qualquer Slide, quando o QA verifica seu campo `concept_ref`, então ele referencia exatamente 1 Concept existente — Slide nunca fica sem Concept associado.
- Dado qualquer item de conteúdo (Domain, Concept, Slide, Flashcard, Question), quando o QA verifica o campo `content_version`, então ele está preenchido com um identificador não vazio, e todos os itens deste lote compartilham o mesmo identificador de versão (ex.: todos `v1`).

**Status de revisão (placeholder vs. produção)**
- Dado que este lote foi rascunhado por IA, quando o QA verifica o campo `status_revisao` de qualquer item, então ele está preenchido (não nulo) e igual a `rascunho` — nenhum item desta entrega pode estar marcado como `revisado_aprovado`, pois a revisão humana ainda não ocorreu.

**Condição de aceite geral (deste ticket mestre):** todos os 7 tickets de domínio estão concluídos, ou seja, todos os cenários acima passam para os 7 domínios, sem exceção, e não há item de conteúdo sem `content_version` e `status_revisao` preenchidos, nem sem uma associação válida ao seu `Domain` (direta, ou via `Concept` no caso de `Slide`).

---

## Riscos e perguntas em aberto

- **Risco — qualidade e viés do conteúdo gerado por IA.** Texto rascunhado por IA pode conter erros técnicos, informação desatualizada ou viés (ex.: favorecer certas tecnologias/vendors sem justificativa pedagógica). Mitigação já decidida: revisão humana obrigatória antes de status `revisado_aprovado`.
- ~~**OPEN QUESTION-001 — Idioma do conteúdo.**~~ **RESOLVIDA.** O Tito confirmou diretamente: conteúdo em português (PT-BR), com termos técnicos consagrados em inglês mantidos como termos (ex.: "sharding", "consensus", "quorum") quando fizer sentido. Todos os 7 domínios foram produzidos e validados por QA nesse idioma.
- **OPEN QUESTION-002 — Quem revisa e com qual critério?** A decisão de revisão humana obrigatória foi tomada, mas não há checklist ou responsável definido para aprovar a mudança de `rascunho` para `revisado_aprovado`. *Por que importa:* sem critério, o gate de qualidade vira formalidade vazia. *Como responder:* Tito define se revisa ele mesmo, e quais critérios mínimos (correção técnica, ausência de viés, clareza) usar. *Owner:* Tito.
- **OPEN QUESTION-003 — `Question`/`Flashcard` devem referenciar `Concept` obrigatoriamente?** A arquitetura descreve `Domain` agregando `Concept`, `Flashcard` e `Question` como filhos diretos, sem exigir explicitamente que `Question`/`Flashcard` referenciem um `Concept` específico. Este ticket recomenda o campo (`concept_ref`) para permitir, no futuro, diagnosticar sub-tópicos fracos dentro de um domínio — mas não impõe obrigatoriedade. *Por que importa:* afeta se o DBA modela a FK como obrigatória (NOT NULL) ou opcional. *Como responder:* decisão conjunta PM + DBA ao desenhar o schema. *Owner:* PM + DBA (próximo elo). **Nota (v3→v4):** chegou a se cogitar tornar `Question.concept_ref` obrigatório sob a premissa de que "categoria da pergunta" = `Concept`; o Tito esclareceu que "categoria" na verdade é sinônimo de `Domain`, e o `DomainProgress` já descrito na arquitetura já satisfaz esse requisito. A questão original sobre `Concept` (diagnóstico de sub-tópicos, não de categoria) segue em aberto, sem relação com força/fraqueza por categoria.
- **OPEN QUESTION-004 — Tamanho de uma sessão de quiz.** O volume mínimo de 18 Questions/domínio definido aqui é uma estimativa; depende de quantos itens compõem uma sessão de quiz (decisão do módulo Assessment/Study ainda não tomada, conforme PRD). *Por que importa:* se uma sessão usar, por exemplo, 15 questões, o pool de 18 seria insuficiente para evitar repetição quase total entre sessões. *Como responder:* revisitar este volume mínimo quando o tamanho da sessão for definido. *Owner:* PM, junto com quem definir a regra de sessão.
- **Risco aceito (já registrado no PRD):** dificuldade editorial (fácil/média/difícil) é subjetiva, sem calibração por dados reais ainda — aceito como ponto de partida, a recalibrar depois.

---

## Handoff para o próximo elo (DBA)

**Objetivo:** desenhar o **schema completo do banco** (todos os módulos da arquitetura: Content, Study, Assessment, Progress, Identity) — tabelas, tipos, constraints, índices, estratégia de migração. Esta é uma ampliação de escopo já decidida pelo Tito anteriormente (o DBA não fica limitado a Content); esta versão do ticket só está corrigindo o texto do handoff, que estava desatualizado.

**Fontes que o DBA deve usar:**
- **Módulo Content (5 entidades: `Domain`, `Concept`, `Slide`, `Flashcard`, `Question`+alternativas):** este ticket mestre, seção "Estrutura de dados exigida", é a fonte de verdade — campos, obrigatoriedade e volume mínimo já definidos. Os 7 tickets de domínio em `docs/product/tickets/content/` **não** são insumo para o DBA — eles só instanciam conteúdo específico por domínio dentro da estrutura já definida aqui; o DBA só precisa deste ticket mestre.
- **Módulo Study (`StudySession`, `FlashcardReview`), Assessment (`QuizAttempt`, `Answer`), Progress (`DomainProgress`) e Identity (`User`):** `docs/architecture/initial-architecture.md` é a fonte — este ticket não redefine esses módulos, apenas os referencia como contexto necessário para as FKs de Content (ex.: `Question` referenciada por `Answer`).

**Restrições que o DBA deve respeitar (módulo Content):**
- Os 7 domínios são fixos para o MVP, mas devem ser modelados como dados (tabela `Domain`), nunca como enum/hardcode no schema ou no código.
- `content_version` é obrigatório em todas as 5 entidades de Content e deve ser tratado como imutável após publicação — alterações de conteúdo geram nova versão, não sobrescrevem a existente (evita reescrever histórico de respostas já registradas).
- `status_revisao` é obrigatório; o schema deve permitir consultar/filtrar conteúdo por esse status (ex.: para a aplicação nunca servir ao usuário final conteúdo `rascunho`, quando isso for implementado).
- `Slide.concept_ref` é obrigatório (NOT NULL) — diferente de `Flashcard.concept_ref`/`Question.concept_ref`, que são recomendados mas ainda em aberto (ver OPEN QUESTION-003). Não confundir as duas obrigatoriedades ao modelar as FKs.
- `Slide.ordem` deve ser único e sequencial dentro do mesmo `Concept` — o DBA decide se isso é garantido por constraint composta (`concept_ref` + `ordem` únicos) ou por validação de aplicação, mas a regra não pode se perder.
- Cada `Question` tem exatamente 4 alternativas, exatamente 1 correta — o DBA decide se isso é garantido por constraint de banco, validação de aplicação, ou ambos; mas a regra de negócio (1 correta, sempre) não pode ser perdida na modelagem.
- Pontos fortes/fracos por categoria são resolvidos pelo par `Question.domain_ref` (obrigatório) + `DomainProgress` (já descrito na arquitetura) — **não** há necessidade de nenhuma tabela nova de progresso por `Concept`.
- Migrações devem ser versionadas e aditivas, conforme já decidido na arquitetura geral do projeto.

**Pendências que o DBA herda para decidir ou devolver ao PM:** OPEN QUESTION-003 (obrigatoriedade de `Concept` em `Flashcard`/`Question` — não se aplica a `Slide`, cuja associação já é obrigatória por definição). OPEN QUESTION-004 (tamanho de sessão de quiz) segue em aberto e pode afetar índices/consultas de `QuizAttempt`, mas não bloqueia o desenho inicial do schema.

**Fora do escopo do DBA neste momento:** nada dos módulos da arquitetura fica de fora — o escopo do DBA é o schema completo (Content, Study, Assessment, Progress, Identity).

---

## Retorno esperado deste ticket (handoff PM → DBA)

- **Objetivo:** conteúdo estruturado (Domain, Concept, Slide, Flashcard, Question+alternativas) para os 7 domínios do MVP, em rascunho por IA, pronto para virar seed após o schema existir.
- **Escopo:** conteúdo e formato de dados; não inclui schema, API ou testes.
- **Restrições:** 7 domínios obrigatórios; autoria por IA como rascunho, revisão humana obrigatória antes de produção; campos e volumes mínimos definidos acima.
- **Critério de conclusão:** todos os cenários Given/When/Then da seção "Critérios de aceite" passam, verificados pelo QA, sobre o lote de conteúdo entregue pelo Backend Engineer após o schema do DBA existir.
- **Retorno:** este arquivo (`docs/product/tickets/TICKET-content-database.md`) é o insumo formal para o DBA iniciar o desenho do schema completo (Content a partir deste ticket mestre; Study/Assessment/Progress/Identity a partir de `docs/architecture/initial-architecture.md`). As 4 Open Questions listadas seguem em aberto e devem ser resolvidas ou explicitamente aceitas como risco antes da entrega final ao QA. Os 7 tickets de domínio em `docs/product/tickets/content/` não são insumo do DBA — servem para quem for produzir o conteúdo de cada domínio.
