
--========================================================================
-- Criando tabela <table>
--========================================================================

IF NOT EXISTS (
  SELECT * FROM SYS.TABLES WHERE NAME = N'<table>'
  AND OBJECT_ID = OBJECT_ID(N'<schema,,dbo>.<table>'))  

  BEGIN
    PRINT N'Criando tabela <table>'
    
    CREATE TABLE [<schema,,dbo>].[<table>] (
    ################COLUMNS#############
    );
  END
GO
