---
name: qa-performance-testing
description: Planeje, execute ou avalie testes de desempenho com carga representativa, métricas interpretáveis e limites operacionais seguros. Use para fluxos críticos, mudanças de capacidade ou investigação de latência e saturação.
---

# Testes de desempenho

Defina o objetivo antes de gerar carga: capacidade, latência, estabilidade, escalabilidade ou detecção de regressão. Escolha jornadas e distribuição de uso representativas, incluindo leituras, escritas, picos e dependências relevantes. Não trate uma taxa arbitrária de requisições como prova de desempenho.

## Execução segura

Use ambiente e dados autorizados, com limites de taxa, tempo e custo. Instrumente cliente e servidor para separar latência, erros, saturação e gargalos de dependência. Registre configuração, versão, volume de dados, perfil de carga e condições de infraestrutura para que o resultado seja comparável.

Inclua aquecimento quando necessário e observe percentis, taxa de erro, uso de recursos, filas e recuperação após o pico; médias isoladas ocultam degradação importante. Pare o teste quando houver risco de dano a ambiente compartilhado ou custo fora do combinado.

## Conclusão

Compare o resultado ao objetivo declarado e explique limitações do experimento. Apresente gargalos com evidência, não como certeza baseada em um único indicador, e recomende a próxima medição ou mudança de menor risco.
