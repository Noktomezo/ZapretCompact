$thisFolder = Split-Path -Parent $MyInvocation.MyCommand.Definition
$rawStartCmdPath = Join-Path -Path $thisFolder -ChildPath "raw-start.cmd"

Start-Process -NoNewWindow $rawStartCmdPath >$null 2>&1

function Stop-WinDivertService {
    & sc.exe stop "WinDivert" >$null 2>&1
    & sc.exe delete "WinDivert" >$null 2>&1
}

while ($true) {
    $process = Get-Process -Name "winws" -ErrorAction SilentlyContinue
    if (-not $process) {
        Stop-WinDivertService
        break
    }
    Start-Sleep -Seconds 2
}
