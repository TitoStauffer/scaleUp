# TICKET — Melhorias de UI/UX: navegação por tarefa, dashboard, seleção de escopo e remoção temporária do seletor de confiança

**Status:** pronto para Frontend Engineer implementar os itens fechados (seções 5–10); 3 Open Questions explícitas (seção 12) não bloqueiam o início, mas bloqueiam decisões pontuais marcadas no texto.
**Origem:** pedido direto do Tito (founder/dono do produto) + avaliação heurística da UI atual conduzida pelo Agente de UI/UX (seção 3).
**Depende de:** módulos Content, Study, Assessment, Progress e Identity já implementados (ver `docs/product/tickets/TICKET-assessment-progress.md`, `docs/product/tickets/TICKET-autenticacao.md`). Este ticket não altera regra de negócio nem contrato de API — onde a experiência exige dado que a API atual não expõe, isso é sinalizado como **necessidade**, não especificado como contrato técnico (papel do Backend Engineer).

---

## 1. Objetivo

Resolver 4 problemas de experiência apontados pelo Tito na interface atual do ScaleUp — (1) estudo/revisão/quiz vivem apenas como sub-abas de um domínio específico, sem existência própria na navegação; (2) não existe uma tela inicial com visão geral de progresso; (3) não é possível estudar/revisar/testar por um recorte menor que "domínio inteiro" nem cruzar todos os domínios de uma vez; (4) o seletor de confiança do quiz deve ser removido da tela, mantendo a lógica intacta — e, adicionalmente, registrar e resolver problemas de UX identificados pela avaliação heurística da interface atual.

## 2. Escopo

**Dentro:**
- Reestruturação da arquitetura de informação: navegação global orientada a tarefa (Estudar / Revisar / Quiz) além da navegação por domínio já existente.
- Nova tela inicial (dashboard) com resumo de progresso e atalhos.
- Novas telas de "seleção de escopo" para estudo, revisão e quiz (tudo / domínio / conceito, quando aplicável).
- Fluxo de "estudar tudo", "revisar tudo" e "quiz geral" cruzando domínios, usando apenas endpoints já existentes (ver seção 8 sobre a limitação técnica encontrada).
- Remoção do seletor de confiança **da UI** do quiz (não do código/lógica).
- Estados de loading/erro/vazio de cada tela nova.
- Critérios de aceite verificáveis.
- Achados adicionais de UX (heurística) e recomendações priorizadas.

**Fora:**
- Qualquer alteração de regra de negócio de pontuação, nível ou cálculo de progresso (já fechado em `TICKET-assessment-progress.md`).
- Contrato técnico detalhado de API (payloads, DTOs, status HTTP) — isso é decisão do Backend Engineer; este ticket apenas sinaliza necessidades de dado.
- Definição de algoritmo de repetição espaçada real (agendamento de "quando revisar X" não existe hoje no backend — ver Open Question A).
- Design system completo (tokens, paleta, tipografia) — fora do pedido do Tito; registrado apenas como nota de UX debt (seção 11).
- Remoção do componente de pontuação "Calibração de autoconfiança" do cálculo de progresso — isso é regra de negócio já fechada; só a UI do seletor de coleta muda.

## 3. Avaliação heurística da interface atual (contexto para as decisões)

| Área | Problema | Evidência | Severidade | Heurística afetada |
|---|---|---|---|---|
| Navegação | Estudo/Revisão/Quiz só existem como sub-abas de `/dominios/:slug` (`frontend/src/pages/DomainLayout.tsx`). O usuário sempre precisa escolher um domínio antes de decidir "o que fazer". | `DomainLayout.tsx` renderiza `NavLink` para Slides/Flashcards/Quiz/Progresso/Histórico como filhos de uma rota de domínio; não existe rota independente para essas ações. | High | Reconhecimento vs. memorização; Flexibilidade e eficiência de uso |
| Escopo de ação | Toda ação (estudar, revisar, quiz) sempre opera sobre **todo o conteúdo de um único domínio** — não há filtro por conceito/dificuldade na UI, embora o backend já suporte `dificuldade` para flashcards. | `frontend/src/api/dominios.ts` (`fetchFlashcards` sem parâmetro), `frontend/src/pages/QuizPage.tsx`, `frontend/src/pages/FlashcardsPage.tsx` | High | Flexibilidade e eficiência de uso; Controle e liberdade do usuário |
| Visão geral | `/` é apenas uma lista de cards de domínio sem métrica alguma; a tela mais "dashboard-like" (`/resultado-geral`) mostra só um número. Usuário não tem noção do que precisa fazer hoje. | `DomainListPage.tsx`, `ResultadoGeralPage.tsx` | High | Visibilidade do status do sistema |
| Cross-domínio | Não existe "estudar tudo"/"revisar tudo"/"quiz geral". Usuário com múltiplos domínios fracos precisa repetir manualmente o mesmo fluxo domínio por domínio. | Ausência de rota/tela correspondente; `POST /api/dominios/{dominioId}/sessoes` e `POST /api/sessoes/{sessaoId}/quiz-attempts` são inerentemente escopados a um domínio | Medium-High | Flexibilidade e eficiência de uso |
| Carga cognitiva | O seletor de confiança (1–5) aparece em toda questão do quiz, mesmo sendo opcional — soma uma decisão extra por questão sem uso visível pelo usuário hoje. | `QuizPage.tsx`, linhas 170–186 | Low-Medium (decisão de produto do Tito, não bug de usabilidade per se) | Design minimalista |
| Consistência | `ResultadoGeralPage` e a futura tela de dashboard descrevem o mesmo conceito ("meu progresso geral") em lugares diferentes, com nomenclaturas diferentes ("Domínios" vs "Resultado geral"). | `DomainListPage.tsx` linha 17 (`<Link to="/resultado-geral">Ver resultado geral</Link>`) | Medium | Consistência e padrões |
| Empty state | A Home não orienta o usuário sobre a próxima ação; é apenas uma grade de cards. | `DomainListPage.tsx` | Medium | Visibilidade do status do sistema; Ajuda e documentação |

