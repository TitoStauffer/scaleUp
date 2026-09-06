---
name: devops-cloud-operations
description: Opere recursos em cloud com foco em confiabilidade, segurança, capacidade e custo, sem assumir um provedor específico. Use para decisões e rotinas de operação de workloads em nuvem.
---

# Operações em cloud

Comece por requisitos de serviço: disponibilidade, recuperação, latência, dados, conformidade, volume e orçamento. Escolha serviços gerenciados ou componentes próprios com base no risco operacional e nas capacidades necessárias, não apenas na familiaridade do time.

## Confiabilidade e capacidade

Projete para falhas de zona, dependência e rede proporcionais ao objetivo de disponibilidade. Defina limites de recursos, autoscaling, quotas e degradação controlada antes que a saturação ocorra. Para dados duráveis, confirme backups, restauração e objetivos de recuperação com testes periódicos.

## Segurança e custo

Use identidade de workload e menor privilégio; evite credenciais permanentes em máquinas, repositórios ou variáveis expostas. Restrinja redes e superfícies públicas ao necessário. Acompanhe tags de custo, consumo, anomalias e recursos ociosos, relacionando gasto a serviço ou equipe responsável.

Mudanças em produção precisam de escopo, plano de reversão e evidência pós-alteração. Não execute operações de criação, remoção, alteração de acesso ou custo relevante sem autorização explícita para o ambiente alvo.
