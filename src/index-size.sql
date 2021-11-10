select * from (
    select 
        i.[name] IndexName,
        ((SUM(s.[used_page_count]) * 8.0) / 1024.0) / 1024.0 IndexSizeGB
    from sys.dm_db_partition_stats as s
    join sys.indexes as i on s.[object_id] = i.[object_id] and s.[index_id] = i.[index_id]
    group by i.[name]
) A
order by A.IndexSizeGB desc