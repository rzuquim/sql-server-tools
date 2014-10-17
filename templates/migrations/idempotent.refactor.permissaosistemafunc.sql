
-- ================================================================================================================
-- Atualizando a SistemaFuncionalidade e a PermissaoSistemaFuncionalidade para a funcionalidade <Funcionalidade>
-- ================================================================================================================

IF EXISTS (SELECT * 
           FROM Permissao p
                INNER JOIN PermissaoSistemaFuncionalidade psf
                        ON psf.Codigo = p.PermissaoSistemaFunc_Codigo
                INNER JOIN SistemaFuncionalidade sf
                        ON psf.SistemaFuncionalidade_Codigo = sf.Codigo
                INNER JOIN Funcionalidade f
                        ON sf.Funcionalidade_Codigo = f.Codigo
                           AND f.Nome = '<Funcionalidade>'
                INNER JOIN Funcionalidade fpai
                        ON fpai.Codigo = f.FuncionalidadePai_Codigo
                           AND fpai.Nome = '<FuncionalidadePai>')
BEGIN
  PRINT N'Já existe uma Permissão referenciando a Funcionalidade <Funcionalidade>'
END
ELSE IF EXISTS (SELECT * 
           FROM Funcionalidade f 
                INNER JOIN Funcionalidade fpai 
                        ON fpai.Codigo = f.FuncionalidadePai_Codigo
                           AND fpai.Nome = '<FuncionalidadePai>' 
           WHERE f.Nome = '<Funcionalidade>')
BEGIN
  DELETE psf
  FROM PermissaoSistemaFuncionalidade psf
       INNER JOIN SistemaFuncionalidade sf
               ON psf.SistemaFuncionalidade_Codigo = sf.Codigo
       INNER JOIN Funcionalidade f
               ON sf.Funcionalidade_Codigo = f.Codigo
                  AND f.Nome = '<Funcionalidade>'
       INNER JOIN Funcionalidade fpai
               ON fpai.Codigo = f.FuncionalidadePai_Codigo
                  AND fpai.Nome = '<FuncionalidadePai>'
                  
  DELETE sf
  FROM SistemaFuncionalidade sf
       INNER JOIN Funcionalidade f
               ON sf.Funcionalidade_Codigo = f.Codigo
                  AND f.Nome = '<Funcionalidade>'
       INNER JOIN Funcionalidade fpai
               ON fpai.Codigo = f.FuncionalidadePai_Codigo
                  AND fpai.Nome = '<FuncionalidadePai>'
                  
  INSERT INTO dbo.SistemaFuncionalidade (Funcionalidade_Codigo, Sistema_Codigo)
  SELECT f.Codigo, s.Codigo
  FROM Funcionalidade f
       INNER JOIN Funcionalidade fpai
               ON fpai.Codigo = f.FuncionalidadePai_Codigo
                  AND fpai.Nome = '<FuncionalidadePai>'
       CROSS JOIN Sistema s
  WHERE f.Nome = '<Funcionalidade>'
        AND s.Sigla in (<Siglas_Sistema,,'CB', 'GB'>)
        
  INSERT INTO dbo.PermissaoSistemaFuncionalidade (TipoPermissao_Codigo, SistemaFuncionalidade_Codigo)
  SELECT tp.Codigo, sf.Codigo
  FROM SistemaFuncionalidade sf
       INNER JOIN Funcionalidade f
               ON sf.Funcionalidade_Codigo = f.Codigo
                  AND f.Nome = '<Funcionalidade>'
       INNER JOIN Funcionalidade fpai
               ON fpai.Codigo = f.FuncionalidadePai_Codigo
                  AND fpai.Nome = '<FuncionalidadePai>'
       INNER JOIN Sistema s
               ON sf.Sistema_Codigo = s.Codigo
                  AND s.Sigla in (<Siglas_Sistema,,'CB', 'GB'>)
       CROSS JOIN TipoPermissao tp
  WHERE tp.Sigla in (<Siglas_TipoPermissao,,'C', 'G', 'A'>) 
END

GO
