select	OBJECT_NAME(A.[object_id]) as Table_name -- Distribution of tables and indexes by file groups
		, A.[name] as Index_name
		, A.type_desc as Type_desc_
		, B.[name] as File_group
		, A.fill_factor as Fill_factor
		, B.is_default as Is_default
		--, B.data_space_id as Data_space_id
		--, '-----' as '-----'
		--, A.* 
from sys.indexes A
left join sys.data_spaces B on B.data_space_id = A.data_space_id
order by Table_name, A.index_id
;
