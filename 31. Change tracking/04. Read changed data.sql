--USE Production_DB_name; -- Database dependent!

select CHANGE_TRACKING_CURRENT_VERSION() as Track_version; -- Current change tracking version

select * from CHANGETABLE (CHANGES [Some_table_name], 0) as A -- Read change trachikg data for table
--where CHANGE_TRACKING_IS_COLUMN_IN_MASK(COLUMNPROPERTY(OBJECT_ID('Table_name'), 'Column_name', 'ColumnId'), A.SYS_CHANGE_COLUMNS) = 1 -- Only changes for some column
;