**Confiança da avaliação:** Alta para os problemas estruturais (navegação, escopo, ausência de dashboard) — evidência direta no código. Baixa/Média para o impacto real da remoção do seletor de confiança na usabilidade, já que é uma decisão de produto do Tito, não um achado heurístico independente.

---

## 4. Decisão de arquitetura de informação (resolve os pedidos #1 e #3 do Tito)

**Pergunta:** as abas de domínio já atendem à intenção de "fluxos separados", ou é necessário promovê-los à navegação principal?

**Decisão: promover Estudar / Revisar / Quiz a itens de primeiro nível da navegação global**, mantendo a navegação por domínio (`/dominios/:slug`) como uma segunda forma de acesso (para quem já sabe exatamente qual domínio quer aprofundar).

**Por quê:** o pedido #3 do Tito ("estudar tudo", "revisar tudo", "quiz geral" cruzando domínios) é estruturalmente incompatível com a arquitetura atual, em que Estudar/Revisar/Quiz são sub-rotas de um domínio específico (`/dominios/:slug/...`) — não existe estado de "nenhum domínio selecionado ainda" nessa estrutura. Resolver #1 e #3 juntos com uma única mudança de IA é mais simples e mais consistente do que resolver #1 com uma mudança cosmética (deixar as abas "parecerem" mais separadas) e #3 com uma tela adicional avulsa. Segue o princípio de IA orientada a tarefa (seção 30 da skill `information-architecture`): perguntar primeiro "o que você quer fazer?", depois "sobre o quê?".

**Trade-off assumido:** existem agora duas portas de entrada para a mesma ação (ex.: fazer quiz de "Bancos de Dados" via `/quiz` → escolher domínio, ou via `/dominios/bancos-de-dados/quiz`). Isso é aceitável e até desejável — usuários que pensam em "o que fazer" e usuários que pensam em "qual domínio" são ambos válidos (ver seção 30 vs 31 da skill de IA) — desde que os dois caminhos levem à mesma experiência subjacente (reduz risco de duplicar lógica) e a nomenclatura seja idêntica nos dois lugares.

### Nova navegação global

```
Início      (/)                — dashboard
Estudar     (/estudar)         — seleção de escopo + sessão de estudo (slides)
Revisar     (/revisar)         — seleção de escopo + sessão de revisão (flashcards)
Quiz        (/quiz)            — seleção de escopo + tentativa de quiz
Domínios    (/dominios)        — lista de domínios (tela hoje em "/"), entrada alternativa orientada a entidade
```

`/dominios/:slug` continua existindo com suas 5 sub-abas (Slides | Flashcards | Quiz | Progresso | Histórico) — **não é removida**, apenas deixa de ser a única porta de entrada. Rotas atuais permanecem válidas (nenhum link quebrado).

---

## 5. Fluxos de usuário: escopo "tudo" vs. "individual"

### 5.1 Objetivo do usuário

```text
Usuário:
Candidato estudando para entrevista de System Design, já cadastrado e autenticado.

Objetivo:
Estudar, revisar ou treinar o conteúdo mais relevante no momento — às vezes um
domínio específico onde sabe que está fraco, às vezes "quero praticar tudo que
já vi hoje".

Critério de sucesso:
Consegue escolher o recorte certo (tudo, um domínio, ou um conceito) em no
máximo 2 decisões, sem se perder sobre em qual domínio ele está.
```

### 5.2 Happy path — modo "Estudar" (aplica-se de forma análoga a Revisar e Quiz)

