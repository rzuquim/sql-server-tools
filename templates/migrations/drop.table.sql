
IF object_id('<schema,,dbo>.<table,,>') IS NOT NULL BEGIN
  PRINT('DROPPING TABLE <schema,,>.<table,,>')
  EXEC('DROP TABLE <schema,,>.<table,,>')
END
GO
