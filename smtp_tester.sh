#!/bin/bash

# GhostOps Tool 13 — Full Mail Port Connectivity Tester (Netcat Version)

clear

echo -e "\e[96m📬 Full Mail Port Connectivity Tester - GhostOps\e[0m"
echo "--------------------------------------------------------"

read -p "Enter domain (e.g. pctelcom.coop): " domain
echo ""
echo "🔍 Checking MX records for $domain..."
mx_host=$(dig +short MX $domain | sort -n | head -1 | awk '{print $2}' | sed 's/\.$//')

if [[ -z "$mx_host" ]]; then
  echo "❌ No MX record found. Trying mail.$domain instead..."
  mx_host="mail.$domain"
fi

echo "Using mail server: $mx_host"
echo ""
echo "🚪 Testing common mail ports with netcat..."

check_port() {
  port=$1
  label=$2
  echo -n "Port $port ($label)... "
  nc -z -w3 $mx_host $port 2>/dev/null && echo "✅ Open" || echo "❌ Closed"
}

# SMTP
check_port 25  "SMTP Plain/Relay"
check_port 465 "SMTP SSL"
check_port 587 "SMTP STARTTLS"

# IMAP
check_port 993 "IMAP SSL"
check_port 143 "IMAP (STARTTLS)"

# POP3
check_port 995 "POP3 SSL"
check_port 110 "POP3 (STARTTLS)"

echo ""
echo "🧠 Summary:"
echo "- If SMTP ports are closed, sending mail won't work."
echo "- If IMAP/POP3 ports are closed, receiving mail won't work."
echo "- If everything is closed, you're likely being blocked by firewall or ISP rules."
echo ""
read -p "🔁 Press Enter to return to menu..."
