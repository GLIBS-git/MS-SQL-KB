--USE Production_DB_name; -- Database dependent!

SELECT OBJECT_NAME(S.id) as Sp_name -- Which stored procedures use table
FROM SYSCOMMENTS S
INNER JOIN SYS.OBJECTS O ON O.Object_Id = S.id
WHERE S.TEXT LIKE '%Table_name%' -- Table name here!
AND O.type = 'p'
order by Sp_name
;



