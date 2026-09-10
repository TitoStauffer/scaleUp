---
name: user-personas
description: Cria, estrutura, valida e mantém personas de UX baseadas em evidências sobre usuários, comportamentos, objetivos, necessidades, dores, motivações e contexto de uso. Use quando for necessário representar segmentos relevantes de usuários para orientar decisões de produto, UX, fluxos, conteúdo ou interface.
---

# User Personas

## 1. Objetivo

Transformar conhecimento sobre usuários em representações claras e acionáveis dos principais perfis comportamentais relevantes para o produto.

Uma persona deve ajudar a equipe a responder:

> "Para quem estamos projetando e quais necessidades desse usuário precisam orientar nossas decisões?"

A persona não deve ser tratada como um personagem fictício criado para decorar uma documentação.

Ela é uma **síntese de padrões reais de usuários**.

---

# 2. Princípios Fundamentais

## 2.1 Personas devem representar padrões

Não criar personas simplesmente porque existem usuários diferentes.

Criar personas quando existirem diferenças relevantes em:

- objetivos;
- comportamentos;
- necessidades;
- contexto;
- motivações;
- dores;
- formas de utilização do produto.

Diferenças puramente demográficas não justificam automaticamente personas diferentes.

---

## 2.2 Comportamento é mais importante que demografia

Priorizar:

- objetivos;
- comportamento;
- necessidades;
- contexto;
- motivações;
- dificuldades;
- frequência de uso;
- experiência com o produto.

Evitar criar personas baseadas principalmente em:

- idade;
- gênero;
- localização;
- profissão;
- renda;
- estado civil.

Esses atributos só devem aparecer quando forem relevantes para o comportamento ou problema investigado.

---

## 2.3 Persona não é usuário médio

Uma persona não representa necessariamente a média de todos os usuários.

Ela representa um padrão significativo.

Exemplo:

```text
Usuários:
1000

Perfil A:
600 usuários

Perfil B:
300 usuários

Perfil C:
100 usuários
```

O Perfil C pode continuar sendo importante se possuir necessidades críticas ou representar uma oportunidade estratégica.

---

# 3. Quando Usar

Use esta Skill quando for necessário:

- definir perfis de usuários;
- segmentar usuários;
- sintetizar pesquisas;
- orientar decisões de UX;
- orientar arquitetura de informação;
- definir fluxos;
- entender diferentes necessidades;
- alinhar Product, Design e Engineering;
- comunicar para quem determinada funcionalidade está sendo construída;
- identificar conflitos entre diferentes tipos de usuários.

---

# 4. Quando NÃO Usar

Não criar personas quando:

- não existem evidências suficientes;
- a segmentação ainda é desconhecida;
- as diferenças entre usuários são irrelevantes;
- uma única jornada atende praticamente todos os usuários;
- a persona seria apenas uma descrição demográfica;
- a persona está sendo criada apenas para preencher documentação.

Quando houver pouca evidência, declarar explicitamente:

```text
Persona provisória
```

em vez de apresentar hipóteses como fatos.

---

# 5. Fontes de Evidência

As personas podem utilizar informações provenientes de:

- UX Research;
- entrevistas;
- testes de usabilidade;
- analytics;
- pesquisas quantitativas;
- tickets de suporte;
- reviews;
- feedback;
- CRM;
- dados de comportamento;
- observação;
- pesquisas de mercado;
- documentação existente;
- Product Manager;
- stakeholders.

Priorizar fontes primárias e evidências comportamentais.

---

# 6. Evidência x Hipótese

Toda característica relevante da persona deve possuir origem conhecida.

Classificar informações como:

### Evidência

Suportada por dados ou observações.

### Inferência

Conclusão razoável derivada de evidências.

### Hipótese

Suposição ainda não validada.

Exemplo:

```text
Objetivo:
Emitir notas fiscais rapidamente.

Status:
Evidência

Fonte:
Entrevistas + analytics
```

Outro exemplo:

```text
Motivação:
Evitar erros porque teme problemas fiscais.

Status:
Hipótese

Necessário:
Validar com pesquisa.
```

---

# 7. Identificação de Segmentos

Ao analisar usuários, procurar diferenças comportamentais.

Exemplos:

```text
Segmento A
Usuários ocasionais

Segmento B
Usuários frequentes

Segmento C
Usuários administradores
```

