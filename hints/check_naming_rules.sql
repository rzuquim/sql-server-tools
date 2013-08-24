
-- ===================================
-- Checking some naming rules
-- ===================================

DECLARE @MAX_NAME_SIZE     INT = 30,
        @PrimaryKey_PREFIX VARCHAR(5) = 'PK_%',
        @ForeignKey_PREFIX VARCHAR(5)= 'FK_%',
        @Check_PREFIX      VARCHAR(5) = 'CK_%',
        @Unique_Prefix     VARCHAR(5) = 'UK_%',
        @Default_Prefix    VARCHAR(5) = 'DF_%'

-- Cheking for tables with more than @MAX_NAME_SIZE 
SELECT [schema_name] = SCHEMA_NAME(schema_id),
       [table_name] = t.name
FROM sys.tables t
where len(t.name) > @MAX_NAME_SIZE

-- Cheking for columns with more than @MAX_NAME_SIZE 
SELECT [schema_name] = SCHEMA_NAME(schema_id),
       [table_name] = t.name,
       [column_name] = c.name 
FROM sys.tables t
     INNER JOIN sys.columns c 
             ON t.OBJECT_ID = c.OBJECT_ID 
WHERE len(c.name) > @MAX_NAME_SIZE
ORDER BY schema_name, table_name

-- Cheking for constraints with more than @MAX_NAME_SIZE 
SELECT [schema_name] = SCHEMA_NAME(schema_id),
       [constraint_name] = OBJECT_NAME(OBJECT_ID),
       [constraint_type] = type_desc
FROM sys.objects
WHERE type_desc LIKE '%CONSTRAINT'
      AND len(OBJECT_NAME(OBJECT_ID)) > @MAX_NAME_SIZE

--Verifica se existe alguma constraint (PK, FK ou DF) cujo prefixo não está correto (ex. PK_FOO é uma FOREIGN_KEY)
SELECT [constraint_name] = OBJECT_NAME(OBJECT_ID),
       [schema_name] = SCHEMA_NAME(schema_id),
       [table_name] = OBJECT_NAME(parent_object_id),
       [constraint_type] = type_desc
FROM sys.objects 
WHERE type_desc LIKE '%CONSTRAINT'
      AND NOT ((OBJECT_NAME(OBJECT_ID) LIKE @PrimaryKey_PREFIX AND OBJECT_NAME(OBJECT_ID) <> 'PRIMARY_KEY_CONSTRAINT') OR
               (OBJECT_NAME(OBJECT_ID) LIKE @ForeignKey_PREFIX AND OBJECT_NAME(OBJECT_ID) <> 'FOREIGN_KEY_CONSTRAINT') OR
               (OBJECT_NAME(OBJECT_ID) LIKE @Default_Prefix    AND OBJECT_NAME(OBJECT_ID) <> 'DEFAULT_CONSTRAINT') OR
               (OBJECT_NAME(OBJECT_ID) LIKE @Unique_Prefix     AND OBJECT_NAME(OBJECT_ID) <> 'UNIQUE_CONSTRAINT') OR
               (OBJECT_NAME(OBJECT_ID) LIKE @Check_PREFIX      AND OBJECT_NAME(OBJECT_ID) <> 'CHECK_CONSTRAINT')) 