-- Ampliação do pool de Slides — Domínio Bancos de Dados (slug 'bancos-de-dados'), Fase 1.
-- TICKET-content-expansion-slides-fase1.md: adiciona 2 Slides novos por Concept (ordem 4 =
-- erros comuns/armadilhas, ordem 5 = comparação com alternativa) às 3 já existentes em
-- V16__seed_conteudo_bancos_de_dados.sql, elevando o pool para 5 Slides por Concept / 25 no domínio.

-- Concept: Modelagem relacional vs. NoSQL
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a3000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'O erro de "normalizar" um banco de documento',
     'Um erro comum de quem migra de relacional para um banco de documento é continuar modelando por referência (um "pedido" que aponta para um "cliente" em outra coleção, exigindo uma segunda consulta para juntar os dois) em vez de embutir os dados relacionados dentro do próprio documento. Parece mais seguro porque evita duplicação, do jeito que se aprendeu com normalização — mas joga fora justamente o motivo de usar um banco de documento: a leitura de um documento único e completo em uma única operação. O resultado é um sistema que paga o custo de múltiplas consultas do relacional sem ganhar nenhuma das garantias de integridade que o relacional oferece via chave estrangeira.',
     4, 'v1', 'rascunho'),
    ('a3000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'JSONB em banco relacional vs. migrar para NoSQL dedicado',
     'Antes de trocar de banco inteiro, muitos casos de dado semiestruturado se resolvem mantendo o banco relacional e usando uma coluna de tipo JSON/JSONB (suportada nativamente pelo PostgreSQL, por exemplo) para os poucos campos realmente variáveis, preservando transações ACID e joins para o restante do modelo. O critério concreto: se a maior parte dos dados continua bem representada em tabelas e só uma fração precisa de estrutura flexível, prefira JSONB dentro do relacional; migre para um banco de documento dedicado quando a maioria das entidades tem forma variável e o volume de escrita já exige escala horizontal que um único nó relacional não sustenta.',
     5, 'v1', 'rascunho');

-- Concept: Indexação e desempenho de consultas
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a3000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'Indexar uma coluna de baixa seletividade e esperar ganho',
     'Um erro frequente é criar um índice em uma coluna com poucos valores distintos (ex.: um booleano `ativo`, ou um `status` com três opções), esperando que qualquer índice acelere qualquer filtro. Parece razoável porque "índice sempre ajuda", mas quando metade ou mais das linhas compartilha o mesmo valor, o otimizador corretamente prefere um `Seq Scan`: acessar o índice e depois voltar à tabela para buscar cada linha (random I/O) é mais caro do que ler a tabela sequencialmente quando a consulta retornaria uma fração grande dela de qualquer forma. O índice nesse caso só existe para pagar custo de escrita sem nunca ser usado nas leituras.',
     4, 'v1', 'rascunho'),
    ('a3000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'Índice vs. tabela de resumo desnormalizada',
     'Um índice acelera a busca sobre os dados originais, mas continua exigindo que o banco calcule o resultado (agregações, contagens, junções) a cada consulta. Uma alternativa concorrente para leituras muito repetitivas e caras é manter uma tabela de resumo desnormalizada, atualizada de forma assíncrona ou por trigger, que já guarda o resultado pronto. O critério: use índice quando a consulta precisa sempre refletir o dado mais recente e o custo de mantê-lo atualizado a cada escrita é aceitável; use uma tabela de resumo quando a mesma agregação cara é lida com muito mais frequência do que os dados-fonte mudam, e uma pequena defasagem (recalculada periodicamente) é tolerável.',
     5, 'v1', 'rascunho');

-- Concept: Transações e ACID
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a3000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'Achar que "estar em uma transação" evita corrida entre leitura e escrita',
     'Um erro conceitual comum é assumir que envolver um "ler o estoque, calcular o novo valor, gravar o novo valor" dentro de `BEGIN`/`COMMIT` já elimina qualquer condição de corrida, só por estar "protegido" por uma transação. Isso parece certo porque a transação garante atomicidade das escritas, mas no nível de isolamento padrão da maioria dos bancos (Read Committed) duas transações concorrentes podem ler o mesmo valor de estoque antes de qualquer uma escrever, e a segunda escrita sobrescreve a primeira sem nunca ver o decremento já aplicado — o clássico "lost update". A transação por si só não serializa a lógica de leitura-decisão-escrita; isso exige lock explícito (`SELECT ... FOR UPDATE`) ou um nível de isolamento mais forte.',
     4, 'v1', 'rascunho'),
    ('a3000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'Transação ACID vs. Saga para operações entre múltiplos serviços',
     'Uma transação ACID tradicional só funciona dentro de um único banco de dados: ela não tem como coordenar um `COMMIT` atômico entre o banco do serviço de pedidos e o banco do serviço de pagamentos, por exemplo. Para esse cenário, a alternativa usada em arquiteturas de microsserviços é o padrão Saga: uma sequência de transações locais, cada uma com uma ação compensatória definida para desfazer o que já foi feito caso uma etapa posterior falhe. O critério: use uma transação ACID quando todos os dados afetados vivem no mesmo banco; use Saga quando a operação atravessa serviços/bancos distintos, aceitando consistência eventual e a complexidade adicional de escrever compensações em troca de não acoplar os serviços a um único banco compartilhado.',
     5, 'v1', 'rascunho');