```text
[Nav global: Estudar]
        ↓
[Tela: Escolher o que estudar]
   ├── "Estudar tudo"           → fila com todos os domínios que têm conteúdo
   └── "Escolher domínio"       → lista de domínios
                                    ↓
                              [Escolher domínio]
                                    ↓
                        "Todos os conceitos" ou "Escolher conceito"
                                    ↓
                              [Sessão de estudo]
                                    ↓
                              Slides do escopo escolhido
```

### 5.3 Fluxo "Estudar tudo" / "Revisar tudo" / "Quiz geral" (cross-domínio)

**Restrição técnica encontrada (ver seção 8 para detalhe):** `StudySession` e `QuizAttempt` são sempre escopados a um único domínio no backend atual (`POST /api/dominios/{dominioId}/sessoes`). Não existe hoje uma sessão ou tentativa verdadeiramente cross-domínio. Por isso, "tudo"/"geral" é implementado no MVP como uma **fila sequencial de sessões por domínio**, orquestrada no frontend, e não como uma única sessão mesclada — isso é possível com os endpoints já existentes, sem exigir mudança de backend.

```text
Usuário escolhe "Estudar tudo" / "Revisar tudo" / "Quiz geral"
        ↓
Sistema monta a fila com os domínios retornados por GET /api/dominios
        ↓
Para cada domínio da fila, em ordem:
   ↓
   Inicia sessão/tentativa desse domínio normalmente (mesmos endpoints de hoje)
   ↓
   Domínio sem conteúdo para o modo escolhido (ex.: 0 flashcards)?
       ├── Sim → pula automaticamente para o próximo domínio da fila (sem interromper o usuário)
       └── Não → usuário estuda/revisa/faz quiz normalmente nesse domínio
   ↓
   Ao concluir o domínio atual, tela intermediária:
   "Domínio X concluído (2 de 5) — [Próximo domínio] [Encerrar sessão de tudo]"
        ↓
Fila vazia → tela de conclusão: "Você concluiu [modo] em N domínios."
```

**Por que expor isso ao usuário (e não simular uma sessão única):** esconder que "tudo" é, por baixo, N sessões separadas seria enganoso se o usuário perceber inconsistências (ex.: nível recalculado domínio a domínio, não de uma vez). Mostrar "domínio 2 de 5" é honesto sobre o que está acontecendo e ainda assim entrega a experiência pedida (não ter que voltar à Home e escolher o próximo domínio manualmente).

**Necessidade sinalizada ao Backend (não especificada aqui):** uma versão futura mais "verdadeiramente unificada" de "quiz geral" — por exemplo, um único `QuizAttempt` com questões de múltiplos domínios misturadas, ou um endpoint agregador que devolva `resultado geral consolidado ao final da fila` sem o frontend precisar somar client-side — exigiria uma decisão de Backend/Architecture (o que é `domainRef` de uma tentativa mista? como fica o cálculo de `pontuacao_geral` por domínio?). Isso está fora do escopo deste ticket; a fila sequencial descrita acima é a solução do MVP com o backend atual.

### 5.4 Escolha de escopo menor que "domínio inteiro"

| Modo | Granularidade disponível hoje na API | Granularidade oferecida na UI (este ticket) |
|---|---|---|
| Estudar (slides) | `DomainDetail.conceitos[]` já vem estruturado por conceito (`frontend/src/api/types.ts`) | Domínio inteiro OU um conceito específico dentro do domínio |
| Revisar (flashcards) | Backend já aceita `?dificuldade=` em `GET /dominios/{slug}/flashcards`, não usado hoje no frontend | Domínio inteiro OU domínio + dificuldade (fácil/médio/difícil) |
| Quiz | `GET /dominios/{slug}/questoes` não expõe filtro por dificuldade nem por conceito hoje | Apenas domínio inteiro no MVP (ver Open Question C) |

Flashcards e Estudar ganham filtro de granularidade menor porque o dado já existe na API sem mudança de contrato. Quiz **não** ganha filtro de conceito/dificuldade neste ticket porque isso exigiria uma mudança de contrato do endpoint de questões (fora do escopo deste ticket — sinalizado como necessidade ao Backend, não especificado).

---

## 6. Tela: Início (Dashboard) — resolve o pedido #2

### 6.1 Propósito

Dar ao usuário, ao entrar no produto, uma resposta imediata para "onde eu estou" e "o que eu deveria fazer agora", substituindo a atual `DomainListPage` como rota `/`.

### 6.2 Estrutura

```
Início (/)
├── Cabeçalho: "Olá! Aqui está seu progresso."
├── Bloco: Resumo geral
│   (substitui a atual /resultado-geral — ver seção 6.3)
├── Bloco: Atalhos de ação
│   [Estudar]  [Revisar]  [Fazer quiz]
├── Bloco: Domínios em andamento
│   Lista compacta: nome do domínio + nível atual ou "em avaliação"
└── Bloco: Revisões pendentes (Open Question A — ver seção 12)
```

