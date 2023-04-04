set location="%~dp0Files_Folder"

:delete_award_file_with_0_size
echo --------------------------------------------------------------------
echo.
echo Deleting Award Files With Size Less Than 100 bytes
echo.
@echo off
pushd %location%
for %%j in (*) do if %%~zj lss 100 del "%%~j"
popd
echo --------------------------------------------------------------------
echo.
