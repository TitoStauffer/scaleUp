---
name: design-system
description: Criação, estruturação e evolução de Design Systems para produtos digitais, incluindo tokens, fundamentos visuais, componentes, padrões, estados, acessibilidade, documentação, governança e consistência entre interfaces. Use quando o produto precisar de uma linguagem visual reutilizável, consistente e escalável.
---

# Design System

## Objective

Criar e evoluir um sistema de design que permita construir interfaces:

- consistentes;
- acessíveis;
- reutilizáveis;
- escaláveis;
- previsíveis;
- fáceis de manter.

Um Design System não é apenas uma biblioteca de componentes.

Ele é um sistema que conecta:

```text
Princípios
   ↓
Foundations
   ↓
Tokens
   ↓
Components
   ↓
Patterns
   ↓
Templates
   ↓
Experiences
```

O objetivo é reduzir decisões repetitivas sem impedir decisões específicas quando elas forem necessárias.

---

# Core Principles

## 1. System Before Screens

Não criar regras diferentes para cada tela quando existe um padrão reutilizável.

Perguntar:

> "Isso é uma decisão específica desta tela ou um padrão do produto?"

Se for padrão, deve potencialmente pertencer ao Design System.

---

## 2. Consistency With Purpose

Consistência não significa que tudo deve ser idêntico.

Elementos equivalentes devem ser consistentes.

Elementos com funções diferentes podem possuir tratamentos diferentes.

---

## 3. Reuse Before Reinvention

Antes de criar um novo componente:

```text
Existe componente equivalente?
        ↓
Pode ser reutilizado?
        ↓
Pode ser composto?
        ↓
Pode ser estendido?
        ↓
Só então criar algo novo
```

---

## 4. Accessibility by Default

Acessibilidade deve fazer parte do componente desde sua criação.

Não tratar acessibilidade como uma etapa posterior.

---

## 5. Tokens Over Hardcoded Values

Quando uma decisão visual se repete, transformá-la em token.

Evitar:

```text
padding: 17px
color: #3489FF
border-radius: 9px
```

espalhados arbitrariamente pelo produto.

Preferir:

```text
spacing.md
color.primary
radius.md
```

---

## 6. Semantic Over Cosmetic

Preferir nomes baseados em significado.

Ruim:

```text
blue-500
gray-700
```

Melhor quando apropriado:

```text
color.action.primary
color.text.primary
color.surface.default
color.border.subtle
```

Isso permite alterar a implementação sem alterar o significado.

---

# When to Use

Use esta Skill quando:

- o produto possui várias telas;
- existem componentes repetidos;
- diferentes times desenvolvem interfaces;
- existe inconsistência visual;
- o produto precisa escalar;
- frontend e design precisam compartilhar padrões;
- componentes precisam de documentação;
- existe necessidade de tokens;
- uma nova linguagem visual precisa ser estabelecida;
- um Design System existente precisa ser revisado.

---

# Inputs

Considerar:

### Product

- posicionamento;
- público;
- necessidades;
- prioridades.

### UX

- user flows;
- padrões de interação;
- necessidades de usuários;
- acessibilidade.

### Visual Design

- cores;
- tipografia;
- spacing;
- grid;
- iconografia;
- linguagem visual.

### UI

- componentes;
- estados;
- variações;
- padrões.

### Engineering

- stack;
- framework;
- arquitetura frontend;
- limitações técnicas;
- biblioteca de componentes existente.

---

# Design System Layers

Estruturar o sistema em camadas.

```text
Layer 1 — Principles
Layer 2 — Foundations
Layer 3 — Tokens
Layer 4 — Components
Layer 5 — Patterns
Layer 6 — Templates
Layer 7 — Guidelines
Layer 8 — Governance
```

---

# Layer 1 — Principles

Definir princípios que orientam decisões.

Exemplos:

```text
Clarity over decoration
Accessibility by default
Consistency over improvisation
Content before chrome
Progressive disclosure
Responsive by default
```

Os princípios devem ajudar a resolver conflitos.

---

# Layer 2 — Foundations

Definir os fundamentos visuais.

## Typography

- font family;
- sizes;
- weights;
- line heights;
- letter spacing.

## Color

- brand;
- semantic;
- neutral;
- surface;
- border;
- text.

## Spacing

- spacing scale;
- component spacing;
- layout spacing.

## Grid

- container;
- columns;
- gutters;
- breakpoints.

## Shape

- border radius;
- borders;
- stroke.

## Elevation

- shadows;
- layers;
- overlays.

## Iconography

- style;
- size;
- stroke;
- alignment.