### 6.3 Bloco "Resumo geral" — fusão com `/resultado-geral`

A rota `/resultado-geral` deixa de ser uma tela isolada e seu conteúdo é incorporado ao dashboard (mesmos dados, mesmo endpoint: `GET /usuarios/{userId}/resultado-geral`). **Decisão:** manter a rota `/resultado-geral` funcionando como redirect para `/` (evita link quebrado caso exista algum bookmark), mas não deixar de exibir mais como página própria.

Estados:
- `avaliado: true` → número de `resultadoGeral` (2 casas decimais) + "Média entre N domínios avaliados." (igual ao texto já existente em `ResultadoGeralPage.tsx`).
- `avaliado: false` → mensagem existente: "Ainda não avaliado — conclua evidências suficientes (quiz e flashcards) em pelo menos um domínio para ver seu resultado geral." + CTA "Começar a estudar" apontando para `/estudar`.

### 6.4 Bloco "Domínios em andamento"

Lista cada domínio (via `GET /api/dominios`) com seu nível atual, obtido de `GET /dominios/{dominioId}/progresso` — **uma chamada por domínio**.

**Nota de performance sinalizada, não bloqueante:** com poucos domínios (MVP), N chamadas sequenciais/paralelas é aceitável. Se o número de domínios crescer, isso deve ser revisitado com o Backend (endpoint agregador tipo `GET /usuarios/{userId}/progresso-resumo` que devolva o progresso de todos os domínios em uma única chamada) — **sinalizado como necessidade futura, não especificado aqui.**

Cada item mostra: nome do domínio, e:
- `emAvaliacao: true` → badge "Em avaliação"
- `emAvaliacao: false` → nível atual (`nivelAtual`)

Clicar no item leva a `/dominios/:slug/progresso` (rota já existente).

### 6.5 Bloco "Revisões pendentes" — Open Question A

Ver seção 12. Este bloco **não deve ser implementado com uma métrica inventada**. Enquanto a Open Question A não for respondida, a tela deve:
- Renderizar o bloco com um estado "placeholder" neutro (ex.: "Em breve: veremos aqui quantas revisões você tem pendentes.") **ou**
- Omitir o bloco inteiramente da v1 do dashboard.

**Recomendação do UI/UX Agent:** omitir o bloco na v1 (mais simples, sem gerar expectativa de um número que ainda não existe) e adicionar quando a Open Question A for resolvida. Frontend Engineer deve implementar a Home **sem** este bloco até nova instrução; a estrutura de 4 blocos (6.2) passa a ter 3 blocos até lá.

### 6.6 Estados da tela

| Estado | Condição | Comportamento |
|---|---|---|
| Loading | Chamadas iniciais em andamento | Skeleton/mensagem de carregamento por bloco (ou global, decisão do Frontend Engineer) — nunca travar a tela inteira esperando o bloco mais lento (ex.: se "domínios em andamento" demorar, "resumo geral" já deve aparecer quando pronto) |
| Erro parcial | Um bloco falha, outro funciona | Cada bloco trata seu próprio erro independentemente (ex.: resumo geral falha mas domínios em andamento carrega normalmente) — usar o mesmo padrão de erro com "Tentar novamente" já usado em `RequestState.tsx`, aplicado por bloco |
| Vazio | Usuário sem nenhum domínio no sistema | "Nenhum domínio disponível no momento." (mensagem já usada em `DomainListPage.tsx`) |
| Vazio | Usuário com domínios mas nenhum avaliado ainda | Ver 6.3 (estado `avaliado: false`) |

---

## 7. Telas: Seleção de escopo (Estudar / Revisar / Quiz)

Uma tela por modo (`/estudar`, `/revisar`, `/quiz`), mesma estrutura, textos adaptados ao modo.

### 7.1 Estrutura (usando "Estudar" como exemplo — mesma estrutura para Revisar/Quiz)

```
/estudar
├── Título: "O que você quer estudar?"
├── Opção A: "Estudar tudo"
│   Descrição: "Percorra todos os seus domínios, um de cada vez."
│   CTA: [Começar]
└── Opção B: "Escolher domínio"
    ├── Lista/seletor de domínios (GET /api/dominios)
    └── Ao escolher um domínio:
        ├── "Todos os conceitos" (default, pré-selecionado)
        └── "Escolher conceito" → lista de conceitos do domínio (GET /dominios/{slug} → conceitos[])
    CTA: [Começar]
```

Para **Revisar**, o passo equivalente a "escolher conceito" é "escolher dificuldade" (opcional: Todas / Fácil / Médio / Difícil), usando o parâmetro `dificuldade` já suportado pelo backend.

Para **Quiz**, não há segundo nível de filtro no MVP (ver seção 5.4) — a tela tem apenas "Fazer quiz geral" e "Escolher domínio".

### 7.2 Interações

