#!/bin/bash
# rbl_check.sh — Check if an IP is blacklisted in common DNSBLs

echo -e "\e[91m🚨 DNS Blacklist Check\e[0m"
echo "------------------------------------"
read -p "Enter IP address to check: " ip
echo ""

# Basic IP format validation
if ! [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
  echo -e "❌ Invalid IP address. Please enter a valid IPv4 (e.g., 64.53.85.101)"
  exit 1
fi

# Common RBLs
lists=(
  zen.spamhaus.org
  bl.spamcop.net
  b.barracudacentral.org
  dnsbl.sorbs.net
  psbl.surriel.com
)

# Reverse IP
IFS='.' read -r o1 o2 o3 o4 <<< "$ip"
revip="$o4.$o3.$o2.$o1"

# Check each RBL
for list in "${lists[@]}"; do
  lookup="$revip.$list"
  result=$(dig +short "$lookup" @8.8.8.8)
  
  if [ -z "$result" ]; then
    echo -e "$list: \e[92mNot listed\e[0m"
  else
    echo -e "$list: \e[91mLISTED ➡ $result\e[0m"
  fi
done

echo "------------------------------------"
