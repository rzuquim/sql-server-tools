
-- =======================================
-- delete plan of a query
-- =======================================

DECLARE @query VARCHAR(1000) = '%what_you_are_looking_for%'

-- find the query you want to delete
SELECT [text], 
       cp.size_in_bytes, 
       plan_handle
FROM sys.dm_exec_cached_plans cp
     CROSS APPLY sys.dm_exec_sql_text(plan_handle)
WHERE cp.cacheobjtype = N'Compiled Plan'
      AND cp.objtype = N'Adhoc'
      AND cp.usecounts = 1
      AND [TEXT] LIKE @query
ORDER BY cp.size_in_bytes DESC;

--delete it 
-- DBCC FREPROCCACHE(plan_handle)
-- for instance: DBCC FREEPROCCACHE(0x060005003821EC3090293D780100000001000000000000000000000000000000000000000000000000000000)
