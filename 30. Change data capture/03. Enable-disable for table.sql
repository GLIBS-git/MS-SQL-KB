EXEC sys.sp_cdc_enable_table -- CDC enable for table
    @source_schema = 'dbo',
    @source_name   = 'Test_1',
    @role_name     = NULL,
    @supports_net_changes = 1
;
