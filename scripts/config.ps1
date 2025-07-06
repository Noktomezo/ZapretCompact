$ROOT = Split-Path -Parent $PSScriptROOT
$FILES = Join-Path $ROOT 'files'
$DOMAINS = Join-Path $ROOT 'hosts'

$RUSSIA_BLOCKED_IPSET = Join-Path $DOMAINS 'russia-blocked-ipset.txt'
$YOUTUBE_LIST = Join-Path $DOMAINS 'youtube.txt'
$QUIC_BIN = Join-Path $FILES 'quic_initial_www_google_com.bin'
$GOOGLE_TLS_BIN = Join-Path $FILES 'tls_clienthello_www_google_com.bin'
$IANA_TLS_BIN = Join-Path $FILES 'tls_clienthello_iana_org.bin'

return @{
  # Экзешники
  NSSM_EXE   = Join-Path $FILES 'nssm.exe'
  WINWS_EXE  = Join-Path $FILES 'winws.exe'

  # Стратегии
  WINWS_ARGS = @(
    "--wf-tcp=80,443 --wf-udp=443,50000-50099",
    "--filter-tcp=80 --ipset=`"$RUSSIA_BLOCKED_IPSET`" --dpi-desync=fake,split2 --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new",
    "--filter-tcp=443 --hostlist=`"$YOUTUBE_LIST`" --dpi-desync=split2 --dpi-desync-split-seqovl=681 --dpi-desync-split-seqovl-pattern=`"$GOOGLE_TLS_BIN`" --new",
    "--filter-tcp=443 --ipset=`"$RUSSIA_BLOCKED_IPSET`" --dpi-desync=syndata,multisplit --dpi-desync-fake-syndata=`"$IANA_TLS_BIN`" --dpi-desync-split-pos=1 --new",
    "--filter-udp=443 --hostlist=`"$YOUTUBE_LIST`" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic=`"$QUIC_BIN`" --new",
    "--filter-udp=443 --ipset=`"$RUSSIA_BLOCKED_IPSET`" --dpi-desync=ipfrag2 --dpi-desync-ipfrag-pos-udp=8 --new",
    "--filter-udp=50000-50099 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-fake-discord=0x00 --dpi-desync-fake-stun=0x00"
  ) -Join " "
}
