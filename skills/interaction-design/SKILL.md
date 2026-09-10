---
name: interaction-design
description: Design de interações, comportamentos, estados, feedbacks, transições e respostas da interface para criar experiências previsíveis, eficientes e intuitivas. Use quando for necessário definir como componentes e telas respondem às ações do usuário.
---

# Interaction Design

## Objective

Projetar como a interface responde às ações do usuário.

O foco desta Skill é definir:

- ações;
- respostas;
- estados;
- feedbacks;
- transições;
- comportamentos;
- validações;
- erros;
- recuperação;
- confirmações;
- interações assíncronas.

O objetivo é fazer com que o usuário consiga prever:

> "Se eu fizer isso, o que vai acontecer?"

Uma boa interação reduz:

- incerteza;
- esforço cognitivo;
- erros;
- frustração;
- ações desnecessárias.

---

# Core Principles

## 1. Every Action Needs a Response

Toda ação relevante do usuário deve possuir uma resposta perceptível.

Exemplo:

```text
Usuário clica em "Salvar"
        ↓
Sistema processa
        ↓
Botão muda de estado
        ↓
Sistema confirma operação
        ↓
Interface atualiza
```

Nunca deixar o usuário sem saber se a ação foi registrada.

---

## 2. Make the System State Visible

O usuário deve conseguir entender o estado atual do sistema.

Exemplos:

```text
Loading
Processing
Saved
Error
Disabled
Offline
Pending
Completed
```

Evitar situações em que o usuário precise adivinhar o que está acontecendo.

---

## 3. Predictability

Interações devem seguir padrões previsíveis.

Se um elemento parece clicável, deve se comportar como clicável.

Se uma ação é destrutiva, deve deixar isso claro.

Se uma operação demora, deve comunicar processamento.

---

## 4. Immediate Feedback

Sempre que possível, fornecer feedback imediatamente.

Exemplos:

- botão muda de estado;
- campo mostra validação;
- item recebe confirmação visual;
- loading aparece;
- mensagem informa resultado.

Feedback não precisa significar que a operação terminou.

Pode significar:

> "Recebi sua ação e estou processando."

---

## 5. Prevent Errors Before Handling Them

Priorizar prevenção de erros.

Ordem de preferência:

```text
Prevenir
   ↓
Orientar
   ↓
Validar
   ↓
Explicar
   ↓
Permitir recuperação
```

Exemplo ruim:

```text
Usuário preenche tudo
        ↓
Clica em salvar
        ↓
Sistema informa que faltou um campo
```

Melhor:

```text
Campo obrigatório
        ↓
Usuário tenta continuar
        ↓
Interface aponta exatamente o problema
```

---

# When to Use

Use esta Skill quando:

- uma nova interação precisa ser definida;
- um componente possui comportamentos complexos;
- existe dúvida sobre estados;
- uma tela possui operações assíncronas;
- formulários precisam de validação;
- ações destrutivas precisam ser projetadas;
- feedbacks precisam ser definidos;
- uma interface possui múltiplos estados;
- existe fricção em uma interface existente;
- uma feature depende de interações entre componentes.

---

# Inputs

Considerar quando disponíveis:

### Product

- objetivo;
- requisitos;
- regras de negócio;
- critérios de sucesso.

### UX

- personas;
- user journey;
- user flow;
- pain points;
- research.

### IA

- estrutura de navegação;
- hierarquia;
- conteúdo.

### Wireframes

- telas;
- componentes;
- layout;
- ações.

### Technical

- operações síncronas;
- operações assíncronas;
- integrações;
- permissões;
- estados de backend;
- possíveis falhas.

---

# Interaction Model

Toda interação importante deve ser analisada através do modelo:

```text
Trigger
   ↓
Action
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
Usuário clica em "Enviar"

Action:
Submit formulário

System Response:
Valida dados

New State:
Submitting

Feedback:
Botão mostra processamento

↓

Success
ou
Error
```

---

# Step 1 — Identify the Trigger

Determinar o que inicia a interação.

Exemplos:

