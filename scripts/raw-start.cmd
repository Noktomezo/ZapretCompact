@echo off

set ROOT=%~dp0..
set FILES=%ROOT%\files
set HOSTS=%ROOT%\hosts

start "zapret-compact" /min "%FILES%\winws.exe" ^
--wf-tcp=80,443 --wf-udp=443,50000-50099 ^
--filter-tcp=80 --dpi-desync=fake,fakedsplit --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new ^
--filter-tcp=443 --hostlist="%HOSTS%\list-russia.txt" --dpi-desync=fake,multidisorder --dpi-desync-split-pos=1,midsld --dpi-desync-repeats=11 --dpi-desync-fooling=md5sig --dpi-desync-fake-tls="%FILES%\tls_clienthello_www_google_com.bin" --new ^
--filter-tcp=443 --dpi-desync=multidisorder --dpi-desync-split-pos=1,sniext+1,host+1,midsld-2,midsld,midsld+2,endhost-1 --new ^
--filter-udp=443 --hostlist="%HOSTS%\list-russia.txt" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic="%FILES%\quic_initial_www_google_com.bin" --new ^
--filter-udp=443 --dpi-desync=fake --dpi-desync-repeats=11 --new ^
--filter-udp=50000-50099 --ipset="%HOSTS%\ipset-discord.txt" --dpi-desync=fake --dpi-desync-any-protocol --dpi-desync-cutoff=d3 --dpi-desync-repeats=6