---

# Layer 3 — Design Tokens

Tokens representam decisões reutilizáveis.

Exemplo:

```text
color.text.primary
color.text.secondary
color.text.disabled

color.surface.default
color.surface.raised

color.action.primary
color.action.primary.hover

color.status.success
color.status.warning
color.status.error

spacing.xs
spacing.sm
spacing.md
spacing.lg

radius.sm
radius.md
radius.lg

font.size.sm
font.size.md
font.size.lg
```

---

# Token Categories

Considerar:

```text
Color
Typography
Spacing
Sizing
Radius
Border
Shadow
Motion
Opacity
Z-index
Breakpoint
```

Não criar tokens simplesmente porque uma propriedade existe.

Criar tokens para decisões que precisam ser controladas ou reutilizadas.

---

# Primitive Tokens

Representam valores básicos.

Exemplo:

```text
blue.500
gray.700
spacing.4
radius.2
```

---

# Semantic Tokens

Representam intenção.

Exemplo:

```text
text.primary
text.secondary
surface.default
surface.elevated
action.primary
status.error
border.subtle
```

Preferir semantic tokens nos componentes.

---

# Component Tokens

Representam decisões específicas de componentes.

Exemplo:

```text
button.height
button.padding.horizontal
button.radius
button.icon.gap
```

Usar quando houver necessidade real de controlar o componente independentemente.

---

# Token Naming

Nomes devem ser:

- previsíveis;
- consistentes;
- semanticamente claros;
- fáceis de descobrir.

Evitar nomes como:

```text
blueThing
newGray
specialButton
finalPadding
```

Esses nomes envelhecem mal.

---

# Layer 4 — Components

Componentes representam unidades reutilizáveis.

Exemplos:

```text
Button
Input
Select
Checkbox
Radio
Switch
Tooltip
Modal
Drawer
Toast
Alert
Badge
Card
Table
Pagination
Tabs
Breadcrumb
Dropdown
Avatar
```

---

# Component Anatomy

Todo componente complexo deve possuir uma anatomia clara.

Exemplo:

```text
Button
├── Label
└── Icon
```

Ou:

```text
Card
├── Header
├── Content
└── Footer
```

Documentar regiões quando isso ajuda composição.

---

# Component Variants

Criar variantes quando houver diferenças semânticas reais.

Exemplo:

```text
Button
├── Primary
├── Secondary
├── Tertiary
└── Danger
```

Evitar criar variantes para diferenças puramente ocasionais.

---

# Component States

Componentes interativos devem definir estados.

Exemplo:

```text
Default
Hover
Focus
Pressed
Disabled
Loading
Selected
Error
Success
```

Definir apenas estados relevantes para cada componente.

---

# Component API

Para componentes implementados em código, definir uma API clara.

Exemplo conceitual:

```text
Button
├── variant
├── size
├── disabled
├── loading
├── icon
└── children
```

Evitar APIs extremamente flexíveis que permitam quebrar o padrão visual.

---

# Composition

Componentes devem poder ser combinados.

Exemplo:

```text
Form
├── FormField
│   ├── Label
│   ├── Input
│   └── ErrorMessage
└── Actions
```

Composição geralmente é preferível a criar componentes gigantes.

---

# Layer 5 — Patterns

Patterns representam soluções recorrentes para problemas de UX.

Exemplos:

```text
Search + Filters + Results
Create Form
Edit Form
Delete Confirmation
Empty State
Error Recovery
Pagination
Bulk Actions
Master / Detail
Multi-step Form
```

Pattern não é necessariamente um componente.

É uma combinação de componentes e comportamento.

---

# Components vs Patterns

### Component

Resolve uma unidade específica.

```text
Button
Input
Modal
```

### Pattern

Resolve uma tarefa recorrente.

```text
Delete Confirmation Flow
Search Results
Checkout
```

### Template

Define uma estrutura maior.

```text
Dashboard
Admin Page
Detail Page
```

Não confundir essas camadas.

---

# Layer 6 — Templates

Templates representam estruturas recorrentes de páginas.

Exemplos:

```text
List Page
Detail Page
Create Page
Edit Page
Dashboard
Settings
Authentication
```

Templates ajudam a manter consistência sem impedir customização necessária.

---

# Responsive Design System

Componentes devem possuir comportamento responsivo definido.

Considerar:

- sizing;
- spacing;
- stacking;
- wrapping;
- visibility;
- navigation;
- touch targets.

Não assumir que cada componente será simplesmente reduzido.

---

# Accessibility

Todo componente deve definir requisitos de acessibilidade.

