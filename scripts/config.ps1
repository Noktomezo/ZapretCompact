$ROOT = Split-Path -Parent $PSScriptROOT
$FILES = Join-Path $ROOT 'files'
$DOMAINS = Join-Path $ROOT 'hosts'

$RUSSIA_BLOCKED_IPSET = Join-Path $DOMAINS 'russia-blocked-ipset.txt'
# $YOUTUBE_LIST = Join-Path $DOMAINS 'youtube.txt'
$GOOGLE_QUIC_BIN = Join-Path $FILES 'quic_initial_www_google_com.bin'
$GOOGLE_TLS_BIN = Join-Path $FILES 'tls_clienthello_www_google_com.bin'
# $IANA_TLS_BIN = Join-Path $FILES 'tls_clienthello_iana_org.bin'

return @{
  # Экзешники
  NSSM_EXE   = Join-Path $FILES 'nssm.exe'
  WINWS_EXE  = Join-Path $FILES 'winws.exe'

  # Стратегии
  WINWS_ARGS = @(
    "--wf-tcp=80,443 --wf-udp=443,50000-50099",
    "--filter-tcp=80 --ipset=`"$RUSSIA_BLOCKED_IPSET`" --dpi-desync=fake,multisplit --dpi-desync-fooling=md5sig --dpi-desync-autottl=1",
    "--new --filter-tcp=443 --ipset=`"$RUSSIA_BLOCKED_IPSET`" --dpi-desync=fake,multidisorder --dpi-desync-fake-tls=0x00000000 --dpi-desync-fake-tls=! --dpi-desync-split-pos=1,midsld --dpi-desync-repeats=2 --dpi-desync-fooling=badseq --dpi-desync-fake-tls-mod=rnd,dupsid,sni=www.google.com",
    "--new --filter-udp=443 --ipset=`"$RUSSIA_BLOCKED_IPSET`" --dpi-desync=fake,multidisorder --dpi-desync-fooling=md5sig,badseq --dpi-desync-fake-quic=`"$GOOGLE_QUIC_BIN`"",
    "--new --filter-udp=50000-50099 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-fake-discord=0x00 --dpi-desync-fake-stun=0x00"
  ) -Join " "
}
