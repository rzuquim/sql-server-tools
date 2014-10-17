
-- =============================================
-- Criando schema <Schema,,>
-- =============================================

IF NOT EXISTS (SELECT TOP 1 * 
               FROM sys.schemas
               WHERE name = '<Schema,,>')
BEGIN
  PRINT N'Criando schema <Schema,,>'
  EXEC('CREATE SCHEMA <Schema,,>')
END
GO


