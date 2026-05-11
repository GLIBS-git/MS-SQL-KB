SELECT -- Waiting tasks
	CAST(DATEADD(MS, A.wait_duration_ms, 0) as time) as [Wait_duration]
	, A.session_id as [Session]
	, A.blocking_session_id as [Blocker_session]
	, A.wait_type as [Wait_type]
	, A.resource_description as [Resource_description]
	, SUBSTRING(Z.text, (B.statement_start_offset / 2) + 1, ((CASE B.statement_end_offset WHEN -1 THEN DATALENGTH(Z.text) ELSE B.statement_end_offset END - B.statement_start_offset) / 2) + 1) AS [SQL]
	, case when B.database_id > 0 then DB_NAME(B.database_id) else '' end as [DataBase]
	, A.waiting_task_address as [Wait_task_address]
	, A.resource_address as [Resource_address]
	, A.blocking_task_address as [Block_task_address]
	--, B.database_id as [DB_id]
	--, B.sql_handle as [SQL_handle]
	--, Z.text as [Full_SQL]
	--, '-----' as [-----]
	--, A.*
	--, B.*
FROM sys.dm_os_waiting_tasks A
left join sys.dm_exec_requests B on B.task_address = A.waiting_task_address and B.session_id = A.session_id
outer apply
(
	SELECT top 1 text FROM sys.dm_exec_sql_text(B.sql_handle)
) Z
where A.wait_duration_ms < 2000000000
and B.database_id in (DB_ID('Production_DB_name'), db_id('Exchange_DB_name'))
--and A.session_id = 142
--and A.blocking_session_id is not null or A.wait_type like 'PAGEIOLATCH_%' -- Waiting due to locks or waiting for disk IO completing
--order by A.session_id desc
order by [Wait_duration] desc
;
