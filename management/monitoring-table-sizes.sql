
-- DROP TABLE #tables_space_used
-- DROP TABLE #tables

IF object_id('tempdb..#tables_space_used') IS NULL BEGIN 
    CREATE TABLE #tables_space_used (
        name NVARCHAR (128),
        rows CHAR (20),
        reserved VARCHAR (18),
        data VARCHAR (18),
        index_size VARCHAR (18),
        unused VARCHAR (18),
        instant_of_measurement DATETIME DEFAULT getdate())
END
GO

IF object_id('tempdb..#tables') IS NULL BEGIN 
    CREATE TABLE #tables (
        rownum INT IDENTITY,
        schema_name NVARCHAR (128),
        name NVARCHAR (128)
    )

    INSERT INTO #tables(schema_name, name)
    SELECT SCHEMA_NAME(SCHEMA_ID), name
    FROM sys.tables 

END
GO

DECLARE @i INT, @max INT, @target_table NVARCHAR(128) 

SELECT @i = 0, @max = COUNT(rownum)
FROM #tables

WHILE (@i < @max) BEGIN

    SELECT @target_table = schema_name + '.' + name, @i = @i + 1
    FROM #tables 
    WHERE rownum = @i + 1
    
    INSERT INTO #tables_space_used (name, rows, reserved, data, index_size, unused)
    EXEC sp_spaceused @target_table

END
GO

SELECT [name] = name,
       [rows] = rows,
       [reserved_KB] = cast(REPLACE(reserved, 'KB', '') AS INT),
       [data_KB] = cast(REPLACE(data, 'KB', '') AS INT),
       [index_size_KB] = cast(REPLACE(index_size, 'KB', '') AS INT),
       [unused_KB] = cast(REPLACE(unused, 'KB', '') AS INT),
       [idex_data_ratio] = cast(REPLACE(index_size, 'KB', '') AS INT) / 
                           CASE WHEN (cast(REPLACE(data, 'KB', '') AS INT)) = 0
                                THEN NULL
                                ELSE cast(REPLACE(index_size, 'KB', '') AS INT) / cast(REPLACE(data, 'KB', '') AS INT) END,
       [instant_of_measurement] = instant_of_measurement
FROM #tables_space_used