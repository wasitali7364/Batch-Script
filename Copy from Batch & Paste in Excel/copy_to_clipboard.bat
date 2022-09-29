@echo off
Title Clipboard Test
color 0A
set text="Hello World"
::code to copy text to clipboard
echo|set /p=%text%|clip

::open excel
set file_path="C:\Users\wasit.ali.CORP\Desktop\TEST\test.xlsm"
start excel %file_path%

::written a vba to paste clipboard item on excel
