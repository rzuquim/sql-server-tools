-- Find spid using sp_who2

SELECT S.text FROM master.dbo.sysprocesses P
CROSS APPLY sys.dm_exec_sql_text(P.sql_handle) S
WHERE P.spid = <spid,,>