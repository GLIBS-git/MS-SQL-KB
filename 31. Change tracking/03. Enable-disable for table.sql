--USE Production_DB_name; -- Database dependent

ALTER TABLE [Some_table_name] ENABLE CHANGE_TRACKING WITH (TRACK_COLUMNS_UPDATED = ON); -- Enable change tracking for table



