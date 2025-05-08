#!/bin/bash

clear

BANNER="
 ▓█████▄   ██▀███   ▒█████   ▄▄▄       ███▄ ▄███▓▓█████  ▄████▄  
 ▒██▀ ██▌ ▓██ ▒ ██▒▒██▒  ██▒▒████▄    ▓██▒▀█▀ ██▒▓█   ▀ ▒██▀ ▀█  
 ░██   █▌ ▓██ ░▄█ ▒▒██░  ██▒▒██  ▀█▄  ▓██    ▓██░▒███   ▒▓█    ▄ 
 ░▓█▄   ▌ ▒██▀▀█▄  ▒██   ██░░██▄▄▄▄██ ▒██    ▒██ ▒▓█  ▄ ▒▓▓▄ ▄██▒
 ░▒████▓  ░██▓ ▒██▒░ ████▓▒░ ▓█   ▓██▒▒██▒   ░██▒░▒████▒▒ ▓███▀ ░
  ▒▒▓  ▒  ░ ▒▓ ░▒▓░░ ▒░▒░▒░  ▒▒   ▓▒█░░ ▒░   ░  ░░░ ▒░ ░░ ░▒ ▒  ░
  ░ ▒  ▒    ░▒ ░ ▒░  ░ ▒ ▒░   ▒   ▒▒ ░░  ░      ░ ░ ░  ░  ░  ▒   
  ░ ░  ░    ░░   ░ ░ ░ ░ ▒    ░   ▒   ░      ░      ░   ░        
    ░        ░         ░ ░        ░  ░       ░      ░  ░░ ░      
  ░                                                       ░      

        GhostCheck v1.0  |  Domain Recon Tool by GhostOps
"


echo "$BANNER"

if [[ "$1" == "--help" ]]; then
  echo -e "\\nUsage: ghostcheck [domain]"
  echo "Runs a full DNS + email flow health scan on the given domain."
  echo -e "\\nOptions:"
  echo "  --help       Show this help message"
  echo "  --version    Show version info"
  exit 0
fi

if [[ "$1" == "--version" ]]; then
  echo "GhostCheck v1.0 by Ruben Valencia"
  exit 0
fi

if [[ -z "$1" ]]; then
  echo -e "\n❌ Error: No domain specified."
  echo "Usage: bash domain_health_check.sh example.com"
  exit 1
fi

DOMAIN=$1
TS=$(date +"%Y-%m-%d_%H-%M-%S")
LOGDIR=~/logs/domain_health
mkdir -p "$LOGDIR"
LOGFILE="${LOGDIR}/${DOMAIN}_${TS}.log"
find "$LOGDIR" -type f -name "*.log" -mtime +7 -delete
exec > >(tee -a "$LOGFILE") 2>&1

PASS=0
FAIL=0
WARN=0

print_section() { echo -e "\n\033[1;34m[== $1 ==]\033[0m"; }

print_good() { echo -e "✅ \033[1;32m$1\033[0m"; ((PASS++)); }
print_warn() { echo -e "⚠️  \033[1;33m$1\033[0m"; ((WARN++)); }
print_bad()  { echo -e "❌ \033[1;31m$1\033[0m"; ((FAIL++)); }

print_section "Basic DNS Records"

# 🔍 A Record + Geo IP + ASN + Flag
A_RECORDS=( $(dig +short A $DOMAIN) )
if [[ ${#A_RECORDS[@]} -eq 0 ]]; then
  print_bad "No A Record"
else
  for IP in "${A_RECORDS[@]}"; do
    RESPONSE=$(curl -s https://ipinfo.io/$IP/json)
    COUNTRY=$(echo "$RESPONSE" | jq -r '.country')
    REGION=$(echo "$RESPONSE" | jq -r '.region')
    CITY=$(echo "$RESPONSE" | jq -r '.city')
    ORG=$(echo "$RESPONSE" | jq -r '.org')

    # Convert country code to emoji flag
    FLAG=$(echo "$COUNTRY" | awk '{for(i=1;i<=length;i++) printf "\\U1F1" toupper(substr($0,i,1)); print ""}' | sed 's/\\U1F1/\\U1F1E/g')

    [[ "$COUNTRY" == "null" || -z "$COUNTRY" ]] && COUNTRY="🌐" && FLAG="🌐"
    [[ "$REGION" == "null" ]] && REGION="?"
    [[ "$CITY" == "null" ]] && CITY="?"
    [[ "$ORG" == "null" ]] && ORG="?"

    print_good "A Record: $IP  $FLAG $COUNTRY - $REGION, $CITY  🛰️ $ORG"
  done
fi

AAAA_RECORD=$(dig +short AAAA $DOMAIN | paste -sd ' ')
[[ -n "$AAAA_RECORD" ]] && print_good "AAAA Record: $AAAA_RECORD" || print_warn "No AAAA"

NS_RECORDS=$(dig +short NS $DOMAIN | paste -sd ', ' -)
[[ -n "$NS_RECORDS" ]] && print_good "NS Records: $NS_RECORDS" || print_bad "No NS"

SOA_RECORD=$(dig +short SOA $DOMAIN)
[[ -n "$SOA_RECORD" ]] && print_good "SOA: $SOA_RECORD" || print_warn "No SOA"

CNAME_RECORD=$(dig +short CNAME $DOMAIN)
[[ -n "$CNAME_RECORD" ]] && print_good "CNAME: $CNAME_RECORD" || print_warn "No CNAME"

print_section "MX Records"
MX=$(dig +short MX $DOMAIN)
[[ -n "$MX" ]] && print_good "MX Records: $MX" || print_bad "No MX records"

print_section "SPF Check"
SPF=$(dig +short TXT $DOMAIN | grep "v=spf1")
[[ -n "$SPF" ]] && print_good "SPF: $SPF" || print_warn "No SPF record"

print_section "DMARC Check"
DMARC=$(dig +short TXT _dmarc.$DOMAIN | grep "v=DMARC1")
[[ -n "$DMARC" ]] && print_good "DMARC: $DMARC" || print_warn "No DMARC record"

print_section "Reverse Lookup (PTR)"
PTR_IP=$(dig +short A $DOMAIN | head -n1)
PTR_HOST=$(dig +short -x $PTR_IP)
[[ -n "$PTR_HOST" ]] && print_good "PTR for $PTR_IP: $PTR_HOST" || print_warn "No PTR for $PTR_IP"

print_section "Blacklist Check"
DNSBLS=(zen.spamhaus.org bl.spamcop.net b.barracudacentral.org)
for BL in "${DNSBLS[@]}"; do
  REV_IP=$(echo $PTR_IP | awk -F. '{print $4"."$3"."$2"."$1}')
  LISTED=$(dig +short $REV_IP.$BL)
  [[ -n "$LISTED" ]] && print_bad "Listed on $BL" || print_good "Not listed on $BL"
done

print_section "WHOIS Summary"
whois $DOMAIN | grep -Ei "Registrar|Creation Date|Expiry|Name Server"

echo -e "\n🎯 Scan complete for: \033[1;36m$DOMAIN\033[0m"
echo -e "\n📁 Log saved to: \033[1;36m$LOGFILE\033[0m"

# End logging
exec &>/dev/tty

# Final summary + optional log view
echo -e "\\n---------------------------------------------------"
echo -e "📊 Summary: ✅ $PASS Passed   ❌ $FAIL Failed   ⚠️ $WARN Warnings"
read -p "📂 Open log now? (y/n): " openlog
[[ "$openlog" =~ ^[Yy]$ ]] && less "$LOGFILE"
