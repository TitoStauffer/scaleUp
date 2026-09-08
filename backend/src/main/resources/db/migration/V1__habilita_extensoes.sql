-- Habilita gen_random_uuid(), usada como padrão de geração de chave primária em todas as
-- tabelas do projeto (ver docs/architecture/database-schema.md, seção "Padrão de chave
-- primária").
CREATE EXTENSION IF NOT EXISTS pgcrypto;
