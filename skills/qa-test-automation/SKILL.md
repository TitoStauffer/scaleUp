---
name: qa-test-automation
description: Projete, implemente ou revise automação de testes confiável, rápida e útil para decisões de entrega. Use para suites de testes de unidade, integração, contrato, interface ou regressão.
---

# Automação de testes

Automatize comportamentos estáveis e relevantes para decisão, não a aparência de cobertura. Posicione cada teste no nível mais baixo que reproduza o risco de forma confiável; prefira testes de unidade e integração para regras e adaptadores, e mantenha testes de interface focados em jornadas críticas.

## Confiabilidade

Isole dados, tempo, aleatoriedade e dependências externas. Não resolva flakiness com repetições ou esperas arbitrárias: encontre a sincronização, condição de corrida ou contrato instável que a produz. Dê nomes aos testes pelo comportamento e falha esperada, não pelo método interno chamado.

Faça fixtures mínimas e explícitas, evitando um estado compartilhado que torne a ordem de execução relevante. Use mocks apenas para limites externos ou condições difíceis de produzir; um teste excessivamente acoplado a mocks pode passar mesmo quando a integração real falha.

## Manutenção e sinal

Relate falhas com contexto suficiente para diagnóstico e preserve execução local viável. Monitore duração, instabilidade e valor de cada suíte; remova ou reescreva testes redundantes em vez de aceitar uma pipeline cada vez menos confiável.
