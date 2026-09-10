---
name: ui-component-design
description: Design detalhado de componentes de interface, incluindo anatomia, propriedades, variantes, estados, comportamento, composição, responsividade, acessibilidade e especificações para implementação. Use quando uma interface precisar definir componentes reutilizáveis de forma precisa e consistente.
---

# UI Component Design

## Objective

Projetar componentes de interface reutilizáveis, previsíveis, acessíveis e consistentes com o Design System.

O objetivo é transformar padrões de interface em componentes suficientemente bem definidos para que:

- designers saibam como utilizá-los;
- desenvolvedores saibam como implementá-los;
- usuários tenham experiências consistentes;
- o produto consiga escalar sem duplicação desnecessária.

Um componente deve definir não apenas:

> "Como parece?"

mas também:

> "Como funciona?"

---

# Core Principles

## 1. Component Is a Contract

Um componente deve possuir um contrato claro.

Esse contrato define:

```text
Anatomy
+
Properties
+
Variants
+
States
+
Behavior
+
Accessibility
+
Responsive behavior
```

---

## 2. Behavior Is Part of the Component

Um botão não é apenas:

```text
[Salvar]
```

Ele também possui:

```text
Default
Hover
Focus
Pressed
Loading
Disabled
```

O comportamento faz parte do design.

---

## 3. Prefer Composition Over Complexity

Quando um componente começa a possuir muitas condições, avaliar se ele deveria ser composto por componentes menores.

Exemplo:

```text
Form
├── FormField
├── Input
├── HelperText
├── ErrorMessage
└── FormActions
```

é geralmente melhor que:

```text
MegaFormComponent
```

---

## 4. Variants Must Have Meaning

Criar variante quando existe uma diferença semântica ou comportamental real.

Não criar variantes simplesmente para acomodar pequenas diferenças visuais ocasionais.

---

## 5. Accessibility by Default

Acessibilidade deve fazer parte da especificação inicial.

Considerar:

- teclado;
- foco;
- semântica;
- screen readers;
- contraste;
- estados;
- tamanho dos alvos;
- mensagens;
- motion.

---

# When to Use

Use esta Skill quando:

- um novo componente precisa ser criado;
- um componente existente precisa ser revisado;
- uma interface possui componentes inconsistentes;
- um componente precisa de documentação;
- design e frontend precisam alinhar implementação;
- uma nova variante está sendo proposta;
- um componente possui comportamento complexo;
- estados precisam ser definidos;
- acessibilidade precisa ser especificada.

---

# Inputs

Considerar:

### Design System

- tokens;
- foundations;
- componentes existentes;
- guidelines.

### UX

- user flows;
- padrões de interação;
- necessidades;
- pain points.

### Wireframes

- estrutura;
- conteúdo;
- composição.

### Interaction Design

- estados;
- comportamentos;
- feedbacks;
- transições.

### Technical

- framework;
- limitações;
- arquitetura frontend;
- APIs;
- componentes existentes.

---

# Component Anatomy

Todo componente deve possuir anatomia clara.

Exemplo:

```text
Button
├── Leading Icon
├── Label
└── Trailing Icon
```

Outro:

```text
Input
├── Label
├── Input Field
├── Helper Text
└── Error Message
```

Outro:

```text
Card
├── Header
├── Content
└── Footer
```

A anatomia ajuda a definir:

- composição;
- espaçamento;
- comportamento;
- acessibilidade.

---

# Component Responsibility

Definir claramente o que o componente faz.

Exemplo:

```text
Button

Responsibility:
Disparar uma ação.

Não é responsabilidade do Button:
- validar formulário;
- executar regra de negócio;
- navegar diretamente;
- controlar estado global.
```

O componente deve possuir uma responsabilidade coerente.

---

# Component API

Para componentes implementados em código, definir propriedades de forma explícita.

Exemplo:

```text
Button
├── variant
├── size
├── disabled
├── loading
├── icon
└── children
```

Cada propriedade deve ter significado claro.

