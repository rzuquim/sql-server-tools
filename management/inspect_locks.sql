
-- =======================
-- Use this connection to periodically inspect and record lock data (from sp_lock)
-- while you perform some other task on another connection
-- Cancel the process whenever you're ready
-- =======================
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

IF OBJECT_ID('tempdb..#Lock_Snapshot') IS NULL BEGIN
  CREATE TABLE #Lock_Snapshot (
      id                    INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
      [snapshot]            UNIQUEIDENTIFIER NOT NULL,
      [snapshot_instant]    DATETIME         NOT NULL, 
      [database]            SYSNAME,
      [object]              VARCHAR(MAX),
      spid                  VARCHAR(MAX),
      dbid                  VARCHAR(MAX),
      ObjId                 VARCHAR(MAX),
      IndId                 VARCHAR(MAX),
      Type                  VARCHAR(MAX),
      Resource              VARCHAR(MAX),
      Mode                  VARCHAR(MAX),
      Status                VARCHAR(MAX))
END
GO

DECLARE @snapshot            AS UNIQUEIDENTIFIER,
        @snapshot_instant    AS DATETIME

WHILE 1 = 1 BEGIN
    IF OBJECT_ID('tempdb..#Lock') IS NOT NULL DROP TABLE #Lock

    SET @snapshot = newid()
    SET @snapshot_instant = GETDATE()
    
    CREATE TABLE #Lock (
        spid varchar(max),
        dbid varchar(max),
        ObjId varchar(max),
        IndId varchar(max),
        Type varchar(max),
        Resource varchar(max),
        Mode varchar(max),
        Status varchar(max))
        
    INSERT INTO #Lock
    EXEC sp_lock

    INSERT INTO #Lock_Snapshot ([snapshot], [snapshot_instant], [database], [object], spid, dbid, ObjId, IndId, Type, Resource, Mode, Status)
    SELECT [Snapshot]    = @Snapshot
         , [DataHora]    = @snapshot_instant
         , [Database]    = d.name
         , [Object]      = RTRIM(ISNULL(OBJECT_SCHEMA_NAME (l.ObjId, l.dbid) + '.', '')) + 
                           + RTRIM(OBJECT_NAME(l.ObjId, l.dbid))
         , l.spid, l.dbid, l.ObjId, l.IndId, l.Type, l.Resource, l.Mode, l.Status
      FROM #Lock l
           LEFT JOIN sys.databases d
                  ON ( d.database_id = l.dbid )

    WAITFOR DELAY '00:00:00.250'
END
