#!/bin/bash
# blacklist_check.sh — Accepts domain or IP, checks 30+ DNSBLs and prints summary

clear
echo -e "\e[91m🚨 RBL Blacklist IP Checker (accepts domain or IP)\e[0m"
echo "------------------------------------------------------------------"
read -p "Enter IP address or domain to check: " input
echo ""

# Resolve domain if needed
if [[ "$input" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
  ip="$input"
else
  echo "🌐 Resolving domain to IP..."
  ip=$(dig +short "$input" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -n 1)
fi

# Validate IP
if [[ -z "$ip" || ! "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
  echo -e "❌ Could not resolve a valid IP for: $input"
  exit 1
fi

echo -e "🔎 Checking RBL status for: \e[96m$ip\e[0m"
echo "------------------------------------------------------------------"

# Reverse IP for DNSBL format
IFS='.' read -r o1 o2 o3 o4 <<< "$ip"
revip="$o4.$o3.$o2.$o1"

# RBL list
dnsbls=(
  "zen.spamhaus.org"
  "dbl.spamhaus.org"
  "bl.spamcop.net"
  "b.barracudacentral.org"
  "dnsbl.sorbs.net"
  "web.dnsbl.sorbs.net"
  "smtp.dnsbl.sorbs.net"
  "new.spam.dnsbl.sorbs.net"
  "dnsbl-1.uceprotect.net"
  "dnsbl-2.uceprotect.net"
  "dnsbl-3.uceprotect.net"
  "psbl.surriel.com"
  "rbl.spamlab.com"
  "spamrbl.imp.ch"
  "cbl.abuseat.org"
  "rbl.realtimeblacklist.com"
  "dnsbl.inps.de"
  "virus.rbl.jp"
  "dnsbl.justspam.org"
  "drone.abuse.ch"
  "http.dnsbl.sorbs.net"
  "misc.dnsbl.sorbs.net"
  "escalations.dnsbl.sorbs.net"
  "z.mailspike.net"
  "bl.mailspike.net"
  "dnsbl.cyberlogic.net"
  "dnsbl.dronebl.org"
  "ix.dnsbl.manitu.net"
  "all.s5h.net"
  "spam.abuse.ch"
  "tor.dnsbl.sectoor.de"
  "orvedb.aupads.org"
)

# Counter
listed_count=0

# RBL loop
for bl in "${dnsbls[@]}"; do
  lookup="$revip.$bl"
  result=$(dig +short "$lookup" @8.8.8.8)

  if [[ -z "$result" ]]; then
    echo -e "$bl: \e[92mNot listed\e[0m"
  else
    echo -e "$bl: \e[91mLISTED!\e[0m ➤ $result"
    ((listed_count++))
  fi
done

echo "------------------------------------------------------------------"
echo -e "🧾 Summary: \e[93m$listed_count / ${#dnsbls[@]} RBLs\e[0m reported this IP as listed"
read -p "🔁 Press Enter to return to menu..."