Ou:

```text
Segmento A
Busca velocidade

Segmento B
Busca controle

Segmento C
Busca orientação
```

Preferir segmentações baseadas em comportamento e necessidade.

---

# 8. Agrupamento de Usuários

Utilizar o seguinte processo:

```text
Dados
 ↓
Observações
 ↓
Comportamentos
 ↓
Padrões
 ↓
Agrupamentos
 ↓
Segmentos
 ↓
Personas
```

Não começar pelo nome da persona.

Primeiro descobrir o padrão.

---

# 9. Estrutura de uma Persona

Uma persona pode conter:

```text
Identificação
Objetivo principal
Contexto
Comportamentos
Necessidades
Dores
Motivações
Frustrações
Expectativas
Nível de experiência
Frequência de uso
Tarefas principais
Critérios de sucesso
Barreiras
Alternativas utilizadas
Implicações para UX
```

Nem todos os campos precisam existir sempre.

Usar somente informações relevantes para a tomada de decisão.

---

# 10. Nome da Persona

O nome deve facilitar a comunicação interna.

Exemplos:

```text
Operador Eficiente
Gestor Analítico
Usuário Iniciante
Administrador de Operações
```

Evitar nomes excessivamente caricatos.

O nome deve representar o comportamento ou contexto, não criar um personagem fictício.

---

# 11. Objetivos

Identificar o que a persona está tentando alcançar.

Diferenciar:

### Objetivo final

Resultado que o usuário deseja alcançar.

### Objetivo operacional

Ação que precisa executar.

Exemplo:

```text
Objetivo final:
Garantir que o pagamento seja processado corretamente.

Objetivo operacional:
Cadastrar e validar os dados bancários.
```

Priorizar objetivos reais e relevantes.

---

# 12. Necessidades

Registrar o que o usuário precisa para atingir seus objetivos.

Exemplos:

- feedback claro;
- velocidade;
- controle;
- orientação;
- confirmação;
- previsibilidade;
- automação;
- segurança;
- flexibilidade.

Não transformar automaticamente uma necessidade em solução.

Exemplo:

```text
Necessidade:
Ter confiança de que a operação foi concluída.

Não assumir:
Adicionar um modal verde de sucesso.
```

A necessidade deve permanecer independente da solução.

---

# 13. Dores

Registrar dificuldades reais.

Exemplos:

- não entende determinado conceito;
- não encontra determinada funcionalidade;
- precisa repetir informações;
- recebe feedback insuficiente;
- teme cometer erros;
- processo demora;
- não sabe qual ação executar;
- precisa utilizar ferramentas externas.

Priorizar dores que tenham impacto significativo.

---

# 14. Motivações

Identificar por que o usuário deseja alcançar determinado objetivo.

Exemplos:

```text
Objetivo:
Concluir operação rapidamente.

Motivação:
Reduzir tempo operacional.

Objetivo:
Validar informação antes de prosseguir.

Motivação:
Evitar prejuízo ou erro.
```

Não inventar motivações psicológicas sem evidência.

---

# 15. Comportamentos

Descrever o que o usuário realmente faz.

Exemplos:

- consulta documentação;
- utiliza atalhos;
- repete determinada operação;
- exporta dados;
- utiliza planilhas;
- pede ajuda ao suporte;
- utiliza funcionalidades específicas;
- abandona determinados fluxos;
- realiza determinada tarefa fora do produto.

Preferir verbos observáveis.

---

# 16. Contexto de Uso

Registrar as condições em que a persona utiliza o produto.

Considerar:

- ambiente;
- dispositivo;
- frequência;
- pressão de tempo;
- experiência técnica;
- interrupções;
- quantidade de informação;
- responsabilidades;
- dependências;
- necessidade de colaboração.

Exemplo:

```text
Contexto:

Utiliza o sistema durante o horário comercial,
frequentemente com pressão de tempo,
em desktop e com múltiplas tarefas simultâneas.
```

---

# 17. Nível de Experiência

Quando relevante, classificar:

- iniciante;
- intermediário;
- avançado;
- especialista.

Não confundir experiência técnica com experiência no produto.

Um usuário pode ser:

```text
Especialista no domínio
+
Iniciante no produto
```

Essa distinção pode ser extremamente importante para UX.

