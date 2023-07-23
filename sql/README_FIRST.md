# Forumala1 statistics database

To setup your personal non commersial (You are not allowed to use this data in any commersial purpose due to ERGAST licensing) follow the following steps.

- You need a Oracle database either in OCI or on premise. On premise the supported operating system is Linux even though Windows probably will work fine.
- Check any firewalls you have for permission to access the internet thru port 80.
- For Personal study you can easily setup a Oracle Express Ediotn or FREE database on your laptop, docker container or personal linux server.
- The database you use must have the following installed and configured
- A client using instant client and/or a installed version of sqlcl (SQLcmdline) that is verified to be able to connect to target database.
  
## Pre-requirements.
  
  -- Oracle Application express.
  -- A USERS tablespace on around 500M-1G in size (Make it autoextendable) 
  -- A instant client setup with a working SQlcmdline (sqlcl) since we install most of the objects with help of liquibase.

## Prepare to install the necessary schemas

The following schemas will be installed

 F1_STAGING - Staging schema storing ERGAST data in JSON format.
 F1_DATA    - Tranformed schema transforming JSON data from F1_STAGING into relational views and tables.
 F1_LOGIK   - Schema with PL/SQL code and SCHEDULED job to maintaine and keep your database upto date with the lateset raceresults.
 F1_ACCESS  - Schema to be used by end-users to be able to do statistical and analyze the data 
 F1_REST_ACCESS - If you use Oracle ORDS (Rest data Services) you can use this to publish rest services for external utilities like Jupyter Notebooks etc for graphing.
 
 First of all. Make sure you have a USERS tablespace in target database and that APEX is installed. The F1_LOGIK schema uses APEX API packages heavily.
 
 As SYS/SYSTEM or your own DBA user with DBA permission (create user, tables, view, job etc) runt the script below.
 This will drop any existing F1_* schemas if they already exists and create them fresh and setup necessary ACL permissions.
 This installation will FAIL if you do not have the USERS tablespace and/or APEX installed as 
 
 install.sql
 