- click;
- tap;
- hover;
- focus;
- typing;
- selection;
- scroll;
- drag;
- keyboard shortcut;
- submit;
- page load;
- system event.

Não assumir que toda interação começa com um clique.

---

# Step 2 — Define the User Action

Descrever exatamente o que o usuário faz.

Exemplo:

```text
Usuário seleciona um cliente
```

ou:

```text
Usuário altera o status do pedido para "Cancelado"
```

Evitar descrições vagas como:

```text
Usuário interage com a tela.
```

---

# Step 3 — Define System Response

Determinar como o sistema responde.

Exemplo:

```text
Usuário seleciona cliente
        ↓
Sistema carrega dados
        ↓
Interface atualiza formulário
```

Considerar:

- resposta imediata;
- resposta assíncrona;
- falha;
- timeout;
- retry.

---

# Step 4 — Define the Resulting State

Toda interação pode mudar o estado da interface.

Exemplo:

```text
Default
   ↓
Focused
   ↓
Filled
   ↓
Submitting
   ↓
Success
```

Ou:

```text
Default
   ↓
Submitting
   ↓
Error
   ↓
Retry
```

---

# Component States

Todo componente interativo deve ter estados definidos quando aplicável.

## Button

```text
Default
Hover
Focus
Pressed
Loading
Disabled
Success
Error
```

---

## Input

```text
Empty
Focused
Filled
Valid
Invalid
Disabled
Read-only
Loading
```

---

## Checkbox

```text
Unchecked
Checked
Indeterminate
Focused
Disabled
```

---

## Select

```text
Closed
Focused
Open
Selected
Disabled
Loading
Error
```

---

## Modal

```text
Closed
Opening
Open
Submitting
Success
Error
Closing
```

Não é necessário implementar todos os estados visualmente.

A regra é:

> Definir os estados relevantes para o comportamento real.

---

# Loading States

Loading deve comunicar progresso ou processamento.

Evitar:

```text
Tela congelada
```

Preferir:

```text
Ação realizada
      ↓
Loading
      ↓
Resultado
```

Tipos possíveis:

### Full-page loading

Quando a tela inteira depende da operação.

### Section loading

Quando apenas uma parte está sendo carregada.

### Skeleton

Quando a estrutura do conteúdo pode ser antecipada.

### Button loading

Quando uma ação específica está sendo processada.

### Inline loading

Quando apenas um elemento precisa indicar processamento.

Escolher o padrão que preserve maior contexto possível.

---

# Async Interactions

Para operações assíncronas:

```text
Idle
 ↓
Processing
 ↓
Success
```

ou:

```text
Idle
 ↓
Processing
 ↓
Error
 ↓
Retry
```

Definir também:

- o usuário pode sair da tela?
- pode executar novamente?
- pode cancelar?
- pode editar durante processamento?
- o resultado pode chegar depois?
- o que acontece se a resposta atrasar?

---

# Optimistic UI

Usar atualização otimista quando apropriado.

Exemplo:

```text
Usuário marca item como favorito
        ↓
Interface atualiza imediatamente
        ↓
Backend processa
```

Se falhar:

```text
Backend Error
      ↓
Reverter estado
      ↓
Informar usuário
```

Não utilizar optimistic UI quando inconsistências temporárias possam causar consequências importantes.

---

# Forms

## Validation Timing

Definir quando validar.

Possibilidades:

```text
On typing
On blur
On change
On submit
```

Escolher baseado no contexto.

---

## Error Messages

Mensagens devem responder:

1. O que aconteceu?
2. Onde está o problema?
3. Como corrigir?

Exemplo ruim:

```text
Erro inválido.
```

Melhor:

```text
CPF inválido.
Confira os números digitados.
```

---

# Destructive Actions

Para ações destrutivas:

```text
Excluir
Cancelar operação
Remover
Desativar
Apagar
```

Avaliar:

- confirmação;
- possibilidade de undo;
- impacto;
- reversibilidade;
- consequência;
- frequência.

Não criar confirmação para toda ação.

Confirmações excessivas geram:

> confirmation fatigue

