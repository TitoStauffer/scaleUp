---
name: qa-test-case-design
description: Crie casos de teste claros e econômicos a partir de requisitos, critérios de aceite e riscos do sistema. Use para transformar comportamento esperado em cenários manuais ou automatizáveis.
---

# Desenho de casos de teste

Parta do comportamento observável e das regras de negócio. Para cada regra, cubra resultado válido, limites, entradas inválidas, estados anteriores relevantes e efeitos persistidos ou externos. Evite multiplicar casos que exercitam a mesma decisão sem aumentar cobertura de risco.

## Técnicas

Use particionamento de equivalência e valores de fronteira para entradas com domínio definido. Use tabelas de decisão quando várias condições mudarem um resultado, transições de estado quando a sequência importar e pares de interação quando combinações de fatores forem risco real.

Cada caso deve indicar pré-condição, dados, ação, resultado observável e prioridade de risco. Quando houver dependência de dados, descreva como criá-los ou isolá-los sem depender de estado residual de outros testes.

## Qualidade

Mantenha o caso independente de detalhes internos e de um layout frágil. Se não houver resultado esperado decidido, registre uma pergunta de produto; não infira comportamento apenas para concluir o teste. Agrupe cenários relacionados para que falhas indiquem claramente a regra que foi violada.
