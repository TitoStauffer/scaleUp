---
name: engineering-spring
description: Desenvolva ou revise aplicações Spring e Spring Boot com fronteiras HTTP claras, configuração segura, transações corretas e operação observável. Use para serviços, APIs ou aplicações que utilizem o ecossistema Spring.
---

# Engenharia Spring

Organize componentes pela responsabilidade de negócio e use injeção de dependência para tornar dependências explícitas e testáveis. Evite lógica de negócio em controllers, entidades de persistência expostas diretamente na API ou configuração implícita que só funciona em um ambiente.

## Web e validação

Use DTOs nos limites externos e valide requisições antes de executar efeitos. Centralize a tradução de erros para que a API mantenha formato e semântica consistentes. Aplique autenticação e autorização no nível de recurso e ação; não confunda presença de identidade com permissão.

## Persistência e transações

Delimite transações conforme a regra de negócio e saiba quais operações participam delas. Não dependa de comportamento acidental de proxies, carregamento lazy ou chamadas internas para garantir transação. Evite consultas não intencionais em volume, e trate operações remotas como externas à consistência transacional local.

## Configuração e operação

Externalize configuração por ambiente e valide propriedades críticas na inicialização. Segredos não pertencem a arquivos versionados ou respostas de diagnóstico. Exponha health checks e métricas que representem dependências reais, mantendo logs estruturados e sem dados sensíveis. Teste o contexto apenas onde ele agrega valor; priorize testes direcionados para regras e adaptadores.
