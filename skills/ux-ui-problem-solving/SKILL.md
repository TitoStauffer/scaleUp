---
name: ux-ui-problem-solving
description: Investiga e resolve problemas de UX/UI de forma estruturada, transformando sintomas em problemas reais, identificando causas e hipóteses, explorando soluções, avaliando trade-offs e definindo formas de validação. Use quando houver fricção, abandono, baixa conversão, reclamações, confusão, inconsistências ou qualquer problema de experiência que ainda não tenha uma solução claramente definida.
---

# UX/UI Problem Solving

## Objective

Investigar problemas de experiência e interface de forma estruturada, evitando soluções prematuras.

A Skill deve transformar:

```text
Sintoma
   ↓
Problema
   ↓
Evidência
   ↓
Causa provável
   ↓
Hipóteses
   ↓
Soluções
   ↓
Trade-offs
   ↓
Protótipo
   ↓
Validação
   ↓
Decisão
```

O objetivo não é simplesmente "melhorar a UI".

É:

> **Entender por que o problema existe, qual intervenção tem maior potencial de resolvê-lo e como comprovar se a solução funcionou.**

---

# Core Principles

## 1. Sintoma ≠ Problema

Exemplo:

### Sintoma

> Muitos usuários abandonam o cadastro.

Isso não explica o problema.

Possíveis causas:

- formulário longo;
- campo difícil de preencher;
- mensagem de erro confusa;
- requisito inesperado;
- problema de confiança;
- performance;
- erro técnico;
- falta de informação;
- incompatibilidade mobile.

Nunca pular diretamente para a solução.

---

# 2. Evidence Before Solution

Antes de recomendar:

> "Vamos simplificar o formulário."

Perguntar:

- Existe evidência de que o formulário é o problema?
- Em qual etapa ocorre abandono?
- Quais usuários são afetados?
- Qual campo causa maior fricção?
- O problema ocorre em desktop ou mobile?
- O abandono ocorre após erro?
- Existe problema técnico?

Uma solução elegante para o problema errado continua sendo uma solução ruim.

---

# 3. Root Cause Over Surface Fix

Diferenciar:

```text
Symptom
   ↓
Immediate Problem
   ↓
Underlying Cause
   ↓
Systemic Cause
```

Exemplo:

```text
Usuário não conclui pagamento
        ↓
Erro durante checkout
        ↓
Feedback insuficiente
        ↓
Estado de integração não tratado
```

O problema visual pode ser apenas consequência.

---

# 4. Multiple Hypotheses

Problemas complexos raramente possuem uma única explicação.

Criar hipóteses concorrentes:

```text
H1 → formulário complexo
H2 → falta de confiança
H3 → erro técnico
H4 → preço inesperado
H5 → performance
```

Depois buscar evidências para diferenciá-las.

---

# 5. Optimize for User Outcome

A solução deve melhorar o resultado do usuário.

Não otimizar apenas:

- número de cliques;
- tempo de tela;
- conversão;
- métricas isoladas.

Considerar:

- sucesso;
- esforço;
- confiança;
- compreensão;
- erro;
- satisfação;
- acessibilidade;
- resultado real.

---

# 6. Constraints Are Part of the Problem

Considerar:

- regras de negócio;
- compliance;
- segurança;
- limitações técnicas;
- dados disponíveis;
- dependências;
- plataforma;
- orçamento;
- prazo;
- Design System.

Não propor uma solução que viola uma restrição conhecida.

---

# When to Use

Usar esta Skill quando:

- usuários reclamam de uma interface;
- existe abandono de fluxo;
- conversão está abaixo do esperado;
- usuários cometem muitos erros;
- uma tarefa parece difícil;
- existe confusão;
- existe baixa adoção;
- uma feature não está sendo utilizada;
- existe feedback contraditório;
- existe um problema recorrente de UX;
- uma solução atual não funciona;
- não está claro qual solução implementar;
- Product ou Engineering apresentam um problema sem solução definida.

---

# Inputs

Quando disponíveis:

