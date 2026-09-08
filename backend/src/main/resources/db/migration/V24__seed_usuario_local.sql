-- Módulo Identity — usuário único/local do MVP.
--
-- O PRD e o ticket de Assessment/Progress assumem um único usuário local, sem autenticação
-- real neste estágio (Identity não implementa login). Em vez de inventar um mecanismo de
-- autenticação fora de escopo, a aplicação resolve "o usuário atual" consultando este único
-- registro por e-mail fixo (ver identity.application.CurrentUserProvider). Quando
-- autenticação real for implementada, este seed deixa de ser necessário e a resolução do
-- usuário passa a vir do contexto de autenticação — migração aditiva, sem impacto retroativo
-- (mesma lógica já registrada em V8 para app_user).

INSERT INTO app_user (email, nome)
VALUES ('local@scaleup.dev', 'Usuário Local')
ON CONFLICT (email) DO NOTHING;
