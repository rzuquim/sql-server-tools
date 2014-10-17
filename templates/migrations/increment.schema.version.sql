

/* ==========================================================
Migração: <MajorRelease,,02>.<MinorRelease,,01>.<PointRelease,,00XX>
Alterações: <Alterações>
Motivação: <Motivos>
CR: <Número do CR,, Não informado>
 ========================================================== */

IF NOT EXISTS (
  SELECT * FROM Versionamento.MigracoesSchema WHERE MajorRelease = '<MajorRelease,,02>' AND 
    MinorRelease = '<MinorRelease,,01>' AND PointRelease = '<PointRelease>')
  BEGIN
    EXEC Versionamento.USP_AtualizaVersaoSchema '<MajorRelease,,02>', '<MinorRelease,,01>', '<PointRelease>', '<Sufixo Arquivo>'
  END
GO
