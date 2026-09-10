---
name: frontend-ui-specification
description: Transforma decisões de UX/UI e design handoff em uma especificação técnica de interface orientada à implementação frontend. Define telas, componentes, estados, propriedades, comportamentos, responsividade, acessibilidade, dados, eventos e critérios de aceite sem impor arquitetura ou código desnecessariamente.
---

# Frontend UI Specification

## Objective

Transformar uma solução de UX/UI em uma **especificação precisa para implementação frontend**.

A especificação deve estabelecer um contrato claro entre:

```text
Product
   ↓
UX/UI
   ↓
Frontend Specification
   ↓
Frontend Implementation
   ↓
UI Quality Review
```

O objetivo é permitir que o Frontend Agent compreenda:

- o que precisa ser construído;
- quais telas existem;
- quais componentes são necessários;
- como os componentes se comportam;
- quais estados existem;
- quais dados são necessários;
- como a interface responde a eventos;
- como funciona em diferentes tamanhos de tela;
- quais requisitos de acessibilidade existem;
- quais critérios determinam que a implementação está correta.

---

# Core Principles

## 1. Especificação é contrato, não código

A Skill define **o comportamento esperado da interface**.

Não deve impor:

- framework;
- biblioteca;
- arquitetura interna;
- estrutura de pastas;
- gerenciamento de estado;
- estratégia de cache;
- detalhes de implementação sem necessidade.

Engineering decide como implementar.

A especificação define o que precisa acontecer.

---

## 2. Behavior First

Priorizar:

```text
User Action
     ↓
System Behavior
     ↓
UI State
     ↓
Feedback
     ↓
Result
```

Uma especificação visual sem comportamento é incompleta.

---

## 3. Estado é parte da interface

Toda interface relevante deve considerar seus estados.

Exemplo:

```text
idle
loading
success
error
empty
disabled
partial
```

Nem todo componente precisa de todos eles.

A especificação deve identificar apenas os estados relevantes.

---

## 4. Dados fazem parte da UI

Uma interface depende de dados reais.

Documentar quando necessário:

- campos;
- tipos;
- obrigatoriedade;
- origem;
- estados;
- formatação;
- ausência;
- erro;
- atualização;
- paginação;
- filtros;
- ordenação.

---

# When to Use

Usar esta Skill quando:

- uma feature está pronta para frontend;
- existe um design handoff;
- um protótipo precisa virar implementação;
- uma tela precisa de especificação técnica;
- existem múltiplos estados de UI;
- existe integração com APIs;
- existem formulários complexos;
- existe comportamento responsivo;
- existem requisitos de acessibilidade;
- o Frontend Agent precisa receber um contrato claro.

---

# Inputs

Considerar, quando disponíveis:

- PRD;
- requirements;
- user stories;
- acceptance criteria;
- user flows;
- wireframes;
- protótipos;
- visual design;
- design system;
- design handoff;
- componentes existentes;
- tokens;
- contratos de API;
- regras de negócio;
- permissões;
- analytics;
- requisitos de acessibilidade.

---

# Process

## Step 1 — Understand the Feature

Identificar:

- objetivo;
- usuário;
- fluxo;
- resultado esperado;
- telas;
- ações principais;
- dependências.

Exemplo:

```text
Feature:
Cadastro de cliente

Goal:
Permitir que operador cadastre um cliente.

Primary Flow:
List → New Customer → Form → Submit → Success
```

---

# Step 2 — Define Screens

Cada tela deve possuir:

```text
Screen
├── Purpose
├── Entry Conditions
├── Layout
├── Components
├── Data
├── Interactions
├── States
├── Responsive Behavior
├── Accessibility
└── Exit Conditions
```

Exemplo:

```text
## Customer Form

Purpose:
Criar cliente.

Entry:
Usuário possui permissão de criação.

Exit:
Cliente criado ou erro apresentado.
```

---

# Step 3 — Define Layout Structure

Descrever a estrutura funcional:

