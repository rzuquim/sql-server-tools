
-- ================================================
-- Garantindo XOR entre as colunas: <coluna_A> e <coluna_B> em <tabela>
-- Só é permitido que uma das colunas seja null (as duas não podem ser null, nem as duas preenchidas)
-- ================================================

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.check_constraints WHERE constraint_name = '<nome constraint,,CK_>')
BEGIN 
ALTER TABLE <tabela>
  ADD CONSTRAINT <nome constraint,,CK_> 
  CHECK ((<coluna_A> IS NULL AND <coluna_B> IS NOT NULL) OR 
         (<coluna_A> IS NOT NULL AND <coluna_B> IS NULL));
END 
GO