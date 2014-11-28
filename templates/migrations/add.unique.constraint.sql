
IF object_id('dbo.<unique_prefix,,UK>_<table,,>_<column,,>') IS NULL BEGIN
    PRINT N'Adding UNIQUE constraint <unique_prefix,,UK>_<table,,>_<column,,>'

    ALTER TABLE [<schema,,dbo>].[<table,,>]
      ADD CONSTRAINT [<unique_prefix,,UK>_<table,,>_<column,,>] UNIQUE (<column,,>);
  END
GO
