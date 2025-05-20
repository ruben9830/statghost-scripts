#!/bin/bash

# GhostOps Tool 14 — Full Mail Port Connectivity Tester (Netcat + OpenSSL + Smart Detection)

clear

echo -e "\e[96m📬 Full Mail Port Connectivity Tester - GhostOps\e[0m"
echo "--------------------------------------------------------"

read -p "Enter domain (e.g. pctelcom.coop): " domain
echo ""
echo "🔍 Checking MX records for $domain..."
mx_host=$(dig +short MX "$domain" | sort -n | head -1 | awk '{print $2}' | sed 's/\.$//')

if [[ -z "$mx_host" ]]; then
  echo "❌ No MX record found. Trying mail.$domain instead..."
  mx_host="mail.$domain"
fi

echo "Using mail server: $mx_host"

# Detect major enterprise/cloud relays
if [[ "$mx_host" == *"protection.outlook.com"* ]]; then
  echo -e "\n⚠️  This domain appears to use Microsoft 365 (Exchange Online)."
  echo "   IMAP/SMTP client access may be blocked or use modern authentication (OAuth2)."
elif [[ "$mx_host" == *"google.com"* ]] || [[ "$mx_host" == *"gmail-smtp-in.l.google.com"* ]]; then
  echo -e "\n⚠️  This domain appears to use Google Workspace (Gmail)."
  echo "   Standard IMAP/SMTP ports may not respond unless authenticated through OAuth2."
elif [[ "$mx_host" == *"pphosted.com"* ]] || [[ "$mx_host" == *"pphosted"* ]]; then
  echo -e "\n⚠️  This domain appears to use Proofpoint (enterprise filtering)."
  echo "   Mail ports are likely firewalled or restricted to internal relays."
fi

echo ""
echo "🚪 Testing common mail ports with netcat..."

check_port() {
  port=$1
  label=$2
  echo -n "Port $port ($label)... "
  nc -z -w3 "$mx_host" "$port" 2>/dev/null && echo "✅ Open" || echo "❌ Closed"
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

# TLS Certificate Extractor
check_tls_cert() {
  port=$1
  service=$2
  echo -e "\n🔐 Testing $service on port $port..."
  timeout 5 openssl s_client -connect "$mx_host:$port" -servername "$mx_host" < /dev/null 2>/dev/null | awk '
    /CONNECTED/ { print "✅ Connected to " ENVIRON["mx_host"] ":" ENVIRON["port"] }
    /subject=/ { print "🔹 Subject CN: " $0 }
    /issuer=/ { print "🔸 Issuer: " $0 }
    /NotBefore/ { print "📅 Valid From: " $0 }
    /NotAfter/ { print "📅 Valid To: " $0 }
    /\* OK/ { print "📬 IMAP Banner: " $0 }
  '
}

# TLS tests on common ports
check_tls_cert 993 "IMAP SSL"
check_tls_cert 587 "SMTP STARTTLS"

echo ""
echo "🧠 Summary:"
echo "- If SMTP ports are closed, sending mail won't work."
echo "- If IMAP/POP3 ports are closed, receiving mail won't work."
echo "- If everything is closed, you're likely being blocked by firewall or ISP rules."
echo ""
read -p "🔁 Press Enter to return to menu..."
