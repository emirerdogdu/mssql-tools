SELECT
    S.name as 'Schema',
    T.name as 'Table',
    I.name as 'Index',
    DDIPS.avg_fragmentation_in_percent,
    DDIPS.page_count,
    'alter index [' + I.name + '] on [' + T.name + '] rebuild'
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS DDIPS
INNER JOIN sys.tables T on T.object_id = DDIPS.object_id
INNER JOIN sys.schemas S on T.schema_id = S.schema_id
INNER JOIN sys.indexes I ON I.object_id = DDIPS.object_id
AND DDIPS.index_id = I.index_id
WHERE DDIPS.database_id = DB_ID()
and I.name is not null
AND DDIPS.avg_fragmentation_in_percent >= 60
ORDER BY DDIPS.avg_fragmentation_in_percent desc

SELECT
    s.name  AS [Schema],
    t.name  AS [Table],
    i.name  AS [Index],
    ips.avg_fragmentation_in_percent,
    ips.page_count,
    CONCAT('ALTER INDEX [', i.name, '] ON [', s.name, '].[', t.name, '] REORGANIZE;') AS ReorgCmd,
    CONCAT('ALTER INDEX [', i.name, '] ON [', s.name, '].[', t.name, '] REBUILD;')    AS RebuildCmd
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') ips
JOIN sys.tables  t ON t.object_id  = ips.object_id
JOIN sys.schemas s ON s.schema_id  = t.schema_id
JOIN sys.indexes i ON i.object_id  = ips.object_id AND i.index_id = ips.index_id
WHERE i.index_id > 0                 
  AND i.is_disabled = 0
  AND ips.page_count >= 1000         
  AND ips.avg_fragmentation_in_percent >= 30
ORDER BY ips.avg_fragmentation_in_percent DESC;
