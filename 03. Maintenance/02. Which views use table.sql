--USE Production_DB_name; -- Database dependent!

select top 100 * from INFORMATION_SCHEMA.VIEWS -- Which views use table
where VIEW_DEFINITION like '%Table_name%' -- Table name here!
;



