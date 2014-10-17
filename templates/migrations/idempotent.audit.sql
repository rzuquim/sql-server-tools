
-- =================================================
-- Garantindo auditoria da tabela de <table>
-- =================================================

IF NOT EXISTS (
  SELECT * FROM Auditoria.AuditoriaDadoConfigTabela WHERE NomeTabela = '<table>')
BEGIN
  PRINT N'Garantindo auditoria da tabela de <table>'
  INSERT INTO Auditoria.AuditoriaDadoConfigTabela (NomeTabela)
  VALUES ('<table>')
END
