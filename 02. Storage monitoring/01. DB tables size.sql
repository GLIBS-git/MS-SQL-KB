--USE Production_DB_name; -- Database dependent

SELECT	OBJECT_NAME(A.[object_id]) AS Table_name -- DB tables size
		, CASE WHEN A.Index_id = 0 THEN 'HEAP' WHEN A.Index_id = 1 THEN 'CLUSTERED' ELSE '##ERROR##' END AS Index_type
		, A.Row_count AS [Rows]
		, (A.Reserved_data + A.Reserved_index) * 8 AS Reserved_all_Kb
		, A.Reserved_data * 8 AS Reserved_data_Kb
		, A.Reserved_index * 8 AS Reserved_index_Kb
		, CASE WHEN Reserved_data <> 0 THEN ROUND(CONVERT(real, A.Reserved_lob_data) / CONVERT(real, A.Reserved_data) * 100, 1) ELSE 0 END AS Reserved_lob_data_percent 
		, CASE WHEN Reserved_data <> 0 THEN ROUND(CONVERT(real, A.Reserved_index) / CONVERT(real, A.Reserved_data) * 100, 1) ELSE 0 END AS Reserved_index_percent 
		, CASE WHEN A.Row_count <> 0 THEN ROUND(CONVERT(real, A.Reserved_data) / CONVERT(real, A.Row_count) * 8 * 1024, 0) ELSE 0 END AS Average_row_size_bytes 
FROM (
	SELECT	[object_id], MIN([index_id]) AS Index_id, MAX(row_count) AS Row_count
			, SUM(CASE WHEN [index_id] <= 1 THEN (in_row_reserved_page_count + lob_reserved_page_count + row_overflow_reserved_page_count) ELSE 0 END) AS Reserved_data
			, SUM(CASE WHEN [index_id] > 1 THEN (in_row_reserved_page_count + lob_reserved_page_count + row_overflow_reserved_page_count) ELSE 0 END) AS Reserved_index
			, SUM(CASE WHEN [index_id] <= 1 THEN lob_reserved_page_count ELSE 0 END) AS Reserved_lob_data
	FROM sys.dm_db_partition_stats 
	--WHERE [object_id] in (OBJECT_ID('Some_table_name')) -- Some tables or comment for all tables
	--WHERE [object_id] in (1,2,3) -- Some table IDs or comment for all tables
	GROUP BY [object_id]
) A
ORDER BY Reserved_all_Kb DESC
;




