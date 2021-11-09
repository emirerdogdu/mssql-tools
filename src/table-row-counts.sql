SELECT 
    T.name [TABLE NAME],
    I.rows [ROWCOUNT]
FROM sys.tables T
INNER JOIN sys.sysindexes I ON T.object_id = I.id AND I.indid < 2
ORDER BY I.rows DESC 