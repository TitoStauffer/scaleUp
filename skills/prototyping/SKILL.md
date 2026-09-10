---
name: prototyping
description: Criação e planejamento de protótipos de interfaces para explorar, comunicar e validar fluxos, interações, arquitetura e soluções de UX. Define fidelidade, escopo, estados, transições, cenários de teste e critérios de validação. Use quando for necessário transformar uma solução de design em uma experiência navegável antes ou durante a implementação.
---

# Prototyping

## Objective

Criar protótipos que permitam simular uma experiência de produto antes de sua implementação completa.

O protótipo deve permitir responder perguntas como:

- O fluxo faz sentido?
- A navegação é compreensível?
- A interação é previsível?
- A estrutura da interface funciona?
- O usuário consegue completar a tarefa?
- Uma determinada solução merece ser implementada?
- Quais riscos ainda existem?

O objetivo não é construir o produto final.

O objetivo é:

> **aprender antes de investir na implementação.**

---

# Core Principles

## 1. Prototype to Answer a Question

Todo protótipo deve existir para responder uma ou mais perguntas.

Exemplo:

```text
Pergunta:

Usuários entendem o novo fluxo de checkout?

Protótipo:

Somente fluxo de checkout.
```

Evitar criar protótipos enormes sem objetivo claro.

---

## 2. Fidelity Should Match the Question

Escolher a fidelidade necessária para responder à pergunta.

```text
Baixa fidelidade
→ estrutura

Média fidelidade
→ fluxo + interação

Alta fidelidade
→ comportamento + visual
```

Não construir um protótipo de alta fidelidade quando um wireframe já responderia à pergunta.

---

## 3. Prototype the Risk

Priorizar partes com maior incerteza.

Exemplos:

- fluxo novo;
- interação incomum;
- decisão crítica;
- navegação complexa;
- componente novo;
- comportamento assíncrono.

---

## 4. Prototype Behavior, Not Just Screens

Um protótipo útil representa:

```text
Tela
 ↓
Ação
 ↓
Resposta
 ↓
Novo estado
 ↓
Próxima ação
```

Não apenas uma coleção de telas estáticas.

---

## 5. Prototype Is Disposable

Protótipo pode ser descartado.

Não existe obrigação de preservar uma solução apenas porque houve investimento na sua criação.

Se o teste demonstrar que a ideia não funciona:

> isso é aprendizado, não desperdício.

---

# When to Use

Use esta Skill quando:

- uma nova feature precisa ser explorada;
- um fluxo é complexo;
- uma interação precisa ser validada;
- wireframes precisam virar experiência navegável;
- usuários precisam testar uma solução antes do desenvolvimento;
- stakeholders precisam visualizar uma proposta;
- existem múltiplas soluções possíveis;
- uma decisão possui alto risco;
- uma mudança significativa precisa ser validada.

---

# When Not to Use

Não criar protótipo quando:

- a pergunta já foi respondida;
- a solução é trivial;
- o componente já possui padrão consolidado;
- o custo do protótipo supera o valor do aprendizado;
- o protótipo está sendo criado apenas para "parecer pronto".

---

# Inputs

Considerar:

### Product

- problema;
- objetivo;
- requisitos;
- hipóteses;
- critérios de sucesso.

### UX

- research;
- personas;
- journey;
- user flows.

### IA

- navegação;
- estrutura;
- conteúdo.

### Wireframes

- layout;
- telas;
- componentes.

### Interaction Design

- comportamentos;
- estados;
- feedback;
- transições.

### Visual Design

- hierarquia;
- tipografia;
- cores;
- linguagem visual.

### Design System

- componentes;
- tokens;
- padrões.

---

# Prototype Fidelity

## Low Fidelity

Foco:

- estrutura;
- fluxo;
- arquitetura;
- conteúdo principal.

Características:

```text
Boxes
Simple labels
Basic navigation
Minimal visual styling
```

Ideal para:

- exploração inicial;
- comparação de estruturas;
- testes rápidos.

---

# Medium Fidelity

Foco:

- interação;
- conteúdo;
- navegação;
- componentes;
- estados principais.

Características:

```text
Realistic structure
Representative content
Basic component styling
Clickable interactions
```

Ideal para:

