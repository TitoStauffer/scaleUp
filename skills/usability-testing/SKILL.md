---
name: usability-testing
description: Planejamento, execução e análise de testes de usabilidade para validar interfaces, fluxos, protótipos e hipóteses de UX com usuários representativos. Use quando for necessário descobrir problemas de usabilidade, medir sucesso de tarefas, comparar soluções ou validar decisões de design com evidências.
---

# Usability Testing

## Objective

Avaliar se usuários conseguem utilizar uma interface para completar tarefas reais ou representativas de forma:

- eficiente;
- compreensível;
- previsível;
- acessível;
- satisfatória;
- com baixo nível de erro.

O objetivo principal não é perguntar:

> "Você gostou do design?"

O objetivo é descobrir:

> **"O usuário consegue realizar a tarefa e onde encontra dificuldade?"**

Usability Testing deve produzir evidências para melhorar o produto.

---

# Core Principles

## 1. Observe Behavior, Not Just Opinions

O comportamento observado possui maior valor do que opiniões isoladas.

Existe diferença entre:

```text
"Eu acho que saberia usar."
```

e:

```text
Usuário realmente conseguiu completar a tarefa.
```

Priorizar evidências comportamentais.

---

## 2. Test the Task

Testar tarefas reais ou representativas.

Evitar perguntas vagas como:

```text
"Você acha essa tela boa?"
```

Preferir:

```text
"Você acabou de receber um pedido e precisa alterá-lo para cancelado. Como faria isso?"
```

---

## 3. Don't Lead the User

O moderador não deve ensinar a solução.

Evitar:

```text
"Clique naquele botão azul."
```

Preferir:

```text
"O que você faria agora?"
```

---

## 4. Failure Is Valuable

Encontrar problemas durante o teste é sucesso do processo.

O objetivo não é provar que o design está correto.

É descobrir:

- onde falha;
- por que falha;
- para quem falha;
- qual impacto possui.

---

## 5. Test Early

Não esperar o produto estar pronto.

Testar:

```text
Ideia
 ↓
Wireframe
 ↓
Protótipo
 ↓
UI
 ↓
Produto
```

Quanto mais cedo o problema é encontrado, menor tende a ser o custo de correção.

---

# When to Use

Use esta Skill quando:

- uma solução precisa ser validada;
- existe dúvida entre duas alternativas;
- um fluxo parece complexo;
- usuários estão cometendo erros;
- uma nova feature está sendo criada;
- um protótipo está disponível;
- uma interface existente apresenta abandono;
- uma mudança importante está sendo planejada;
- é necessário validar hipóteses de UX.

---

# When Not to Use

Usability Testing não substitui:

- UX Research amplo;
- entrevistas exploratórias;
- análise quantitativa;
- analytics;
- A/B testing;
- revisão heurística.

Cada método responde perguntas diferentes.

---

# Testing Questions

Antes do teste, formular perguntas.

Exemplos:

```text
Os usuários encontram a funcionalidade?

Conseguem entender o objetivo da tela?

Conseguem completar a tarefa?

Onde ocorrem erros?

Quais etapas geram hesitação?

Quais informações estão faltando?

Quais informações são ignoradas?

Os usuários entendem os estados?

Conseguem recuperar erros?

A navegação faz sentido?

A terminologia é compreensível?
```

---

# Test Objectives

Definir objetivos observáveis.

Exemplo:

```text
Objetivo:

Avaliar se operadores conseguem cadastrar um cliente sem assistência.

Critérios:

- encontram o cadastro;
- entendem os campos;
- concluem o formulário;
- identificam erros;
- conseguem finalizar.
```

Evitar objetivos vagos:

```text
"Validar a UX."
```

---

# Test Types

## Moderated

Um pesquisador acompanha o usuário.

Útil para:

- entender raciocínio;
- explorar problemas;
- fazer perguntas de acompanhamento.

---

## Unmoderated

Usuário realiza o teste sem moderador.

Útil para:

- maior escala;
- tarefas estruturadas;
- coleta mais ampla.

---

## Remote

Realizado remotamente.

Vantagens:

- facilidade;
- alcance geográfico;
- menor custo.

Limitações:

- contexto;
- controle do ambiente;
- problemas técnicos.

---

## In-Person

Realizado presencialmente.

Útil quando:

- contexto físico importa;
- equipamento específico é utilizado;
- observação presencial agrega valor.

---

## Prototype Testing

Testar:

- wireframes;
- protótipos;
- interfaces parcialmente funcionais.

É especialmente útil antes da implementação.

---

## Production Testing

Testar uma interface real em produção.

Pode revelar problemas que não aparecem em protótipos.

---

# Participant Selection

