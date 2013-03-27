
-- =======================================================
-- Retorna todas as referências a uma determinada string em todos os artefatos do banco
-- =======================================================

SELECT DISTINCT o.name, o.xtype
FROM syscomments c
INNER JOIN sysobjects o ON c.id=o.id
WHERE c.TEXT LIKE <query,,'%%'>
