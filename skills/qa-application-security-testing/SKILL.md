---
name: qa-application-security-testing
description: Avalie controles de segurança de aplicações em sistemas autorizados, verificando autenticação, autorização, exposição de dados e configuração sem realizar ações destrutivas. Use para revisão de segurança de mudanças ou preparação de release.
---

# Testes de segurança de aplicação

Defina escopo autorizado, ambiente, contas de teste, dados permitidos e limites operacionais antes de qualquer avaliação. Concentre-se em verificar controles e impactos reais: autenticação, autorização por recurso, gestão de sessão, validação de entrada, exposição de dados, segredos, logs, dependências e configuração de transporte.

Teste cenários negativos de forma controlada: identidade ausente, privilégios insuficientes, tentativa de acesso cruzado entre recursos, dados malformados e repetição de operações sensíveis. Priorize demonstrar a menor evidência necessária para confirmar o risco; não extraia dados desnecessários, mantenha persistência no alvo ou degrade disponibilidade.

## Relato responsável

Registre ativo, pré-condições, reprodução mínima, impacto demonstrado, severidade contextualizada e recomendação de correção. Marque com clareza o que foi confirmado e o que é hipótese. Proteja capturas, tokens, identificadores e quaisquer dados sensíveis presentes na evidência.

Se a validação exigir exploração invasiva, varredura ampla, acesso a produção ou técnica fora do escopo, pare e solicite autorização explícita com escopo e janela definidos.
