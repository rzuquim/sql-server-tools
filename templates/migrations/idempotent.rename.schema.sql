
-- ========================================================================
-- Alterando schema da tabela <Tabela,,> de <SchemaAntigo,,> para <SchemaNovo,,>
-- ========================================================================

IF EXISTS (SELECT TOP 1 * 
           FROM sys.tables st
             INNER JOIN sys.schemas ss
               ON st.schema_id = ss.schema_id
           WHERE st.name = '<Tabela,,>'
             AND ss.name = '<SchemaAntigo,,>')
BEGIN
  PRINT N'Alterando schema da tabela <Tabela,,> de <SchemaAntigo,,> para <SchemaNovo,,>'
  ALTER SCHEMA <SchemaNovo,,> TRANSFER <SchemaAntigo,,>.<Tabela,,>
END
GO

