---
name: accessibility-design
description: Design de experiências digitais acessíveis para diferentes capacidades, contextos e formas de interação. Define requisitos de acessibilidade para conteúdo, navegação, componentes, teclado, foco, leitores de tela, contraste, movimento, formulários, responsividade e estados. Use quando uma interface precisar ser inclusiva, acessível e compatível com diferentes tecnologias assistivas.
---

# Accessibility Design

## Objective

Projetar interfaces que possam ser compreendidas, navegadas e utilizadas por pessoas com diferentes capacidades e diferentes formas de interação.

Acessibilidade deve ser considerada desde:

```text
Research
   ↓
UX
   ↓
IA
   ↓
Flow
   ↓
Wireframe
   ↓
Interaction
   ↓
Visual
   ↓
Components
   ↓
Frontend
```

e não apenas durante QA.

O objetivo é garantir que a interface seja:

- perceptível;
- compreensível;
- navegável;
- operável;
- robusta;
- consistente;
- compatível com tecnologias assistivas.

---

# Core Principles

## 1. Accessibility by Default

Acessibilidade deve ser uma propriedade padrão do produto.

Não tratar como:

> "Uma melhoria que podemos adicionar depois."

Quanto mais tarde uma barreira é descoberta, maior tende a ser o custo para corrigi-la.

---

## 2. Design for Different Abilities

Considerar diferentes necessidades relacionadas a:

- visão;
- audição;
- mobilidade;
- cognição;
- fala;
- atenção;
- processamento de informação.

Também considerar limitações temporárias ou situacionais.

Exemplos:

```text
Visão reduzida
Braço lesionado
Ambiente muito barulhento
Conexão ruim
Uso com uma mão
Alta luminosidade
Baixa luminosidade
```

Acessibilidade beneficia mais pessoas do que apenas aquelas que possuem uma deficiência permanente.

---

## 3. Don't Rely on a Single Signal

Nunca depender exclusivamente de:

- cor;
- som;
- posição;
- animação;
- ícone;
- hover.

Exemplo ruim:

```text
Campo vermelho = erro
```

Melhor:

```text
Campo
+
Mensagem de erro
+
Estado visual
```

---

## 4. Semantic Structure

A estrutura semântica deve comunicar significado.

Preferir:

```text
button
nav
main
header
footer
label
heading
```

quando apropriado.

Evitar substituir elementos semânticos por elementos genéricos sem necessidade.

---

## 5. Keyboard First

Se uma interação pode ser realizada com mouse ou touch, avaliar se também pode ser realizada via teclado quando aplicável.

O usuário deve conseguir:

- navegar;
- acessar;
- executar;
- cancelar;
- corrigir;
- concluir.

sem depender exclusivamente do mouse.

---

# When to Use

Use esta Skill quando:

- uma nova interface estiver sendo projetada;
- componentes estiverem sendo especificados;
- uma interface existente possuir barreiras de acessibilidade;
- formulários precisarem ser acessíveis;
- navegação via teclado precisar ser definida;
- leitores de tela forem relevantes;
- contraste precisar ser avaliado;
- interfaces mobile precisarem considerar touch;
- animações ou motion estiverem presentes;
- uma revisão de acessibilidade estiver sendo realizada.

---

# Accessibility Scope

Avaliar pelo menos:

```text
Perception
Understanding
Navigation
Interaction
Feedback
Error Recovery
Assistive Technology
Responsive Behavior
```

---

# Perceivable

O usuário deve conseguir perceber a informação.

Considerar:

- contraste;
- tamanho do texto;
- alternativas textuais;
- estrutura;
- áudio;
- vídeo;
- imagens;
- estados visuais.

---

# Operable

O usuário deve conseguir operar a interface.

Considerar:

- teclado;
- touch;
- ponteiros;
- foco;
- tempo;
- navegação;
- targets.

---

# Understandable

O usuário deve conseguir compreender:

- o que está acontecendo;
- o que pode fazer;
- o que aconteceu;
- como corrigir erros.

---

# Robust

A interface deve funcionar adequadamente com diferentes:

- browsers;
- dispositivos;
- tecnologias assistivas;
- tamanhos de tela;
- métodos de entrada.

---

# Semantic HTML

Quando houver controle sobre implementação, preferir elementos semanticamente corretos.

Exemplo:

```text
button
```

para ação.

```text
a
```

para navegação.

```text
input
```

para entrada.

Evitar:

```text
div onclick
```

quando um elemento semântico apropriado já existe.

---

# Headings

Estruturar títulos hierarquicamente.

Exemplo:

