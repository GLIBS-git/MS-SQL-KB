begin tran;
exec sp_getapplock @Resource = '123', @LockMode = 'Exclusive', @LockOwner = 'Session';
declare @result int;
exec @result = sp_getapplock @Resource = '123', @LockMode = 'Exclusive', @LockOwner = 'Session', @LockTimeout = 1000;
select @result;
commit tran;
rollback tran;

exec sp_releaseapplock @Resource = '123', @LockOwner = 'Session';

select @@TRANCOUNT;

SELECT 
    tl.request_session_id AS [SPID],
    tl.resource_description AS [AppLock_Name],
    tl.request_mode AS [Lock_Mode],        -- Обычно 'X' (Exclusive) для лидера
    tl.request_status AS [Lock_Status],    -- 'GRANT' (удерживает) или 'WAIT' (ждет очереди)
    es.host_name AS [Client_Host_Name],    -- Имя сервера/контейнера, где запущено приложение
    es.program_name AS [Application_Name], -- Имя приложения из строки подключения
    es.login_name AS [DB_Login_Name],
    es.login_time AS [Session_Started_At]
FROM sys.dm_tran_locks tl
INNER JOIN sys.dm_exec_sessions es 
    ON tl.request_session_id = es.session_id
WHERE tl.resource_type = 'APPLICATION' -- Отсекаем блокировки таблиц, страниц и строк
ORDER BY tl.resource_description, tl.request_status;

