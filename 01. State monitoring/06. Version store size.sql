select	db_name(database_id) as [DB_name] -- Version store size 
		, reserved_page_count as Reserved_page_count
		, reserved_space_kb as Reserved_space_kb
from sys.dm_tran_version_store_space_usage
;
