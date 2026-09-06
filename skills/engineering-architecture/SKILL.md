---
name: engineering-architecture
description: Proponha, avalie ou registre arquitetura de software para mudanças relevantes, explicitando trade-offs, fronteiras e riscos operacionais. Use antes de implementar alterações que afetem componentes, dados, integrações ou atributos de qualidade.
---

# Arquitetura de software

Parta dos requisitos de produto e dos atributos de qualidade que realmente importam para a mudança. Inspecione o sistema existente antes de propor novas camadas, serviços ou dependências; uma solução menor que preserve convenções já consolidadas é preferível quando atende ao problema.

## Proposta arquitetural

Descreva o fluxo principal de dados e controle, responsabilidades de cada componente, interfaces ou contratos e os limites de confiança. Declare impactos em disponibilidade, latência, consistência, segurança, custo, manutenção e observabilidade apenas quando forem pertinentes.

Para decisões que sejam difíceis de reverter, compare alternativas viáveis. Registre decisão, contexto, consequências e gatilhos que justificariam revisá-la. Não trate preferência tecnológica como requisito sem evidência ou decisão do responsável técnico.

## Mudança segura

Planeje compatibilidade entre versões, migrações de dados, falhas parciais, reprocessamento e rollback quando houver mudanças em contratos ou persistência. Defina como o comportamento será observado em produção e quais riscos exigem experimento, feature flag ou entrega gradual.

Peça decisão quando houver trade-off material entre prazo, custo, risco ou escopo. A arquitetura deve deixar claro o que está decidido, o que é hipótese e o que permanece aberto.
