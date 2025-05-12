#!/bin/bash

# GhostOps Tool 12 — Mail Client Settings Report (Offline Config Only)

clear
echo -e "\e[95m📧 Mail Client Settings Report - GhostOps\e[0m"
echo "--------------------------------------------------"

read -p "Enter domain (e.g. example.com): " DOMAIN

EMAIL="you@$DOMAIN"
MAILHOST=$(dig +short MX $DOMAIN | sort | head -n1 | awk '{print $2}' | sed 's/\.$//')

if [ -z "$MAILHOST" ]; then
  MAILHOST="mail.$DOMAIN"
fi

echo ""
echo "*********************************************************"
echo ""
echo "📥 Incoming Mail Server"
echo "************************************"
echo ""
echo "---------"
echo "IMAP"
echo "---------"
echo "Port: 993"
echo "Security Type: SSL/TLS"
echo "U/N: USERNAME@$DOMAIN"
echo "Host: $MAILHOST"
echo ""
echo "-OR-"
echo ""
echo "----------"
echo "POP3"
echo "----------"
echo "Port: 995"
echo "Security Type: SSL/TLS"
echo "U/N: USERNAME@$DOMAIN"
echo "Host: $MAILHOST"
echo ""
echo "***************************************"
echo "📤 Outgoing Mail Server (SMTP)"
echo "***************************************"
echo ""
echo "Port: 587"
echo "Security Type: STARTTLS"
echo "U/N: USERNAME@$DOMAIN"
echo "Host: $MAILHOST (or smtp.$DOMAIN)"
echo "Outgoing server requires authentication?: Yes"
echo ""
echo "-OR-"
echo ""
echo "Port: 465"
echo "Security Type: SSL/TLS"
echo "U/N: USERNAME@$DOMAIN"
echo "Host: $MAILHOST (or smtp.$DOMAIN)"
echo "Outgoing server requires authentication?: Yes"
echo ""
echo "*********************************************************"
read -p "Press Enter to return to menu..."
