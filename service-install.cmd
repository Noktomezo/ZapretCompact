@echo off

set HOSTS=%~dp0hosts
set FILES=%~dp0files

(%FILES%\nssm.exe install ZapretCompact "%FILES%\winws.exe" ^
--wf-tcp=80,443 --wf-udp=443,50000-50099 ^
--filter-tcp=80 --dpi-desync=fake,fakedsplit --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --hostlist="%HOSTS%\list-youtube.txt" --dpi-desync=fake,multidisorder --dpi-desync-split-pos=1,midsld --dpi-desync-repeats=11 --dpi-desync-fooling=md5sig --dpi-desync-fake-tls="%FILES%\tls_clienthello_www_google_com.bin" --new ^
--filter-tcp=443 --dpi-desync=fake,multidisorder --dpi-desync-split-pos=midsld --dpi-desync-repeats=6 --dpi-desync-fooling=badseq,md5sig --new ^
--filter-udp=443 --hostlist="%HOSTS%\list-youtube.txt" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic="%FILES%\quic_initial_www_google_com.bin" --new ^
--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=11 --new ^
--filter-udp=50000-50099 --ipset="%HOSTS%\ipset-discord.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-any-protocol --dpi-desync-cutoff=n4--dpi-desync-any-protocol --dpi-desync-cutoff=n4

%FILES%\nssm.exe set ZapretCompact DisplayName Zapret Compact Edition
%FILES%\nssm.exe set ZapretCompact Description Bypasses DPI
%FILES%\nssm.exe set ZapretCompact Start SERVICE_AUTO_START
%FILES%\nssm.exe set ZapretCompact AppAffinity 1

%FILES%\nssm.exe start ZapretCompact) >nul 2>&1
