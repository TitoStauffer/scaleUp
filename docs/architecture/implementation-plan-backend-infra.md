# Plano de implementacao - infraestrutura de backend e seed de conteudo (ScaleUp)

**Status:** proposta pronta para o Backend Engineer.
**Origem:** `docs/product/PRD-mvp.md`, `docs/architecture/initial-architecture.md`, `docs/architecture/database-schema.md` (12 migracoes Flyway, `V1` a `V12`, ja validadas contra Postgres real), `docs/product/tickets/TICKET-content-database.md` e os 7 tickets de dominio em `docs/product/tickets/content/`.
**Objetivo deste documento:** definir como a implementacao do backend vai se organizar antes de liberar 7 agentes de conteudo trabalhando em paralelo, um por dominio, sem conflito entre si nem com o codigo do Backend Engineer.

**Nota sobre nome de pacote:** o esqueleto atual do backend usa o pacote `com.scaleup.studyplatform` (`backend/src/main/java/com/scaleup/studyplatform/`), nao `com.vam.studyplatform`. Este documento usa o pacote real existente no repositorio.

---

## 1. Estrutura de pacotes por modulo

A arquitetura ja decidiu: cada modulo tem dominio, aplicacao, entrada/saida (API) e infraestrutura proprios; nada acessa repositorio ou entidade interna de outro modulo diretamente. Mapeamento das 12 tabelas do DBA para os 5 modulos:

| Modulo | Tabelas |
|---|---|
| Content | `domain`, `concept`, `slide`, `flashcard`, `question`, `question_alternative` |
| Study | `study_session`, `flashcard_review` |
| Assessment | `quiz_attempt`, `answer` |
| Progress | `domain_progress`, `nivel_referencia`, `componente_peso` |
| Identity | `app_user` |

Estrutura de pacotes proposta:

```text
com.scaleup.studyplatform
+-- StudyPlatformApplication.java
+-- shared/                      # cross-cutting: tratamento de erro HTTP comum, config geral
|   +-- (ex.: GlobalExceptionHandler, ApiErrorResponse)
+-- content/
|   +-- domain/                  # entidades JPA: Domain, Concept, Slide, Flashcard,
|   |                            #   Question, QuestionAlternative; enums StatusRevisao, Dificuldade
|   +-- application/             # servicos de leitura (casos de uso) + contratos expostos
|   |                            #   a outros modulos (ex.: ContentQueryPort)
|   +-- api/                     # controllers REST + DTOs de request/response
|   +-- infra/                   # repositorios Spring Data JPA
+-- study/
|   +-- domain/  application/  api/  infra/   # skeleton, sem implementacao ainda
+-- assessment/
|   +-- domain/  application/  api/  infra/   # skeleton, sem implementacao ainda
+-- progress/
|   +-- domain/  application/  api/  infra/   # skeleton, sem implementacao ainda
+-- identity/
    +-- domain/  application/  api/  infra/   # skeleton, sem implementacao ainda
```

**Por que so Content ganha implementacao completa agora:** o objetivo desta etapa e destravar os 7 agentes de conteudo, que so dependem do modulo Content existir de ponta a ponta (entidade -> repositorio -> API de leitura). Study, Assessment, Progress e Identity nao tem ticket de API ainda (a arquitetura so os descreve narrativamente) - implementa-los agora seria antecipar decisoes (ex.: formato de submissao de resposta, regra de sessao) que nao sao escopo deste handoff. Criar o pacote vazio (com um `package-info.java` de uma linha, se quiser) ja reserva o boundary para quando esses modulos forem implementados, sem gerar codigo morto significativo.

**Contrato entre modulos:** quando Study/Assessment precisarem de dados de Content (ex.: buscar a Question atual para registrar uma Answer), o acesso deve passar por uma interface explicita exposta em `content/application` (ex.: `ContentQueryPort`), implementada internamente pelo modulo Content - nunca por injecao direta de `QuestionRepository` fora de `content/infra`. Isso nao precisa ser criado agora (nao ha consumidor ainda), mas fica registrado como a regra a seguir quando Study/Assessment forem implementados.

---

