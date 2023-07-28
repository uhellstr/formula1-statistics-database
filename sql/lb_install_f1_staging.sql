REM
REM Run this script using SQLcmdline connected as F1_DATA from the sql folder
REM
cd ../F1_STAGING
pwd
lb update --changelog-file controller.xml
lb tag -tag version_1.0
cd ../sql
pwd
@insert_f1_json_doctype.sql
@insert_f1_json_racetype.sql
