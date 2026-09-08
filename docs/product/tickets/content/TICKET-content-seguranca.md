# TICKET — Conteúdo de domínio: Segurança

**Status:** rascunho — pronto para produção de conteúdo (autoria assistida por IA + revisão humana obrigatória antes de produção).
**Ticket mestre:** `docs/product/tickets/TICKET-content-database.md` — **leia primeiro**. Este ticket não repete as decisões gerais (autoria por IA, revisão humana obrigatória, campos e regras das 5 entidades, riscos e open questions gerais, handoff ao DBA). Ele só instancia o volume mínimo e os critérios de aceite para este domínio específico.

## Domínio

- **Nome de exibição:** Segurança
- **Slug:** `seguranca`
- **Descrição curta (rascunho, sujeita a revisão humana):** Autenticação, autorização, proteção de dados em trânsito e em repouso, e mitigação de vulnerabilidades comuns em sistemas distribuídos.

## Escopo deste ticket

Produzir, apenas para o domínio Segurança, o conteúdo das 4 entidades definidas no ticket mestre: `Concept`, `Slide`, `Flashcard` e `Question`+alternativas — respeitando os campos obrigatórios definidos lá e o volume mínimo abaixo. Não inclui os outros 6 domínios, nem qualquer decisão de schema, API, cálculo de pontuação ou infraestrutura (ver "Fora de escopo" no ticket mestre).

## Volume mínimo para este domínio

| Entidade | Quantidade mínima |
|---|---|
| Concept | 5 |
| Slide | 15 (mínimo 3 por Concept) |
| Flashcard | 15 |
| Question | 18 (mínimo 6 fácil, 6 média, 6 difícil) |

## Critérios de aceite (instanciados para Segurança)

**Cobertura**
- Dado o domínio Segurança, quando o QA verifica se ele possui conteúdo, então existe pelo menos 1 Concept, 1 Slide, 1 Flashcard e 1 Question associados a ele.

**Volume mínimo**
- Dado o domínio Segurança, quando o QA conta os itens desse domínio, então existem no mínimo 5 Concepts, 15 Slides, 15 Flashcards e 18 Questions.
- Dado o domínio Segurança, quando o QA agrupa as Questions desse domínio por dificuldade, então existem no mínimo 6 questões `facil`, 6 `media` e 6 `dificil`.

**Slide**
- Dado qualquer Concept do domínio Segurança, quando o QA conta os Slides associados a esse Concept, então existem no mínimo 3.
- Dado qualquer Concept do domínio Segurança, quando o QA ordena os Slides associados pelo campo `ordem`, então os valores são sequenciais, únicos e começam em 1 (sem lacunas nem duplicatas) dentro daquele Concept.
- Dado qualquer Slide do domínio Segurança, quando o QA verifica os campos `titulo` e `conteudo`, então nenhum dos dois está vazio.

**Question e alternativas**
- Dado qualquer Question do domínio Segurança, quando o QA conta suas alternativas, então existem exatamente 4.
- Dado qualquer Question do domínio Segurança, quando o QA conta quantas alternativas estão marcadas como `correta`, então o resultado é exatamente 1 (nunca 0, nunca mais de 1).
- Dado qualquer Question do domínio Segurança, quando o QA verifica as 4 alternativas, então nenhuma tem texto vazio e não há duas com texto idêntico dentro da mesma questão.
- Dado qualquer Question do domínio Segurança, quando o QA verifica o campo `explicacao`, então ele não está vazio.
- Dado o domínio Segurança, quando o QA compara os `enunciado` de todas as Questions desse domínio, então não há dois enunciados idênticos.

**Flashcard**
- Dado qualquer Flashcard do domínio Segurança, quando o QA verifica `frente` e `verso`, então nenhum dos dois está vazio.
- Dado qualquer Flashcard ou Question do domínio Segurança, quando o QA verifica o campo `dificuldade`, então o valor é exatamente um entre `facil`, `media`, `dificil`.

**Rastreabilidade e associação**
- Dado qualquer Concept, Slide, Flashcard ou Question do domínio Segurança, quando o QA verifica sua associação de domínio (direta ou via `Concept`, no caso de Slide), então ela referencia exatamente o domínio Segurança (slug `seguranca`) — nenhum item órfão ou associado a outro domínio.
- Dado qualquer Slide do domínio Segurança, quando o QA verifica seu campo `concept_ref`, então ele referencia exatamente 1 Concept existente do domínio Segurança.
- Dado qualquer item de conteúdo do domínio Segurança, quando o QA verifica o campo `content_version`, então ele está preenchido e é igual ao identificador de versão do lote (ex.: `v1`).

**Status de revisão**
- Dado que este conteúdo foi rascunhado por IA, quando o QA verifica o campo `status_revisao` de qualquer item do domínio Segurança, então ele está preenchido e igual a `rascunho` — nenhum item deste ticket pode estar `revisado_aprovado` nesta entrega.

**Condição de aceite deste ticket:** todos os cenários acima passam para o domínio Segurança. Este ticket pode ser marcado como concluído independentemente do andamento dos outros 6 tickets de domínio.

## Riscos e perguntas específicas deste domínio

Nenhuma pendência específica identificada além das já registradas no ticket mestre (OPEN QUESTION-001 idioma do conteúdo, 002 critério de revisão humana, 003 obrigatoriedade de `concept_ref`, 004 tamanho de sessão de quiz). Consulte `docs/product/tickets/TICKET-content-database.md` para essas questões gerais.
