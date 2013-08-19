;WITH ColunasQueEstaoNasFK AS (
SELECT 
  c.name, fkc.parent_object_id AS tabela , fk.object_id AS FK_NOME, fkc.parent_column_id AS coluna 
FROM 
  sys.foreign_keys fk
  INNER JOIN sys.foreign_key_columns fkc 
    ON fk.object_id = fkc.constraint_object_id 
  INNER JOIN sys.columns c
    ON fkc.parent_column_id = c.column_id AND fkc.parent_object_id = c.object_id
)
--,ColunasQueEstaoNaPK AS (
--SELECT 
--  ic.*
--FROM 
--  sys.index_columns ic 
--  INNER JOIN sys.indexes i 
--    ON ic.index_id = i.index_id  AND ic.object_id = i.object_id AND i.is_primary_key = 1
--  
--)

SELECT 
  
   c.Name, 
  object_name(c.object_id) AS Tabela
FROM
  sys.columns C 
  INNER JOIN sys.tables t 
    ON C.object_id = t.object_id 
  LEFT OUTER JOIN ColunasQueEstaoNasFK FK
    ON fk.coluna = c.column_id AND fk.tabela = c.object_id
--  LEFT OUTER JOIN ColunasQueEstaoNaPK PK 
--    ON FK.Coluna = pk.column_id  AND fk.tabela = pk.object_id 
WHERE 
  fk.name IS NULL 
  --AND pk.object_id IS NULL 
  AND c.name LIKE '%[_]Codigo'
ORDER BY tabela