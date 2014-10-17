
IF object_id('<schema,,dbo>.<table,,>') IS NULL BEGIN
  PRINT('CREATE TABLE <schema,,>.<table,,>')
  CREATE TABLE <schema,,>.<table,,> (
    Id UNIQUEIDENTIFIER NOT NULL CONSTRAINT "DF_<table,,>_Id" DEFAULT newid(),
    
    ... other columns... 
    
    CONSTRAINT [PK_<table,,>] PRIMARY KEY NONCLUSTERED (Id ASC),
    ... examples ... 
    
    CONSTRAINT [FK_<table,,>_other_table] FOREIGN KEY (other_table_id) 
                                    REFERENCES <schema,,dbo>.other_table (Id)
  )
END
GO
