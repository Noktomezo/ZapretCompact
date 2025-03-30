@echo off
chcp 65001 >nul 2>&1

set HOSTS=%~dp0hosts
set FILES=%~dp0files

echo ┌→ Установка службы...
(%FILES%\nssm.exe install ZapretCompact "%FILES%\winws.exe" ^
--wf-tcp=80,443 --wf-udp=443,50000-50099 ^
--filter-tcp=80 --dpi-desync=fake,fakedsplit --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --hostlist="%HOSTS%\russia-blocked.txt" --dpi-desync=fake,multidisorder --dpi-desync-split-pos=1,midsld --dpi-desync-repeats=11 --dpi-desync-fooling=md5sig --dpi-desync-fake-tls="%FILES%\tls_clienthello_www_google_com.bin" --dpi-desync-fake-tls-mod=rnd,dupsid --new ^
--filter-tcp=443 --hostlist-auto="%HOSTS%\autohostlist.txt" --dpi-desync=fake,multidisorder --dpi-desync-split-pos=midsld --dpi-desync-repeats=6 --dpi-desync-fooling=badseq,md5sig --new ^
--filter-udp=443 --hostlist="%HOSTS%\russia-blocked.txt" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic="%FILES%\quic_initial_www_google_com.bin" --new ^
--filter-udp=443 --hostlist-auto="%HOSTS%\autohostlist.txt" --dpi-desync=fake --dpi-desync-repeats=11 --new ^
--filter-udp=50000-50099 --ipset="%HOSTS%\ipset-discord.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-any-protocol --dpi-desync-cutoff=n4) >nul 2>&1

echo ├→ Настройка свойств службы...
%FILES%\nssm.exe set ZapretCompact DisplayName Zapret Compact Edition >nul 2>&1
%FILES%\nssm.exe set ZapretCompact Description Bypasses DPI >nul 2>&1
%FILES%\nssm.exe set ZapretCompact Start SERVICE_AUTO_START >nul 2>&1
%FILES%\nssm.exe set ZapretCompact AppAffinity 1 >nul 2>&1

echo ├→ Запуск службы...
%FILES%\nssm.exe start ZapretCompact >nul 2>&1

echo └→ Установка завершена.

pause
