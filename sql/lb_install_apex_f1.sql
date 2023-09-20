REM
REM Run this script connected as F1_ACCESS from the sql folder
REM
cd ../APEX_F1
pwd
lb update --changelog-file controller.xml
lb tag -tag version_1.0
