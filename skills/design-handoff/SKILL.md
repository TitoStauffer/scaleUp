---
name: design-handoff
description: Transforma decisões de UX/UI em uma especificação clara, implementável e verificável para engenharia. Use para preparar handoff de telas, fluxos, componentes, estados, responsividade, acessibilidade, tokens, regras de interação e critérios de implementação para frontend.
---

# Design Handoff

## Objective

Transformar uma solução de UX/UI em um **contrato de implementação** claro para Engineering.

O handoff deve eliminar ambiguidades sobre:

- estrutura;
- comportamento;
- componentes;
- estados;
- interações;
- responsividade;
- acessibilidade;
- conteúdo;
- validações;
- feedback;
- regras visuais;
- dependências;
- decisões de design.

O objetivo não é entregar apenas uma imagem.

O objetivo é entregar **informação suficiente para implementar a experiência corretamente**.

---

# Core Principles

## 1. Design Handoff é um contrato

O handoff deve responder:

```text
O que construir?
        ↓
Como deve funcionar?
        ↓
Quais estados existem?
        ↓
Como deve responder?
        ↓
Como se comporta em diferentes telas?
        ↓
Como deve ser acessível?
        ↓
Como saberemos que está correto?
```

---

## 2. Design ≠ implementação

O Designer define:

- experiência;
- comportamento esperado;
- hierarquia;
- interação;
- estados;
- regras visuais;
- acessibilidade.

Engineering decide:

- arquitetura frontend;
- estrutura de código;
- abstrações;
- gerenciamento de estado;
- bibliotecas;
- estratégia técnica;
- implementação.

Não transformar decisões de implementação em requisito de design sem necessidade.

---

## 3. Especificar comportamento, não apenas aparência

Evitar:

> "O botão fica azul."

Preferir:

> "O CTA primário utiliza o token de ação primária. Em hover, aplica o estado correspondente do componente. Em loading, mantém a posição e desabilita novas submissões."

---

## 4. Todos os estados importantes devem existir

Uma interface raramente possui apenas:

```text
Default
```

Considerar:

```text
Default
Hover
Focus
Active
Disabled
Loading
Success
Error
Empty
Partial
Selected
Expanded
Collapsed
```

Usar apenas os estados relevantes para o componente.

---

# When to Use

Usar esta Skill quando:

- uma tela está pronta para desenvolvimento;
- um fluxo foi validado;
- um protótipo será entregue para frontend;
- um novo componente precisa ser implementado;
- existe um redesign;
- existe uma alteração visual significativa;
- uma feature possui interações complexas;
- existem estados assíncronos;
- existem requisitos de acessibilidade;
- é necessário alinhar Design e Engineering.

---

# Inputs

Quando disponíveis:

- PRD;
- requisitos;
- user stories;
- acceptance criteria;
- personas;
- user flows;
- wireframes;
- protótipos;
- telas finais;
- design system;
- tokens;
- componentes;
- regras de negócio;
- requisitos de acessibilidade;
- breakpoints;
- conteúdo;
- estados;
- APIs ou dados esperados;
- restrições técnicas conhecidas.

---

# Handoff Process

## Step 1 — Understand the Product Context

Antes do handoff, entender:

- problema;
- usuário;
- objetivo;
- fluxo;
- resultado esperado;
- regras relevantes;
- dependências.

Não entregar uma tela isolada sem contexto quando o comportamento depender do fluxo.

---

# Step 2 — Define the Scope

Documentar claramente:

```text
Feature:
...

Telas:
- ...
- ...

Fluxos:
- ...
- ...

Componentes:
- ...
- ...

Estados:
- ...
- ...

Plataformas:
- Desktop
- Mobile
```

Também declarar explicitamente o que **não faz parte do escopo** quando isso evitar ambiguidade.

---

# Step 3 — Describe the Screen Structure

Para cada tela:

```text
Screen
├── Header
├── Navigation
├── Main Content
│   ├── Section
│   ├── Form
│   └── Actions
└── Feedback
```

Documentar:

- regiões;
- hierarquia;
- agrupamentos;
- conteúdo;
- componentes;
- ações;
- dependências.

---

# Step 4 — Define Components

Para cada componente relevante:

```text
Component:
Button

Purpose:
Executar ação principal.

Variant:
Primary

States:
- default
- hover
- focus
- disabled
- loading

Behavior:
Ao clicar, inicia a operação.

Accessibility:
Possui accessible name.
Mantém foco.
Estado de loading é anunciado adequadamente.
```

Não duplicar documentação que já exista no Design System.

Referenciar o componente quando houver documentação oficial.

---

# Step 5 — Define Interaction Behavior

Para cada interação importante:

```text
Trigger
   ↓
User Action
   ↓
System Response
   ↓
New State
   ↓
Feedback
```

Exemplo:

```text
Trigger:
Usuário clica em "Salvar"

Action:
Sistema valida os dados

Response:
Exibe loading no botão

Success:
Fecha formulário e exibe confirmação

Error:
Mantém dados preenchidos e apresenta mensagem de erro
```

