-- Módulo Content — adiciona ordem pedagógica a Concept.
-- Achado (revisão de código independente): ConceptRepository ordenava por título
-- alfabético, quebrando a sequência pedagógica autorada por cada agente de conteúdo
-- (ex.: em Arquitetura, "Acoplamento" aparecia antes de "Estilos", invertendo a ordem
-- intencional). Slide já tem uma coluna `ordem` (V4); esta migração traz a mesma ideia
-- para Concept, na granularidade "ordem do Concept dentro do Domain".
--
-- Migração aditiva em 3 passos (coluna nullable -> backfill -> NOT NULL + constraints),
-- para nunca deixar uma linha existente inconsistente durante a aplicação da migração.
--
-- Os valores de `ordem` abaixo replicam a ordem literal de aparição de cada Concept no
-- bloco `INSERT INTO concept` do respectivo arquivo de seed (V14 a V20) — essa ordem de
-- aparição é a sequência pedagógica pretendida pelo autor de cada domínio.

-- =====================================================================================
-- 1. Coluna nova, nullable
-- =====================================================================================

ALTER TABLE concept ADD COLUMN ordem integer;

-- =====================================================================================
-- 2. Backfill — um UPDATE por Concept, usando os UUIDs literais definidos nos seeds
-- =====================================================================================

-- Domínio: arquitetura (V14)
UPDATE concept SET ordem = 1 WHERE id = 'a2000000-0000-4000-8000-000000000001'; -- Estilos Arquiteturais e Camadas
UPDATE concept SET ordem = 2 WHERE id = 'a2000000-0000-4000-8000-000000000002'; -- Monólito vs. Microsserviços
UPDATE concept SET ordem = 3 WHERE id = 'a2000000-0000-4000-8000-000000000003'; -- Acoplamento, Coesão e Modularização
UPDATE concept SET ordem = 4 WHERE id = 'a2000000-0000-4000-8000-000000000004'; -- Padrões Arquiteturais
UPDATE concept SET ordem = 5 WHERE id = 'a2000000-0000-4000-8000-000000000005'; -- Evolução de Arquitetura e Trade-offs

-- Domínio: sistemas-distribuidos (V15)
UPDATE concept SET ordem = 1 WHERE id = 'b1a1c1a0-0001-4000-8000-000000000001'; -- CAP Theorem e trade-offs de consistência
UPDATE concept SET ordem = 2 WHERE id = 'b1a1c1a0-0002-4000-8000-000000000002'; -- Replicação e modelos de consistência
UPDATE concept SET ordem = 3 WHERE id = 'b1a1c1a0-0003-4000-8000-000000000003'; -- Consenso distribuído: Paxos e Raft
UPDATE concept SET ordem = 4 WHERE id = 'b1a1c1a0-0004-4000-8000-000000000004'; -- Particionamento e sharding de dados
UPDATE concept SET ordem = 5 WHERE id = 'b1a1c1a0-0005-4000-8000-000000000005'; -- Relógios lógicos, ordenação de eventos e tolerância a falhas

-- Domínio: bancos-de-dados (V16)
UPDATE concept SET ordem = 1 WHERE id = 'a3000000-0000-4000-8000-000000000001'; -- Modelagem relacional vs. NoSQL
UPDATE concept SET ordem = 2 WHERE id = 'a3000000-0000-4000-8000-000000000002'; -- Indexação e desempenho de consultas
UPDATE concept SET ordem = 3 WHERE id = 'a3000000-0000-4000-8000-000000000003'; -- Transações e ACID
UPDATE concept SET ordem = 4 WHERE id = 'a3000000-0000-4000-8000-000000000004'; -- Níveis de isolamento e controle de concorrência
UPDATE concept SET ordem = 5 WHERE id = 'a3000000-0000-4000-8000-000000000005'; -- Replicação, particionamento e CAP

-- Domínio: apis-mensageria (V17)
UPDATE concept SET ordem = 1 WHERE id = 'a4000000-0000-4000-8000-000000000001'; -- Design de contratos REST
UPDATE concept SET ordem = 2 WHERE id = 'a4000000-0000-4000-8000-000000000002'; -- Versionamento e evolução de APIs
UPDATE concept SET ordem = 3 WHERE id = 'a4000000-0000-4000-8000-000000000003'; -- Idempotência em APIs
UPDATE concept SET ordem = 4 WHERE id = 'a4000000-0000-4000-8000-000000000004'; -- Filas e brokers de mensagens
UPDATE concept SET ordem = 5 WHERE id = 'a4000000-0000-4000-8000-000000000005'; -- Garantias de entrega e ordenação

-- Domínio: escalabilidade-desempenho (V18)
UPDATE concept SET ordem = 1 WHERE id = 'a1000000-0000-4000-8000-000000000001'; -- Escalabilidade horizontal vs. vertical
UPDATE concept SET ordem = 2 WHERE id = 'a1000000-0000-4000-8000-000000000002'; -- Caching e estratégias de invalidação
UPDATE concept SET ordem = 3 WHERE id = 'a1000000-0000-4000-8000-000000000003'; -- Balanceamento de carga
UPDATE concept SET ordem = 4 WHERE id = 'a1000000-0000-4000-8000-000000000004'; -- Particionamento e distribuição de tráfego
UPDATE concept SET ordem = 5 WHERE id = 'a1000000-0000-4000-8000-000000000005'; -- Otimização de latência, throughput e rate limiting

-- Domínio: observabilidade-confiabilidade (V19)
UPDATE concept SET ordem = 1 WHERE id = 'a1a10000-0000-4000-8000-000000000001'; -- Logging estruturado
UPDATE concept SET ordem = 2 WHERE id = 'a1a10000-0000-4000-8000-000000000002'; -- Métricas e monitoramento
UPDATE concept SET ordem = 3 WHERE id = 'a1a10000-0000-4000-8000-000000000003'; -- Tracing distribuído
UPDATE concept SET ordem = 4 WHERE id = 'a1a10000-0000-4000-8000-000000000004'; -- SLIs, SLOs e SLAs
UPDATE concept SET ordem = 5 WHERE id = 'a1a10000-0000-4000-8000-000000000005'; -- Tolerância a falhas e recuperação

-- Domínio: seguranca (V20)
UPDATE concept SET ordem = 1 WHERE id = 'a5000000-0000-4000-8000-000000000001'; -- Autenticação e Autorização
UPDATE concept SET ordem = 2 WHERE id = 'a5000000-0000-4000-8000-000000000002'; -- Criptografia Aplicada
UPDATE concept SET ordem = 3 WHERE id = 'a5000000-0000-4000-8000-000000000003'; -- TLS e Segurança em Trânsito
UPDATE concept SET ordem = 4 WHERE id = 'a5000000-0000-4000-8000-000000000004'; -- Vulnerabilidades Comuns em Aplicações Web
UPDATE concept SET ordem = 5 WHERE id = 'a5000000-0000-4000-8000-000000000005'; -- Defesa em Profundidade e Controle de Abuso

-- =====================================================================================
-- 3. NOT NULL + constraints de integridade (mesmo padrão de slide.ordem, ver V4)
-- =====================================================================================

ALTER TABLE concept ALTER COLUMN ordem SET NOT NULL;

ALTER TABLE concept ADD CONSTRAINT uq_concept_domain_ordem UNIQUE (domain_ref, ordem);
ALTER TABLE concept ADD CONSTRAINT ck_concept_ordem_positiva CHECK (ordem >= 1);
