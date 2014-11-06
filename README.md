DataMover
=========

Dumps Paradox data to SQL files

DataMover can be used to move and ODBC/BDE database alias to SQL Server.

It DOES NOT connect to SQL Server it generated sql create/insert scripts and a run.bat file that calls sqlcmd. It does this for a few reasons:

1) SQL Server's importing just plain sucks. If you get an error on the import that's all you get, the error. Running it with sqlcmd you will get the error and in the .log file you will see the insert statement that failed - much easier to debug.

2) ADO.NET does not see all Paradox database fields - this does

3) Running the Querys in SSMS you can get out of memory errors due to the length of the import file - you're moving a database - they can get rather large

All "dumps" are created in the following directory like structure.

C:\Temp         - after all this is temp stuff right
  \DBMover      - Just for grouping
    \Alias Name - Why bother asking for a name if you already have a unique one in ODBC or BDE right?
      \<DATE>   - The date (in MMDDYYYY format) the Mover was called

I chose to add the date so you can do a diff between dumps to see what's changed (cheaper than paying $$$ for a db compare utility)

Ken