```text
H1
 ├── H2
 │    ├── H3
 │    └── H3
 └── H2
      └── H3
```

Não utilizar heading apenas por causa do tamanho visual.

---

# Landmarks

Quando apropriado, utilizar regiões semânticas como:

```text
header
nav
main
aside
footer
```

Isso permite que usuários de tecnologias assistivas entendam a estrutura da página.

---

# Accessible Names

Controles interativos precisam possuir nomes compreensíveis.

Evitar:

```text
[ícone]
```

sem contexto quando o significado não for evidente.

Preferir:

```text
[ícone] Excluir
```

ou fornecer um nome acessível equivalente.

---

# Icon Buttons

Para botões apenas com ícone:

```text
[🗑]
```

garantir que exista um nome acessível como:

```text
Excluir cliente
```

Não assumir que o ícone sozinho é suficiente.

---

# Images

Definir tratamento de acordo com a função.

## Informational Image

Precisa de alternativa textual apropriada.

## Decorative Image

Pode ser ignorada por tecnologia assistiva quando realmente decorativa.

## Functional Image

O texto alternativo deve comunicar a função.

---

# Alternative Text

Alt text deve responder:

> "Qual informação esta imagem transmite neste contexto?"

Não descrever detalhes irrelevantes.

Ruim:

```text
Imagem de um homem sorrindo em frente a um fundo branco
```

quando a imagem simplesmente representa:

```text
Perfil do usuário
```

---

# Decorative Elements

Elementos puramente decorativos não devem competir com conteúdo ou tecnologia assistiva.

Exemplos:

- ilustrações decorativas;
- backgrounds;
- divisores;
- ícones redundantes.

---

# Color

Nunca utilizar cor como único indicador.

Ruim:

```text
Verde = sucesso
Vermelho = erro
```

Melhor:

```text
✓ Pagamento aprovado

✕ Pagamento recusado
```

A cor pode complementar o significado.

---

# Contrast

Avaliar contraste entre:

- texto e background;
- ícones e background;
- controles e superfície;
- estados interativos.

Dar atenção especial a:

- texto pequeno;
- placeholder;
- disabled;
- secondary text.

---

# Do Not Over-Rely on Gray

Texto secundário não deve ficar tão claro que se torne difícil de ler.

Hierarquia visual não deve ser criada sacrificando legibilidade.

---

# Typography

Considerar:

- tamanho;
- peso;
- line-height;
- largura da linha;
- espaçamento;
- legibilidade.

Evitar:

- textos excessivamente pequenos;
- line-height insuficiente;
- parágrafos muito densos;
- fontes difíceis de ler.

---

# Text Scaling

A interface deve continuar utilizável quando o usuário aumenta o tamanho do texto.

Verificar:

```text
Normal
Larger text
Very large text
```

Observar:

- overflow;
- clipping;
- overlap;
- botões quebrados;
- conteúdo escondido.

---

# Zoom

Considerar uso com zoom.

Evitar layouts que dependam de:

- largura fixa;
- posicionamento absoluto excessivo;
- conteúdo não responsivo.

---

# Keyboard Navigation

Definir ordem lógica de navegação.

Exemplo:

```text
Header
 ↓
Navigation
 ↓
Main content
 ↓
Actions
```

A ordem deve refletir a lógica da interface.

---

# Tab Order

A ordem do Tab deve ser previsível.

Evitar manipular `tabindex` sem necessidade.

Preferir a ordem natural do documento.

---

# Focus Visible

O usuário deve conseguir identificar claramente onde está o foco.

Nunca remover o indicador de foco sem fornecer uma alternativa equivalente.

---

# Focus Management

Quando a interface muda significativamente, definir para onde o foco deve ir.

Exemplo:

```text
Modal abre
    ↓
Focus → Modal

Modal fecha
    ↓
Focus → Trigger
```

Outro:

```text
Form submit
    ↓
Error
    ↓
Focus → First invalid field
```

---

# Modal Accessibility

Modal deve considerar:

- accessible name;
- focus entry;
- focus trap quando apropriado;
- Escape;
- closing behavior;
- focus restoration;
- screen reader announcement.

Não permitir que o usuário fique perdido entre modal e conteúdo de fundo.

---

# Drawer Accessibility

Drawer deve definir:

- trigger;
- accessible name;
- open state;
- close action;
- Escape;
- focus;
- background interaction.

---

# Dropdown Accessibility

Definir:

- keyboard interaction;
- selected state;
- expanded state;
- active option;
- Escape;
- Arrow navigation quando aplicável.

---

# Forms

Formulários são áreas críticas de acessibilidade.

Cada campo deve possuir:

```text
Label
Input
Helper
Error
Required state
```

