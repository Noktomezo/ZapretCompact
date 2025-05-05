$ROOT = Split-Path -Parent $(Split-Path -Parent $MyInvocation.MyCommand.Path)
$FILES = "$ROOT\files"
$HOSTS = "$ROOT\hosts"
$SCRIPTS = "$ROOT\files"
$NSSM_EXE = "$FILES\nssm.exe"
$WINWS_EXE = "$FILES\winws.exe"
$WINWS_ARGS = "`
--wf-tcp=80,443 --wf-udp=443,50000-50099 `
--filter-tcp=80 --dpi-desync=fake,fakedsplit --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new `
--filter-tcp=443 --hostlist=`"$HOSTS\russia-blocked.txt`" --dpi-desync=fake,multidisorder --dpi-desync-split-pos=1,midsld --dpi-desync-repeats=11 --dpi-desync-fooling=md5sig --dpi-desync-fake-tls-mod=rnd,dupsid,sni=www.google.com --new `
--filter-tcp=443 --hostlist-auto=`"$HOSTS\autohostlist.txt`" --dpi-desync=fake,multidisorder --dpi-desync-split-pos=1,midsld --dpi-desync-repeats=11 --dpi-desync-fooling=md5sig --dpi-desync-fake-tls-mod=rnd,dupsid,sni=www.google.com --new `
--filter-udp=443 --hostlist=`"$HOSTS\russia-blocked.txt`" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic=`"$FILES\quic_initial_www_google_com.bin`" --new `
--filter-udp=443 --hostlist=`"$HOSTS\autohostlist.txt`" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic=`"$FILES\quic_initial_www_google_com.bin`" --new `
--filter-udp=50000-50099 --filter-l7=discord,stun --dpi-desync=fake"
