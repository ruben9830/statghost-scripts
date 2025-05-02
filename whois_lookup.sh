#!/bin/bash
# whois_lookup.sh — Check domain expiration and registrar info

clear
echo -e "\e[96m🌐 WHOIS Lookup Tool\e[0m"
echo "------------------------------------------------------"

# Check if whois is installed
if ! command -v whois &> /dev/null; then
  echo "❌ whois is not installed. Install it with: sudo apt install whois"
  read -p '🔁 Press Enter to return to menu...'
  exit 1
fi

# Prompt for one or more domains
read -p "Enter domain(s) separated by space: " -a domains
echo ""

# Loop through each domain and run whois
for domain in "${domains[@]}"; do
  echo -e "\e[93m▶ Checking $domain...\e[0m"
  whois "$domain" | grep -Ei 'Domain Name:|Registrar:|Expiry|Expiration|Name Server:' | sed 's/^/   /'
  echo "------------------------------------------------------"
done

read -p '🔁 Press Enter to return to menu...'
