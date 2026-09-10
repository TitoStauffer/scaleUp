---
name: a-b-test-design
description: Planeja experimentos A/B para validar hipóteses de UX/UI de forma estatisticamente e operacionalmente adequada. Define hipótese, controle, variante, métricas, população, segmentação, critérios de sucesso, riscos, duração, instrumentação e regras de decisão. Use quando houver uma hipótese comparável e condições suficientes para realizar um experimento controlado.
---

# A/B Test Design

## Objective

Transformar uma hipótese de UX/UI em um experimento controlado capaz de gerar evidência para uma decisão.

O processo deve seguir:

```text
Problem
   ↓
Hypothesis
   ↓
Experiment
   ↓
Control vs Variant
   ↓
Measurement
   ↓
Analysis
   ↓
Decision
```

O objetivo não é simplesmente descobrir qual versão "converte mais".

O objetivo é responder:

> **A mudança proposta causou uma melhoria relevante no comportamento ou resultado que queremos otimizar, sem criar danos importantes em outras dimensões da experiência?**

---

# Core Principles

## 1. Experiment the Hypothesis, Not the Design

Não começar com:

> "Vamos testar dois botões."

Começar com:

> "Acreditamos que tornar a ação principal mais explícita reduzirá erros de conclusão."

O elemento visual é apenas a intervenção.

---

## 2. Correlation ≠ Causation

Uma métrica melhorar durante um período não significa necessariamente que a mudança causou a melhoria.

Considerar:

- sazonalidade;
- campanhas;
- mudanças de tráfego;
- releases;
- incidentes;
- alterações de preço;
- mudanças externas;
- composição da população.

---

## 3. One Primary Hypothesis

Um experimento deve possuir uma hipótese principal clara.

Evitar:

```text
Testar:
- botão
- copy
- layout
- preço
- fluxo
- formulário
```

ao mesmo tempo sem saber qual mudança causou o efeito.

---

## 4. Primary Metric Must Be Defined Before the Test

Definir previamente:

```text
Primary Metric
Secondary Metrics
Guardrail Metrics
```

Não escolher a métrica depois de observar os resultados.

---

# When to Use

Usar esta Skill quando:

- existem duas ou mais soluções plausíveis;
- existe tráfego suficiente;
- a experiência pode ser randomizada;
- o comportamento pode ser medido;
- existe uma métrica clara;
- o risco da mudança permite experimentação;
- a decisão precisa de evidência quantitativa.

---

# When NOT to Use

Não utilizar A/B testing automaticamente.

Evitar quando:

- não existe tráfego suficiente;
- o problema é raro;
- o resultado precisa ser entendido qualitativamente;
- a mudança é obrigatória;
- existe risco ético ou operacional elevado;
- não é possível randomizar;
- não existe métrica adequada;
- o problema exige entendimento antes da comparação.

Nesses casos, considerar:

- usability testing;
- entrevistas;
- protótipo;
- análise qualitativa;
- análise de comportamento;
- rollout gradual.

---

# Inputs

Quando disponíveis:

- problema;
- hipótese;
- user journey;
- user flow;
- design atual;
- variante proposta;
- métricas existentes;
- analytics;
- população;
- segmentos;
- tráfego;
- baseline;
- restrições;
- riscos;
- requisitos de negócio.

---

# Experiment Design Process

## Step 1 — Define the Problem

Registrar:

```text
Problem:
...

Evidence:
...

Current Impact:
...

Affected Users:
...
```

Nunca iniciar o experimento apenas porque uma nova interface foi criada.

---

# Step 2 — Define the Hypothesis

Utilizar:

```text
We believe that
[intervention]

for
[target users]

will cause
[expected behavior]

because
[rationale].

We will know this is true if
[metric changes].
```

Exemplo:

```text
We believe that simplifying the checkout summary

for first-time buyers

will increase checkout completion

because users currently have difficulty understanding
the final price.

We will know this is true if checkout completion increases
without increasing payment errors.
```

---

# Step 3 — Define Control