- problema relatado;
- métricas;
- analytics;
- feedback;
- entrevistas;
- testes de usabilidade;
- screenshots;
- gravações;
- suporte;
- tickets;
- user journey;
- user flows;
- personas;
- requisitos;
- regras de negócio;
- arquitetura;
- restrições técnicas;
- design system;
- problemas conhecidos.

---

# Problem Solving Process

## Step 1 — Capture the Problem

Registrar o problema sem assumir solução.

### Ruim

> Precisamos colocar um tooltip.

### Melhor

> Usuários não compreendem o significado do campo "Tipo de operação".

A solução ainda não foi escolhida.

---

# Step 2 — Define the Problem Statement

Utilizar:

```text
[Usuário]
tem dificuldade em
[comportamento/tarefa]
porque
[problema observado]
resultando em
[impacto].
```

Exemplo:

```text
Operadores têm dificuldade em identificar
qual ação utilizar para corrigir uma transação
porque as opções possuem nomenclatura semelhante,
resultando em erros e retrabalho.
```

---

# Step 3 — Define the Desired Outcome

Perguntar:

> O que precisa melhorar?

Exemplos:

- aumentar conclusão;
- reduzir erros;
- reduzir tempo;
- melhorar compreensão;
- reduzir suporte;
- aumentar confiança;
- melhorar acessibilidade.

Definir resultado antes da solução.

---

# Step 4 — Establish Baseline

Quando houver dados, registrar:

```text
Current State

Task success:
72%

Abandonment:
28%

Average completion time:
4m 12s

Error rate:
17%
```

Não inventar métricas.

Quando não houver dados:

```text
Baseline:
Unknown
```

---

# Step 5 — Map the Problem

Localizar o problema dentro da jornada:

```text
Journey
   ↓
Stage
   ↓
Task
   ↓
Interaction
   ↓
Problem
```

Exemplo:

```text
Checkout
  ↓
Payment
  ↓
Card verification
  ↓
Validation error
  ↓
User abandonment
```

---

# Step 6 — Identify Evidence

Classificar evidências:

### Quantitative

- conversion;
- abandonment;
- completion;
- error rate;
- time;
- frequency;
- retention.

### Qualitative

- interviews;
- usability tests;
- support tickets;
- reviews;
- observations.

### Behavioral

- click patterns;
- navigation;
- rage clicks;
- repeated actions;
- backtracking.

### Technical

- API failures;
- latency;
- errors;
- timeouts;
- broken states.

---

# Step 7 — Separate Facts From Assumptions

Utilizar:

```text
Fact:
Usuários abandonam após o erro.

Assumption:
A mensagem de erro causa abandono.

Hypothesis:
Uma mensagem mais acionável reduzirá abandono.
```

Nunca promover uma hipótese a fato sem validação.

---

# Step 8 — Generate Hypotheses

Para cada hipótese:

```text
Hypothesis:
...

Evidence:
...

Expected behavior:
...

Potential impact:
...

Confidence:
High / Medium / Low
```

Exemplo:

```text
Hypothesis:
Usuários abandonam porque não sabem como recuperar do erro.

Evidence:
62% dos usuários que encontram o erro não tentam novamente.

Expected:
Mensagem com instrução de recuperação aumenta retry.

Confidence:
Medium.
```

---

# Step 9 — Identify Root Causes

Utilizar técnicas quando apropriado:

- 5 Whys;
- fishbone;
- causal mapping;
- journey analysis;
- task analysis;
- heuristic evaluation;
- funnel analysis.

Exemplo:

```text
Why?
Usuário abandona.

Why?
Não consegue concluir.

Why?
Pagamento retorna erro.

Why?
Erro não possui recuperação clara.

Why?
Estado de falha não foi projetado.
```

---

# Step 10 — Avoid False Root Causes

Não assumir:

> "Usuário é pouco técnico."

Questionar:

- A interface é clara?
- O conceito está explicado?
- O fluxo exige conhecimento prévio?
- Existe informação suficiente?
- O comportamento é previsível?

