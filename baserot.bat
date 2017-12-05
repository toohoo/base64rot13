@echo off
REM echo --- base64 Vorarbeit ---
set MYPATH_QUIET=On
REM set MYPATH_QUIET=Off

if exist z:\temp\baserot.bat goto drivez
if exist d:\temp\baserot.bat goto drived

:drivez
path z:\temp;%PATH%
call z:\sperl\perl\bin\perl.exe z:\temp\zmypath.pl -q delete z:\temp delete z:\temp unshift z:\temp
call mypathnew
REM echo --- base64 Script ---
REM @echo on
call perl z:\temp\baserot.pl %1 %2 %3 %4
goto baroende

:drived
path d:\temp;%PATH%
call d:\sperl\perl\bin\perl.exe d:\temp\mypath.pl -q delete d:\temp delete D:\temp unshift d:\temp
call mypathnew
REM echo --- base64 Script ---
REM @echo on
call perl d:\temp\baserot.pl %1 %2 %3 %4
goto baroende

:baroende
