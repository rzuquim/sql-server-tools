
-- ===========================================================
-- Renomeando coluna <column> para <new column>
-- ===========================================================

IF EXISTS (
  SELECT * FROM SYS.COLUMNS WHERE NAME = N'<column>'
  AND OBJECT_ID = OBJECT_ID(N'<schema,,dbo>.<table>')) 
  BEGIN
    PRINT N'Renomeando coluna <column> para <new column>'
    EXEC sp_RENAME '<schema,,dbo>.<table>.<column>' , '<new column>', 'COLUMN'
  END 
GO