---

# 18. Tarefas Principais

Identificar as tarefas que a persona executa com maior frequência ou importância.

Exemplo:

```text
Principais tarefas:

1. Criar pedido
2. Consultar pedido
3. Alterar pedido
4. Acompanhar status
5. Exportar informações
```

Classificar quando necessário:

```text
Alta frequência
Alta importância

Baixa frequência
Alta importância
```

---

# 19. Critérios de Sucesso

Definir como a persona entende que conseguiu realizar seu objetivo.

Exemplo:

```text
Critérios de sucesso:

- operação concluída;
- confirmação clara;
- nenhuma informação perdida;
- resultado disponível imediatamente;
- ausência de erro inesperado.
```

Isso é particularmente útil para decisões de UX.

---

# 20. Barreiras

Identificar o que impede ou dificulta o sucesso.

Categorias possíveis:

### Cognitiva

Usuário não entende o conceito.

### Informacional

Usuário não encontra a informação.

### Operacional

Processo exige esforço excessivo.

### Técnica

Sistema ou dispositivo dificulta a tarefa.

### Emocional

Usuário sente insegurança ou falta de confiança.

### Organizacional

Existem dependências externas ou regras internas.

---

# 21. Persona Primária

Quando houver múltiplas personas, identificar a principal.

A persona primária representa o usuário cujo sucesso deve orientar prioritariamente determinada experiência.

Exemplo:

```text
Persona Primária:
Operador Eficiente

Personas Secundárias:
Gestor Analítico
Administrador
```

Não significa ignorar personas secundárias.

Significa estabelecer prioridade quando existirem conflitos.

---

# 22. Personas Secundárias

Personas secundárias podem:

- possuir necessidades específicas;
- utilizar funcionalidades diferentes;
- interagir com o mesmo fluxo;
- influenciar decisões;
- compartilhar partes da experiência.

Não criar personas secundárias apenas para aumentar a quantidade de personas.

---

# 23. Anti-Personas

Quando necessário, definir perfis que **não são o público-alvo principal**.

Exemplo:

```text
Anti-persona:
Usuário que busca utilizar o sistema para uma finalidade
fora do escopo do produto.
```

Anti-personas podem ajudar a evitar decisões que desviem o produto de seu objetivo.

Usar somente quando houver valor estratégico.

---

# 24. Persona Primária x Job to Be Done

Personas e Jobs to Be Done não são necessariamente concorrentes.

Uma persona responde:

> "Quem é o usuário?"

Job to Be Done responde:

> "Qual progresso esse usuário está tentando realizar?"

Podem ser utilizados juntos:

```text
Persona
   ↓
Contexto
   ↓
Job
   ↓
Necessidades
   ↓
Experiência
```

---

# 25. Conflitos Entre Personas

Quando personas possuem necessidades diferentes, não esconder o conflito.

Exemplo:

```text
Persona A:
Busca velocidade.

Persona B:
Busca controle e confirmação detalhada.
```

Possível implicação:

```text
A interface precisa permitir execução rápida
sem remover mecanismos de confirmação para usuários
que necessitam de maior controle.
```

Não escolher arbitrariamente uma persona sem considerar impacto.

---

# 26. Personas e Decisões de UX

Uma persona deve influenciar decisões concretas.

Exemplo:

```text
Persona:
Usuário Iniciante

Necessidade:
Orientação durante tarefas complexas.

Implicação UX:
Fornecer orientação contextual e feedback progressivo.
```

Se uma característica da persona não influencia nenhuma decisão, avaliar se ela realmente precisa existir.

---

# 27. Personas e Product Management

O Product Manager define:

- problema;
- oportunidade;
- objetivo de negócio;
- resultado esperado.

UX Research descobre:

- evidências;
- comportamentos;
- necessidades;
- dores.

Personas sintetizam:

- padrões de usuários;
- objetivos;
- contexto;
- necessidades.

Fluxo:

```text
Product Manager
      ↓
Problema
      ↓
UX Research
      ↓
Evidências
      ↓
Personas
      ↓
UX Design
```

---

# 28. Personas e User Journey

Personas podem servir como entrada para jornadas.

Fluxo:

```text
Persona
  ↓
Objetivo
  ↓
Contexto
  ↓
Jornada
  ↓
Touchpoints
  ↓
Dores
  ↓
Oportunidades
```

