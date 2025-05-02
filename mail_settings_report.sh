#!/bin/bash

# Usage: ./mail_settings_report.sh domain.com
DOMAIN=$1
EMAIL="you@$DOMAIN"

MAILHOST=$(dig +short MX $DOMAIN | sort | head -n1 | awk '{print $2}' | sed 's/\.$//')

if [ -z "$MAILHOST" ]; then
  MAILHOST="mail.$DOMAIN"
fi

echo -e "\n📧 Mail Client Settings for $DOMAIN"
echo "*********************************************************\n"

echo "📥 Incoming Mail Server"
echo "************************************"
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

echo -e "\n***************************************"
echo "📤 Outgoing Mail Server (SMTP)"
echo "***************************************"

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
