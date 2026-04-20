-- Delete cached plan by plan handle or sql handle
DBCC FREEPROCCACHE(0x0600060075361a2020ded7caec02000001000000000000000000000000000000000000000000000000000000);

DBCC FREEPROCCACHE; -- Delete all cached query plans. Not for production DB!

exec sp_recompile 'Table_name'; -- Delete cached plans for some table

-- View query plan if plan handle or sql handle are known
SELECT query_plan FROM sys.dm_exec_query_plan(0x060006008c336637e072af744c03000001000000000000000000000000000000000000000000000000000000);

KILL 301; -- End session
