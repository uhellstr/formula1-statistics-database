REM
REM Run this script connected as F1_DATA from the sql folder
REM
cd ../F1_DATA
pwd
lb update --changelog-file controller.xml
lb tag -tag version_1.0
cd ../sql
pwd
