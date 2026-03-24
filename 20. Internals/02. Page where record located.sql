--USE Production_DB_name; -- Database dependent

select top 100 B.*, '--------' as [--------], A.* from Some_table_name A -- with (nolock) -- Displays file number, page number and slot where actual record is located
outer apply sys.fn_PhysLocCracker(%%physloc%%) B
--where -- Optional condition
--order by -- Sorting if necessary
;
