REM
REM Run this script connected as F1_DATA from the sql folder
REM
cd ../F1_LOGIK
pwd
set define off
lb update -changelog-file controller.xml
lb tag -tag version_2.0
cd ../sql
pwd
set define on
