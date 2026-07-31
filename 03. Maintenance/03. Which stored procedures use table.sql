--USE Production_DB_name; -- Database dependent!

SELECT OBJECT_NAME(S.id) AS Sp_name -- Which stored procedures use table
FROM SYSCOMMENTS S
INNER JOIN SYS.OBJECTS O ON O.Object_Id = S.id
WHERE S.TEXT LIKE '%InventSize%' -- Table name here!
AND O.type = 'p'
ORDER BY Sp_name
;




