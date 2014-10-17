
--========================================================================
-- Dropando índice <index>
--========================================================================

IF EXISTS (SELECT name FROM sys.indexes WHERE name = '<index>') 
BEGIN 
  PRINT N'Dropando índice <index>'
  DROP INDEX <index>
END 
GO
