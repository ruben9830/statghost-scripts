#!/bin/bash

clear
echo "🔐 GhostOps Spoofability Scanner"
echo "================================"
read -rp "Enter a domain to analyze: " domain

if [[ -z "$domain" ]]; then
  echo "❌ No domain entered. Exiting."
  exit 1
fi

echo ""
spf_domain="$domain"
spf=$(dig +short TXT "$spf_domain" | tr -d '"' | grep 'v=spf1')

# Handle SPF redirect
if [[ "$spf" == *"redirect="* ]]; then
  redirect_domain=$(echo "$spf" | sed -n 's/.*redirect=\([^ ]*\).*/\1/p')
  echo "↪️ SPF redirects to: $redirect_domain"
  spf=$(dig +short TXT "$redirect_domain" | tr -d '"' | grep 'v=spf1')
  spf_domain="$redirect_domain"
fi

echo ""
# Analyze SPF
if [[ "$spf" == *"-all"* ]]; then
  echo "✅ SPF is strict (-all) on $spf_domain:"
elif [[ "$spf" == *"~all"* ]]; then
  echo "⚠️ SPF uses soft fail (~all) on $spf_domain:"
elif [[ "$spf" == *"+all"* ]]; then
  echo "❌ SPF allows all (+all) on $spf_domain:"
else
  echo "❌ No valid SPF record found for $spf_domain"
fi
echo "   $spf"
echo ""

# DMARC
dmarc=$(dig +short TXT "_dmarc.$domain" | tr -d '"')
if [[ "$dmarc" == *"p=reject"* ]]; then
  echo "✅ DMARC policy is REJECT (strict):"
elif [[ "$dmarc" == *"p=quarantine"* ]]; then
  echo "⚠️ DMARC policy is QUARANTINE:"
elif [[ "$dmarc" == *"p=none"* ]]; then
  echo "❌ DMARC is NONE (no enforcement):"
else
  echo "❌ No DMARC record found."
fi
echo "   $dmarc"
echo ""

# DKIM
dkim=$(dig +short TXT "default._domainkey.$domain" | tr -d '"')
if [[ -n "$dkim" ]]; then
  echo "✅ DKIM record found at default._domainkey.$domain"
else
  echo "❌ No DKIM record found at default._domainkey.$domain"
fi

echo ""
# Verdict logic
echo "📛 Verdict:"
if [[ "$spf" == *"-all"* && "$dmarc" == *"p=reject"* && -n "$dkim" ]]; then
  echo "✅ $domain is well-protected against spoofing."
elif [[ "$spf" == *"~all"* || "$dmarc" == *"p=quarantine"* || -z "$dkim" ]]; then
  echo "⚠️ $domain is SPOOFABLE under many conditions."
else
  echo "❌ $domain is WIDE OPEN to spoofing."
fi