O controle representa a experiência atual ou baseline.

```text
Control:
Current experience.
```

Documentar:

- versão;
- comportamento;
- componentes;
- fluxo;
- métricas;
- período de referência.

---

# Step 4 — Define Variant

A variante deve possuir uma diferença explícita.

```text
Variant:
New checkout summary.

Change:
- clearer price hierarchy
- simplified information
- explicit total
```

Não esconder outras mudanças dentro da variante.

---

# Step 5 — Define Experiment Unit

Determinar o que será randomizado:

- usuário;
- conta;
- sessão;
- dispositivo;
- organização;
- transação.

A unidade deve evitar contaminação entre grupos.

Exemplo:

```text
User A → Control
User A → Control

User B → Variant
User B → Variant
```

Evitar que o mesmo usuário alterne entre experiências quando isso comprometer o experimento.

---

# Step 6 — Define Population

Especificar:

```text
Population:
...

Included:
...

Excluded:
...
```

Exemplo:

```text
Included:
New customers using web checkout.

Excluded:
Internal users.
Bots.
Users without completed sessions.
```

---

# Step 7 — Define Randomization

Quando apropriado:

```text
Control:
50%

Variant:
50%
```

A distribuição depende do risco.

Para mudanças de maior risco:

```text
Control:
90%

Variant:
10%
```

seguido de expansão gradual se os resultados forem seguros.

---

# Step 8 — Define Exposure

Determinar quando um usuário entra no experimento.

Exemplo:

```text
Exposure:
When checkout page is rendered.
```

Não contar usuários que nunca tiveram contato com a variante.

---

# Step 9 — Define Primary Metric

A métrica principal deve representar o objetivo do experimento.

Exemplos:

- task completion;
- conversion;
- successful checkout;
- form completion;
- error-free completion;
- activation.

Exemplo:

```text
Primary Metric:
Checkout completion rate.
```

---

# Step 10 — Define Secondary Metrics

Acompanhar outras dimensões:

```text
Secondary:
- time to completion
- retry rate
- form completion
- support contact
```

Essas métricas ajudam a interpretar o resultado.

---

# Step 11 — Define Guardrail Metrics

Guardrails protegem contra melhorias superficiais.

Exemplo:

```text
Primary:
Checkout completion ↑

Guardrails:
Payment errors
Refunds
Support tickets
Cancellation rate
```

Uma variante não deve ser considerada vencedora apenas porque melhora uma métrica enquanto prejudica outra crítica.

---

# Step 12 — Define Success Criteria

Antes do teste:

```text
Success:
Primary metric improves without violating guardrails.
```

Quando possível, definir um efeito mínimo relevante.

Exemplo:

```text
Minimum meaningful improvement:
+5% relative improvement.
```

Não inventar thresholds sem contexto.

---

# Step 13 — Define Sample Size

Quando houver condições para cálculo estatístico, considerar:

- baseline conversion;
- minimum detectable effect;
- significance level;
- statistical power;
- allocation ratio;
- expected traffic.

Não escolher duração ou amostra apenas porque:

> "vamos deixar rodando uma semana."

---

# Step 14 — Define Experiment Duration

A duração deve considerar:

- volume;
- comportamento semanal;
- sazonalidade;
- ciclos de negócio;
- tempo necessário para exposição;
- estabilidade do experimento.

Evitar interromper imediatamente ao primeiro resultado positivo.

---

# Step 15 — Define Instrumentation

Documentar eventos necessários:

```text
experiment_exposed
primary_action
conversion
error
abandonment
```

Cada evento deve possuir:

- nome;
- trigger;
- propriedades;
- identificação do experimento;
- variante.

---

# Step 16 — Define Experiment Identity

Todo evento relevante deve permitir identificar:

```text
experiment_id
variant
user/session
timestamp
```

Quando aplicável.

Isso facilita análise e debugging.

---

# Step 17 — Define Data Quality Checks

Antes de confiar nos resultados:

Verificar:

