--USE Production_DB_name; -- Database dependent

select OBJECT_NAME(B.[OBJECT_ID]) as Table_name  -- Columnstore segments
	, (select [name] from sys.columns where [object_id] = B.[object_id] and column_id = A.column_id) as Field
	, A.segment_id as Segment_id
	, A.[version] as [Version]
	, case 
		when A.encoding_type = 1 then 'VALUE_BASED (' + CAST(A.encoding_type as varchar) + ')'
		when A.encoding_type = 2 then 'VALUE_HASH_BASED (' + CAST(A.encoding_type as varchar) + ')'
		when A.encoding_type = 3 then 'STRING_HASH_BASED (' + CAST(A.encoding_type as varchar) + ')'
		when A.encoding_type = 4 then 'STORE_BY_VALUE_BASED (' + CAST(A.encoding_type as varchar) + ')'
		when A.encoding_type = 5 then 'STRING_STORE_BY_VALUE_BASED (' + CAST(A.encoding_type as varchar) + ')'
		else '#Unknown# (' + CAST(A.encoding_type as varchar) + ')'
	  end as Encoding_type
	, A.row_count as Row_count
	, A.primary_dictionary_id as Primary_dictionary_id
	, A.secondary_dictionary_id as Secondary_dictionary_id
	, A.has_nulls as Has_nulls
	--, '-------' as [-------]
	--, A.*
	--, '-------' as [-------]
	--, B.* 
from sys.column_store_segments A
inner join sys.partitions B on B.partition_id = A.partition_id and B.hobt_id = A.hobt_id
where B.[OBJECT_ID] in (OBJECT_ID('Some_table_name')) -- Table here of may be commented
order by Table_name, A.column_id
;