Participantes devem representar usuários relevantes.

Considerar:

- perfil comportamental;
- experiência;
- contexto;
- frequência de uso;
- conhecimento do domínio;
- tipo de tarefa.

Não selecionar apenas pessoas que concordam com a solução.

---

# Sample Diversity

Quando relevante, incluir:

```text
Novos usuários
Usuários experientes
Usuários frequentes
Usuários ocasionais
Diferentes dispositivos
Diferentes níveis de conhecimento
```

Não assumir que um único tipo de usuário representa todos.

---

# Participant Screener

Quando recrutamento for necessário, definir critérios.

Exemplo:

```text
Experiência:
Já realizou a tarefa?

Frequência:
Quantas vezes por mês?

Contexto:
Em que situação utiliza o produto?

Exclusões:
Possui conhecimento interno do projeto?
```

Evitar revelar a resposta do teste no recrutamento.

---

# Task Design

Uma boa tarefa possui:

- contexto;
- objetivo;
- motivação;
- resultado esperado.

Exemplo:

```text
Você precisa cadastrar um novo cliente para uma negociação que começará hoje.

Encontre onde realizar o cadastro e conclua o processo.
```

Não fornecer:

```text
Clique em Clientes → Novo Cliente → Salvar.
```

Isso testa memória da instrução, não usabilidade.

---

# Task Difficulty

Variar tarefas:

```text
Easy
Medium
Complex
```

Quando apropriado.

Testar também tarefas críticas.

---

# Critical Tasks

Priorizar tarefas que possuem:

- alto impacto;
- alta frequência;
- risco;
- receita;
- abandono;
- suporte;
- erro operacional.

---

# Test Script

Estrutura recomendada:

```text
## Introduction

Apresentação.

## Context

Explicação do cenário.

## Task

Descrição da tarefa.

## Observation

Comportamentos observados.

## Follow-up

Perguntas após a tentativa.

## Debrief

Feedback final.
```

---

# Introduction Script

O moderador deve deixar claro:

```text
Estamos testando o produto, não você.

Não existe resposta certa.

Queremos observar como você faria normalmente.

Se algo parecer confuso, isso é importante para nós.
```

Isso reduz ansiedade do participante.

---

# Think Aloud

Quando apropriado, pedir:

> "Fale o que está pensando enquanto realiza a tarefa."

Pode revelar:

- expectativas;
- confusão;
- modelos mentais;
- hipóteses;
- interpretações.

Mas não utilizar de maneira que atrapalhe tarefas que exigem concentração natural.

---

# Moderator Behavior

O moderador deve:

- observar;
- ouvir;
- registrar;
- evitar ajudar prematuramente;
- fazer perguntas neutras.

Evitar:

```text
"Você não está vendo o botão?"
```

Preferir:

```text
"O que você esperava encontrar aqui?"
```

---

# Intervention Ladder

Quando o usuário estiver bloqueado:

```text
1. Esperar
      ↓
2. Observar
      ↓
3. Pergunta neutra
      ↓
4. Pergunta de esclarecimento
      ↓
5. Ajuda mínima
```

Registrar quando houve intervenção.

---

# Observation

Registrar fatos observáveis.

Bom:

```text
Usuário procurou por "Clientes" durante 20 segundos.
```

Ruim:

```text
Usuário não entendeu nada.
```

Separar:

```text
Observation
Interpretation
Hypothesis
```

---

# Observation Notes

Estrutura:

```text
Participant:
P03

Task:
Cadastrar cliente

Observation:
Procurou a ação no menu lateral.

Behavior:
Abriu "Configurações".

Expectation:
Esperava encontrar cadastro dentro de configurações.

Outcome:
Não completou sem ajuda.
```

---

# Metrics

Quando apropriado, coletar:

## Task Success Rate

Percentual de tarefas concluídas.

```text
Success Rate =
Successful Tasks / Total Tasks
```

---

## Time on Task

Tempo necessário para completar a tarefa.

---

## Error Rate

Quantidade ou frequência de erros.

---

## Assistance Rate

Quantas tarefas exigiram ajuda.

---

## Abandonment Rate

Percentual de tarefas abandonadas.

---

## First Click

Onde o usuário clicou primeiro.

Pode revelar se a hierarquia ou navegação está coerente.

---

# Qualitative Signals

Observar:

- hesitação;
- confusão;
- busca visual;
- cliques repetidos;
- backtracking;
- perguntas;
- erros;
- tentativas;
- frustração;
- surpresa;
- confiança.

Esses sinais ajudam a explicar os números.

---

# Severity

Classificar problemas encontrados.

## Critical

Impede conclusão da tarefa ou gera consequência grave.