Considerar:

### Keyboard

- Tab;
- Enter;
- Space;
- Escape;
- Arrow keys.

### Focus

- visible focus;
- focus order;
- focus management.

### Screen Reader

- semantic HTML;
- accessible name;
- roles;
- states;
- announcements.

### Visual

- contrast;
- text size;
- non-color indicators.

### Motion

- reduced motion;
- animation duration;
- unnecessary movement.

---

# Content Guidelines

Design System também pode estabelecer padrões de conteúdo.

Exemplos:

### Button

Preferir:

```text
Salvar pedido
```

a:

```text
Clique aqui
```

### Error

Preferir:

```text
Não foi possível salvar o pedido.
Tente novamente.
```

a:

```text
Erro!
```

### Empty State

Comunicar:

- situação;
- contexto;
- próximo passo.

---

# Component Documentation

Todo componente relevante deve possuir documentação.

Estrutura:

```text
Component
Purpose
Anatomy
Variants
States
Behavior
Accessibility
Content Guidelines
Responsive Behavior
Usage
Do
Don't
Examples
```

---

# Do / Don't

Exemplo:

```text
## Button

### Do

Use primary button para a ação principal.

### Don't

Use múltiplos primary buttons concorrendo na mesma região.
```

Documentar decisões evita interpretações diferentes.

---

# Usage Guidelines

Para cada componente, explicar:

- quando usar;
- quando não usar;
- como escolher variante;
- limitações;
- composição recomendada.

---

# Design Tokens Governance

Tokens devem possuir:

- naming convention;
- ownership;
- documentação;
- processo de alteração.

Evitar criação indiscriminada de tokens.

---

# Component Lifecycle

Componentes devem possuir ciclo de vida.

```text
Proposed
   ↓
Exploration
   ↓
Review
   ↓
Approved
   ↓
Implemented
   ↓
Documented
   ↓
Stable
   ↓
Deprecated
   ↓
Removed
```

---

# Contribution Model

Quando novos componentes forem propostos, analisar:

```text
Problema
   ↓
Existe solução?
   ↓
Existe componente equivalente?
   ↓
Pode compor componentes existentes?
   ↓
Existe necessidade recorrente?
   ↓
Novo componente
```

---

# Governance

Definir:

- quem pode criar componentes;
- quem revisa;
- quem aprova;
- como mudanças são comunicadas;
- como versões são controladas;
- como componentes deprecated são tratados.

---

# Breaking Changes

Uma mudança é potencialmente breaking quando altera:

- comportamento;
- API;
- estrutura;
- acessibilidade;
- visual esperado;
- tokens utilizados.

Breaking changes devem ser:

- identificadas;
- documentadas;
- comunicadas;
- planejadas.

---

# Versioning

Quando aplicável, utilizar versionamento para:

- componentes;
- tokens;
- APIs;
- documentação.

O objetivo é permitir evolução controlada.

---

# Deprecation

Antes de remover algo:

```text
Mark deprecated
      ↓
Document replacement
      ↓
Communicate migration
      ↓
Migration period
      ↓
Remove
```

Nunca remover silenciosamente um padrão amplamente utilizado.

---

# Design-to-Code Consistency

O Design System deve manter alinhamento entre:

```text
Figma / Design
       ↕
Design Tokens
       ↕
Component Library
       ↕
Production UI
```

Se o componente no design se comporta de maneira diferente do componente em código, existe uma dívida de consistência.

---

# Single Source of Truth

Definir claramente onde cada decisão vive.

Exemplo:

```text
Visual values
→ Tokens

Component behavior
→ Component documentation

UX patterns
→ Pattern documentation

Implementation
→ Component library
```

Evitar duplicação de regras.

---

# Design System vs Brand System

Não confundir:

### Brand System

Define:

- identidade;
- personalidade;
- marca;
- expressão.

### Design System

Define:

- interface;
- componentes;
- comportamento;
- padrões;
- acessibilidade;
- tokens.

Brand pode influenciar o Design System, mas não substituí-lo.

---

# Design System Audit

Periodicamente analisar:

### Consistency

Existem múltiplas versões do mesmo componente?

### Adoption

Os times realmente utilizam o sistema?

### Accessibility

Os componentes seguem requisitos de acessibilidade?

### Duplication

Existem componentes redundantes?

### Complexity

Existem variantes demais?

### Documentation

As regras estão claras?

### Technical Alignment

Design e código estão sincronizados?

---

# Maturity Model

Um Design System pode evoluir por níveis.

## Level 0 — Ad hoc

