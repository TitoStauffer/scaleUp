---
name: appsec-supply-chain-security
description: Avalie e reduza riscos de dependências, artefatos, repositórios e ferramentas de build na cadeia de software. Use ao adicionar dependências, revisar build ou preparar uma release.
---

# Segurança da cadeia de software

Mantenha inventário rastreável de dependências diretas e transitivas, origem, versão e finalidade. Avalie manutenção, compatibilidade, licença quando relevante e histórico de vulnerabilidades antes de introduzir uma dependência; não adicione bibliotecas apenas para resolver uma conveniência pequena.

## Build e artefatos

Fixe ou controle versões de dependências e ferramentas conforme o ecossistema permitir. Proteja tokens de repositório e publicação com menor privilégio e expiração. Separe credenciais de leitura, publicação e deploy, e assegure que logs, caches e artefatos não exponham segredos.

Associe artefatos publicados à origem e aos testes que os geraram. Verifique integridade, procedência e permissões antes de promover artefatos entre ambientes. Uma atualização de dependência deve considerar compatibilidade e testes de regressão, não apenas a ausência de alertas.

## Resposta

Quando houver vulnerabilidade conhecida, determine se o componente é alcançável, o contexto de uso, exposição, correção disponível e mitigação temporária. Priorize por risco efetivo ao sistema, mas registre exceções, dono e prazo de reavaliação.
