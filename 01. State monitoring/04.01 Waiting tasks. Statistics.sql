select * from sys.dm_os_wait_stats -- Waits total statistics
where wait_time_ms <> 0
--and wait_type in ('PAGEIOLATCH_EX','WRITELOG','PAGEIOLATCH_SH','MEMORY_ALLOCATION_EXT','RESERVED_MEMORY_ALLOCATION_EXT','ASYNC_NETWORK_IO','PAGELATCH_EX','PAGEIOLATCH_UP','SOS_SCHEDULER_YIELD')
order by wait_time_ms desc
;

DBCC SQLPERF ('sys.dm_os_wait_stats', CLEAR); -- Clean all statistics counters
