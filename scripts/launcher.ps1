Import-Module "$(Split-Path -Parent $MyInvocation.MyCommand.Path)\config.ps1"

if (-not $args[0]) {
  Write-Host "No action specified. Use 'JustStart', 'ServiceInstall', or 'ServiceRemove'." -ForegroundColor Red
  exit 1
}

function Start-WinwsMonitoring {
  try {
    $process = Get-Process -Name "winws" -ErrorAction Stop
    $process.WaitForExit()

    & sc.exe stop WinDivert >$null 2>&1
    & sc.exe delete WinDivert >$null 2>&1
  }
  catch {
    & sc.exe stop WinDivert >$null 2>&1
    & sc.exe delete WinDivert >$null 2>&1
  }
}

$service_status = & $NSSM_EXE status ZapretCompact 2>&1

switch ($args[0]) {
  "JustStart" {
    if ($service_status -eq "SERVICE_RUNNING") {
      Start-Process powershell.exe {
        Write-Host "ZapretCompact is already running as a service." -ForegroundColor Yellow
        & cmd.exe /c "pause"
      }
    }
    else {
      Start-Process -WindowStyle Minimized $WINWS_EXE $WINWS_ARGS
      Start-Process -WindowStyle Hidden powershell.exe ${function:Start-WinwsMonitoring}
    }
  }
  "ServiceInstall" {
    if ($service_status -eq "SERVICE_RUNNING") {
      Write-Host "ZapretCompact is already installed as a service." -ForegroundColor Yellow
      & cmd.exe /c "pause"
    }
    elseif (Get-Process -Name "winws" -ErrorAction SilentlyContinue) {
      Write-Host "ZapretCompact currently running as a standalone app, close it first" -ForegroundColor Yellow
      & cmd.exe /c "pause"
    }
    else {
      Write-Host "Setting up ZapretCompact service..." -ForegroundColor Yellow
      & $NSSM_EXE install ZapretCompact $WINWS_EXE $WINWS_ARGS >$null 2>&1

      Write-Host "Configuring service properties..." -ForegroundColor Yellow
      & $NSSM_EXE set ZapretCompact DisplayName Zapret Compact Edition >$null 2>&1
      & $NSSM_EXE set ZapretCompact Description Bypasses DPI >$null 2>&1
      & $NSSM_EXE set ZapretCompact Start SERVICE_AUTO_START >$null 2>&1
      & $NSSM_EXE set ZapretCompact AppAffinity 1 >$null 2>&1

      Write-Host "Starting service ..." -ForegroundColor Yellow
      & $NSSM_EXE start ZapretCompact >$null 2>&1

      Write-Host "Service setup complete!" -ForegroundColor Green
      & cmd.exe /c "pause"
    }
  }
  "ServiceRemove" {
    if ($service_status -ne "SERVICE_RUNNING") {
      Write-Host "ZapretCompact service is not installed." -ForegroundColor Yellow
      & cmd.exe /c "pause"
    }
    else {
      Write-Host "Removing ZapretCompact service..." -ForegroundColor Yellow
      & $NSSM_EXE set ZapretCompact start SERVICE_DISABLED >$null 2>&1
      & $NSSM_EXE stop ZapretCompact >$null 2>&1
      & $NSSM_EXE remove ZapretCompact confirm >$null 2>&1

      Write-Host "Removing WinDivert service..." -ForegroundColor Yellow
      & sc.exe stop WinDivert >$null 2>&1
      & sc.exe delete WinDivert >$null 2>&1

      Write-Host "Service removed!" -ForegroundColor Green
      & cmd.exe /c "pause"
    }
  }
  default {
    Write-Host "Unknown action: $args[0]" -ForegroundColor Red
    & cmd.exe /c "pause"
  }
}
