$ROOT = Split-Path -Parent $PSScriptROOT
$FILES = Join-Path $ROOT 'files'
$DOMAINS = Join-Path $ROOT 'hosts'

$ZAPRET_IP_USER = Join-Path $DOMAINS 'zapret-ip-user.txt'
$ZAPRET_HOSTS_GOOGLE = Join-Path $DOMAINS 'zapret-hosts-google.txt'

$GOOGLE_QUIC_BIN = Join-Path $FILES 'quic_initial_www_google_com.bin'
$GOOGLE_TLS_BIN = Join-Path $FILES 'tls_clienthello_www_google_com.bin'
$STUN_BIN = Join-Path $FILES 'stun.bin'

function Format-Strategy {
  param([string]$multilineStrategy)

  $lines = $multilineStrategy -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
  return $lines -join " "
}

$TCP_PORTS = "1-65535"
$UDP_PORTS = "1-65535"

$HTTP_STRATEGY_RUSSIA_BLOCKED = @"
  --filter-l7=http
  --ipset=`"$ZAPRET_IP_USER`"
  --dpi-desync=fake,multisplit
  --dpi-desync-split-pos=method+2
  --dpi-desync-fooling=md5sig
"@

$HTTPS_STRATEGY_GOOGLE = @"
  --filter-tcp=443
  --hostlist=`"$ZAPRET_HOSTS_GOOGLE`"
  --dpi-desync=fake,multisplit
  --dpi-desync-split-pos=2,sld
  --dpi-desync-fake-tls=0x0F0F0F0F
  --dpi-desync-fake-tls=`"$GOOGLE_TLS_BIN`"
  --dpi-desync-fake-tls-mod=rnd,dupsid,sni=ggpht.com
  --dpi-desync-split-seqovl=2108
  --dpi-desync-split-seqovl-pattern=`"$GOOGLE_TLS_BIN`"
  --dpi-desync-fooling=badsum,badseq
"@

$HTTPS_STRATEGY_RUSSIA_BLOCKED = @"
  --filter-l7=tls
  --ipset=`"$ZAPRET_IP_USER`"
  --dpi-desync=split2
  --dpi-desync-split-seqovl=681
  --dpi-desync-split-seqovl-pattern=`"$STUN_BIN`"
"@

$QUIC_STRATEGY_RUSSIA_BLOCKED = @"
  --filter-l7=quic
  --dpi-desync=fake
  --dpi-desync-repeats=6
  --dpi-desync-fake-quic=`"$GOOGLE_QUIC_BIN`"
"@

# (and telegram media actually)
$UDP_STRATEGY_DISCORD_STUN_WG = @"
  --filter-l7=discord,stun,wireguard
  --dpi-desync=fake
  --dpi-desync-repeats=2
"@

$UDP_STRATEGY_UNKNOWN = @"
  --filter-udp=*
  --filter-l7=unknown
  --ipset=`"$ZAPRET_IP_USER`"
  --dpi-desync=fake
  --dpi-desync-cutoff=d2
  --dpi-desync-any-protocol=1
  --dpi-desync-fake-unknown-udp=`"$GOOGLE_QUIC_BIN`"
"@

$FULL_STRATEGY = Format-Strategy @"
  --wf-tcp=$TCP_PORTS --wf-udp=$UDP_PORTS

  $HTTP_STRATEGY_RUSSIA_BLOCKED

  --new
  $HTTPS_STRATEGY_GOOGLE

  --new
  $HTTPS_STRATEGY_RUSSIA_BLOCKED

  --new
  $QUIC_STRATEGY_RUSSIA_BLOCKED

  --new
  $UDP_STRATEGY_DISCORD_STUN_WG

  --new
  $UDP_STRATEGY_UNKNOWN
"@

return @{
  NSSM_EXE   = Join-Path $FILES 'nssm.exe'
  WINWS_EXE  = Join-Path $FILES 'winws.exe'
  WINWS_ARGS = $FULL_STRATEGY
}