---

# Undo

Quando a ação for reversível, considerar:

```text
Ação executada
      ↓
Toast / feedback
      ↓
[Desfazer]
```

Undo pode ser melhor que:

```text
Você tem certeza?
```

quando a operação é facilmente reversível.

---

# Confirmation

Usar confirmação quando:

- impacto é alto;
- ação é destrutiva;
- operação é difícil de reverter;
- consequência não é óbvia.

A confirmação deve explicar a consequência.

Exemplo:

```text
Excluir cliente?

Os dados relacionados a este cliente serão removidos.

[Cancelar] [Excluir cliente]
```

Evitar:

```text
Tem certeza?
```

sem contexto.

---

# Feedback Design

Feedback pode ser:

### Visual

- mudança de estado;
- mensagem;
- indicador;
- animação.

### Textual

- confirmação;
- erro;
- orientação.

### Auditory

Quando aplicável.

### Haptic

Especialmente em mobile.

Não depender exclusivamente de uma única modalidade.

---

# Notifications

Diferenciar:

```text
Toast
Inline message
Banner
Dialog
Notification
```

Usar o nível adequado à importância.

### Toast

Para feedback breve e não bloqueante.

### Inline

Para problemas ou informações diretamente relacionadas ao conteúdo.

### Banner

Para situações relevantes para uma área ou página.

### Dialog

Para decisões que precisam interromper o fluxo.

---

# Navigation Interactions

Definir:

- back;
- forward;
- tabs;
- breadcrumbs;
- deep links;
- abertura de modal;
- fechamento;
- retorno ao contexto anterior.

Perguntar:

> Depois da ação, para onde o usuário espera ir?

Evitar redirecionamentos inesperados.

---

# Keyboard Interaction

Para interfaces desktop, considerar:

- Tab;
- Shift + Tab;
- Enter;
- Space;
- Escape;
- Arrow keys;
- atalhos quando apropriado.

Exemplo:

```text
Modal aberto
   ↓
Focus trap
   ↓
Escape
   ↓
Modal fecha
   ↓
Focus retorna ao elemento anterior
```

---

# Focus Management

Sempre considerar onde o foco deve estar após uma mudança de estado.

Exemplo:

```text
Usuário envia formulário
        ↓
Erro
        ↓
Foco vai para primeiro campo inválido
```

Ou:

```text
Modal fecha
        ↓
Foco retorna para botão que abriu o modal
```

Isso é especialmente importante para acessibilidade.

---

# Mobile Interactions

Considerar:

- touch target;
- gestos;
- teclado virtual;
- scroll;
- orientação;
- bottom sheets;
- menus;
- feedback háptico;
- áreas de toque.

Nunca assumir que:

```text
hover = touch
```

---

# Microinteractions

Microinterações podem comunicar:

- confirmação;
- progresso;
- mudança de estado;
- relacionamento entre elementos;
- feedback.

Exemplos:

```text
Like
Toggle
Favorite
Copy
Save
Expand
Collapse
```

Devem ter propósito funcional.

Não adicionar animação apenas porque "fica bonito".

---

# Animation

Animações devem ajudar a comunicar:

- continuidade;
- causa e efeito;
- mudança de estado;
- hierarquia;
- orientação espacial.

Evitar animações:

- longas;
- excessivas;
- inesperadas;
- que atrasam tarefas.

Sempre considerar usuários com preferência por movimento reduzido.

---

# Error Recovery

Todo erro importante deve responder:

```text
O que aconteceu?
      ↓
O que posso fazer?
      ↓
Posso tentar novamente?
```

Exemplo:

```text
Não foi possível salvar o pedido.

Seus dados continuam preenchidos.

[Tentar novamente]
```

Evitar simplesmente:

```text
Erro 500
```

---

# Empty States

Estado vazio também é uma interação.

Exemplo:

```text
Nenhum pedido encontrado.

Você ainda não possui pedidos cadastrados.

[Cadastrar pedido]
```

Quando apropriado, o empty state deve orientar o próximo passo.

---

# Permissions

