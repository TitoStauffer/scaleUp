---
name: ui-quality-review
description: Revisa a qualidade de interfaces implementadas comparando o resultado com UX/UI, design handoff, frontend UI specification e design system. Identifica divergências visuais, funcionais, responsivas, de acessibilidade e comportamento, prioriza problemas e produz recomendações acionáveis para correção.
---

# UI Quality Review

## Objective

Avaliar uma interface implementada para determinar se ela atende aos requisitos definidos por:

- UX;
- UI;
- Design System;
- Design Handoff;
- Frontend UI Specification;
- Accessibility;
- Responsive Design;
- Product Requirements.

O objetivo é identificar diferenças entre:

```text
Expected Experience
        ↓
Design Specification
        ↓
Frontend Implementation
        ↓
Quality Review
        ↓
Corrections
        ↓
Validation
```

A revisão deve responder:

> **A implementação reproduz corretamente a experiência projetada e atende aos requisitos funcionais, visuais, responsivos e de acessibilidade?**

---

# Core Principles

## 1. Compare Expected vs Actual

A revisão deve comparar:

```text
Expected
   ↕
Actual
```

Não avaliar a implementação apenas pelo gosto pessoal.

---

## 2. Behavior > Pixel Perfection

Diferenças visuais importam, mas problemas funcionais possuem prioridade maior.

Priorizar:

1. bloqueios de tarefa;
2. erros funcionais;
3. problemas de acessibilidade;
4. problemas de interação;
5. problemas responsivos;
6. problemas de hierarquia;
7. inconsistências visuais;
8. detalhes estéticos.

---

## 3. Evidence-Based Review

Cada finding deve possuir:

- evidência;
- localização;
- impacto;
- severidade;
- recomendação;
- confiança.

Evitar:

> "Não gostei."

Preferir:

> "O CTA primário possui a mesma hierarquia visual do CTA secundário, dificultando a identificação da ação principal."

---

## 4. Review the Whole Experience

Não revisar apenas uma screenshot.

Considerar:

```text
Entry
 ↓
Navigation
 ↓
Interaction
 ↓
Loading
 ↓
Success
 ↓
Error
 ↓
Exit
```

Quando esses estados estiverem disponíveis.

---

# When to Use

Usar esta Skill quando:

- uma feature foi implementada;
- uma tela está pronta para QA;
- existe uma implementação baseada em Figma;
- existe um protótipo implementado;
- houve alteração significativa de UI;
- existe suspeita de regressão;
- uma release está próxima;
- é necessário validar responsive;
- é necessário validar acessibilidade;
- é necessário validar Design System.

---

# Inputs

Quando disponíveis:

- implementação atual;
- screenshots;
- gravações;
- aplicação funcionando;
- design;
- protótipo;
- design handoff;
- frontend UI specification;
- design system;
- tokens;
- acceptance criteria;
- requisitos;
- user flow;
- resultados anteriores de QA;
- bugs conhecidos.

---

# Review Process

## Step 1 — Understand the Expected State

Antes da revisão, identificar:

- objetivo da tela;
- usuário;
- fluxo;
- comportamento esperado;
- componentes;
- estados;
- responsividade;
- acessibilidade;
- critérios de aceite.

---

# Step 2 — Establish the Baseline

Definir a fonte de verdade.

Prioridade recomendada:

```text
Product Requirements
        ↓
UX Decisions
        ↓
Design System
        ↓
Design Handoff
        ↓
Frontend Specification
        ↓
Implementation
```

Quando houver conflito, identificar explicitamente o conflito.

Não escolher silenciosamente uma interpretação.

---

# Step 3 — Review Structure

Verificar:

- layout;
- hierarquia;
- agrupamento;
- espaçamento;
- navegação;
- composição;
- presença dos elementos necessários.

Perguntar:

> A estrutura implementada corresponde à estrutura definida?

---

# Step 4 — Review Visual Design

Avaliar:

### Typography

