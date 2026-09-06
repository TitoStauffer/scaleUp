---
name: devops-environment-management
description: Defina e opere ambientes de desenvolvimento, teste, homologação e produção com configuração rastreável, isolamento e paridade adequada. Use para criar, alterar ou diagnosticar ambientes de aplicação.
---

# Gestão de ambientes

Descreva a finalidade, dados permitidos, integrações, nível de disponibilidade e responsáveis de cada ambiente. Busque paridade nos aspectos que podem invalidar uma entrega — configuração, versões, dependências e topologia — sem replicar custos ou dados sensíveis de produção quando isso não for necessário.

## Configuração e dados

Mantenha configuração fora do artefato e rastreie quais valores pertencem a cada ambiente. Use segredos por ambiente com acesso mínimo, rotação possível e auditoria. Não copie dados de produção para ambientes inferiores sem autorização, minimização e proteção adequadas.

## Ciclo de vida

Defina como ambientes são provisionados, atualizados, validados, acessados e removidos. Ambientes efêmeros devem ter limite de vida e limpeza segura; ambientes persistentes precisam de ownership e monitoramento. Documente dependências compartilhadas que possam tornar um teste não isolado.

Quando uma divergência entre ambientes afetar comportamento, identifique a diferença observável e corrija a causa configuracional ou de processo em vez de normalizar um workaround local.
