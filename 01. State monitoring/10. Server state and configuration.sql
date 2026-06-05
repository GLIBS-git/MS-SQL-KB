select A.sqlserver_start_time as Server_started -- Server start time and CPU/memory configuration
	, A.cpu_count as Logical_CPU_cores
	, A.hyperthread_ratio as Physical_CPU_cores
	, A.physical_memory_kb as Physical_memory_Kb
	, A.physical_memory_kb / 1024 as Physical_memory_Mb
	, A.physical_memory_kb / 1024 / 1024 as Physical_memory_Gb
	, A.virtual_memory_kb as Virtual_memory_Kb
	--, '-------' as [-------]
	--, A.*
from sys.dm_os_sys_info A;

select * from sys.dm_os_sys_info; -- Server state and configuration



