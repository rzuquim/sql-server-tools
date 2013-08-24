
-- ====================================
-- Prints the script to correct wrong collations
-- IF THE WRONG COLLUMN HAS AN INDEX YOU MUST MANNUALY DROP YOUR INDEX BEFORE RUNNINING THE CORRECTION
-- ====================================

DECLARE @CorrectCollation VARCHAR(128)

SET @CorrectCollation = 'SQL_Latin1_General_CP1_CI_AS' -- examples: Latin1_General_CI_AS, SQL_Latin1_General_CP1_CI_AS

IF object_id('tempdb..#wrong_collation') IS NOT NULL BEGIN 
    DROP TABLE #wrong_collation 
END
GO

CREATE TABLE #wrong_collation (
    [rownum] INT IDENTITY,
    [schema] NVARCHAR (128),
    [table] NVARCHAR (128),
    [column] NVARCHAR (128),
    [type] NVARCHAR (128),
    [collation] NVARCHAR (128),
    [has_index] BIT)
GO

INSERT INTO #wrong_collation 
SELECT [schema] = schema_name(t.schema_id),
       [table] = t.name,
       [column] =  c.name, 
       [type] = type_name(c.user_type_id) + '(' + CAST(c.max_length AS VARCHAR) + ')',
       [collation] = c.collation_name, 
       [has_index] = CASE WHEN ix.col_name IS NULL THEN 0 ELSE 1 END
FROM sys.columns c 
     INNER JOIN sys.objects t 
             ON t.object_id = c.object_id 
      LEFT JOIN (SELECT [col_name] = col.name, 
                        [ind_name] = ind.name, 
                        t.object_id, 
                        col.column_id 
                 FROM sys.indexes ind 
                      INNER JOIN sys.index_columns ic 
                              ON ind.object_id = ic.object_id 
                                 AND ind.index_id = ic.index_id 
                      INNER JOIN sys.columns col 
                              ON ic.object_id = col.object_id 
                                 AND ic.column_id = col.column_id 
                      INNER JOIN sys.tables t 
                              ON ind.object_id = t.object_id) ix 
             ON c.object_id = ix.object_id 
                AND c.column_id = ix.column_id 
WHERE t.type = 'U' 
      AND c.collation_name IS NOT NULL
      AND c.collation_name <> @CorrectCollation
ORDER BY ix.col_name

DECLARE @i INT, @max INT, @sql NVARCHAR(4000) 

SELECT @i = 0, @max = COUNT(rownum)
FROM #wrong_collation

WHILE (@i < @max) BEGIN
    
    SELECT @sql = CASE WHEN has_index = 1 THEN '! MUST DROP INDEXES BEFORE CONVERTION !' ELSE '' END +
                  'ALTER TABLE ' + [schema] + '.' + [table] + ' ' + 
                  'ALTER COLUMN ' + [column] + ' '  + [type] + ' COLLATE ' + @CorrectCollation,
           @i = @i + 1 
    FROM #wrong_collation
    where rownum = @i + 1

    PRINT @sql
    PRINT 'GO'
END
GO
