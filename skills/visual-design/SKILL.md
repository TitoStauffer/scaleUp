---
name: visual-design
description: Design visual de interfaces digitais com foco em hierarquia visual, tipografia, cores, espaçamento, composição, contraste, iconografia e estética funcional. Use quando wireframes e interações já estiverem suficientemente definidos e for necessário transformar a estrutura em uma interface visual clara, consistente e profissional.
---

# Visual Design

## Objective

Transformar estruturas funcionais de interface em experiências visuais claras, consistentes e atraentes.

O foco desta Skill é definir:

- hierarquia visual;
- tipografia;
- cores;
- espaçamento;
- composição;
- contraste;
- iconografia;
- densidade visual;
- superfícies;
- bordas;
- elevação;
- estados visuais;
- consistência estética.

O objetivo não é simplesmente criar uma interface "bonita".

O objetivo é utilizar elementos visuais para:

- comunicar hierarquia;
- orientar atenção;
- facilitar compreensão;
- reduzir carga cognitiva;
- reforçar ações;
- comunicar estados;
- criar consistência;
- transmitir confiança.

---

# Core Principles

## 1. Function Before Decoration

A estética deve servir à função.

Antes de perguntar:

> "Como deixar mais bonito?"

Perguntar:

> "Como tornar isso mais claro?"

---

## 2. Visual Hierarchy

Nem todos os elementos possuem a mesma importância.

A interface deve comunicar visualmente:

```text
Mais importante
      ↓
Importante
      ↓
Secundário
      ↓
Auxiliar
```

A hierarquia pode ser criada através de:

- tamanho;
- peso;
- contraste;
- posição;
- espaçamento;
- cor;
- agrupamento;
- densidade.

---

## 3. Consistency

Elementos que possuem a mesma função devem parecer e se comportar de maneira semelhante.

Exemplo:

```text
Primary Action
→ mesmo padrão visual

Secondary Action
→ mesmo padrão visual

Danger Action
→ mesmo padrão visual
```

Evitar criar estilos diferentes para elementos equivalentes sem uma razão clara.

---

## 4. Visual Simplicity

Simplicidade não significa remover tudo.

Significa:

> manter apenas aquilo que ajuda o usuário a entender e realizar a tarefa.

Evitar:

- decoração excessiva;
- cores desnecessárias;
- sombras exageradas;
- borders em excesso;
- múltiplos estilos competindo;
- componentes visualmente complexos sem necessidade.

---

# When to Use

Use esta Skill quando:

- wireframes já estiverem definidos;
- interações principais já estiverem definidas;
- uma interface precisa ganhar identidade visual;
- uma tela precisa ser refinada;
- componentes precisam de tratamento visual;
- uma nova feature precisa seguir uma linguagem visual;
- uma interface existente possui problemas de hierarquia;
- é necessário definir tokens visuais;
- o projeto ainda não possui um design system completo.

Não usar esta Skill para resolver primeiro:

- problemas de discovery;
- problemas de arquitetura da informação;
- user flows;
- requisitos;
- regras de negócio.

Visual Design não deve esconder problemas estruturais.

---

# Inputs

Considerar:

### UX

- personas;
- user journey;
- user flows;
- pain points;
- necessidades.

### IA

- estrutura da informação;
- navegação;
- hierarquia de conteúdo.

### Wireframes

- layout;
- conteúdo;
- componentes;
- estados.

### Interaction Design

- comportamentos;
- estados;
- feedbacks;
- transições.

### Brand

Quando disponível:

- identidade;
- logo;
- cores;
- guidelines;
- personalidade da marca.

### Product

- posicionamento;
- público;
- contexto;
- objetivos.

---

# Visual Hierarchy

## Primary Content

Deve receber maior destaque.

Exemplos:

- título;
- valor principal;
- status crítico;
- ação principal.

---

## Secondary Content

Informações relevantes, mas não prioritárias.

Exemplos:

- descrição;
- metadata;
- informações complementares.

---

## Tertiary Content

Informações auxiliares.

Exemplos:

- timestamps;
- detalhes adicionais;
- referências secundárias.

---

# Hierarchy Techniques

## Size

Elementos maiores chamam mais atenção.

Usar tamanho para comunicar importância.

---