```text
Page
├── Header
├── Breadcrumb
├── Main
│   ├── Form
│   │   ├── Personal Data
│   │   └── Contact Data
│   └── Actions
└── Feedback
```

Não transformar a especificação em uma descrição pixel-perfect desnecessária.

---

# Step 4 — Define Components

Para cada componente:

```text
Component:
CustomerForm

Responsibility:
Capturar dados do cliente.

Inputs:
- customerName
- document
- email
- phone

Outputs:
- submit
- cancel

States:
- idle
- submitting
- validationError
- serverError
- success
```

---

# Step 5 — Define Component Properties

Quando necessário:

```text
Button
├── variant
├── size
├── disabled
├── loading
├── icon
└── label
```

Documentar apenas propriedades relevantes ao comportamento.

Evitar criar APIs artificiais apenas para documentar o componente.

---

# Step 6 — Define State Model

Para fluxos complexos, modelar explicitamente:

```text
Idle
 ↓
Editing
 ↓
Submitting
 ├── Success → Completed
 └── Error → Editing
```

Também considerar:

```text
Empty
Loading
Partial
Unauthorized
Forbidden
Not Found
Offline
Timeout
```

Somente quando aplicável.

---

# Step 7 — Define Events

Para cada interação importante:

```text
Event:
submitCustomer

Trigger:
Usuário confirma cadastro.

Preconditions:
Campos válidos.

UI:
Botão entra em loading.

Success:
Redirecionar para customer detail.

Error:
Manter formulário preenchido.
Exibir erro.
Permitir retry.
```

---

# Step 8 — Define Form Specification

Para cada campo:

```text
Field:
Email

Type:
email

Required:
Yes

Label:
E-mail

Placeholder:
se necessário

Validation:
Formato válido.

Error:
"Informe um e-mail válido."

Submit:
Campo deve estar válido.
```

Também considerar:

- autocomplete;
- máscara;
- input mode;
- keyboard;
- paste;
- valores máximos;
- valores mínimos;
- caracteres permitidos;
- mensagens;
- validação client-side;
- validação server-side.

---

# Step 9 — Define Data Contract

Quando a UI consumir dados:

```text
Customer
├── id
├── name
├── document
├── email
├── status
└── createdAt
```

Documentar:

| Field | Type | Required | Display |
|---|---|---|---|
| id | string | yes | hidden |
| name | string | yes | text |
| email | string | yes | text |
| status | enum | yes | status badge |
| createdAt | datetime | yes | localized date |

Não inventar campos inexistentes.

Se o contrato ainda não estiver definido:

```text
Status:
OPEN QUESTION
```

---

# Step 10 — Define UI/Data Boundaries

Distinguir:

```text
Backend Data
      ↓
Mapping
      ↓
UI Model
      ↓
Component
```

A especificação pode indicar transformações necessárias:

```text
status = ACTIVE
        ↓
"Ativo"
        ↓
StatusBadge / positive
```

Não confundir representação visual com valor de domínio.

---

# Step 11 — Define Loading Behavior

Documentar:

- quando começa;
- o que fica bloqueado;
- o que continua disponível;
- skeleton ou spinner;
- feedback;
- timeout;
- retry;
- preservação dos dados.

Exemplo:

```text
Initial load:
Show skeleton.

Submit:
Disable submit action.

Retry:
Allow user to retry without losing entered data.
```

---

# Step 12 — Define Error Behavior

Cada erro relevante deve responder:

```text
What happened?
Why?
What can the user do?
```

Exemplo:

```text
Error:
Customer creation failed.

UI:
Display inline form error.

Recovery:
Allow retry.

Data:
Preserve entered values.
```

Evitar:

```text
Something went wrong.
```

sem orientação.

---

# Step 13 — Define Empty States

Para listas:

```text
Empty:
No customers registered.

Title:
Nenhum cliente cadastrado.

Description:
Cadastre seu primeiro cliente.

Primary Action:
Cadastrar cliente.
```

Diferenciar:

```text
Empty
```

de:

```text
Loading
```

e:

```text
Error
```

---

