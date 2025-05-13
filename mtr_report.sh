#!/bin/bash
# Tool 7 – Network Path Analyzer (Traceroute+)
# Smart MTR wrapper that summarizes loss and latency
source ./ghostops_helpers.sh
require_tools mtr bc

TARGET="$1"
COUNT="${2:-10}"

if [[ -z "$TARGET" ]]; then
  echo "Usage: $0 <target-hostname-or-IP> [packet-count]"
  echo "Example: $0 google.com 10"
  exit 1
fi

# 🔍 Dependency check
MISSING=()
for tool in mtr bc; do
  if ! command -v "$tool" &> /dev/null; then
    MISSING+=("$tool")
  fi
done

if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo -e "\e[91m❌ Missing required tools: ${MISSING[*]}\e[0m"
  echo "Please install with: sudo apt install ${MISSING[*]}"
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

rm -f /tmp/mtr_output.txt
