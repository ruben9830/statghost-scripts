#!/bin/bash

LOGFILE="$HOME/statghost_usage.log"

if [[ ! -f "$LOGFILE" ]]; then
  echo "❌ Log file not found at $LOGFILE"
  exit 1
fi

clear
echo -e "\e[96m📊 StatGhost CLI Usage Log Viewer\e[0m"
echo "========================================="
echo -e "\e[93mTimestamp           | User     | Option | Description\e[0m"
echo "-----------------------------------------"

# Print formatted log entries
awk -F'[][]|  +' '{
  printf "\e[92m%-19s\e[0m | \e[96m%-8s\e[0m | \e[93m%-6s\e[0m | %s\n", $2, $4, $6, substr($0, index($0,$8))
}' "$LOGFILE"

echo -e "\n📁 Log location: $LOGFILE"