Quando uma ação depende de permissão:

```text
Visible + enabled
Visible + disabled
Hidden
```

Escolher de acordo com o contexto.

Não expor ações impossíveis sem explicar o motivo quando a informação for relevante.

---

# Edge Cases

Sempre investigar:

- usuário clica duas vezes;
- usuário abandona operação;
- usuário volta;
- rede cai;
- request demora;
- request falha;
- sessão expira;
- dados mudam externamente;
- outro usuário altera o registro;
- operação é repetida;
- resposta chega fora de ordem.

---

# Idempotency and Repeated Actions

Para ações críticas, considerar:

```text
Clique
 ↓
Processing
 ↓
Botão disabled
```

Quando apropriado, impedir múltiplos submits acidentais.

Isso é especialmente importante para:

- pagamentos;
- criação de pedidos;
- transferências;
- envio de documentos;
- operações irreversíveis.

---

# Interaction Documentation

Documentar interações complexas no formato:

```text
## Interaction

### Trigger

<evento>

### User Action

<ação>

### System Response

<resposta>

### States

- Default
- Loading
- Success
- Error

### Feedback

<feedback>

### Recovery

<como recuperar>

### Accessibility

<comportamento de teclado/foco>

### Edge Cases

- ...
- ...
```

---

# Interaction Matrix

Para interfaces complexas, utilizar uma matriz:

| Elemento | Ação | Estado inicial | Resposta | Estado final | Erro |
|---|---|---|---|---|---|
| Button | Click | Default | Submit | Loading | Error |
| Input | Blur | Filled | Validate | Valid/Invalid | Message |
| Modal | Escape | Open | Close | Closed | — |
| Select | Change | Selected | Update | New value | Error |

Isso ajuda a encontrar estados esquecidos.

---

# Quality Criteria

Uma interação bem projetada:

- é previsível;
- fornece feedback;
- possui estados claros;
- evita erros;
- permite recuperação;
- não exige esforço desnecessário;
- respeita o contexto;
- funciona com teclado;
- funciona em touch quando necessário;
- comunica operações assíncronas;
- possui comportamento consistente.

---

# Anti-Patterns

## No Feedback

Usuário não sabe se a ação funcionou.

---

## Invisible State

O sistema está processando algo, mas a interface parece parada.

---

## Generic Errors

```text
Algo deu errado.
```

sem orientação adicional.

---

## Confirmation Everywhere

Confirmar ações triviais cria fricção.

---

## Animation for Decoration

Movimento sem função aumenta distração.

---

## Surprise Navigation

Usuário é redirecionado sem entender por quê.

---

## Disabled Without Explanation

Uma ação está desabilitada e o usuário não sabe como habilitá-la.

---

## Hover-Only Information

Informação essencial disponível apenas via hover.

---

## Double Submit

Usuário consegue disparar múltiplas vezes uma operação crítica.

---

## Happy Path Only

A interação funciona apenas quando tudo dá certo.

---

# Interaction Checklist

Antes de aprovar uma interação:

```text
[ ] Trigger definido
[ ] Ação definida
[ ] Resposta definida
[ ] Estado inicial definido
[ ] Estado final definido
[ ] Loading definido
[ ] Success definido
[ ] Error definido
[ ] Recovery definido
[ ] Feedback definido
[ ] Edge cases analisados
[ ] Keyboard definido
[ ] Focus definido
[ ] Mobile considerado
[ ] Accessibility considerada
```

---

# Rule of Thumb

> **Toda ação do usuário deve produzir uma resposta compreensível.**

O usuário nunca deveria precisar perguntar:

> "Será que clicou?"

> "Está carregando?"

> "Deu certo?"

> "Posso clicar de novo?"

> "O que aconteceu?"

---

# Final Principle

**Design não é apenas desenhar o que aparece na tela.**

É definir o que acontece:

```text
antes da ação
durante a ação
depois da ação
quando dá certo
quando dá errado
e quando o usuário muda de ideia.
```

Uma interface excelente não apenas mostra informações.

**Ela conversa com o usuário através de suas respostas.**