- exposição;
- distribuição entre grupos;
- eventos;
- duplicidade;
- missing data;
- tracking failures;
- diferenças inesperadas;
- tráfego inválido;
- bots.

Se os dados estiverem incorretos:

> **O experimento não está pronto para decisão.**

---

# Step 18 — Validate Randomization

Verificar se os grupos possuem distribuição razoavelmente esperada.

Exemplo:

```text
Expected:
50 / 50

Observed:
49.7 / 50.3
```

Uma diferença pequena pode ser normal.

Uma diferença inesperada exige investigação.

---

# Step 19 — Monitor Experiment Health

Durante o experimento, acompanhar:

- crashes;
- errors;
- latency;
- conversion;
- guardrails;
- exposição;
- tracking.

Se houver risco grave:

```text
Pause / Stop
```

Não esperar o final do experimento para agir sobre problemas críticos.

---

# Step 20 — Avoid Peeking Bias

Não alterar continuamente a decisão com base em pequenas flutuações intermediárias sem um método estatístico apropriado.

Evitar:

```text
Day 1:
Variant +8%
→ ship!

Day 2:
Variant +2%
→ continue!

Day 3:
Variant -3%
→ stop!
```

Definir previamente as regras de decisão.

---

# Step 21 — Analyze Results

Comparar:

```text
Control
vs
Variant
```

Considerar:

- diferença absoluta;
- diferença relativa;
- intervalo de confiança;
- significância estatística quando aplicável;
- efeito prático;
- guardrails;
- segmentos;
- qualidade dos dados.

---

# Statistical Significance

Quando apropriado, considerar:

```text
Observed Effect
+
Uncertainty
+
Statistical Test
```

Não utilizar "significativo" apenas como sinônimo de "diferença grande".

Uma diferença estatisticamente significativa pode ser pequena demais para ter valor prático.

---

# Practical Significance

Perguntar:

> Mesmo que a diferença seja estatisticamente significativa, ela é relevante para o usuário ou negócio?

Exemplo:

```text
Conversion:
+0.1%

Statistically significant:
Yes

Practical significance:
Potentially low
```

A decisão deve considerar impacto real.

---

# Segment Analysis

Segmentos podem revelar comportamentos diferentes:

- novos usuários;
- usuários recorrentes;
- mobile;
- desktop;
- região;
- plano;
- tipo de cliente.

Mas:

> Não procurar segmentos apenas até encontrar um resultado positivo.

Segment analysis deve ter racional definido ou ser tratada como exploratória.

---

# Interaction Effects

Quando necessário, considerar se:

```text
Variant effect
```

depende de:

```text
Device
User type
Traffic source
```

Não assumir que um resultado observado em um segmento representa todos os usuários.

---

# Experiment Results

Classificar resultado como:

### Winner

Variante melhora a métrica principal sem violar guardrails relevantes.

### No Clear Difference

Não existe evidência suficiente de diferença relevante.

### Negative

Variante piora resultado relevante.

### Inconclusive

Dados insuficientes ou problemas de instrumentação impedem conclusão.

---

# Decision Framework

Utilizar:

```text
                 Primary Metric
                      │
          ┌───────────┴───────────┐
          ↓                       ↓
       Improves                Does not improve
          │                       │
      Guardrails?              Stop / Learn
       /       \
     Yes       No
     ↓          ↓
   Ship      Investigate
```

---

# Rollout Strategy

Uma variante vencedora pode ser expandida gradualmente:

```text
10%
 ↓
25%
 ↓
50%
 ↓
100%
```

Após cada etapa:

- verificar erros;
- verificar métricas;
- verificar guardrails;
- verificar feedback.

---

# Experiment Documentation

Quando solicitado um plano completo:

