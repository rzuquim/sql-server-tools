
SELECT *
FROM (
      SELECT [Time] = deqs.last_execution_time, 
             [Query] = dest.text, 
             [LastExecution] = deqs.last_execution_time
      FROM sys.dm_exec_query_stats deqs
           CROSS APPLY sys.dm_exec_sql_text(deqs.sql_handle) dest
     ) a
WHERE a.[Query] LIKE '%<query_content>%'
ORDER BY a.LastExecution DESC