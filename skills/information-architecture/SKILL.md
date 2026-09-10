---
name: information-architecture
description: Estrutura e organiza informações, conteúdos, funcionalidades e navegação de produtos digitais para facilitar encontrabilidade, compreensão, orientação e execução de tarefas. Use quando for necessário definir hierarquia de conteúdo, navegação, menus, categorias, taxonomias, rotulagem, arquitetura de páginas ou estrutura de uma aplicação.
---

# Information Architecture

## 1. Objetivo

Organizar informações, conteúdos e funcionalidades de maneira que os usuários consigam:

- entender onde estão;
- encontrar o que precisam;
- compreender as opções disponíveis;
- navegar pelo produto;
- prever onde determinada informação estará;
- executar tarefas com o menor esforço cognitivo possível.

A pergunta central desta Skill é:

> "Como devemos organizar o produto para que o usuário consiga encontrar, compreender e utilizar o que precisa?"

---

# 2. Princípios Fundamentais

## 2.1 Organizar para o usuário

A arquitetura deve refletir principalmente:

- objetivos do usuário;
- modelos mentais;
- tarefas;
- linguagem conhecida pelo usuário;
- frequência de uso;
- importância das informações;
- contexto.

Não organizar exclusivamente segundo a estrutura interna da empresa.

---

## 2.2 Estrutura interna não é arquitetura de usuário

A empresa pode pensar:

```text
Financeiro
Operações
Compliance
Risk
```

Enquanto o usuário pensa:

```text
Meus pagamentos
Minha conta
Problemas
Documentos
Relatórios
```

A arquitetura deve considerar como o usuário entende o domínio.

---

# 3. Quando Usar

Use esta Skill quando for necessário:

- estruturar um produto;
- definir navegação;
- organizar menus;
- criar hierarquia de páginas;
- definir categorias;
- criar taxonomias;
- definir labels;
- organizar conteúdo;
- estruturar dashboards;
- organizar configurações;
- definir arquitetura de uma aplicação;
- reorganizar um produto existente;
- reduzir dificuldade de encontrabilidade;
- melhorar navegação;
- analisar excesso de categorias;
- definir breadcrumbs;
- estruturar busca.

---

# 4. Quando NÃO Usar

Não utilizar esta Skill quando:

- o problema é exclusivamente visual;
- a tarefa é escolher cores;
- a tarefa é definir tipografia;
- a tarefa é criar um componente isolado;
- não existe problema de organização ou navegação.

Nesses casos, utilizar Skills de UI apropriadas.

---

# 5. Entradas

Antes de definir uma arquitetura, considerar:

- personas;
- jornadas;
- objetivos;
- tarefas;
- conteúdo existente;
- funcionalidades;
- regras de negócio;
- domínio;
- frequência de uso;
- métricas;
- problemas de navegação;
- feedback dos usuários;
- restrições técnicas.

Quando essas informações não existirem, declarar as lacunas.

---

# 6. Perguntas Fundamentais

Antes de estruturar a arquitetura, responder:

```text
Quem utiliza?
O que precisa encontrar?
O que precisa fazer?
Com que frequência?
Em qual contexto?
Como descreve esse conteúdo?
Quais informações estão relacionadas?
Quais informações precisam estar próximas?
Quais informações precisam estar separadas?
```

---

# 7. Modelo Mental

O modelo mental é a forma como o usuário entende e organiza determinado domínio.

A arquitetura deve tentar aproximar:

```text
Modelo mental do usuário
          ↓
Estrutura do produto
```

Quanto maior a distância entre os dois, maior tende a ser o esforço cognitivo.

---

# 8. Domínio

Antes de criar categorias, compreender o domínio.

Exemplo:

```text
Produto:
ERP para corretora de café

Domínio:
- empresas
- produtos
- negociações
- sacarias
- contratos
- notas fiscais
- usuários
- relatórios
```

Depois investigar como os usuários trabalham com essas entidades.

Não assumir que a estrutura técnica do banco deve ser a estrutura da interface.

---

# 9. Objetivos do Usuário

Organizar a arquitetura em torno das principais tarefas.

Exemplo:

```text
Usuário quer:
"Criar uma negociação"

Arquitetura:
Negociações
  ↓
Nova negociação
```

Evitar:

```text
Database
  ↓
Tables
  ↓
Entities
  ↓
Negotiation
```

se esses conceitos não fizerem parte do modelo mental do usuário.

---

# 10. Hierarquia

Definir níveis de informação.

Exemplo:

