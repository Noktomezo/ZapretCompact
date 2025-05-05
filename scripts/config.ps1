$ROOT = Split-Path -Parent $PSScriptROOT
$FILES = Join-Path $ROOT 'files'
$HOSTS = Join-Path $ROOT 'hosts'

$AUTOHOSTLIST = Join-Path $HOSTS 'autohostlist.txt'
$RUSSIA_BLOCKED_LIST = Join-Path $HOSTS 'russia-blocked.txt'
$QUIC_BIN = Join-Path $FILES 'quic_initial_www_google_com.bin'

return @{
  # Экзешники
  NSSM_EXE   = Join-Path $FILES 'nssm.exe'
  WINWS_EXE  = Join-Path $FILES 'winws.exe'

  # Аргументы командной строки
  WINWS_ARGS = @(
    "--wf-tcp=80,443 --wf-udp=443,50000-50099",
    "--filter-tcp=80 --hostlist-auto=`"$AUTOHOSTLIST`" --dpi-desync=fake,fakedsplit --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new",
    "--filter-tcp=443 --hostlist=`"$RUSSIA_BLOCKED_LIST`" --dpi-desync=fake,multidisorder --dpi-desync-split-pos=1,midsld --dpi-desync-repeats=11 --dpi-desync-fooling=md5sig --dpi-desync-fake-tls-mod=rnd,dupsid,sni=www.google.com --new",
    "--filter-tcp=443 --hostlist-auto=`"$AUTOHOSTLIST`" --dpi-desync=fake,multidisorder --dpi-desync-split-pos=1,midsld --dpi-desync-repeats=11 --dpi-desync-fooling=md5sig --dpi-desync-fake-tls-mod=rnd,dupsid,sni=www.google.com --new",
    "--filter-udp=443 --hostlist=`"$RUSSIA_BLOCKED_LIST`" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic=`"$QUIC_BIN`" --new",
    "--filter-udp=443 --hostlist=`"$AUTOHOSTLIST`" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic=`"$QUIC_BIN`" --new",
    "--filter-udp=50000-50099 --filter-l7=discord,stun --dpi-desync=fake"
  ) -Join " "
}