-- Concept: Níveis de isolamento e controle de concorrência
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a3000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'Usar Serializable sem tratar falha de serialização',
     'Um erro comum é elevar o nível de isolamento para Serializable achando que é "estritamente melhor" e sem contrapartida, apenas mais seguro. Na prática, sob Serializable o banco pode abortar uma transação no meio da execução com um erro de serialização (ex.: `40001` no PostgreSQL) sempre que detecta que a ordem de execução concorrente violaria a garantia de isolamento — isso é esperado e faz parte do protocolo, não uma falha do sistema. Quem não implementa lógica de retry ao redor dessa transação trata o erro como uma exceção genérica e expõe falhas intermitentes ao usuário, exatamente a categoria de bug mais difícil de reproduzir, porque só ocorre sob concorrência real.',
     4, 'v1', 'rascunho'),
    ('a3000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'Lock pessimista vs. concorrência otimista',
     'Controlar concorrência com `SELECT ... FOR UPDATE` (lock pessimista) bloqueia outras transações que tentem alterar a mesma linha até o commit, garantindo que não haja conflito, mas ao custo de contenção sob alta concorrência. A alternativa otimista mantém uma coluna de versão (ou timestamp) na linha, deixa as transações prosseguirem sem lock, e só rejeita a escrita no `UPDATE` final se a versão mudou desde a leitura, exigindo que a aplicação reexecute a operação. O critério: prefira lock pessimista quando conflitos são frequentes e o custo de reexecutar a lógica é alto; prefira otimista quando conflitos são raros, para não pagar o custo de bloqueio na maioria das vezes em que não haveria disputa alguma.',
     5, 'v1', 'rascunho');

-- Concept: Replicação, particionamento e CAP
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a3000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'Confundir réplica com backup',
     'Um erro conceitual recorrente é achar que ter réplicas (síncronas ou assíncronas) elimina a necessidade de backup, já que "os dados já estão copiados em outro lugar". Isso parece razoável para falha de hardware — se um nó cai, o outro tem os dados —, mas não protege contra erro lógico: um `DELETE` sem `WHERE`, uma migração malfeita ou uma corrupção de dado são replicados para os seguidores quase tão rápido quanto para o líder, porque a réplica existe para propagar exatamente as mesmas operações, certas ou erradas. Backup (cópias pontuais, imutáveis, restauráveis para um instante no passado) resolve um problema diferente do que replicação resolve, e um não substitui o outro.',
     4, 'v1', 'rascunho'),
    -- OPEN QUESTION-009: para este Concept, "comparação com alternativa" já é abordado nos 3
    -- slides originais (líder-seguidor vs., faixa vs. hash, CP vs. AP); o 5º ângulo escolhido
    -- aqui é "impacto em escala/produção" (quando sharding compensa frente a escalar verticalmente),
    -- mantendo uma perspectiva distinta sem repetir as comparações já feitas.
    ('a3000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'bancos-de-dados'),
     'Sharding vs. escalar verticalmente: quando vale a complexidade',
     'Particionar dados entre vários nós resolve um limite real de capacidade, mas introduz complexidade permanente: consultas que cruzam partições ficam mais caras, junções entre shards deixam de ser triviais, e rebalancear dados conforme o volume cresce é um trabalho operacional contínuo. A alternativa mais simples, e que deveria ser esgotada primeiro, é escalar verticalmente — aumentar CPU, memória e I/O de um único nó —, que não exige nenhuma mudança de modelo de dados nem de aplicação. O critério concreto: mantenha um único nó enquanto o hardware disponível comporta o volume de escrita e leitura com folga operacional; migre para sharding apenas quando o crescimento de dados ou tráfego já ultrapassa o maior nó disponível na prática (ou seu custo deixa de ser viável), não como antecipação especulativa de escala que ainda não chegou.',
     5, 'v1', 'rascunho');
