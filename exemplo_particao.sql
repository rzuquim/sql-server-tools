
DROP TABLE PartitionA
DROP TABLE PartitionB
GO

CREATE TABLE PartitionA (
    Id INT NOT NULL, -- não pode ser identity
    PartitionKey CHAR NOT NULL CHECK (PartitionKey = 'A'),
    Data VARCHAR(100),
    CONSTRAINT [PK_PartitionA] PRIMARY KEY NONCLUSTERED (Id, PartitionKey)
)
GO

CREATE TABLE PartitionB (
    Id INT NOT NULL, -- não pode ser identity
    PartitionKey CHAR CHECK (PartitionKey = 'B'),
    Data VARCHAR(100),
    CONSTRAINT [PK_PartitionB] PRIMARY KEY NONCLUSTERED (Id, PartitionKey)
)
GO

DROP VIEW Everything
GO

CREATE VIEW Everything AS
SELECT * FROM PartitionA UNION ALL
SELECT * FROM PartitionB 
GO

INSERT INTO Everything(Id, PartitionKey, DATA)
SELECT 1, 'A', 'Some useful data' UNION
SELECT 2, 'A', 'Some useful data' UNION
SELECT 3, 'A', 'Some useful data' UNION
SELECT 4, 'B', 'Some useful data' UNION
SELECT 5, 'B', 'Some useful data' UNION
SELECT 6, 'B', 'Some useful data' UNION
SELECT 7, 'B', 'Some useful data'
GO

SELECT * FROM Everything
SELECT * FROM PartitionA
SELECT * FROM PartitionB