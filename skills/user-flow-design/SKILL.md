---
name: user-flow-design
description: Define, analisa e otimiza fluxos de usuário para produtos digitais, descrevendo caminhos, decisões, ações, estados, alternativas, erros, recuperações e conclusões necessárias para atingir um objetivo. Use quando for necessário desenhar uma tarefa ponta a ponta, mapear happy paths, tratar edge cases, reduzir fricção ou transformar requisitos e arquitetura em fluxos de experiência.
---

# User Flow Design

## 1. Objetivo

Projetar e analisar os caminhos que um usuário percorre dentro de um produto para alcançar determinado objetivo.

Esta Skill responde:

> "Quais passos o usuário precisa percorrer para realizar uma tarefa com sucesso?"

O foco não é apenas listar telas.

Um User Flow deve representar:

- objetivo;
- ações;
- decisões;
- respostas do sistema;
- estados;
- alternativas;
- erros;
- recuperação;
- conclusão.

---

# 2. Princípios Fundamentais

## 2.1 Projetar a partir do objetivo

Começar pelo objetivo do usuário.

Exemplo:

```text
Objetivo:
Criar uma negociação
```

Depois:

```text
Objetivo
 ↓
Tarefas
 ↓
Ações
 ↓
Decisões
 ↓
Estados
 ↓
Resultado
```

Não começar simplesmente desenhando telas.

---

# 3. Quando Usar

Use esta Skill quando for necessário:

- criar um novo fluxo;
- melhorar um fluxo existente;
- mapear uma tarefa;
- desenhar onboarding;
- desenhar checkout;
- desenhar cadastro;
- desenhar autenticação;
- desenhar recuperação de conta;
- desenhar processos administrativos;
- tratar erros;
- mapear estados;
- identificar pontos de fricção;
- preparar wireframes;
- transformar requisitos em experiência;
- analisar abandono de fluxo.

---

# 4. Quando NÃO Usar

Não utilizar esta Skill quando:

- o problema é puramente visual;
- a tarefa é apenas escolher componentes;
- não existe interação significativa;
- o problema está exclusivamente em arquitetura de informação;
- o objetivo é apenas definir identidade visual.

Nesses casos, utilizar Skills apropriadas.

---

# 5. Entradas

Considerar:

- persona;
- objetivo;
- jornada;
- arquitetura de informação;
- requisitos;
- regras de negócio;
- permissões;
- restrições técnicas;
- integrações;
- estados do sistema;
- métricas;
- problemas existentes.

Quando informações críticas estiverem ausentes, declarar a lacuna.

---

# 6. Definir o Objetivo

Todo fluxo deve possuir um objetivo claro.

Formato:

```text
Usuário:
[persona]

Objetivo:
[o que deseja alcançar]

Contexto:
[situação]

Critério de sucesso:
[quando considera a tarefa concluída]
```

Exemplo:

```text
Usuário:
Operador

Objetivo:
Cadastrar um novo cliente

Contexto:
Cliente está aguardando atendimento

Critério de sucesso:
Cliente criado e disponível para utilização.
```

---

# 7. Definir Início e Fim

Todo fluxo precisa ter limites.

```text
Início:
Onde o usuário entra no fluxo.

Fim:
Qual resultado representa sucesso ou encerramento.
```

Exemplo:

```text
Início:
Página de clientes

Fim:
Cliente criado com sucesso
```

Não expandir o fluxo indefinidamente.

---

# 8. Happy Path

O Happy Path representa o caminho principal em que tudo ocorre conforme esperado.

Exemplo:

```text
Lista de clientes
 ↓
Adicionar cliente
 ↓
Preencher dados
 ↓
Validar
 ↓
Salvar
 ↓
Confirmação
 ↓
Cliente criado
```

O Happy Path deve ser simples e fácil de compreender.

---

# 9. Fluxos Alternativos

Nem todos os usuários percorrem exatamente o mesmo caminho.

Exemplo:

```text
Login
 ↓
Credenciais válidas?
 ├── Sim → Dashboard
 └── Não → Recuperação
```

Alternativas podem surgir por:

- decisões do usuário;
- permissões;
- dados disponíveis;
- preferências;
- regras de negócio;
- contexto.

---

# 10. Decision Points