# Step 14 — Define Permissions

Documentar quando aplicável:

```text
Permission:
customer.create

Allowed:
Show create button.

Denied:
Hide action or display disabled state according to product rules.
```

Diferenciar:

- usuário não autorizado;
- usuário sem permissão;
- recurso indisponível;
- ação temporariamente bloqueada.

---

# Step 15 — Define Responsive Behavior

Especificar comportamento, não apenas breakpoints.

Exemplo:

```text
Desktop:
Two-column form.

Mobile:
Single-column form.

Desktop:
Actions aligned horizontally.

Mobile:
Primary action full width.
```

Considerar:

- navigation;
- tables;
- forms;
- cards;
- dialogs;
- drawers;
- overflow;
- typography;
- spacing;
- touch;
- orientation.

---

# Step 16 — Define Accessibility

Especificar:

- semantic structure;
- accessible names;
- labels;
- keyboard navigation;
- focus;
- focus restoration;
- screen reader behavior;
- error announcement;
- loading announcement;
- contrast;
- touch targets;
- reduced motion.

Exemplo:

```text
Modal:
- trap focus while open
- close with Escape when appropriate
- restore focus after close
- provide accessible name
```

---

# Step 17 — Define Navigation

Para cada ação de navegação:

```text
Action:
Click customer.

Destination:
/customers/:id

Behavior:
Navigate to customer details.

Back:
Return to previous list state when appropriate.
```

Também considerar:

- deep links;
- browser back;
- cancel;
- redirects;
- unsaved changes.

---

# Step 18 — Define URL and Routing Behavior

Quando aplicável:

```text
Route:
/customers

Detail:
/customers/:id

Create:
/customers/new
```

Documentar apenas o comportamento necessário.

---

# Step 19 — Define Persistence

Quando aplicável:

- filtros;
- paginação;
- ordenação;
- tabs;
- formulário;
- drafts;
- scroll;
- seleção.

Exemplo:

```text
User filters customer list.

Navigate to customer.

Return to list.

Expected:
Preserve filter and pagination state.
```

Não presumir persistência sem necessidade.

---

# Step 20 — Define Optimistic Behavior

Quando apropriado:

```text
User Action
 ↓
Optimistic UI
 ↓
Request
 ├── Success → Keep state
 └── Failure → Rollback + Feedback
```

Utilizar apenas quando a operação permitir reversão segura e a experiência se beneficiar.

---

# Step 21 — Define Double Submission Protection

Para ações críticas:

```text
Submit
 ↓
Submitting
 ↓
Prevent duplicate action
```

Aplicar especialmente em:

- pagamentos;
- criação de registros;
- exclusões;
- operações financeiras;
- ações não idempotentes.

---

# Step 22 — Define Confirmation Behavior

Não adicionar confirmação automaticamente.

Perguntar:

- a ação é destrutiva?
- é reversível?
- possui impacto significativo?
- existe undo?
- confirmação reduz risco real?

Evitar:

```text
Click
 ↓
Are you sure?
 ↓
Yes
```

para ações triviais.

---

# Step 23 — Define Notifications

Quando houver feedback global:

```text
Type:
Success

Trigger:
Customer created.

Message:
"Cliente criado com sucesso."

Duration:
According to design system.

Dismissible:
Yes
```

Utilizar o padrão definido pelo Design System.

---

# Step 24 — Define Analytics

Quando necessário:

```text
Event:
customer_created

Trigger:
Successful creation.

Properties:
customer_type
source
```

Não criar eventos apenas para preencher documentação.

Analytics deve responder a uma necessidade de produto ou análise.

---

# Step 25 — Define Performance Expectations

Quando relevante:

- loading imediato;
- skeleton;
- lazy loading;
- pagination;
- virtualização;
- image strategy;
- perceived performance.

Não prescrever otimizações técnicas sem necessidade.

Especificar a experiência esperada.

---

# Step 26 — Define Edge Cases

Sempre verificar:

