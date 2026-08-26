--USE Production_DB_name; -- Database dependent

SELECT	A.[filename] AS [File_name] -- DB data files size
		, A.fileid AS [File_id]
		, C.[name] AS File_group
		, CONVERT(bigint, A.[size]) * 8 / 1024 /1024 AS Total_spece_Gb
		--, CONVERT(bigint, A.[size]) * 8 / 1024 AS Total_spece_Mb
		--, CONVERT(bigint, A.[size]) * 8 AS Total_spece_Kb
		--, B.unallocated_extent_page_count * 8 / 1024 / 1024 AS Not_alloc_extent_Gb
		, B.unallocated_extent_page_count * 8 / 1024 AS Not_alloc_extent_Mb
		--, B.unallocated_extent_page_count * 8 AS Not_alloc_extent_Kb
		, ROUND(CONVERT(real, B.unallocated_extent_page_count) / CONVERT(real, B.total_page_count) * 100, 2) AS Not_alloc_extent_percent
		, C.is_default AS Is_default
		, CASE WHEN A.maxsize > 0 THEN CONVERT(bigint, A.maxsize) * 8 ELSE A.maxsize END AS Max_size_Kb
		, A.growth * 8 AS Growth_Kb
		--, B.total_page_count * 8 AS Total_spece_Kb_alt
		, B.version_store_reserved_page_count * 8 AS Version_store_reserved_Kb
		--, '-------' AS [-------]
		--, *
		--, A.*
		--, B.*
FROM sys.sysfiles A
LEFT JOIN sys.dm_db_file_space_usage B ON B.[file_id] = A.fileid
LEFT JOIN sys.data_spaces C ON C.data_space_id = A.groupid
;


