@echo off
set fpath=C:\Program Files (x86)\NetSarang\Xshell 7
set startName=Xshell.exe
set olddate=%date:~0,4%-%date:~5,2%-%date:~8,2%
set setdate=2017-%date:~5,2%-%date:~8,2%
echo setdate=%setdate%
date %setdate%
cd %fpath%
start %startName%
TIMEOUT /T 1
date %olddate%