---

## High

Grande dificuldade ou alto impacto.

---

## Medium

Fricção relevante, mas usuário consegue continuar.

---

## Low

Problema pequeno ou pouco frequente.

---

# Severity Framework

Considerar:

```text
Impact
+
Frequency
+
Task Criticality
+
Recoverability
```

Não classificar severidade apenas pela quantidade de participantes que encontraram o problema.

---

# Problem Classification

Categorizar problemas.

Exemplos:

```text
Navigation
Information Architecture
Terminology
Visual Hierarchy
Interaction
Content
Accessibility
Feedback
Error Recovery
Performance
Trust
```

Isso ajuda a identificar padrões sistêmicos.

---

# Pattern Identification

Depois dos testes:

```text
Observations
      ↓
Individual Issues
      ↓
Similar Issues
      ↓
Patterns
      ↓
Insights
      ↓
Recommendations
```

Não transformar cada comportamento observado em um problema separado.

---

# Evidence Confidence

Classificar confiança.

Exemplo:

```text
High confidence
→ padrão observado repetidamente

Medium confidence
→ sinal consistente, mas evidência limitada

Low confidence
→ hipótese inicial
```

Não tratar uma observação isolada como verdade universal.

---

# Triangulation

Quando possível, combinar:

```text
Usability Testing
+
Analytics
+
Support Tickets
+
Research
+
User Feedback
```

Isso ajuda a separar:

```text
Problema real
vs
Problema específico do teste
```

---

# SUS

Quando apropriado, utilizar o:

> System Usability Scale

SUS pode fornecer uma medida padronizada de percepção de usabilidade.

Não utilizar SUS como substituto para observar tarefas.

---

# Satisfaction

Perguntar sobre experiência após a tarefa.

Exemplos:

```text
Quão fácil ou difícil foi realizar a tarefa?

O que foi mais confuso?

O que você esperava que acontecesse?

O que você mudaria?
```

Evitar perguntas que induzam resposta positiva.

---

# Prototype Limitations

Ao testar protótipos, lembrar:

- nem tudo está implementado;
- algumas interações podem ser simuladas;
- performance não representa produção;
- estados podem estar incompletos.

Documentar essas limitações.

---

# Production Limitations

Em produção, considerar:

- dados reais;
- permissões;
- performance;
- integrações;
- ambiente;
- riscos operacionais.

Nunca realizar testes destrutivos em dados reais sem controle apropriado.

---

# Accessibility Testing

Usability Testing deve incluir, quando relevante:

- teclado;
- screen reader;
- zoom;
- text scaling;
- contraste;
- touch;
- diferentes métodos de entrada.

Não testar acessibilidade apenas visualmente.

---

# Mobile Testing

Testar tarefas em dispositivos reais quando possível.

Observar:

- tamanho dos targets;
- teclado;
- scroll;
- orientação;
- navegação;
- gestos;
- distrações;
- contexto físico.

---

# Competitive Benchmarking

Quando útil, testar soluções existentes.

Objetivo:

- identificar padrões;
- entender expectativas;
- encontrar oportunidades.

Não copiar concorrentes automaticamente.

---

# Comparative Testing

Quando existem duas soluções:

```text
Solution A
vs
Solution B
```

Definir previamente:

- tarefa;
- participantes;
- métricas;
- critérios;
- ordem;
- hipóteses.

Evitar comparar apenas por opinião.

---

# Prototype A/B

Quando possível:

```text
Group A → Prototype A

Group B → Prototype B
```

Controlar diferenças relevantes.

Evitar concluir superioridade com amostras inadequadas.

---

# Test Bias

Possíveis vieses:

- moderator bias;
- selection bias;
- confirmation bias;
- learning effect;
- novelty effect;
- social desirability;
- order effect.

Mitigar quando possível.

---

# Learning Effect

Se o mesmo participante testar duas soluções, pode aprender com a primeira.

Considerar:

```text
A → B
```

versus:

```text
B → A
```

quando ordem puder influenciar resultado.

---

# Test Environment

Registrar:

```text
Device
OS
Browser
Viewport
Connection
Prototype version
Date
Task
Participant
```

Isso facilita reprodução dos resultados.

---

# Version Control

Todo teste deve indicar qual versão foi testada.

Exemplo:

```text
Prototype:
v0.8.2

Test:
Round 2
```

Não misturar conclusões de versões diferentes sem contexto.

---

# Test Report

Estrutura recomendada:

```text
## Executive Summary

Principais descobertas.

## Objective

O que foi investigado.

## Participants

Quem participou.

## Tasks

Quais tarefas foram testadas.

## Findings

Problemas encontrados.

## Metrics

Resultados quantitativos.

## Severity

Prioridade dos problemas.

## Insights

O que aprendemos.

## Recommendations

O que fazer.

## Open Questions

O que ainda não sabemos.
```

