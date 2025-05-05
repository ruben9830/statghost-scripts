#!/bin/bash
# domain_health_check.sh - DNS & host triage

echo "🌐 Domain Health Check"
read -p "Enter a domain to check: " domain

echo ""
echo "🔍 DNS Records:"
dig +short "$domain"
echo ""
echo "🔍 NS Records:"
dig NS "$domain" +short
echo ""
echo "🔍 MX Records:"
dig MX "$domain" +short
echo ""
echo "🔍 WHOIS Lookup:"
whois "$domain" | grep -Ei 'Registrar|Expiry|Expiration|Name Server|Updated'

echo ""
read -p "🔁 Press Enter to return to the menu..."
