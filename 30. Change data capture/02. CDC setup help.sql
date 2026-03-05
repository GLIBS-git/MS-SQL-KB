USE Production_DB;

SELECT [name], object_id, is_tracked_by_cdc from sys.tables; -- CDC enabled tables

EXECUTE sys.sp_cdc_help_change_data_capture; -- CDC setup for tables help










