---
name: responsive-design
description: Design responsivo de interfaces digitais para diferentes tamanhos de viewport, dispositivos e contextos de uso. Define breakpoints, adaptação de layout, conteúdo, componentes, navegação, densidade, touch interactions e estratégias mobile-first. Use quando uma interface precisar funcionar de forma consistente e adequada em desktop, tablet e mobile.
---

# Responsive Design

## Objective

Projetar interfaces que se adaptem adequadamente a diferentes:

- tamanhos de tela;
- orientações;
- dispositivos;
- métodos de entrada;
- densidades de informação;
- contextos de uso.

O objetivo não é fazer uma interface simplesmente "encolher".

O objetivo é garantir que:

```text
Desktop
   ↓
Tablet
   ↓
Mobile
```

continuem oferecendo uma experiência coerente, compreensível e eficiente.

Responsive Design deve adaptar:

- layout;
- conteúdo;
- navegação;
- componentes;
- hierarquia;
- interação;
- densidade;
- ações;
- comportamento.

---

# Core Principles

## 1. Content First

Breakpoints devem ser determinados principalmente pelo conteúdo.

Não começar com:

```text
Desktop = 1440px
Tablet = 768px
Mobile = 375px
```

e simplesmente adaptar tudo.

Perguntar:

> "Em que momento este layout deixa de funcionar?"

Esse ponto é mais importante que um dispositivo específico.

---

## 2. Responsive Is More Than Width

Responsividade envolve:

```text
Viewport
+
Input
+
Context
+
Content
+
Interaction
```

Uma experiência pode precisar se adaptar devido a:

- largura;
- altura;
- touch;
- teclado;
- orientação;
- densidade;
- capacidade do dispositivo.

---

## 3. Mobile Is Not a Smaller Desktop

Mobile possui restrições diferentes.

Uma interface mobile pode precisar:

- remover conteúdo secundário;
- reorganizar ações;
- alterar navegação;
- transformar tabelas;
- trocar sidebar por drawer;
- empilhar campos;
- utilizar bottom navigation;
- alterar prioridades.

Não simplesmente reduzir dimensões.

---

## 4. Preserve User Intent

Quando o layout muda, a intenção da tarefa deve permanecer.

Exemplo:

```text
Desktop:
Filtros na sidebar

Mobile:
Filtros em drawer
```

A implementação mudou.

A tarefa não.

---

## 5. Progressive Disclosure

Quando não houver espaço suficiente:

```text
Informação principal
        ↓
Informação secundária
        ↓
Informação sob demanda
```

Não tentar colocar tudo na tela.

---

# When to Use

Use esta Skill quando:

- uma nova interface precisa funcionar em mobile;
- um produto desktop precisa ganhar versão mobile;
- uma tela possui problemas de responsividade;
- componentes precisam definir comportamento por breakpoint;
- layouts complexos precisam ser adaptados;
- tabelas precisam funcionar em telas pequenas;
- navegação precisa mudar entre dispositivos;
- touch e mouse possuem comportamentos diferentes.

---

# Inputs

Considerar:

### UX

- personas;
- user journeys;
- user flows;
- contexto de uso;
- frequência de tarefas.

### Information Architecture

- navegação;
- hierarquia;
- conteúdo;
- prioridade.

### Wireframes

- estrutura;
- layout;
- componentes.

### Interaction Design

- estados;
- interações;
- feedback;
- comportamento.

### Visual Design

- grid;
- spacing;
- typography;
- hierarchy.

### Design System

- tokens;
- breakpoints;
- components;
- patterns.

### Technical

- framework;
- browser support;
- performance;
- device constraints.

---

# Responsive Strategy

Antes de adaptar uma tela, identificar:

```text
Primary task
Secondary task
Primary content
Secondary content
Primary action
Secondary actions
Critical information
Optional information
```

Depois definir como cada item se comporta em diferentes contextos.

---

# Breakpoints

Breakpoints devem existir quando o layout precisa mudar.

Exemplo conceitual:

```text
Small
Medium
Large
Extra Large
```

