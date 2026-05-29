SELECT -- Executing requests
	cast(getdate() - A.start_time as time) as Duration
	, A.cpu_time as [CPU_time]
	, A.total_elapsed_time as [Elapsed_time]
	, DB_NAME(A.database_id) as [DataBase]
	, A.session_id as [Session]
	, A.status as [Status]
	, A.command as [Command]
	, SUBSTRING(Z.text, (A.statement_start_offset / 2) + 1, ((CASE statement_end_offset WHEN -1 THEN DATALENGTH(Z.text) ELSE A.statement_end_offset END - A.statement_start_offset) / 2) + 1) AS [SQL]
	, (SELECT query_plan FROM sys.dm_exec_query_plan(A.plan_handle)) as [Plan]
	, A.blocking_session_id as [Blocking_session]
	, A.wait_type as [Wait_type]
	, A.wait_time as [Wait_time]
	, A.last_wait_type as [Last_wait_type]
	, A.reads as [Reads]
	, A.writes as [Writes]
	, A.logical_reads as [Logical_reads]
	, A.transaction_id as [Transaction]
	, W.login_name as [Login]
	, W.HOST_NAME as [Host_name]
	, W.program_name as [Application]
	, A.wait_resource as [Wait_resource]
	, A.start_time as [Start_time]
	, A.sql_handle as [SQL_handle]
	, A.plan_handle as [Plan_handle]
	, Z.text [Full_SQL]
	, case	when SUBSTRING(Z.text , 1, 16) = 'FETCH API_CURSOR' then 
				(
					SELECT (SELECT top 1 text FROM sys.dm_exec_sql_text(A.sql_handle)) + char(10) + char(10) as 'data()' 
					FROM sys.dm_exec_cursors(A.session_id) A
					for xml path('')
				)
			else '' 
		end as [Cursor_Sql]
	--, A.connection_id as Connection_id
	--, A.task_address as Task_address
	--, '-----' as [-----]
	--, A.* 
FROM sys.dm_exec_requests A with (nolock)
outer apply
(
	SELECT top 1 text FROM sys.dm_exec_sql_text(A.sql_handle)
) Z
outer apply
(
	select X.HOST_NAME, X.program_name, X.login_name from sys.dm_exec_sessions X with (nolock)
	inner join sys.dm_exec_connections Y with (nolock) on Y.session_id = X.session_id
	where Y.connection_id = A.connection_id
) W
where A.database_id in (db_id('Production_DB_name'), db_id('Buffer_DB_name'))
and A.session_id <> @@SPID
and A.command not in ('GHOST CLEANUP','CHECKPOINT','TM REQUEST','WAITFOR') -- Exemptions list
--and A.session_id in (451)
order by A.start_time
--order by A.session_id desc
;
