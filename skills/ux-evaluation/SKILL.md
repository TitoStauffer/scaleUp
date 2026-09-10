---
name: ux-evaluation
description: Avalia interfaces, fluxos e experiências digitais para identificar problemas de usabilidade, inconsistências, fricções e oportunidades de melhoria. Use para realizar avaliações heurísticas, revisar UX antes de desenvolvimento ou lançamento, analisar problemas encontrados em testes e transformar evidências em recomendações acionáveis.
---

# UX Evaluation

## Objective

Avaliar sistematicamente uma experiência digital para identificar:

- problemas de usabilidade;
- fricções;
- inconsistências;
- problemas de compreensão;
- dificuldades de navegação;
- problemas de interação;
- problemas de acessibilidade;
- violações de padrões de UX;
- riscos de abandono;
- oportunidades de melhoria.

A avaliação deve transformar observações em **problemas claros, priorizados e acionáveis**.

O objetivo não é simplesmente dizer se uma interface é "bonita" ou "feia".

O objetivo é determinar:

> **A experiência permite que o usuário alcance seu objetivo com clareza, eficiência, confiança e baixo esforço?**

---

# Core Principles

## 1. Avalie a experiência, não apenas a tela

Uma tela isolada pode parecer correta e ainda fazer parte de um fluxo ruim.

Avalie:

```text
Contexto
   ↓
Entrada
   ↓
Navegação
   ↓
Interação
   ↓
Feedback
   ↓
Resultado
```

Sempre que possível, avaliar o fluxo completo.

---

## 2. Evidência > opinião

Separar:

### Evidência

Algo observado diretamente.

Exemplo:

> O usuário não encontrou o botão para concluir o cadastro durante o teste.

### Hipótese

Possível explicação.

> O botão pode estar pouco destacado.

### Opinião

Preferência pessoal.

> Eu colocaria o botão no topo.

Não tratar preferência visual como problema de UX sem evidência ou princípio que a sustente.

---

## 3. Avalie contra critérios explícitos

Uma avaliação deve utilizar critérios claros.

Exemplos:

- heurísticas de usabilidade;
- requisitos do produto;
- padrões do design system;
- acessibilidade;
- comportamento esperado;
- métricas;
- feedback de usuários;
- resultados de testes;
- objetivos do usuário.

---

## 4. Problemas devem ser acionáveis

Evitar:

> "A tela está confusa."

Preferir:

> "O usuário precisa distinguir entre 'Salvar rascunho' e 'Finalizar'. Atualmente os dois CTAs possuem a mesma hierarquia visual, aumentando o risco de conclusão acidental."

O problema deve permitir que alguém tome uma decisão.

---

## 5. Severidade não é opinião estética

Priorizar problemas pelo impacto.

Uma escala possível:

### Critical

Impede a realização da tarefa ou pode gerar consequências graves.

### High

Dificulta significativamente a realização da tarefa.

### Medium

Gera fricção ou confusão, mas permite concluir a tarefa.

### Low

Problema menor, inconsistência ou melhoria incremental.

---

# When to Use

Usar esta Skill quando:

- uma interface já existe;
- um protótipo precisa ser revisado;
- um fluxo foi desenhado e precisa de validação;
- uma feature está próxima de desenvolvimento;
- uma feature está próxima de lançamento;
- testes de usabilidade encontraram problemas;
- usuários estão abandonando uma jornada;
- existem reclamações recorrentes;
- uma interface parece inconsistente;
- uma mudança importante foi realizada;
- existe dúvida sobre a qualidade da experiência.

---

# Inputs

Quando disponíveis, considerar:

- problema do usuário;
- personas;
- user journey;
- user flows;
- wireframes;
- protótipos;
- telas existentes;
- requisitos;
- regras de negócio;
- métricas;
- resultados de testes;
- feedback de usuários;
- analytics;
- design system;
- requisitos de acessibilidade;
- contexto técnico;
- plataforma;
- dispositivos;
- restrições conhecidas.

---

# Evaluation Process

## Step 1 — Understand the Context

Antes de avaliar, entender:

- quem é o usuário;
- qual é o objetivo;
- qual é a tarefa;
- em qual contexto ela acontece;
- qual é o resultado esperado;
- quais são as restrições;
- qual é o risco do problema.

Não avaliar uma interface sem compreender seu propósito.

---

# Step 2 — Define the Evaluation Scope

Determinar:

- telas;
- fluxos;
- componentes;
- funcionalidades;
- estados;
- dispositivos;
- cenários;
- personas;
- etapas da jornada.

Exemplo:

```text
Feature:
Cadastro de cliente

Escopo:
- tela inicial
- formulário
- validação
- confirmação
- erro
- edição

Plataformas:
- desktop
- mobile
```

---

# Step 3 — Evaluate the User Goal

Perguntar:

- O usuário entende o que precisa fazer?
- O objetivo está claro?
- A próxima ação é evidente?
- O resultado esperado está claro?
- Existem obstáculos desnecessários?
- Existe esforço cognitivo excessivo?

---

# Step 4 — Evaluate Information Architecture

Verificar:

- organização das informações;
- hierarquia;
- agrupamento;
- nomenclatura;
- navegação;
- localização das funcionalidades;
- consistência entre telas;
- previsibilidade.

Perguntar:

> "Onde o usuário esperaria encontrar isso?"

---

# Step 5 — Evaluate Interaction

Verificar:

- affordances;
- estados;
- feedback;
- validações;
- loading;
- sucesso;
- erro;
- cancelamento;
- confirmação;
- undo;
- ações destrutivas;
- interações assíncronas;
- foco;
- teclado;
- touch.

Toda interação importante deve ter uma resposta compreensível.

---

# Step 6 — Evaluate Content

Avaliar:

- clareza dos textos;
- labels;
- CTAs;
- mensagens de erro;
- mensagens de sucesso;
- instruções;
- placeholders;
- textos auxiliares;
- consistência terminológica.

Evitar mensagens genéricas.

### Ruim

> Erro ao processar.

### Melhor

> Não foi possível salvar o cliente. Verifique sua conexão e tente novamente.

---

# Step 7 — Evaluate Visual Hierarchy

Avaliar:

- prioridade visual;
- contraste;
- tipografia;
- espaçamento;
- alinhamento;
- agrupamento;
- densidade;
- destaque de ações;
- diferenciação entre estados;
- consistência visual.

A pergunta principal é:

> "O usuário consegue perceber rapidamente o que importa?"

---

# Step 8 — Evaluate Accessibility

Verificar:

- contraste;
- tamanho de texto;
- foco;
- navegação por teclado;
- labels;
- mensagens de erro;
- semântica;
- leitores de tela;
- tamanho dos alvos de interação;
- uso de cor;
- motion;
- reduced motion;
- zoom;
- text scaling;
- acessibilidade cognitiva.

Nunca considerar acessibilidade como etapa opcional.

---

# Step 9 — Evaluate Error Handling

Avaliar:

### Prevention

O erro poderia ser evitado?

### Detection

O usuário percebeu que ocorreu?

### Explanation

O usuário entende o que aconteceu?

### Recovery

O usuário sabe como corrigir?

### Persistence

O sistema preservou o que já havia sido preenchido?

Um bom erro não apenas informa que algo deu errado.

Ele ajuda o usuário a recuperar o fluxo.

---

# Step 10 — Evaluate Edge Cases

Não avaliar apenas o happy path.

Considerar:

- dados vazios;
- dados muito longos;
- valores inválidos;
- duplicidade;
- timeout;
- falha de API;
- ausência de conexão;
- carregamento lento;
- permissões insuficientes;
- sessão expirada;
- usuário cancelando;
- usuário voltando;
- múltiplos cliques;
- operação duplicada;
- estados intermediários.

---

# Step 11 — Evaluate Consistency

Verificar consistência entre:

- nomenclatura;
- componentes;
- comportamentos;
- espaçamentos;
- hierarquia;
- mensagens;
- ícones;
- estados;
- navegação;
- padrões de interação.

Inconsistência aumenta o esforço de aprendizado.

---

# Step 12 — Evaluate User Effort

Identificar:

- quantidade de decisões;
- quantidade de campos;
- etapas desnecessárias;
- informações que precisam ser lembradas;
- navegação excessiva;
- retrabalho;
- digitação;
- mudanças de contexto;
- necessidade de interpretação.

Não assumir que "menos cliques" significa automaticamente melhor UX.

O objetivo é reduzir:

> **esforço desnecessário.**

---

# Step 13 — Identify UX Problems

Registrar cada problema separadamente.

Formato:

```text
Problema:
O usuário não percebe qual ação conclui o cadastro.

Evidência:
Existem três CTAs com peso visual semelhante.

Impacto:
Aumenta a incerteza no momento de conclusão.

Severidade:
Medium.

Princípio afetado:
Clareza / hierarquia visual.

Recomendação:
Estabelecer "Concluir cadastro" como CTA primário.

Confiança:
Alta.
```

---

# Step 14 — Prioritize Problems

Uma abordagem simples:

```text
Prioridade = Impacto × Frequência × Risco
```

Considerar:

### Impacto

Quanto o problema prejudica o usuário?

### Frequência

Quantas pessoas ou situações são afetadas?

### Risco

Qual o custo de manter o problema?

Exemplos de alto risco:

- pagamento incorreto;
- exclusão acidental;
- perda de dados;
- problemas de segurança;
- erros financeiros;
- bloqueio de tarefas críticas.

---

# Step 15 — Recommend Improvements

Cada recomendação deve:

- resolver o problema identificado;
- respeitar o contexto;
- considerar regras de negócio;
- preservar consistência;
- considerar acessibilidade;
- evitar complexidade desnecessária.

Evitar simplesmente trocar componentes sem entender a causa.

---

# Heuristic Evaluation

Quando apropriado, utilizar heurísticas clássicas de usabilidade.

Avaliar especialmente:

1. Visibilidade do status do sistema
2. Correspondência com o mundo real
3. Controle e liberdade do usuário
4. Consistência e padrões
5. Prevenção de erros
6. Reconhecimento em vez de memorização
7. Flexibilidade e eficiência
8. Design minimalista
9. Ajuda para reconhecer e recuperar erros
10. Ajuda e documentação

