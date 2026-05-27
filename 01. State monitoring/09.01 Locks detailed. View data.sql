--USE Production_DB_name; -- Database dependent

SELECT %%lockres%% AS Lockres, '-----' as [-----], * FROM Table_name with (index(Index_name), nolock)
where %%lockres%% in ('(4006394d3759)')
;

SELECT %%lockres%% AS Lockres, '-----' as [-----], * FROM Table_name with (index(Index_name))
where %%lockres%% in ('(4006394d3759)')
;





