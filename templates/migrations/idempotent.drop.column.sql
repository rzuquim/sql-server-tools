--========================================================================
-- Removendo coluna se existir
--========================================================================
IF EXISTS (
  SELECT * FROM SYS.COLUMNS WHERE NAME = N'<column>'
  AND OBJECT_ID = OBJECT_ID(N'<schema,,dbo>.<table>'))  

  BEGIN
    PRINT N'Removendo coluna <column> a tabela <schema,,dbo>.<table>'
    ALTER TABLE [<schema,,dbo>].[<table>]
    DROP COLUMN [<column>];
  END
GO