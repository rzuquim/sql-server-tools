
IF OBJECT_ID('[<schema,,dbo>].[<function>]') IS NOT NULL
  DROP FUNCTION [<schema,,dbo>].[<function>]
GO

CREATE FUNCTION [<schema,,dbo>].[<function>]( ... parameters ... )
RETURNS  <returnVar,,@myTable> TABLE (
    ... columns returned by the FUNCTION ..
) AS BEGIN

    RETURN
END