Identificar pontos onde o fluxo pode mudar.

Representação:

```text
Condição?
├── Sim → Caminho A
└── Não → Caminho B
```

Exemplo:

```text
Possui documento?
├── Sim → Continuar
└── Não → Solicitar documento
```

Cada decisão deve possuir motivo.

Evitar decisões desnecessárias.

---

# 11. Ações do Usuário

Representar ações concretas.

Exemplos:

- clicar;
- selecionar;
- preencher;
- confirmar;
- cancelar;
- voltar;
- pesquisar;
- enviar;
- editar;
- excluir.

Evitar ações abstratas como:

> "Usuário interage com a tela."

---

# 12. Respostas do Sistema

Para cada ação importante, identificar a resposta do sistema.

Exemplo:

```text
Usuário envia formulário
        ↓
Sistema valida
        ↓
Dados válidos?
```

A interface não deve deixar o usuário sem saber o que aconteceu.

---

# 13. Estados

Fluxos devem considerar estados relevantes.

Exemplo:

```text
Idle
 ↓
Loading
 ↓
Success
```

Ou:

```text
Idle
 ↓
Loading
 ↓
Error
 ↓
Retry
 ↓
Success
```

Estados importantes devem aparecer no fluxo antes do wireframe.

---

# 14. Loading

Definir o comportamento quando uma operação demora.

Considerar:

- feedback imediato;
- duração;
- possibilidade de cancelamento;
- prevenção de ações duplicadas;
- atualização de status.

Evitar que o usuário fique sem saber se a ação foi processada.

---

# 15. Success

Definir claramente o resultado de sucesso.

Um sucesso deve responder:

- o que aconteceu;
- se a ação foi concluída;
- qual é o próximo passo;
- onde encontrar o resultado.

Exemplo:

```text
Pedido criado
 ↓
Mostrar confirmação
 ↓
Oferecer:
[Ver pedido]
[Voltar para pedidos]
```

---

# 16. Error

Todo fluxo relevante deve considerar falhas.

Exemplo:

```text
Salvar
 ↓
Erro?
 ├── Não → Sucesso
 └── Sim → Explicar erro
            ↓
         Corrigir
            ↓
         Tentar novamente
```

Evitar:

```text
Erro.
```

sem orientação.

---

# 17. Error Recovery

Um erro deve, quando possível, permitir recuperação.

Perguntar:

```text
O usuário sabe o que aconteceu?

Sabe como corrigir?

Pode tentar novamente?

Perdeu os dados?

Precisa reiniciar o fluxo?

Existe alternativa?
```

---

# 18. Edge Cases

Mapear casos fora do caminho principal.

Exemplos:

- dados inválidos;
- usuário sem permissão;
- recurso inexistente;
- operação duplicada;
- timeout;
- serviço externo indisponível;
- sessão expirada;
- usuário interrompe fluxo;
- usuário volta posteriormente;
- dados parcialmente preenchidos.

Não ignorar edge cases relevantes.

---

# 19. Abandono

Considerar quando o usuário pode sair do fluxo.

Exemplo:

```text
Formulário
 ↓
Usuário abandona
 ↓
Dados devem ser preservados?
```

Avaliar:

- salvar automaticamente;
- confirmar saída;
- permitir retomada;
- descartar dados;
- registrar abandono.

A decisão depende do custo de perder o progresso.

---

# 20. Retorno ao Fluxo

Usuários frequentemente interrompem tarefas.

Considerar:

```text
Usuário inicia
 ↓
Interrompe
 ↓
Sai
 ↓
Retorna
 ↓
Continua?
```

Definir:

- estado preservado;
- ponto de retorno;
- contexto;
- mensagens;
- validade dos dados.

---

# 21. Fluxos Multi-Step

Para processos complexos:

```text
Etapa 1
 ↓
Etapa 2
 ↓
Etapa 3
 ↓
Confirmação
```

Cada etapa deve possuir:

- objetivo;
- entradas;
- validações;
- saída;
- possibilidade de voltar;
- possibilidade de avançar.

---

# 22. Progressive Disclosure

Não apresentar todas as informações de uma vez quando isso gerar sobrecarga.

Fluxo:

```text
Informação essencial
 ↓
Decisão
 ↓
Detalhes quando necessários
```

