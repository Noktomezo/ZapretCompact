$ROOT = Split-Path -Parent $PSScriptROOT
$FILES = Join-Path $ROOT 'files'
$DOMAINS = Join-Path $ROOT 'hosts'

$AUTOHOSTLIST = Join-Path $DOMAINS 'autohostlist.txt'
$RUSSIA_BLOCKED_LIST = Join-Path $DOMAINS 'russia-blocked.txt'
$DISCORD_LIST = Join-Path $DOMAINS 'discord.txt'
$YOUTUBE_LIST = Join-Path $DOMAINS 'youtube.txt'
$QUIC_BIN = Join-Path $FILES 'quic_initial_www_google_com.bin'

return @{
  # Экзешники
  NSSM_EXE   = Join-Path $FILES 'nssm.exe'
  WINWS_EXE  = Join-Path $FILES 'winws.exe'

  # Стратегии
  WINWS_ARGS = @(
    "--wf-tcp=80,443 --wf-udp=443,50000-50099",
    "--filter-tcp=80 --hostlist-auto=`"$AUTOHOSTLIST`" --dpi-desync=fake,fakedsplit --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new",
    "--filter-tcp=443 --hostlist=`"$DISCORD_LIST`" --dpi-desync=fake,split --dpi-desync-autottl=5 --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-fake-tls-mod=rnd,dupsid,sni=www.cloudflare.com --new",
    "--filter-tcp=443 --hostlist=`"$YOUTUBE_LIST`" --dpi-desync=fake,multidisorder --dpi-desync-split-pos=1,midsld --dpi-desync-repeats=11 --dpi-desync-fooling=md5sig --dpi-desync-fake-tls-mod=rnd,dupsid,sni=www.google.com --new",
    "--filter-tcp=443 --hostlist-auto=`"$RUSSIA_BLOCKED_LIST`" --dpi-desync=fake,multidisorder --dpi-desync-split-pos=1,midsld --dpi-desync-repeats=11 --dpi-desync-fooling=md5sig --dpi-desync-fake-tls-mod=rnd,dupsid,sni=www.google.com --new",
    "--filter-udp=443 --hostlist=`"$RUSSIA_BLOCKED_LIST`" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic=`"$QUIC_BIN`" --new",
    "--filter-udp=50000-50099 --filter-l7=discord,stun --dpi-desync=fake"
  ) -Join " "
}
