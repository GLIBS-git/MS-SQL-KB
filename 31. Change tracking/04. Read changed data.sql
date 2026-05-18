--USE Production_DB_name; -- Database dependent!

select CHANGE_TRACKING_CURRENT_VERSION() as Track_version; -- Current change tracking version

select * from CHANGETABLE (CHANGES [Some_table_name], 0) as A; -- Read change trachikg data for table