## 2. Convencao de seed por dominio - mecanismo a prova de conflito

### Decisao

Cada um dos 7 dominios de conteudo tem um arquivo de migracao Flyway com nome e numero reservados, fixos, decididos agora. Um arquivo Flyway e uma unidade atomica: dois agentes nunca escrevem no mesmo arquivo porque cada um so tem permissao/instrucao para tocar no seu proprio arquivo, com seu proprio numero de versao. Se, por engano, dois agentes usassem o mesmo numero, o Flyway falha a build imediatamente (checksum/versao duplicada) - nao ha cenario de sobrescrita silenciosa.

Pre-requisito: a tabela `domain` precisa ter as 7 linhas antes de qualquer arquivo de conteudo rodar, porque `concept`, `flashcard` e `question` tem FK obrigatoria para `domain`. Por isso, a migracao dos 7 registros de `Domain` e um arquivo a parte, de responsabilidade do Backend Engineer, com numero anterior a todos os arquivos de dominio.

### Nomes de arquivo reservados (literal - repassar aos 7 agentes)

| Arquivo | Responsavel | Conteudo |
|---|---|---|
| `V13__seed_dominios.sql` | Backend Engineer | Insere as 7 linhas de `domain` (`slug`, `nome`, `descricao`, `content_version = v1`, `status_revisao = rascunho`) |
| `V14__seed_conteudo_arquitetura.sql` | Agente do dominio Arquitetura | `Concept`, `Slide`, `Flashcard`, `Question` + alternativas do dominio `arquitetura` |
| `V15__seed_conteudo_sistemas_distribuidos.sql` | Agente do dominio Sistemas Distribuidos | idem, dominio `sistemas-distribuidos` |
| `V16__seed_conteudo_bancos_de_dados.sql` | Agente do dominio Bancos de Dados | idem, dominio `bancos-de-dados` |
| `V17__seed_conteudo_apis_mensageria.sql` | Agente do dominio APIs/Mensageria | idem, dominio `apis-mensageria` |
| `V18__seed_conteudo_escalabilidade_desempenho.sql` | Agente do dominio Escalabilidade/Desempenho | idem, dominio `escalabilidade-desempenho` |
| `V19__seed_conteudo_observabilidade_confiabilidade.sql` | Agente do dominio Observabilidade/Confiabilidade | idem, dominio `observabilidade-confiabilidade` |
| `V20__seed_conteudo_seguranca.sql` | Agente do dominio Seguranca | idem, dominio `seguranca` |

Local: `backend/src/main/resources/db/migration/`. Os slugs acima devem ser usados exatamente assim (mesma grafia dos nomes de arquivo dos tickets em `docs/product/tickets/content/`) para bater com a chave natural usada nos INSERTs.

### Regras que cada agente de dominio deve seguir dentro do seu arquivo

1. Nunca inserir na tabela `domain`. A linha do seu dominio ja existe (criada por `V13`); referencie-a por subquery: `(SELECT id FROM domain WHERE slug = arquitetura)` (usando aspas simples de SQL ao redor do slug no arquivo real).
2. `content_version = v1` em toda linha inserida (Concept, Slide, Flashcard, Question) - todo o lote desta entrega compartilha o mesmo identificador de versao, conforme o ticket mestre exige.
3. `status_revisao = rascunho` em toda linha - nenhum item deste lote pode nascer como `revisado_aprovado` (autoria por IA, revisao humana ainda nao ocorreu).
4. Question + suas 4 alternativas na mesma transacao. Como cada arquivo Flyway roda como uma transacao unica (comportamento padrao do Flyway em Postgres), basta que o INSERT em `question` e os 4 INSERTs em `question_alternative` para aquela questao estejam no mesmo arquivo - o que ja e garantido por essa convencao. O trigger de constraint adiada (`trg_verificar_alternativas_question`) valida ao final da transacao/arquivo.
5. Nao tocar em nenhum outro arquivo `V*`, inclusive dos outros dominios. Isso e o que torna o paralelismo estruturalmente seguro: nenhuma dependencia textual ou de merge entre os 7 arquivos.
6. Ordem dos `Slide` sequencial e sem lacunas dentro de cada `Concept`, comecando em 1 - nao garantido por constraint de banco (so a unicidade e), entao cada agente e responsavel por gerar a sequencia certa no proprio arquivo.

