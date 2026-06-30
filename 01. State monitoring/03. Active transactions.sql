SELECT -- Open transactions (+ duration)
	cast(GETDATE() - A.transaction_begin_time as time(0))as [Duration]
	, A.transaction_id as [Transaction_ID]
	, DB_NAME(B.database_id) as [DataBase]
	, (select top 1 session_id from sys.dm_tran_session_transactions with (nolock) where transaction_id = A.transaction_id) as [Session]
	, case
		when A.transaction_type = 1 then 'Read-Write'
		when A.transaction_type = 2 then 'Read only'
		when A.transaction_type = 3 then 'System'
		when A.transaction_type = 4 then 'Distributed'
		else '#Unknown#'end as [Transaction_type]
	, case
		when A.transaction_state = 0 then 'Not initialized'
		when A.transaction_state = 1 then 'Initialized not started'
		when A.transaction_state = 2 then 'Active'
		when A.transaction_state = 3 then 'Ended'
		when A.transaction_state = 4 then 'Commit distributed'
		when A.transaction_state = 5 then 'Waiting resolution'
		when A.transaction_state = 6 then 'Committed'
		when A.transaction_state = 7 then 'Rolling back'
		when A.transaction_state = 8 then 'Rolled back'
		else '#Unknown#'
	  end as [Transaction_state]
	, A.transaction_begin_time as [Start_time]
	, A.name as [Name]
	, case
		when B.database_transaction_state = 1 then 'Not initialized'
		when B.database_transaction_state = 3 then 'Initialized not logging'
		when B.database_transaction_state = 4 then 'Logging'
		when B.database_transaction_state = 5 then 'Prepared'
		when B.database_transaction_state = 10 then 'Committed'
		when B.database_transaction_state = 11 then 'Rolled back'
		when B.database_transaction_state = 12 then 'Being committed'
		else '#Unknown#'
	  end as [DB_transaction_state]
	, B.database_transaction_log_record_count as [Log_records]
	, B.database_transaction_log_bytes_used as [Log_bytes_used]
	, B.database_transaction_log_bytes_reserved as [Log_bytes_reserved]
	, B.database_transaction_log_bytes_used_system as [Log_bytes_used_system]
	, B.database_transaction_log_bytes_reserved_system as [Log_bytes_reserved_system]
	--, B.database_transaction_begin_lsn as [Begin_lsn]
	--, B.database_transaction_last_lsn as [Last_lsn]
	--, B.database_transaction_most_recent_savepoint_lsn as [Recent_savepoint_lsn]
	--, B.database_transaction_commit_lsn as [Commit_lsn]
	--, B.database_transaction_last_rollback_lsn as [Last_rollback_lsn]
	--, B.database_transaction_next_undo_lsn as [Next_undo_lsn]
	--, '-----' as [-----]
	--, A.* 
	--, '-----' as [-----]
	--, B.* 
FROM sys.dm_tran_active_transactions A with (nolock)
left join sys.dm_tran_database_transactions B with (nolock) on B.transaction_id = A.transaction_id
-- One can adjust exemptions list for certain environment and tasks
where A.name not in ('worktable','WorkFileGroup_fake_worktable','workfile','sort_fake_worktable','sort_init','LobStorageProviderSession','GhostCleanupTask','topn_fake_worktable','SplitPage')
order by A.transaction_begin_time
;
