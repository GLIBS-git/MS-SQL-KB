select -- Index statistics
	DB_NAME(A.database_id) as [Database]
	, OBJECT_NAME(A.object_id, A.database_id) as [Table]
	, (select top 1 name from sys.indexes where object_id = A.object_id and index_id = A.index_id) as [Index]
	, (select top 1 type_desc from sys.indexes where object_id = A.object_id and index_id = A.index_id) as [Index type]
	, A.user_seeks as User_seeks
	, A.user_scans as User_scans
	, A.user_lookups as User_lookups
	, A.user_updates as User_updates
	, A.last_user_seek as Last_user_seek
	, A.last_user_scan as Last_user_scan
	, A.last_user_lookup as Last_user_lookup
	, A.last_user_update as Last_user_update
	, ( select cast(Y.name as nvarchar) + ',' as 'data()' from sys.index_columns X
		inner join sys.columns Y on Y.object_id = A.object_id and Y.column_id = X.column_id
		where X.object_id = A.object_id and X.index_id = A.index_id and X.is_included_column = 0
		order by X.key_ordinal
		for xml path('')
	  ) as [Index_key_fields]
	, ( select cast(Y.name as nvarchar) + ',' as 'data()' from sys.index_columns X
		inner join sys.columns Y on Y.object_id = A.object_id and Y.column_id = X.column_id
		where X.object_id = A.object_id and X.index_id = A.index_id and X.is_included_column = 1
		order by X.key_ordinal
		for xml path('')
	  ) as [Index_include_fields] 
	--, A.database_id as [DataBase ID]
	--, A.object_id as [Object ID]
	--, A.index_id as [Index ID]
	--, '-----' as [-----]
	--, A.*
from SYS.DM_DB_INDEX_USAGE_STATS A
where A.object_id = OBJECT_ID('Some_table_name') -- Table name here
and A.database_id = DB_ID('Production_DB_name') -- DB name here
order by A.database_id, A.object_id, A.index_id
;




