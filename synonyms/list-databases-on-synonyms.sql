
--- ===========
-- Verifica todos os bancos apontados pelos sinônimos
--- ===========

SELECT DISTINCT
	[Database] = COALESCE(PARSENAME(base_object_name,3),DB_NAME(DB_ID())), 
	[Schema] = COALESCE(PARSENAME(base_object_name,2),SCHEMA_NAME(SCHEMA_ID()))
FROM sys.synonyms 