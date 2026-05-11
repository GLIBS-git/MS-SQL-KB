SELECT -- Open cursors
	A.session_id as [Session]
	, db_name((select top 1 database_id from sys.dm_exec_sessions where session_id = A.session_id)) as [DataBase]
	, A.cursor_id as [Cursor_ID]
	, SUBSTRING(Z.text, (A.statement_start_offset / 2) + 1, ((CASE A.statement_end_offset WHEN -1 THEN DATALENGTH(Z.text) ELSE A.statement_end_offset END - A.statement_start_offset) / 2) + 1) AS [SQL]
	, A.reads as [Reads]
	, A.writes as [Writes]
	, A.is_open as [Is_open]
	, A.fetch_status as [Fetch_status]
	, A.fetch_buffer_size as [Fetch_buffer_size]
	, A.worker_time as [CPU_time]
	, A.dormant_duration as [Dormant_duration]
	, A.is_close_on_commit as [Is_close_on_commit]
	, A.creation_time as [Created]
	, A.name as [Name]
	, A.sql_handle as [SQL_handle]
	, Z.text as [Full_SQL]
	, A.properties as Properties
	--, '-----' as [-----]
	--, A.*
FROM sys.dm_exec_cursors(0) A
outer apply
(
	SELECT top 1 text FROM sys.dm_exec_sql_text(A.sql_handle)
) Z
where A.session_id in(158)
;
