--USE Production_DB_name; -- Database dependent

select OBJECT_NAME(B.OBJECT_ID) as Table_name  -- Columnstore dictionaries
	, (select [name] from sys.columns where object_id = B.object_id and column_id = A.column_id) as Field
	, case 
		when A.dictionary_id = 0 then 'Common'
		else 'Local (' + cast(A.dictionary_id as varchar) + ')'
	  end as Dictionary_id
	, A.[version] as [Version]
	, case 
		when A.[type] = 1 then 'Hash dict: Integer'
		when A.[type] = 2 then 'Not used'
		when A.[type] = 3 then 'Hash dict: String'
		when A.[type] = 4 then 'Hash dict: Float'
		else '#Unknown# (' + cast(A.[type] as varchar) + ')'
	  end as [Type]
	, A.last_id as Last_id
	, A.entry_count as Entry_count
	, A.on_disk_size as On_disk_size
	--, '-------' as [-------]
	--, A.*
	--, '-------' as [-------]
	--, B.* 
from sys.column_store_dictionaries A
inner join sys.partitions B on B.partition_id = A.partition_id and B.hobt_id = A.hobt_id
where B.OBJECT_ID in (OBJECT_ID('Some_table_name')) -- Table here or line may be commented
order by Table_name, A.column_id
;
