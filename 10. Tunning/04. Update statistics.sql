UPDATE STATISTICS [Some_table_name];

dbcc show_statistics ('InventDim', _WA_Sys_00000003_17246572); -- with histogram;
dbcc show_statistics ('NAMEALIASKERNELTABLE_MRC', I_50512PICKUPCERTIDX);

CREATE STATISTICS Stat_1 ON inventitembarcode (dataareaid, itemid) WITH FULLSCAN, PERSIST_SAMPLE_PERCENT = ON; -- WITH SAMPLE 5 PERCENT; WHERE ItemGroupId = 'Test'; NORECOMPUTE; PERSIST_SAMPLE_PERCENT = ON
update statistics NAMEALIASKERNELTABLE_MRC (I_50512PICKUPCERTIDX) with fullscan; -- WITH SAMPLE 5 PERCENT;
DROP STATISTICS inventitembarcode.Stat_1;










