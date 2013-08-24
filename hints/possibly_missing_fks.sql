
-- ====================================
-- Given a FK pattern on the name of a FK-column, searches for missing FKs
-- ====================================

DECLARE @fk_column_suffix VARCHAR(1000) = '%[_]Codigo'

;WITH columns_on_fks AS (
  SELECT c.name, fkc.parent_object_id AS tabela , fk.object_id AS FK_NOME, fkc.parent_column_id AS coluna 
  FROM sys.foreign_keys fk
       INNER JOIN sys.foreign_key_columns fkc 
               ON fk.object_id = fkc.constraint_object_id 
       INNER JOIN sys.columns c
               ON fkc.parent_column_id = c.column_id AND fkc.parent_object_id = c.object_id)

SELECT [Column Name] = c.Name, 
       [Table Name] = object_name(c.object_id)
FROM sys.columns C 
     INNER JOIN sys.tables t 
             ON c.object_id = t.object_id 
      LEFT JOIN columns_on_fks FK
             ON fk.coluna = c.column_id AND fk.tabela = c.object_id
WHERE fk.name IS NULL 
      AND c.name LIKE @fk_column_suffix
ORDER BY object_name(c.object_id)