```text
Empty
Long content
Invalid input
Slow network
Network failure
Timeout
Permission denied
Unauthorized
Not found
Duplicate action
Expired session
Unexpected data
Partial data
```

---

# Step 27 — Define Open Questions

Toda decisão não resolvida deve ser explícita:

```text
Open Questions:

1. O filtro deve persistir após navegação?
2. O erro de API será exibido inline ou globalmente?
3. O usuário pode editar durante o processamento?
```

Nunca transformar dúvida em requisito implícito.

---

# Frontend UI Specification Template

Quando solicitado um documento completo:

```text
# Frontend UI Specification

## Feature
...

## Objective
...

## User
...

## Scope
...

## Screens

### Screen 1
Purpose:
...

Entry Conditions:
...

Layout:
...

Components:
...

Data:
...

Interactions:
...

States:
...

Responsive:
...

Accessibility:
...

Exit Conditions:
...

## Components

### Component
Purpose:
...

Properties:
...

States:
...

Behavior:
...

Accessibility:
...

## Data Contract
...

## Events
...

## Navigation
...

## Permissions
...

## Loading
...

## Errors
...

## Empty States
...

## Responsive Behavior
...

## Accessibility
...

## Analytics
...

## Edge Cases
...

## Open Questions
...

## Acceptance Criteria
...
```

---

# Acceptance Criteria

A frontend specification deve permitir validar:

### Structure

- [ ] Todas as telas relevantes foram definidas.
- [ ] Hierarquia funcional está clara.
- [ ] Componentes principais estão identificados.

### Behavior

- [ ] Interações estão especificadas.
- [ ] Estados relevantes estão definidos.
- [ ] Loading está definido.
- [ ] Erros estão definidos.
- [ ] Empty states estão definidos.
- [ ] Recovery está definido.

### Data

- [ ] Dados necessários estão identificados.
- [ ] Campos possuem tipos quando necessário.
- [ ] Estados de dados estão definidos.

### Responsive

- [ ] Desktop definido.
- [ ] Mobile definido.
- [ ] Adaptações importantes documentadas.

### Accessibility

- [ ] Keyboard behavior definido.
- [ ] Focus behavior definido.
- [ ] Accessible names definidos.
- [ ] Feedback acessível definido.

### Engineering

- [ ] Não existem decisões críticas implícitas.
- [ ] Open questions estão explícitas.
- [ ] Critérios de aceite são verificáveis.
- [ ] A especificação não impõe implementação desnecessariamente.

---

# Anti-Patterns

Nunca:

- escrever código quando uma regra é suficiente;
- prescrever arquitetura sem necessidade;
- definir biblioteca específica sem requisito;
- ignorar estados;
- ignorar erros;
- ignorar loading;
- ignorar empty states;
- ignorar acessibilidade;
- documentar apenas desktop;
- assumir que dados sempre existem;
- inventar contratos de API;
- esconder open questions;
- duplicar o Design System inteiro;
- transformar detalhe visual irrelevante em requisito técnico;
- deixar comportamento importante para interpretação do desenvolvedor.

---

# Quality Criteria

Uma boa especificação deve ser:

- precisa;
- implementável;
- verificável;
- independente de framework;
- orientada ao comportamento;
- consistente com o Design System;
- consciente dos dados;
- acessível;
- responsiva;
- explícita sobre estados;
- explícita sobre incertezas.

O Frontend Agent deve conseguir responder:

```text
What?
   ↓
How should it behave?
   ↓
What data does it need?
   ↓
What states exist?
   ↓
What happens on failure?
   ↓
How does it behave responsively?
   ↓
How do we validate it?
```

sem precisar adivinhar decisões críticas.

---

# Outputs

Dependendo do contexto:

- frontend UI specification;
- screen specification;
- component specification;
- interaction contract;
- UI state model;
- data/UI contract;
- responsive specification;
- accessibility specification;
- frontend acceptance criteria;
- implementation-ready design specification.

---

# Rule of Thumb

> **O Frontend Agent deve decidir como implementar, mas nunca deveria precisar adivinhar o que a interface deve fazer.**
