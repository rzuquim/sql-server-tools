
-- =======================================================
-- Remove sinônimos que não obedeçam ao critério abaixo
-- =======================================================

DECLARE @synonym_cont INT,
        @sql VARCHAR(1000)
DECLARE @not_in TABLE (
          synonym_name VARCHAR(100)
        )
        
INSERT INTO @not_in (synonym_name)
SELECT 'AuditoriaDado'

SELECT @synonym_cont = count(name)
FROM sys.synonyms
WHERE name NOT IN (SELECT synonym_name FROM @not_in)

WHILE (@synonym_cont > 0 )
BEGIN
  
  SELECT TOP 1 @sql = 'drop synonym ' + name
  FROM sys.synonyms
  WHERe name NOT IN (SELECT synonym_name FROM @not_in)
  
  EXEC(@sql)
  
  SELECT @synonym_cont = count(name)
  FROM sys.synonyms
  WHERE name NOT IN (SELECT synonym_name FROM @not_in)
END 
GO
