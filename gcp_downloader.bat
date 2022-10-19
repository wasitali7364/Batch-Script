@echo off
Title Downloader
color 0A
:Main
set Adeo_Award_location="%~dp0Adeo\Award"
set BT_Award_location="%~dp0BT\Award"
set BTEE_Award_location="%~dp0BTEE\Award"

set Adeo_Ack_location="%~dp0Adeo\ACK"
:: BTEE & BT ACK Location is same
set BTEE_Ack_location="%~dp0BTEE\ACK"

set file_path="%~dp0Recon_File.xlsm"

echo Enter Market Clear:
set /p Market_Clear_Date=

goto Date_Calculator

:Date_Calculator
set day=0
echo >"%temp%\%~n0.vbs" s=DateAdd("d",%day%,"%Market_Clear_Date%") : d=weekday(s)
echo>>"%temp%\%~n0.vbs" WScript.Echo year(s)^& right(100+month(s),2)^& right(100+day(s),2)
for /f %%a in ('cscript /nologo "%temp%\%~n0.vbs"') do set "Market_Clear_Date=%%a"
del "%temp%\%~n0.vbs"
set "YYYY=%Market_Clear_Date:~0,4%"
set "MM=%Market_Clear_Date:~4,2%"
set "DD=%Market_Clear_Date:~6,2%"
:: set date format
set "Market_Clear_Date=%yyyy%-%mm%-%dd%"
echo %Market_Clear_Date% is Market_Clear_Date
echo exit Date_Calculator
goto date_checks

:date_checks
set day=0
echo >"%temp%\%~n0.vbs" s=DateAdd("d",%day%,"%Market_Clear_Date%")
echo>>"%temp%\%~n0.vbs" WScript.Echo WeekdayName(Weekday(s))
for /f %%a in ('cscript /nologo "%temp%\%~n0.vbs"') do set "Market_day_name=%%a"
del "%temp%\%~n0.vbs"

if %Market_day_name% == Sunday (
    goto sub2day
) else (
    goto delete_old_files
)

:sub2day
echo inside sub2day
set day=-2
echo >"%temp%\%~n0.vbs" s=DateAdd("d",%day%,"%Market_Clear_Date%") : d=weekday(s)
echo>>"%temp%\%~n0.vbs" WScript.Echo year(s)^& right(100+month(s),2)^& right(100+day(s),2)
for /f %%a in ('cscript /nologo "%temp%\%~n0.vbs"') do set "Market_Clear_Date=%%a"
del "%temp%\%~n0.vbs"
set "YYYY=%Market_Clear_Date:~0,4%"
set "MM=%Market_Clear_Date:~4,2%"
set "DD=%Market_Clear_Date:~6,2%"
:: set date format
set "Market_Clear_Date=%yyyy%-%mm%-%dd%"
echo %Market_Clear_Date% is new Market_Clear_Date after sub 2 days

goto delete_old_files

:delete_old_files
echo --------------------------------------------------------------------
echo.
echo Deleting Old Award Files
echo.
@echo off
del /s /q %Adeo_Award_location%"\*.*"
for /d %%p in (%Adeo_Award_location%"\*.*") do rmdir "%%p" /s /q
echo.
echo.
@echo off
del /s /q %BT_Award_location%"\*.*"
for /d %%p in (%BT_Award_location%"\*.*") do rmdir "%%p" /s /q
echo.
@echo off
del /s /q %BTEE_Award_location%"\*.*"
for /d %%p in (%BTEE_Award_location%"\*.*") do rmdir "%%p" /s /q
echo.
echo --------------------------------------------------------------------
echo.
goto download_files_from_s3

:download_files_from_s3
echo Downloading Award Files and ACK Files From S3 Bucket.....
::award file
set Adeo_bucket_path=gsutil -m rsync -r gs://enterprise-euprod/io/adeo/award/%Market_Clear_Date%/
@echo off
call %Adeo_bucket_path% %Adeo_Award_location%

set BTEE_bucket_path=gsutil -m rsync -r gs://enterprise-euprod/io/btee/award/%Market_Clear_Date%/
@echo off
call %BTEE_bucket_path% %BTEE_Award_location%

set BT_bucket_path=gsutil -m rsync -r gs://enterprise-euprod/io/bt/award/%Market_Clear_Date%/
@echo off
call %BT_bucket_path% %BT_Award_location%
echo.

::ACK file
set HSBCHK_bucket_path=gsutil -m rsync -r gs://enterprise-euprod/funder-feedback/HSBCHK/
@echo off
call %HSBCHK_bucket_path% %Adeo_Ack_location%
echo.

::BT & BTEE have same Ack Location
set HSBCUK_bucket_path=gsutil -m rsync -r gs://enterprise-euprod/funder-feedback/HSBCUK/
@echo off
call %HSBCUK_bucket_path% %BTEE_Ack_location%
echo.
echo --------------------------------------------------------------------
echo.
goto exit_batch


:exit_batch
:: Copy Market Clear Date to Clipboard
echo|set /p=%Market_Clear_Date%|clip
:: Start Excel Application and run vba
start excel %file_path%

exit