# formula1-statistics-database

Analyze public formula1 data published on ergast/fastf1 API with Oracle Express/Free edition-

Note: This data CANNOT be used in any kind of commercial application due to how ergast licensing its data.
      You are however free to use this data for your own personal fun and personal development!

Requirements:

- OracleDB and client on Linux operatingsystem like OEL8, client can be any sutable linux distro.
- A working Oracle database >= 19c, could be EE,SE,XE,FREE edition , cloud or on premise.
- Oracle Application Express edition >= 22
- Oracle instant client >= 21c
- Oracle Java 11 JDK 
- Oracle SQLcl >= 23.2 complete installation and future maintenance is done with SQLcl liquibase.

A very easy way to get started is to install the Oracle Developers FREE 23c database that is free for use for us all!
See: https://www.oracle.com/database/free/

To be able to publish data a REST services you also need

Oracle ORDS >= 22.4 installed (Further instructions on this is planned , but mainly you need to publish the f1_rest_access_schema)

# Installation:

Follow the instructions in the README_FIRST.md in the sql subdirectory.
Don't forget to change password for F1_STAGING,F1_DATA,F1_LOGIK,F1_ACCESS and F1_REST_ACCESS.
Loading Ergast data into the database is done thru DBMS_SCHEDULER. 
The F1_LOGIK.AUTO_ERGAST_LOAD_JOB runs workdays at 20:00, you can change this to suite your need.
After installation it is recommended to start the job manually to start load data into the database.
This will take some time ~1-2 hours , check the status some times if fails due to networking issues
It is safe to restart since it will continue to load from where it failed.

# Getting started with analysing formula 1 data.

See the demo_queries.sql file in the sql/demo subdirectory.

# Extra data from Official Formula 1 using python and fastf1.

In the directory python you can use the f1_timingdata to load official timing and weather data from Formula 1.
Before attempting to use this python program you need to install python 3, have an instant client 21c installed that work
and can connect to the database and then install the following python packages.

- cx_Oracle
- fastf1
- (possible some more if f1_timingdata fails to run due to missing packages.)

I use Miniconda for my personal python environment that is very easy to setup and do not interrupt with other possible installed python environments. 
You can install Miniconda for your own local user and using provided shell additions to point out the miniconda3
python environment. cx_Oracle requires an working Oracle Instant Client environment and with miniconda you can install it with

- conda install cx_Oracle

To install fastf1 use pip like

- pip install fastf1

Note: First initial load of data from Official Formula 1 can take allot of time (we talk hours). It will load all datapoints for fp1,fp2,fp3,Qualification and race
starting with season 2018. However if you break or loose network connection it will use cache functionality so you it will continue or skipping
to download alredy downloaded data. It also take some diskspace. Downloading all data can take 30-50GB of diskspace to keep the cache intact.
As long as you have already installed datapoints into the oracle database you can clear the cache directory. Anytime you run the code it will
check if the datapoint already is loaded in the database. If then it will not try to download any data at all.

When running f1_timingdata you will be asked for servicename from you tnsnames.ora (Oracle Instant Client), hostname, listener port (1521), username
and password. Connect as F1_DATA schema.
