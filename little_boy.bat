@echo off
TITLE Ack File Downloader
color 0A

:: don't use path as a variable because it's internal windows keyword

:: File Path
set file_path="C:\Users\wasit.ali.CORP\OneDrive - C2FO\Documents\DSF_Reconciliation\AMER DSF RECON\Project\AMER DSF Recon.xlsm"

::BNPP
set path1="C:\Users\wasit.ali.CORP\OneDrive - C2FO\Documents\DSF_Reconciliation\AMER DSF RECON\Project\BNPP"

::Moog-HSBC
set path2="C:\Users\wasit.ali.CORP\OneDrive - C2FO\Documents\DSF_Reconciliation\AMER DSF RECON\Project\MOOG-HSBC"

::HP/HPE HSBC
set path3="C:\Users\wasit.ali.CORP\OneDrive - C2FO\Documents\DSF_Reconciliation\AMER DSF RECON\Project\HP-HPE HSBC"

::Ford Europe FP-HSBC
set path4="C:\Users\wasit.ali.CORP\OneDrive - C2FO\Documents\DSF_Reconciliation\AMER DSF RECON\Project\Ford Europe HSBC"

:: --------------------------------------------------------------

:welcome
::Create Ascii Art
for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A

echo Press 1 to Automatically Pick Date. By Default Picks Last Market Clear Day.
echo.
echo Press 2 to input Market Clear Date Manually. For Historical Purpose only.

:user_choice
set /p user_input=

if %user_input% == 1 (
    goto Date_Calculator
) else if %user_input% == 2 (
    goto manual
) else (
    goto repeat
)

:repeat
echo please select a valid option between 1 and 2
goto user_choice

:: -------------------------------------------------------------------------

:Date_Calculator
:: Get market_clear_date's Date Dynamically --
set day=-1
echo >"%temp%\%~n0.vbs" s=DateAdd("d",%day%,now) : d=weekday(s)
echo>>"%temp%\%~n0.vbs" WScript.Echo year(s)^& right(100+month(s),2)^& right(100+day(s),2)
for /f %%a in ('cscript /nologo "%temp%\%~n0.vbs"') do set "market_clear_date=%%a"
del "%temp%\%~n0.vbs"
set "YYYY=%market_clear_date:~0,4%"
set "MM=%market_clear_date:~4,2%"
set "DD=%market_clear_date:~6,2%"
:: set date format
set "market_clear_date=%yyyy%%mm%%dd%"
set "market_clear_date_input=%yyyy%-%mm%-%dd%"

goto weekend_check

:weekend_check

set day=0
echo >"%temp%\%~n0.vbs" s=DateAdd("d",%day%,"%market_clear_date_input%")
echo>>"%temp%\%~n0.vbs" WScript.Echo WeekdayName(Weekday(s))
for /f %%a in ('cscript /nologo "%temp%\%~n0.vbs"') do set "market_clear_day_name=%%a"
del "%temp%\%~n0.vbs"

if %market_clear_day_name% == Sunday (
    goto sub2day
) else (
    goto next_business_day_and_next_market_clear_day
)

:sub2day
set day=-2
echo >"%temp%\%~n0.vbs" s=DateAdd("d",%day%,"%market_clear_date_input%") : d=weekday(s)
echo>>"%temp%\%~n0.vbs" WScript.Echo year(s)^& right(100+month(s),2)^& right(100+day(s),2)
for /f %%a in ('cscript /nologo "%temp%\%~n0.vbs"') do set "market_clear_date=%%a"
del "%temp%\%~n0.vbs"
set "YYYY=%market_clear_date:~0,4%"
set "MM=%market_clear_date:~4,2%"
set "DD=%market_clear_date:~6,2%"
:: set date format
set "market_clear_date_input=%yyyy%-%mm%-%dd%"
set "market_clear_date=%yyyy%%mm%%dd%"

goto next_business_day_and_next_market_clear_day

:next_business_day_and_next_market_clear_day
:: Get next_business_Day Dynamically --
set day=0
echo >"%temp%\%~n0.vbs" s=DateAdd("d",%day%,now) : d=weekday(s)
echo>>"%temp%\%~n0.vbs" WScript.Echo year(s)^& right(100+month(s),2)^& right(100+day(s),2)
for /f %%a in ('cscript /nologo "%temp%\%~n0.vbs"') do set "next_business_day=%%a"
del "%temp%\%~n0.vbs"
set "YYYY=%next_business_day:~0,4%"
set "MM=%next_business_day:~4,2%"
set "DD=%next_business_day:~6,2%"
:: set date format
set "next_business_day=%yyyy%%mm%%dd%"

:: Get next_date_of_market_clear Dynamically --
set day=1
echo >"%temp%\%~n0.vbs" s=DateAdd("d",%day%,"%market_clear_date_input%") : d=weekday(s)
echo>>"%temp%\%~n0.vbs" WScript.Echo year(s)^& right(100+month(s),2)^& right(100+day(s),2)
for /f %%a in ('cscript /nologo "%temp%\%~n0.vbs"') do set "next_market_day=%%a"
del "%temp%\%~n0.vbs"
set "YYYY=%next_market_day:~0,4%"
set "MM=%next_market_day:~4,2%"
set "DD=%next_market_day:~6,2%"
:: set date format
set "next_date_of_market_clear=%yyyy%%mm%%dd%"

goto main
:: --------------------------------------------------------------------------

:manual

echo Enter Market Clear Date: 
set /p dt=

