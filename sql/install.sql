REM
REM Before running this script install Oracle Application Express latest version if not already installed.
REM Minimum version of APEX required is >= 5.0
REM Run this script as SYS,SYSTEM or own DBA with full DBA permission to create schema and objects.
REM 
@setup_schema.sql
@F1_LOGIK_SCHEDULER.sql
@F1_ACL_SETUP.sql

