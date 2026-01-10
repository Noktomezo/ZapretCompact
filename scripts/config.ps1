$ROOT = Split-Path -Parent $PSScriptROOT
$FILES = Join-Path $ROOT 'files'
$DOMAINS = Join-Path $ROOT 'hosts'

$IPSET_RUSSIA_BLOCKED = Join-Path $DOMAINS 'ipset-russia-blocked.txt'
$HOSTS_GOOGLE = Join-Path $DOMAINS 'hosts-google.txt'

$GOOGLE_QUIC_BIN = Join-Path $FILES 'quic_initial_www_google_com.bin'
$GOOGLE_TLS_BIN = Join-Path $FILES 'tls_clienthello_www_google_com.bin'

function Normalize-Strategy {
  param([string]$multilineStrategy)

  $lines = $multilineStrategy -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

  return $lines -join " "
}

$TCP_PORTS = "80,443,2053,2083,2087,2096,8443"
$UDP_PORTS = "443,1024-65535"

$HTTP_STRATEGY_RUSSIA_BLOCKED = @"
  --filter-tcp=80
  --ipset=`"$IPSET_RUSSIA_BLOCKED`"
  --dpi-desync=fake,fakedsplit
  --dpi-desync-autottl=2
  --dpi-desync-fooling=badsum
"@

# $HTTPS_STRATEGY_GOOGLE = @"
#   --filter-tcp=443
#   --hostlist=`"$HOSTS_GOOGLE`"
#   --dpi-desync=fake,multisplit
#   --dpi-desync-split-pos=2,sld
#   --dpi-desync-fake-tls=0x0F0F0F0F
#   --dpi-desync-fake-tls=`"$GOOGLE_TLS_BIN`"
#   --dpi-desync-fake-tls-mod=rnd,dupsid,sni=ggpht.com
#   --dpi-desync-split-seqovl=2108
#   --dpi-desync-split-seqovl-pattern=`"$GOOGLE_TLS_BIN`"
#   "--dpi-desync-fooling=badsum,badseq"
# "@

$HTTPS_STRATEGY_RUSSIA_BLOCKED = @"
  --filter-tcp=443
  --ipset=`"$IPSET_RUSSIA_BLOCKED`"
  --dpi-desync=fake,multisplit
  --dpi-desync-split-pos=2,sld
  --dpi-desync-fake-tls=0x0F0F0F0F
  --dpi-desync-fake-tls=`"$GOOGLE_TLS_BIN`"
  --dpi-desync-fake-tls-mod=rnd,dupsid,sni=ggpht.com
  --dpi-desync-split-seqovl=2108
  --dpi-desync-split-seqovl-pattern=`"$GOOGLE_TLS_BIN`"
  --dpi-desync-fooling=badsum,badseq
"@

$HTTPS_STRATEGY_DISCORD_VOICE = @"
  --filter-tcp=2053,2083,2087,2096,8443
  --hostlist-domains=discord.media
  --dpi-desync=multisplit
  --dpi-desync-split-seqovl=652
  --dpi-desync-split-pos=2
  --dpi-desync-split-seqovl-pattern=`"$GOOGLE_TLS_BIN`"
"@

$QUIC_STRATEGY_RUSSIA_BLOCKED = @"
  --filter-udp=443
  --dpi-desync=fake
  --dpi-desync-repeats=6
  --dpi-desync-fake-quic=`"$GOOGLE_QUIC_BIN`"
"@

$QUIC_STRATEGY_DISCORD_VOICE = @"
  --filter-udp=19294-19344,50000-50100
  --filter-l7=discord,stun
  --dpi-desync=fake
  --dpi-desync-repeats=6
"@

$QUIC_OTHER = @"
  --filter-udp=1024-19293,19345-49999,50101-65535
  --dpi-desync=fake
  --dpi-desync-cutoff=d2
  --dpi-desync-any-protocol=1
  --dpi-desync-fake-unknown-udp=`"$GOOGLE_QUIC_BIN`"
"@

$FULL_STRATEGY = Normalize-Strategy @"
  --wf-tcp=$TCP_PORTS --wf-udp=$UDP_PORTS

  $HTTP_STRATEGY_RUSSIA_BLOCKED

  --new 
  $HTTPS_STRATEGY_RUSSIA_BLOCKED

  --new 
  $HTTPS_STRATEGY_DISCORD_VOICE

  --new 
  $QUIC_STRATEGY_RUSSIA_BLOCKED

  --new 
  $QUIC_STRATEGY_DISCORD_VOICE

  --new 
  $QUIC_OTHER
"@

return @{
  NSSM_EXE   = Join-Path $FILES 'nssm.exe'
  WINWS_EXE  = Join-Path $FILES 'winws.exe'
  WINWS_ARGS = $FULL_STRATEGY
}