---

# Property Design

Para cada propriedade, definir:

```text
Name
Type
Required?
Default
Purpose
Allowed values
Behavior
```

Exemplo:

```text
variant

Type:
enum

Values:
primary | secondary | tertiary | danger

Default:
primary

Purpose:
Define a hierarquia da ação.
```

---

# Avoid Boolean Explosion

Evitar componentes com dezenas de flags.

Exemplo problemático:

```text
showIcon
showLabel
isRounded
isCompact
isBlue
isLarge
isSpecial
hasBorder
```

Isso normalmente indica que o componente está tentando resolver problemas demais.

Preferir propriedades semânticas e composição.

---

# Variants

Variantes devem representar diferenças significativas.

Exemplo:

```text
Button
├── Primary
├── Secondary
├── Tertiary
└── Danger
```

---

# Sizes

Quando apropriado:

```text
Small
Medium
Large
```

O tamanho deve possuir uso definido.

Não criar:

```text
Tiny
Small
SmallCompact
Medium
MediumLarge
Large
Huge
```

sem necessidade real.

---

# States

Definir os estados relevantes.

Exemplo:

```text
Default
Hover
Focus
Pressed
Disabled
Loading
Success
Error
Selected
```

Nem todo componente precisa de todos.

---

# State Matrix

Para componentes complexos, criar uma matriz.

| State | Visual | Interaction | Accessibility |
|---|---|---|---|
| Default | Normal | Enabled | Standard |
| Hover | Highlight | Enabled | — |
| Focus | Focus ring | Keyboard ready | Focus visible |
| Disabled | Reduced emphasis | Blocked | Disabled |
| Loading | Progress indicator | Blocked | Busy |
| Error | Error styling | Retry possible | Error announced |

Isso evita estados esquecidos.

---

# Interactive Behavior

Documentar:

```text
Trigger
↓
Action
↓
System response
↓
New state
↓
Feedback
```

Exemplo:

```text
Button click
    ↓
Submit request
    ↓
Loading
    ↓
Success
```

Ou:

```text
Button click
    ↓
Submit request
    ↓
Loading
    ↓
Error
    ↓
Retry
```

---

# Loading Behavior

Definir:

- o conteúdo permanece visível?
- aparece spinner?
- botão fica disabled?
- usuário pode cancelar?
- múltiplos submits são bloqueados?
- existe timeout?
- o resultado é comunicado?

---

# Error Behavior

Definir:

- onde o erro aparece;
- como o usuário entende o problema;
- se os dados são preservados;
- se existe retry;
- como o foco se comporta;
- se o componente continua utilizável.

---

# Success Behavior

Nem toda operação precisa de uma animação.

Definir quando apropriado:

```text
Success
→ visual state
→ message
→ next action
```

---

# Disabled vs Read-only

Não confundir.

### Disabled

Usuário não pode interagir.

### Read-only

Usuário pode visualizar, mas não alterar.

O significado e o comportamento são diferentes.

---

# Accessibility

## Semantic HTML

Utilizar elementos semânticos sempre que possível.

Exemplo:

```text
button
```

para ações.

Não transformar:

```text
div
```

em botão sem necessidade.

---

## Keyboard

Definir:

- Tab;
- Enter;
- Space;
- Escape;
- Arrow keys quando aplicável.

---

## Focus

Definir:

- focus visible;
- focus order;
- focus trap quando necessário;
- focus restoration.

---

## Screen Reader

Considerar:

- accessible name;
- role;
- state;
- value;
- description;
- announcements.

---

## Color

Nunca depender exclusivamente de cor.

---

# Touch

Para componentes mobile:

- tamanho do alvo;
- espaçamento entre ações;
- comportamento de toque;
- gesture conflicts;
- keyboard virtual.

---

# Responsive Behavior

Definir o que acontece em diferentes tamanhos.

Exemplo:

```text
Desktop
[Icon] [Label]

Mobile
[Icon]
```

Ou:

```text
Desktop
Button Group

Mobile
Stacked Buttons
```

Não assumir que responsividade é apenas reduzir largura.

---

# Content

Componentes devem funcionar com conteúdo real.

Testar:

```text
Texto curto
Texto médio
Texto muito longo
Número grande
Idioma diferente
Nome extenso
Mensagem de erro longa
```

---

# Localization

Quando aplicável, considerar:

- textos maiores;
- formatos de data;
- moedas;
- números;
- pluralização;
- idiomas RTL.

Evitar componentes que dependam de largura fixa para funcionar.

---

# Long Content

Testar situações como:

```text
"Este é um texto extremamente longo..."
```

Verificar:

- wrapping;
- truncation;
- tooltip;
- expansion;
- overflow.

Nunca truncar informação importante sem fornecer uma forma de acessar o conteúdo completo.

---

# Component Composition

Exemplo:

```text
FormField
├── Label
├── Input
├── HelperText
└── ErrorMessage
```

O FormField pode controlar a relação entre esses elementos sem transformar todos eles em um único componente indivisível.

---

# Compound Components

Para componentes complexos, considerar composição explícita.

Exemplo:

```text
Modal
├── Modal.Header
├── Modal.Body
└── Modal.Footer
```

Isso permite flexibilidade mantendo estrutura conhecida.

---

# Component Boundaries

Definir quando algo deve ser:

```text
Component
Pattern
Template
Page
```

Exemplo:

```text
Button
→ Component

Search + Filters + Table
→ Pattern

Admin List Page
→ Template

Customer Management
→ Page
```

---

# Design Tokens

Componentes devem utilizar tokens existentes.

Exemplo:

```text
Button

height:
button.height

padding:
button.padding.horizontal

radius:
button.radius

color:
action.primary
```

Evitar valores arbitrários.

---

# Visual Specifications

Quando necessário, documentar:

```text
Typography
Spacing
Color
Border
Radius
Shadow
Icon
Alignment
```

Mas preferir referências aos tokens em vez de valores isolados.

---

# Component States and Tokens

Estados devem utilizar tokens semânticos.

Exemplo:

```text
Button Primary
├── Default → action.primary
├── Hover → action.primary.hover
├── Focus → focus.default
├── Disabled → action.disabled
└── Loading → action.primary
```

---

# Motion

Quando houver animação, definir:

- trigger;
- duration;
- easing;
- purpose;
- reduced-motion behavior.

Motion deve comunicar mudança.

Não deve bloquear o usuário.

---

# Overlay Components

Para:

- Modal;
- Drawer;
- Popover;
- Tooltip;
- Dropdown.

Definir:

- trigger;
- positioning;
- layering;
- closing;
- Escape;
- outside click;
- focus;
- scroll behavior;
- mobile behavior.

---

# Modal Specification

Exemplo:

```text
Open
↓
Focus moves into modal
↓
User interacts
↓
Escape / Cancel / Success
↓
Modal closes
↓
Focus returns to trigger
```

---

# Tooltip Specification

Tooltip não deve ser a única forma de acessar informação essencial.

Considerar:

- hover;
- focus;
- touch;
- keyboard;
- delay;
- positioning.

---

# Tables and Data Components

Componentes de dados devem considerar:

- sorting;
- filtering;
- pagination;
- selection;
- bulk actions;
- loading;
- empty;
- error;
- responsive behavior.

---

# Forms Components

Para inputs:

```text
Label
Field
Helper
Error
Required indicator
Disabled
Read-only
Loading
```

A relação semântica entre esses elementos deve ser preservada.

---

# Destructive Components

Componentes relacionados a ações destrutivas devem deixar claro:

- ação;
- consequência;
- estado;
- possibilidade de undo;
- confirmação quando necessário.

---

# Component Documentation

Cada componente deve possuir:

```text
## Purpose

## Anatomy

## Variants

## Properties

## States

## Behavior

## Accessibility

## Responsive

## Content Guidelines

## Do

## Don't

## Examples
```