Problemas de UX frequentemente são atribuídos ao usuário quando deveriam ser investigados no sistema.

---

# Step 11 — Explore Solution Space

Criar múltiplas soluções.

Exemplo:

```text
Problem:
Usuários não entendem uma configuração.

Solution A:
Melhorar label.

Solution B:
Adicionar descrição contextual.

Solution C:
Reorganizar opções.

Solution D:
Simplificar configuração.

Solution E:
Alterar fluxo.
```

Não escolher a primeira ideia automaticamente.

---

# Step 12 — Evaluate Solutions

Para cada alternativa:

```text
Impact
Effort
Risk
Confidence
Accessibility
Technical Complexity
User Value
```

Uma matriz simples:

| Solution | Impact | Effort | Risk | Confidence |
|---|---:|---:|---:|---:|
| A | High | Low | Low | High |
| B | Medium | Low | Low | Medium |
| C | High | Medium | Medium | Medium |
| D | High | High | High | Low |

---

# Step 13 — Consider Trade-offs

Toda solução pode criar consequências.

Perguntar:

- O que melhora?
- O que piora?
- Quem se beneficia?
- Quem pode ser prejudicado?
- A complexidade aumenta?
- A acessibilidade melhora?
- A manutenção aumenta?
- Existe impacto em outros fluxos?

Documentar explicitamente.

---

# Step 14 — Select Intervention

Escolher com base em:

```text
Evidence
+
User Value
+
Impact
+
Feasibility
+
Risk
+
Confidence
```

Não escolher apenas porque:

> "fica mais bonito."

---

# Step 15 — Prototype the Solution

Quando houver incerteza significativa, prototipar antes de implementar.

Escolher fidelidade de acordo com o risco:

```text
Low uncertainty
→ Wireframe

Medium uncertainty
→ Interactive prototype

High uncertainty
→ High-fidelity prototype + usability testing
```

---

# Step 16 — Define Validation

Cada solução deve possuir uma forma de validação.

Exemplos:

### Usability

> 8 de 10 usuários concluem a tarefa sem assistência.

### Quantitative

> Reduzir abandono de 28% para abaixo de 20%.

### Error

> Reduzir taxa de erro em 30%.

### Qualitative

> Usuários conseguem explicar corretamente a diferença entre as opções.

Não inventar metas sem contexto.

---

# Step 17 — Run Experiment When Appropriate

Quando houver incerteza sobre impacto:

```text
Current
   ↓
Hypothesis
   ↓
Variant
   ↓
Experiment
   ↓
Measure
   ↓
Decision
```

Pode envolver:

- A/B test;
- usability test;
- prototype test;
- beta;
- phased rollout.

---

# Step 18 — Evaluate Results

Após validação:

```text
Hypothesis
   ↓
Evidence
   ↓
Result
   ↓
Decision
```

Possíveis decisões:

```text
Validated
Partially Validated
Invalidated
Inconclusive
```

---

# Step 19 — Learn and Iterate

Se a solução não resolver:

```text
Result
 ↓
What did we learn?
 ↓
Update hypothesis
 ↓
New solution
 ↓
Validate again
```

Falha de solução não significa necessariamente falha do processo.

Pode revelar uma hipótese incorreta.

---

# Problem-Solving Canvas

Quando útil:

```text
# UX/UI Problem Solving

## Problem
...

## User
...

## Context
...

## Desired Outcome
...

## Evidence
...

## Baseline
...

## Current Journey
...

## Problem Location
...

## Root Causes
...

## Hypotheses

### H1
...

### H2
...

## Constraints
...

## Solutions

### Solution A
...

### Solution B
...

### Solution C
...

## Trade-offs
...

## Selected Intervention
...

## Validation Plan
...

## Success Criteria
...

## Risks
...

## Open Questions
...

## Decision
...
```

---

# Problem Tree

Para problemas complexos:

```text
                 Main Problem
                      │
          ┌───────────┼───────────┐
          ↓           ↓           ↓
       Cause A     Cause B     Cause C
          │           │           │
       Factor A    Factor B    Factor C
```