Os valores exatos devem ser definidos pelo produto e pelo conteúdo.

Evitar criar dezenas de breakpoints.

---

# Breakpoint Rule

Adicionar breakpoint quando:

```text
Layout atual
    ↓
Começa a prejudicar
legibilidade / interação / hierarquia
    ↓
Breakpoint
    ↓
Novo layout
```

Não adicionar breakpoint apenas porque existe um dispositivo popular com determinada resolução.

---

# Mobile-First

Quando apropriado, utilizar abordagem mobile-first.

Estrutura:

```text
Mobile
 ↓
Tablet
 ↓
Desktop
```

Começar pela experiência mais restrita ajuda a identificar:

- prioridades;
- conteúdo essencial;
- ações principais;
- elementos dispensáveis.

---

# Desktop-First

Desktop-first pode ser apropriado quando:

- produto é predominantemente desktop;
- contexto profissional;
- workflows complexos;
- grandes volumes de dados;
- interfaces administrativas.

Mesmo nesses casos, mobile deve ser considerado quando necessário.

---

# Layout Adaptation

Um layout pode:

### Stack

```text
Desktop

[A] [B]

Mobile

[A]
[B]
```

### Wrap

```text
Desktop

[A] [B] [C] [D]

Mobile

[A] [B]
[C] [D]
```

### Collapse

```text
Sidebar
   ↓
Drawer
```

### Hide

Conteúdo secundário pode desaparecer quando realmente não for essencial.

### Reorder

A ordem dos elementos pode mudar para preservar prioridade.

### Transform

Um componente pode assumir outra representação.

---

# Component Behavior

Para cada componente relevante, definir:

```text
Desktop
Tablet
Mobile
```

Exemplo:

```text
Table
Desktop:
Full table

Tablet:
Reduced columns

Mobile:
Card/list representation
```

---

# Responsive Component Specification

Utilizar:

```text
## Component

### Desktop

<behavior>

### Tablet

<behavior>

### Mobile

<behavior>

### Breakpoint Trigger

<quando ocorre a mudança>

### Priority

<o que permanece visível>

### Accessibility

<considerações>
```

---

# Navigation

Navegação frequentemente precisa mudar significativamente.

Exemplo:

```text
Desktop
────────────────────
Logo | Menu | Actions

Mobile
────────────────────
Menu | Logo | Action
```

Ou:

```text
Desktop:
Sidebar

Mobile:
Hamburger → Drawer
```

---

# Navigation Principles

Em mobile:

- priorizar destinos principais;
- reduzir competição visual;
- preservar contexto;
- facilitar retorno;
- evitar menus excessivamente profundos.

Não esconder funções críticas apenas para simplificar visualmente.

---

# Header

Headers podem adaptar:

```text
Desktop:
Logo + Navigation + Search + Actions

Mobile:
Menu + Logo + Primary Action
```

Elementos secundários podem entrar em:

- overflow;
- menu;
- drawer;
- página contextual.

---

# Sidebars

Sidebar pode:

```text
Desktop:
Persistent

Tablet:
Collapsible

Mobile:
Drawer
```

Definir:

- trigger;
- abertura;
- fechamento;
- overlay;
- focus;
- scroll.

---

# Tables

Tabelas são um dos maiores desafios responsivos.

Não simplesmente aplicar:

```text
overflow-x: scroll
```

sem analisar a tarefa.

Alternativas:

### Horizontal Scroll

Quando comparação entre colunas é essencial.

### Column Reduction

Remover colunas secundárias.

### Priority Columns

Manter apenas as informações principais.

### Row Expansion

Mostrar detalhes sob demanda.

### Card Transformation

Transformar registros em cards.

### Master / Detail

Separar resumo e detalhes.

Escolher baseado na tarefa.

---

# Forms

Desktop:

```text
[First Name] [Last Name]
[Email]      [Phone]
```

Mobile:

```text
[First Name]

[Last Name]

[Email]

[Phone]
```

Mas não assumir que todos os campos devem sempre ser empilhados.

Considerar:

