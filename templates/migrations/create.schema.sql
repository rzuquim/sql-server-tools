
IF schema_id('<schema,,>') IS NULL BEGIN
  PRINT N'create schema <schema,,>'
  EXEC('CREATE SCHEMA <schema,,>')
END
GO
