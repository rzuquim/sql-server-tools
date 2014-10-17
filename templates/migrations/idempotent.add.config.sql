
-- =====================================
-- Criando configuração <Nome>
-- =====================================

IF NOT EXISTS (SELECT * FROM Configuracao WHERE Nome = '<Nome>')
BEGIN 

  INSERT INTO dbo.Configuracao (Nome, Tipo, ObjetoBD_Codigo, Descricao)
  SELECT '<Nome>', <Tipo,Booleano,3>, obd.Codigo, '<Descricao>'
  FROM dbo.ObjetoBD obd
  WHERE obd.Nome = <ObjetoBD,'Estabelecimento'>
  
  INSERT INTO dbo.SistemaConfiguracao (Sistema_Codigo, Configuracao_Codigo, Status)
  SELECT s.Codigo, c.Codigo, 1
  FROM dbo.Sistema s, dbo.Configuracao c
  WHERE c.Nome = '<Nome>'
        AND s.Sigla = <Siglas_Sistema>

END
GO

