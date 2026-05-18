select top 100 * from INFORMATION_SCHEMA.VIEWS -- Which views use table
where VIEW_DEFINITION like '%Table_name%'
;



