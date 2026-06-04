-- Test environment only!

DBCC FREEPROCCACHE; -- Clean all cached SQL query plans

DBCC DROPCLEANBUFFERS; -- Write to disk and clean all buffered pages

