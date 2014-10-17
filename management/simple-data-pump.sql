
-- =======================
-- Generates inserts to simply duplicate a database
-- =======================

DECLARE @SourceDB VARCHAR(1000)

set @SourceDB = 'SrcBD'

DECLARE @Table VARCHAR(1000)
DECLARE @Columns VARCHAR(1000)
DECLARE @IsIdentity BIT

DECLARE @i INT
DECLARE @max INT

IF object_id('tempdb..#src_tables') IS NOT NULL DROP TABLE #src_tables

create table #src_tables (
    row_num INT IDENTITY(1,1),
    name VARCHAR(1000),
    is_identity BIT
)

insert into #src_tables
SELECT t.name, [is_identity] = coalesce(MAX(CAST (c.is_identity AS INT)), 0)
FROM sys.tables t
     LEFT JOIN sys.columns c
            ON t.object_id = c.object_id
               and c.is_identity = 1
GROUP BY t.name

SELECT @i = MIN(row_num), @max = MAX(row_num)
FROM #src_tables

WHILE @i <= @max BEGIN
    SELECT @Table = name, @IsIdentity = is_identity
    FROM #src_tables
    WHERE row_num = @i

    IF (@IsIdentity = 1) BEGIN 
        PRINT 'SET IDENTITY_INSERT ' + @Table + ' ON'
        PRINT 'GO'
    
        SELECT @Columns = STUFF((SELECT ',' + CAST(name AS VARCHAR) 
                             FROM (SELECT name 
                                   FROM sys.columns
                                   WHERE object_name(object_id) = @Table) T
                             FOR XML PATH('')), 1, 1, '')

        PRINT 'INSERT INTO ' + @Table + ' (' + @Columns + ')'
        PRINT 'SELECT ' + @Columns + ' FROM ' + @SourceDB + '..' + @Table
        PRINT 'GO'

        PRINT 'SET IDENTITY_INSERT ' + @Table + ' OFF'
        PRINT 'GO'
    END ELSE BEGIN
        PRINT 'INSERT INTO ' + @Table
        PRINT 'SELECT * FROM ' + @SourceDB + '..' + @Table
        PRINT 'GO'
    END
    
    SET @i = @i + 1
END




