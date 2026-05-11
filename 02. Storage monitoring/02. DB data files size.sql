select	A.[filename] as [File_name] -- DB data files size
		, A.fileid as [File_id]
		, C.[name] as File_group
		, convert(bigint, A.[size]) * 8 as Total_spece_Kb
		, B.unallocated_extent_page_count * 8 as Not_alloc_extent_Kb
		, ROUND(CONVERT(real, B.unallocated_extent_page_count) / CONVERT(real, B.total_page_count) * 100, 2) as Not_alloc_extent_percent
		, C.is_default as Is_default
		, case when A.maxsize > 0 then convert(bigint, A.maxsize) * 8 else A.maxsize end as Max_size_Kb
		, A.growth * 8 as Growth_Kb
		--, B.total_page_count * 8 as Total_spece_Kb_alt
		, B.version_store_reserved_page_count * 8 as Version_store_reserved_Kb
		--, '-------' as [-------]
		--, *
		--, A.*
		--, B.*
from sys.sysfiles A
left join sys.dm_db_file_space_usage B on B.[file_id] = A.fileid
left join sys.data_spaces C on C.data_space_id = A.groupid
;
