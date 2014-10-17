
IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.ConfigReplicacaoTabela 
               WHERE NomeSchema = <schema,VARCHAR(255),dbo> AND NomeTabela = <tabela,VARCHAR(255),>) BEGIN   
   INSERT INTO dbo.ConfigReplicacaoTabela (NomeSchema, NomeTabela, TipoReplicacao, FuncaoBDContexto, ColunaExclusaoLogica, Proprietario, Status, SchemaProcedureBDImportacao, NomeProcedureBDImportacao)   
   SELECT <schema, VARCHAR(255), dbo>, <tabela,VARCHAR(255)>, <tipo-replicacao,VARCHAR(1),D>, <FuncaoBDContexto,VARCHAR(255),NULL>, <ColunaExclusaoLogica,VARCHAR(50),NULL>, <Proprietario,VARCHAR(10),CENTRAL>, <status,BIT,1>, <SchemaProcedureBDImportacao,VARCHAR(255),NULL>, <NomeProcedureBDImportacao,VARCHAR(255),NULL>     
END
GO
