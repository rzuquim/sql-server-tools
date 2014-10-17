-- =================
-- http://www.jasonstrate.com/2008/07/index-size-and-usage/
-- =================

SELECT [table_name] = object_name(i.object_id),
       [index_name] = COALESCE(i.name, space(0)),
       [partition_number] = ps.partition_number,
       [row_count] = ps.row_count,
       [size_in_mb] = Cast((ps.reserved_page_count * 8)/1024. as decimal(12,2)),
       [user_seeks] = COALESCE(ius.user_seeks,0),
       [user_scans] = COALESCE(ius.user_scans,0), 
       [user_lookups] = COALESCE(ius.user_lookups,0),
       [index_type] = i.type_desc
FROM sys.all_objects t
     INNER JOIN sys.indexes i ON t.object_id = i.object_id
     INNER JOIN sys.dm_db_partition_stats ps ON i.object_id = ps.object_id AND i.index_id = ps.index_id
      LEFT JOIN sys.dm_db_index_usage_stats ius ON ius.database_id = db_id() AND i.object_id = ius.object_id AND i.index_id = ius.index_id
-- ===========
-- uncomment for search unused indexes
-- ===========
-- WHERE i.type_desc NOT IN ('HEAP', 'CLUSTERED')
-- AND i.is_unique = 0
-- AND i.is_primary_key = 0
-- AND i.is_unique_constraint = 0
-- AND COALESCE(ius.user_seeks,0) <= 0
-- AND COALESCE(ius.user_scans,0) <= 0
-- AND COALESCE(ius.user_lookups,0) <= 0 
ORDER BY object_name(i.object_id), i.name




