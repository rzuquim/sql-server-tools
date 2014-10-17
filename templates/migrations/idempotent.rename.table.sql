
IF NOT EXISTS (<Seu if>)
BEGIN
  EXEC sp_rename '<schema,,dbo>.<NomeAntigo>', '<NovoNome>'
END
GO


