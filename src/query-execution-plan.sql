select
     q.[text],
     SUBSTRING(q.text, (qs.statement_start_offset/2)+1,
        ((CASE qs.statement_end_offset
          WHEN -1 THEN DATALENGTH(q.text)
         ELSE qs.statement_end_offset
         END - qs.statement_start_offset)/2) + 1) AS statement_text,        
     qs.last_execution_time,
     qs.execution_count,
     qs.total_logical_reads as total_logical_read,
     qs.total_logical_reads/execution_count as avg_logical_read,
     qs.total_worker_time/1000000 as total_cpu_time_sn,
     qs.total_worker_time/qs.execution_count/1000 as avg_cpu_time_ms,
     qp.query_plan,
     DB_NAME(q.dbid) as database_name,
     q.objectid,
     q.number,
     q.encrypted
from
    (select top 50
          qs.last_execution_time,
          qs.execution_count,
          qs.plan_handle,
          qs.total_worker_time,
          qs.total_logical_reads,
          qs.statement_start_offset,
          qs.statement_end_offset
    from sys.dm_exec_query_stats qs
    order by qs.total_worker_time desc) qs
cross apply sys.dm_exec_sql_text(plan_handle) q
cross apply sys.dm_exec_query_plan(plan_handle) qp
order by avg_cpu_time_ms desc