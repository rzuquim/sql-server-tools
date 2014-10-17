--========================================================================
-- Adicionando nova constraint <df constraint> a coluna <column> da tabela <schema,,dbo>.<table> (valor: <constraint value,,0>)
--========================================================================
IF NOT EXISTS (
  SELECT * FROM sys.tables t 
    JOIN sys.default_constraints d ON d.parent_object_id = t.object_id
    JOIN sys.columns c ON c.object_id = t.object_id AND c.column_id = d.parent_column_id  
  WHERE t.name = N'<table>' AND c.name = N'<column>' AND d.name = N'<df constraint>')
  
  BEGIN
    PRINT N'Adicionando nova constraint <df constraint> a coluna <column> da tabela <schema,,dbo>.<table> (valor: <constraint value,,0>)'
    ALTER TABLE [<schema,,dbo>].[<table>]
      ADD CONSTRAINT [<df constraint>] DEFAULT ((<constraint value,,0>)) FOR [<column>];
  END
GO