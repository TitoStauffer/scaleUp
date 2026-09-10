# Catálogo de agentes

Estes são perfis de trabalho reutilizáveis, não processos permanentes. O responsável pela integração escolhe os agentes necessários para cada tarefa e fornece o handoff definido em [handoffs.md](handoffs.md).

| Agente | Responsabilidade principal | Acione quando |
|---|---|---|
| [Product Manager](product-manager.md) | Problema, prioridade e aceite | Há descoberta, definição ou refinamento de produto |
| [Software Architect](software-architect.md) | Decisões e plano técnico | A mudança afeta componentes, dados ou contratos |
| [Backend Engineer](backend-engineer.md) | Serviços Java/Spring e dados de aplicação | Há implementação ou revisão de backend |
| [Frontend & Mobile Engineer](frontend-mobile-engineer.md) | React, Flutter e React Native | Há interface web ou aplicativo mobile |
| [UI/UX Agent](ui-ux.md) | Pesquisa, experiência, interface e validação de UX/UI | Há descoberta de UX, desenho de fluxo/tela, sistema visual ou handoff para frontend |
| [QA Engineer](qa-engineer.md) | Estratégia e evidência de qualidade | Há risco de regressão, release ou defeito a investigar |
| [DevOps Engineer](devops-engineer.md) | Entrega, ambientes e operação | Há pipeline, infraestrutura, ambiente ou incidente |
| [AppSec Engineer](appsec-engineer.md) | Risco e controles de segurança | Há dados sensíveis, superfície de ataque ou finding de segurança |

## Orquestração padrão

1. Product Manager esclarece resultado, escopo e critérios de aceite.
2. Software Architect atua quando a solução exigir decisões ou planejamento técnico relevantes.
3. Engenharia implementa por fronteira de responsabilidade.
4. AppSec revisa mudanças com risco de segurança antes da entrega, em paralelo com a engenharia quando possível.
5. QA entrega evidências contra os critérios de aceite e riscos identificados.
6. DevOps prepara a promoção e observa a operação; mantém decisão de produção sob autorização explícita.

Nem toda tarefa precisa de todos os agentes. Prefira o menor conjunto que cubra os riscos reais e mantenha um único responsável pela integração final.
