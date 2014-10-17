IF NOT EXISTS (SELECT TOP 1 1 FROM SYS.COLUMNS WHERE NAME = N'<column>' AND OBJECT_ID = OBJECT_ID(N'<schema,,dbo>.<table>')) BEGIN
    PRINT N'Adding new null column <column> into table <schema,,dbo>.<table>'
    ALTER TABLE [<schema,,dbo>].[<table>]
    ADD [<column>] <type> NULL;
  END
GO