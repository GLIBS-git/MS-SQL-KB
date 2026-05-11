--USE Production_DB_name; -- Database dependent

select * from cdc.dbo_Test_1_CT; -- Read CDC data changes (only for investigating). [More description](/Help/04.%20Read%20changed%20data.md)
/Help/04.%20Read%20changed%20data.md

SELECT * FROM cdc.fn_cdc_get_all_changes_dbo_Test_1(0x00000293000001B80052, 0x0000029400000CE80001, 'all') as A; -- CDC read data changes (officially recommended)
SELECT * FROM cdc.fn_cdc_get_all_changes_dbo_Test_1(0x00000293000001B80052, 0x0000029400000CE80001, 'all update old') as A;
SELECT * FROM cdc.fn_cdc_get_net_changes_dbo_Test_1(0x00000293000001B80052, 0x0000029400000CE80001, 'all') as A;
SELECT * FROM cdc.fn_cdc_get_net_changes_dbo_Test_1(0x00000293000001B80052, 0x0000029400000CE80001, 'all with mask') as A;
SELECT * FROM cdc.fn_cdc_get_net_changes_dbo_Test_1(0x00000293000001B80052, 0x0000029400000CE80001, 'all with merge') as A;