- usability testing;
- validação de fluxo;
- avaliação de arquitetura.

---

# High Fidelity

Foco:

- visual;
- interação;
- comportamento;
- detalhes próximos da implementação.

Pode incluir:

- design system;
- animações;
- transições;
- conteúdo real;
- estados detalhados.

Ideal quando:

- decisões visuais importam;
- comportamento complexo precisa ser validado;
- stakeholders precisam avaliar experiência próxima da realidade.

---

# Fidelity Decision

Perguntar:

```text
O que queremos descobrir?
        ↓
É estrutura?
        ↓
Low fidelity

É fluxo/interação?
        ↓
Medium fidelity

É visual/comportamento detalhado?
        ↓
High fidelity
```

---

# Prototype Scope

Definir explicitamente:

```text
Included:
<o que será prototipado>

Excluded:
<o que não será prototipado>

Question:
<o que queremos aprender>
```

Isso evita escopo desnecessário.

---

# Prototype Flow

Representar:

```text
Entry Point
     ↓
Screen A
     ↓
Action
     ↓
Screen B
     ↓
Decision
   ↙   ↘
Yes     No
 ↓       ↓
C       D
```

O protótipo deve representar o caminho necessário para responder à pergunta.

---

# Happy Path

Sempre que necessário, começar pelo fluxo principal.

Exemplo:

```text
Login
 ↓
Dashboard
 ↓
Create Customer
 ↓
Fill Form
 ↓
Save
 ↓
Success
```

Depois expandir para casos importantes.

---

# Edge Cases

Adicionar quando fizerem parte do risco da solução.

Exemplos:

```text
Invalid input
Empty state
Error
Permission denied
Loading
Timeout
Cancel
Back
Duplicate action
```

Não prototipar todos os edge cases automaticamente.

Priorizar os que podem alterar a decisão de design.

---

# Interactive States

Representar estados relevantes:

```text
Default
Hover
Focus
Pressed
Loading
Disabled
Error
Success
Selected
Expanded
Collapsed
```

---

# Async Prototyping

Operações assíncronas devem parecer assíncronas quando isso for relevante para o teste.

Exemplo:

```text
Click Save
     ↓
Submitting
     ↓
Processing
     ↓
Success
```

Não simular uma operação instantânea quando o tempo de resposta influencia a experiência.

---

# Prototype Data

Quando possível, utilizar dados realistas.

Exemplo:

```text
Cliente:
Maria Oliveira

Pedido:
#PED-10482

Valor:
R$ 1.245,90
```

Evitar:

```text
User 123
Item ABC
Lorem ipsum
```

Conteúdo influencia a percepção da experiência.

---

# Data Variation

Testar diferentes formatos:

```text
Short text
Long text
Large numbers
Empty values
Multiple items
No results
Error messages
```

Isso ajuda a descobrir problemas estruturais.

---

# Navigation Prototype

Definir:

- entry points;
- back;
- forward;
- menus;
- tabs;
- breadcrumbs;
- modal;
- drawer;
- deep links.

A navegação deve preservar contexto.

---

# Prototype Interaction Model

Documentar:

```text
Trigger
 ↓
Action
 ↓
Response
 ↓
State
 ↓
Next available actions
```

Exemplo:

```text
Usuário seleciona cliente
        ↓
Sistema carrega dados
        ↓
Loading
        ↓
Dados aparecem
        ↓
Usuário pode editar
```

---

# Forms

Prototipar:

```text
Empty
 ↓
Typing
 ↓
Filled
 ↓
Validation
 ↓
Submit
 ↓
Success / Error
```

Quando necessário, representar:

- máscaras;
- validações;
- campos condicionais;
- dependências;
- erros;
- submit;
- loading.

---

# Conditional Logic

Quando o fluxo possuir decisões:

```text
Tipo de cliente?
      ↓
Pessoa física
      → CPF

Pessoa jurídica
      → CNPJ
```

O protótipo deve representar a lógica necessária para o teste.

---

# Progressive Disclosure

Prototipar conteúdo que aparece sob demanda.

Exemplo:

```text
Informações básicas
        ↓
"Mostrar detalhes"
        ↓
Informações adicionais
```

Validar se:

- o usuário encontra;
- entende;
- utiliza;
- percebe a mudança.

