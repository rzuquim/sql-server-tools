-- Find spid using sp_who2

SELECT der.percent_complete FROM sys.dm_exec_requests der
WHERE der.session_id = <spid,,>