# Forumala1 statistics database

To setup your personal non commersial (You are not allowed to use this data in any commersial purpose due to ERGAST licensing) follow the following steps.

- You need a Oracle database either in OCI or on premise. On premise the supported operating system is Linux even though Windows probably will work fine.
- Check any firewalls you have for permission to access the internet thru port 80.
- For Personal study you can easily setup a Oracle Express Ediotn or FREE database on your laptop, docker container or personal linux server.
- The database you use must have the following installed and configured
- A client using instant client and/or a installed version of sqlcl (SQLcmdline) that is verified to be able to connect to target database.
  
## Pre-requirements.
  
  - Oracle Application express.
  - A USERS tablespace on around 500M-1G in size (Make it autoextendable) 
  - A instant client version 21.0 or higher with a working SQlcmdline (sqlcl) since we install most of the objects with help of liquibase.
  - SQlcmdLine version 23.2 or higher. 

## Prepare to install the necessary schemas.

Note: You should run all script using SQLcmdLine instead of using sqlplus.

The following schemas will be installed

 - F1_STAGING - Staging schema storing ERGAST data in JSON format.
 - F1_DATA    - Tranformed schema transforming JSON data from F1_STAGING into relational views and tables.
 - F1_LOGIK   - Schema with PL/SQL code and SCHEDULED job to maintaine and keep your database upto date with the lateset raceresults.
 - F1_ACCESS  - Schema to be used by end-users to be able to do statistical and analyze the data 
 - F1_REST_ACCESS - If you use Oracle ORDS (Rest data Services) you can use this to publish rest services for external utilities like Jupyter Notebooks etc for graphing.
 - APEX_F1 for future app's with oracle low-code tool Oracle Application Express.
 
 First of all. Make sure you have a USERS tablespace in target database and that APEX is installed. The F1_LOGIK schema uses APEX API packages heavily.
 
## Install schemas.
 
 As SYS/SYSTEM or your own DBA user with DBA permission (create user, tables, view, job etc) runt the script below.
 
 
 This will drop any existing F1_* schemas if they already exists and create them fresh and setup necessary ACL permissions.
 This installation will FAIL if you do not have the USERS tablespace and/or APEX installed 
 
 After sucesfull installation of the schemas you should have f1_staging,f1_data,f1_logik and an extra schema for eventual future REST calls f1_rest_access.
 All schemas are setup with a default password "oracle". You should immediate change this password for each schema to something more secure.

``` 
$ sql 
SQL> conn sys@<TNS-ALIAS> as sysdba
SQL> @install.sql
```

## Setup schema objects.

To setup all database objects we will use the built in liquibase in SQlcmdLine run the following scripts in the order below

``` 
$ sql /nolog
SQL> conn f1_staging@<TNS-ALIAS>
SQL> @lb_install_f1_staging

$ sql /nolog
SQL> conn f1_data@<TNS-ALIAS>
SQL> @lb_install_f1_data

$ sql /nolog
SQL> conn f1_logik@<TNS-ALIAS>
SQL> @lb_install_f1_logik

$ sql /nolog
SQL> conn f1_access@<TNS-ALIAS>
SQL> @lb_install_f1_access

$ sql /nolog
SQL> conn f1_rest_access@<TNS-ALIAS>
SQL> @lb_install_f1_rest_access

$ sql /nolog
SQL> conn apex_f1@<TNS-ALIAS>
SQL> $lb_install_apex_f1
``` 

Finally , due to some obscure bug with JOBS in liquibase we have to setup a scheduled job in the F1_LOGIK schema.

``` 
sql /nolog
SQL> conn sys@<TNS-ALIAS> as sysdba
SQL> @F1_LOGIK_SCHEDULER.sql
``` 
 
Finished!
