---
name: wireframe-design
description: Design de wireframes de baixa e média fidelidade para estruturar telas, hierarquia de conteúdo, layout, componentes e interação antes do design visual. Use quando for necessário transformar requisitos, arquitetura da informação e user flows em estruturas de interface claras e testáveis.
---

# Wireframe Design

## Objective

Criar wireframes que representem a estrutura e organização de uma interface antes da definição detalhada do design visual.

O wireframe deve responder principalmente:

- O que existe na tela?
- Onde cada elemento fica?
- Qual é a hierarquia da informação?
- O que o usuário precisa perceber primeiro?
- Quais ações estão disponíveis?
- Como o usuário navega pela interface?
- Quais estados a tela precisa representar?
- Como a interface suporta o fluxo definido?

O objetivo não é criar uma interface bonita.

O objetivo é criar uma **estrutura de interface clara, funcional e validável**.

---

# Core Principles

## 1. Estrutura antes de estética

Wireframe deve priorizar:

- hierarquia;
- layout;
- conteúdo;
- navegação;
- ações;
- estados;
- fluxo.

Não priorizar:

- cores;
- sombras;
- gradientes;
- tipografia refinada;
- decoração;
- branding.

---

## 2. Conteúdo real sempre que possível

Evite preencher telas com:

- Lorem ipsum;
- textos genéricos;
- títulos artificiais;
- dados excessivamente simplificados.

Sempre que possível, utilizar exemplos próximos do conteúdo real.

Conteúdo influencia diretamente:

- layout;
- tamanho dos componentes;
- hierarquia;
- densidade;
- decisões de navegação.

---

## 3. Wireframe deve representar comportamento

Uma tela não deve ser analisada isoladamente.

Considerar:

```text
Estado anterior
      ↓
Tela
      ↓
Ação
      ↓
Próximo estado
```

O wireframe deve deixar claro o que acontece quando o usuário:

- clica;
- seleciona;
- digita;
- confirma;
- cancela;
- volta;
- recebe erro;
- aguarda processamento.

---

## 4. Hierarquia é mais importante que aparência

O wireframe deve deixar evidente:

1. objetivo principal da tela;
2. informação principal;
3. ação principal;
4. ações secundárias;
5. informações auxiliares;
6. navegação.

Se tudo parece importante, nada está claramente priorizado.

---

## 5. Um wireframe deve representar uma intenção

Antes de desenhar uma tela, identificar:

> "O que o usuário precisa conseguir fazer aqui?"

Exemplos:

```text
Cadastrar cliente
Consultar pedido
Editar produto
Acompanhar pagamento
Resolver erro
Confirmar operação
```

A estrutura deve ser construída em torno dessa intenção.

---

# When to Use

Use esta Skill quando:

- uma nova tela precisa ser projetada;
- um fluxo já foi definido;
- requisitos precisam ser transformados em interface;
- existe dúvida sobre a estrutura de uma página;
- uma feature possui muitas informações;
- é necessário validar uma solução antes do design visual;
- uma interface existente precisa ser reorganizada;
- é necessário explorar diferentes layouts;
- uma nova funcionalidade precisa de protótipo estrutural.

Não usar wireframe como substituto para:

- UX Research;
- User Flow;
- Information Architecture;
- Visual Design;
- Design System.

Cada disciplina resolve um problema diferente.

---

# Inputs

Antes de criar um wireframe, analisar quando disponíveis:

### Product

- problema;
- objetivo;
- requisitos;
- regras de negócio;
- prioridades;
- métricas;
- critérios de sucesso.

### UX

- research;
- personas;
- journey map;
- pain points;
- necessidades;
- user flows.

### IA

- arquitetura da informação;
- navegação;
- taxonomia;
- labels;
- estrutura de conteúdo.

### Technical

- limitações técnicas conhecidas;
- permissões;
- integrações;
- estados assíncronos;
- disponibilidade de dados.

---

# Process

## Step 1 — Define the Screen Goal

