-- Some more details in help

exec sp_getapplock @Resource = 'Secret_operation', @LockMode = 'Exclusive', @LockOwner = 'Session'; -- Session lock
exec sp_releaseapplock @Resource = '123', @LockOwner = 'Session';

declare @result int;
exec @result = sp_getapplock @Resource = '123', @LockMode = 'Exclusive', @LockOwner = 'Session', @LockTimeout = 1000; -- Timeout & check
select @result;

begin tran;
exec sp_getapplock @Resource = 'Secret_operation', @LockMode = 'Exclusive'; -- Transaction lock
exec sp_releaseapplock @Resource = '123';
commit tran;
rollback tran;

select @@TRANCOUNT;

SELECT -- The application lock list
    tl.request_session_id AS [SPID],
    tl.resource_description AS [AppLock_Name],
    tl.request_mode AS [Lock_Mode],
    tl.request_status AS [Lock_Status],
    es.host_name AS [Client_Host_Name],
    es.program_name AS [Application_Name],
    es.login_name AS [DB_Login_Name],
    es.login_time AS [Session_Started_At]
FROM sys.dm_tran_locks tl
INNER JOIN sys.dm_exec_sessions es 
    ON tl.request_session_id = es.session_id
WHERE tl.resource_type = 'APPLICATION'
ORDER BY tl.resource_description, tl.request_status
;

