#!/bin/bash

echo "🛡️  SPF/DKIM Failure Finder"

read -p "Enter the full path to the mail log file (e.g., /var/log/maillog): " log_file

if [ ! -f "$log_file" ]; then
  echo "❌ Log file not found. Please check the path."
  exit 1
fi

echo ""
echo "🔎 Searching for SPF and DKIM failures..."

grep -iE "spf=fail|dkim=fail|spf=softfail|dkim=none" "$log_file"

echo ""
echo "✅ Search complete. Review any failures above."