quando aplicável.

---

# Labels

Nunca depender apenas de placeholder para identificar um campo.

Exemplo:

```text
Email

[________________]

Exemplo: nome@empresa.com
```

é preferível a:

```text
[Digite seu email]
```

como única identificação.

---

# Required Fields

Indicar obrigatoriedade de forma compreensível.

Exemplo:

```text
Nome *
```

mas também considerar uma explicação global:

```text
* Campos obrigatórios
```

O significado não deve depender apenas de cor.

---

# Error Messages

Erro acessível deve indicar:

1. qual campo possui problema;
2. o que está errado;
3. como corrigir.

Exemplo:

```text
CPF

[123]

CPF inválido.
Digite 11 números.
```

---

# Error Summary

Em formulários grandes, considerar resumo dos erros.

Exemplo:

```text
Existem 3 erros no formulário.

- CPF inválido
- Email obrigatório
- CEP inválido
```

Cada erro pode levar o usuário ao campo correspondente.

---

# Validation Timing

Evitar validações que interrompam desnecessariamente a digitação.

Considerar:

- blur;
- change;
- submit.

Escolher de acordo com o contexto.

---

# Status Messages

Mensagens importantes devem ser percebidas sem depender exclusivamente de alteração visual.

Exemplo:

```text
Pedido salvo com sucesso.
```

Quando necessário, utilizar mecanismos apropriados de announcement.

---

# Loading

Loading deve comunicar:

```text
O que está acontecendo?
```

e, quando necessário:

```text
Quanto tempo?
```

Evitar interfaces que pareçam congeladas.

---

# Progress

Para operações longas:

```text
Processando documento...

Etapa 2 de 4
```

pode ser mais compreensível que apenas:

```text
Loading...
```

quando houver progresso real mensurável.

---

# Motion

Motion deve ser funcional e controlado.

Evitar:

- animações excessivas;
- movimentos rápidos;
- parallax desnecessário;
- flashing;
- transições que dificultem leitura.

---

# Reduced Motion

Considerar preferência do usuário por redução de movimento.

Quando apropriado:

```text
Normal motion
      ↓
Reduced motion
      ↓
Minimal / no animation
```

Não remover feedback funcional junto com animações decorativas.

---

# Flashing

Evitar conteúdo que pisque ou alterne rapidamente.

Especial atenção para:

- banners;
- animações;
- vídeos;
- notificações.

---

# Touch Accessibility

Para interfaces touch:

- alvos suficientemente grandes;
- espaçamento adequado;
- evitar ações muito próximas;
- não depender de gestos complexos;
- fornecer alternativa para gestos quando necessário.

---

# Gesture Alternatives

Se uma ação depende de:

```text
Swipe
Drag
Pinch
Long press
```

considerar uma alternativa mais simples.

Exemplo:

```text
Swipe to delete
```

pode ter também:

```text
Mais opções → Excluir
```

---

# Hover

Nunca colocar informação essencial exclusivamente em hover.

Hover não existe em muitos contextos:

- touch;
- keyboard;
- screen readers.

Quando uma informação é importante, deve existir outra forma de acesso.

---

# Time Limits

Quando houver limite de tempo:

- informar;
- permitir extensão quando apropriado;
- evitar expiração inesperada;
- preservar trabalho quando possível.

---

# Auto-Advance

Evitar:

```text
Carousel
   ↓
muda sozinho
   ↓
usuário perde contexto
```

quando isso prejudicar leitura ou interação.

---

# Carousels

Quando utilizados:

- controles claros;
- foco;
- keyboard;
- labels;
- posição;
- pausa quando necessário.

Não depender apenas de gesto.

---

# Tables

Tabelas acessíveis devem considerar:

- headers;
- relacionamento entre células;
- ordem de leitura;
- navegação;
- responsive behavior.

Não transformar tabelas complexas em estruturas impossíveis de navegar com tecnologias assistivas.

---

# Data Visualization

Gráficos não devem depender apenas de cor ou forma.

Fornecer, quando necessário:

- labels;
- valores;
- tabelas alternativas;
- descrições;
- contexto textual.

Exemplo:

```text
Gráfico
+
Resumo textual
+
Dados acessíveis
```

---

# Status and Badges

Badges e status devem possuir significado textual ou semântico.

Evitar:

```text
●
```

sozinho para representar:

```text
Ativo
```

Preferir:

```text
● Ativo
```

ou equivalente acessível.

---

# Links vs Buttons

Diferenciar:

### Link

Leva o usuário para outro destino.

### Button

Executa uma ação.

Exemplo:

```text
Ver pedido
→ Link

Cancelar pedido
→ Button
```

Isso melhora:

- semântica;
- teclado;
- previsibilidade;
- screen reader behavior.

---

# Navigation

Navegação acessível deve permitir:

- identificar localização;
- acessar destinos;
- retornar;
- ignorar regiões repetitivas quando apropriado.

Considerar mecanismos como:

```text
Skip to content
```

em interfaces onde isso seja relevante.

---

# Responsive Accessibility

A versão mobile não deve perder:

- labels;
- foco;
- conteúdo;
- contexto;
- acessibilidade;
- ações importantes.

Não criar:

```text
Desktop → acessível
Mobile → visual simplificado, mas inacessível
```

---

# Accessibility and Design System

Componentes do Design System devem nascer acessíveis.

Exemplo:

```text
Button
→ keyboard
→ focus
→ accessible name

Input
→ label
→ error
→ description

Modal
→ focus management
→ Escape

Tooltip
→ keyboard/focus alternative
```

Acessibilidade deve ser parte do contrato do componente.

---

# Accessibility States

Componentes devem representar estados de maneira semântica.

Exemplos conceituais:

```text
Expanded
Collapsed
Selected
Checked
Disabled
Busy
Invalid
Pressed
```

O usuário e a tecnologia assistiva precisam conseguir entender esses estados.

---

# Content Accessibility

Conteúdo também precisa ser acessível.

Preferir:

- linguagem clara;
- frases objetivas;
- títulos descritivos;
- instruções específicas;
- mensagens orientadas à ação.

Evitar jargão desnecessário.

---

# Cognitive Accessibility

Considerar redução de carga cognitiva.

Boas práticas:

- linguagem previsível;
- instruções claras;
- hierarquia consistente;
- poucas decisões simultâneas;
- feedback claro;
- prevenção de erros;
- recuperação simples.

---

# Error Prevention

Acessibilidade também significa reduzir a chance de erro.

Exemplo:

```text
Usuário precisa preencher CPF

↓
Input já possui máscara apropriada
↓
Formato esperado fica claro
↓
Validação acontece
↓
Erro é explicado
```

---

# Consistency

Padrões consistentes ajudam usuários a aprender a interface.

Se:

```text
Salvar = Primary Button
Cancelar = Secondary Button
Excluir = Danger Button
```

essa lógica deve permanecer consistente.

---

# Accessibility Heuristics

Ao revisar uma interface, perguntar:

```text
O usuário consegue perceber?
O usuário consegue entender?
O usuário consegue navegar?
O usuário consegue interagir?
O usuário consegue recuperar erros?
O usuário consegue fazer isso sem mouse?
O usuário consegue fazer isso com tecnologia assistiva?
```

---

# Accessibility Audit

Realizar revisão em camadas.

## Layer 1 — Structure

- semantic structure;
- headings;
- landmarks;
- labels.

## Layer 2 — Interaction

- keyboard;
- focus;
- states;
- dialogs.

## Layer 3 — Visual

- contrast;
- typography;
- focus indicators;
- non-color signals.

## Layer 4 — Content

- language;
- instructions;
- errors;
- alternatives.

## Layer 5 — Responsive

- mobile;
- zoom;
- text scaling;
- touch.

## Layer 6 — Assistive Technology

- screen reader;
- keyboard;
- alternative input.

---

# Testing Strategy

Sempre que possível, combinar:

```text
Automated checks
        +
Manual testing
        +
Keyboard testing
        +
Screen reader testing
        +
Real user testing
```

Nenhuma abordagem isolada detecta todos os problemas.

---

# Keyboard Test

Percorrer a interface apenas com teclado.

Verificar:

```text
[ ] Todos os controles acessíveis
[ ] Ordem de foco lógica
[ ] Focus visible
[ ] Enter funciona
[ ] Space funciona quando apropriado
[ ] Escape funciona quando apropriado
[ ] Modal não perde foco
[ ] Foco retorna corretamente
```

---

# Screen Reader Test

Quando aplicável, verificar:

```text
[ ] Headings fazem sentido
[ ] Landmarks fazem sentido
[ ] Labels existem
[ ] Buttons possuem nomes
[ ] Links possuem nomes
[ ] Estados são comunicados
[ ] Erros são percebidos
[ ] Mudanças importantes são anunciadas
```

---

# Automated Testing

Ferramentas automatizadas podem ajudar a identificar:

- problemas de contraste;
- labels ausentes;
- estrutura semântica;
- atributos inválidos;
- problemas comuns de ARIA.

Mas:

> Ferramenta automatizada não significa interface acessível.

Sempre complementar com testes manuais.