```text
Dashboard
├── Vendas
│   ├── Pedidos
│   ├── Clientes
│   └── Relatórios
│
├── Financeiro
│   ├── Contas
│   ├── Recebimentos
│   └── Relatórios
│
└── Configurações
    ├── Usuários
    └── Empresa
```

A profundidade deve ser proporcional à complexidade.

Evitar profundidade excessiva.

---

# 11. Profundidade x Amplitude

Arquiteturas podem ser:

### Muito profundas

Poucos itens por nível, muitos níveis.

Problema:

- usuário precisa navegar várias vezes;
- aumenta memória necessária;
- aumenta distância até a informação.

### Muito amplas

Muitos itens no mesmo nível.

Problema:

- excesso de opções;
- dificuldade de escaneamento;
- sobrecarga cognitiva.

Buscar equilíbrio.

---

# 12. Navegação Global

Definir elementos que permitem acessar as principais áreas do produto.

Exemplo:

```text
Logo
Dashboard
Clientes
Pedidos
Financeiro
Relatórios
Configurações
Perfil
```

A navegação global deve priorizar áreas importantes e recorrentes.

Não transformar o menu em inventário completo do sistema.

---

# 13. Navegação Local

Quando uma área possui estrutura própria, definir navegação contextual.

Exemplo:

```text
Clientes
├── Lista
├── Segmentos
├── Importação
└── Configurações
```

Utilizar quando houver agrupamento natural.

---

# 14. Navegação Contextual

Permitir ações relacionadas ao conteúdo atual.

Exemplo:

```text
Pedido #1234

[Editar]
[Duplicar]
[Cancelar]
[Exportar]
```

As ações devem aparecer no contexto em que fazem sentido.

---

# 15. Rotulagem

Labels devem ser:

- claros;
- consistentes;
- previsíveis;
- familiares;
- específicos;
- curtos quando possível.

Preferir:

```text
Clientes
Pedidos
Relatórios
```

a:

```text
Gestão de relacionamento
Operações comerciais
Inteligência operacional
```

quando os termos não forem familiares ao usuário.

---

# 16. Linguagem do Usuário

Utilizar a linguagem encontrada em:

- entrevistas;
- suporte;
- documentação;
- pesquisas;
- conversas;
- comportamento;
- domínio.

Não impor jargão técnico sem necessidade.

---

# 17. Consistência Terminológica

Um conceito deve possuir um nome consistente.

Evitar:

```text
Cliente
Consumidor
Comprador
Conta
```

quando todos representam a mesma entidade.

Escolher um termo principal e utilizá-lo consistentemente.

---

# 18. Sinônimos

Quando usuários utilizarem termos diferentes para a mesma coisa, considerar:

- alias;
- busca;
- labels;
- ajuda contextual;
- redirecionamento.

Não necessariamente alterar toda a interface para acomodar todos os sinônimos.

---

# 19. Taxonomia

Taxonomia é a forma de classificar informações.

Exemplo:

```text
Produtos
├── Café
│   ├── Arábica
│   └── Robusta
├── Insumos
└── Equipamentos
```

Uma taxonomia deve possuir lógica compreensível.

---

# 20. Critério de Classificação

Toda categoria deve possuir um critério claro.

Evitar misturar critérios.

Ruim:

```text
Produtos
├── Café
├── Mais vendidos
├── Importados
├── Pequenos
└── Equipamentos
```

Aqui existem critérios diferentes:

- tipo;
- popularidade;
- origem;
- tamanho.

Melhor:

```text
Produtos
├── Café
├── Insumos
└── Equipamentos
```

E utilizar filtros separados para:

```text
Popularidade
Origem
Tamanho
```

---

# 21. Exclusividade e Sobreposição

Categorias podem ser:

### Mutuamente exclusivas

Cada item pertence a uma categoria.

### Sobrepostas

Um item pode pertencer a várias categorias.

Escolher conscientemente.

Não criar estruturas onde o usuário não sabe em qual categoria procurar.

---

# 22. Busca

Quando o volume de informação for grande, considerar busca.

Busca é especialmente útil quando:

- existem muitos itens;
- usuários sabem o que procuram;
- nomes são específicos;
- navegação seria lenta;
- conteúdo cresce constantemente.

A busca não deve ser usada como desculpa para uma arquitetura ruim.

---

# 23. Filtros

Filtros permitem reduzir grandes conjuntos de informação.

Exemplo:

```text
Pedidos

Status:
[ ] Pago
[ ] Pendente
[ ] Cancelado

Período:
[Data inicial] → [Data final]

Cliente:
[Selecionar]
```

