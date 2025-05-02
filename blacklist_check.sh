#!/bin/bash
# blacklist_check.sh — Check if IP is blacklisted via DNSBL

clear
echo -e "\e[91m🚨 DNS Blacklist Check\e[0m"
echo "------------------------------------"
read -p "Enter IP address to check: " ip

# Reverse the IP for DNSBL lookup
reversed_ip=$(echo "$ip" | awk -F. '{print $4"."$3"."$2"."$1}')
dnsbls=(
  "zen.spamhaus.org"
  "bl.spamcop.net"
  "b.barracudacentral.org"
  "dnsbl.sorbs.net"
  "psbl.surriel.com"
)

for bl in "${dnsbls[@]}"; do
  result=$(dig +short "$reversed_ip.$bl")
  if [[ -z "$result" ]]; then
    echo -e "$bl: \e[32mNot listed\e[0m"
  else
    echo -e "$bl: \e[91mLISTED!\e[0m ➤ $result"
  fi
done

echo "------------------------------------"
read -p '🔁 Press Enter to return to menu...'
