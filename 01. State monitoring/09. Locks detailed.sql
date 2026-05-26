SELECT -- Locks (detailed)
	db_name(A.resource_database_id) as [DataBase]
	, A.request_session_id as [Session]
	, A.request_owner_type as [Owner_type]
	, A.request_owner_id as [Owner_ID]
	, case
		when A.request_mode = 'X' then 'Exclusive (X)'
		when A.request_mode = 'IX' then 'Intend exclusive (IX)'
		when A.request_mode = 'U' then 'Update (U)'
		when A.request_mode = 'IU' then 'Intend update (IU)'
		when A.request_mode = 'S' then 'Shared (S)'
		when A.request_mode = 'Sch-S' then 'Shared scheme (Sch-S)'
		when A.request_mode = 'Sch-M' then 'Modify scheme (Sch-M)'
		when A.request_mode = 'IS' then 'Intend shared (IS)'
		when A.request_mode = 'RangeS-S' then 'Range shares (RangeS-S)'
		else A.request_mode
	  end as [Request_mode]
	, A.request_type as [Request_type]
	, A.request_status as [Request_status]
	, case
		when A.resource_type = 'OBJECT' then 'Table'
		when A.resource_type = 'PAGE' then 'Page'
		when A.resource_type = 'KEY' then 'Key'
		when A.resource_type = 'EXTENT' then 'Extent'
		when A.resource_type = 'RID' then 'Record'
		when A.resource_type = 'METADATA' then 'Metadata'
		when A.resource_type = 'DATABASE' then 'Database'
		when A.resource_type = 'FILE' then 'File'
		else A.resource_type
	  end as [Resource_type]
	, A.resource_subtype as [Resource_subtype]
	, case
		when A.resource_type = 'OBJECT' then OBJECT_NAME(A.resource_associated_entity_id, A.resource_database_id)
		when A.resource_type = 'PAGE' or A.resource_type = 'KEY' or A.resource_type = 'RID'
			then (select top 1 OBJECT_NAME(object_id, A.resource_database_id) from sys.partitions where hobt_id = A.resource_associated_entity_id)
		when A.resource_type = 'METADATA'
			then object_name(case when SUBSTRING(A.resource_description, 1, 12) = 'object_id = ' then SUBSTRING(A.resource_description, 13, CHARINDEX(',', A.resource_description, 13) - 13) else null end, A.resource_database_id)
		else null
	  end as [Table]
	, case
		when A.resource_type = 'KEY'
			then (select top 1 W.name from sys.partitions V inner join sys.indexes W on W.object_id = V.object_id and W.index_id = V.index_id where V.hobt_id = A.resource_associated_entity_id)
		else null
	  end as [Index]
	, A.resource_description as [Resource_description]
	, case 
		when A.request_status = 'WAIT' then
			(
				select top 1 '--' + request_mode + '--    (' + CAST(request_session_id as varchar) + ')' from sys.dm_tran_locks
				where resource_description = A.resource_description
				and resource_associated_entity_id = A.resource_associated_entity_id
				and resource_type = A.resource_type
				and resource_subtype = A.resource_subtype
				and resource_database_id = A.resource_database_id
				and request_status = 'GRANT'
				and request_type = 'LOCK'
				and request_mode in ('X', 'S')
			)
		when A.request_status = 'CONVERT' then
			(
				select top 1 '--' + request_mode + '--    (' + CAST(request_session_id as varchar) + ')' from sys.dm_tran_locks
				where resource_description = A.resource_description
				and resource_associated_entity_id = A.resource_associated_entity_id
				and resource_type = A.resource_type
				and resource_subtype = A.resource_subtype
				and resource_database_id = A.resource_database_id
				and request_status = 'GRANT'
				and request_type = 'LOCK'
				and request_mode in ('S', 'RangeS-S')
			)
		else null 
	  end as [Blocker_mode_session]
	, Z.Duration as [Trans_duration]
	, Z.TransType as [Trans_type]
	, Z.TransState as [Trans_state]
	, Z.transaction_begin_time as [Trans_start_time]
	, Z.name as [Trans_name]
	, A.resource_associated_entity_id as [Resource_associated_entity_ID]
	--, A.resource_database_id as [DB ID]
	--, '-----' as [-----]
	--, A.*
FROM sys.dm_tran_locks A
outer apply
(
	SELECT top 1
		cast(GETDATE() - Y.transaction_begin_time as time(0))as [Duration]
		, Y.transaction_id
		, case
			when Y.transaction_type = 1 then 'Read-Write'
			when Y.transaction_type = 2 then 'Read only'
			when Y.transaction_type = 3 then 'System'
			when Y.transaction_type = 4 then 'Distributed'
			else cast(Y.transaction_type as varchar)
		  end as [TransType]
		, case
			when Y.transaction_state = 0 then 'Not initialized'
			when Y.transaction_state = 1 then 'Initialized not started'
			when Y.transaction_state = 2 then 'Active'
			when Y.transaction_state = 3 then 'Ended'
			when Y.transaction_state = 4 then 'Commit distributed'
			when Y.transaction_state = 5 then 'Waiting resolution'
			when Y.transaction_state = 6 then 'Committed'
			when Y.transaction_state = 7 then 'Rolling back'
			when Y.transaction_state = 8 then 'Rolled back'
			else cast(Y.transaction_state as varchar)
		  end as [TransState]
		, Y.transaction_begin_time
		, Y.name
	FROM sys.dm_tran_active_transactions Y
	where Y.transaction_id = request_owner_id
) Z
where A.resource_database_id in (db_id('Production_DB'), db_id('Buffer_DB'))
--and A.resource_type = 'object'
and A.request_owner_type <> 'SHARED_TRANSACTION_WORKSPACE'
and A.request_session_id <> @@SPID
and A.request_session_id in (757) -- Session filter
--and A.resource_associated_entity_id = OBJECT_ID('Some_table_name')
--and A.request_owner_id = 5275803168
--and A.resource_description = '1:59154164'
--and ((A.request_status = 'WAIT' or A.request_status = 'CONVERT') or (A.resource_type = 'OBJECT' and A.request_mode = 'X' and A.resource_subtype <> 'UPDSTATS')) -- Problem locks
order by A.request_session_id, [Table], A.resource_type
;
