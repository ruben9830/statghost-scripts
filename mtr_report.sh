#!/bin/bash
# Tool 7 – Network Path Analyzer (Traceroute+GeoIP)
# By GhostOps | Requires: mtr, curl, jq, bc

source "$(dirname "$0")/ghostops_helpers.sh"
require_tools mtr bc curl jq

TARGET="$1"
COUNT="${2:-10}"

if [[ -z "$TARGET" ]]; then
  echo "Usage: $0 <target-hostname-or-IP> [packet-count]"
  echo "Example: $0 google.com 10"
  exit 1
fi

echo "📡 Running MTR report to $TARGET with $COUNT packets..."
mtr -rwzbc "$COUNT" "$TARGET" | tee /tmp/mtr_output.txt

echo
echo "📊 Analyzing results..."
echo "-------------------------------------------"

WARNINGS=0

grep -v '^\s*HOST' /tmp/mtr_output.txt | while read -r line; do
  hop=$(echo "$line" | awk '{print $2}')
  loss=$(echo "$line" | awk '{print $3}')
  avg=$(echo "$line" | awk '{print $6}')

  if [[ "$loss" == "100.0%" ]]; then
    echo "❌ Hop $hop: 100% packet loss"
    ((WARNINGS++))
  elif [[ "$loss" != "0.0%" ]]; then
    echo "⚠️  Hop $hop: Partial packet loss – $loss"
    ((WARNINGS++))
  elif [[ "$avg" =~ ^[0-9.]+$ ]] && (( $(echo "$avg > 80" | bc -l) )); then
    echo "⚠️  Hop $hop: High latency – Avg $avg ms"
    ((WARNINGS++))
  fi
done

[[ "$WARNINGS" -eq 0 ]] && echo "✅ No significant packet loss or latency detected."

# Ask to show Route Map
echo ""
read -p "🗺️  Show route map with GeoIP info? (y/n): " showmap
[[ "$showmap" =~ ^[Yy]$ ]] || { rm -f /tmp/mtr_output.txt; exit 0; }

echo -e "\n🌍 Route Map to $TARGET"
echo "-------------------------------------------"

awk '!/^ *HOST/ {print $NF}' /tmp/mtr_output.txt | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort -u > /tmp/mtr_ips.txt

while read -r ip; do
  [[ -z "$ip" ]] && continue

  geo=$(curl -s "http://ip-api.com/json/$ip")
  status=$(echo "$geo" | jq -r '.status')

  if [[ "$status" != "success" ]]; then
    echo "⛔ $ip – Lookup failed"
    continue
  fi

  city=$(echo "$geo" | jq -r '.city // "?"')
  region=$(echo "$geo" | jq -r '.regionName // "?"')
  country=$(echo "$geo" | jq -r '.country // "?"')
  asn=$(echo "$geo" | jq -r '.as // "?"')
  isp=$(echo "$geo" | jq -r '.isp // "?"')
  cc=$(echo "$geo" | jq -r '.countryCode // "US"')

  # Convert country code to emoji flag
  flag=$(echo "$cc" | awk '{printf("%c%c", 0x1F1E6 + index("ABCDEFGHIJKLMNOPQRSTUVWXYZ", substr($0,1,1)) - 1, 0x1F1E6 + index("ABCDEFGHIJKLMNOPQRSTUVWXYZ", substr($0,2,1)) - 1)}')

  echo "🌐 $ip – $city, $region, $country $flag | $asn | $isp"
done < /tmp/mtr_ips.txt

rm -f /tmp/mtr_output.txt /tmp/mtr_ips.txt
