# formula1-statistics-database

Analyze public formula1 data published on ergast/fastf1 API with Oracle Express/Free edition-

Note: This data CANNOT be used in any kind of commercial application due to how jolpa licensing its data.
      You are however free to use this data for your own personal fun and personal development!

Requirements:

- OracleDB and client on Linux operatingsystem like OEL8, client can be any sutable linux distro.
- A working Oracle database >= 21c, could be EE,SE,XE,FREE edition , cloud or on premise.
- Oracle Application Express edition >= 22
- Oracle instant client >= 21c
- Oracle Java >= 11 JDK 
- Oracle SQLcl >= 24.2 complete installation and future maintenance is done with SQLcl liquibase.
- Or if you prefer you can use the provided compact sqlite database directly for all historical
  data until right now until the end of the 2024 season. 

A very easy way to get started is to install the Oracle Developers FREE 23c database that is free for use for us all!
See: https://www.oracle.com/database/free/

Using podman you can get an oracle FREE database up and running in minutes.
See: https://dbengineer.hashnode.dev/oracle-database-23c-free-with-podman

To be able to publish data a REST services or use APEX to build analysis applications you also need

Oracle ORDS >= 22.4 installed (Further instructions on this is planned , but mainly you need to publish the f1_rest_access_schema)

# Installation:

Follow the instructions in the README_FIRST.md in the sql subdirectory.
Don't forget to change password for F1_STAGING,F1_DATA,F1_LOGIK,F1_ACCESS and F1_REST_ACCESS.

Loading future or historical Jolpa data into the database is done thru DBMS_SCHEDULER. 
The F1_LOGIK.AUTO_ERGAST_LOAD_JOB runs workdays at 20:00, you can change this to suite your need.
After installation it is recommended to start the job manually to start load data into the database.
This will take some time ~1-2 hours , check the status some times if fails due to networking issues
It is safe to restart since it will continue to load from where it failed.

Update: I have provided a compact sqlite database that includes all data from 1950- and at least last years season that speeds
up the processing of updating the F1 data allot especially since jolpa has limits on loads per second
and no more then 500 calls per hour.

Additional formula 1 data can be loaded if using an Oracle database. 
For this you need python3 installed and dboracle/cx_oracle plugins.

Check out miniconda and add dboracle/cx_oracle with pip to get started.
If any of the provided python scripts fails to start check them import statements
and instll the missing API's with pip or conda.

After setting up the oracle database and using sqlCmdline and provided liquibase scripts to
create all objects in the database you can insert all necessary data by:

1. Unzip the f1.zip file in the setup_data catalog (A compact sqlite database with all data in JSON format).
2. Then run the python script f1_json_oracle.py
   Connect to the sqlite database by given the path and f1.sqlite as parameter to the python script.
3. Then connect to the oracle database F1_STAGING schema by enter hostname,username,password,service_name.
4. The script will insert all necessary JSON documents into F1_JSON_DOCS in the F1_STAGING schema.

   Note: You might need to change the NLS settings on the client side in the python script.
   Or temporary set your NLS settings to swedish.

   This because we will need to set some formatting for TIMESTAMP column in the F1_JSON_DOCS table on the oracle side.

6. After you get all the data inserted into F1_JSON_DOCS in the oracle instance you can setup all the data using the
   provided SQL script f1_data_f1_logik.sql. Run this script as F1_LOGIK schema in the oracle database and you can
   now check in F1_ACCESS schema that you have all the data in place.

I will update the provided f1 sqlite database after each season.
And ofcause you could actually use the sqlite database as a standalone database if you prefer that from using an
Oracle database. libSQL provides a way of writing node , python or javascript applications reading the data 
directly from the sqlite database (even remote applications) if you want to do your analysis that way. 
If you check the sqlite database you will find i provide json-relational views that tranforms json to relational data 
that you can use for all kinds of analysis.

I recommend you to check at libSQL and provided API's for javascript,python etc if you prefer that way of analyzing
Formula 1 historical data.

# Getting started with analysing formula 1 data.

See the demo_queries.sql file in the sql/demo subdirectory.
See the demo_sqlite in the setup_data subdirectory if you prefer sqlite.

# Extra data from Official Formula 1 using python and fastf1 for an Oracle database.

In the directory python you can use the f1_timingdata to load official timing and weather data from Formula 1.
Before attempting to use this python program you need to install python 3, have an instant client 21c installed that work
and can connect to the database and then install the following python packages.

- cx_Oracle ( I plan to switch to dboracle)
- fastf1
- (possible some more if f1_timingdata fails to run due to missing packages.)

I use Miniconda for my personal python environment that is very easy to setup and do not interrupt with other possible installed python environments. 
You can install Miniconda for your own local user and using provided shell additions to point out the miniconda3
python environment. cx_Oracle requires an working Oracle Instant Client environment and with miniconda you can install it with

- conda install cx_Oracle
- conda or pip install dboracle

To install fastf1 use pip like

- pip install fastf1

Note: First initial load of data from Official Formula 1 can take allot of time (we talk hours). It will load all datapoints for fp1,fp2,fp3,Qualification and race
starting with season 2018. However if you break or loose network connection it will use cache functionality so you it will continue or skipping
to download alredy downloaded data. It also take some diskspace. Downloading all data can take 30-50GB of diskspace to keep the cache intact.
As long as you have already installed datapoints into the oracle database you can clear the cache directory. Anytime you run the code it will
check if the datapoint already is loaded in the database. If then it will not try to download any data at all.

When running f1_timingdata you will be asked for servicename from you tnsnames.ora (Oracle Instant Client), hostname, listener port (1521), username
and password. Connect as F1_DATA schema.
