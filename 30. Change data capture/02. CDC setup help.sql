USE Production_DB;

SELECT [name], object_id, is_tracked_by_cdc from sys.tables; -- CDC enabled tables
