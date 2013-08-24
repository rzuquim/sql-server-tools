
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @database VARCHAR(1000) = '%%'

--ignore this tables
DECLARE @ignore_tables TABLE (
  table_name VARCHAR(1000)
)

INSERT INTO @ignore_tables (table_name)
SELECT 'Table A' UNION
SELECT 'Table B' -- ect

;WITH missing_indexes AS (
  SELECT  [object_name] = Object_name(mid.object_id),
          mid.equality_columns, mid.inequality_columns, mid.included_columns, 
          [avg_cost] = mis.avg_total_user_cost, 
          mis.unique_compiles, 
          [database] = db_name(mid.database_id),
          [total_cost] = (mis.avg_total_user_cost * mis.unique_compiles), 
          mis.avg_user_impact
  FROM sys.dm_db_missing_index_details mid
       INNER JOIN sys.dm_db_missing_index_groups mig 
               ON mig.index_handle = mid.index_handle
       INNER JOIN sys.dm_db_missing_index_group_stats mis 
               ON mig.index_group_handle = mis.group_handle
  WHERE (db_name(mid.database_id) LIKE @database))
  
SELECT *, custo_total_provavel = (total_cost - (total_cost * (avg_user_impact/100)))
FROM missing_indexes
WHERE avg_cost > 3
      AND object_name NOT IN (SELECT table_name FROM @ignore_tables)
      --AND ifa.avg_user_impact > 30
ORDER BY avg_cost DESC, object_name  