## Weight

Peso tipográfico pode separar:

```text
Heading
Body
Caption
Metadata
```

Evitar utilizar bold em excesso.

---

## Contrast

Contraste ajuda a separar:

- conteúdo principal;
- conteúdo secundário;
- estados;
- ações.

---

## Position

Elementos localizados em posições estratégicas recebem maior atenção.

---

## Spacing

Espaçamento pode comunicar relacionamento.

Exemplo:

```text
Campo A
Campo B

──────────

Seção seguinte
```

Um espaço maior comunica separação entre grupos.

---

## Grouping

Elementos relacionados devem parecer relacionados.

Usar:

- proximidade;
- containers;
- alinhamento;
- background;
- divisores quando necessários.

---

# Typography

## Define a Type Scale

Criar uma escala consistente.

Exemplo conceitual:

```text
Display
H1
H2
H3
Body Large
Body
Body Small
Caption
```

Não escolher tamanhos arbitrariamente para cada tela.

---

# Typography Roles

Definir papéis.

```text
Display
Page Title
Section Title
Subsection
Body
Supporting Text
Caption
Label
Button
```

Cada papel deve possuir propósito claro.

---

# Readability

Considerar:

- tamanho;
- peso;
- largura da linha;
- altura da linha;
- contraste;
- densidade.

Evitar linhas de texto excessivamente longas.

---

# Font Selection

Escolher fontes considerando:

- legibilidade;
- contexto;
- personalidade;
- disponibilidade;
- performance;
- suporte a idiomas;
- números;
- caracteres especiais.

Não escolher uma fonte apenas porque está na moda.

---

# Numbers and Data

Interfaces administrativas e sistemas de negócio frequentemente possuem muitos números.

Considerar:

- alinhamento;
- peso;
- tamanho;
- tabular numbers quando apropriado;
- separadores;
- unidades;
- precisão.

Exemplo:

```text
R$ 12.540,90
98,4%
1.245 pedidos
```

Números devem ser facilmente escaneáveis.

---

# Color

Cores devem possuir função.

Exemplos:

```text
Primary
Secondary
Success
Warning
Danger
Info
Neutral
Background
Surface
Border
Text
```

Não utilizar cores apenas para "deixar mais vivo".

---

# Semantic Color

A cor deve comunicar significado de maneira consistente.

Exemplo:

```text
Success → operação concluída
Warning → atenção
Danger → risco/erro/ação destrutiva
Info → informação
Neutral → conteúdo sem estado semântico
```

---

# Color Accessibility

Nunca depender apenas de cor para transmitir informação.

Evitar:

```text
Verde = aprovado
Vermelho = rejeitado
```

sem outro indicador.

Preferir:

```text
✓ Aprovado
✕ Rejeitado
```

ou:

- ícone;
- texto;
- padrão;
- label.

---

# Contrast

Verificar contraste suficiente entre:

- texto e background;
- ícones e background;
- componentes e superfícies;
- estados interativos.

Especial atenção para:

- texto pequeno;
- placeholders;
- disabled states;
- secondary text.

---

# Spacing

Criar um sistema consistente de espaçamento.

Exemplo:

```text
4
8
12
16
24
32
48
64
```

Os valores são exemplos.

O projeto deve definir sua própria escala quando necessário.

Evitar:

```text
17px aqui
13px ali
21px em outro lugar
```

sem justificativa.

---

# Alignment

Alinhamento cria ordem visual.

Priorizar:

- alinhamento consistente;
- grids;
- colunas;
- baseline;
- margens previsíveis.

Evitar elementos aparentemente desalinhados.

---

# Grid

Quando apropriado, definir:

- número de colunas;
- gutters;
- margins;
- max-width;
- breakpoints.

Grid deve apoiar o conteúdo.

Não aplicar uma grid rígida que prejudique a interface.

---

# Density

Interfaces podem ser:

```text
Compact
Comfortable
Spacious
```

Escolher densidade de acordo com:

- frequência de uso;
- quantidade de informação;
- dispositivo;
- contexto;
- tipo de usuário.

Exemplo:

### Sistema operacional interno

Pode favorecer maior densidade.

### Produto consumer

Pode favorecer maior espaço e foco.

---

# Surfaces

