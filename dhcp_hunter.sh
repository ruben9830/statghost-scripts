#!/bin/bash

# DHCP Hunter Tool v1.0 - GhostOps Utility
# Quickly search for DHCP lease blocks by IP, MAC, or date inside lease files

echo "👻 DHCP Hunter Tool – Scan leases by IP, MAC, or Date"
echo "-----------------------------------------------------"

read -p "Enter IP (or press Enter to skip): " ip
read -p "Enter MAC address (or press Enter to skip): " mac
read -p "Enter Date (YYYY/MM/DD) to filter (or press Enter to skip): " date
echo ""

LEASE_FILES=$(find /var/lib/dhcpd -type f -name "dhcpd.leases*")
if [ -z "$LEASE_FILES" ]; then
  echo "❌ No lease files found in /var/lib/dhcpd"
  exit 1
fi

for file in $LEASE_FILES; do
  echo "📄 Scanning $file..."
  awk -v ip="$ip" -v mac="$mac" -v date="$date" '
    BEGIN { RS = ""; IGNORECASE = 1 }
    /lease [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+ {/ {
      match_block = 1
      if (ip != "" && $0 !~ ip) match_block = 0
      if (mac != "" && $0 !~ mac) match_block = 0
      if (date != "" && $0 !~ date) match_block = 0
      if (match_block) print "\n-----------------------------\n" $0 "\n"
    }
  ' "$file"
done

echo "✅ Scan complete."
