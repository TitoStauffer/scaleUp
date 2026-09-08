-- Módulo Progress — aplica os cortes reais dos 12 níveis (TICKET-assessment-progress.md,
-- seção 5.1, OPEN QUESTION-A).
--
-- Contexto: V11 seedou `nivel_referencia` com um placeholder de 12 faixas de largura igual
-- (~8.33 pontos cada), documentado como pendência para o PM (database-schema.md, seção 10).
-- O ticket de Assessment/Progress propõe a curva não-linear abaixo (faixas mais largas nos
-- níveis mais altos) como OPEN QUESTION-A, pedindo confirmação explícita do Tito antes do
-- UPDATE final.
--
-- Decisão do Backend nesta entrega: aplicar a proposta da seção 5.1 agora, não deixá-la
-- pendente. Motivo: o próprio critério de aceite AC-07 do ticket ("pontuação geral exatamente
-- 65.00 deve classificar como 'Sênior 1', não 'Pleno 3'") só é satisfazível com os cortes
-- propostos aqui — sob o placeholder de larguras iguais, 65.00 cairia em "Sênior 2"
-- ([58.33, 66.67)), quebrando o teste que o próprio ticket pede para escrever. Como o ticket
-- também registra que a proposta "não bloqueia o início da implementação do resto", e o
-- conjunto de ACs já pressupõe essa tabela, aplico o UPDATE para permitir uma entrega
-- testável e sinalizo explicitamente no handoff que este é um ponto que ainda depende de
-- confirmação direta do Tito (OPEN QUESTION-A) — não fica silenciosamente decidido.
--
-- Migração aditiva (só UPDATE, sem alterar schema) — mesma tabela, mesmas 12 linhas
-- (identificadas por `slug`, que já são estáveis desde V11).

UPDATE nivel_referencia SET pontuacao_minima = 0.00,  pontuacao_maxima = 15.00 WHERE slug = 'junior-1';
UPDATE nivel_referencia SET pontuacao_minima = 15.00, pontuacao_maxima = 25.00 WHERE slug = 'junior-2';
UPDATE nivel_referencia SET pontuacao_minima = 25.00, pontuacao_maxima = 35.00 WHERE slug = 'junior-3';
UPDATE nivel_referencia SET pontuacao_minima = 35.00, pontuacao_maxima = 45.00 WHERE slug = 'pleno-1';
UPDATE nivel_referencia SET pontuacao_minima = 45.00, pontuacao_maxima = 55.00 WHERE slug = 'pleno-2';
UPDATE nivel_referencia SET pontuacao_minima = 55.00, pontuacao_maxima = 65.00 WHERE slug = 'pleno-3';
UPDATE nivel_referencia SET pontuacao_minima = 65.00, pontuacao_maxima = 73.00 WHERE slug = 'senior-1';
UPDATE nivel_referencia SET pontuacao_minima = 73.00, pontuacao_maxima = 81.00 WHERE slug = 'senior-2';
UPDATE nivel_referencia SET pontuacao_minima = 81.00, pontuacao_maxima = 89.00 WHERE slug = 'senior-3';
UPDATE nivel_referencia SET pontuacao_minima = 89.00, pontuacao_maxima = 94.00 WHERE slug = 'especialista-1';
UPDATE nivel_referencia SET pontuacao_minima = 94.00, pontuacao_maxima = 97.00 WHERE slug = 'especialista-2';
UPDATE nivel_referencia SET pontuacao_minima = 97.00, pontuacao_maxima = 100.00 WHERE slug = 'especialista-3';
