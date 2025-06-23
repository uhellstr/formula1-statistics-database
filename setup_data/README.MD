# How to move data from sqlite to Oracle.

The purpose of providing an sqlite database is
to speed up the build of the F1 statistical
database in oracle. But you can also build
a sqlite database if you prefer.

# Using sqlite to analyze f1 data.

If you want to use sqlite insted of Oracle
unzip the f1.zip database and then in sqlite
run the script formula1_sqlite.sql to create
necessary tables and views up to the latest
race that f1.zip include. 

Note: 

There is no python script for loading the sqlite databas
with future races that is up to the user
to build themselves.

## The Oracle part!

After setting up the Oracle database, install APEX,
creating the dabase schemas and then load the
database objects using liquibase you can fast load
the oracle database with data without having to
run the job to load the data wich will take long time and has restriction on how many calls you can
do per hour and day.

To fast load the Formula one database 

1. unzip f1.zip this will end up with f1.sqlite database.

2. Make sure you have python3 (and sqlite3) installed and look
at the import section of the f1_json_oracle.py
and use pip or conda (if you use conda) to install the packages if they
are not already installed on your system.

3. Then run python ./f1_json_oracle.py to load
the oracle database with as much data as possible.

4. The program will ask you for how to connect to
the oracle database and the path and filename for
the sqlite database (f1.sqlite)

5. The rest of the python programs is used by the
developer of this git repo to maintain the 
sqlite database you do not need that code for 
anything.