---
name: engineering-java
description: Desenvolva ou revise aplicações Java baseadas na plataforma padrão, com APIs explícitas, concorrência segura e manutenção previsível. Use para código Java que não dependa especificamente de convenções do Spring.
---

# Engenharia Java

Prefira tipos e modelos de domínio que tornem estados inválidos difíceis de representar. Defina contratos públicos estáveis, incluindo nulidade, mutabilidade, exceções e propriedades de ordenação ou igualdade quando relevantes. Não exponha coleções mutáveis ou detalhes de implementação como parte acidental da API.

## Recursos e concorrência

Feche recursos determinísticos e use APIs que expressem posse e ciclo de vida. Evite bloquear pools compartilhados, criar threads sem estratégia de gestão ou compartilhar estado mutável sem sincronização definida. Ao usar paralelismo, defina limites, cancelamento, propagação de falha e o que acontece com efeitos parciais.

## Dados e erros

Valide dados nas fronteiras adequadas, preservando invariantes no domínio. Use exceções para condições excepcionais e traduza falhas de infraestrutura no limite apropriado, sem perder contexto operacional ou vazar detalhes sensíveis. Evite capturar exceções amplas apenas para registrar e continuar em estado inconsistente.

## Verificação

Mantenha testes rápidos e determinísticos para regras de negócio e casos de borda. Cubra comportamento de serialização, data/hora, concorrência e recursos externos quando esses riscos existirem. Não use testes que dependam de ordem global ou tempo real sem controle explícito.