---

# ARIA

ARIA deve ser utilizada quando necessário.

Princípio:

> Primeiro utilizar HTML semântico correto. Depois utilizar ARIA para complementar comportamentos que não podem ser expressos adequadamente apenas com HTML nativo.

Evitar adicionar ARIA sem compreender:

- role;
- state;
- property;
- interaction model.

ARIA incorreta pode piorar a experiência.

---

# Accessibility Specification

Para componentes complexos, documentar:

```text
## Accessibility

### Semantic Element

...

### Accessible Name

...

### Keyboard

...

### Focus

...

### Screen Reader

...

### States

...

### Contrast

...

### Motion

...

### Touch

...
```

---

# Accessibility Requirements Matrix

Para interfaces complexas:

| Element | Keyboard | Focus | Screen Reader | Contrast | Mobile |
|---|---|---|---|---|---|
| Button | Yes | Visible | Name | Valid | Touch |
| Input | Yes | Visible | Label | Valid | Responsive |
| Modal | Yes | Managed | Announced | Valid | Adapted |
| Table | Yes | Logical | Headers | Valid | Adapted |

---

# Quality Criteria

Uma interface acessível:

- possui estrutura semântica;
- pode ser navegada por teclado;
- possui foco visível;
- possui nomes acessíveis;
- possui labels;
- comunica estados;
- comunica erros;
- não depende apenas de cor;
- possui contraste adequado;
- suporta zoom e text scaling;
- considera touch;
- considera motion;
- funciona com tecnologias assistivas;
- utiliza linguagem clara;
- permite recuperação de erros.

---

# Anti-Patterns

## Accessibility Later

Deixar acessibilidade para o final.

---

## Color Only

Comunicar tudo apenas por cor.

---

## Icon Only Without Name

Ícones sem nome acessível.

---

## Placeholder as Label

Usar placeholder como única identificação do campo.

---

## Remove Focus Outline

Remover foco sem alternativa.

---

## Mouse Only

Interações que só funcionam com mouse.

---

## Hover Only

Informações ou ações essenciais disponíveis apenas via hover.

---

## ARIA Everywhere

Adicionar ARIA indiscriminadamente.

---

## Tiny Touch Targets

Controles difíceis de tocar.

---

## Screen Reader Afterthought

Testar somente depois que toda interface estiver pronta.

---

## Accessibility Toolbar as Solution

Não considerar acessibilidade estruturalmente e tentar resolver tudo através de uma ferramenta externa.

---

## Visual Accessibility Only

Considerar apenas contraste e esquecer:

- teclado;
- foco;
- semântica;
- conteúdo;
- interação.

---

# Accessibility Checklist

```text
[ ] Semantic HTML definido
[ ] Headings definidos
[ ] Landmarks considerados
[ ] Accessible names definidos
[ ] Images possuem tratamento adequado
[ ] Color não é único indicador
[ ] Contrast verificado
[ ] Typography legível
[ ] Text scaling considerado
[ ] Zoom considerado
[ ] Keyboard navigation definida
[ ] Tab order definido
[ ] Focus visible
[ ] Focus management definido
[ ] Modal accessibility definida
[ ] Drawer accessibility definida
[ ] Form labels definidos
[ ] Required states definidos
[ ] Error messages definidos
[ ] Error recovery definido
[ ] Loading comunicado
[ ] Status messages considerados
[ ] Reduced motion considerado
[ ] Flashing evitado
[ ] Touch targets considerados
[ ] Gestures possuem alternativas quando necessário
[ ] Hover não é obrigatório
[ ] Tables consideradas
[ ] Charts possuem alternativa acessível
[ ] Responsive accessibility validada
[ ] Screen reader considerado
[ ] Automated testing considerado
[ ] Manual testing considerado
```

---

# Rule of Thumb

> **Se o usuário precisa enxergar, ouvir ou utilizar um dispositivo específico para entender ou executar uma ação, pergunte qual é a alternativa.**

Acessibilidade não significa criar uma experiência separada.

Significa:

> **criar uma experiência que possa ser utilizada por mais pessoas desde o início.**

---

# Final Principle

**Acessibilidade não é uma camada visual adicionada sobre o produto.**

Ela faz parte da própria experiência:

```text
Perceber
   ↓
Entender
   ↓
Navegar
   ↓
Interagir
   ↓
Receber feedback
   ↓
Corrigir erros
   ↓
Concluir tarefa
```

Uma interface realmente bem projetada não pergunta:

> "Como fazer uma versão acessível?"

Ela pergunta:

> **"Como fazer com que esta experiência funcione para o maior número possível de pessoas?"**
