---
name: task-orchestration
description: Estruture tarefas com possível colaboração de agentes, definindo escopo, dependências e handoffs antes de delegar. Use quando o pedido tiver múltiplas frentes ou precisar de execução paralela.
---

# Orquestração de tarefas

Transforme o pedido em resultados concretos, com um responsável claro por cada resultado. Mantenha no agente principal as decisões de escopo, permissões e a integração final.

## Decidir se há delegação

Delegue somente uma parte independente que tenha resultado verificável e contexto delimitado. Execute localmente trabalhos pequenos, sequenciais ou cuja divisão aumentaria o risco de inconsistência.

Antes de delegar, informe: objetivo, arquivos ou fontes em escopo, resultado esperado, restrições e critério de conclusão. Não delegue uma aprovação do usuário, a decisão final de produto, nem ações externas que não estejam autorizadas.

## Integrar resultados

Confira o resultado contra o pedido original, preserve alterações pré-existentes e resolva conflitos antes de comunicar a entrega. Registre fatos observáveis — arquivos modificados, verificações executadas e pendências — em vez de assumir que a subtarefa foi concluída corretamente.
