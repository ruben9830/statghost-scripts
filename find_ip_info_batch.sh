#!/bin/bash

# GhostOps Tool 1 — IP Subpoena Search Tool (Batch Mode)
# Use after SSH'ing into a DHCP log server — falls back to public IP info if off-network

clear
echo -e "\e[95m👋 Welcome to the IP Subpoena Search Tool (Batch Mode)\e[0m"
echo "-------------------------------------------------------------"
echo -e "⚠️  \e[93mNote: This tool is designed to be used AFTER SSH'ing into a network with access to DHCP logs.\e[0m"
echo -e "   Expected path: \e[94m/var/log/dhcp.*.gz\e[0m\n"

read -p "How many IPs do you need to search? " count
echo

for ((i=1; i<=count; i++)); do
  echo -e "🔹 Processing IP #$i"
  read -p "Enter the IP address: " ip
  read -p "Enter the date (MM-DD-YYYY): " date
  echo -e "Finding DHCP log for $date..."

  log_file=$(ls /var/log/dhcp.*"$date"*.gz 2>/dev/null | head -n 1)

  if [[ -f "$log_file" ]]; then
    echo -e "\e[92m📄 Found $log_file — scanning for $ip...\e[0m"
    zgrep "$ip" "$log_file" || echo -e "\e[90mNo matches found for $ip.\e[0m"
  else
    echo -e "\e[91m❌ No DHCP log found for $date.\e[0m"
    echo -e "\e[93m🌍 Running public IP info lookup as fallback...\e[0m"
    
    # Public fallback using ip-api.com
    response=$(curl -s "http://ip-api.com/json/$ip")

    status=$(echo "$response" | jq -r '.status')
    if [[ "$status" == "success" ]]; then
      echo -e "\n📡 \e[96mPublic IP Info for $ip:\e[0m"
      echo "$response" | jq -r '
        "🛰️  ISP: \(.isp)\n🔧 Org: \(.org)\n🌍 Country: \(.country)\n🏙️  City: \(.city)\n📍 Lat/Lon: \(.lat), \(.lon)\n🔒 ASN: \(.as)\n🌐 Reverse DNS: \(.reverse)"'
    else
      echo -e "\e[90m⚠️ Public lookup failed or returned no data.\e[0m"
    fi
  fi
  echo
done

echo -e "\e[92m🏁 All IPs processed. Copy your raw pulls above for your ticket!\e[0m"
read -p "🔁 Press Enter to return to the menu..."
