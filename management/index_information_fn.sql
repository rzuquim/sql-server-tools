
IF OBJECT_ID('[dbo].[IndexInformation]') IS NOT NULL
  DROP FUNCTION [dbo].[IndexInformation]
GO

CREATE FUNCTION IndexInformation() RETURNS TABLE AS RETURN (
    WITH IndexedColumns AS (
        SELECT name,
               ic.object_id,
               ic.index_id,
               is_included_column,
               ic.key_ordinal
        FROM sys.index_columns ic,
             sys.columns c
        WHERE ic.object_id=c.object_id AND ic.column_id = c.column_id 
    ), IndexesDetails AS (
        SELECT i.object_id, 
               i.index_id, 
               [indexed] = (SELECT stuff((SELECT ',' + name as [text()] 
                                          FROM IndexedColumns q
                                          WHERE q.object_id = i.object_id
                                                AND q.index_id=i.index_id AND q.is_included_column=0
                                          ORDER BY q.key_ordinal
                                          FOR XML path('')),1,1,'')),
               [included] = (SELECT stuff((SELECT ',' + name as [text()] 
                                           FROM IndexedColumns q
                                           WHERE q.object_id=I.object_id
                                                 AND q.index_id=i.index_id AND q.is_included_column=1
                                           FOR XML path('')),1,1,''))
        FROM IndexedColumns q, sys.indexes i, sys.objects o
        WHERE q.object_id = i.object_id
              AND q.index_id = i.index_id AND o.object_id = i.object_id 
              AND o.type not in ('S','IT') -- IT = Internal table, S = System base table
        GROUP BY i.object_id, i.index_id
    )
    SELECT id.object_id,
           [table] = schema_name(o.[schema_id]) + '.' + o.name,
           id.index_id,
           [index_name] = i.name,
           i.is_primary_key,
           i.type_desc,
           id.indexed,
           id.included,
           is_unique,fill_factor,
           i.is_padded,
           i.has_filter,
           i.filter_definition
    FROM IndexesDetails id, sys.objects o,sys.indexes i
    where id.object_id = o.object_id  AND id.object_id = i.object_id  AND id.index_id = i.index_id
)
GO

--- USAGE:
--- SELECT * 
--- FROM IndexInformation()

