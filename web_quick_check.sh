#!/bin/bash

# GhostOps - Web Service Quick Test v2
# Tool 14: Diagnose a specific URL or domain quickly

clear

echo -e "\e[95m🛠️  Web Service Quick Test - GhostOps\e[0m"
echo "---------------------------------------------------"

read -p "🔗 Enter a domain or full URL (e.g. https://example.com or espn.com): " target
if [[ -z "$target" ]]; then
  echo -e "\e[91m❌ No input provided. Exiting.\e[0m"
  exit 1
fi

# Normalize input to include scheme if missing
if [[ "$target" != http* ]]; then
  url="https://$target"
else
  url="$target"
fi

# Extract domain name from URL
domain=$(echo "$url" | awk -F[/:] '{print $4}')
if [[ -z "$domain" ]]; then
  echo -e "\e[91m❌ Unable to extract domain from input. Exiting.\e[0m"
  exit 1
fi

echo -e "\n🔎 \e[96mDNS & IP Info for \e[93m$domain\e[0m:"
dig +short "$domain" || echo -e "\e[90m(No dig results)\e[0m"
host "$domain" | grep "has address" || echo -e "\e[90m(No A record found)\e[0m"

echo -e "\n🌐 \e[96mHTTP Status & Redirect Path:\e[0m"
curl -s -o /dev/null -w "Status: %{http_code}\nRedirect URL: %{redirect_url}\n" -L "$url"

echo -e "\n📄 \e[96mResponse Headers:\e[0m"
curl -sI "$url" | head -n 15

echo -e "\n🔐 \e[96mTLS Certificate Info:\e[0m"
timeout 5 bash -c "echo | openssl s_client -connect $domain:443 -servername $domain 2>/dev/null | openssl x509 -noout -issuer -subject -dates" || echo -e "\e[90m(No valid TLS info found)\e[0m"

echo -e "\n🧠 \e[96mUser-Agent Response Tests:\e[0m"
ua_desktop="Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
ua_mobile="Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X)"

echo -e "\n🖥️ Desktop UA:"
curl -s -A "$ua_desktop" -o /dev/null -w "%{http_code}\n" "$url"

echo -e "\n📱 Mobile UA:"
curl -s -A "$ua_mobile" -o /dev/null -w "%{http_code}\n" "$url"

echo -e "\n✅ \e[92mDiagnostics Complete.\e[0m Press Enter to return to menu..."
read
