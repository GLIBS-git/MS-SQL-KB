--USE Production_DB_name; -- Some columns are database dependent

SELECT -- Locks (grouped)
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
	, object_name(A.table_id, A.resource_database_id) as [Table]
	, Z.name as [Index]
	, Z.type_desc as [Index_type]
	, count(*) as [Qty]
	, A.Blocker as [Blocker_session]
	, W.trans_duration as [Trans_duration]
	, W.trans_state as [Trans_state]
	, W.trans_type as [Trans_type]
	, W.name as [Trans_name]
FROM
(
	select 
		X.resource_database_id
		, X.request_session_id
		, X.request_owner_type
		, X.request_owner_id
		, X.resource_type
		, X.request_mode
		, X.request_type
		, X.resource_subtype
		, X.request_status
		, case
			when X.resource_type = 'OBJECT' then X.resource_associated_entity_id
			when X.resource_type = 'PAGE' or X.resource_type = 'KEY' or X.resource_type = 'RID' then (select top 1 object_id from sys.partitions where hobt_id = X.resource_associated_entity_id)
			when X.resource_type = 'METADATA'
				then (case when SUBSTRING(X.resource_description, 1, 12) = 'object_id = ' then SUBSTRING(X.resource_description, 13, CHARINDEX(',', X.resource_description, 13) - 13) else null end)
			else null
		  end as [table_id]
		, case
			when X.resource_type = 'KEY' then (select top 1 index_id from sys.partitions where hobt_id = X.resource_associated_entity_id)
			else null
		  end as [index_id]
		, case 
			when X.request_status = 'WAIT' then
				(
					select top 1 request_session_id from sys.dm_tran_locks
					where resource_description = X.resource_description
					and resource_associated_entity_id = X.resource_associated_entity_id
					and resource_type = X.resource_type
					and resource_subtype = X.resource_subtype
					and resource_database_id = X.resource_database_id
					and request_status = 'GRANT'
					and request_type = 'LOCK'
					and request_mode in ('X', 'S')
				)
			when X.request_status = 'CONVERT' then
				(
					select top 1 request_session_id from sys.dm_tran_locks
					where resource_description = X.resource_description
					and resource_associated_entity_id = X.resource_associated_entity_id
					and resource_type = X.resource_type
					and resource_subtype = X.resource_subtype
					and resource_database_id = X.resource_database_id
					and request_status = 'GRANT'
					and request_type = 'LOCK'
					and request_mode in ('S', 'RangeS-S')
				)
			else null 
		  end as [Blocker] 
	from sys.dm_tran_locks X
	where X.resource_database_id in (db_id('Production_DB'), db_id('Buffer_DB'))
	and X.request_owner_type <> 'SHARED_TRANSACTION_WORKSPACE'
	and X.request_session_id <> @@SPID
	and X.request_session_id in (302) -- Session
	--and X.request_owner_id = 189889650 -- Transaction
	--and ((X.request_status = 'WAIT' or X.request_status = 'CONVERT') or (X.resource_type = 'OBJECT' and X.request_mode = 'X' and X.resource_subtype <> 'UPDSTATS')) -- Problem 
) A
cross apply 
(
	select case
		when A.resource_type = 'OBJECT' then 1
		when A.resource_type = 'PAGE' then 2
		when A.resource_type = 'KEY' then 3
		when A.resource_type = 'EXTENT' then 4
		when A.resource_type = 'RID' then 5
		else 0
	  end as [resource_type_sort]
) Y
outer apply 
(
	select top 1 name, type_desc from sys.indexes where object_id = A.table_id and index_id = A.index_id	
) Z
outer apply
(
	SELECT top 1
		cast(GETDATE() - V.transaction_begin_time as time(0))as [trans_duration]
		, V.transaction_id
		, case
			when V.transaction_type = 1 then 'Read-Write'
			when V.transaction_type = 2 then 'Read only'
			when V.transaction_type = 3 then 'System'
			when V.transaction_type = 4 then 'Distributed'
			else cast(V.transaction_type as varchar)
		  end as [trans_type]
		, case
			when V.transaction_state = 0 then 'Not initialized'
			when V.transaction_state = 1 then 'Initialized not started'
			when V.transaction_state = 2 then 'Active'
			when V.transaction_state = 3 then 'Ended'
			when V.transaction_state = 4 then 'Commit distributed'
			when V.transaction_state = 5 then 'Waiting resolution'
			when V.transaction_state = 6 then 'Committed'
			when V.transaction_state = 7 then 'Rolling back'
			when V.transaction_state = 8 then 'Rolled back'
			else cast(V.transaction_state as varchar)
		  end as [trans_state]
		, V.name
	FROM sys.dm_tran_active_transactions V
	where V.transaction_id = A.request_owner_id
) W
group by 
	A.resource_database_id
	, A.request_session_id
	, A.request_owner_type
	, A.request_owner_id
	, A.request_mode
	, A.resource_type
	, A.request_type
	, A.resource_subtype
	, A.request_status
	, A.table_id
	, A.index_id
	, A.Blocker
	, Y.resource_type_sort
	, Z.name
	, Z.type_desc
	, W.trans_duration
	, W.trans_state
	, W.trans_type
	, W.name
order by A.request_session_id, [Table], Y.resource_type_sort
;
