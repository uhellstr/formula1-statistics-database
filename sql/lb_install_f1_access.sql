REM
REM Run this script connected as F1_ACCESS from the sql folder
REM
cd ../F1_ACCESS
pwd
lb update -changelog-file controller.xml
lb tag -tag version_2.0
cd ../sql
pwd
