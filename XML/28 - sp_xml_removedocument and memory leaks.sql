EXEC sys.sp_configure N'max server memory (MB)', N'512'
GO
RECONFIGURE WITH OVERRIDE
GO

------------------------------------------------------

SELECT used_mb = pages_in_bytes / 1024 / 1024.
     , max_used_mb = max_pages_in_bytes / 1024 / 1024.
FROM sys.dm_os_memory_objects
WHERE [type] = 'MEMOBJ_MSXML' -- ~1/8 from 512MB = ~64MB

DECLARE @doc INT
      , @i INT = 0
      , @x XML = N'<item name="Hello world!" />'

WHILE @i < 1000 BEGIN

      EXEC sys.sp_xml_preparedocument @doc OUTPUT, @x
      -- ...
      --EXEC sys.sp_xml_removedocument @doc

      SET @i += 1

END

SELECT used_mb = pages_in_bytes / 1024 / 1024.
     , max_used_mb = max_pages_in_bytes / 1024 / 1024.
FROM sys.dm_os_memory_objects
WHERE [type] = 'MEMOBJ_MSXML'
GO

/*
    Msg 6624, Level 16, State 12, Procedure sp_xml_preparedocument, Line 1 [Batch Start Line 7]
    Error: 6624, Severity: 16, State: 12. (Params:). The error is printed in terse mode because there was error during formatting. Tracing, ETW, notifications etc are skipped.
    Msg 701, Level 17, State 123, Line 18
    There is insufficient system memory in resource pool 'default' to run this query.
*/

------------------------------------------------------

/* fix: restart SQL Server or sp_xml_removedocument 1..2147483647 */

DECLARE @doc INT = 1

WHILE EXISTS(
    SELECT *
    FROM sys.dm_os_memory_objects
    WHERE type = 'MEMOBJ_MSXML'
        AND pages_in_bytes > 8
)
BEGIN
    BEGIN TRY
        EXEC sys.sp_xml_removedocument @doc
    END TRY
        --Msg 8179, Level 16, State 5, Procedure sp_xml_removedocument, Line 1 [Batch Start Line 48]
        --Could not find prepared statement with handle 77.
        --Msg 6607, Level 16, State 3, Procedure sp_xml_removedocument, Line 1
        --sp_xml_removedocument: The value supplied for parameter number 1 is invalid.
    BEGIN CATCH
        IF ERROR_NUMBER() NOT IN (8179, 6607)
            BREAK
    END CATCH

    SET @doc +=1
END

------------------------------------------------------

EXEC sys.sp_configure N'max server memory (MB)', N'2147483647'
GO
RECONFIGURE WITH OVERRIDE
GO
