#!/bin/bash

mkdir -p ~/logs/phishing_trace
TS=$(date +%Y-%m-%d_%H-%M-%S)
LOG=~/logs/phishing_trace/trace_$TS.log
TMP=/tmp/ghost_headers_input.txt

echo -e "📥 Paste full email headers below. Press CTRL+D when done:\n"
cat > "$TMP"
cp "$TMP" "$LOG"

IPS=$(grep -Eo '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' "$TMP")

# Filter public IPs
echo -e "\n🔎 Extracted public IPs:"
PUB_IPS=()
for ip in $IPS; do
  if [[ ! "$ip" =~ ^10\. ]] && [[ ! "$ip" =~ ^192\.168\. ]] && [[ ! "$ip" =~ ^172\.(1[6-9]|2[0-9]|3[0-1])\. ]] && [[ ! "$ip" =~ ^127\. ]]; then
    echo "🌐 $ip"
    PUB_IPS+=("$ip")
  fi
done

if [[ ${#PUB_IPS[@]} -eq 0 ]]; then
  echo "❌ No valid public IPs found."
  exit 1
fi

for ip in "${PUB_IPS[@]}"; do
  read -p "👉 Run domain_health_check.sh on $ip? (y/n): " go
  if [[ "$go" =~ ^[Yy]$ ]]; then
    bash ~/scripts/domain_health_check.sh "$ip"
  fi
done

echo -e "\n📝 Saved trace log to: $LOG"