Filtros devem representar critérios relevantes para o usuário.

---

# 24. Sorting

Ordenação permite reorganizar resultados.

Exemplo:

```text
Ordenar por:

Mais recente
Maior valor
Menor valor
Nome
```

Priorizar ordenações úteis para as tarefas.

---

# 25. Breadcrumbs

Breadcrumbs ajudam usuários a entender:

- onde estão;
- qual é a hierarquia;
- como retornar a níveis anteriores.

Exemplo:

```text
Pedidos
>
Pedido #1234
>
Itens
```

Usar quando a hierarquia for significativa.

Não utilizar breadcrumbs apenas por hábito.

---

# 26. Dashboard Architecture

Dashboards devem organizar informação segundo:

- objetivos;
- decisões;
- frequência;
- importância;
- contexto.

Evitar transformar dashboard em coleção de gráficos.

Pergunta principal:

> "Quais decisões o usuário precisa tomar aqui?"

---

# 27. Configurações

Configurações frequentemente crescem de maneira desorganizada.

Agrupar por conceitos compreensíveis.

Exemplo:

```text
Configurações

Conta
├── Perfil
├── Segurança
└── Preferências

Empresa
├── Dados da empresa
├── Usuários
└── Permissões

Integrações
├── API
├── Webhooks
└── Serviços externos
```

Não organizar simplesmente pela ordem em que as funcionalidades foram implementadas.

---

# 28. Arquitetura para Produtos Complexos

Para produtos grandes:

```text
Produto
├── Domínio
│   ├── Área
│   ├── Área
│   └── Área
│
├── Tarefas
│   ├── Tarefa
│   └── Tarefa
│
└── Administração
```

Avaliar diferentes modelos antes de escolher um.

---

# 29. Modelos de Organização

Alguns modelos comuns:

### Hierárquico

```text
Categoria
└── Subcategoria
    └── Item
```

### Sequencial

```text
Etapa 1
↓
Etapa 2
↓
Etapa 3
```

### Matricial

O usuário pode navegar por diferentes dimensões.

### Orientado a busca

O usuário encontra conteúdo principalmente por pesquisa.

### Orientado a tarefa

A estrutura gira em torno do que o usuário precisa fazer.

Escolher o modelo de acordo com o problema.

---

# 30. Arquitetura Orientada a Tarefas

Quando usuários entram no sistema para executar tarefas específicas, priorizar essas tarefas.

Exemplo:

```text
O que você precisa fazer?

[Emitir nota]
[Criar pedido]
[Consultar cliente]
[Gerar relatório]
```

Pode ser melhor do que apresentar dezenas de entidades internas.

---

# 31. Arquitetura Orientada a Entidades

Quando usuários trabalham frequentemente com objetos persistentes:

```text
Clientes
Pedidos
Produtos
Contratos
```

Esse modelo pode funcionar bem.

Validar com o modelo mental do usuário.

---

# 32. Card Sorting

Quando houver incerteza sobre organização, considerar card sorting.

### Aberto

Usuários criam suas próprias categorias.

### Fechado

Usuários organizam itens em categorias existentes.

### Híbrido

Combina os dois.

Utilizar resultados para descobrir modelos mentais.

---

# 33. Tree Testing

Utilizar tree testing para validar:

- encontrabilidade;
- estrutura;
- labels;
- categorias;
- navegação.

O objetivo é testar a estrutura sem depender do visual da interface.

---

# 34. Validação

Perguntar:

```text
Usuário consegue prever onde determinada informação está?

Usuário consegue encontrar rapidamente?

Os labels são compreensíveis?

Categorias possuem lógica?

Existe sobreposição confusa?

A estrutura reflete o modelo mental?

A arquitetura suporta crescimento?
```

---

# 35. Arquitetura Atual x Desejada

Ao trabalhar em produto existente, separar:

```text
Arquitetura Atual
      ↓
Problemas
      ↓
Hipóteses
      ↓
Nova Estrutura
      ↓
Validação
```

Não assumir que uma reorganização é automaticamente melhor.

---

# 36. Migração

Mudanças de arquitetura podem afetar usuários existentes.

Considerar:

- links existentes;
- favoritos;
- URLs;
- hábitos;
- documentação;
- treinamento;
- suporte;
- bookmarks;
- permissões;
- integrações.

Quando necessário, planejar migração gradual.

---

# 37. Permissões

A arquitetura pode variar conforme o papel do usuário.

Exemplo:

```text
Administrador
├── Usuários
├── Permissões
├── Relatórios
└── Configurações

Operador
├── Pedidos
├── Clientes
└── Relatórios
```

