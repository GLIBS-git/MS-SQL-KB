SELECT DB_NAME(database_id) AS DatabaseName, is_auto_cleanup_on, retention_period, retention_period_units_desc FROM sys.change_tracking_databases; -- Change thacking enabled databases

--USE Production_DB_name; -- Database dependent!
SELECT OBJECT_NAME(object_id) AS TableName FROM sys.change_tracking_tables; -- Change tracked tables list

SELECT A.[name] AS Table_name -- Change tracking tables
	, A.[object_id] AS [Object_id]
	, (SELECT TOP 1 [name] FROM sys.schemas WHERE schema_id = A.schema_id) AS Table_chema
	, OBJECT_NAME(A.parent_object_id) AS Tracking_table
	, A.create_date AS Created
	, A.modify_date AS Modified
	--, '-----' AS [-----]
	--, A.* 
FROM sys.internal_tables A 
WHERE A.internal_type = 209
;

-- Read help!
EXEC sp_spaceused 'sys.change_tracking_356261120'; -- Space used by change tracking table
EXEC sp_help 'sys.change_tracking_356261120'; -- Change tracking table structure.





