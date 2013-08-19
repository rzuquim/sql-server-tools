
DROP TABLE #PKsUniqueClustered
DROP TABLE #FKsEnvolvidas

CREATE TABLE #PKsUniqueClustered (
  rownum INT IDENTITY(1,1),
  Table_Name VARCHAR(4000),
  PK_Name VARCHAR(4000) ,
  Column_Name VARCHAR(4000),
  SchemaName VARCHAR(4000)
);

CREATE TABLE #FKsEnvolvidas (
  rownum INT IDENTITY(1,1),
  FK_Name VARCHAR(4000),
  SRC_Schema VARCHAR(1000),
  SRC_Tabela VARCHAR(1000),
  SRC_Column VARCHAR(1000),
  TRG_Schema VARCHAR(1000),
  TRG_Tabela VARCHAR(1000),
  TRG_Column VARCHAR(1000)
);

-- ===========================
-- Pks problemáticas com UNIQUEIDENTIFIER
-- ===========================
INSERT INTO #PKsUniqueClustered (SchemaName, Table_Name, PK_Name, Column_Name)
SELECT t.SchemaName, t.Table_Name, t.PK_Name, t.Column_Name
FROM (SELECT [SchemaName] = OBJECT_SCHEMA_NAME(i.object_id),
             [Table_Name] = object_Name(i.object_id), 
             [PK_Name] = i.name,
             [Column_Name] = STUFF((SELECT ',' + CAST(c.name AS VARCHAR) 
                                    FROM sys.index_columns ic
                                         INNER JOIN sys.all_columns c 
                                                 ON ic.object_id = c.object_id 
                                                    AND ic.column_id = c.column_id 
                                    WHERE i.index_id = ic.index_id
                                          AND i.object_id = ic.object_id
                                    FOR XML PATH('')), 1, 1, '')
  FROM sys.indexes i
       INNER JOIN sys.index_columns ic_guid
               ON i.index_id = ic_guid.index_id
                  AND i.object_id = ic_guid.object_id
       INNER JOIN sys.all_columns c_guid
               ON ic_guid.object_id = c_guid.object_id 
                  AND ic_guid.column_id = c_guid.column_id 
                  AND c_guid.system_type_id = 36 -- system_type = 36 significa coluna UNIQUEIDENTIFIER
  WHERE i.is_primary_key = 1 
        AND i.type = 1) t-- type = 1 significa índice clustered WHERE Column_Name IS NOT NULL
WHERE Column_Name IS NOT NULL

-- ===========================
-- Resolvendo possíveis fks que apontam para as pks problemáticas
-- ===========================
INSERT INTO #FKsEnvolvidas (FK_Name, SRC_Schema, SRC_Tabela, SRC_Column, TRG_Schema, TRG_Tabela, TRG_Column)
SELECT DISTINCT C.CONSTRAINT_NAME, CU.TABLE_SCHEMA, CU.TABLE_NAME, CU.COLUMN_NAME, CU2.TABLE_SCHEMA, CU2.TABLE_NAME, CU2.COLUMN_NAME
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C
     INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU
             ON C.CONSTRAINT_NAME = CU.CONSTRAINT_NAME
     INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE CU2
             ON CU2.CONSTRAINT_NAME = C.UNIQUE_CONSTRAINT_NAME
     INNER JOIN #PKsUniqueClustered pk
             ON C.UNIQUE_CONSTRAINT_NAME = pk.PK_Name

DECLARE @sql NVARCHAR(4000),
        @i_pk INT,
        @max_pk INT,
        @SchemaName VARCHAR(100),
        @TableName VARCHAR(100),
        @PK_Name VARCHAR(100),
        @Column_Name VARCHAR(100),
        
        -- fks
        @i_fk INT,
        @max_fk INT,
        @FK_Name VARCHAR(4000),
        @SRC_Schema VARCHAR(1000),
        @SRC_Tabela VARCHAR(1000),
        @SRC_Column VARCHAR(1000),
        @TRG_Schema VARCHAR(1000),
        @TRG_Tabela VARCHAR(1000),
        @TRG_Column VARCHAR(1000)