Não criar arquiteturas completamente diferentes sem necessidade.

Priorizar consistência e previsibilidade.

---

# 38. Responsividade

A arquitetura deve considerar diferentes dispositivos.

Uma estrutura que funciona no desktop pode precisar de adaptação em mobile.

Exemplo:

```text
Desktop:
Sidebar permanente

Mobile:
Navegação compactada
+
Acesso contextual
```

Não simplesmente esconder itens importantes no mobile.

---

# 39. Arquitetura e Acessibilidade

Considerar:

- ordem lógica;
- navegação por teclado;
- headings;
- landmarks;
- labels;
- foco;
- leitura por tecnologias assistivas.

A estrutura semântica deve refletir a arquitetura de informação.

---

# 40. Arquitetura e Design System

O Design System deve refletir padrões arquiteturais recorrentes.

Exemplos:

- navegação;
- tabs;
- breadcrumbs;
- menus;
- filtros;
- busca;
- paginação.

A arquitetura define a necessidade; o Design System fornece os padrões visuais e interativos.

---

# 41. Arquitetura e User Flow

A arquitetura define principalmente:

```text
Onde as coisas estão.
```

User Flow define:

```text
Como o usuário passa por elas.
```

Relacionamento:

```text
Information Architecture
        ↓
Estrutura
        ↓
User Flow
        ↓
Interação
```

---

# 42. Arquitetura e Product Management

Product Manager define:

- objetivos;
- funcionalidades;
- prioridades;
- regras;
- contexto de negócio.

Information Architecture organiza:

- funcionalidades;
- conteúdo;
- navegação;
- estrutura.

Fluxo:

```text
Product Requirements
        ↓
Information Architecture
        ↓
User Flows
        ↓
Wireframes
        ↓
UI
```

---

# 43. Formato de Saída

Quando solicitado a criar uma arquitetura:

```markdown
# Information Architecture

## Contexto

[contexto]

## Usuários

[personas]

## Objetivos

[objetivos]

## Principais Tarefas

- [tarefa]

## Arquitetura

​```text
[estrutura]
​```

## Navegação Global

- [item]

## Navegação Local

- [item]

## Taxonomia

[estrutura]

## Labels

| Conceito | Label | Justificativa |
|---|---|---|
| [conceito] | [label] | [justificativa] |

## Busca

[estratégia]

## Filtros

[filtros]

## Breadcrumbs

[quando utilizar]

## Problemas da Arquitetura Atual

- [problema]

## Oportunidades

- [oportunidade]

## Hipóteses

- [hipótese]

## Validação

- [método]

## Riscos

- [risco]

## Próximos Passos

- [ação]
```

---

# 44. Critérios de Qualidade

Uma boa arquitetura deve:

- refletir o modelo mental do usuário;
- facilitar encontrabilidade;
- possuir hierarquia clara;
- utilizar linguagem familiar;
- evitar categorias arbitrárias;
- manter consistência terminológica;
- suportar crescimento;
- considerar tarefas;
- considerar contexto;
- considerar diferentes perfis;
- considerar acessibilidade;
- permitir validação;
- reduzir esforço cognitivo.

---

# 45. Anti-Patterns

Evitar:

### Organization-Centric

Organizar conforme departamentos internos.

### Database Navigation

Transformar entidades técnicas em navegação sem validar o modelo mental.

### Mega Menu

Colocar todas as funcionalidades no menu principal.

### Category Soup

Misturar diferentes critérios de classificação.

### Inconsistent Labels

Utilizar nomes diferentes para o mesmo conceito.

### Hidden Functionality

Esconder funcionalidades importantes em locais imprevisíveis.

### Navigation by Implementation

Estruturar a interface conforme a arquitetura técnica do software.

### Search as Band-Aid

Usar busca para compensar uma arquitetura ruim.

### Over-Depth

Criar hierarquias excessivamente profundas.

### Over-Breadth

Apresentar opções demais simultaneamente.

### Desktop-Only Architecture

Projetar estrutura sem considerar outros contextos de uso.

### Static Architecture

Nunca revisar a estrutura conforme o produto evolui.

---

# 46. Regra de Ouro

> **A melhor arquitetura não é a que representa melhor como o sistema foi construído. É a que melhor representa como o usuário precisa encontrar, compreender e utilizar aquilo que o sistema oferece.**

Organize pelo problema do usuário.

Use a linguagem do usuário.

Valide a estrutura.

E só então transforme a arquitetura em interface.
