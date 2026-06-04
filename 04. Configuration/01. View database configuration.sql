select A.[name] as Name_ -- DB configuration: snapshot & recovery state
	, A.database_id as Id
	, A.recovery_model_desc as Recovery_model
	, case
		when A.is_read_committed_snapshot_on = 1 then 'ON'
		when A.is_read_committed_snapshot_on = 0 then 'OFF'
		else '#Unknown#'
	  end as Read_committed_snapshot_on
	, A.snapshot_isolation_state_desc as Snapshot_isolation_state
	--, '-----' as [-----]
	--, A.* 
from sys.databases A
;




