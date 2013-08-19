declare @MAX_CHAR INT; --número máximo de caracteres permitidos no nome de algum atributo do banco
set @MAX_CHAR = 30;

-- Verifica se existe alguma tabela cujo nome possui mais de @MAX_CHAR caracteres
SELECT t.name AS table_name,
SCHEMA_NAME(schema_id) AS schema_name
FROM sys.tables t
where len(t.name) > @MAX_CHAR

-- Verifica se existe alguma coluna de tabela cujo nome possui mais de @MAX_CHAR caracteres
SELECT t.name AS table_name,
SCHEMA_NAME(schema_id) AS schema_name,
c.name AS column_name
FROM sys.tables AS t
INNER JOIN sys.columns c ON t.OBJECT_ID = c.OBJECT_ID 
where len(c.name) > @MAX_CHAR
ORDER BY schema_name, table_name

--Verifica se existe alguma constraint (PK, FK ou DF) cujo nome possui mais de @MAX_CHAR caracteres
select * from (
SELECT OBJECT_NAME(OBJECT_ID) AS constraint_name,
SCHEMA_NAME(schema_id) AS schema_name,
OBJECT_NAME(parent_object_id) AS table_name,
type_desc AS constraint_type
FROM sys.objects
WHERE type_desc LIKE '%CONSTRAINT'
) a where len(constraint_name) > @MAX_CHAR

--Verifica se existe alguma constraint (PK, FK ou DF) cujo prefixo não está correto (ex. PK_FOO é uma FOREIGN_KEY)
select * from (
SELECT OBJECT_NAME(OBJECT_ID) AS constraint_name,
SCHEMA_NAME(schema_id) AS schema_name,
OBJECT_NAME(parent_object_id) AS table_name,
type_desc AS constraint_type
FROM sys.objects 
WHERE type_desc LIKE '%CONSTRAINT'
) a
where (constraint_name like 'PK_%' and constraint_type <> 'PRIMARY_KEY_CONSTRAINT') or
	  (constraint_name like 'FK_%' and constraint_type <> 'FOREIGN_KEY_CONSTRAINT') or
	  (constraint_name like 'DF_%' and constraint_type <> 'DEFAULT_CONSTRAINT') or
	  (constraint_name like 'UK_%' and constraint_type <> 'UNIQUE_CONSTRAINT') or
	  not (constraint_name like 'PK_%' or constraint_name like 'FK_%' or constraint_name like 'DF_%' or constraint_name like 'UK_%')

go
