select -- Index list for a table
	OBJECT_NAME(A.object_id) as [Table]
	, A.index_id as [Id]
	, A.name as [Index]
	, A.type_desc as [Type]
	, A.is_unique as [Unique]
	, Z.Field_list as [Index_key_fields]
	, Y.Field_list as [Index_include_fields]
	, A.is_primary_key as [PK]
	, A.fill_factor as [Fill_factor]
	, (select [name] from sys.data_spaces where data_space_id = A.data_space_id) as Data_space_id
	--, '-----' as '-----'
	--, A.*
from sys.indexes A
outer apply 
(
	select 
	(
		select cast(Y.name as nvarchar) + ',' as 'data()' from sys.index_columns X
		inner join sys.columns Y on Y.object_id = A.object_id and Y.column_id = X.column_id
		where X.object_id = A.object_id and X.index_id = A.index_id and X.is_included_column = 0
		order by X.key_ordinal
		for xml path('')
	) as [Field_list]
) Z
outer apply 
(
	select 
	(
		select cast(Y.name as nvarchar) + ',' as 'data()' from sys.index_columns X
		inner join sys.columns Y on Y.object_id = A.object_id and Y.column_id = X.column_id
		where X.object_id = A.object_id and X.index_id = A.index_id and X.is_included_column = 1
		order by X.key_ordinal
		for xml path('')
	) as [Field_list]
) Y
where A.object_id = OBJECT_ID('Some_table_name') -- Table name here!
order by A.object_id, A.index_id
;
