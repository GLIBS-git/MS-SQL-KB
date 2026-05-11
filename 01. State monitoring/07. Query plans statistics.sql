SELECT -- Query plans statistics
	SUBSTRING(Z.text, (A.statement_start_offset / 2) + 1, ((CASE statement_end_offset WHEN -1 THEN DATALENGTH(Z.text) ELSE A.statement_end_offset END - A.statement_start_offset) / 2) + 1) AS [SQL]
	--, (SELECT query_plan FROM sys.dm_exec_query_plan(A.plan_handle)) as [Plan]
	, A.execution_count as Executions
	, A.total_worker_time / 1000 as Total_CPU_time
	, A.total_worker_time / A.execution_count / 1000 Average_CPU_time
	, A.total_elapsed_time / 1000 as Total_elapsed_time
	, A.total_elapsed_time / A.execution_count / 1000 Average_elapsed_time
	, A.min_elapsed_time / 1000 as Min_elapsed_time
	, A.max_elapsed_time / 1000 as Max_elapsed_time
	, A.total_physical_reads as [Physical reads]
	, A.total_physical_reads / A.execution_count as Average_physical_reads
	, A.total_logical_reads as Logical_reads
	, A.total_logical_reads / A.execution_count as Average_logical_reads
	, A.total_logical_writes as Logical_writes
	, A.total_logical_writes / A.execution_count as Average_logical_writes
	, A.total_rows as [Rows]
	, A.total_rows / A.execution_count as Average_rows
	, A.creation_time as Created
	, A.last_execution_time as Last_executed
	, A.plan_generation_num as Plan_generated
	, A.sql_handle as [SQL_handle]
	, A.plan_handle as Plan_handle
	--, Z.text as [Full_SQL]	
	--, '-----' as [-----]
	--, A.*
FROM sys.dm_exec_query_stats A
outer apply
(
	SELECT text FROM sys.dm_exec_sql_text(A.sql_handle)
) Z
--where A.execution_count > 10
--order by A.total_elapsed_time / A.execution_count desc
order by A.total_elapsed_time desc
--order by A.total_logical_reads desc
;