---

# Step 6 — Define State Transitions

Quando necessário, utilizar uma máquina de estados conceitual:

```text
Idle
 ↓
Submitting
 ├── Success → Completed
 └── Error → Idle
```

Para operações assíncronas, especificar:

- quando começa;
- o que fica bloqueado;
- o que permanece interativo;
- feedback;
- timeout;
- retry;
- sucesso;
- erro;
- comportamento em caso de abandono.

---

# Step 7 — Define Form Behavior

Para formulários, documentar:

- campos;
- labels;
- placeholders;
- valores padrão;
- obrigatoriedade;
- validação;
- formato;
- máscara;
- mensagens de erro;
- quando validar;
- comportamento após erro;
- submit;
- loading;
- sucesso;
- preservação dos dados.

Exemplo:

```text
Campo:
CPF

Required:
Yes

Validation:
Formato válido

Error:
"Informe um CPF válido."

Validation timing:
Após blur e no submit.

On submit error:
Manter valor informado.
Mover foco para primeiro erro quando apropriado.
```

---

# Step 8 — Define Responsive Behavior

Não entregar apenas:

> Desktop + Mobile.

Especificar como o layout muda.

Exemplo:

```text
Desktop:
Sidebar fixa + conteúdo principal.

Tablet:
Sidebar reduzida.

Mobile:
Sidebar substituída por navegação compacta.
Conteúdo ocupa largura disponível.
Tabela utiliza estratégia de adaptação definida.
```

Considerar:

- largura;
- altura;
- navegação;
- grids;
- tabelas;
- formulários;
- modais;
- drawers;
- menus;
- tipografia;
- espaçamento;
- overflow;
- touch;
- orientação.

---

# Step 9 — Define Accessibility

Documentar requisitos relevantes:

- semântica;
- labels;
- accessible names;
- foco;
- teclado;
- ordem de navegação;
- contraste;
- mensagens;
- estados;
- leitores de tela;
- reduced motion;
- zoom;
- text scaling;
- touch targets.

Não deixar acessibilidade implícita.

---

# Step 10 — Define Content

Quando o conteúdo afeta o layout, especificar:

- textos;
- limites;
- truncamento;
- wrapping;
- conteúdo vazio;
- conteúdo longo;
- pluralização;
- localização;
- datas;
- números;
- moedas;
- mensagens de erro.

Evitar entregar:

> "Lorem ipsum"

quando o conteúdo real possui impacto estrutural.

---

# Step 11 — Define Empty States

Documentar:

```text
Empty state
├── Title
├── Explanation
├── Primary action
└── Optional secondary action
```

Exemplo:

> Nenhum cliente cadastrado.

> Cadastre seu primeiro cliente para começar a utilizar a plataforma.

> [Cadastrar cliente]

---

# Step 12 — Define Loading States

Especificar:

- skeleton;
- spinner;
- progress;
- disabled state;
- optimistic update;
- loading parcial;
- loading global.

Perguntar:

- O usuário pode continuar interagindo?
- O que está carregando?
- O conteúdo anterior permanece?
- Existe timeout?
- Existe retry?

---

# Step 13 — Define Error States

Documentar:

```text
Error
├── What happened?
├── What can user do?
├── Recovery action
└── Data preservation
```

Exemplo:

```text
Title:
Não foi possível salvar o cliente.

Explanation:
O serviço está temporariamente indisponível.

Action:
Tentar novamente.

Data:
Manter dados preenchidos.
```

---

# Step 14 — Define Destructive Actions

Para ações destrutivas:

- identificar claramente a ação;
- explicar consequência;
- diferenciar ação primária/secundária;
- confirmar quando necessário;
- evitar confirmação desnecessária;
- considerar undo quando apropriado.

Exemplo:

```text
Delete
 ↓
Confirmation
 ↓
Delete
 ↓
Success
```

Ou:

```text
Delete
 ↓
Undo window
 ↓
Permanent deletion
```

A estratégia depende do risco.

---

# Step 15 — Define Data Dependencies

Quando a interface depende de dados externos, documentar:

- origem do dado;
- dados necessários;
- loading;
- ausência;
- erro;
- atualização;
- refresh;
- paginação;
- filtros;
- ordenação;
- permissões.

Não assumir que Engineering descobrirá essas regras olhando apenas para a tela.

---

# Step 16 — Define Permissions

Quando aplicável:

```text
Role A:
Pode visualizar.

Role B:
Pode editar.

Role C:
Pode excluir.
```

Diferenciar:

- elemento invisível;
- elemento disabled;
- acesso negado;
- ação indisponível temporariamente.

---

# Step 17 — Define Analytics

Quando necessário, documentar eventos relevantes:

```text
Event:
customer_created

Trigger:
Cadastro concluído.

Properties:
- source
- customer_type

Purpose:
Medir conversão do fluxo.
```

Analytics deve existir quando fizer parte do objetivo do produto.

---

# Step 18 — Define Design Tokens