- Selecionar "Estudar tudo" / "Revisar tudo" / "Quiz geral" e clicar em "Começar" inicia o fluxo cross-domínio da seção 5.3.
- Selecionar "Escolher domínio" sem escolher um domínio específico mantém o botão "Começar" desabilitado (não há ação válida sem escopo definido).
- Escolher domínio + "Todos os conceitos"/dificuldade e clicar "Começar" leva à sessão single-domain — **reaproveita exatamente os componentes já existentes** (`DomainSlidesPage`, `FlashcardsPage`, `QuizPage`), apenas navegando para eles com o escopo escolhido, para não duplicar lógica já implementada.

### 7.3 Estados

| Estado | Comportamento |
|---|---|
| Loading (lista de domínios) | "Carregando domínios..." (mesmo padrão de `RequestState`) |
| Erro (lista de domínios) | Mensagem de erro + "Tentar novamente" (padrão já existente) |
| Vazio (nenhum domínio no sistema) | "Nenhum domínio disponível no momento." + esconder opção "Escolher domínio" (só "tudo" ficaria sem sentido também — nesse caso, a tela inteira deve comunicar que não há conteúdo, não apenas a sub-opção) |
| Domínio escolhido sem conceitos/flashcards/questões | Ao tentar "Começar", mostrar mensagem equivalente às já existentes ("Nenhum flashcard disponível para este domínio ainda.") antes de navegar, evitando entrar em uma tela vazia |

### 7.4 Acessibilidade

- Navegação por teclado entre as opções "tudo" / "escolher domínio" (usar `radiogroup` ou estrutura de abas acessível, não `div`s clicáveis sem semântica).
- O seletor de domínio e de conceito/dificuldade deve ser operável via teclado (select nativo ou listbox acessível).
- O botão "Começar" deve comunicar via `aria-disabled`/mensagem por que está desabilitado quando nenhum escopo foi escolhido.

---

## 8. Necessidade de dado sinalizada ao Backend (não especificada tecnicamente aqui)

Ao especificar o fluxo "tudo"/"geral" (seção 5.3), o UI/UX Agent identificou que a arquitetura atual não permite uma sessão ou tentativa verdadeiramente cross-domínio:

- `POST /api/dominios/{dominioId}/sessoes` sempre recebe um único `dominioId`.
- `QuizAttempt.domainRef` é sempre um único domínio (`frontend/src/api/types.ts`).

**Não estou propondo a solução técnica** (é decisão de Architecture/Backend), apenas registrando a limitação: se no futuro o produto quiser um "quiz geral" com uma única tentativa de questões misturadas de vários domínios (em vez da fila sequencial da seção 5.3), isso exigiria repensar o que `domainRef` significa para uma tentativa mista, e como isso se relaciona com o cálculo de `pontuacao_geral` por domínio (já fechado em `TICKET-assessment-progress.md`). A fila sequencial da seção 5.3 resolve o pedido do Tito com os endpoints de hoje, sem essa mudança.

Também sinalizado: um endpoint agregador de progresso por usuário (`GET /usuarios/{userId}/progresso-resumo` ou equivalente) reduziria as N chamadas do bloco "Domínios em andamento" (seção 6.4) — necessidade registrada, não bloqueante para este ticket.

---

## 9. Remoção do seletor de confiança do quiz — instrução explícita e não-ambígua

**Arquivo:** `frontend/src/pages/QuizPage.tsx`

**O que muda:** o bloco JSX abaixo (linhas ~170–186 na versão atual) deixa de ser renderizado na tela:

```tsx
<fieldset className="quiz-confianca" disabled={enviando}>
  <legend>Quão confiante você está nesta resposta? (opcional)</legend>
  ...
</fieldset>
```

**O que NÃO muda (deve permanecer exatamente como está):**
- O state `confiancas` (`useState<Record<string, number>>`, linha ~47).
- A construção do payload em `enviarQuiz()`, incluindo `confiancaDeclarada: confiancas[questao.id]` (linha ~71) — como o usuário nunca mais vai marcar um valor, `confiancas[questao.id]` será sempre `undefined`, e o payload deve continuar enviando `confiancaDeclarada: undefined` normalmente (o backend já trata esse campo como opcional — ver `TICKET-assessment-progress.md`, seção 5.2, "calibração... Volume mínimo: pelo menos 5 declarações... Abaixo disso, `pontuacao_calibracao = NULL`" — o componente de calibração simplesmente para de ser calculado, o que já é um comportamento suportado, não um caso de erro).
- Qualquer lógica de backend, DTO ou cálculo de progresso relacionados a confiança.

**Forma de implementação recomendada (mais limpa para religar depois):** envolver apenas o bloco JSX em uma constante local de flag, não um comentário de código morto:

