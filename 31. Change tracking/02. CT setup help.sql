SELECT DB_NAME(database_id) AS DatabaseName, is_auto_cleanup_on, retention_period, retention_period_units_desc FROM sys.change_tracking_databases; -- Change thacking enabled databases
