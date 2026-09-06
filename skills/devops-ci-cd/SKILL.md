---
name: devops-ci-cd
description: Projete, implemente ou revise pipelines de integração e entrega contínuas com feedback rápido, artefatos rastreáveis e deploy seguro. Use para automação de build, testes, publicação e promoção entre ambientes.
---

# CI/CD

Organize a pipeline como uma cadeia de evidências: código identificado gera artefato reproduzível, verificações compatíveis com o risco e promoção explícita entre ambientes. Mantenha o mesmo artefato ao promover uma release; reconstruir por ambiente reduz rastreabilidade.

## Integração contínua

Faça o feedback de pull request rápido e determinístico. Separe verificações essenciais das mais demoradas, sem omitir riscos relevantes. Fixe versões de ferramentas e dependências quando necessário para reprodutibilidade, use cache com chave controlada e nunca imprima segredos nos logs.

## Entrega e reversão

Associe release a commit, versão, artefato, configuração e resultado das verificações. Planeje compatibilidade de banco e contratos antes de um deploy automatizado. Defina critérios observáveis de sucesso, janela de observação, responsável e estratégia de rollback ou roll-forward.

Não transforme deploy em produção, criação de credenciais ou mudança destrutiva em efeito implícito de um pipeline. Esses passos exigem ambientes, permissões e aprovações definidos de forma explícita.