---

# Finding Format

Cada finding deve seguir:

```text
## Finding

### Problem

<problema>

### Evidence

<observação>

### Impact

<impacto>

### Frequency

<frequência>

### Severity

<severidade>

### Hypothesis

<possível causa>

### Recommendation

<recomendação>

### Confidence

<confiança>
```

---

# Recommendations

Recomendações devem ser:

- específicas;
- acionáveis;
- relacionadas à evidência.

Ruim:

```text
Melhorar UX.
```

Melhor:

```text
Mover "Novo Cliente" para a área de ações primárias da página de clientes, pois 4 de 6 participantes procuraram a ação no menu lateral.
```

---

# Don't Overfit

Não alterar todo o produto baseado em uma única sessão.

Perguntar:

```text
Isso é um padrão?
É crítico?
É frequente?
Existe evidência adicional?
```

---

# Iterative Testing

Usabilidade deve ser um ciclo:

```text
Design
   ↓
Test
   ↓
Findings
   ↓
Improve
   ↓
Test Again
   ↺
```

Não tratar teste como evento único.

---

# Test → Design Feedback Loop

As descobertas devem retornar para as Skills anteriores.

```text
Usability Testing
        ↓
Finding
        ↓
UX Problem
        ↓
User Flow / IA / Wireframe / Interaction
        ↓
New Design
        ↓
New Test
```

Um teste pode revelar que o problema está na arquitetura, não no componente visual.

---

# Quality Criteria

Um bom teste de usabilidade:

- possui objetivo claro;
- testa tarefas reais;
- utiliza participantes relevantes;
- evita indução;
- observa comportamento;
- registra evidências;
- separa fatos de interpretações;
- identifica padrões;
- mede sucesso quando apropriado;
- classifica severidade;
- documenta limitações;
- produz recomendações acionáveis;
- gera aprendizado para o próximo ciclo.

---

# Anti-Patterns

## Testing Opinions

Perguntar apenas se o usuário gostou.

---

## Leading the User

Ensinar o caminho durante o teste.

---

## Testing the Interface Instead of the Task

Avaliar apenas estética.

---

## Small Sample Overconfidence

Tratar poucos participantes como representação estatística universal.

---

## Confirmation Bias

Buscar evidências para confirmar uma decisão já tomada.

---

## Moderator Rescue

Ajudar o usuário cedo demais.

---

## Vanity Metrics

Coletar números que não ajudam a tomar decisões.

---

## One-and-Done Testing

Testar uma vez e nunca iterar.

---

## Ignoring Accessibility

Testar apenas usuários e contextos convencionais.

---

## Testing the Wrong Version

Misturar resultados de protótipos diferentes.

---

## Overfitting

Reprojetar todo o produto baseado em um caso isolado.

---

## No Action After Testing

Coletar feedback e não transformar em mudanças.

---

# Usability Testing Checklist

```text
[ ] Objective definido
[ ] Research question definida
[ ] Participants definidos
[ ] Screener definido quando necessário
[ ] Tasks definidas
[ ] Critical tasks identificadas
[ ] Script preparado
[ ] Moderator guidelines preparadas
[ ] Environment definido
[ ] Prototype version registrada
[ ] Metrics definidas
[ ] Observations registradas
[ ] Behavior separado de opinião
[ ] Problems classificados
[ ] Severity definida
[ ] Confidence definida
[ ] Patterns identificados
[ ] Recommendations criadas
[ ] Accessibility considerada
[ ] Mobile considerado
[ ] Findings documentados
[ ] Next steps definidos
[ ] Retest planejado quando necessário
```

---

# Rule of Thumb

> **Não pergunte ao usuário se ele consegue fazer algo. Dê a tarefa e observe se ele consegue.**

A diferença entre:

```text
"Você saberia onde cadastrar um cliente?"
```

e:

```text
"Você precisa cadastrar este cliente. Faça o que faria normalmente."
```

é enorme.

A segunda abordagem produz evidência de comportamento.

---

# Final Principle

**Usability Testing não existe para provar que o design está certo.**

Existe para descobrir onde ele está errado, onde está confuso e onde pode ser melhorado.

O ciclo ideal é:

```text
Hipótese
   ↓
Design
   ↓
Teste
   ↓
Evidência
   ↓
Insight
   ↓
Mudança
   ↓
Novo teste
   ↺
```

> **O melhor design não é aquele que parece intuitivo para quem o criou. É aquele que continua funcionando quando colocamos usuários reais diante dele.**
