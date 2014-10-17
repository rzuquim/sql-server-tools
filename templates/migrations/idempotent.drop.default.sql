
--========================================================================
-- Removendo constraint <df constraint>
--========================================================================
IF EXISTS (  SELECT * FROM sys.tables t     
                 JOIN sys.default_constraints d ON d.parent_object_id = t.object_id    
                 JOIN sys.columns c ON c.object_id = t.object_id AND c.column_id = d.parent_column_id    
                 WHERE t.name = N'<table>' AND c.name = N'<column>' AND d.name = N'<df constraint>')    
  BEGIN    
  
  PRINT N'Removendo constraint <df constraint>'    
  ALTER TABLE [<schema,,dbo>].[<table>]      
  DROP CONSTRAINT [<df constraint>]  
  
  END
GO