Cada tela é criada individualmente.

---

## Level 1 — Shared Styles

Existem padrões visuais básicos.

---

## Level 2 — Component Library

Componentes reutilizáveis existem.

---

## Level 3 — Design System

Tokens, componentes, patterns e documentação estão estruturados.

---

## Level 4 — Governed System

Existe:

- ownership;
- contribution model;
- versioning;
- governance;
- accessibility;
- métricas.

---

## Level 5 — Product Platform

O Design System funciona como uma plataforma compartilhada entre produtos e times.

---

# Metrics

Quando aplicável, acompanhar:

- adoption rate;
- component reuse;
- accessibility compliance;
- duplicate components;
- time to build;
- design-to-code consistency;
- number of deprecated components;
- contribution frequency.

Métricas devem servir para orientar evolução, não criar burocracia.

---

# Outputs

Quando aplicável, produzir:

```text
Design Principles
Foundations
Design Tokens
Component Inventory
Component Specifications
Patterns
Templates
Accessibility Guidelines
Content Guidelines
Documentation Structure
Governance Model
Contribution Model
Versioning Strategy
Deprecation Strategy
Audit Results
```

---

# Recommended Output Format

```text
## Design System

### Principles

...

### Foundations

#### Typography

...

#### Color

...

#### Spacing

...

#### Grid

...

### Tokens

...

### Components

...

### Patterns

...

### Templates

...

### Accessibility

...

### Documentation

...

### Governance

...

### Open Questions

...
```

---

# Quality Criteria

Um bom Design System:

- reduz inconsistência;
- facilita reutilização;
- possui regras claras;
- possui tokens coerentes;
- possui componentes bem definidos;
- possui estados;
- possui acessibilidade;
- possui documentação;
- permite composição;
- evita duplicação;
- possui governança;
- consegue evoluir;
- mantém alinhamento entre design e código.

---

# Anti-Patterns

## Component Explosion

Criar um componente para cada pequena diferença.

---

## Variant Explosion

```text
Button
├── Primary
├── PrimarySmall
├── PrimaryRounded
├── PrimaryRoundedSmall
├── PrimaryBlue
├── PrimaryBlueSmall
...
```

Isso indica que o sistema provavelmente está sendo modelado incorretamente.

---

## Token Explosion

Criar tokens para absolutamente cada valor.

---

## Generic Components

Criar componentes tão genéricos que ninguém sabe como utilizá-los corretamente.

---

## Design-Only System

Sistema existe no Figma, mas não existe no código.

---

## Code-Only System

Componentes existem no código, mas designers não possuem especificações correspondentes.

---

## No Governance

Qualquer pessoa cria novos componentes sem análise.

---

## No Documentation

Existe uma biblioteca, mas ninguém sabe quando utilizar cada componente.

---

## Copying Other Design Systems

Copiar um sistema famoso sem considerar:

- produto;
- usuários;
- contexto;
- tecnologia;
- necessidades específicas.

---

## Accessibility Later

Criar componentes primeiro e tentar "adicionar acessibilidade" depois.

---

# Design System Checklist

```text
[ ] Princípios definidos
[ ] Foundations definidos
[ ] Typography definida
[ ] Color system definido
[ ] Spacing definido
[ ] Grid definido
[ ] Iconography definida
[ ] Tokens definidos
[ ] Semantic tokens definidos
[ ] Component inventory definido
[ ] Variants definidas
[ ] States definidos
[ ] Accessibility definida
[ ] Patterns documentados
[ ] Templates definidos
[ ] Content guidelines definidas
[ ] Documentation definida
[ ] Governance definida
[ ] Contribution model definido
[ ] Versioning definido
[ ] Deprecation strategy definida
[ ] Design/code alignment validado
```

---

# Rule of Thumb

> **Um Design System não existe para limitar designers e desenvolvedores. Existe para evitar que eles precisem tomar a mesma decisão dezenas de vezes.**

Se uma decisão acontece repetidamente:

```text
Decisão repetida
      ↓
Padrão identificado
      ↓
Regra documentada
      ↓
Token / Component / Pattern
      ↓
Reutilização
```

---

# Final Principle

**Design System é infraestrutura de produto.**

Ele conecta:

```text
UX
 ↓
Visual Design
 ↓
Components
 ↓
Code
 ↓
Product
```

Um sistema saudável não tenta controlar tudo.

Ele estabelece **padrões fortes onde consistência importa e flexibilidade onde contexto importa**.

O objetivo final é simples:

> **Permitir que o time construa experiências melhores, mais rápido e com menos inconsistência.**
