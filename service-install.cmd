@echo off

powershell ^
  -ExecutionPolicy Bypass ^
  -NoProfile ^
  "& '%~dp0scripts\launcher.ps1' ServiceInstall"