Utilizar quando a complexidade puder ser reduzida progressivamente.

---

# 23. Minimizar Passos

Não buscar simplesmente o menor número de telas.

O objetivo é minimizar:

> esforço desnecessário.

Uma etapa adicional pode ser válida se reduzir:

- erro;
- confusão;
- carga cognitiva;
- retrabalho;
- risco.

---

# 24. Minimizar Decisões

Cada decisão exige esforço cognitivo.

Perguntar:

```text
Essa decisão é necessária?

O usuário possui informação suficiente?

Podemos eliminar a decisão?

Podemos utilizar um padrão seguro?

Podemos recomendar uma opção?
```

---

# 25. Defaults

Utilizar valores padrão quando:

- forem seguros;
- forem previsíveis;
- forem reversíveis;
- representarem o caso mais comum.

Evitar defaults perigosos ou irreversíveis.

---

# 26. Autocomplete e Sugestões

Quando apropriado, utilizar:

- autocomplete;
- sugestões;
- valores recentes;
- histórico;
- recomendações;
- preenchimento automático.

Objetivo:

> reduzir esforço sem remover controle.

---

# 27. Validação

Preferir validação próxima da ação que pode gerar erro.

Exemplo:

```text
Campo inválido
 ↓
Mensagem contextual
 ↓
Correção
```

Evitar descobrir todos os erros somente após o envio quando for possível validar antes.

---

# 28. Inline Validation

Quando apropriado:

```text
Email
[usuario@email]
✓ Email válido
```

Ou:

```text
CPF
[123...]
⚠ CPF inválido
```

Mensagens devem indicar:

- problema;
- causa quando relevante;
- como corrigir.

---

# 29. Confirmações

Confirmações devem ser usadas quando o custo de erro for significativo.

Exemplo:

```text
Excluir cliente?
```

Perguntar:

- ação é destrutiva?
- reversão existe?
- consequência é importante?

Evitar confirmação para toda ação simples.

---

# 30. Undo

Quando possível, preferir ações reversíveis.

Exemplo:

```text
Cliente arquivado.

[Desfazer]
```

Pode ser melhor que:

```text
Tem certeza?
```

antes de toda ação.

---

# 31. Ações Destrutivas

Para ações destrutivas:

- explicar consequência;
- diferenciar visualmente;
- evitar confirmação ambígua;
- exigir confirmação quando necessário;
- preferir recuperação quando possível.

Exemplo:

```text
Excluir pedido

Esta ação removerá o pedido permanentemente.

[Cancelar] [Excluir pedido]
```

---

# 32. Permissões

O fluxo pode variar conforme permissões.

Exemplo:

```text
Usuário acessa pedido
 ↓
Pode editar?
 ├── Sim → Editar
 └── Não → Visualizar
```

Não assumir que todos os usuários possuem as mesmas capacidades.

---

# 33. Autenticação e Sessão

Considerar:

- sessão expirada;
- login necessário;
- MFA;
- recuperação;
- troca de conta;
- logout;
- permissões.

Exemplo:

```text
Usuário executa ação
 ↓
Sessão válida?
 ├── Sim → Continuar
 └── Não → Autenticar
             ↓
          Retornar ao fluxo
```

Sempre que possível, preservar a intenção original.

---

# 34. Integrações Externas

Quando o fluxo depender de serviços externos:

```text
Sistema
 ↓
Integração
 ↓
Resposta
```

Considerar:

- sucesso;
- erro;
- timeout;
- indisponibilidade;
- retry;
- duplicidade;
- processamento assíncrono.

Exemplo:

```text
Enviar pagamento
 ↓
Processador externo
 ├── Aprovado → Sucesso
 ├── Recusado → Informar resultado
 ├── Timeout → Processando
 └── Indisponível → Tentar novamente
```

---

# 35. Processamento Assíncrono

Quando a operação não for imediata, não fingir que é síncrona.

Exemplo:

```text
Enviar arquivo
 ↓
Recebido
 ↓
Processando
 ↓
Concluído
```

A interface deve representar o estado real.

---

# 36. Idempotência e Ações Duplicadas

Quando uma ação puder gerar efeitos duplicados:

```text
Usuário clica duas vezes
        ↓
Sistema deve evitar duplicidade
```

O fluxo deve considerar:

