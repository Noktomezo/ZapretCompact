@echo off

set FILES=%~dp0files

(%FILES%\nssm.exe set ZapretCompact start SERVICE_DISABLED
%FILES%\nssm.exe stop ZapretCompact
%FILES%\nssm.exe remove ZapretCompact confirm

sc stop WinDivert
sc delete WinDivert) >nul 2>&1
