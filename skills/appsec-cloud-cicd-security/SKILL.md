---
name: appsec-cloud-cicd-security
description: Revise controles de segurança em cloud, infraestrutura como código e pipelines de entrega, com foco em identidade, segredos, rede e mudanças rastreáveis. Use para hardening ou revisão de ambientes e automações autorizadas.
---

# Segurança de cloud e CI/CD

Mapeie identidades humanas, workloads, pipelines e contas de serviço junto dos privilégios que recebem. Prefira identidade de curta duração e menor privilégio; não trate uma credencial guardada como variável secreta como controle suficiente por si só.

## Controles

Revise acesso público, segmentação de rede, políticas de identidade, criptografia aplicável, auditoria, retenção de logs e postura de recursos críticos. Em infraestrutura como código, avalie o plano antes da aplicação para detectar aumento de privilégio, exposição de serviço, exclusão ou mudança de recursos duráveis.

Pipelines devem separar contextos de confiança: código não confiável não pode obter credenciais de publicação ou produção. Proteja gatilhos, aprovações, runners, artefatos e caches contra uso indevido. Não exponha tokens em mensagens, relatórios ou artefatos de teste.

## Resultado

Relate recurso ou fluxo afetado, configuração observada, risco, evidência mínima, prioridade e correção. Mudanças de permissão, rede ou produção exigem autorização explícita e plano de reversão antes de execução.
