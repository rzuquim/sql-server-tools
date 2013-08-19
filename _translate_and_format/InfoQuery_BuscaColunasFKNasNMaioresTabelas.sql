DECLARE @N INT 


IF object_id('tempdb..#temp_Tabelas') IS NOT NULL
BEGIN 
  DROP TABLE #temp_Tabelas
END 

IF object_id('tempdb..#temp_BigTabelas') IS NOT NULL
BEGIN 
  DROP TABLE #temp_BigTabelas
END 

CREATE TABLE #temp_Tabelas
  (
  object_id          INT,
  COLUMN_id          INT,
  index_id           INT,
  PosicaoChaveIndice VARCHAR (30)
  )

CREATE TABLE #temp_BigTabelas
  (
  object_id INT,
  Tabela NVARCHAR (128),
  FMTLinhas VARCHAR(30),
  LInhas INT 
  
  )

SET @N = 10

/*Grava a lista das N maiores tabelas*/
;WITH TopNBigTables AS (
  SELECT TOP (@N)
    object_id, object_name(object_id) AS Tabela, 
    CONVERT(varchar, CAST(rows AS money), 1)  AS FMTLInhas,
    rows AS Linhas 
  FROM 
    sys.partitions p
  WHERE
    p.INDEX_id IN (0,1)
    AND p.object_id NOT IN ( SELECT o.object_id FROM sys.objects o WHERE type = 'U' AND name LIKE '%_TRANSFER')
  ORDER BY rows DESC 
)
INSERT INTO #temp_BigTabelas 
 SELECT * FROM TopNBigTables


/*Listar todas as FKs sem índices e todas as que estão em índices (em que a 
coluna FK não inicie a chave)*/
;WITH FKSemIndices AS (
  SELECT 
    c.column_id, BIG.Object_id
  FROM 
    sys.all_columns C
    INNER JOIN #temp_BigTabelas BIG 
      ON C.object_id = BIG.Object_id 
    LEFT JOIN sys.index_columns ic
      ON c.column_id = ic.column_id AND C.object_id = ic.object_id AND ic.is_included_column  = 0 
      left JOIN sys.indexes i 
        ON ic.index_id = i.index_id and ic.object_id = i.object_id
  WHERE C.name LIKE '%[_]Codigo' 
  AND i.name IS NULL 
  ), 
  FKComIndiceNaoCobrindo AS (
  SELECT 
    c.column_id, c.object_id, ic.index_id, ic.key_ordinal
  FROM 
    sys.all_columns C
    INNER JOIN #temp_BigTabelas BIG 
      ON C.object_id = BIG.Object_id 
    INNER JOIN sys.index_columns ic
      ON c.column_id = ic.column_id AND C.object_id = ic.object_id AND ic.is_included_column  = 0 AND ic.key_ordinal > 1
  WHERE C.name LIKE '%[_]Codigo'      
)
INSERT INTO #temp_Tabelas 
  (
  object_id         ,
  COLUMN_id         ,
  index_id          ,
  PosicaoChaveIndice
  )
  SELECT 
    FSI.object_id, 
    FSI.column_id, 
    NULL,
    NULL 
  FROM 
    FKSemIndices FSI
  
  UNION 
  
  SELECT 
    object_id         ,
    COLUMN_id         ,
    index_id          ,
    CAST(key_ordinal AS VARCHAR)

  FROM 
    FKComIndiceNaoCobrindo
    

/*Remover todas as FKs cobertas por índices*/
;WITH FKCobertas AS (
  SELECT 
    c.column_id, c.object_id 
  FROM 
    sys.all_columns C
    INNER JOIN #temp_BigTabelas BIG 
      ON C.object_id = BIG.Object_id 
    INNER JOIN sys.index_columns ic
      ON c.column_id = ic.column_id AND C.object_id = ic.object_id AND ic.is_included_column  = 0 AND ic.key_ordinal = 1
  WHERE C.name LIKE '%[_]Codigo'       
  ) 
DELETE #temp_Tabelas 
FROM 
  #temp_Tabelas TT
  INNER JOIN FKCobertas FC
    ON TT.Column_id = FC.Column_id AND TT.object_id = Fc.object_id 


SELECT 
  c.name AS Coluna,
  object_name(tt.object_id) AS Tabela,
  coalesce(i.name, 'SEM INDICE') AS "Índice",
  coalesce(tt.PosicaoChaveIndice, 'N/A') AS PosicaoChaveIndice,
  bt.FMTLInhas AS LinhasTabela

FROM 
  #temp_Tabelas TT
  INNER JOIN #temp_BigTabelas bt
    ON TT.object_id = bt.object_id 
  INNER JOIN sys.all_columns C
    ON tt.column_id = c.column_id AND TT.object_id = c.object_id  
  LEFT OUTER JOIN sys.indexes i
    ON TT.object_id = i.object_id AND TT.index_id = i.index_id 
ORDER BY bt.Linhas desc,Tabela,Coluna 
  
  