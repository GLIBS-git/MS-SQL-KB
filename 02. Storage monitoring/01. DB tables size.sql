select	OBJECT_NAME(A.[object_id]) as Table_name -- DB tables size
		, case when A.Index_id = 0 then 'HEAP' when A.Index_id = 1 then 'CLUSTERED' else '##ERROR##' end as Index_type
		, A.Row_count as [Rows]
		, (A.Reserved_data + A.Reserved_index) * 8 as Reserved_all_Kb
		, A.Reserved_data * 8 as Reserved_data_Kb
		, A.Reserved_index * 8 as Reserved_index_Kb
		, case when Reserved_data <> 0 then round(CONVERT(real, A.Reserved_lob_data) / CONVERT(real, A.Reserved_data) * 100, 1) else 0 end as Reserved_lob_data_percent 
		, case when Reserved_data <> 0 then round(CONVERT(real, A.Reserved_index) / CONVERT(real, A.Reserved_data) * 100, 1) else 0 end as Reserved_index_percent 
		, case when A.Row_count <> 0 then round(CONVERT(real, A.Reserved_data) / CONVERT(real, A.Row_count) * 8 * 1024, 0) else 0 end as Average_row_size_bytes 
from (
	select	[object_id], MIN([index_id]) as Index_id, MAX(row_count) as Row_count
			, SUM(case when [index_id] <= 1 then (in_row_reserved_page_count + lob_reserved_page_count + row_overflow_reserved_page_count) else 0 end) as Reserved_data
			, SUM(case when [index_id] > 1 then (in_row_reserved_page_count + lob_reserved_page_count + row_overflow_reserved_page_count) else 0 end) as Reserved_index
			, SUM(case when [index_id] <= 1 then lob_reserved_page_count else 0 end) as Reserved_lob_data
	from sys.dm_db_partition_stats 
	--where object_id in (OBJECT_ID('Some_table_name')) -- Some or all tables 
	group by [object_id]
) A
order by Reserved_all_Kb desc
;
