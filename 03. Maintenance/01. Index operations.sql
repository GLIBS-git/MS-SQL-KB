--USE Production_DB_name; -- Database dependent

CREATE INDEX Index_name ON Table_name (Field_1,Field_1,...) WITH (ONLINE = OFF, SORT_IN_TEMPDB = ON, MAXDOP = 6);
CREATE UNIQUE INDEX Index_name ON Table_name (Field_1,Field_1,...) with (ONLINE = OFF, sort_in_tempdb = on, maxdop = 6);
CREATE CLUSTERED INDEX Index_name ON Table_name (Field_1,Field_1,...) WITH (ONLINE = OFF, SORT_IN_TEMPDB = ON, MAXDOP = 6);
ALTER TABLE Table_name ADD CONSTRAINT Index_name PRIMARY KEY NONCLUSTERED (Field_1,Field_1,...) WITH (ONLINE = OFF, SORT_IN_TEMPDB = ON, MAXDOP = 6);

ALTER index [Index_name] on [Table_name] rebuild WITH (sort_in_tempdb = on, maxdop = 6, ONLINE = OFF);
ALTER index All on [Table_name] rebuild WITH (sort_in_tempdb = on, maxdop = 6, ONLINE = OFF);

DROP INDEX [Index_name] ON [dbo].[Table_name] WITH (ONLINE = OFF);
ALTER TABLE [dbo].[Table_name] DROP CONSTRAINT [Index_name] WITH (ONLINE = OFF);








