$ROOT = Split-Path -Parent $PSScriptROOT
$FILES = Join-Path $ROOT 'files'
$DOMAINS = Join-Path $ROOT 'hosts'

$IPSET_RUSSIA_BLOCKED = Join-Path $DOMAINS 'ipset-russia-blocked.txt'
$IPSET_AMAZON = Join-Path $DOMAINS 'ipset-amazon.txt'
$HOSTS_GOOGLE = Join-Path $DOMAINS 'hosts-google.txt'

$GOOGLE_QUIC_BIN = Join-Path $FILES 'quic_initial_www_google_com.bin'
$GOOGLE_TLS_BIN = Join-Path $FILES 'tls_clienthello_www_google_com.bin'

return @{
  # Экзешники
  NSSM_EXE   = Join-Path $FILES 'nssm.exe'
  WINWS_EXE  = Join-Path $FILES 'winws.exe'

  # Стратегии
  WINWS_ARGS = @(
    "--wf-tcp=80,443,20000-21999 --wf-udp=443,19294-19344,20000-21999,50000-50100",
    "--filter-tcp=80 --ipset=`"$IPSET_RUSSIA_BLOCKED`" --dpi-desync=fake,fakedsplit --dpi-desync-autottl=2 --dpi-desync-fooling=badsum",
    "--new --filter-tcp=443 --hostlist=`"$HOSTS_GOOGLE`" --dpi-desync=split2 --dpi-desync-split-seqovl=681 --dpi-desync-split-seqovl-pattern=`"$GOOGLE_TLS_BIN`"",
    "--new --filter-tcp=443 --ipset=`"$IPSET_RUSSIA_BLOCKED`" --dpi-desync=multidisorder --dpi-desync-split-pos=1,sniext+1,host+1,midsld-2,midsld,midsld+2,endhost-1",
    "--new --filter-tcp=20000-21999 --ipset=`"$IPSET_AMAZON`" --dpi-desync=fake --dpi-desync-fake-tls-mod=none --dpi-desync-repeats=6 --dpi-desync-fooling=badseq --dpi-desync-badseq-increment=10000000",
    "--new --filter-udp=443 --hostlist=`"$HOSTS_GOOGLE`" --dpi-desync=fake --dpi-desync-repeats=11 --dpi-desync-fake-quic=`"$GOOGLE_QUIC_BIN`"",
    "--new --filter-udp=443 --ipset=`"$IPSET_RUSSIA_BLOCKED`" --dpi-desync=fake --dpi-desync-repeats=11",
    "--new --filter-udp=20000-21999 --ipset=`"$IPSET_AMAZON`" --dpi-desync=fake --dpi-desync-autottl=2 --dpi-desync-repeats=10 --dpi-desync-any-protocol=1 --dpi-desync-fake-unknown-udp=`"$GOOGLE_QUIC_BIN`" --dpi-desync-cutoff=n2",
    "--new --filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake"
  ) -Join " "
}