Uma mesma jornada pode ser diferente para personas diferentes.

---

# 29. Validação da Persona

Uma persona deve ser revisada quando:

- novas pesquisas surgirem;
- comportamento mudar;
- produto mudar significativamente;
- novo segmento surgir;
- evidências contradizerem a persona;
- decisões baseadas na persona começarem a falhar.

Nunca tratar uma persona como documento permanente.

---

# 30. Nível de Confiança

Classificar cada persona:

### Alta confiança

Baseada em múltiplas fontes e padrões consistentes.

### Média confiança

Existem evidências relevantes, mas ainda existem lacunas.

### Baixa confiança

Baseada principalmente em hipóteses ou dados limitados.

Exemplo:

```text
Persona:
Operador Eficiente

Confiança:
Alta

Evidências:
- 12 entrevistas
- analytics
- tickets de suporte
- testes de usabilidade
```

---

# 31. Evitar Falsa Precisão

Não inventar:

- idade exata;
- salário;
- cidade;
- hábitos;
- personalidade;
- preferências;
- objetivos;
- motivações.

Quando a informação não for conhecida:

```text
Desconhecido
```

Quando for uma hipótese:

```text
Hipótese
```

Não preencher lacunas apenas para deixar a persona mais "completa".

---

# 32. Atualização de Personas

Manter histórico quando necessário.

Exemplo:

```text
Persona v1
↓
Nova pesquisa
↓
Evidências adicionais
↓
Persona v2
```

Registrar:

- o que mudou;
- por que mudou;
- quais evidências justificaram a mudança.

---

# 33. Formato de Saída

Quando solicitado a criar uma persona, utilizar preferencialmente:

```markdown
# Persona: [Nome]

## Resumo

[descrição curta]

## Status

- Tipo: Primária/Secundária/Provisória
- Confiança: Alta/Média/Baixa

## Objetivo Principal

[objetivo]

## Contexto

[contexto]

## Comportamentos

- [comportamento]
- [comportamento]

## Necessidades

- [necessidade]
- [necessidade]

## Dores

- [dor]
- [dor]

## Motivações

- [motivação]

## Tarefas Principais

1. [tarefa]
2. [tarefa]
3. [tarefa]

## Critérios de Sucesso

- [critério]

## Barreiras

- [barreira]

## Alternativas Atualmente Utilizadas

- [alternativa]

## Implicações para UX

- [implicação]
- [implicação]

## Evidências

- [evidência]

## Hipóteses

- [hipótese]

## Lacunas de Conhecimento

- [lacuna]

## Próximos Passos

- [ação]
```

---

# 34. Critérios de Qualidade

Uma boa persona deve:

- representar um padrão real;
- ser baseada em evidências;
- possuir objetivos claros;
- possuir contexto relevante;
- descrever comportamentos observáveis;
- identificar necessidades;
- identificar dores;
- identificar motivações quando houver evidência;
- possuir nível de confiança;
- separar fatos de hipóteses;
- influenciar decisões;
- ser suficientemente simples para ser utilizada pela equipe;
- ser atualizável.

---

# 35. Anti-Patterns

Evitar:

### Persona Inventada

Criar um personagem sem evidências.

### Demographic Persona

Basear a persona quase exclusivamente em idade, gênero, profissão ou localização.

### Persona Perfeita

Adicionar detalhes fictícios para torná-la mais humana.

### Persona Sem Uso

Criar uma persona que não influencia nenhuma decisão.

### Persona Estática

Nunca atualizar a persona quando surgem novas evidências.

### Persona Universal

Criar uma única persona para representar todos os usuários sem investigar diferenças.

### Persona Como Marketing

Transformar a persona em um perfil promocional em vez de uma ferramenta de decisão.

### Confundir Persona com Cliente

O comprador do produto pode não ser a pessoa que utiliza o produto.

### Confundir Persona com Stakeholder

Stakeholder interno não é automaticamente usuário.

---

# 36. Regra de Ouro

> **Uma persona não deve responder "quem seria um usuário interessante?". Ela deve representar "quem é um padrão relevante de usuário que conseguimos sustentar com evidências?".**

Personas existem para melhorar decisões.

Se a persona não muda nenhuma decisão de produto ou UX, questionar se ela precisa existir.
