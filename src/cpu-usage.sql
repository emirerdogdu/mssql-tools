select top 200
    start_time,
    [cpu usage %] = avg_cpu_percent,
    reserved_storage_mb, storage_space_used_mb, io_requests, io_bytes_read, io_bytes_written
from sys.server_resource_stats
order by start_time desc