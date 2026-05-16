--USE Production_DB_name; -- Database dependent

checkpoint; -- Allow truncate transaction log in simple recovery mode to shorten output (test environment only)

select  -- Reading BD transaction log
	[Current LSN], [Previous LSN], [Operation], Context, [Transaction ID], [Parent Transaction ID], [Transaction Name]
	, CONVERT(int, CONVERT(binary(2), '0x' + SUBSTRING([Page ID], 1, 4), 1)) as [File], CONVERT(int, CONVERT(binary(4), '0x' + SUBSTRING([Page ID], 6, 10), 1)) as [Page], [Slot ID]
	, [Begin Time], [Transaction SID], SPID
	, [AllocUnitName], [Lock Information], [Num Elements]
	--, [RowLog Contents 0], [RowLog Contents 1], [RowLog Contents 2], [Page ID]
--select * 
from sys.fn_dblog(null,null)
where [Transaction ID] in('0000:0023cabe','0000:0023cac2','0000:0023cac5','0000:0023cabf','0000:0023cac3','0000:0023cac6')
--where AllocUnitName like '%dbo.Test_1.Test_1_t1_clust%'
--where [Current LSN] >= '000002d6:00000300:0003'
--where [Transaction ID] in('0005:73bfb941','0005:73bfb940','0005:73bfb942','0005:73bfb943') -- or [Current LSN] = '000e682f:00cfa1db:0005'
--where [Transaction ID] in('0000:00233e09') -- or [Current LSN] = '000e682f:00cfa1db:0005'
--where Operation = 'LOP_INSERT_ROWS'
--where spid = '92'
;

select * 
from sys.fn_dblog(null,null)
where [SPID] = 71
;