### Por que isso resolve "estruturalmente impossivel conflitar"

- Arquivos diferentes, numeros de versao diferentes reservados de antemao: sem merge conflict de Git possivel entre os 7 agentes (cada um so cria um arquivo novo, nunca edita um existente).
- Sem coordenacao de ordem de execucao necessaria entre os 7: `V14` a `V20` podem ser criados e mergeados em qualquer ordem relativa entre si; o Flyway aplica todos em ordem numerica quando a migracao rodar, e todos dependem so de `V13` ja ter rodado antes (garantido pela numeracao, nao por coordenacao humana).
- Reutilizacao de numero por engano e detectada pelo proprio Flyway (falha de build/migracao), nao silenciosamente sobrescrita.

### Observacao operacional para os agentes de conteudo

Migracoes Flyway ja aplicadas nao devem ser editadas (Flyway valida checksum). Durante a autoria/iteracao local, cada agente deve resetar o banco local (`docker compose down -v` + subir de novo) sempre que editar seu proprio arquivo antes do commit final - isso e iteracao normal de desenvolvimento, nao um problema do mecanismo de seed.

---

## 3. Contrato inicial de API de leitura (modulo Content)

Escopo: so o suficiente para o Frontend montar a tela de selecao de dominio e exibir slides/flashcards/quiz depois. Nao inclui sessao de estudo, submissao de resposta ou calculo de pontuacao - isso e decisao futura (Study/Assessment), fora deste handoff.

| Metodo | Rota | Retorno |
|---|---|---|
| GET | `/api/dominios` | Lista dos dominios: `id`, `slug`, `nome`, `descricao` |
| GET | `/api/dominios/{slug}` | Detalhe do dominio + seus `Concept`s, cada um com seus `Slide`s aninhados e ordenados por `ordem` |
| GET | `/api/dominios/{slug}/flashcards` | Flashcards do dominio (`id`, `frente`, `verso`, `dificuldade`); filtro opcional `?dificuldade=` |
| GET | `/api/dominios/{slug}/questoes` | Questoes do dominio com alternativas, sem o campo `correta` e sem `explicacao` |

**Regra de seguranca ja decidida na arquitetura, aplicada aqui:** nao retornar respostas corretas antes da submissao ja vale para esta API de leitura, mesmo sem endpoint de submissao ainda existir - o DTO de alternativa expoe so `id` e `texto`. `explicacao` da `Question` tambem fica de fora da resposta de leitura, pelo mesmo motivo (evita vazar a resposta indiretamente pela explicacao).

**Filtro de status:** as consultas devem filtrar `status_revisao = revisado_aprovado` - e a regra ja registrada na arquitetura (a aplicacao nunca deve servir ao usuario final conteudo rascunho). Isso gera uma pendencia real, registrada na secao 5.

**Erros:** dominio com `slug` inexistente retorna 404 com corpo de erro consistente (`shared/GlobalExceptionHandler`, reaproveitavel pelos outros modulos quando forem implementados).

Fora de escopo aqui, decisao futura: paginacao (volume atual - dezenas de itens por dominio - nao justifica), endpoint de submissao de resposta/revisao, calculo de pontuacao, nivel do dominio.

---

## 4. Ordem de execucao do Backend Engineer

O objetivo da ordem abaixo e chegar a um ponto testavel (API de leitura respondendo, mesmo sem conteudo dos dominios ainda) antes de liberar os 7 agentes - a partir dai, os seeds de conteudo sao so INSERTs aditivos que nao exigem nenhuma mudanca de codigo.

