USE Production_DB;

EXEC sys.sp_cdc_enable_table -- CDC enable for table
    @source_schema = 'dbo',
    @source_name   = 'Test_1',
    @role_name     = NULL,
    @supports_net_changes = 1
;

EXEC sys.sp_cdc_enable_table -- CDC enable second copy for table
    @source_schema = 'dbo',
    @source_name = 'Test_1',
	@capture_instance = 'dbo_Test_1_new',
	@role_name = NULL,
    @supports_net_changes = 1
;

EXEC sys.sp_cdc_disable_table -- CDC disable for table
    @source_schema = 'dbo',
    @source_name = 'Test_1',
	@capture_instance = 'dbo_Test_1_new'
;





