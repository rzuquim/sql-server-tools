
--========================================================================
-- Adding index <index,,>
--========================================================================

IF NOT EXISTS (SELECT name FROM sys.indexes WHERE name = '<index,,>') BEGIN
  PRINT N'Adding index <index,,>'
  CREATE NONCLUSTERED INDEX <index,,> ON <table,,> (<columns,,>) INCLUDE (<includeColumns,,>)
END 
GO
