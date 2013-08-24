
-- =====================================================
-- Suggests indexes on fk-columns off big tables
-- =====================================================

DECLARE @N INT = 25, -- the @N biggest tables
        @fk_column_suffix VARCHAR(1000) = '%[_]Id'
        
IF object_id('tempdb..#temp_tables') IS NOT NULL BEGIN 
  DROP TABLE #temp_tables
END 

IF object_id('tempdb..#temp_big_tables') IS NOT NULL BEGIN 
  DROP TABLE #temp_big_tables
END 

CREATE TABLE #temp_tables (
  object_id          INT,
  COLUMN_id          INT,
  index_id           INT,
  position_on_index VARCHAR (30))

CREATE TABLE #temp_big_tables (
  object_id INT,
  table_name NVARCHAR (128),
  row_count INT)

-- ==========================================
-- Storing the @N biggest tables 
-- ==========================================

INSERT INTO #temp_big_tables 
  SELECT TOP (@N) 
    object_id, object_name(object_id) AS table_name, 
    rows AS row_count 
  FROM 
    sys.partitions p
  WHERE
    p.INDEX_id IN (0,1)
    AND p.object_id NOT IN ( SELECT o.object_id FROM sys.objects o WHERE type = 'U' AND name LIKE '%_TRANSFER')
  ORDER BY rows DESC 

-- ======================================
-- Querying for columns without indexes with fks on those big tables
-- ======================================

;WITH FK_Without_Index AS (
  SELECT c.column_id, BIG.Object_id
  FROM sys.all_columns C
       INNER JOIN #temp_big_tables BIG 
               ON C.object_id = BIG.Object_id 
        LEFT JOIN sys.index_columns ic
               ON c.column_id = ic.column_id 
                  AND C.object_id = ic.object_id 
                  AND ic.is_included_column  = 0 
        LEFT JOIN sys.indexes i 
               ON ic.index_id = i.index_id 
                  AND ic.object_id = i.object_id
  WHERE C.name LIKE @fk_column_suffix 
        AND i.name IS NULL 
), FK_With_Index AS (
  SELECT 
    c.column_id, c.object_id, ic.index_id, ic.key_ordinal
  FROM 
    sys.all_columns C
    INNER JOIN #temp_big_tables BIG 
      ON C.object_id = BIG.Object_id 
    INNER JOIN sys.index_columns ic
      ON c.column_id = ic.column_id AND C.object_id = ic.object_id AND ic.is_included_column  = 0 AND ic.key_ordinal > 1
  WHERE C.name LIKE @fk_column_suffix
)

INSERT INTO #temp_tables (object_id, column_id, index_id, position_on_index)
  SELECT FSI.object_id, FSI.column_id, NULL, NULL 
  FROM FK_Without_Index FSI
  
  UNION 
  
  SELECT object_id, COLUMN_id, index_id, CAST(key_ordinal AS VARCHAR)
  FROM FK_With_Index
    
-- ========================
-- Removing fks covered with indexes
-- ========================
;WITH FK_Covered AS (
  SELECT 
    c.column_id, c.object_id 
  FROM 
    sys.all_columns C
    INNER JOIN #temp_big_tables BIG 
      ON C.object_id = BIG.Object_id 
    INNER JOIN sys.index_columns ic
      ON c.column_id = ic.column_id 
         AND C.object_id = ic.object_id 
         AND ic.is_included_column  = 0 
         AND ic.key_ordinal = 1
  WHERE C.name LIKE @fk_column_suffix
  ) 
  
DELETE #temp_tables 
FROM #temp_tables TT
     INNER JOIN FK_Covered FC
             ON TT.Column_id = FC.Column_id AND TT.object_id = Fc.object_id 

--Result

SELECT  [Table] = object_name(tt.object_id),
        [Column] = c.name,
        [Index] = coalesce(i.name, 'N/A'),
        [Position On Index] = coalesce(tt.position_on_index, 'N/A'),
        [Row Count] = bt.row_count
FROM #temp_tables TT
     INNER JOIN #temp_big_tables bt
             ON TT.object_id = bt.object_id 
     INNER JOIN sys.all_columns C
             ON tt.column_id = c.column_id AND TT.object_id = c.object_id  
      LEFT JOIN sys.indexes i
             ON TT.object_id = i.object_id AND TT.index_id = i.index_id 
ORDER BY bt.row_count desc
  