```tsx
// Ticket UI/UX — seletor de confiança escondido da UI por decisão de produto (não é bug,
// não remover a lógica). Religar: trocar para `true`.
const EXIBIR_SELETOR_CONFIANCA = false;
```

```tsx
{EXIBIR_SELETOR_CONFIANCA && (
  <fieldset className="quiz-confianca" disabled={enviando}>
    ...
  </fieldset>
)}
```

Isso é preferível a comentar o bloco inteiro (fica menos legível e mais fácil de esquecer de remover o comentário depois) e preferível a um verdadeiro feature flag de configuração/ambiente (over-engineering para uma decisão que hoje é binária e sem necessidade de configuração por ambiente).

**Verificação de que nada mais na UI referencia confiança:** `FlashcardsPage.tsx` não possui, hoje, nenhum seletor de confiança visível (o campo `confiancaDeclarada` existe no tipo `RegistrarFlashcardReviewRequest` mas não é preenchido por nenhuma UI atual) — **nenhuma mudança necessária nesse arquivo**.

---

## 10. Componentes novos necessários (para o Frontend Engineer)

| Componente | Responsabilidade | Reaproveita |
|---|---|---|
| `DashboardPage` | Tela `/`, orquestra os blocos da seção 6 | `RequestState`, chamadas já existentes de `api/progresso.ts`, `api/usuarios.ts`, `api/dominios.ts` |
| `ResumoGeralCard` | Bloco "resumo geral" (seção 6.3) | Lógica hoje em `ResultadoGeralPage.tsx` (pode ser extraída para este componente e reaproveitada) |
| `AtalhosAcaoCard` | 3 CTAs (Estudar/Revisar/Quiz) | Novo, simples (links estilizados) |
| `DominiosEmAndamentoList` | Bloco "domínios em andamento" (seção 6.4) | Reaproveita padrão visual de `domain-grid`/`domain-card` já existente em `styles.css` |
| `EscolherEscopoPage` | Componente parametrizável por modo (`estudar`/`revisar`/`quiz`), tela da seção 7 | Novo — pode ser um único componente com prop `modo`, evitando 3 componentes quase idênticos |
| `FilaSequencialProvider`/hook equivalente | Orquestra a fila cross-domínio da seção 5.3 (estado: domínio atual, índice, avançar, encerrar) | Novo — decisão de implementação (context, hook, ou state local) é do Frontend Engineer |
| Ajuste em `QuizPage.tsx` | Esconder fieldset de confiança (seção 9) + aceitar navegação vinda da fila sequencial (CTA extra "Próximo domínio" na tela de resultado, ao lado de "Fazer nova tentativa", quando estiver dentro do fluxo "tudo") | Componente já existente |
| Ajuste em `FlashcardsPage.tsx` | Aceitar filtro de dificuldade (querystring ou prop) e tela intermediária "domínio concluído" quando dentro do fluxo "tudo" | Componente já existente |
| Ajuste em `DomainSlidesPage.tsx` | Aceitar deep-link direto para um conceito específico (vindo da seleção de escopo) e tela intermediária "domínio concluído" quando dentro do fluxo "tudo" | Componente já existente |
| Ajuste em `App.tsx` | Nova navegação global (seção 4) | Componente já existente (`app-header`) |
| Ajuste em `main.tsx` | Novas rotas `/estudar`, `/revisar`, `/quiz`, `/dominios` (mover `DomainListPage` de `/` para `/dominios`), redirect de `/resultado-geral` para `/` | Roteamento já existente |

---

## 11. Sugestões adicionais do UI/UX Agent (além dos 4 pedidos)

Estas não foram pedidas explicitamente pelo Tito, mas emergiram da avaliação heurística (seção 3). Priorizadas por impacto:

**P1 — Unificar nomenclatura "Domínios" vs "Resultado geral":** com a criação do dashboard, a antiga distinção confusa desaparece. Garantir que o texto de introdução da tela `/dominios` (hoje em `DomainListPage.tsx`, linha 13: "Escolha um domínio para estudar os slides, revisar flashcards e treinar com questões") seja atualizado para deixar claro que esta é a via "por domínio", já que agora existe a via "por tarefa" no dashboard/nav global — evita o usuário achar que são fluxos diferentes.

**P2 — Empty state orientador na Home:** ao invés de simplesmente listar domínios/mostrar zero, a Home deve sempre ter uma próxima ação clara mesmo no primeiro acesso (usuário sem nenhuma atividade ainda) — ex.: destacar o atalho "Estudar" com uma chamada tipo "Comece por aqui" quando `avaliado: false` e nenhum domínio tem qualquer evidência.

**P3 — Indicador de progresso na fila sequencial:** ao implementar "domínio 2 de 5" (seção 5.3), reaproveitar visualmente o padrão já usado em "Questão 1 de 10" (`QuizPage.tsx`, `quiz-counter`) para manter consistência de como o produto comunica progresso dentro de uma sequência.

