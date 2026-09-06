---
name: engineering-backend
description: Desenvolva ou revise serviços, APIs, integrações e regras de negócio de backend com contratos claros, segurança e operação confiável. Use para alterações no lado servidor; não use como orientação para administração de banco de dados isolada.
---

# Engenharia de backend

Mantenha as regras de negócio independentes de transporte e armazenamento quando isso reduzir acoplamento sem criar abstrações artificiais. Preserve os contratos públicos existentes, ou planeje versionamento e migração explícitos quando a quebra for necessária.

## Contratos e comportamento

Valide entradas no limite do sistema e retorne erros consistentes, acionáveis e sem expor detalhes internos. Aplique autorização no recurso e ação corretos, não apenas na autenticação inicial. Para operações de escrita, defina efeitos, atomicidade, idempotência e comportamento diante de repetição ou falha parcial quando aplicáveis.

Faça timeouts, tentativas e circuit breaking conscientes das características da dependência. Não use retries cegos em operações não idempotentes. Mantenha segredos fora de código e respostas, e minimize dados pessoais nos logs.

## Operação e verificação

Registre eventos estruturados com correlação suficiente para depuração, sem vazar dados sensíveis. Produza métricas e sinais de falha relevantes ao serviço. Teste regras de negócio, bordas do contrato e integração com dependências nos níveis apropriados; testes não devem apenas reproduzir a implementação atual.
