---
name: engineering-react
description: Desenvolva ou revise aplicações React com estado previsível, componentes acessíveis e integração resiliente com APIs. Use para interfaces React; combine com a skill geral de frontend para decisões de experiência e comportamento.
---

# Engenharia React

Modele a interface como derivação de estado explícito. Mantenha o estado próximo do menor escopo que o utiliza e eleve-o apenas quando houver consumidores reais. Não copie props ou dados remotos para estado local sem uma regra clara de sincronização ou edição independente.

## Componentes e efeitos

Crie componentes em torno de responsabilidades de interface, evitando componentes genéricos prematuros. Use efeitos para sincronizar com sistemas externos, não para calcular valores que podem ser derivados durante a renderização. Trate limpeza, cancelamento e respostas fora de ordem em efeitos que disparem operações assíncronas.

Preserve identidades estáveis quando listas e estado dependem delas; não use índices como chave se a ordem puder mudar. Evite otimizações de memoização sem medir ou identificar um gargalo, pois elas também ampliam a superfície de estados desatualizados.

## Qualidade

Garanta estados de carregamento, falha e vazio para dados remotos. Use elementos semânticos e testes baseados no comportamento que a pessoa usuária encontra. Quando houver rotas protegidas ou dados sensíveis, trate a autorização como responsabilidade também do servidor; proteções de UI são apenas uma camada de experiência.