---

# Do / Don't

## Do

```text
Use Primary Button para a ação principal.
```

## Don't

```text
Use vários Primary Buttons concorrendo na mesma área.
```

---

# Implementation Handoff

Quando o componente estiver pronto para frontend, produzir uma especificação suficientemente clara para implementação.

Exemplo:

```text
Component:
Button

Variants:
Primary
Secondary
Danger

Sizes:
Small
Medium
Large

States:
Default
Hover
Focus
Pressed
Disabled
Loading

Behavior:
Loading blocks repeated submission.

Accessibility:
Keyboard accessible.
Visible focus.
Accessible name required.

Responsive:
Same component across breakpoints.

Tokens:
Use button.* and semantic color tokens.
```

---

# Component Review

Antes de aprovar um componente:

### Necessity

O componente realmente precisa existir?

### Reuse

Existe um componente equivalente?

### Responsibility

A responsabilidade está clara?

### Variants

As variantes possuem significado?

### States

Os estados importantes foram definidos?

### Accessibility

Acessibilidade está especificada?

### Responsive

O comportamento responsivo está definido?

### Content

O componente funciona com conteúdo real?

### API

A API é simples?

### Composition

Pode ser composto com outros componentes?

---

# Quality Criteria

Um componente bem projetado:

- possui responsabilidade clara;
- possui API simples;
- possui variantes justificadas;
- possui estados definidos;
- possui comportamento previsível;
- é acessível;
- é responsivo;
- suporta conteúdo real;
- utiliza tokens;
- é reutilizável;
- pode ser composto;
- possui documentação;
- pode ser implementado sem ambiguidades significativas.

---

# Anti-Patterns

## God Component

Um componente responsável por tudo.

---

## Boolean Explosion

Muitas propriedades booleanas tentando controlar todas as combinações possíveis.

---

## Variant Explosion

Uma variante nova para cada pequena diferença.

---

## Hardcoded Design

Valores visuais arbitrários espalhados pelo componente.

---

## Inaccessible Component

Componente visualmente correto, mas impossível de utilizar via teclado ou screen reader.

---

## Hidden Behavior

Comportamentos importantes não documentados.

---

## Desktop Only

Componente projetado sem considerar touch ou telas menores.

---

## Content Fragility

Componente que quebra quando o texto cresce.

---

## Duplicate Components

Criar um novo componente quando já existe solução equivalente.

---

## Generic Everything

Componentes tão abstratos que se tornam difíceis de entender e utilizar.

---

# Component Checklist

```text
[ ] Purpose definido
[ ] Responsibility definida
[ ] Anatomy definida
[ ] Properties definidas
[ ] Variants justificadas
[ ] Sizes definidos
[ ] States definidos
[ ] Behavior definido
[ ] Loading definido
[ ] Error definido
[ ] Success definido quando aplicável
[ ] Accessibility definida
[ ] Keyboard definida
[ ] Focus definido
[ ] Responsive definido
[ ] Touch considerado
[ ] Long content testado
[ ] Localization considerada
[ ] Tokens utilizados
[ ] Documentation criada
[ ] Do/Don't definidos
[ ] Implementation handoff preparado
```

---

# Rule of Thumb

> **Se o desenvolvedor precisa perguntar "o que acontece nesse estado?", o componente ainda não está suficientemente especificado.**

Um componente bom responde claramente:

```text
Como parece?
Como funciona?
Quais estados possui?
Quais variantes existem?
Como o usuário interage?
Como funciona no teclado?
Como funciona no mobile?
Como deve ser implementado?
```

---

# Final Principle

**Um componente não é apenas uma peça visual.**

Ele é um contrato entre:

```text
UX
 ↓
Design
 ↓
Design System
 ↓
Frontend
 ↓
Usuário
```

Quanto mais claro esse contrato, menor a quantidade de interpretação necessária durante a implementação.

E quanto menos interpretação, **menos inconsistência e menos retrabalho.** 🚀