Não confundir correlação com causalidade.

---

# Opportunity Mapping

Transformar problemas em oportunidades:

```text
Problem
   ↓
User Need
   ↓
Opportunity
   ↓
Potential Intervention
```

Exemplo:

```text
Problem:
Usuário não sabe se a operação foi concluída.

Need:
Ter confiança no resultado.

Opportunity:
Tornar o estado da operação claramente visível.

Interventions:
- confirmation state
- transaction status
- notification
```

---

# Prioritization

Quando existirem muitos problemas:

```text
Priority =
Impact × Frequency × Risk × Confidence
```

O cálculo é conceitual.

Não utilizar números artificiais para criar falsa precisão.

---

# UX Debt

Identificar problemas acumulados:

- padrões inconsistentes;
- fluxos duplicados;
- mensagens diferentes para o mesmo erro;
- componentes customizados;
- acessibilidade incompleta;
- navegação inconsistente;
- decisões temporárias que se tornaram permanentes.

Classificar:

```text
Immediate
Short Term
Long Term
```

---

# Cross-Functional Problems

Alguns problemas não são exclusivamente de UX.

Classificar:

```text
UX
UI
Frontend
Backend
Product
Data
Infrastructure
Integration
Business Rule
```

Exemplo:

```text
Problem:
Tela demora 8 segundos para responder.

Possibilities:
- UX feedback insuficiente
- frontend rendering
- backend latency
- external API
```

Não tentar resolver tudo como problema visual.

---

# Escalation

Quando o problema ultrapassar UX/UI:

```text
UX Problem
   ↓
Needs Product Decision
```

ou:

```text
UX Problem
   ↓
Needs Architecture Decision
```

ou:

```text
UX Problem
   ↓
Needs Backend Investigation
```

ou:

```text
UX Problem
   ↓
Needs Data Analysis
```

O agente deve sinalizar a necessidade de outro especialista.

---

# Confidence Levels

## High

Existe forte evidência.

## Medium

Existem sinais consistentes, mas falta validação.

## Low

É uma hipótese inicial.

Sempre explicitar confiança quando houver incerteza relevante.

---

# Anti-Patterns

Nunca:

- começar pela solução;
- assumir causa sem evidência;
- culpar o usuário;
- usar apenas opinião do designer;
- usar apenas analytics;
- ignorar evidências qualitativas;
- ignorar problemas técnicos;
- criar solução única sem explorar alternativas;
- confundir correlação com causalidade;
- inventar métricas;
- inventar evidências;
- usar A/B test para qualquer problema;
- prototipar sem uma pergunta;
- otimizar uma métrica destruindo a experiência;
- ignorar acessibilidade;
- ignorar trade-offs;
- transformar todo problema em redesign;
- tentar resolver problemas fora do escopo sem envolver o especialista adequado.

---

# Quality Criteria

Uma análise de problem solving deve ser:

- estruturada;
- baseada em evidências;
- orientada ao usuário;
- explícita sobre hipóteses;
- consciente das restrições;
- aberta a múltiplas soluções;
- orientada a impacto;
- validável;
- transparente sobre incerteza.

A solução final deve responder:

```text
Qual é o problema?
        ↓
Como sabemos?
        ↓
Por que ele acontece?
        ↓
Quais hipóteses existem?
        ↓
Quais soluções foram consideradas?
        ↓
Por que escolhemos esta?
        ↓
Como vamos validar?
```

---

# Outputs

Dependendo do contexto:

- UX problem statement;
- root cause analysis;
- hypothesis map;
- opportunity map;
- solution exploration;
- solution matrix;
- UX improvement plan;
- redesign strategy;
- validation plan;
- experiment proposal;
- UX debt backlog;
- decision record.

---

# Rule of Thumb

> **Não desenhe a solução até entender suficientemente o problema.**

E, principalmente:

> **Quando o problema é incerto, a próxima entrega não precisa ser código — pode ser evidência.**
