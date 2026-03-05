-- Allow free-text values in Products.collection.
-- This removes any CHECK constraint that references [collection] on dbo.Products.

DECLARE @dropSql NVARCHAR(MAX) = N'';

SELECT @dropSql = @dropSql
        + N'ALTER TABLE dbo.Products DROP CONSTRAINT [' + cc.name + N'];'
        + CHAR(10)
FROM sys.check_constraints cc
WHERE cc.parent_object_id = OBJECT_ID(N'dbo.Products')
  AND cc.definition LIKE N'%[[]collection[]]%';

IF LEN(@dropSql) > 0
BEGIN
    EXEC sp_executesql @dropSql;
END
