---
name: qa-adversarial-testing
description: Explore falhas, usos inesperados e condições degradadas em sistemas autorizados para revelar riscos que testes roteirizados não cobrem. Use em revisão de release, investigação de defeito ou validação de fluxos críticos.
---

# Testes adversariais

Questione as suposições do fluxo feliz: o que acontece com entradas incompletas, repetidas, fora de ordem, antigas, concorrentes ou incompatíveis? Explore mudanças de estado, interrupções de rede, indisponibilidade de dependências, permissões insuficientes e recuperação após reinício quando forem aplicáveis.

Priorize superfícies com maior impacto: autenticação e autorização, escrita de dados, dinheiro, dados pessoais, integrações e operações irreversíveis. Teste apenas ativos e ambientes explicitamente autorizados, usando dados seguros e limites que não degradem sistemas compartilhados.

## Evidência

Para cada achado, registre pré-condições, passos mínimos de reprodução, resultado observado, resultado esperado, impacto, ambiente e evidências relevantes. Diferencie defeito confirmado, risco plausível e comportamento ainda sem decisão. Não altere dados de produção nem execute ações destrutivas para demonstrar uma hipótese sem autorização específica.

Uma sessão exploratória termina com uma síntese de áreas cobertas, descobertas, perguntas e próximos experimentos de maior valor.
