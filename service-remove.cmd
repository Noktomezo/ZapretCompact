@echo off
chcp 65001 >nul 2>&1

set FILES=%~dp0files

echo ┌→ Удаление службы ZapretCompact...
%FILES%\nssm.exe set ZapretCompact start SERVICE_DISABLED >nul 2>&1
%FILES%\nssm.exe stop ZapretCompact >nul 2>&1
%FILES%\nssm.exe remove ZapretCompact confirm >nul 2>&1

echo ├→ Удаление службы WinDivert...
sc stop WinDivert >nul 2>&1
sc delete WinDivert >nul 2>&1

echo └→ Службы удалены

pause