- botão desabilitado;
- estado de processamento;
- identificador da operação;
- feedback;
- recuperação.

Essa decisão deve ser alinhada com Engenharia.

---

# 37. Mobile

Fluxos mobile devem considerar:

- espaço limitado;
- teclado;
- toque;
- orientação;
- conectividade;
- interrupções;
- navegação;
- ações críticas.

Não assumir que o fluxo desktop pode simplesmente ser reduzido.

---

# 38. Acessibilidade

Considerar:

- navegação por teclado;
- foco;
- ordem de interação;
- leitores de tela;
- mensagens de erro;
- estados;
- alternativas para interações complexas.

Um fluxo visualmente simples pode ser difícil para usuários de tecnologias assistivas.

---

# 39. Fluxos e Jornada

User Journey responde:

> "Qual é a experiência completa do usuário?"

User Flow responde:

> "Como o usuário executa uma tarefa dentro dessa experiência?"

Relacionamento:

```text
User Journey
     ↓
Objetivo
     ↓
User Flow
     ↓
Wireframe
     ↓
Interaction Design
```

---

# 40. Fluxos e Information Architecture

Information Architecture define:

> onde as coisas estão.

User Flow define:

> como o usuário passa por elas.

Exemplo:

```text
IA:
Clientes
 └── Novo Cliente

Flow:
Clientes
 ↓
Novo Cliente
 ↓
Preencher
 ↓
Salvar
 ↓
Sucesso
```

---

# 41. Fluxos e Business Rules

Regras de negócio podem alterar o fluxo.

Exemplo:

```text
Valor > limite?
├── Não → Continuar
└── Sim → Solicitar aprovação
```

Não criar fluxo de UX ignorando regras do domínio.

---

# 42. Fluxos e Product Manager

Product Manager fornece:

- objetivo;
- requisito;
- regras;
- prioridade;
- critérios de sucesso.

UX transforma isso em:

- fluxo;
- decisões;
- estados;
- alternativas;
- experiência.

Fluxo:

```text
Requirement
 ↓
User Goal
 ↓
User Flow
 ↓
Wireframe
 ↓
UI
```

---

# 43. Fluxos e Engenharia

O User Flow deve ser validado com Engenharia quando depender de:

- APIs;
- processamento assíncrono;
- permissões;
- integrações;
- estados persistentes;
- limitações técnicas;
- regras complexas.

Não assumir comportamento técnico sem evidência.

---

# 44. Representação do Fluxo

Usar representações simples.

Exemplo:

```text
[Dashboard]
      |
      v
[Clientes]
      |
      v
[Novo Cliente]
      |
      v
[Preencher dados]
      |
      v
[Validar]
      |
      +------ Inválido ------> [Corrigir]
      |
     Válido
      |
      v
[Salvar]
      |
      v
   Sucesso?
    /    \
  Sim     Não
  |        |
  v        v
[Sucesso] [Erro]
             |
             v
          [Retry]
```

---

# 45. Tabela de Fluxo

Quando um diagrama visual não for necessário:

```markdown
| Etapa | Ação do usuário | Sistema | Decisão | Próximo estado |
|---|---|---|---|---|
| 1 | Acessa clientes | Exibe lista | — | Lista |
| 2 | Clica em novo | Exibe formulário | — | Formulário |
| 3 | Preenche dados | Valida | Dados válidos? | Validação |
| 4 | Envia | Processa | Sucesso? | Resultado |
```

---

# 46. Catálogo de Estados

Para fluxos complexos, documentar estados separadamente.

```markdown
| Estado | Condição | Interface | Ações disponíveis |
|---|---|---|---|
| Idle | Nenhuma operação | Normal | Executar |
| Loading | Processamento | Feedback | Cancelar |
| Success | Operação concluída | Confirmação | Continuar |
| Error | Falha | Mensagem | Corrigir/Retry |
```

---

# 47. Critérios de Sucesso

Todo fluxo deve definir:

```text
Resultado esperado
+
Estado final
+
Feedback ao usuário
```

Exemplo:

```text
Resultado:
Cliente criado

Estado:
Persistido e disponível na lista

Feedback:
"Cliente criado com sucesso."
```

---

# 48. Métricas

Quando disponíveis, associar métricas ao fluxo.

