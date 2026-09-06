# Estrutura de automação

Esta base separa instruções reutilizáveis (skills) de responsabilidades que só fazem sentido quando o trabalho é dividido entre agentes. Produto, Engenharia, QA, DevOps e AppSec são domínios complementares: AppSec revisa riscos de ponta a ponta; QA valida a qualidade e o comportamento do sistema em cenários autorizados.

## Organização

- `skills/`: capacidades invocáveis e portáveis. Cada pasta é uma skill válida, com `SKILL.md`.
- `agents/`: contratos de colaboração. Não define agentes permanentes nem concede novas permissões.

## Como evoluir

1. Quando um fluxo se repetir e exigir regras locais, crie ou refine uma skill.
2. Quando a tarefa tiver partes independentes ou exigir uma especialidade distinta, atribua um papel descrito em `agents/roles.md`.
3. Toda delegação deve seguir o pacote mínimo de `agents/handoffs.md`.
4. Só mova uma skill para a coleção global depois de usá-la e validá-la no projeto.

## Limites

Skills orientam decisões; elas não autorizam alterações externas, publicação, exclusões ou acesso a dados fora do escopo dado pelo usuário. Agentes são temporários e devem devolver resultados verificáveis ao agente responsável.