As heurísticas são instrumentos de avaliação, não regras absolutas.

---

# Evaluation Matrix

Quando útil, estruturar a análise:

| Área | Problema | Impacto | Severidade | Confiança | Recomendação |
|---|---|---|---|---|---|
| Navegação | Usuário não encontra função | Alto | High | Alta | Revisar IA |
| Formulário | Erros pouco claros | Médio | Medium | Alta | Melhorar mensagens |
| CTA | Hierarquia ambígua | Médio | Medium | Média | Revisar prioridade |
| Acessibilidade | Foco não visível | Alto | High | Alta | Corrigir estados |

---

# Confidence

Classificar confiança da avaliação:

### High

Evidência direta ou problema claramente fundamentado.

### Medium

Indícios relevantes, mas falta validação.

### Low

Hipótese que precisa ser testada.

Nunca apresentar uma hipótese como fato.

---

# UX Evaluation Report

Quando solicitado um relatório, utilizar:

```text
# UX Evaluation

## Context
...

## Scope
...

## User Goal
...

## Summary
...

## Critical Findings

### Finding 1
Problem:
Evidence:
Impact:
Severity:
Confidence:
Recommendation:

## Medium / Low Findings
...

## Accessibility Findings
...

## Edge Cases
...

## Prioritized Recommendations

P0:
...

P1:
...

P2:
...

## Open Questions
...

## Recommended Validation
...
```

---

# Evaluation by Stage

## Before Development

Priorizar:

- fluxos;
- arquitetura;
- clareza;
- regras de interação;
- estados;
- acessibilidade;
- edge cases.

Objetivo:

> Evitar problemas antes de virar código.

---

## During Development

Priorizar:

- fidelidade à especificação;
- comportamento;
- estados;
- componentes;
- responsividade;
- acessibilidade.

---

## Before Launch

Priorizar:

- tarefas críticas;
- regressões;
- erros;
- acessibilidade;
- dispositivos;
- performance percebida;
- estados extremos.

---

## After Launch

Priorizar:

- métricas;
- comportamento real;
- abandono;
- tickets;
- feedback;
- problemas recorrentes.

---

# Evaluation Sources

Combinar diferentes fontes quando possível:

```text
Heurísticas
     +
Analytics
     +
Usability Testing
     +
Feedback
     +
Support Tickets
     +
Product Metrics
     ↓
UX Diagnosis
```

Uma única fonte raramente explica toda a experiência.

---

# Do Not Confuse

## UX Problem ≠ UI Preference

Exemplo:

> "Eu prefiro botão azul."

Não é necessariamente problema.

Mas:

> "O CTA primário não possui diferenciação suficiente das ações secundárias."

Pode ser um problema de hierarquia.

---

## UX Problem ≠ Business Rule

Uma regra de negócio pode tornar uma experiência mais complexa.

Não alterar uma regra simplesmente para simplificar a interface.

Primeiro entender:

```text
Regra de negócio
      ↓
Necessidade
      ↓
Restrição
      ↓
Experiência
```

---

## UX Problem ≠ Technical Limitation

Uma limitação técnica pode explicar um comportamento, mas não significa que seja a melhor experiência possível.

Registrar:

```text
UX requirement
+
Technical constraint
=
Design decision
```

---

# Anti-Patterns

Nunca:

- avaliar apenas estética;
- inventar problemas sem evidência;
- transformar preferência pessoal em requisito;
- avaliar somente o happy path;
- ignorar acessibilidade;
- ignorar estados de erro;
- ignorar mobile;
- recomendar redesign completo sem necessidade;
- listar dezenas de problemas sem priorização;
- tratar todos os problemas como igualmente importantes;
- confundir sintoma com causa;
- alterar regra de negócio sem entender o contexto;
- recomendar padrões só porque estão na moda;
- considerar "menos cliques" como métrica universal de qualidade.

---

# Quality Criteria

Uma boa avaliação deve ser:

- baseada em evidências;
- estruturada;
- objetiva;
- acionável;
- priorizada;
- contextualizada;
- acessível;
- orientada ao usuário;
- consciente das restrições;
- clara sobre incertezas.

O resultado deve permitir que Product, Design e Engineering saibam:

```text
O que está errado?
        ↓
Por que importa?
        ↓
Quem é afetado?
        ↓
Qual a severidade?
        ↓
Qual a recomendação?
        ↓
Como validar?
```

---

# Outputs

Dependendo do contexto, produzir:

- UX evaluation;
- heuristic evaluation;
- UX audit;
- usability findings;
- accessibility findings;
- problem backlog;
- severity matrix;
- prioritized recommendations;
- redesign recommendations;
- validation plan;
- UX quality report.

---

# Rule of Thumb

> **Não pergunte apenas "isso está bom?". Pergunte "qual comportamento do usuário queremos facilitar e quais evidências mostram que estamos conseguindo?"**

Uma boa avaliação não procura defeitos por procurar.

Ela identifica **obstáculos reais entre o usuário e seu objetivo** e transforma esses obstáculos em decisões de design melhores.
