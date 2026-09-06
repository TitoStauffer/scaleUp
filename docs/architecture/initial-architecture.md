# Arquitetura inicial — MVP

**Status:** proposta  
**Decisão:** monólito modular com React, Spring Boot/Java, PostgreSQL e migrações versionadas.

## Objetivo arquitetural

Entregar o ciclo de estudo com baixo custo operacional, fronteiras claras e espaço para evoluir o cálculo de domínio, conteúdo e autenticação sem transformar o MVP em uma arquitetura distribuída.

## Módulos

- **Content:** domínios, conceitos, slides, flashcards e questões.
- **Study:** sessões, apresentação de conteúdo e registro de revisão.
- **Assessment:** tentativas, respostas, cálculo de pontuação e classificação.
- **Progress:** histórico, evolução por domínio e resultado geral.
- **Identity:** abstração mínima de usuário local, preparada para autenticação futura.

Cada módulo deve possuir domínio, aplicação, entrada/saída e infraestrutura próprias. Compartilhamento entre módulos ocorre por contratos explícitos; não acessar repositórios ou entidades internas de outro módulo diretamente.

## Fluxo principal

1. O frontend solicita o domínio e seu conteúdo publicado.
2. O backend cria uma sessão de estudo e entrega os itens na ordem definida.
3. O frontend envia revisões e respostas; o backend valida a sessão e persiste os resultados.
4. O módulo Assessment calcula os componentes da pontuação.
5. O módulo Progress atualiza o estado do domínio e a média geral.
6. A API retorna resultado, explicações e próximo passo recomendado.

## Modelo de domínio inicial

`User` possui `DomainProgress`. `Domain` agrega `Concept`, `Slide`, `Flashcard` e `Question`. `StudySession` registra a sessão; `FlashcardReview` e `QuizAttempt` registram evidências. `QuizAttempt` possui `Answer` para cada questão. `DomainProgress` mantém pontuação por componente, nível atual, volume mínimo e data da última avaliação.

Conteúdo é versionável e publicado por seed no primeiro corte. Respostas devem guardar referência à versão do conteúdo usada, evitando que uma alteração posterior reescreva o histórico.

## Persistência e consistência

PostgreSQL é a fonte de verdade. Operações de resposta e atualização de progresso devem ser atômicas dentro do módulo de aplicação. A classificação pode ser recalculada de forma determinística a partir das evidências; não armazenar somente um valor sem origem explicável.

Migrações são versionadas, aditivas quando possível e compatíveis com a sequência de deploy. Índices devem ser adicionados conforme consultas reais do fluxo forem conhecidas.

## Contrato e segurança

API HTTP versionada apenas quando houver necessidade de compatibilidade externa; no MVP, manter contrato claro e documentado. Validar payloads na entrada, autorizar o usuário da sessão e não retornar respostas corretas antes da submissão. Não registrar respostas, tokens ou PII em logs.

## Observabilidade

Instrumentar início/conclusão de sessão, duração, falhas de resposta, cálculo de pontuação e erros de persistência. Usar correlação de requisição e métricas sem conteúdo sensível. O fluxo deve permitir diagnosticar uma pontuação sem depender de logs contendo respostas pessoais.

## Decisões futuras

- Autenticação real quando houver mais de um usuário.
- Admin de conteúdo quando seed versionado deixar de ser suficiente.
- Fila ou processamento assíncrono somente para tarefas que demonstrarem custo ou desacoplamento necessário.
- Cache e busca após medir latência ou volume reais.
