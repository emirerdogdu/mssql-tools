declare @DatabaseName varchar(50) = 'DATABASE_NAME';

select
    t.TABLE_NAME 'Table Name',
    c.COLUMN_NAME 'Column Name',
    c.DATA_TYPE 'Data Type',
    c.IS_NULLABLE 'Nullable',
    c.CHARACTER_MAXIMUM_LENGTH 'Max Length'
from INFORMATION_SCHEMA.TABLES t
join INFORMATION_SCHEMA.COLUMNS c on t.TABLE_NAME = c.TABLE_NAME
where t.TABLE_CATALOG = @DatabaseName and t.TABLE_SCHEMA = 'dbo' and t.TABLE_TYPE = 'BASE TABLE'
order by t.TABLE_NAME, c.ORDINAL_POSITION