- relação entre campos;
- comprimento;
- frequência;
- teclado;
- scanning.

---

# Form Inputs

Adaptar:

- largura;
- tamanho;
- spacing;
- input type;
- keyboard type;
- action buttons.

Mobile deve utilizar o teclado adequado quando possível.

Exemplo:

```text
Email
→ email keyboard

Phone
→ numeric/phone keyboard

Number
→ numeric keyboard
```

---

# Touch Targets

Elementos interativos precisam possuir área de toque adequada.

Considerar:

- tamanho;
- espaçamento;
- proximidade entre ações;
- erro de toque.

Evitar ações muito próximas em mobile.

---

# Hover vs Touch

Nunca depender de hover para uma função essencial.

Desktop:

```text
Hover → preview
```

Mobile:

```text
Tap → preview
```

Quando o comportamento equivalente fizer sentido.

---

# Pointer Capabilities

Não assumir apenas:

```text
Desktop
Mobile
```

Considerar diferenças como:

- mouse;
- touch;
- stylus;
- teclado.

Uma interface pode existir em touchscreen grande ou desktop com touch.

---

# Typography

Responsive typography pode utilizar:

```text
Fixed scale
Fluid scale
Breakpoint scale
```

Escolher de acordo com:

- importância;
- legibilidade;
- espaço;
- contexto.

Evitar reduzir textos importantes demais em mobile.

---

# Fluid Typography

Quando apropriado:

```text
Desktop
32px

Tablet
28px

Mobile
24px
```

ou utilizar escala fluida.

O objetivo é manter hierarquia e legibilidade.

---

# Spacing

Spacing pode diminuir em telas pequenas.

Mas não reduzir indiscriminadamente.

Exemplo:

```text
Desktop:
32px section spacing

Mobile:
24px section spacing
```

Preservar espaço suficiente para compreensão e toque.

---

# Content Priority

Classificar conteúdo:

```text
P0 — Essential
P1 — Important
P2 — Secondary
P3 — Optional
```

Em telas menores:

```text
P0
 ↓
P1
 ↓
P2
 ↓
P3
```

Pode ser:

- escondido;
- colapsado;
- movido;
- carregado sob demanda.

---

# Action Priority

Da mesma forma:

```text
Primary Action
Secondary Action
Tertiary Action
```

Em mobile:

- manter ação principal visível;
- agrupar ações secundárias;
- mover ações raras para overflow.

---

# Fixed Actions

Quando uma ação crítica precisa permanecer disponível:

```text
Bottom action bar
Sticky header
Sticky footer
```

Avaliar:

- espaço disponível;
- conteúdo coberto;
- keyboard;
- acessibilidade;
- scroll.

Não transformar toda ação em sticky.

---

# Bottom Sheets

Bottom sheets podem substituir:

- menus;
- filtros;
- ações contextuais;
- seletores.

Definir:

- trigger;
- height;
- drag behavior;
- closing;
- focus;
- accessibility.

---

# Dialogs

Dialogs desktop podem precisar virar:

```text
Mobile:
Full-screen dialog
```

quando o conteúdo exigir mais espaço.

Não assumir que um modal pequeno continuará adequado em mobile.

---

# Images

Imagens devem considerar:

- aspect ratio;
- cropping;
- loading;
- resolution;
- art direction;
- importance.

Não utilizar imagens gigantes quando não agregam valor.

---

# Responsive Content

Texto também pode precisar mudar.

Exemplo:

```text
Desktop:
"Adicionar novo cliente"

Mobile:
"Adicionar"
```

Só fazer isso quando:

- significado continuar claro;
- ação continuar identificável.

Não sacrificar clareza por espaço.

---

# Localization

Responsive Design deve considerar textos de diferentes idiomas.

Um label curto em português pode ficar muito maior em outro idioma.

Testar:

```text
Short text
Long text
Different language
Plural
Numbers
Currency
Dates
```

---

# Long Content

Sempre testar:

- nomes longos;
- títulos longos;
- mensagens extensas;
- números grandes;
- emails;
- URLs;
- traduções.