Quando o Design System existir, utilizar tokens em vez de valores arbitrários.

Preferir:

```text
color.action.primary
spacing.md
radius.sm
font.body
shadow.surface
```

Em vez de:

```text
#123456
17px
13px
```

Valores específicos podem ser documentados quando necessários, mas não devem substituir o sistema de tokens.

---

# Step 19 — Define Open Questions

Toda ambiguidade deve ser explicitada.

Exemplo:

```text
Open Questions:

1. O usuário pode editar enquanto a operação está processando?
2. O retry deve ocorrer automaticamente?
3. Qual mensagem será usada para erro de integração?
4. O usuário sem permissão deve visualizar o item?
```

Nunca esconder decisões pendentes dentro da especificação.

---

# Step 20 — Define Acceptance Criteria

O handoff deve permitir validação.

Exemplo:

```text
- Usuário consegue iniciar o cadastro.
- Campos obrigatórios são identificados.
- Erros são exibidos próximos aos campos.
- Submit apresenta loading.
- Duplo clique não gera submissões duplicadas.
- Sucesso apresenta confirmação.
- Erro preserva os dados.
- Fluxo funciona em mobile.
- Fluxo pode ser executado via teclado.
```

---

# Handoff Specification

Quando solicitado um handoff completo, utilizar:

```text
# Design Handoff

## Feature
...

## Objective
...

## Scope
...

## User Flow
...

## Screens

### Screen 1
Purpose:
...

Structure:
...

Components:
...

Interactions:
...

States:
...

Responsive:
...

Accessibility:
...

Content:
...

## Data Dependencies
...

## Permissions
...

## Analytics
...

## Design System
...

## Edge Cases
...

## Open Questions
...

## Acceptance Criteria
...
```

---

# Component Handoff

Para componentes reutilizáveis:

```text
# Component Handoff

## Name
...

## Purpose
...

## Anatomy
...

## Variants
...

## Properties
...

## States
...

## Behavior
...

## Responsive Behavior
...

## Accessibility
...

## Content Rules
...

## Composition
...

## Do
...

## Don't
...
```

---

# Design-to-Code Contract

Sempre que possível, manter correspondência:

```text
Design
  ↓
Component
  ↓
Variant
  ↓
State
  ↓
Behavior
  ↓
Code
```

Exemplo:

```text
Design:
Button / Primary / Loading

Frontend:
Button variant="primary" loading
```

O objetivo é reduzir interpretações durante implementação.

---

# Visual QA Contract

O handoff deve permitir comparar:

```text
Expected Design
      ↓
Implementation
      ↓
Visual QA
      ↓
Differences
      ↓
Fix
      ↓
Validation
```

Verificar:

- layout;
- spacing;
- typography;
- colors;
- component states;
- responsiveness;
- interactions;
- accessibility.

---

# Developer Questions

Antes de finalizar o handoff, tentar responder:

- O que acontece quando clico?
- O que acontece enquanto carrega?
- O que acontece se falhar?
- O que acontece se estiver vazio?
- O que acontece se eu clicar duas vezes?
- O que acontece em mobile?
- O que acontece sem permissão?
- O que acontece com dados muito longos?
- O que acontece se eu voltar?
- O que acontece se a sessão expirar?
- O que acontece se a API estiver indisponível?
- Como o usuário recupera o erro?
- Como o componente deve ser acessado via teclado?

Se essas respostas não estiverem claras, o handoff ainda não está pronto.

---

# Anti-Patterns

Nunca:

- entregar apenas screenshots;
- assumir que Engineering "vai entender";
- esconder estados;
- ignorar erros;
- ignorar loading;
- ignorar empty states;
- ignorar responsividade;
- ignorar acessibilidade;
- documentar valores arbitrários quando existem tokens;
- definir arquitetura frontend desnecessariamente;
- deixar decisões críticas implícitas;
- usar lorem ipsum quando conteúdo real afeta layout;
- esquecer permissões;
- esquecer comportamento assíncrono;
- criar documentação duplicada do Design System;
- misturar requisito de produto com detalhe de implementação sem necessidade.

---

# Quality Criteria

Um handoff de qualidade deve ser:

- claro;
- implementável;
- verificável;
- completo nos estados relevantes;
- consistente com o Design System;
- acessível;
- responsivo;
- orientado ao comportamento;
- explícito sobre incertezas;
- alinhado aos requisitos do produto.

A pergunta final é:

> **Um frontend engineer consegue implementar a experiência sem precisar adivinhar decisões importantes?**

Se a resposta for "não", o handoff precisa ser melhorado.

---

# Outputs

Dependendo do contexto, produzir:

- design handoff;
- screen specification;
- component specification;
- interaction specification;
- responsive specification;
- accessibility specification;
- design-to-code contract;
- visual QA checklist;
- frontend implementation notes;
- open questions;
- acceptance criteria.

---

# Rule of Thumb

> **Se uma decisão importante precisa ser descoberta pelo desenvolvedor olhando para uma imagem, o handoff está incompleto.**
