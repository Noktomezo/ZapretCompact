@echo off

@set ROOT=%~dp0
@set SCRIPTS=%ROOT%scripts

powershell -WindowStyle Hidden "%SCRIPTS%\smart-start.ps1" -Verb runAs