Identificar:

```text
Tela:
Objetivo:
Usuário:
Tarefa principal:
Ação principal:
```

Exemplo:

```text
Tela:
Cadastro de cliente

Objetivo:
Permitir criar um novo cliente

Usuário:
Operador

Tarefa principal:
Preencher os dados obrigatórios

Ação principal:
Cadastrar cliente
```

---

# Step 2 — Identify Required Content

Listar tudo que precisa aparecer.

Separar em:

### Primary

Informações essenciais para completar a tarefa.

### Secondary

Informações úteis, mas não essenciais.

### Supporting

Informações auxiliares.

### Optional

Informações que podem ser acessadas sob demanda.

Exemplo:

```text
Primary:
- Nome
- CPF
- Email

Secondary:
- Telefone
- Endereço

Supporting:
- Data de criação

Optional:
- Histórico
```

---

# Step 3 — Establish Visual Hierarchy

Definir a ordem de atenção.

Exemplo:

```text
1. Título da página
2. Contexto
3. Dados principais
4. Ação principal
5. Ações secundárias
6. Informações auxiliares
```

A hierarquia deve refletir a importância para a tarefa.

---

# Step 4 — Define Layout

Escolher uma estrutura apropriada.

Possibilidades:

- single column;
- two columns;
- sidebar;
- header + content;
- dashboard;
- master/detail;
- wizard;
- tabs;
- cards;
- table;
- modal;
- drawer.

Não escolher layout por preferência estética.

Escolher baseado em:

- conteúdo;
- tarefa;
- frequência de uso;
- densidade;
- contexto;
- dispositivo.

---

# Step 5 — Place Navigation

Definir:

- navegação global;
- navegação contextual;
- breadcrumbs;
- tabs;
- back navigation;
- ações de saída.

Perguntar:

> O usuário sabe onde está?

> O usuário sabe para onde pode ir?

> O usuário consegue voltar?

---

# Step 6 — Define Primary Action

Toda tela orientada a tarefa deve possuir uma ação principal clara quando aplicável.

Exemplos:

```text
Salvar
Continuar
Enviar
Confirmar
Comprar
Cadastrar
Finalizar
```

Evitar múltiplas ações visualmente equivalentes quando existe uma ação claramente principal.

---

# Step 7 — Define Secondary Actions

Identificar ações como:

```text
Cancelar
Voltar
Editar
Excluir
Salvar rascunho
Duplicar
Exportar
```

Ações destrutivas ou menos frequentes não devem competir com a ação principal.

---

# Step 8 — Model Screen States

Não criar apenas o estado ideal.

Considerar:

### Default

Tela normal.

### Loading

Dados sendo carregados.

### Empty

Nenhum dado disponível.

### Error

Falha na operação.

### Success

Operação concluída.

### Disabled

Ação temporariamente indisponível.

### Partial

Alguns dados disponíveis, outros ainda carregando.

### Permission

Usuário sem autorização.

### Offline

Quando aplicável.

---

# Step 9 — Model Form States

Para formulários, considerar:

```text
Empty
Focused
Filled
Invalid
Valid
Disabled
Read-only
Loading
Submitting
Success
Error
```

Não assumir que um formulário possui apenas:

```text
vazio → preenchido → enviado
```

---

# Step 10 — Consider Responsive Structure

O wireframe deve considerar diferentes tamanhos de tela.

Pensar em:

```text
Desktop
Tablet
Mobile
```

Definir quando necessário:

- elementos desaparecem;
- elementos mudam de posição;
- colunas viram uma coluna;
- menus colapsam;
- tabelas se transformam;
- ações mudam de localização.

---

# Step 11 — Check Against User Flow

Comparar o wireframe com o User Flow.

Verificar:

```text
Flow Step 1 → Tela A
Flow Step 2 → Tela B
Flow Step 3 → Tela C
```

Perguntar:

