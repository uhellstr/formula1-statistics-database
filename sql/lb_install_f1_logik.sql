REM
REM Run this script connected as F1_DATA from the sql folder
REM
cd ../F1_LOGIK
pwd
lb update --changelog-file controller.xml
lb tag -tag version_1.0
cd ../sql
pwd
