select -- Active sessions
	A.session_id as [Session]
	, db_name(A.database_id) as [DataBase]
	, A.status as [Status]
	, A.open_transaction_count as [Open_transactions]
	, (select count(*) from sys.dm_exec_cursors(A.session_id)) as [Open_cursors]
	, (select count(*) from sys.dm_exec_requests where session_id = A.session_id) as [Executing_requests]
	, (SELECT top 1 text FROM sys.dm_exec_sql_text(B.most_recent_sql_handle)) as [Last_SQL]
	, A.login_time as [Login_time]
	, A.cpu_time as [CPU_time]
	, A.total_elapsed_time [Elapsed_time]
	, A.memory_usage as [Memory_usage]
	, A.last_request_start_time as Last_request_start_time
	, A.last_request_end_time as Last_request_end_time
	, A.reads as [Reads]
	, A.writes as [Writes]
	, A.logical_reads as [Logical_reads]
	, A.row_count as [Row_count]
	, case
		when A.transaction_isolation_level = 0 then 'Unspecified'
		when A.transaction_isolation_level = 1 then 'Read Uncomitted'
		when A.transaction_isolation_level = 2 then 'Read Committed'
		when A.transaction_isolation_level = 3 then 'Repeatable read'
		when A.transaction_isolation_level = 4 then 'Serializable'
		when A.transaction_isolation_level = 5 then 'Snapshot'
		else cast(A.transaction_isolation_level as varchar)
	  end as [Transaction_isolation_level]
	, A.host_name as [Host_name]
	, A.login_name as [Login]
	, A.program_name as [Application_name]
	, A.total_scheduled_time as Total_scheduled_time
	, A.is_user_process as Is_user_process
	, A.original_login_name as Original_login_name
	, B.connect_time as Connect_time
	, B.num_reads as Num_reads
	, B.num_writes as Num_writes
	, B.client_net_address as Client_net_address
	, B.last_read as Last_read
	, B.last_write as Last_write
	--, B.most_recent_sql_handle as [SQL_handle]
	--, B.client_tcp_port as Client_tcp_port
	--, B.local_net_address as Local_net_address
	--, B.local_tcp_port as Local_tcp_port
	--, B.connection_id as Connection_id
	--, '-----' as [-----]
	--, A.*
	--, '-----' as [-----]
	--, B.*
from sys.dm_exec_sessions A
left join sys.dm_exec_connections B on B.session_id = A.session_id
--where A.database_id in (db_id('Production_DB_name'), db_id('Buffer_DB_name')) -- DB filter
where A.session_id in (440,275) -- Session filter
;
