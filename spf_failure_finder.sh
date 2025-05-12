#!/bin/bash

# GhostOps Tool 9 — SPF/DKIM Failure Finder (SSH-Required Version)

clear
echo -e "\e[95m🛡️  SPF/DKIM Failure Finder - GhostOps\e[0m"
echo "---------------------------------------------------------"
echo -e "⚠️  \e[93mNote: This tool is meant to be used AFTER SSH'ing into a mail server.\e[0m"
echo -e "   It scans local mail logs for SPF and DKIM failures.\n"

# Try common mail log paths if user doesn't provide one
default_logs=(
  "/var/log/maillog"
  "/var/log/mail.log"
  "/var/log/zimbra.log"
  "/var/log/maillog.1"
  "/var/log/mail.log.1"
)

read -p "🔍 Enter full path to mail log file (or press Enter to auto-detect): " log_file

if [[ -z "$log_file" ]]; then
  echo -e "\n📂 No path entered. Scanning for common mail logs..."
  for path in "${default_logs[@]}"; do
    if [[ -f "$path" ]]; then
      log_file="$path"
      echo -e "✅ Found: $log_file"
      break
    fi
  done
fi

# Validate final log file path
if [[ ! -f "$log_file" ]]; then
  echo -e "\e[91m❌ No valid mail log found. Please SSH into the mail server and try again.\e[0m"
  read -p "🔙 Press Enter to return to menu..."
  exit 1
fi

# Timestamped output file
timestamp=$(date +%Y-%m-%d_%H-%M-%S)
output_file="spf_dkim_failures_${timestamp}.log"

echo -e "\n🔎 Scanning $log_file for SPF and DKIM failures..."
grep -iE "spf=fail|dkim=fail|spf=softfail|dkim=none" "$log_file" | tee "$output_file"

echo -e "\n✅ Done. Results saved to \e[92m$output_file\e[0m"
read -p "🔁 Press Enter to return to the menu..."