- família;
- tamanho;
- peso;
- line-height;
- hierarquia;
- truncamento.

### Color

- background;
- text;
- border;
- action;
- feedback;
- states.

### Spacing

- padding;
- margin;
- gaps;
- section spacing.

### Shape

- border radius;
- borders;
- elevation;
- surfaces.

### Iconography

- tamanho;
- alinhamento;
- significado;
- consistência.

Não recomendar valores arbitrários quando existem tokens no Design System.

---

# Step 5 — Review Components

Verificar:

- componente correto;
- variant correta;
- size;
- estado;
- comportamento;
- composição;
- consistência.

Exemplo:

```text
Expected:
Button / Primary / Loading

Actual:
Button / Secondary / Default

Finding:
Component state mismatch.
```

---

# Step 6 — Review Interaction

Testar ou analisar:

- click;
- hover;
- focus;
- active;
- disabled;
- keyboard;
- touch;
- navigation;
- modal;
- dropdown;
- tabs;
- accordion;
- forms;
- confirmation;
- cancellation.

Perguntar:

> A interface responde como definido?

---

# Step 7 — Review States

Verificar quando aplicável:

```text
Default
Loading
Success
Error
Empty
Disabled
Selected
Expanded
Collapsed
Partial
```

Uma interface não deve ser considerada completa apenas porque o estado default está correto.

---

# Step 8 — Review Forms

Verificar:

- labels;
- required fields;
- input types;
- validation;
- errors;
- focus;
- submit;
- loading;
- success;
- retry;
- preservation of data.

Testar casos como:

```text
Valid
Invalid
Empty
Long value
Special characters
Duplicate value
Server error
```

---

# Step 9 — Review Error Handling

Verificar:

- mensagem;
- localização;
- clareza;
- recuperação;
- preservação de dados;
- retry;
- acessibilidade.

Problemas como:

```text
"Error"
"Something went wrong"
"Invalid request"
```

devem ser questionados quando não ajudam o usuário a resolver o problema.

---

# Step 10 — Review Loading

Avaliar:

- feedback imediato;
- skeleton;
- spinner;
- disabled state;
- conteúdo preservado;
- prevenção de ações duplicadas;
- timeout;
- retry.

Especialmente em operações assíncronas.

---

# Step 11 — Review Empty States

Verificar:

```text
Title
Description
Action
Context
```

Diferenciar corretamente:

```text
Empty
≠
Loading
≠
Error
≠
No Permission
```

---

# Step 12 — Review Responsive

Validar diferentes condições:

```text
Desktop
Tablet
Mobile
Small Mobile
```

Quando relevante:

- orientação;
- viewport estreito;
- viewport alto/baixo;
- zoom;
- text scaling.

Verificar:

- overflow;
- clipping;
- wrapping;
- navigation;
- tables;
- forms;
- modals;
- drawers;
- buttons;
- touch targets;
- spacing;
- typography.

---

# Step 13 — Review Accessibility

Verificar:

### Keyboard

- tab order;
- focus;
- focus visibility;
- keyboard interactions.

### Screen Readers

- labels;
- names;
- roles;
- state announcements;
- errors.

### Visual

- contrast;
- hierarchy;
- text scaling;
- zoom;
- color dependence.

### Motion

- unnecessary animation;
- reduced motion;
- transition behavior.

---

# Step 14 — Review Content

Verificar:

- textos;
- labels;
- spelling;
- terminology;
- formatting;
- localization;
- dates;
- numbers;
- currencies.

Também testar conteúdo extremo:

```text
Short
Normal
Long
Very long
Empty
```

---

# Step 15 — Review Data States

Quando houver dados:

```text
Complete data
Partial data
Missing data
Unexpected data
Null values
Long values
Large lists
```

Verificar se a interface continua utilizável.

---

# Step 16 — Review Navigation

Validar:

- links;
- routes;
- browser back;
- breadcrumbs;
- cancel;
- redirects;
- deep links;
- unsaved changes.