Evitar layout dependente de uma largura específica de texto.

---

# Orientation

Quando relevante:

```text
Portrait
Landscape
```

Não assumir que mobile sempre estará em portrait.

---

# Height Constraints

Algumas interfaces falham não por largura, mas por altura.

Considerar:

- notebooks pequenos;
- mobile landscape;
- teclado aberto;
- split screen.

---

# Keyboard

Em mobile, o teclado pode reduzir drasticamente o viewport.

Considerar:

```text
Input focused
↓
Keyboard opens
↓
Content remains reachable
```

Evitar esconder:

- campo ativo;
- botão submit;
- mensagens importantes.

---

# Accessibility

Responsive Design deve preservar:

- keyboard navigation;
- focus;
- screen reader structure;
- zoom;
- text scaling;
- contrast;
- touch targets.

Não criar uma versão mobile que seja menos acessível.

---

# Zoom

Interfaces devem continuar utilizáveis com zoom e aumento de texto quando aplicável.

Evitar:

- conteúdo cortado;
- overlap;
- fixed widths;
- texto ilegível.

---

# Performance

Responsive Design também envolve performance.

Considerar:

- imagens responsivas;
- lazy loading;
- quantidade de elementos;
- animações;
- JavaScript;
- network conditions.

Não carregar o mesmo conteúdo pesado para todos os dispositivos sem necessidade.

---

# Responsive Images

Quando aplicável:

```text
Mobile
→ image variant menor

Desktop
→ image variant maior
```

Priorizar eficiência sem degradar qualidade perceptível.

---

# Responsive States

Estados também precisam funcionar em diferentes telas.

Exemplo:

```text
Desktop Error:
Inline message beside field

Mobile Error:
Message below field
```

Não basta adaptar apenas o estado default.

---

# Responsive Empty States

Um empty state pode mudar de composição:

```text
Desktop:
Illustration + text + action

Mobile:
Text + action
```

A prioridade deve permanecer.

---

# Responsive Dashboards

Dashboards devem preservar:

```text
Key metrics
Critical alerts
Primary actions
```

e reduzir ou reorganizar:

```text
Secondary charts
Detailed breakdowns
Low-priority information
```

Não transformar dashboard em uma longa lista de widgets sem hierarquia.

---

# Responsive Data Density

Definir densidade:

```text
Desktop:
High density

Tablet:
Medium density

Mobile:
Low density
```

Mas densidade deve considerar contexto.

Usuários profissionais podem precisar de maior densidade mesmo em telas menores.

---

# Responsive Testing

Testar pelo menos:

```text
Small mobile
Large mobile
Tablet
Small desktop
Large desktop
```

E quando relevante:

```text
Landscape
Zoom
Large text
Touch
Keyboard
```

Não testar apenas:

```text
375px
1440px
```

---

# Real Device Testing

Quando possível, validar em dispositivos reais.

Emuladores ajudam, mas não substituem completamente:

- touch;
- teclado;
- viewport;
- performance;
- browser behavior.

---

# Responsive QA Checklist

### Layout

```text
[ ] No horizontal overflow inesperado
[ ] No overlap
[ ] Conteúdo não é cortado
[ ] Grid adapta corretamente
[ ] Containers funcionam
```

### Typography

```text
[ ] Textos legíveis
[ ] Headings preservam hierarquia
[ ] Long text funciona
[ ] Zoom funciona
```

### Interaction

```text
[ ] Touch targets adequados
[ ] Hover não é obrigatório
[ ] Keyboard funciona
[ ] Focus funciona
```

### Navigation

```text
[ ] Menu funciona
[ ] Back funciona
[ ] Contexto é preservado
[ ] Destinos importantes continuam acessíveis
```

### Components

```text
[ ] Forms funcionam
[ ] Tables funcionam
[ ] Modals funcionam
[ ] Drawers funcionam
[ ] Toasts funcionam
```

### Accessibility

```text
[ ] Screen reader considerado
[ ] Focus preservado
[ ] Contrast preservado
[ ] Text scaling considerado
```

