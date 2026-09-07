# PRD — ScaleUp (Plataforma de estudos de System Design, MVP)

**Status:** proposta inicial  
**Stack decidida:** React + Spring Boot/Java + PostgreSQL + Maven + npm  
**Arquitetura inicial:** monólito modular

## Contexto e problema

Quem estuda para entrevistas de System Design precisa alternar entre conteúdo conceitual, revisão e avaliação, normalmente usando ferramentas separadas. Isso dificulta perceber quais domínios estão fracos e acompanhar a evolução do conhecimento.

## Objetivo

Oferecer um ciclo único de estudo que permita aprender um conceito, revisá-lo, testá-lo e acompanhar o domínio por tópico. A métrica inicial será a conclusão bem-sucedida do ciclo e a evolução da pontuação por domínio; não há linha de base definida ainda.

## Não objetivos do MVP

- aplicativo mobile nativo;
- algoritmo avançado de repetição espaçada;
- geração automática de conteúdo ou questões por IA;
- marketplace, colaboração social ou gamificação complexa;
- painel administrativo completo;
- microserviços ou arquitetura distribuída.

## Usuário e fluxo principal

O usuário é uma pessoa estudando para entrevistas técnicas. Ela seleciona um domínio, consulta slides, revisa flashcards, responde questões objetivas e recebe resultado atualizado do domínio.

## Domínios iniciais — hipótese

Arquitetura, sistemas distribuídos, bancos de dados, APIs/mensageria, escalabilidade/desempenho, observabilidade/confiabilidade e segurança. A lista pode ser ajustada antes da carga inicial de conteúdo.

## Requisitos funcionais

1. O usuário consegue visualizar domínios e seu nível atual de domínio.
2. Cada domínio possui conteúdo organizado em conceitos e slides.
3. Cada domínio possui flashcards com frente, verso e dificuldade.
4. Cada domínio possui questões objetivas com alternativas, resposta correta e explicação.
5. O usuário consegue iniciar uma sessão de estudo para um domínio.
6. Ao concluir um quiz, o sistema exibe acertos, erros, explicações e pontuação.
7. O sistema atualiza a pontuação do domínio usando os pesos definidos: quiz 40%, flashcards 25%, questões novas 20%, consistência 10% e calibração da autoconfiança 5%.
8. O sistema converte a pontuação em um dos 12 níveis: Junior 1–3, Pleno 1–3, Senior 1–3 ou Especialista 1–3.
9. O sistema exibe um resultado geral como média ponderada dos domínios; no MVP, os domínios têm peso igual.
10. O usuário consegue consultar seu histórico recente de sessões e evolução por domínio.

## Regras de classificação

- A pontuação varia de 0 a 100.
- A classificação é por domínio; o resultado geral é uma agregação, não substitui os níveis individuais.
- O nível não deve oscilar por uma única sessão; a implementação inicial deve exigir volume mínimo de evidência e consistência.
- Os thresholds devem ser configuráveis, não codificados em múltiplas telas ou regras duplicadas.

## Requisitos não funcionais

- A aplicação deve proteger credenciais, PII e dados de estudo nos logs e respostas.
- APIs devem validar entrada, aplicar autorização e retornar erros consistentes.
- Alterações de banco devem usar migrações versionadas e compatíveis.
- O código deve passar build, lint, testes unitários, análise estática e revisão de segurança antes da entrega.
- A interface deve atender acessibilidade básica e funcionar em telas desktop e mobile responsivas.

## Dados e instrumentação

Registrar sessão iniciada/concluída, domínio, tipo de atividade, dificuldade, acerto/erro, confiança declarada, pontuação calculada e nível resultante. Não registrar respostas ou identificadores pessoais em texto de log sem necessidade.

## Dependências, riscos e perguntas abertas

- **Conteúdo inicial:** precisa ser criado e revisado; responsável e formato ainda serão definidos.
- **Autenticação:** assumir usuário único/local no primeiro corte, salvo decisão contrária.
- **Modelo de dificuldade:** começar com dificuldade editorial (fácil/média/difícil); calibrar por dados depois.
- **Fórmula de consistência e estabilidade:** precisa de uma especificação técnica antes da implementação.
- **Administração de conteúdo:** decidir entre seed versionado e uma interface mínima após o primeiro fluxo.

## Critérios de aceite do MVP

- É possível selecionar um domínio e completar o fluxo slides → flashcards → quiz.
- O resultado do quiz mostra acertos, erros, explicações e pontuação.
- A pontuação e o nível do domínio são persistidos e consultáveis depois da sessão.
- O resultado geral é calculado a partir dos domínios disponíveis.
- Casos inválidos, ausência de conteúdo e falhas de persistência têm feedback compreensível.
- Testes unitários cobrem cálculo de pontuação/classificação e testes de integração cobrem o fluxo principal da API.
