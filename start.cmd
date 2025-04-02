@echo off

powershell ^
  -WindowStyle Hidden ^
  -ExecutionPolicy Bypass ^
  -NoProfile ^
  %~dp0scripts\launcher.ps1 JustStart ^
  -Verb runAs ^
