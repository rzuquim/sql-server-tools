
IF NOT EXISTS (SELECT TOP 1 1 FROM SYS.COLUMNS WHERE NAME = N'<column>' AND OBJECT_ID = OBJECT_ID(N'<schema,,dbo>.<table>')) BEGIN 
    PRINT N'Adding new column <column> to table <schema,,dbo>.<table>'
    ALTER TABLE [<schema,,dbo>].[<table>]
    ADD [<column>] <type> NULL;
END
GO

PRINT N'updating to default values'
UPDATE [<schema,,dbo>].[<table>] SET [<column>] = <default value,,0> WHERE [<column>] IS NULL
GO

IF NOT EXISTS (SELECT TOP 1 1 
               FROM sys.tables t 
               INNER JOIN sys.default_constraints d ON d.parent_object_id = t.object_id
               INNER JOIN sys.columns c ON c.object_id = t.object_id AND c.column_id = d.parent_column_id  
               WHERE t.name = N'<table>' AND c.name = N'<column>' AND d.name = N'<df constraint>') BEGIN
    PRINT N'adding default constraint <df constraint> a coluna <column> da tabela <schema,,dbo>.<table> (valor: <default value,,0>)'
    ALTER TABLE [<schema,,dbo>].[<table>]
      ADD CONSTRAINT [<df constraint>] DEFAULT <default value,,0> FOR [<column>];
END
GO

IF EXISTS (SELECT TOP 1 1 FROM SYS.COLUMNS WHERE NAME = N'<column>' AND OBJECT_ID = OBJECT_ID(N'<schema,,dbo>.<table>')) BEGIN
    ALTER TABLE [<schema,,dbo>].[<table>]
    ALTER COLUMN [<column>] <type> NOT NULL;
END 
GO