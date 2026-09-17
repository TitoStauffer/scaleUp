-- Ampliação do pool de Slides — Domínio Arquitetura (slug 'arquitetura'), Fase 1.
-- TICKET-content-expansion-slides-fase1.md: adiciona 2 Slides novos por Concept (ordem 4 =
-- erros comuns/armadilhas, ordem 5 = comparação com alternativa) às 3 já existentes em
-- V14__seed_conteudo_arquitetura.sql, elevando o pool para 5 Slides por Concept / 25 no domínio.

-- Concept: Estilos Arquiteturais e Camadas
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a2000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Erro comum: achar que mais camadas é sempre mais organizado',
     'Um erro frequente é tratar "adicionar camadas" como sinônimo de "melhorar a arquitetura". Um time pode introduzir uma camada de "Facade" entre Controller e Service, ou um DTO intermediário entre Service e Repository, sem que essa camada agregue nenhuma regra ou tradução real — ela só repassa a chamada adiante com um nome diferente. Isso parece disciplina arquitetural porque segue "o padrão do livro", mas na prática aumenta o número de arquivos que precisam mudar a cada nova funcionalidade sem reduzir acoplamento real, já que a dependência entre as responsabilidades de negócio continua a mesma — só foi espalhada por mais lugares.',
     4, 'v1', 'rascunho'),
    ('a2000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Camadas em vez de pipe-and-filter: quando um fluxo de transformação sequencial é mais natural',
     'Arquitetura em camadas organiza responsabilidades por tipo (apresentação, negócio, dados), mas nem todo sistema tem esse formato: um pipeline de processamento de dados (ex.: ingestão de arquivo → validação → transformação → enriquecimento → gravação) se encaixa melhor no estilo pipe-and-filter, em que cada estágio consome a saída do anterior e produz uma entrada para o próximo, independentemente de "camada" de negócio. O critério concreto para escolher: se o sistema é organizado em torno de uma sequência de transformações sobre um mesmo dado (ETL, processamento de imagem, compiladores), pipe-and-filter tende a expressar o fluxo real melhor do que forçar esse fluxo dentro de Controller/Service/Repository; se o sistema é organizado em torno de responsabilidades de negócio distintas sobre múltiplas entidades, camadas continuam mais adequadas.',
     5, 'v1', 'rascunho');

-- Concept: Monólito vs. Microsserviços
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a2000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Erro comum: extrair microsserviços ao longo das linhas técnicas, não de domínio',
     'Um erro conceitual frequente é dividir os serviços por camada técnica (um "serviço de banco de dados", um "serviço de validação", um "serviço de autenticação genérico" compartilhado por tudo) em vez de por fronteira de domínio de negócio (pedidos, pagamento, catálogo). Isso parece razoável porque reaproveita código e evita duplicação de lógica técnica, mas na prática cria um sistema distribuído com o mesmo acoplamento forte de um monólito — só que agora as chamadas entre essas responsabilidades acopladas cruzam a rede, somando a lentidão e a fragilidade da comunicação distribuída ao acoplamento que já existia antes, sem ganhar a autonomia de deploy que era o objetivo original de migrar para microsserviços.',
     4, 'v1', 'rascunho'),
    ('a2000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Alternativa intermediária: modular monolith com deploys independentes por módulo (release trains)',
     'Além do par "monólito puro" e "microsserviços completos", existe uma alternativa que muitos times ignoram: manter um monólito modular, mas com pipelines de build e teste independentes por módulo, aceitando que o deploy final ainda seja de um único artefato coordenado (um "release train" periódico). O critério concreto para escolher essa alternativa em vez de ir direto a microsserviços: se o principal problema do time é velocidade de desenvolvimento e teste (builds lentos, conflitos de merge, times pisando no código um do outro) mas não há necessidade real de escalar partes do sistema de forma independente em produção, o release train resolve a dor organizacional sem pagar o custo operacional de infraestrutura distribuída que os microsserviços exigem.',
     5, 'v1', 'rascunho');

