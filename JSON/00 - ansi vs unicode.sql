DECLARE @JSON_ANSI VARCHAR(MAX) =      '[{"Nąme":"Lenōvo モデ460"}]'
      , @JSON_Unicode NVARCHAR(MAX) = N'[{"Nąme":"Lenōvo モデ460"}]'

SELECT @JSON_ANSI, DATALENGTH(@JSON_ANSI)
UNION ALL
SELECT @JSON_Unicode, DATALENGTH(@JSON_Unicode)
GO

------------------------------------------------------

DECLARE @XML_ANSI XML =              '<root Nąme="Lenōvo モデ460" />'
      , @XML_Unicode XML = /* -> */ N'<root Nąme="Lenōvo モデ460" />'

SELECT @XML_ANSI, DATALENGTH(@XML_ANSI)
UNION ALL
SELECT @XML_Unicode, DATALENGTH(@XML_Unicode)

SELECT CAST(@XML_ANSI AS VARCHAR(MAX)), DATALENGTH(CAST(@XML_ANSI AS VARCHAR(MAX)))
UNION ALL
SELECT CAST(@XML_Unicode AS NVARCHAR(MAX)), DATALENGTH(CAST(@XML_Unicode AS NVARCHAR(MAX)))