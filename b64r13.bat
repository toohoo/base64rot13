@echo off
REM echo --- base64 Vorarbeit ---
path d:\temp;%PATH%
set MYPATH_QUIET=On
REM set MYPATH_QUIET=Off
call d:\sperl\perl\bin\perl.exe d:\temp\mypath.pl -q delete d:\temp delete D:\temp unshift d:\temp
call mypathnew
REM echo --- base64 Script ---
REM @echo on
call perl d:\temp\b64r13.pl %1 %2 %3 %4
REM call d:\sperl\perl\bin\perl.exe d:\temp\base64.pl %1 %2 %3
