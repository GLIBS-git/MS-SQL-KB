select A.[name] as Name_ -- DB configuration
	, A.database_id as Id
	, A.recovery_model_desc as Recovery_model
	, case
		when A.is_read_committed_snapshot_on = 1 then 'ON'
		when A.is_read_committed_snapshot_on = 0 then 'OFF'
		else '#Unknown#'
	  end as Read_committed_snapshot_on
	, A.snapshot_isolation_state_desc as Snapshot_isolation_state
	, A.state_desc as Db_state
	, A.is_auto_create_stats_on as Auto_create_stats
	, A.is_auto_update_stats_on as Auto_update_stats
	, A.collation_name as Collation
	--, '-----' as [-----]
	--, A.* 
from sys.databases A
;





