
-- =======================================================
-- Searchs a term on the body of procedures, functions, triggers, views or checks
-- =======================================================

DECLARE @query VARCHAR(1000) = '%query%'

SELECT DISTINCT
       [object_type] = CASE o.xtype
                       WHEN 'C' THEN 'CHECK'
                       WHEN 'TR' THEN 'TRIGGER'
                       WHEN 'P' THEN 'PROCEDURE'
                       WHEN 'V' THEN 'VIEW' END,
       [object_name] = o.name 
FROM syscomments c
INNER JOIN sysobjects o ON c.id=o.id
WHERE c.TEXT LIKE @query
