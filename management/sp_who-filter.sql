
DECLARE @sp_who TABLE(         
  spid INT,         
  status VARCHAR(MAX),
  login VARCHAR(MAX),
  hostname VARCHAR(MAX),
  blkby VARCHAR(MAX),
  dbname VARCHAR(MAX),
  command VARCHAR(MAX),
  cputime INT,
  diskio INT,
  lastbatch VARCHAR(MAX),
  programname VARCHAR(MAX),
  spid_1 INT,
  requestid INT)  

INSERT INTO @sp_who EXEC sp_who2

-- SELECT * FROM @sp_who

SELECT spid, dbname, status, diskio, cputime, lastbatch, programname
FROM @sp_who 
WHERE 
  dbname LIKE <dbname,,'%%'>
  AND login LIKE <login,,'%%'>
  AND hostname LIKE <hostname,,'%%'>
ORDER BY 
  diskio DESC
  ,cputime DESC 