set day=0
echo >"%temp%\%~n0.vbs" s=DateAdd("d",%day%,"%dt%") : d=weekday(s)
echo>>"%temp%\%~n0.vbs" WScript.Echo year(s)^& right(100+month(s),2)^& right(100+day(s),2)
for /f %%a in ('cscript /nologo "%temp%\%~n0.vbs"') do set "market_clear_date=%%a"
del "%temp%\%~n0.vbs"
set "YYYY=%market_clear_date:~0,4%"
set "MM=%market_clear_date:~4,2%"
set "DD=%market_clear_date:~6,2%"
:: set date format
set "market_clear_date=%yyyy%%mm%%dd%"
set "market_clear_date_input=%yyyy%-%mm%-%dd%"

echo.

set day=1
echo >"%temp%\%~n0.vbs" s=DateAdd("d",%day%,"%market_clear_date_input%") : d=weekday(s)
echo>>"%temp%\%~n0.vbs" WScript.Echo year(s)^& right(100+month(s),2)^& right(100+day(s),2)
for /f %%a in ('cscript /nologo "%temp%\%~n0.vbs"') do set "next_date_of_market_clear=%%a"
del "%temp%\%~n0.vbs"
set "YYYY=%next_date_of_market_clear:~0,4%"
set "MM=%next_date_of_market_clear:~4,2%"
set "DD=%next_date_of_market_clear:~6,2%"
:: set date format
set "next_date_of_market_clear=%yyyy%%mm%%dd%"

set "next_business_day=%next_date_of_market_clear%"
set "next_business_day_chk=%yyyy%-%mm%-%dd%"

goto weekend_check_2

:weekend_check_2
set day=0
echo >"%temp%\%~n0.vbs" s=DateAdd("d",%day%,"%next_business_day_chk%")
echo>>"%temp%\%~n0.vbs" WScript.Echo WeekdayName(Weekday(s))
for /f %%a in ('cscript /nologo "%temp%\%~n0.vbs"') do set "next_business_day_name=%%a"
del "%temp%\%~n0.vbs"

if %next_business_day_name% == Saturday (
    goto add2day
) else (
    goto main
)

:add2day
set day=2
echo >"%temp%\%~n0.vbs" s=DateAdd("d",%day%,"%next_business_day_chk%") : d=weekday(s)
echo>>"%temp%\%~n0.vbs" WScript.Echo year(s)^& right(100+month(s),2)^& right(100+day(s),2)
for /f %%a in ('cscript /nologo "%temp%\%~n0.vbs"') do set "next_business_day=%%a"
del "%temp%\%~n0.vbs"
set "YYYY=%next_business_day:~0,4%"
set "MM=%next_business_day:~4,2%"
set "DD=%next_business_day:~6,2%"
:: set date format
set "next_business_day=%yyyy%%mm%%dd%"

goto main

:: --------------------------------------------------------------------------

:main
echo next_date_of_market_clear is %next_date_of_market_clear% and market_clear_date is %market_clear_date% and next_business_day is %next_business_day%

:: Copy Market Clear Date to Clipboard
echo|set /p=%market_clear_date_input%|clip
pause
:: Ford BNPP
set b_funder=aws s3 sync s3://c2foupload-prod/funder-feedback/BNPP/

:: delete older files if available
del /s /q %path1%"\*.*"
for /d %%p in (%path1%"\*.*") do rmdir "%%p" /s /q

:: filter
set regex=--exclude "*" --include "*Ack_%next_date_of_market_clear%*"

:: s3 command
%b_funder% %path1% %regex%
::echo %b_funder% %path1% %regex%
echo.
echo ____________________________________________________________________
echo.
:: --------------------------------------------------------------------------

:: Moog HSBC
set b_funder=aws s3 sync s3://c2foupload-prod/funder-feedback/HSBCUS/

:: delete older files if available
del /s /q %path2%"\*.*"
for /d %%p in (%path2%"\*.*") do rmdir "%%p" /s /q

:: filter
set regex=--exclude "*" --include "*%market_clear_date%*"

:: s3 command
%b_funder% %path2% %regex%
::echo %b_funder% %path2% %regex%
echo.
echo ____________________________________________________________________
echo.

:: --------------------------------------------------------------------------

:: HP/HPE HSBC
set b_funder=aws s3 sync s3://c2foupload-prod/funder-feedback/HSBCSG/

:: delete older files if available
del /s /q %path3%"\*.*"
for /d %%p in (%path3%"\*.*") do rmdir "%%p" /s /q

:: filter
set regex=--exclude "*" --include "*%next_business_day%*"

:: s3 command
%b_funder% %path3% %regex%
::echo %b_funder% %path3% %regex%
echo.
echo ____________________________________________________________________
echo.
:: --------------------------------------------------------------------------

:: Ford Europe FP-HSBC
set b_funder=aws s3 sync s3://c2foupload-prod/funder-feedback/HSBCEC/

:: delete older files if available
del /s /q %path4%"\*.*"
for /d %%p in (%path4%"\*.*") do rmdir "%%p" /s /q

:: filter
set regex=--exclude "*" --include "*%next_business_day%*"

:: s3 command
%b_funder% %path4% %regex%
::echo %b_funder% %path4% %regex%
echo.
echo ____________________________________________________________________
echo.

:: --------------------------------------------------------------------------

:: Start Excel Application and run vba
start excel %file_path%

exit






:: Ascii Art

:::
:::     .d8888b.      .d8888b.     8888888888     .d88888b.  
:::    d88P  Y88b    d88P  Y88b    888           d88P" "Y88b 
:::    888    888           888    888           888     888 
:::    888                .d88P    8888888       888     888 
:::    888            .od888P"     888           888     888 
:::    888    888    d88P"         888           888     888 
:::    Y88b  d88P    888"          888           Y88b. .d88P 
:::     "Y8888P"     888888888     888            "Y88888P"  
:::