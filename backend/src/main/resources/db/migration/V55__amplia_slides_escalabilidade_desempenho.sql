-- Ampliação do pool de Slides — Domínio Escalabilidade e Desempenho (slug 'escalabilidade-desempenho'), Fase 1.
-- TICKET-content-expansion-slides-fase1.md: adiciona 2 Slides novos por Concept (ordem 4 =
-- erros comuns/armadilhas, ordem 5 = comparação com alternativa) às 3 já existentes em
-- V18__seed_conteudo_escalabilidade_desempenho.sql, elevando o pool para 5 Slides por Concept / 25 no domínio.

-- Concept: Escalabilidade horizontal vs. vertical
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a1000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'O erro de "escalar horizontal" sem remover estado local',
     'Um erro comum é adicionar mais instâncias de uma aplicação (scale out) sem antes eliminar o estado guardado em memória local, como sessão de usuário ou cache não compartilhado. Parece que o sistema "escalou" porque agora há mais máquinas atendendo requisições, mas na prática cada instância só consegue atender corretamente os usuários que já passaram por ela, forçando o uso de sticky sessions como remendo. Isso mascara o problema em vez de resolvê-lo: se uma instância cair, todo o estado local dela se perde, e o sistema continua tão frágil quanto uma única máquina, só que com mais partes móveis para falhar.',
     4, 'v1', 'rascunho'),
    ('a1000000-0000-4000-8000-000000000001',
     (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'Escalar automaticamente (auto scaling) vs. provisionar capacidade fixa',
     'Uma alternativa a manter uma frota fixa de máquinas dimensionada para o pico é usar auto scaling, que adiciona ou remove instâncias automaticamente conforme métricas como CPU ou fila de requisições. Capacidade fixa é mais simples de prever em custo e comportamento, e faz sentido quando a carga é estável e previsível. Auto scaling compensa o custo operacional adicional (é preciso lidar com boot time de novas instâncias, warm-up de cache e métricas confiáveis de gatilho) quando a carga tem picos e vales significativos — por exemplo, tráfego que cresce 10x em horário comercial ou em campanhas pontuais, onde manter capacidade de pico o tempo todo desperdiçaria recursos na maior parte do dia.',
     5, 'v1', 'rascunho');

-- Concept: Caching e estratégias de invalidação
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a1000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'O erro de cachear dados sem considerar quem mais os lê',
     'Um erro frequente é definir TTL e estratégia de invalidação olhando apenas para o caminho de escrita que gerou o dado, sem considerar todos os outros pontos do sistema que também leem e potencialmente cacheiam a mesma informação. Parece seguro invalidar o cache no serviço que fez a alteração, mas se outro serviço, ou uma camada de CDN, mantém sua própria cópia com TTL independente, o dado desatualizado continua sendo servido em outro lugar mesmo após a invalidação "bem-sucedida". O resultado é uma inconsistência intermitente e difícil de depurar, porque o sintoma aparece longe de onde a escrita ocorreu.',
     4, 'v1', 'rascunho'),
    ('a1000000-0000-4000-8000-000000000002',
     (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'Cache local por instância vs. cache distribuído compartilhado',
     'Cache local (in-process, na memória da própria aplicação) tem latência de acesso praticamente nula, pois evita qualquer salto de rede, mas cada instância mantém sua própria cópia, o que multiplica o uso de memória e gera inconsistência entre instâncias até que cada uma individualmente invalide ou expire sua entrada. Cache distribuído (ex.: Redis compartilhado) mantém uma única cópia vista por todas as instâncias, facilitando invalidação consistente, ao custo de uma chamada de rede por acesso. A escolha depende do padrão de leitura: dados pequenos, lidos com altíssima frequência e que toleram alguma inconsistência entre instâncias (ex.: feature flags) favorecem cache local; dados que exigem uma única fonte de verdade compartilhada entre instâncias favorecem cache distribuído.',
     5, 'v1', 'rascunho');

-- Concept: Balanceamento de carga
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a1000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'O erro de configurar health check superficial demais',
     'Um erro comum é configurar o health check do load balancer para apenas verificar se o processo da aplicação responde (ex.: um endpoint que sempre retorna 200), sem checar se as dependências críticas da instância (banco de dados, cache, filas) estão realmente acessíveis. Parece suficiente porque a instância "está de pé" e responde à sondagem, mas ela pode estar incapaz de processar requisições reais por não conseguir falar com o banco, e o load balancer continua roteando tráfego normalmente para ela. O sistema aparenta estar saudável nos painéis de monitoramento enquanto uma fração real das requisições falha silenciosamente.',
     4, 'v1', 'rascunho'),
    ('a1000000-0000-4000-8000-000000000003',
     (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'Load balancer dedicado vs. balanceamento client-side',
     'Um load balancer dedicado (proxy ou hardware, como um ALB ou nginx) centraliza a decisão de roteamento em um componente separado, o que simplifica a lógica dos serviços clientes mas introduz um salto de rede extra e potencialmente um novo ponto de contenção. Balanceamento client-side, comum em arquiteturas de microsserviços internos, embute a lógica de escolha de instância diretamente no cliente (que consulta um registro de serviços), eliminando o salto extra de rede. A escolha depende de quem são os clientes: tráfego externo, vindo de navegadores ou apps de terceiros, exige um load balancer dedicado na borda, pois não é viável embutir lógica de descoberta de serviço no cliente; comunicação interna entre serviços do mesmo sistema, onde ambos os lados são controlados pela mesma equipe, pode se beneficiar da menor latência do balanceamento client-side.',
     5, 'v1', 'rascunho');

-- Concept: Particionamento e distribuição de tráfego
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a1000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'O erro de particionar por um campo de baixa cardinalidade',
     'Um erro conceitual comum é escolher como chave de partição um campo com poucos valores possíveis, como "região" (quando existem apenas 3 ou 4 regiões atendidas) ou "status do pedido". Parece razoável porque o campo é relevante para o negócio e frequentemente usado em filtros, mas com poucos valores distintos o número de partições fica limitado ao número de valores da chave, e a distribuição de carga entre eles raramente é uniforme — uma região ou status concentra naturalmente mais volume que os demais. O sistema "parece" particionado, mas na prática recria o mesmo gargalo de antes dentro da maior partição.',
     4, 'v1', 'rascunho'),
    ('a1000000-0000-4000-8000-000000000004',
     (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'Particionamento por hash vs. particionamento por intervalo (range)',
     'Particionamento por hash aplica uma função de hash à chave para decidir a partição, distribuindo os dados de forma uniforme e evitando hot spots relacionados à ordem de inserção, mas torna consultas por intervalo (ex.: "todos os pedidos entre duas datas") ineficientes, pois exigem consultar todas as partições. Particionamento por intervalo mantém dados com chaves próximas na mesma partição, o que torna consultas por intervalo eficientes (tocam poucas partições), mas é mais vulnerável a hot spots quando as inserções seguem uma ordem crescente natural, como timestamps, concentrando toda escrita recente em uma única partição "quente". A escolha depende do padrão de acesso dominante: se a maioria das consultas busca por intervalos (séries temporais, históricos ordenados), range compensa o risco de hot spot; se o acesso é majoritariamente por chave exata e distribuição uniforme importa mais, hash é a escolha mais segura.',
     5, 'v1', 'rascunho');

-- Concept: Otimização de latência, throughput e rate limiting
INSERT INTO slide (concept_ref, domain_ref, titulo, conteudo, ordem, content_version, status_revisao)
VALUES
    ('a1000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'O erro de paralelizar chamadas que competem pelo mesmo recurso',
     'Um erro comum ao tentar reduzir latência é paralelizar indiscriminadamente todas as chamadas de uma requisição, presumindo que "mais paralelismo é sempre mais rápido". Isso parece correto quando as chamadas são de fato independentes, mas se várias delas competem pelo mesmo recurso limitado — como o mesmo pool de conexões de banco de dados ou a mesma CPU de uma instância pequena —, o paralelismo apenas cria contenção adicional: as chamadas passam a disputar o recurso entre si em vez de executar de fato em paralelo, e a latência total pode piorar em vez de melhorar, além de esgotar o pool de conexões para outras requisições concorrentes no sistema.',
     4, 'v1', 'rascunho'),
    ('a1000000-0000-4000-8000-000000000005',
     (SELECT id FROM domain WHERE slug = 'escalabilidade-desempenho'),
     'Rate limiting vs. circuit breaker como proteção contra sobrecarga',
     'Rate limiting protege o sistema limitando quanto um cliente específico pode chamar, atuando na origem do tráfego (por usuário, API key ou IP) independentemente da saúde do sistema no momento. Circuit breaker protege o sistema "desligando" temporariamente chamadas a uma dependência que já está falhando ou lenta, atuando na saúde observada do destino, não na identidade de quem chama. Rate limiting é o critério certo quando o objetivo é impedir que um cliente específico consuma mais que sua cota justa de capacidade (ex.: um único tenant abusando de uma API multi-tenant); circuit breaker é o critério certo quando o problema é uma dependência downstream degradada, e o objetivo é parar de sobrecarregá-la ainda mais e falhar rápido em vez de empilhar requisições que provavelmente vão expirar.',
     5, 'v1', 'rascunho');