Definir níveis de superfície.

Exemplo:

```text
Page Background
Surface
Elevated Surface
Overlay
```

Cada nível deve possuir uma razão visual.

Não transformar cada bloco em um card.

---

# Cards

Cards podem ajudar a:

- agrupar conteúdo;
- separar contextos;
- destacar informações.

Mas seu uso excessivo cria:

> "Card soup"

Antes de criar um card, perguntar:

> Esse conteúdo realmente precisa ser visualmente agrupado?

---

# Borders

Borders podem comunicar:

- separação;
- limites;
- agrupamento;
- interação.

Usar com moderação.

Se cada elemento possui uma borda, a interface pode ficar visualmente pesada.

---

# Elevation and Shadows

Sombras podem representar:

- hierarquia espacial;
- elementos flutuantes;
- overlays;
- modais;
- menus.

Evitar utilizar sombra decorativa em todos os componentes.

---

# Iconography

Ícones devem:

- possuir significado claro;
- seguir estilo consistente;
- possuir tamanho consistente;
- possuir alinhamento consistente;
- ser utilizados quando agregarem compreensão.

Evitar:

> ícone por decoração.

---

# Icon + Text

Quando o significado do ícone não for universal, utilizar texto.

Exemplo:

```text
[ícone] Configurações
```

é geralmente mais claro que:

```text
[ícone]
```

sozinho.

---

# Buttons

Definir hierarquia visual:

```text
Primary
Secondary
Tertiary
Danger
```

A interface deve deixar claro:

> Qual ação eu deveria executar?

---

# Button Hierarchy

Exemplo:

```text
[Salvar]        ← Primary

[Cancelar]      ← Secondary

[Mais opções]   ← Tertiary
```

Evitar várias ações competindo pelo mesmo destaque.

---

# Forms

Visualmente, formularios devem comunicar:

- label;
- campo;
- valor;
- estado;
- erro;
- ajuda;
- obrigatoriedade.

Não utilizar apenas placeholder como label quando isso prejudicar compreensão.

---

# Input States

Considerar visualmente:

```text
Default
Hover
Focus
Filled
Valid
Invalid
Disabled
Read-only
Loading
```

O estado deve ser reconhecível.

---

# Focus State

Focus deve ser visualmente evidente.

Nunca remover outline/focus sem fornecer alternativa equivalente ou superior.

---

# Tables

Para tabelas:

- priorizar escaneabilidade;
- alinhar números;
- diferenciar header;
- manter densidade controlada;
- facilitar leitura por linha;
- destacar ações sem poluir;
- evitar excesso de borders.

---

# Data Visualization

Quando houver gráficos:

- priorizar compreensão;
- evitar decoração;
- utilizar cores semanticamente;
- manter legendas claras;
- mostrar unidades;
- fornecer contexto;
- considerar acessibilidade.

Gráfico não deve ser usado apenas porque "parece profissional".

---

# Responsive Visual Design

Definir como a linguagem visual se adapta.

Considerar:

- escala tipográfica;
- spacing;
- grid;
- cards;
- navegação;
- densidade;
- imagens;
- componentes.

Não simplesmente reduzir tudo proporcionalmente.

---

# Dark Mode

Quando aplicável, definir dark mode como uma linguagem visual própria.

Considerar:

- contraste;
- superfícies;
- elevação;
- cores semânticas;
- imagens;
- borders;
- estados.

Não inverter simplesmente:

```text
white → black
black → white
```

---

# Motion

Quando motion fizer parte da linguagem visual, utilizar para reforçar:

- continuidade;
- feedback;
- hierarquia;
- transição de estados.

Não utilizar movimento como decoração indiscriminadamente.

---

# Brand Expression

A identidade visual pode comunicar:

- confiança;
- modernidade;
- simplicidade;
- sofisticação;
- energia;
- segurança;
- profissionalismo.

Mas branding não deve prejudicar:

- legibilidade;
- acessibilidade;
- usabilidade.

---

# Visual Tokens

Quando o projeto estiver evoluindo para um Design System, transformar decisões recorrentes em tokens.

Exemplo:

```text
color.primary
color.surface
color.text.primary
color.text.secondary
color.border

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

O objetivo é transformar decisões visuais em regras reutilizáveis.

---

# Component States

Todo componente visual relevante deve considerar seus estados.

Exemplo:

```text
Button

