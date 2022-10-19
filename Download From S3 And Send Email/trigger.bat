@echo off
Title Downloader
color 0A

set location="%~dp0Files"

:Date_Calculator
:: Get response date for today --
set day=0
echo >"%temp%\%~n0.vbs" s=DateAdd("d",%day%,now) : d=weekday(s)
echo>>"%temp%\%~n0.vbs" WScript.Echo year(s)^& right(100+month(s),2)^& right(100+day(s),2)
for /f %%a in ('cscript /nologo "%temp%\%~n0.vbs"') do set "response_date=%%a"
del "%temp%\%~n0.vbs"
set "YYYY=%response_date:~0,4%"
set "MM=%response_date:~4,2%"
set "DD=%response_date:~6,2%"
:: set date format
set "response_date=%yyyy%-%mm%-%dd%"
echo %response_date% is response_date

:: Get award_date's Dynamically --
set day=-1
echo >"%temp%\%~n0.vbs" s=DateAdd("d",%day%,now) : d=weekday(s)
echo>>"%temp%\%~n0.vbs" WScript.Echo year(s)^& right(100+month(s),2)^& right(100+day(s),2)
for /f %%a in ('cscript /nologo "%temp%\%~n0.vbs"') do set "award_date=%%a"
del "%temp%\%~n0.vbs"
set "YYYY=%award_date:~0,4%"
set "MM=%award_date:~4,2%"
set "DD=%award_date:~6,2%"
:: set date format
set "award_date=%yyyy%-%mm%-%dd%"
set "award_date_chk=%yyyy%-%mm%-%dd%"
echo %award_date% is award_date

goto date_checks

:date_checks
set day=0
echo >"%temp%\%~n0.vbs" s=DateAdd("d",%day%,"%award_date_chk%")
echo>>"%temp%\%~n0.vbs" WScript.Echo WeekdayName(Weekday(s))
for /f %%a in ('cscript /nologo "%temp%\%~n0.vbs"') do set "award_day_name=%%a"
del "%temp%\%~n0.vbs"

if %award_day_name% == Sunday (
    goto sub2day
) else (
    goto delete_old_files
)

:sub2day
set day=-2
echo >"%temp%\%~n0.vbs" s=DateAdd("d",%day%,"%award_date_chk%") : d=weekday(s)
echo>>"%temp%\%~n0.vbs" WScript.Echo year(s)^& right(100+month(s),2)^& right(100+day(s),2)
for /f %%a in ('cscript /nologo "%temp%\%~n0.vbs"') do set "award_date=%%a"
del "%temp%\%~n0.vbs"
set "YYYY=%award_date:~0,4%"
set "MM=%award_date:~4,2%"
set "DD=%award_date:~6,2%"
:: set date format
set "award_date=%yyyy%-%mm%-%dd%"
echo %award_date% is new award_date after sub 2 days

set day=-1
echo >"%temp%\%~n0.vbs" s=DateAdd("d",%day%,"%award_date_chk%") : d=weekday(s)
echo>>"%temp%\%~n0.vbs" WScript.Echo year(s)^& right(100+month(s),2)^& right(100+day(s),2)
for /f %%a in ('cscript /nologo "%temp%\%~n0.vbs"') do set "response_date=%%a"
del "%temp%\%~n0.vbs"
set "YYYY=%response_date:~0,4%"
set "MM=%response_date:~4,2%"
set "DD=%response_date:~6,2%"
:: set date format
set "response_date=%yyyy%-%mm%-%dd%"
echo %response_date% is new response_date after sub 1 days

goto delete_old_files

:delete_old_files
echo --------------------------------------------------------------------
echo.
echo Deleting Old Files
echo.
@echo off
del /s /q %location%"*.*"
for /d %%p in (%location%"*.*") do rmdir "%%p" /s /q
echo.
echo --------------------------------------------------------------------
echo.
goto download_files_from_s3
goto exit_batch


:download_files_from_s3
echo Downloading Award Files and Response Files.....
::award file
set bucket_path=aws s3 sync s3://c2foupload-inprod/internationaltractors/award/merged/%award_date%/76/
set regex=--exclude "*" --include "*merged_award*"
::s3 command
@echo off
%bucket_path% %location% %regex%
echo.

::response file
set bucket_path=aws s3 sync s3://c2foupload-inprod/internationaltractors/invalid/%response_date%/
set regex=--exclude "*" --include "*award_response*"
::s3 command
@echo off
%bucket_path% %location% %regex%
echo.

goto delete_award_file_with_0_size
goto exit_batch

:delete_award_file_with_0_size
echo --------------------------------------------------------------------
echo.
echo Deleting Award Files With Size Less Than 600 bytes
echo.
@echo off
pushd %location%
for %%j in (*) do if %%~zj lss 600 del "%%~j"
popd
echo --------------------------------------------------------------------
echo.
goto exit_batch


:exit_batch
@echo off
pushd %~dp0
cscript ol_trigger.vbs
exit