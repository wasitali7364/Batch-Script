@echo off
TITLE Ack File Downloader
color 0A
:: https://www.geeksforgeeks.org/color-cmd-command/


:: echo ____________________________________________________________________


:: -------------------------------------------------------------------------

:: Get Yesterday's Date Dynamically
set day=-1
echo >"%temp%\%~n0.vbs" s=DateAdd("d",%day%,now) : d=weekday(s)
echo>>"%temp%\%~n0.vbs" WScript.Echo year(s)^& right(100+month(s),2)^& right(100+day(s),2)
for /f %%a in ('cscript /nologo "%temp%\%~n0.vbs"') do set "yesterday=%%a"
del "%temp%\%~n0.vbs"
set "YYYY=%yesterday:~0,4%"
set "MM=%yesterday:~4,2%"
set "DD=%yesterday:~6,2%"
:: set date format
set "yesterday=%yyyy%%mm%%dd%"

:: --------------------------------------------------------------------------

:: Get Today's Date Dynamically
set day=0
echo >"%temp%\%~n0.vbs" s=DateAdd("d",%day%,now) : d=weekday(s)
echo>>"%temp%\%~n0.vbs" WScript.Echo year(s)^& right(100+month(s),2)^& right(100+day(s),2)
for /f %%a in ('cscript /nologo "%temp%\%~n0.vbs"') do set "today=%%a"
del "%temp%\%~n0.vbs"
set "YYYY=%today:~0,4%"
set "MM=%today:~4,2%"
set "DD=%today:~6,2%"
:: set date format
set "today=%yyyy%%mm%%dd%"

:: --------------------------------------------------------------------------

:: Ford BNPP
set b_funder=aws s3 cp --recursive s3://c2foupload-prod/funder-feedback/BNPP/

:: don't use path as a variable because it's internal windows keyword
set path1="C:\Users\wasit.ali.CORP\OneDrive - C2FO\Documents\DSF_Reconciliation\AMER DSF RECON\Project\BNPP"

:: delete older files if available
del /s /q %path1%"\*.*"
for /d %%p in (%path1%"\*.*") do rmdir "%%p" /s /q

:: filter
set regex=--exclude "*" --include "*Ack%today%*"

:: s3 command
%b_funder% %path1% %regex%

echo.

:: --------------------------------------------------------------------------

:: Moog HSBC
set b_funder=aws s3 cp --recursive s3://c2foupload-prod/funder-feedback/HSBCUS/

:: don't use path as a variable because it's internal windows keyword
set path2="C:\Users\wasit.ali.CORP\OneDrive - C2FO\Documents\DSF_Reconciliation\AMER DSF RECON\Project\MOOG-HSBC"

:: delete older files if available
del /s /q %path2%"\*.*"
for /d %%p in (%path2%"\*.*") do rmdir "%%p" /s /q

:: filter
set regex=--exclude "*" --include "*%yesterday%*"

:: s3 command
%b_funder% %path2% %regex%

echo.

:: --------------------------------------------------------------------------

:: HP/HPE HSBC
set b_funder=aws s3 cp --recursive s3://c2foupload-prod/funder-feedback/HSBCSG/

:: don't use path as a variable because it's internal windows keyword
set path3="C:\Users\wasit.ali.CORP\OneDrive - C2FO\Documents\DSF_Reconciliation\AMER DSF RECON\Project\HP-HPE HSBC"

:: delete older files if available
del /s /q %path3%"\*.*"
for /d %%p in (%path3%"\*.*") do rmdir "%%p" /s /q

:: filter
set regex=--exclude "*" --include "*%today%*"

:: s3 command
%b_funder% %path3% %regex%

echo.

pause
