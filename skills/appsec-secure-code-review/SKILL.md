---
name: appsec-secure-code-review
description: Revise código e configuração de aplicação em busca de falhas de segurança, priorizando impacto, contexto e correções verificáveis. Use em pull requests, mudanças sensíveis ou revisões periódicas de componentes autorizados.
---

# Revisão segura de código

Siga os fluxos que recebem entrada, decidem identidade e permissão, acessam dados, chamam dependências, registram eventos e produzem resposta. Revise o comportamento real e a configuração efetiva; a presença de uma biblioteca de segurança não prova que o controle está aplicado corretamente.

## Focos de revisão

Verifique validação e normalização no limite apropriado, autorização por recurso e ação, gestão de sessão, proteção de segredos, tratamento de erros, serialização, acesso a arquivos ou rede e exposição em logs. Para mudanças de dados, avalie isolamento, consultas parametrizadas, privilégio da identidade de banco e integridade das regras de negócio.

Priorize descobertas exploráveis com impacto demonstrável. Descreva local, pré-condições, comportamento vulnerável, impacto e correção recomendada. Evite classificar estilo, preferência de biblioteca ou hipótese não confirmada como vulnerabilidade crítica.

Não introduza dados de produção, credenciais ou ataques invasivos para validar uma suspeita. Quando a confirmação exigir interação além da revisão autorizada, solicite escopo e ambiente apropriados.
