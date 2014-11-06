
--========================================================================
-- Altering <column,,> from <schema,,dbo>.<table,,>
--========================================================================
IF EXISTS (
  SELECT top 1 1 FROM SYS.COLUMNS WHERE NAME = N'<column,,>'
  AND OBJECT_ID = OBJECT_ID(N'<schema,,dbo>.<table,,>')) 
  BEGIN
    ALTER TABLE [<schema,,dbo>].[<table,,>]
      ALTER COLUMN [<column,,>] <type,,> <nullable,,NOT NULL>;
  END 
GO