1. **Dependencias no `pom.xml`:** `spring-boot-starter-data-jpa`, driver `org.postgresql:postgresql` (runtime), `flyway-core` + `flyway-database-postgresql` (Flyway 10+ separa o suporte a Postgres em modulo proprio).
2. **Configuracao de datasource e Flyway** (`application.yml`): URL/usuario/senha compativeis com `docker-compose.yml`; `spring.jpa.hibernate.ddl-auto=validate` (o schema e 100% controlado por Flyway, nunca por auto-geracao do Hibernate); `spring.flyway.enabled=true`.
3. **Criar o skeleton de pacotes** dos 5 modulos (secao 1) - so `content` recebe conteudo real nesta etapa.
4. **Entidades JPA do modulo Content** (`Domain`, `Concept`, `Slide`, `Flashcard`, `Question`, `QuestionAlternative`) mapeando as tabelas existentes (`V1` a `V6`), incluindo os enums `StatusRevisao`/`Dificuldade` como `@Enumerated(STRING)` ou conversor customizado, coerente com as colunas `varchar` + `CHECK` ja decididas pelo DBA.
5. **Repositorios Spring Data JPA** em `content/infra`, com as queries de leitura ja filtrando por `status_revisao` (ex.: `findBySlugAndStatusRevisao`).
6. **Servicos de aplicacao** em `content/application` (ex.: `ConsultarDominiosService`, `ConsultarConteudoDominioService`, `ConsultarFlashcardsService`, `ConsultarQuestoesService`) retornando DTOs (nao entidades) - e aqui que o campo `correta`/`explicacao` fica de fora por construcao.
7. **Controllers e DTOs** em `content/api`, implementando os 4 endpoints da secao 3, e `shared/GlobalExceptionHandler` para 404/erro de validacao.
8. **Migracao `V13__seed_dominios.sql`** (as 7 linhas de `domain`) - so agora, depois que o codigo de leitura ja existe e pode ser testado contra ela.
9. **Checkpoint testavel:** subir a aplicacao, migracoes `V1` a `V13` aplicadas, `GET /api/dominios` retorna os 7 dominios (com listas de conceitos/flashcards/questoes vazias, ja que `V14` a `V20` ainda nao existem). Teste de integracao cobrindo isso (subida da app + Flyway + `GET /api/dominios`) e o criterio minimo antes de liberar os 7 agentes.
10. **A partir daqui, liberar os 7 agentes de conteudo em paralelo**, cada um entregando seu arquivo reservado (`V14` a `V20`). Nenhuma mudanca de codigo e necessaria para os seeds aparecerem na API - sao INSERTs aditivos sobre um schema e uma API ja prontos.

---

## 5. Pendencias

**Para o PM (bloqueio real, nao cosmetico):** a API de leitura, por regra ja decidida na arquitetura, so deve servir conteudo com `status_revisao = revisado_aprovado`. Mas o ticket mestre de conteudo exige explicitamente que todo o lote desta entrega (autoria por IA) nasca como `status_revisao = rascunho`, sem excecao, ate haver revisao humana. Consequencia: depois que os 7 seeds rodarem, `GET /api/dominios/{slug}` vai continuar retornando listas vazias de conceitos/flashcards/questoes, porque nada estara `revisado_aprovado` - a tela de estudo do Frontend fica sem dado para mostrar, mesmo com o conteudo ja no banco. Preciso de uma decisao do Tito sobre uma das opcoes abaixo antes que o Frontend consiga validar o fluxo fim a fim com dado real:
   - (a) um processo explicito (script UPDATE avulso, nao migracao) que promove o lote v1 inteiro para `revisado_aprovado` depois de uma revisao rapida, mesmo que superficial, dado que o objetivo desta fase e validar o pipeline tecnico, nao publicar conteudo final; ou
   - (b) a API de leitura aceitar temporariamente `status_revisao IN (rascunho, revisado_aprovado)` enquanto nao houver processo de revisao formal, com um plano explicito de apertar esse filtro depois (risco: caso essa opcao seja esquecida, o app passa a exibir permanentemente conteudo nao revisado ao usuario final).

   Este documento nao decide entre (a) e (b) - e uma regra de produto/negocio (quando conteudo rascunho pode ou nao ser exibido), nao uma decisao estrutural.

**Para o DBA:** nenhuma pendencia de schema. As FKs, constraints e triggers ja existentes (`V1` a `V12`) suportam o mecanismo de seed descrito aqui sem alteracao.