- Todas as ações do fluxo estão representadas?
- Existem passos desnecessários?
- Existem decisões não representadas?
- Existem estados ausentes?
- O usuário consegue se recuperar de erros?
- O fluxo continua coerente?

---

# Step 12 — Validate the Wireframe

Antes de considerar o wireframe concluído:

### Task clarity

O usuário entende o que precisa fazer?

### Hierarchy

A informação mais importante aparece primeiro?

### Navigation

O usuário entende onde está e para onde pode ir?

### Actions

As ações estão claras?

### States

Os principais estados estão representados?

### Cognitive load

A tela possui informação demais?

### Consistency

A estrutura segue padrões já existentes?

### Accessibility

A estrutura permite uma experiência acessível?

---

# Wireframe Fidelity

## Low Fidelity

Utilizar quando:

- problema ainda está sendo explorado;
- várias soluções estão sendo comparadas;
- validação inicial é necessária.

Características:

- blocos;
- placeholders;
- poucos detalhes;
- foco em estrutura.

---

## Medium Fidelity

Utilizar quando:

- estrutura já está relativamente definida;
- é necessário validar conteúdo;
- fluxo precisa ser testado;
- componentes precisam ser representados com maior precisão.

Características:

- conteúdo aproximado do real;
- componentes identificáveis;
- hierarquia mais clara;
- estados representados.

---

## High Fidelity

Evitar chamar de wireframe quando o artefato já contém:

- cores finais;
- tipografia final;
- ícones finais;
- branding;
- componentes visuais refinados.

Nesse ponto, normalmente estamos entrando em:

- Visual Design;
- UI Component Design;
- Design System.

---

# Component Identification

Quando possível, identificar semanticamente os componentes.

Exemplo:

```text
Header
Sidebar
Breadcrumb
PageTitle
SearchInput
Filter
Table
Pagination
PrimaryButton
SecondaryButton
EmptyState
ErrorMessage
Modal
```

Evitar especificações visuais prematuras como:

```text
Button azul #123456
Border radius 8px
Shadow 0 4px 10px
```

Essas decisões pertencem principalmente ao Design System e Visual Design.

---

# Wireframe Annotation

Quando necessário, adicionar anotações para explicar comportamento.

Exemplo:

```text
[Salvar]

→ Envia formulário

→ Botão fica disabled durante processamento

→ Em sucesso:
   mostrar confirmação

→ Em erro:
   manter dados preenchidos
   mostrar mensagem de erro
```

Anotações são especialmente importantes para:

- estados;
- validações;
- comportamento condicional;
- integrações;
- regras complexas.

---

# Complex Interfaces

Para telas complexas, dividir em regiões.

Exemplo:

```text
┌───────────────────────────────────────┐
│ Header                                │
├──────────────┬────────────────────────┤
│              │ Page Header            │
│ Sidebar      ├────────────────────────┤
│              │ Filters                │
│              ├────────────────────────┤
│              │ Main Content           │
│              │                        │
│              ├────────────────────────┤
│              │ Pagination             │
└──────────────┴────────────────────────┘
```

Depois detalhar cada região.

Não tentar resolver toda a interface simultaneamente.

---

# Tables

Para interfaces com tabelas, analisar:

- colunas essenciais;
- colunas secundárias;
- ordenação;
- filtros;
- busca;
- paginação;
- seleção;
- ações por linha;
- ações em massa;
- estados vazios;
- loading;
- erros;
- responsividade.

Pergunta principal:

> Qual decisão o usuário precisa tomar usando esses dados?

Não adicionar colunas simplesmente porque o sistema possui esses dados.

---

# Dashboards

Para dashboards:

1. identificar decisões importantes;
2. identificar métricas prioritárias;
3. agrupar informações relacionadas;
4. definir hierarquia;
5. evitar excesso de widgets;
6. priorizar ações e alertas relevantes.

Dashboard não deve ser apenas uma coleção de gráficos.

---

# Forms

Para formulários:

- agrupar campos relacionados;
- separar informações por contexto;
- definir campos obrigatórios;
- reduzir campos desnecessários;
- definir ordem de preenchimento;
- evitar múltiplas decisões simultâneas;
- representar validações;
- representar erros;
- definir confirmação.

Pergunta principal:

> Qual é a menor quantidade de informação necessária para completar a tarefa corretamente?

---

# Modals and Drawers

Usar modal quando:

- a tarefa é curta;
- o contexto da tela atual ainda é importante;
- não é necessário navegar para uma nova página.

Usar página quando:

- a tarefa é complexa;
- existem muitos campos;
- existe navegação própria;
- o usuário precisa de espaço e contexto.

Usar drawer quando:

- o conteúdo é contextual;
- o usuário precisa consultar a tela anterior;
- a tarefa é relativamente simples.

Não transformar qualquer interação em modal.

---

# Accessibility Considerations

Mesmo em wireframes, considerar:

- ordem lógica de leitura;
- foco;
- navegação por teclado;
- tamanho dos alvos;
- labels claros;
- mensagens de erro;
- agrupamento semântico;
- estados não dependentes apenas de cor;
- conteúdo compreensível sem elementos visuais.

Acessibilidade começa na estrutura, não apenas no CSS.

---

# Outputs

Um wireframe deve produzir, quando aplicável:

```text
Screen Structure
Content Hierarchy
Layout
Navigation
Primary Actions
Secondary Actions
Component Structure
Interaction Notes
Screen States
Form States
Responsive Considerations
Accessibility Considerations
Open Questions
```

---

# Recommended Output Format

Ao documentar um wireframe:

```text
## Screen

### Objective

<objetivo da tela>

### User Task

<tarefa principal>

### Layout

<estrutura>

### Content Hierarchy

1. ...
2. ...
3. ...

### Components

- ...
- ...
- ...

### Primary Action

...

### Secondary Actions

...

### States

- Default
- Loading
- Empty
- Error
- Success

### Interactions

...

### Responsive Behavior

...

### Accessibility

...

### Open Questions

- ...
```

---

# Quality Criteria

Um bom wireframe:

- representa claramente o objetivo da tela;
- possui hierarquia compreensível;
- suporta o user flow;
- apresenta ações claras;
- considera estados;
- utiliza conteúdo suficientemente realista;
- evita complexidade desnecessária;
- considera responsividade;
- considera acessibilidade;
- pode ser validado com usuários;
- não depende de detalhes visuais para fazer sentido.

---

# Anti-Patterns

## Wireframe bonito demais

Problema:

O time começa a discutir estética antes de validar estrutura.

---

## Lorem ipsum everywhere

Problema:

Ignora o impacto do conteúdo real no layout.

---

## Apenas happy path

Problema:

A interface quebra quando ocorre erro, loading ou ausência de dados.

---

## Tela isolada

Problema:

A tela pode parecer boa individualmente, mas não funcionar dentro do fluxo.

---

## Excesso de informação

Problema:

Tudo é colocado na tela porque "pode ser útil".

---

## Excesso de ações

Problema:

Todas as ações recebem a mesma importância.

---

## Modal para tudo

Problema:

Interações complexas ficam comprimidas em espaços inadequados.

---

## Copiar sistema existente sem questionar

Problema:

Mantém problemas históricos da interface.

---

## Ignorar mobile

Problema:

A estrutura funciona apenas em desktop.

---

## Ignorar acessibilidade

Problema:

Decisões estruturais podem impedir uma experiência acessível posteriormente.

---

# Rule of Thumb

> **Wireframe não serve para mostrar como a interface vai parecer. Serve para mostrar como a interface vai funcionar.**

Antes de perguntar:

> "Está bonito?"

Pergunte:

> "O usuário consegue entender o que fazer, encontrar o que precisa e concluir a tarefa?"

---

# Final Principle

**Primeiro estrutura.
Depois interação.
Depois visual.**

Um bom wireframe reduz incerteza antes que decisões visuais e técnicas se tornem caras de mudar.
