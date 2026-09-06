---
name: product-acceptance-criteria
description: Defina e revise critérios de aceite observáveis para histórias, tickets ou PRDs. Use para alinhar produto, engenharia e QA sobre quando uma entrega pode ser aceita.
---

# Critérios de aceite

Converta a intenção do produto em exemplos que uma pessoa ou teste automatizado consiga verificar. Cubra o comportamento desejado, as regras que não podem ser violadas e os casos de borda que alteram o resultado para o usuário.

## Forma recomendada

Use cenários em **Dado / Quando / Então** para comportamentos relevantes. Cada cenário deve declarar estado inicial, ação ou evento e resultado observável. Agrupe cenários por regra de negócio, não por componente técnico.

Inclua quando aplicável:

- fluxo principal e resultado de sucesso;
- validações de entrada, permissões e estados inválidos;
- ausência, duplicidade ou concorrência de dados quando mudarem o comportamento;
- mensagens, efeitos persistidos, notificações ou eventos de auditoria necessários;
- requisitos não funcionais que possuam limite ou método de verificação definido.

## Limites

Não descreva detalhes internos de implementação. Não converta cada detalhe visual em critério, a menos que ele seja uma obrigação de acessibilidade, marca ou comportamento. Se o resultado esperado depender de uma regra ainda não decidida, registre a pergunta; não escolha arbitrariamente.

Finalize com uma condição curta de aceite: todos os cenários aplicáveis passam e não há regressão conhecida dentro do escopo definido.
