#!/bin/bash

read -p "Enter domain (e.g. pctelcom.coop): " domain
echo ""
echo "=== 🔍 Checking MX records for $domain..."
mx_host=$(dig +short MX $domain | sort -n | head -1 | awk '{print $2}' | sed 's/\.$//')

if [[ -z "$mx_host" ]]; then
  echo "❌ No MX record found. Trying mail.$domain instead..."
  mx_host="mail.$domain"
fi

echo "Using mail server: $mx_host"
echo ""

echo "=== 🌐 Checking common ports..."

check_port() {
  port=$1
  proto=$2
  desc=$3

  echo -n "Testing $desc on port $port... "
  timeout 5 bash -c "echo > /dev/tcp/$mx_host/$port" 2>/dev/null && echo "✅ Open" || echo "❌ Closed"
}

check_port 993 "IMAPS" "IMAP SSL"
check_port 995 "POP3S" "POP3 SSL"
check_port 143 "IMAP" "IMAP (STARTTLS)"
check_port 110 "POP3" "POP3 (STARTTLS)"
check_port 465 "SMTPS" "SMTP SSL"
check_port 587 "SMTP" "SMTP STARTTLS"
check_port 25 "SMTP" "SMTP Plain/Relay"

echo ""
echo "*********************************************************"
echo ""
echo "-Mail Client Settings for $domain"
echo ""
echo "************************************"
echo "Incoming Mail Server"
echo "************************************"
echo ""
echo "---------"
echo "IMAP"
echo "---------"
echo "Port: 993"
echo "Security Type: SSL/TLS"
echo "U/N: USERNAME@$domain"
echo "Host: $mx_host"
echo ""
echo "-OR-"
echo ""
echo "----------"
echo "POP3"
echo "----------"
echo "Port: 995"
echo "Security Type: SSL/TLS"
echo "U/N: USERNAME@$domain"
echo "Host: $mx_host"
echo ""
echo "***************************************"
echo "Outgoing Mail Server (SMTP)"
echo "***************************************"
echo ""
echo "Port: 587"
echo "Security Type: STARTTLS"
echo "U/N: USERNAME@$domain"
echo "Host: $mx_host"
echo "Outgoing server requires authentication?: Yes"
echo ""
echo "-OR-"
echo ""
echo "Port: 465"
echo "Security Type: SSL/TLS"
echo "U/N: USERNAME@$domain"
echo "Host: $mx_host"
echo "Outgoing server requires authentication?: Yes"
echo ""
echo "*********************************************************"

read -p "Press Enter to return to Launchpad..."