---

# Modal Prototyping

Quando utilizar modal, testar:

```text
Open
 ↓
Interaction
 ↓
Confirm
 ↓
Success
```

e:

```text
Open
 ↓
Cancel / Escape
 ↓
Close
 ↓
Return to previous context
```

---

# Drawer Prototyping

Testar:

- abertura;
- fechamento;
- scroll;
- interação;
- overlay;
- contexto;
- mobile.

---

# Responsive Prototyping

Quando responsividade fizer parte da pergunta, criar versões representativas:

```text
Desktop
Tablet
Mobile
```

Não é necessário prototipar todos os tamanhos possíveis.

Testar os pontos onde o comportamento muda.

---

# Mobile Prototype

Considerar:

- touch;
- tamanho dos targets;
- keyboard;
- scroll;
- gestures;
- bottom navigation;
- drawers;
- sticky actions.

---

# Accessibility Prototype

Mesmo protótipos devem considerar:

- ordem de navegação;
- labels;
- foco;
- contraste quando visual relevante;
- tamanho dos targets;
- alternativas a gestures;
- estados.

Um protótipo não precisa implementar toda acessibilidade técnica, mas não deve validar uma solução impossível de tornar acessível.

---

# Animation Prototype

Adicionar animação quando ela fizer parte da pergunta.

Exemplo:

```text
Pergunta:
Usuários entendem que o painel desliza lateralmente?

→ Prototipar a transição.
```

Não gastar tempo animando elementos que não afetam a decisão.

---

# Motion Specification

Quando motion for importante:

```text
Trigger:
Click

Animation:
Slide

Duration:
<valor>

Purpose:
Comunicar mudança de contexto

Reduced Motion:
Alternative transition
```

---

# Prototype Variants

Quando existem soluções diferentes:

```text
Prototype A
Prototype B
```

Manter as diferenças controladas.

Exemplo:

```text
A:
Filters in sidebar

B:
Filters in top bar
```

Evitar alterar múltiplas variáveis simultaneamente quando isso dificultar interpretação do teste.

---

# Comparative Prototype

Estrutura:

```text
Question
 ↓
Hypothesis A
 ↓
Prototype A

Question
 ↓
Hypothesis B
 ↓
Prototype B
```

Definir previamente:

- o que está sendo comparado;
- qual tarefa será utilizada;
- quais critérios serão observados.

---

# Prototype Testing

Depois de criado:

```text
Prototype
 ↓
Test
 ↓
Observation
 ↓
Findings
 ↓
Iteration
```

Conectar diretamente com:

```text
usability-testing
```

---

# Prototype Versioning

Registrar:

```text
Prototype:
v0.1

Date:
YYYY-MM-DD

Scope:
Customer creation flow

Changes:
Initial prototype
```

Depois:

```text
v0.2
v0.3
v1.0
```

Isso evita confundir resultados entre versões.

---

# Prototype Change Log

Exemplo:

```text
## v0.2

Changed:
- Moved primary action to page header.
- Added inline validation.
- Changed filter interaction.

Reason:
Users failed to discover the previous interaction.
```

---

# Prototype Review

Antes do teste:

### Scope

O protótipo cobre a pergunta?

### Flow

O fluxo pode ser executado?

### Interaction

As ações estão conectadas?

### States

Os estados necessários existem?

### Content

O conteúdo representa o cenário?

### Fidelity

O nível de fidelidade é suficiente?

### Accessibility

A solução pode ser utilizada de maneira acessível?

### Responsive

O contexto necessário está representado?

---

# Prototype Handoff

Quando o protótipo estiver pronto para desenvolvimento, separar:

```text
Prototype
≠
Final Specification
```

O protótipo demonstra uma experiência.

A especificação deve definir:

- comportamento;
- componentes;
- estados;
- regras;
- tokens;
- acessibilidade;
- responsividade.

---

# Prototype Documentation

Utilizar:

```text
## Prototype

### Objective

<objetivo>

### Question

<pergunta>

### Hypothesis

<hipótese>

### Scope

<escopo>

### Fidelity

<low / medium / high>

### Flow

<fluxo>

### Screens

<telas>

### Interactions

<interações>

### States

<estados>

### Edge Cases

<casos relevantes>

### Responsive

<adaptações>

### Accessibility

<considerações>

### Test Plan

<como será validado>
```