**P4 (baixa prioridade, UX debt registrada, não escopo deste ticket):** o projeto não tem tokens de design (cores, espaçamento, tipografia) — todo o CSS é um arquivo monolítico (`styles.css`). Isso não bloqueia as mudanças deste ticket, mas deve ser considerado antes de qualquer expansão visual maior futura (ex.: se o dashboard crescer com gráficos/mais widgets). Registrado como nota, não como requisito deste ticket.

---

## 12. Open Questions

```
OPEN QUESTION-A

Question: O que exatamente conta como "revisão pendente" para o bloco da seção 6.5?
O backend hoje não tem nenhum campo de "próxima data de revisão" por flashcard/usuário —
não existe repetição espaçada real, apenas um registro de `FlashcardReview` por evento.
Possíveis proxies calculáveis com os dados de hoje: "domínios não revisados nos últimos N
dias", "domínios com `emAvaliacao=true` por falta de evidência de flashcard". Nenhuma
dessas é uma verdadeira "revisão pendente" no sentido de repetição espaçada.

Why It Matters: Inventar essa métrica sem decisão de produto cria uma expectativa errada
no usuário (ex.: um número de "pendências" que não significa o que ele imagina) e pode
exigir um endpoint/lógica de backend inteiramente novos (agendamento de repetição
espaçada) — decisão de escopo e prioridade, não de UX.

How To Answer: Tito decide se (a) omitimos o bloco na v1 (recomendação deste ticket,
seção 6.5), (b) aceitamos um proxy simples com os dados de hoje (qual?), ou (c) isso vira
um ticket separado de Product para desenhar repetição espaçada real antes de expor
qualquer número ao usuário.

Owner: Tito
Bloqueante: Não bloqueia o restante deste ticket — apenas o bloco 6.5 do dashboard, que
deve ser implementado como omitido até resposta.
```

```
OPEN QUESTION-B

Question: Quais "métricas de estudo" do usuário devem aparecer no dashboard além do
resultado geral já existente? (ex.: sequência de dias de estudo/streak, tempo total
estudado, número de sessões na semana). Nenhuma dessas métricas tem endpoint hoje —
o componente de "consistência" do cálculo de progresso (TICKET-assessment-progress.md,
seção 5.2) calcula "dias distintos com atividade" internamente, mas não expõe esse
número via API para exibição direta ao usuário.

Why It Matters: Adicionar uma métrica de estudo ao dashboard sem decisão de produto seria
inventar requisito de negócio (Golden Rule do Agente de UI/UX) — o valor e a forma de
exibição (streak visual, contador simples, gráfico de barras) mudam a percepção de
progresso do usuário e devem ser uma escolha deliberada, não uma inferência de UX.

How To Answer: Tito decide se quer adicionar alguma métrica de estudo específica ao
dashboard nesta v1 ou se o dashboard descrito na seção 6 (resumo geral + atalhos +
domínios em andamento) já é suficiente para a primeira entrega, deixando "métricas de
estudo" mais ricas para uma iteração futura.

Owner: Tito
Bloqueante: Não bloqueia a implementação da seção 6 como especificada (3 blocos, sem
métricas adicionais) — só bloqueia adicionar um 4º bloco de métricas extras.
```

```
OPEN QUESTION-C

Question: Vale a pena, em uma iteração futura, expor filtro de dificuldade/conceito
também no modo Quiz (hoje só Estudar e Revisar ganham granularidade menor que domínio
inteiro, seção 5.4), o que exigiria uma mudança de contrato em
`GET /dominios/{slug}/questoes` (parâmetro de filtro) e possivelmente em como o backend
sorteia as 10 questões de um `QuizAttempt` (regra já fechada em
TICKET-assessment-progress.md, seção 6.2)?

Why It Matters: É uma pergunta de escopo/prioridade que envolve mudança de contrato de
API e possivelmente a regra de seleção de questões já fechada — não é uma decisão de UX
isolada.

How To Answer: Não bloqueia este ticket (o MVP de Quiz fica só com granularidade de
domínio inteiro, seção 5.4). Se o Tito quiser essa granularidade, deve virar um ticket
separado de Backend + UI/UX.

Owner: Tito (prioridade) + Backend Engineer (viabilidade técnica)
Bloqueante: Não.
```

---

## 13. Critérios de aceite (Given/When/Then)

**AC-01 — Seletor de confiança some da tela, payload permanece intacto**
Dado um usuário respondendo uma questão do quiz,
Quando a tela é renderizada,
Então nenhum fieldset de "Quão confiante você está" aparece na tela, mas ao enviar o quiz o payload de submissão continua no mesmo formato de hoje (incluindo a chave `confiancaDeclarada`, que será `undefined` para todas as respostas).

