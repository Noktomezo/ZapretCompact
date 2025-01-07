@echo off

@set ROOT=%~dp0
@set SCRIPTS=%ROOT%scripts

powershell -WindowStyle Hidden -File "%SCRIPTS%\smart-start.ps1" -Verb runAs