A navegação deve preservar contexto quando isso fizer parte da experiência esperada.

---

# Step 17 — Review Permissions

Verificar:

- authorized;
- unauthorized;
- forbidden;
- read-only;
- disabled;
- hidden actions.

A UI não deve sugerir ações que o usuário não pode executar sem uma razão clara.

---

# Step 18 — Review Design System Compliance

Verificar:

- tokens;
- components;
- variants;
- typography;
- spacing;
- colors;
- patterns;
- interaction conventions.

Identificar:

```text
Design System Component
        ↓
Expected Usage
        ↕
Actual Usage
```

Evitar customização desnecessária.

---

# Step 19 — Review Performance Perception

Não fazer profiling técnico profundo nesta Skill, mas avaliar experiência percebida:

- loading excessivo;
- layout shift;
- flickering;
- feedback tardio;
- imagens inadequadas;
- interações sem resposta.

Quando houver suspeita técnica, registrar como investigação.

---

# Step 20 — Review Analytics

Quando eventos forem especificados:

- evento dispara no momento correto;
- evento não dispara duplicadamente;
- propriedades estão corretas;
- eventos críticos não são omitidos.

Analytics faz parte da implementação quando explicitamente definido como requisito.

---

# Step 21 — Review Edge Cases

Sempre considerar:

```text
Empty
Error
Loading
Slow network
Offline
Timeout
Unauthorized
Forbidden
Not Found
Long content
Large dataset
Duplicate action
Expired session
Unexpected response
```

---

# Finding Classification

Classificar cada finding:

### Functional

Comportamento incorreto.

### UX

Experiência ou fluxo inadequado.

### Visual

Divergência visual.

### Accessibility

Problema de acessibilidade.

### Responsive

Problema em determinado viewport ou dispositivo.

### Design System

Uso incorreto ou inconsistente do sistema.

### Content

Problema de texto ou informação.

### Performance Perception

Problema percebido na velocidade ou resposta.

---

# Severity

## P0 — Blocker

Impede uma tarefa crítica ou causa consequência grave.

Exemplos:

- impossibilidade de concluir pagamento;
- perda de dados;
- ação destrutiva incorreta;
- bloqueio completo da funcionalidade.

---

## P1 — Critical

Impacta fortemente a utilização.

Exemplos:

- fluxo principal quebrado;
- erro grave de acessibilidade;
- interação fundamental incorreta.

---

## P2 — Major

Problema relevante, mas com workaround.

Exemplos:

- formulário confuso;
- responsive quebrado em uma condição importante;
- estado de erro inadequado.

---

## P3 — Minor

Problema de menor impacto.

Exemplos:

- espaçamento inconsistente;
- pequena divergência visual;
- detalhe de alinhamento.

---

## P4 — Polish

Melhoria estética ou refinamento.

Exemplos:

- microajuste;
- detalhe visual;
- pequena melhoria de consistência.

---

# Finding Format

Cada finding deve seguir:

```text
Finding:

ID:
UI-001

Category:
Accessibility

Severity:
P1

Location:
Customer form → Email field

Expected:
Field has accessible label.

Actual:
Input is visually labeled but lacks accessible name.

Impact:
Screen reader users cannot reliably identify the field.

Recommendation:
Associate the visible label with the input and expose an accessible name.

Confidence:
High.
```

---

# Visual Comparison

Quando existir design de referência:

```text
Expected
   ↕
Actual
```

Comparar:

- layout;
- dimensions;
- spacing;
- typography;
- colors;
- components;
- states;
- alignment;
- responsive behavior.

Não transformar pequenas diferenças de rendering em problemas automaticamente.

Priorizar diferenças perceptíveis e relevantes.

---

# Review Matrix

Quando útil:

| Area | Expected | Actual | Severity | Status |
|---|---|---|---|---|
| Layout | Two columns | Two columns | — | Pass |
| CTA | Primary | Secondary | P2 | Fail |
| Loading | Button loading | Spinner only | P2 | Fail |
| Mobile | Single column | Single column | — | Pass |
| Keyboard | Visible focus | No focus | P1 | Fail |

---

# Quality Gates

Uma feature pode ser considerada pronta quando:

### Functional

- [ ] Fluxo principal funciona.
- [ ] Estados críticos funcionam.
- [ ] Erros são recuperáveis.
- [ ] Ações críticas estão protegidas.

### UX

- [ ] Fluxo corresponde ao esperado.
- [ ] Hierarquia é clara.
- [ ] Feedback é compreensível.

### Visual

- [ ] Design System está sendo seguido.
- [ ] Componentes estão corretos.
- [ ] Hierarquia visual corresponde ao design.

### Responsive

- [ ] Desktop validado.
- [ ] Mobile validado.
- [ ] Sem overflow inesperado.

### Accessibility

- [ ] Keyboard navigation funciona.
- [ ] Focus é visível.
- [ ] Labels existem.
- [ ] Estados importantes são acessíveis.

---

# Pass / Fail Rules

Não considerar uma interface aprovada apenas porque:

- "parece boa";
- funciona no desktop;
- o happy path funciona;
- a screenshot parece próxima do Figma.

A aprovação deve considerar o escopo relevante da feature.

---

# Regression Review

Após correções:

```text
Finding
   ↓
Fix
   ↓
Targeted Validation
   ↓
Regression Check
   ↓
Pass
```

Uma correção não deve introduzir outro problema.

---

# Review Report

Quando solicitado um relatório:

```text
# UI Quality Review

## Feature
...

## Scope
...

## Baseline
...

## Overall Status
PASS / PASS WITH ISSUES / FAIL

## Summary
...

## Findings

### UI-001
Category:
Severity:
Location:
Expected:
Actual:
Impact:
Recommendation:
Confidence:

### UI-002
...

## Passed Areas

- Functional
- UX
- Visual
- Responsive
- Accessibility

## Failed Areas

- ...

## Priority Fixes

P0:
...

P1:
...

P2:
...

## Regression Risks
...

## Final Recommendation
...
```

---

# Status Definitions

## PASS

Nenhum problema relevante dentro do escopo.

## PASS WITH ISSUES

Existem problemas menores ou não bloqueantes.

## FAIL

Existe pelo menos um problema relevante que deve ser corrigido antes da próxima etapa.

---

# Anti-Patterns

Nunca:

- aprovar só pela aparência;
- comparar apenas screenshots;
- ignorar estados;
- ignorar mobile;
- ignorar acessibilidade;
- ignorar erros;
- considerar todo pixel diferente como bug;
- exigir pixel perfection sem justificativa;
- transformar preferência pessoal em finding;
- ignorar o contexto do Design System;
- corrigir diretamente sem registrar o problema;
- priorizar polish antes de problemas funcionais;
- testar apenas o happy path;
- assumir que "funciona no meu computador" significa qualidade.

---

# Quality Criteria

Uma UI Quality Review deve ser:

- objetiva;
- baseada em evidências;
- comparativa;
- priorizada;
- reproduzível;
- orientada ao usuário;
- consciente do Design System;
- responsiva;
- acessível;
- acionável.

O resultado deve permitir que Engineering saiba:

```text
What is wrong?
      ↓
Where?
      ↓
Why does it matter?
      ↓
How severe is it?
      ↓
What should change?
      ↓
How do we validate the fix?
```

---

# Outputs

Dependendo do contexto:

- UI quality review;
- visual QA;
- UX QA;
- accessibility QA;
- responsive QA;
- design compliance review;
- component compliance review;
- implementation findings;
- prioritized bug list;
- release readiness assessment.

---

# Rule of Thumb

> **A implementação não está pronta porque "parece igual ao design". Está pronta quando o comportamento, a experiência, a acessibilidade e a interface atendem ao contrato definido.**
