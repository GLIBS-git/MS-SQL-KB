--USE Production_DB_name; -- Database dependent

SELECT	A.name -- Columns for a table
		, A.column_id 
		, (SELECT [name] FROM sys.types WHERE system_type_id = A.system_type_id and user_type_id = A.user_type_id) Data_type
FROM sys.columns A
WHERE A.object_id = 1894124613 -- Filter on object id here
;






