-- Módulo Identity — perfil do usuário (TICKET-perfil-usuario.md, seção 8)
--
-- Três colunas aditivas em app_user, todas NULL-able (mesmo padrão de V33 para nome/senha_hash):
-- data_nascimento é puramente informativa (nenhuma regra de negócio depende dela, decisão
-- fechada com o Tito, seção 5.2 do ticket); foto_perfil/foto_perfil_content_type guardam o
-- binário da foto direto no Postgres (decisão fechada: sem storage externo, seção 5.3).

ALTER TABLE app_user
    ADD COLUMN data_nascimento date NULL,
    ADD COLUMN foto_perfil bytea NULL,
    ADD COLUMN foto_perfil_content_type varchar(50) NULL;

-- Só os tipos de imagem aceitos pelo upload (seção 5.3) — reforça no banco a mesma regra já
-- validada na aplicação, evitando que um caminho de escrita futuro burle a validação.
ALTER TABLE app_user
    ADD CONSTRAINT ck_app_user_foto_perfil_content_type
        CHECK (foto_perfil_content_type IS NULL
            OR foto_perfil_content_type IN ('image/jpeg', 'image/png', 'image/webp'));

-- Garante consistência entre os dois campos: não existe imagem sem content-type nem
-- content-type sem imagem — os dois são sempre definidos ou limpos juntos pela aplicação.
ALTER TABLE app_user
    ADD CONSTRAINT ck_app_user_foto_perfil_consistente
        CHECK ((foto_perfil IS NULL) = (foto_perfil_content_type IS NULL));
