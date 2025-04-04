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
        Write-Host "ZapretCompact is already running as a service."
        & cmd /c "pause"
      }
      break
    }

    Start-Process -WindowStyle Minimized $WINWS_EXE $WINWS_ARGS
    Start-Process -NoNewWindow powershell.exe ${function:Start-WinwsMonitoring}
  }
  "ServiceInstall" {
    if ($service_status -eq "SERVICE_RUNNING") {
      Write-Host "ZapretCompact is already installed as a service."
      & cmd.exe /c "pause"
      break
    }

    Write-Host "Setting up ZapretCompact service..."
    & $NSSM_EXE install ZapretCompact $WINWS_EXE $WINWS_ARGS >$null 2>&1

    Write-Host "Configuring service properties..."
    & $NSSM_EXE set ZapretCompact DisplayName Zapret Compact Edition >$null 2>&1
    & $NSSM_EXE set ZapretCompact Description Bypasses DPI >$null 2>&1
    & $NSSM_EXE set ZapretCompact Start SERVICE_AUTO_START >$null 2>&1
    & $NSSM_EXE set ZapretCompact AppAffinity 1 >$null 2>&1

    Write-Host "Starting service ..."
    & $NSSM_EXE start ZapretCompact >$null 2>&1

    Write-Host "Service setup complete!"
    & cmd.exe /c "pause"
  }
  "ServiceRemove" {
    if ($service_status -ne "SERVICE_RUNNING") {
      Write-Host "ZapretCompact service is not installed."
      & cmd.exe /c "pause"
      break
    }

    Write-Host "Removing ZapretCompact service..."
    & $NSSM_EXE set ZapretCompact start SERVICE_DISABLED >$null 2>&1
    & $NSSM_EXE stop ZapretCompact >$null 2>&1
    & $NSSM_EXE remove ZapretCompact confirm >$null 2>&1

    Write-Host "Removing WinDivert service..."
    & sc.exe stop WinDivert >$null 2>&1
    & sc.exe delete WinDivert >$null 2>&1

    Write-Host "Service removed!"
    & cmd.exe /c "pause"
  }
  default {
    Write-Host "Unknown action: $args[0]" -ForegroundColor Red
    & cmd.exe /c "pause"
  }
}
