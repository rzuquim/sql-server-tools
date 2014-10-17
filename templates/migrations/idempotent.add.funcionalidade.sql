
-- ==================================================================
-- Adicionando funcionalidade <FuncionalidadePai> > <Funcionalidade>
-- ==================================================================

IF NOT EXISTS ( SELECT * FROM dbo.Funcionalidade f inner join Funcionalidade fpai on f.FuncionalidadePai_Codigo = fpai.Codigo 
        WHERE f.Nome = '<Funcionalidade>' and fpai.Nome = '<FuncionalidadePai>' )

BEGIN
  PRINT N'Adicionando funcionalidade <FuncionalidadePai> > <Funcionalidade>'

  INSERT INTO dbo.Funcionalidade (Nome, Endereco, Ordem, Interna, FuncionalidadePai_Codigo, Descricao, PossuiCalendario, TipoFuncionalidade_Codigo)
    SELECT '<Funcionalidade>', '<Funcionalidade_URL>', <Funcionalidade_Ordem>, 0, fpai.Codigo, '<Funcionalidade>', 0, tf.Codigo
    FROM Funcionalidade fpai, TipoFuncionalidade tf
    WHERE fpai.Nome = '<FuncionalidadePai>'
          AND tf.Sigla = 'M'
  
  INSERT INTO dbo.SistemaFuncionalidade (Funcionalidade_Codigo, Sistema_Codigo)
    SELECT f.Codigo, s.Codigo 
    FROM Funcionalidade f
         INNER JOIN Funcionalidade fpai
                 ON fpai.Codigo = f.FuncionalidadePai_Codigo
         CROSS JOIN Sistema s
    WHERE f.Nome = '<Funcionalidade>' 
          AND fpai.Nome = '<FuncionalidadePai>'
          AND s.Sigla in (<Siglas_Sistema>)
    
  INSERT INTO dbo.PermissaoSistemaFuncionalidade (TipoPermissao_Codigo, SistemaFuncionalidade_Codigo)
    SELECT tp.Codigo, sf.Codigo
    FROM dbo.SistemaFuncionalidade sf
         INNER JOIN Sistema s
                 ON sf.Sistema_Codigo = s.Codigo
         INNER JOIN Funcionalidade f
                 ON sf.Funcionalidade_Codigo = f.Codigo
         INNER JOIN Funcionalidade fpai
                 ON fpai.Codigo = f.FuncionalidadePai_Codigo
         CROSS JOIN TipoPermissao tp
    WHERE tp.Sigla IN (<Siglas_TipoPermissao>)
          AND s.Sigla IN (<Siglas_Sistema>)
          AND f.Nome = '<Funcionalidade>'
          AND fpai.Nome = '<FuncionalidadePai>'
    
END 
GO
