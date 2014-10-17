--========================================================================
-- Adicionando nova UNIQUE constraint <constraint> à coluna <column> da tabela <schema,,dbo>.<table>
--========================================================================
IF NOT EXISTS (
  SELECT * FROM information_schema.constraint_column_usage
  WHERE table_name = N'<table>' AND column_name = N'<column>' AND constraint_name = N'<constraint>')
  
  BEGIN
    PRINT N'Adicionando nova UNIQUE constraint <constraint> à coluna <column> da tabela <schema,,dbo>.<table>'

    ALTER TABLE [<schema,,dbo>].[<table>]
      ADD CONSTRAINT [<constraint>] UNIQUE (<column>);
  END
GO
