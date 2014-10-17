
IF OBJECT_ID('[<schema,,dbo>].[<function>]') IS NOT NULL
  DROP FUNCTION [<schema,,dbo>].[<function>]
GO

CREATE FUNCTION [<schema,,dbo>].[<function>]( ... parameters ... )
RETURNS <returnType,,INT> AS BEGIN

    RETURN @SomeValue
END
GO