-- ===================
-- Removendo fks envolvidas
-- ===================

SELECT @i_fk = 1,
       @max_fk = COUNT(rownum)
FROM #FKsEnvolvidas

WHILE @i_fk < @max_fk + 1 BEGIN

  SELECT @FK_Name  = FK_Name, @SRC_Schema = SRC_Schema,
         @SRC_Tabela = SRC_Tabela, @SRC_Column = SRC_Column,
         @TRG_Schema = TRG_Schema, @TRG_Tabela = TRG_Tabela,
         @TRG_Column = TRG_Column
  FROM #FKsEnvolvidas
  WHERE rownum = @i_fk

  SET @i_fk = @i_fk + 1
  PRINT 'IF EXISTS (SELECT TOP 1 1 FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C 
                    WHERE C.CONSTRAINT_NAME = ''' + @FK_Name + ''') BEGIN '
  PRINT 'ALTER TABLE ' + @SRC_Schema + '.' + @SRC_Tabela + ' DROP CONSTRAINT ' + @FK_Name + ';'
  PRINT 'PRINT ''REMOVING ' + @FK_Name + ''' END'
  PRINT 'GO'
END

-- ===========================
-- Recriando pks
-- ===========================

SELECT @i_pk = 1,
       @max_pk = count(rownum)
FROM #PKsUniqueClustered

WHILE @i_pk < @max_pk + 1 BEGIN

  SELECT @TableName = Table_Name, @PK_Name = PK_Name, @Column_Name = Column_Name, @SchemaName = SchemaName
  FROM #PKsUniqueClustered
  WHERE rownum = @i_pk
  
  PRINT 'IF EXISTS (SELECT TOP 1 1 FROM sys.indexes i WHERE i.name = ''' + @PK_Name + ''' AND i.type = 1) BEGIN'
  PRINT 'ALTER TABLE ' + @SchemaName + '.' + @TableName + ' DROP CONSTRAINT ' + @PK_Name + ' ;'
  PRINT 'PRINT ''REMOVING PK ' + @PK_Name + ''' END'
  PRINT 'GO'
  
  PRINT 'IF NOT EXISTS (SELECT TOP 1 1 FROM sys.indexes i WHERE i.name = ''' + @PK_Name + ''' AND i.type = 2) BEGIN'
  PRINT 'ALTER TABLE ' + @SchemaName + '.' + @TableName + ' ADD CONSTRAINT ' + @PK_Name + ' PRIMARY KEY NONCLUSTERED ('+ @Column_Name + ');'
  PRINT 'PRINT ''RECRATING PK ' + @PK_Name + ''' END'
  PRINT 'GO'
  SET @i_pk = @i_pk + 1
END

-- ===========================
-- Recriando fks
-- ===========================
SELECT @i_fk = 1,
       @max_fk = COUNT(rownum)
FROM #FKsEnvolvidas

WHILE @i_fk < @max_fk + 1 BEGIN

  SELECT @FK_Name  = FK_Name,      @SRC_Schema = SRC_Schema,
         @SRC_Tabela = SRC_Tabela, @SRC_Column = SRC_Column,
         @TRG_Schema = TRG_Schema, @TRG_Tabela = TRG_Tabela,
         @TRG_Column = TRG_Column
  FROM #FKsEnvolvidas
  WHERE rownum = @i_fk

  SET @i_fk = @i_fk + 1
  
  PRINT 'IF NOT EXISTS (SELECT TOP 1 1 FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS C 
                        WHERE C.CONSTRAINT_NAME = ''' + @FK_Name + ''') BEGIN '
  PRINT 'ALTER TABLE ' + @SRC_Schema + '.' + @SRC_Tabela + ' ADD CONSTRAINT ' + @FK_Name +
        ' FOREIGN KEY (' + @SRC_Column + ') REFERENCES ' + @TRG_Schema + '.' + @TRG_Tabela + ' (' + @TRG_Column + ');'
  PRINT 'PRINT ''RESTORING ' + @FK_Name + ''' END'
  PRINT 'GO'
END