-- Concept: Acoplamento, Coesão e Modularização
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a2000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Erro comum: confundir "poucas dependências declaradas" com baixo acoplamento',
     'Um erro conceitual comum é medir acoplamento só pelo número de imports ou chamadas diretas entre módulos, ignorando o acoplamento implícito: dois módulos que não se chamam diretamente, mas leem e escrevem na mesma tabela de banco de dados, ou que dependem de uma mesma ordem de execução assumida sem estar documentada, estão fortemente acoplados mesmo sem nenhuma dependência visível no código. Isso engana porque o código "parece" desacoplado à primeira vista (nenhum módulo importa o outro), mas uma mudança no formato dos dados de um módulo quebra o outro silenciosamente, exatamente o sintoma que o design de baixo acoplamento deveria evitar.',
     4, 'v1', 'rascunho'),
    ('a2000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Modularização por camada técnica vs. por domínio de negócio (bounded context)',
     'Uma alternativa de modularização, mais comum em bases de código mais antigas, é dividir pacotes por camada técnica (um pacote "controllers", um pacote "services", um pacote "repositories") em vez de por domínio de negócio (um pacote "pedidos" contendo seu próprio controller, service e repository). O critério concreto de escolha: modularização por camada técnica facilita encontrar "todos os controllers" rapidamente, mas espalha uma mesma funcionalidade de negócio por vários pacotes, tornando alterações que cruzam camadas mais difíceis de rastrear; modularização por domínio (bounded context, como no design orientado a domínio) agrupa tudo que muda junto por motivo de negócio no mesmo lugar, o que tende a escalar melhor conforme o número de funcionalidades cresce, ao custo de uma curva de aprendizado inicial maior para quem só conhece a organização por camada técnica.',
     5, 'v1', 'rascunho');

-- Concept: Padrões Arquiteturais
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a2000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Erro comum: aplicar CQRS e event-driven juntos sem precisar de nenhum dos dois',
     'Um erro recorrente é adotar CQRS combinado com event-driven architecture (o modelo de escrita publica eventos que atualizam o modelo de leitura de forma assíncrona) só porque essa combinação aparece com frequência em artigos e talks sobre sistemas de grande escala. Isso parece uma boa prática por vir de empresas conhecidas, mas introduz consistência eventual e complexidade de sincronização entre os dois modelos mesmo quando o sistema não tem nenhuma divergência real entre padrões de leitura e escrita — o time paga o custo (mais infraestrutura, bugs de sincronização, dificuldade de debugar "por que a tela ainda mostra o dado antigo") sem ter o problema que justificaria o padrão.',
     4, 'v1', 'rascunho'),
    ('a2000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Arquitetura hexagonal vs. camadas tradicionais: quando o núcleo precisa ser independente de framework',
     'Arquitetura em camadas tradicional (Controller → Service → Repository) e arquitetura hexagonal resolvem um problema parecido — isolar regra de negócio de detalhes técnicos — mas hexagonal vai além ao inverter a dependência: o núcleo de negócio não conhece nem o framework web nem o banco, apenas interfaces que ele define. O critério concreto para escolher hexagonal em vez de camadas tradicionais: se o time espera trocar de tecnologia com frequência (ex.: múltiplas interfaces de entrada, como REST e mensageria, para a mesma regra de negócio, ou alta prioridade de testar a regra de negócio sem subir infraestrutura real), hexagonal compensa a complexidade extra de definir portas e adaptadores; para uma API CRUD simples com baixa expectativa de mudança tecnológica, camadas tradicionais já entregam separação suficiente com menos indireção.',
     5, 'v1', 'rascunho');

-- Concept: Evolução de Arquitetura e Trade-offs
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a2000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Erro comum: escrever ADR só depois que a decisão já foi implementada',
     'Um erro conceitual frequente é tratar o ADR como documentação retroativa — escrita depois que o código já está em produção, resumindo a decisão que já foi tomada. Isso parece cumprir a prática ("temos ADRs, olha") mas perde o valor central do processo: um ADR escrito antes da implementação obriga o autor a listar as alternativas que foram descartadas e por quê, o que frequentemente revela, ainda em fase de decisão, um risco ou uma alternativa melhor que não tinha sido considerada. Escrito depois, o ADR vira uma justificativa a posteriori da escolha já feita, com viés de confirmação, em vez de uma ferramenta real de decisão.',
     4, 'v1', 'rascunho'),
    -- OPEN QUESTION-009: "comparação com alternativa" não se aplica bem a este Concept, que já é
    -- sobre comparar/justificar trade-offs em si (redundante com os 3 slides originais). Trocado
    -- pelo ângulo "impacto em produção/entrevista" sugerido no ticket: como a ausência de registro
    -- de decisão se manifesta como problema concreto depois que o sistema já está em produção.
    ('a2000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'arquitetura'),
     'Impacto em produção: o custo de decisões arquiteturais não documentadas',
     'Sem ADRs (ou processo equivalente), decisões arquiteturais importantes sobrevivem apenas na memória de quem as tomou. Na prática isso aparece como: um engenheiro novo reverte uma escolha que parecia "estranha" sem saber que ela evitava um problema de concorrência já resolvido antes, ou o time re-discute do zero uma decisão já tomada há um ano porque ninguém lembra o motivo original, gastando tempo de reunião que poderia ter sido evitado com uma consulta de cinco minutos a um documento. Esse custo cresce com o tempo de vida do sistema e com a rotatividade do time — é menor em um projeto de três meses com o mesmo time desde o início, e maior em um sistema de produção de vários anos que já passou por múltiplas gerações de engenheiros.',
     5, 'v1', 'rascunho');
