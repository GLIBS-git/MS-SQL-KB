--USE Production_DB_name; -- Database dependent

select -- Statistics for a table
	OBJECT_NAME(A.object_id) as [Table] 
	, A.stats_id as Stats_id
	, A.name as [Stats_name]
	, A.auto_created as Auto_created
	, A.user_created as User_created
	, A.no_recompute as No_recompute
	, A.has_filter as Has_filter
	, Z.Field_list as [Stats_fields]
	, Y.last_updated as Last_updated
	, Y.[rows] as [Rows]
	, Y.rows_sampled as Rows_sampled
	, Y.steps as Steps
	, Y.unfiltered_rows as Unfiltered_rows
	, Y.modification_counter as Modification_counter
	, Y.persisted_sample_percent as Persisted_sample_percent
	--, '-----' as [-----]
	--, A.*
	--, Y.*
from sys.stats A
outer apply 
(
	select 
	(
		select cast(Y.name as nvarchar) + ',' as 'data()' from sys.stats_columns X
		inner join sys.columns Y on Y.object_id = A.object_id and Y.column_id = X.column_id
		where X.object_id = A.object_id and X.stats_id = A.stats_id
		order by X.stats_column_id
		for xml path('')
	) as [Field_list]
) Z
outer apply
(
	select * from sys.dm_db_stats_properties(A.object_id, A.stats_id)
) Y
where A.object_id = OBJECT_ID('Some_table_name') -- Table name here
order by A.object_id, A.stats_id
;
