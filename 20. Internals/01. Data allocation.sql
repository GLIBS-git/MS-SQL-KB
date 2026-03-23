select	A.partition_id as [Partition_id] -- Data allocation (partitions и allocation units)
		, OBJECT_NAME(A.object_id) as [Object_name]
		, C.name as Index_name
		, A.index_id as Index_id
		, C.type_desc Index_type
		, A.rows as Rows
		, B.allocation_unit_id as Allocation_unit
		, B.type_desc as Page_type
		, B.total_pages as Total_pages
		, B.total_pages * 8 as Total_pages_Kb
		, B.used_pages as Used_pages
		, B.data_pages as Data_pages
		, E.file_id as First_page_file
		, E.page_id as First_page_id
		, F.file_id as Root_page_file
		, F.page_id as Root_page_id
		, G.file_id as First_iam_page_file
		, G.page_id as First_iam_page_id
		--, B.type as Type_id
		--, A.data_compression_desc as Data_compression
		--, '-----' as '-----'
		--, * 
from sys.partitions A
join sys.allocation_units B on B.container_id = A.hobt_id
join sys.system_internals_allocation_units D on D.allocation_unit_id = B.allocation_unit_id
outer apply (select name, type_desc from sys.indexes where object_id = A.object_id and index_id = A.index_id) as C
outer apply sys.fn_PhysLocCracker(D.first_page) E
outer apply sys.fn_PhysLocCracker(D.root_page) F
outer apply sys.fn_PhysLocCracker(D.first_iam_page) G
where A.object_id = OBJECT_ID('SomeTableName') -- Table here or comment line
--where B.type_desc = 'ROW_OVERFLOW_DATA' -- IN_ROW_DATA, LOB_DATA, ROW_OVERFLOW_DATA
;