```text
# A/B Test Design

## Experiment
...

## Problem
...

## Evidence
...

## Hypothesis
...

## Control
...

## Variant
...

## Target Population
...

## Exclusions
...

## Randomization
...

## Exposure
...

## Primary Metric
...

## Secondary Metrics
...

## Guardrail Metrics
...

## Success Criteria
...

## Sample Size
...

## Expected Duration
...

## Instrumentation
...

## Data Quality Checks
...

## Risks
...

## Stop Conditions
...

## Analysis Plan
...

## Decision Rules
...

## Rollout Plan
...

## Open Questions
...
```

---

# Stop Conditions

Definir antecipadamente situações que exigem interrupção.

Exemplos:

```text
Critical error rate increase
Payment failures increase
Data loss
Security issue
Severe accessibility regression
Business-critical metric degradation
```

Não sacrificar segurança ou experiência para concluir um experimento.

---

# Ethical Considerations

Não utilizar experimentação para:

- manipular usuários de forma enganosa;
- esconder informações importantes;
- dificultar cancelamento;
- criar dark patterns;
- explorar vulnerabilidades;
- aumentar conversão causando dano significativo.

Uma variante vencedora não é automaticamente uma boa experiência.

---

# Dark Pattern Check

Antes de aprovar uma variante, verificar:

- existe pressão artificial?
- informações importantes foram ocultadas?
- cancelamento ficou mais difícil?
- consentimento ficou ambíguo?
- ações foram apresentadas de forma enganosa?
- o usuário perde controle?

Se sim:

> Reavaliar a proposta.

---

# A/B Testing vs Usability Testing

Usar A/B testing para responder:

> "Qual alternativa produz melhor resultado em comportamento mensurável?"

Usar usability testing para responder:

> "Por que o usuário está tendo dificuldade?"

Uma abordagem não substitui a outra.

---

# Experiment Lifecycle

```text
Problem
   ↓
Research
   ↓
Hypothesis
   ↓
Design
   ↓
Instrumentation
   ↓
Experiment
   ↓
Analysis
   ↓
Decision
   ↓
Rollout
   ↓
Learning
```

---

# Common Failure Modes

## Tracking Failure

O evento não dispara corretamente.

Resultado:

> Dados inválidos.

---

## Sample Bias

A população do experimento não representa o público relevante.

---

## Novelty Effect

Usuários respondem temporariamente à novidade.

---

## Seasonality

O resultado depende de período específico.

---

## Contamination

Usuários são expostos a múltiplas variantes.

---

## Metric Gaming

A métrica melhora enquanto o resultado real piora.

---

## False Positive

Uma diferença aparece por acaso.

---

## False Negative

O experimento não detecta um efeito real.

---

# Anti-Patterns

Nunca:

- fazer A/B test porque "parece profissional";
- testar sem hipótese;
- testar sem métrica;
- escolher métrica depois do resultado;
- ignorar guardrails;
- parar ao primeiro resultado positivo;
- continuar indefinidamente sem critério;
- inventar significância estatística;
- confundir significância estatística com impacto prático;
- testar múltiplas mudanças sem entender o efeito;
- ignorar qualidade dos dados;
- analisar apenas segmentos favoráveis;
- sacrificar acessibilidade;
- usar dark patterns;
- testar mudanças obrigatórias;
- substituir pesquisa qualitativa por A/B test.

---

# Quality Criteria

Um experimento bem desenhado deve possuir:

- problema claro;
- hipótese explícita;
- controle definido;
- variante definida;
- população definida;
- unidade de randomização;
- exposição definida;
- métrica primária;
- métricas secundárias;
- guardrails;
- critérios de sucesso;
- critérios de parada;
- instrumentação;
- plano de análise;
- decisão pré-definida.

---

# Outputs

Dependendo do contexto:

- A/B test plan;
- experiment design;
- hypothesis;
- experiment specification;
- metric definition;
- instrumentation plan;
- experiment analysis framework;
- rollout strategy;
- decision framework;
- experiment report.

---

# Rule of Thumb

> **Um A/B test não serve para descobrir qual design você prefere. Serve para reduzir uma incerteza importante com evidência.**

E a regra mais importante:

> **Se você não sabe qual decisão o resultado vai informar, ainda não existe um bom experimento.**
