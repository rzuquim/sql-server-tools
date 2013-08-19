SET TRANSACTION ISOLATION LEVEL READ unCOMMITTED
GO

BEGIN TRAN
  ;WITH IndicesFaltantes AS (
  
  SELECT  Object_name(mid.object_id) AS Objeto,
          mid.equality_columns, mid.inequality_columns, mid.included_columns, 
          mis.avg_total_user_cost as "Custo_Médio", 
          mis.unique_compiles, 
          db_name(mid.database_id) AS banco,
          
          (mis.avg_total_user_cost * mis.unique_compiles) custo_total, mis.avg_user_impact
          
  FROM 
    sys.dm_db_missing_index_details mid
    INNER JOIN sys.dm_db_missing_index_groups AS mig ON mig.index_handle = mid.index_handle
    INNER JOIN SYS.dm_db_missing_index_group_stats as mis on mig.index_group_handle = mis.group_handle
    WHERE (db_name(mid.database_id) = 'Teste_Arena_Central_Bom')
  --where (MID.object_id = Object_id('tarefasdba.dbo.trace_lentidao_24072010'))
  )
  
  SELECT *, (custo_total - (custo_total * (avg_user_impact/100))) AS custo_total_provavel--, db_name(ifa.banco)
  
  from IndicesFaltantes ifa
  WHERE  ifa."Custo_Médio" > 3
  --AND ifa.avg_user_impact > 30
  AND ifa.Objeto NOT IN ('VendaFiscal', 'VendaPagamento','MapaResumo')
  order by ifa."Custo_Médio" DESC ,ifa.Objeto 
  --order by  ("custo_médio" * unique_compiles) DESC
  --sp_help [SYS.dm_db_missing_index_details]
  --PRINT @@TRANCOUNT
  --EXEC SP_HELPINDEX 'detalhe01'
  --print @@trancount

while @@trancount > 0
commit


--print @@TRANCOUNT
--
--PRINT db_id()

--
--[Codigo], 
--[DataHoraEntrada], 
--[DataHoraSaida], 
--[Usuario_Codigo], 
--[ValorAbertura], 
--[QtdTransacao], 
--[ValorConferido], 
--[ValorDiferenca], 
--[Situacao], 
--[DataConsolidacao]