**AC-02 — Navegação global expõe Estudar/Revisar/Quiz em qualquer tela**
Dado qualquer tela autenticada do produto,
Quando o usuário olha a navegação principal,
Então consegue acessar "Início", "Estudar", "Revisar", "Quiz" e "Domínios" sem precisar antes estar dentro de um domínio específico.

**AC-03 — Dashboard exibe resumo geral e atalhos**
Dado um usuário autenticado com pelo menos um domínio avaliado,
Quando ele acessa `/`,
Então vê seu resultado geral (mesmo dado de `GET /usuarios/{userId}/resultado-geral`) e os 3 atalhos de ação (Estudar/Revisar/Quiz).

**AC-04 — Dashboard sem nenhum domínio avaliado**
Dado um usuário autenticado sem nenhum domínio com `volume_minimo_atingido = true`,
Quando ele acessa `/`,
Então vê o estado "ainda não avaliado" (nunca um valor 0) com um CTA para começar a estudar.

**AC-05 — Seleção de escopo "tudo"**
Dado um usuário na tela `/estudar` (ou `/revisar` ou `/quiz`),
Quando ele escolhe "Estudar tudo" (ou equivalente) e confirma,
Então o sistema inicia a fila sequencial pelo primeiro domínio com conteúdo disponível, sem exigir escolha manual de domínio.

**AC-06 — Fila sequencial pula domínio sem conteúdo**
Dado um domínio sem nenhum flashcard cadastrado, dentro da fila de "Revisar tudo",
Quando a fila chega nesse domínio,
Então o sistema avança automaticamente para o próximo domínio da fila, sem interromper o usuário com uma tela vazia.

**AC-07 — Fila sequencial comunica progresso**
Dado um usuário dentro do fluxo "Quiz geral" com 5 domínios na fila,
Quando ele conclui o quiz do 2º domínio,
Então vê uma indicação clara de posição na fila (ex.: "Domínio 2 de 5 concluído") antes de decidir avançar ou encerrar.

**AC-08 — Escolha de domínio específico continua funcionando como hoje**
Dado um usuário que escolhe "Escolher domínio" em `/estudar`, seleciona um domínio e confirma,
Então a experiência de estudo desse domínio é idêntica à já existente em `/dominios/:slug` (sem regressão de comportamento).

**AC-09 — Filtro de dificuldade em Revisar**
Dado um usuário em `/revisar`, escolhendo um domínio específico,
Quando ele seleciona a dificuldade "Fácil" e confirma,
Então apenas flashcards com `dificuldade = 'facil'` desse domínio aparecem na sessão (usando o parâmetro já suportado pelo backend).

**AC-10 — Filtro de conceito em Estudar**
Dado um usuário em `/estudar`, escolhendo um domínio específico,
Quando ele seleciona um conceito específico e confirma,
Então a sessão de estudo mostra apenas os slides daquele conceito, não do domínio inteiro.

**AC-11 — Rotas antigas não quebram**
Dado um usuário com um link salvo para `/dominios/:slug/quiz` (comportamento hoje existente),
Quando ele acessa esse link,
Então a tela funciona exatamente como antes — nenhuma rota atual foi removida.

**AC-12 — Redirect de `/resultado-geral`**
Dado um usuário acessando `/resultado-geral` diretamente (link antigo),
Quando a página carrega,
Então ele é redirecionado para `/` (dashboard), onde o mesmo resultado geral está incorporado.

**AC-13 — Acessibilidade da tela de seleção de escopo**
Dado um usuário navegando por teclado em `/estudar`,
Quando ele usa Tab/Enter/setas para escolher entre "tudo" e "escolher domínio", selecionar um domínio e confirmar,
Então consegue completar o fluxo inteiro sem usar o mouse, com foco visível em cada etapa.

**AC-14 — Estado de erro por bloco no dashboard**
Dado que a chamada de progresso de um domínio específico falha no bloco "Domínios em andamento",
Quando isso acontece,
Então apenas aquele item/bloco mostra erro com opção de tentar novamente — o restante do dashboard (resumo geral, atalhos) continua funcional.

---

## 14. Definition of Done deste ticket

- [ ] Problema entendido e evidenciado (seção 3).
- [ ] Decisão de IA justificada, não apenas descrita (seção 4).
- [ ] Fluxos "tudo" vs "individual" mapeados com estados e casos de borda (seção 5).
- [ ] Dashboard especificado com estados de loading/erro/vazio (seção 6).
- [ ] Telas de seleção de escopo especificadas com estados e acessibilidade (seção 7).
- [ ] Necessidade de dado não coberta pela API atual sinalizada, não especificada tecnicamente (seção 8).
- [ ] Instrução de remoção do seletor de confiança inequívoca, sem tocar lógica/backend (seção 9).
- [ ] Componentes necessários listados para o Frontend Engineer (seção 10).
- [ ] Open Questions registradas em vez de decisões inventadas (seção 12).
- [ ] Critérios de aceite verificáveis (seção 13).
