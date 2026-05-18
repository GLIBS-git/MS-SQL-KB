SELECT DB_NAME(database_id) AS DatabaseName, is_auto_cleanup_on, retention_period, retention_period_units_desc FROM sys.change_tracking_databases; -- Change thacking enabled databases

--USE Production_DB_name; -- Database dependent!
SELECT OBJECT_NAME(object_id) AS TableName FROM sys.change_tracking_tables; -- Change tracking tables list


select * from sys.internal_tables where internal_type = 209; -- Change tracking tables
exec sp_spaceused 'sys.change_tracking_356261120'; -- Space used by change tracking table
exec sp_help 'sys.change_tracking_356261120'; -- Change tracking table structure 