### Performance

```text
[ ] Imagens otimizadas
[ ] Conteúdo desnecessário não é carregado
[ ] Animações controladas
```

---

# Responsive Decision Framework

Quando um elemento não cabe em uma tela menor, seguir:

```text
1. É essencial?
        ↓
      Sim
        ↓
Preservar e reorganizar

      Não
        ↓
2. É importante?
        ↓
      Sim
        ↓
Colapsar / mover / progressive disclosure

      Não
        ↓
3. É necessário?
        ↓
      Não
        ↓
Remover
```

Nunca começar simplesmente com:

> "Esconde no mobile."

---

# Responsive Specification

Para cada tela:

```text
## Screen

### Primary Task

...

### Desktop

Layout:
...

Navigation:
...

Content:
...

Actions:
...

### Tablet

Layout:
...

Changes:
...

### Mobile

Layout:
...

Navigation:
...

Content Priority:
...

Actions:
...

### Breakpoints

...

### Accessibility

...

### Edge Cases

...
```

---

# Quality Criteria

Um bom Responsive Design:

- preserva a tarefa principal;
- mantém hierarquia;
- adapta layout;
- adapta interação;
- funciona com touch;
- funciona com teclado;
- suporta conteúdo real;
- evita overflow;
- mantém acessibilidade;
- considera diferentes alturas;
- considera orientação;
- considera zoom;
- evita breakpoints arbitrários;
- preserva consistência do Design System.

---

# Anti-Patterns

## Shrink Everything

Simplesmente reduzir todos os elementos.

---

## Desktop Squished Into Mobile

Manter o mesmo layout mesmo quando ele deixa de funcionar.

---

## Hide Everything

Esconder grande parte da interface sem estratégia de prioridade.

---

## Horizontal Scroll Everywhere

Usar scroll horizontal como solução padrão.

---

## Hover Dependency

Funcionalidade essencial depende de hover.

---

## Tiny Touch Targets

Reduzir elementos até ficarem difíceis de tocar.

---

## Fixed Widths

Layouts dependentes de larguras rígidas.

---

## Breakpoint Explosion

Criar inúmeros breakpoints para corrigir problemas pontuais.

---

## Mobile as Afterthought

Projetar desktop completamente e só depois tentar adaptar.

---

## Accessibility Regression

Criar uma versão mobile que perde recursos de acessibilidade.

---

## Same Content Priority Everywhere

Manter toda informação igualmente importante em qualquer tamanho de tela.

---

# Responsive Checklist

```text
[ ] Primary task identificada
[ ] Content priority definida
[ ] Action priority definida
[ ] Breakpoints definidos por necessidade
[ ] Mobile considerado
[ ] Tablet considerado
[ ] Desktop considerado
[ ] Layout adaptation definida
[ ] Navigation adaptation definida
[ ] Components adaptados
[ ] Forms adaptados
[ ] Tables adaptadas
[ ] Modals adaptados
[ ] Touch considerado
[ ] Hover dependency eliminada
[ ] Typography adaptada
[ ] Spacing adaptado
[ ] Long content testado
[ ] Localization considerada
[ ] Orientation considerada
[ ] Keyboard considerado
[ ] Zoom considerado
[ ] Accessibility validada
[ ] Performance considerada
[ ] Real device testing considerado
```

---

# Rule of Thumb

> **Quando o espaço muda, a prioridade pode mudar — mas a intenção do usuário não.**

Não pergunte apenas:

> "Como colocar essa tela de desktop no celular?"

Pergunte:

> "Qual é a melhor forma de permitir que o usuário complete a mesma tarefa neste contexto?"

---

# Final Principle

**Responsive Design não é uma técnica de CSS.**

É uma decisão de produto e UX.

Uma interface verdadeiramente responsiva adapta:

```text
Layout
   +
Conteúdo
   +
Navegação
   +
Interação
   +
Prioridade
   +
Acessibilidade
```

para que a experiência continue fazendo sentido independentemente do contexto.

> **Não faça a interface caber na tela. Faça a experiência caber no contexto.**