Default
Hover
Focus
Pressed
Disabled
Loading
Success
Error
```

A aparência deve comunicar o estado sem depender exclusivamente de cor.

---

# Visual QA

Antes de considerar uma interface visualmente pronta, verificar:

### Hierarchy

A atenção vai para os lugares certos?

### Typography

Os textos são legíveis?

### Spacing

Existe consistência?

### Alignment

Os elementos estão alinhados?

### Color

As cores possuem propósito?

### Contrast

Existe contraste suficiente?

### Components

Os padrões são consistentes?

### Density

Existe informação demais?

### Responsive

A composição funciona em diferentes telas?

### Accessibility

Usuários com diferentes capacidades conseguem compreender a interface?

---

# Outputs

Quando aplicável, produzir:

```text
Visual Direction
Typography System
Color System
Spacing System
Grid
Iconography Guidelines
Component Styling
States
Responsive Rules
Visual Tokens
Accessibility Notes
Open Questions
```

---

# Recommended Output Format

```text
## Visual Direction

<descrição da linguagem visual>

## Typography

### Headings

...

### Body

...

### Supporting Text

...

## Colors

### Primary

...

### Semantic

...

### Neutral

...

## Spacing

...

## Grid

...

## Components

### Buttons

...

### Inputs

...

### Cards

...

## States

...

## Responsive

...

## Accessibility

...

## Open Questions

...
```

---

# Quality Criteria

Um bom Visual Design:

- possui hierarquia clara;
- possui linguagem consistente;
- utiliza cores com propósito;
- possui tipografia legível;
- possui espaçamento consistente;
- possui contraste adequado;
- facilita escaneabilidade;
- comunica estados;
- evita decoração desnecessária;
- funciona em diferentes tamanhos de tela;
- respeita acessibilidade;
- pode evoluir para um Design System.

---

# Anti-Patterns

## Visual Over UX

Criar uma interface visualmente impressionante que dificulta a tarefa.

---

## Color Explosion

Usar muitas cores sem função semântica.

---

## Typography Chaos

Cada tela possui tamanhos e pesos diferentes.

---

## Card Everything

Transformar toda seção em card.

---

## Shadow Everything

Adicionar sombra em todos os componentes.

---

## Border Everything

Adicionar borda em todos os elementos.

---

## Contrast Abuse

Usar contraste extremo para chamar atenção constantemente.

---

## Decoration Over Information

Elementos decorativos competem com o conteúdo.

---

## Inaccessible Beauty

Interface bonita, mas ilegível ou inacessível.

---

## Trend Copying

Copiar tendências visuais sem considerar:

- produto;
- usuário;
- contexto;
- tarefa.

---

# Visual Design Checklist

```text
[ ] Hierarquia visual definida
[ ] Tipografia definida
[ ] Escala tipográfica consistente
[ ] Cores definidas
[ ] Cores semânticas definidas
[ ] Contraste verificado
[ ] Espaçamento consistente
[ ] Grid definido
[ ] Alinhamento consistente
[ ] Densidade adequada
[ ] Iconografia consistente
[ ] Estados visuais definidos
[ ] Buttons hierarquizados
[ ] Forms definidos
[ ] Tabelas consideradas
[ ] Responsividade considerada
[ ] Dark mode considerado quando aplicável
[ ] Acessibilidade considerada
[ ] Tokens identificados
```

---

# Rule of Thumb

> **Cada decisão visual deve responder a uma pergunta funcional.**

Se você não consegue explicar por que um elemento:

- possui aquela cor;
- possui aquele tamanho;
- possui aquele espaçamento;
- possui aquele contraste;
- possui aquele destaque;

provavelmente a decisão ainda não está madura.

---

# Final Principle

**Visual Design não é decoração da interface.**

É uma linguagem.

Essa linguagem deve dizer ao usuário:

```text
O que é importante.
O que está relacionado.
O que posso fazer.
O que aconteceu.
O que mudou.
O que precisa da minha atenção.
```

Uma interface visualmente excelente não é aquela que chama mais atenção.

É aquela que **direciona a atenção exatamente para onde ela é necessária**.
