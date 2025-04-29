#!/bin/bash

echo "👋 Welcome to the IP Subpoena Search Tool (Batch Mode)"

# --- Ask how many IPs to process ---
read -p "How many IPs do you need to search? " count

# --- Loop through each IP ---
for ((i=1; i<=count; i++))
do
  echo ""
  echo "🔹 Processing IP #$i"

  read -p "Enter the IP address: " ip
  read -p "Enter the date (MM-DD-YYYY): " input_date

  # Break down the date
  month=$(echo $input_date | cut -d'-' -f1)
  day=$(echo $input_date | cut -d'-' -f2)
  year=$(echo $input_date | cut -d'-' -f3)

  # Fix single-digit day
  if [[ "$day" == 0* ]]; then
    day="${day:1}"
  fi

  # Find correct DHCP log
  echo "Finding DHCP log for $input_date..."
  files=$(ls -lh --time-style=long-iso /var/log/dhcp.*.gz | grep "$year-$month" | awk '{print $8,$9}')
  dhcp_file=$(echo "$files" | awk -v d="$year-$month-$day" '$1 ~ d {print $2}' | head -n1)

  if [ -z "$dhcp_file" ]; then
    echo "❌ No DHCP log found for $input_date. Skipping this IP."
    continue
  fi

  echo "✅ Found: $dhcp_file"
  echo "🔎 Searching for IP: $ip ..."
  echo ""

  # Search and show results
  zgrep "$ip" "$dhcp_file"

  echo ""
  echo "✅ Done with IP #$i"
  echo "----------------------------------------"
done

echo "🏁 All IPs processed. Copy your raw pulls above for your ticket!"

