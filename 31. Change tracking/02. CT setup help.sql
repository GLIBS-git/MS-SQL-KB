SELECT DB_NAME(database_id) AS DatabaseName, is_auto_cleanup_on, retention_period, retention_period_units_desc FROM sys.change_tracking_databases; -- Change thacking enabled databases

--USE Production_DB_name; -- Database dependent!
SELECT OBJECT_NAME(object_id) AS TableName FROM sys.change_tracking_tables; -- Change tracked tables list

select A.[name] as Table_name -- Change tracking tables
	, A.[object_id] as [Object_id]
	, (select top 1 [name] from sys.schemas where schema_id = A.schema_id) as Table_chema
	, OBJECT_NAME(A.parent_object_id) as Tracking_table
	, A.create_date as Created
	, A.modify_date as Modified
	--, '-----' as [-----]
	--, A.* 
from sys.internal_tables A 
where A.internal_type = 209
;

exec sp_spaceused 'sys.change_tracking_356261120'; -- Space used by change tracking table
exec sp_help 'sys.change_tracking_356261120'; -- Change tracking table structure 





