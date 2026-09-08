-- Seed dos 7 domínios do MVP (Backend Engineer).
-- Pré-requisito para os 7 arquivos de seed de conteúdo por domínio (V14 a V20), que
-- referenciam estas linhas por subquery em domain.slug — nunca inserem em domain
-- (ver docs/architecture/implementation-plan-backend-infra.md, seção 2).
-- Slugs exatos conforme reservado no plano do Architect.
-- content_version = 'v1' e status_revisao = 'rascunho' (padrão da tabela, explicitado
-- aqui): autoria por IA, revisão humana ainda não realizada.

INSERT INTO domain (slug, nome, descricao, content_version, status_revisao)
VALUES
    ('arquitetura',
     'Arquitetura',
     'Padrões e decisões de arquitetura de software para sistemas de larga escala: estilos arquiteturais, trade-offs e como estruturar sistemas para evoluir com segurança.',
     'v1', 'rascunho'),
    ('sistemas-distribuidos',
     'Sistemas Distribuídos',
     'Fundamentos de sistemas distribuídos: consistência, disponibilidade, particionamento, consenso e as dificuldades inerentes a coordenar múltiplos nós.',
     'v1', 'rascunho'),
    ('bancos-de-dados',
     'Bancos de Dados',
     'Modelagem, indexação, transações e escolha entre bancos relacionais e não relacionais para diferentes cargas de trabalho.',
     'v1', 'rascunho'),
    ('apis-mensageria',
     'APIs e Mensageria',
     'Design de APIs (REST, RPC) e comunicação assíncrona via filas e mensageria entre serviços.',
     'v1', 'rascunho'),
    ('escalabilidade-desempenho',
     'Escalabilidade e Desempenho',
     'Técnicas de escalabilidade horizontal e vertical, caching, balanceamento de carga e otimização de desempenho em sistemas de alto volume.',
     'v1', 'rascunho'),
    ('observabilidade-confiabilidade',
     'Observabilidade e Confiabilidade',
     'Monitoramento, logging, tracing, tolerância a falhas e práticas para manter sistemas confiáveis em produção.',
     'v1', 'rascunho'),
    ('seguranca',
     'Segurança',
     'Princípios de segurança em sistemas distribuídos: autenticação, autorização, criptografia e proteção contra ameaças comuns.',
     'v1', 'rascunho')
ON CONFLICT (slug) DO NOTHING;