Exemplos:

- completion rate;
- conversion rate;
- abandonment rate;
- time on task;
- error rate;
- retry rate;
- task success rate.

Exemplo:

```text
Cadastro
↓
Conclusão: 78%
Abandono: 22%
Tempo médio: 2m14s
```

---

# 49. Identificar Fricção

Após desenhar o fluxo, procurar:

- passos desnecessários;
- decisões desnecessárias;
- repetição de informações;
- esperas;
- erros;
- ambiguidades;
- mudanças de contexto;
- dependências externas;
- ações destrutivas;
- falta de feedback.

---

# 50. Priorização de Problemas

Quando houver vários problemas:

```text
Impacto
+
Frequência
+
Severidade
+
Esforço
```

Priorizar problemas que afetam significativamente o sucesso do usuário.

---

# 51. Comparar Fluxos

Quando houver alternativas:

```text
Fluxo A
↓
3 etapas
↓
Maior carga cognitiva

Fluxo B
↓
4 etapas
↓
Menor risco de erro
```

Não escolher automaticamente o fluxo com menos etapas.

Avaliar esforço total.

---

# 52. Formato de Saída

Quando solicitado a criar um User Flow:

```markdown
# User Flow

## Persona

[persona]

## Objetivo

[objetivo]

## Contexto

[contexto]

## Início

[início]

## Critério de Sucesso

[resultado]

---

## Happy Path

​```text
[fluxo]
​```

---

## Fluxos Alternativos

### Alternativa 1

[fluxo]

### Alternativa 2

[fluxo]

---

## Decision Points

| Decisão | Condição | Caminho A | Caminho B |
|---|---|---|---|
| [decisão] | [condição] | [resultado] | [resultado] |

---

## Estados

| Estado | Condição | Feedback | Ações |
|---|---|---|---|
| Idle | [condição] | [feedback] | [ações] |
| Loading | [condição] | [feedback] | [ações] |
| Success | [condição] | [feedback] | [ações] |
| Error | [condição] | [feedback] | [ações] |

---

## Edge Cases

- [caso]

---

## Error Recovery

- [estratégia]

---

## Abandono e Retorno

- [comportamento]

---

## Dependências

- [dependência]

---

## Pain Points

- [problema]

---

## Oportunidades

- [oportunidade]

---

## Métricas

- [métrica]

---

## Riscos

- [risco]

---

## Questões em Aberto

- [questão]

---

## Próximos Passos

- [ação]
```

---

# 53. Critérios de Qualidade

Um bom User Flow deve:

- possuir objetivo claro;
- possuir início e fim;
- representar o caminho principal;
- representar decisões importantes;
- considerar estados;
- considerar erros;
- considerar recuperação;
- considerar edge cases;
- considerar abandono;
- considerar permissões;
- considerar integrações;
- considerar processamento assíncrono quando necessário;
- minimizar esforço desnecessário;
- fornecer feedback;
- ser compreensível por Product, Design e Engineering;
- poder ser transformado em wireframes.

---

# 54. Anti-Patterns

Evitar:

### Screen Flow

Descrever somente telas sem representar ações e decisões.

### Happy Path Only

Ignorar erros e caminhos alternativos.

### Minimum Screens Obsession

Reduzir telas independentemente do esforço cognitivo.

### Dead Ends

Criar estados onde o usuário não sabe como continuar.

### No Feedback

Usuário executa ação sem saber o resultado.

### Error Without Recovery

Mostrar erro sem permitir correção ou retry.

### Hidden State

Não representar loading, processing ou outros estados importantes.

### Business Flow Only

Representar somente o processo interno da empresa.

### Technical Flow Only

Transformar detalhes de backend em experiência do usuário.

### Overengineering

Criar dezenas de decisões e caminhos desnecessários.

### Irreversible By Default

Tornar ações destrutivas sem possibilidade de recuperação.

---

# 55. Regra de Ouro

> **Um bom User Flow não minimiza necessariamente o número de passos. Ele minimiza o esforço, a incerteza e os erros necessários para que o usuário alcance seu objetivo.**

Comece pelo objetivo.

Modele o caminho principal.

Adicione decisões relevantes.

Modele estados e falhas.

Garanta recuperação.

E só depois transforme o fluxo em telas e componentes.
