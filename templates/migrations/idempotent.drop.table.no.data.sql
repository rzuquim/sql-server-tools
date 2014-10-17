--========================================================================
-- droping <table> if exists - ALL DATA WILL BE LOST
--========================================================================
IF EXISTS (
  SELECT * FROM SYS.TABLES WHERE NAME = N'<table>'
  AND OBJECT_ID = OBJECT_ID(N'<schema,,dbo>.<table>'))  

  BEGIN
    PRINT N'Removendo tabela <table>'
    DROP TABLE [<schema,,dbo>].[<table>]
  END
GO