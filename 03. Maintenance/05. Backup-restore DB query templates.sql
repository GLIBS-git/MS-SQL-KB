use master;

backup database Database_name
to disk = 'D:\MSSQL\Backup\Database_name.bak'
with init;

drop database Database_name;

restore database Database_name
from disk = 'D:\MSSQL\Backup\Database_name.bak'
with move 'Database_name_data' to 'F:\MSSQL\Database_name.mdf',
move 'Database_name_log' to 'D:\MSSQL\Database_name.ldf';



