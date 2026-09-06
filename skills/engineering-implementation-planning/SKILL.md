---
name: engineering-implementation-planning
description: Produza um plano técnico executável para uma mudança de software, usando o repositório e requisitos reais. Use antes de implementações não triviais, integrações, migrações ou alterações entre múltiplos componentes.
---

# Planejamento de implementação

Entenda o comportamento atual percorrendo os pontos de entrada, contratos, persistência e testes relevantes. Diferencie fatos observados no código de suposições. Não proponha modificar arquivos sem explicar sua responsabilidade no fluxo.

## Plano

Organize o trabalho em passos na ordem de dependência, indicando para cada um: componente ou arquivo afetado, mudança de comportamento, contrato alterado e verificação correspondente. Inclua configurações, migrações, documentação ou telemetria quando fizerem parte da entrega.

Trate alterações de API, evento, banco de dados ou configuração como mudanças de contrato. Avalie consumidores, compatibilidade, dados existentes, sequência de deploy e estratégia de reversão antes de declarar o plano seguro.

## Critério de qualidade

Relacione cada requisito e critério de aceite a uma evidência: teste automatizado, validação de integração, inspeção manual, métrica ou migração verificada. Aponte decisões e riscos que não podem ser resolvidos apenas pelo código. O plano deve ser específico o bastante para execução, sem antecipar detalhes de implementação ainda sem impacto na decisão.
