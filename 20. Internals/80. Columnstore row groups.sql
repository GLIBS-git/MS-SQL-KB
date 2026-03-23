--USE Production_DB_name; -- Database dependent

select OBJECT_NAME(A.object_id) as Table_name -- Columnstore row groups
	, B.name as Index_name
	, B.type_desc as Index_type
	, A.partition_number as Partition_number
	, A.row_group_id as Row_group_id
	, A.delta_store_hobt_id as Delta_store_hobt_id
	, A.state_description as Row_group_state
	, A.total_rows as Total_rows
	, A.deleted_rows as deleted_rows
	, A.size_in_bytes as Size_bytes
	--, '-------' as [-------]
	--, A.* 
from sys.column_store_row_groups A
outer apply (
	select [name], type_desc from sys.indexes where object_id = A.object_id
) B
where A.object_id in (OBJECT_ID('Some_table_name'))
;

