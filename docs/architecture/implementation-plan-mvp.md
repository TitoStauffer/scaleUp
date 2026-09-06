# Plano de implementação — primeiro vertical slice

## Ordem de execução

1. Criar projeto Maven Spring Boot e aplicação React com comandos de build reproduzíveis.
2. Configurar PostgreSQL local e migração inicial.
3. Implementar domínio e seed de um domínio com conceitos, slides, flashcards e questões.
4. Implementar API de consulta de domínio/conteúdo.
5. Implementar sessão de estudo e registro de revisão/resposta.
6. Implementar cálculo determinístico de pontuação e nível do domínio.
7. Implementar tela React do fluxo completo.
8. Adicionar histórico e resultado geral.
9. Adicionar testes, lint, análise estática, documentação da API e revisão de segurança.

## Primeiro recorte verificável

Um usuário local seleciona um domínio, estuda pelo menos um conceito, revisa flashcards, responde um quiz e consulta a pontuação e o nível persistidos. O resultado deve sobreviver a uma nova consulta e exibir explicações das respostas.

## Evidências por camada

- **Domínio:** testes unitários para pesos, thresholds, volume mínimo e estabilidade do nível.
- **API:** testes de integração para criação de sessão, submissão idempotente e persistência.
- **Frontend:** teste de comportamento do fluxo, incluindo carregamento, vazio, erro e resultado.
- **Banco:** migração aplicada em banco limpo e seed reproduzível.
- **Entrega:** build Maven/npm, lint, análise estática, testes e revisão de segurança aprovados.

## Riscos a acompanhar

- Fórmula de consistência ainda não especificada; começar com uma regra documentada e substituível.
- Conteúdo inicial pode enviesar a classificação; registrar dificuldade editorial e versão.
- Sem autenticação, o usuário local não representa o modelo final multiusuário; manter Identity isolado.