---

# Prototype Success Criteria

Definir antecipadamente o que significa "protótipo suficiente".

Exemplo:

```text
Prototype is ready when:

[ ] Primary flow is navigable
[ ] Critical interactions are represented
[ ] Relevant states exist
[ ] Content is realistic
[ ] Test task can be completed
[ ] Prototype answers the research question
```

Não buscar perfeição.

---

# Prototype vs Production

Nunca assumir:

```text
Protótipo funcionando
=
Produto pronto
```

O protótipo pode esconder:

- backend;
- performance;
- segurança;
- persistência;
- regras complexas;
- integrações;
- erros reais.

Seu objetivo é validar experiência, não substituir implementação.

---

# Technical Simulation

Quando necessário, simular:

```text
Loading
API response
Error
Empty state
Permission
Latency
Success
```

A simulação deve existir para validar comportamento.

---

# Risk-Based Prototyping

Priorizar prototipagem onde houver:

```text
High uncertainty
+
High impact
```

Exemplo:

```text
Nova interação de pagamento
→ alto risco

Nova alteração de cor
→ baixo risco
```

O primeiro merece prototipagem mais cuidadosa.

---

# Prototype Debt

Evitar transformar protótipo em produto permanente.

Sinais:

```text
Prototype survives many iterations
+
Developers use it as specification
+
Behavior exists only in prototype
```

Nesse ponto, transformar aprendizado em documentação e implementação adequada.

---

# Quality Criteria

Um bom protótipo:

- possui objetivo claro;
- responde uma pergunta específica;
- possui escopo controlado;
- utiliza fidelidade adequada;
- representa o fluxo;
- possui interações relevantes;
- representa estados importantes;
- utiliza conteúdo realista;
- permite teste;
- possui versão identificável;
- pode ser descartado;
- gera aprendizado acionável.

---

# Anti-Patterns

## High Fidelity Too Early

Investir horas em visual antes de validar estrutura.

---

## Prototype Everything

Prototipar cada detalhe sem necessidade.

---

## No Research Question

Criar protótipo sem saber o que precisa ser aprendido.

---

## Static Screens Only

Criar várias telas bonitas sem representar comportamento.

---

## Fake Perfect Flow

Representar apenas o caminho ideal.

---

## Unrealistic Content

Usar conteúdo que não representa o uso real.

---

## Prototype as Final Product

Tratar protótipo como implementação pronta.

---

## No Versioning

Não registrar qual versão foi testada.

---

## No Testing

Criar protótipo e nunca colocá-lo diante de usuários.

---

## Prototype Theater

Criar algo visualmente impressionante apenas para apresentação, sem objetivo de aprendizado.

---

## Overengineering

Construir infraestrutura complexa para validar uma hipótese simples.

---

# Prototyping Checklist

```text
[ ] Objective definido
[ ] Research question definida
[ ] Hypothesis definida
[ ] Risk identificado
[ ] Scope definido
[ ] Fidelity definida
[ ] Primary flow definido
[ ] Interactions definidas
[ ] States definidos
[ ] Error states definidos quando relevantes
[ ] Content realista
[ ] Conditional logic representada
[ ] Responsive considerado
[ ] Accessibility considerada
[ ] Prototype version registrada
[ ] Test plan definido
[ ] Success criteria definidos
[ ] Limitations documentadas
[ ] Handoff separado da especificação final
```

---

# Rule of Thumb

> **Prototipe aquilo que você ainda não sabe.**

Se você já sabe que uma solução funciona e existe um padrão estabelecido, provavelmente não precisa de um protótipo elaborado.

Se existe:

```text
Dúvida
+
Risco
+
Decisão
```

o protótipo pode ser uma das formas mais baratas de aprender antes de construir.

---

# Final Principle

**Um protótipo é uma pergunta transformada em experiência.**

O ciclo deve ser:

```text
Pergunta
   ↓
Hipótese
   ↓
Protótipo
   ↓
Teste
   ↓
Evidência
   ↓
Decisão
   ↓
Iteração
```

O melhor protótipo não é o mais detalhado.

É o que **responde à pergunta certa com o menor investimento necessário**.
