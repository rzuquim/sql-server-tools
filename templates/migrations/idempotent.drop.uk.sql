
--========================================================================
-- Dropando UNIQUE constraint <constraint>
--========================================================================

IF EXISTS (  SELECT * FROM information_schema.constraint_column_usage 
             WHERE table_name = N'<table>' AND column_name = N'<column>' AND constraint_name = N'<constraint>')    
  BEGIN    
     PRINT N'Dropando UNIQUE constraint <constraint>'    
     
     ALTER TABLE [<schema,,dbo>].[<table>]      DROP CONSTRAINT [<constraint>];  
  END
GO
