--========================================================================
-- Adicionando nova coluna <fk table>_Codigo a tabela <schema,,dbo>.<table>
--========================================================================
IF NOT EXISTS (
  SELECT * FROM SYS.COLUMNS WHERE NAME = N'<fk table>_Codigo'
  AND OBJECT_ID = OBJECT_ID(N'<schema,,dbo>.<table>'))  

  BEGIN      -- COLUMN EXISTS  END
    PRINT N'Adicionando nova coluna <fk table>_Codigo a tabela <schema,,dbo>.<table>'
    ALTER TABLE [<schema,,dbo>].[<table>]
    ADD [<fk table>_Codigo] <type> NULL;
  END
GO

-- Adicionando nova fk constraint a coluna <fk table>_Codigo da tabela <schema,,dbo>.<table>
IF NOT EXISTS (
  SELECT * FROM SYS.FOREIGN_KEYS WHERE object_id = OBJECT_ID(N'<schema,,dbo>.<fk restriction,,FK_>') AND 
    parent_object_id = OBJECT_ID(N'<schema,,dbo>.<table>'))
  BEGIN
    PRINT N'Adicionando novo relacionamento <fk restriction,,FK_> de <schema,,dbo>.<table> para <schema,,dbo>.<fk table>'
    ALTER TABLE [<schema,,dbo>].[<table>] ADD CONSTRAINT [<fk restriction,,FK_>]
      FOREIGN KEY (<fk table>_Codigo) REFERENCES <schemaFK,,dbo>.<fk table> (Codigo);
  END
GO
