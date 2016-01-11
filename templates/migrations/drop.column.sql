
IF EXISTS (SELECT TOP 1 1
           FROM sys.columns WHERE name = N'<column,,>'
                    AND object_id = object_id(N'<schema,,dbo>.<table,,>')) BEGIN
  PRINT('DROPPING COLUMN <column,,> FROM <schema,,>.<table,,>')
  EXEC('ALTER TABLE [<schema,,dbo>].[<table,,>]
        DROP COLUMN [<column,,>];')
END
GO
