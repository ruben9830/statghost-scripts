#!/bin/bash
# log_error_grabber.sh — Scan logs for recent errors or failures

source ./ghostops_helpers.sh
require_tools grep awk

clear
echo -e "\e[91m📄 Log Error Grabber\e[0m"
echo "------------------------------------------------------"

# Define default log files to scan
log_files=(
  "/var/log/syslog"
  "/var/log/auth.log"
  "/var/log/mail.log"
  "/var/log/messages"
)

# Define keywords to look for
keywords="fail|error|critical|denied|segfault|timeout|panic|refused"

# Loop through log files
for file in "${log_files[@]}"; do
  if [ -f "$file" ]; then
    echo -e "\n🔍 Checking $file"
    grep -iE "$keywords" "$file" | tail -n 10 | sed 's/^/   /'
  fi
done

echo -e "\n✅ Done scanning logs."
read -p '🔁 Press Enter to return to menu...'
