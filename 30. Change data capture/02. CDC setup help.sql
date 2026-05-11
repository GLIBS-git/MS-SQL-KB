--USE Production_DB_name; -- Database dependent

SELECT [name], object_id, is_tracked_by_cdc from sys.tables; -- CDC status for tables

SELECT [name], object_id, is_tracked_by_cdc from sys.tables where is_tracked_by_cdc = 1; -- only CDC enabled tables

EXEC sys.sp_cdc_help_change_data_capture; -- CDC setup for tables help

EXEC sys.sp_cdc_help_jobs; -- CDC jobs setup: CDC tables cleanup interval and other. More details in help.










