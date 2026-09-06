---
name: devops-observability
description: Projete ou revise observabilidade de sistemas com sinais acionáveis, objetivos de serviço e diagnósticos que preservem privacidade. Use para métricas, logs, tracing, dashboards, alertas e SLOs.
---

# Observabilidade

Meça a experiência e a confiabilidade do serviço antes de medir detalhes internos. Defina indicadores de serviço, objetivo e janela de avaliação quando houver compromisso operacional; não crie alertas para toda métrica disponível.

## Sinais

Use métricas para tendências e alertas, logs estruturados para contexto e traces para fluxos distribuídos. Propague correlação entre entrada, serviços e dependências de forma consistente. Preserve cardinalidade e retenção controladas para evitar custo e degradação da própria telemetria.

Não registre segredos, tokens, conteúdo sensível ou dados pessoais além do necessário. Aplique mascaramento e controle de acesso, mas também reduza a coleta na origem.

## Alertas e operação

Acione alertas quando houver impacto ou risco de impacto que demande ação humana. Cada alerta deve indicar condição, severidade, serviço, dono, runbook ou próximo passo e forma de silenciar ou encerrar após normalização. Teste dashboards e alertas em incidentes simulados ou mudanças relevantes; um alerta que ninguém consegue investigar é ruído, não cobertura.
