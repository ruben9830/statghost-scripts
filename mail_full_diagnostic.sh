#!/bin/bash

# ─────────────────────────────────────────────
# 🧠 GhostOps Mail Diagnostic – Local or Cloud
# Author: Ruben Valencia (StatGhost)
# ─────────────────────────────────────────────

# Option to run remotely
read -p "🌐 Run test locally or in the cloud? (L/C): " mode
if [[ "$mode" =~ ^[Cc]$ ]]; then
  echo "🚀 Launching remote diagnostic using GhostOps cloud script..."
  bash ./ghostops_mail_diag_cloud.sh
  exit 0
fi

# Check for required tools
for cmd in dig timeout openssl tee curl; do
  if ! command -v $cmd &>/dev/null; then
    echo "❌ Required tool '$cmd' is missing. Please run from a full terminal or install prerequisites."
    exit 1
  fi
done

# Detect if running inside Google Cloud VM
if curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/id >/dev/null 2>&1; then
  echo "🛰️  Running in Google Cloud VM (remote)"
  is_cloud=true
else
  echo "💻 Running locally (this device)"
  is_cloud=false
fi

echo "📧 GhostOps Full Mail Diagnostic Tool"
echo "=========================================="

read -p "Enter domain (e.g. nrtc.coop): " domain
timestamp=$(date +"%Y%m%d_%H%M%S")
log_file="mail_diag_${domain//./_}_$timestamp.txt"

exec > >(tee -a "$log_file") 2>&1

echo ""
echo "=========================================="
if [ "$is_cloud" = true ]; then
  echo "🌐 Test Mode: Cloud VM"
else
  echo "🏠 Test Mode: Local"
fi
echo "=========================================="
echo ""

echo "🔍 Resolving MX records for $domain..."
mx_host=$(dig +short MX "$domain" | sort -n | head -1 | awk '{print $2}' | sed 's/\.$//')

if [[ -z "$mx_host" ]]; then
  echo "❌ No MX record found. Exiting."
  exit 1
fi

echo "✅ Found mail server: $mx_host"
echo ""

# DNS Lookups
echo "🌐 DNS Record Check:"
echo "-----------------------------"
dig +short A "$domain"
dig +short MX "$domain"
dig +short TXT "$domain" | grep -iE "spf|dkim|dmarc"
echo ""

# Port Testing
echo "🚪 Port Connectivity Test (Netcat):"
echo "-----------------------------"
declare -A ports=(
  [25]="SMTP Plain/Relay"
  [465]="SMTP SSL"
  [587]="SMTP STARTTLS"
  [993]="IMAP SSL"
  [143]="IMAP (STARTTLS)"
  [995]="POP3 SSL"
  [110]="POP3 (STARTTLS)"
)

for port in "${!ports[@]}"; do
  echo -n "Port $port (${ports[$port]})... "
  timeout 5 bash -c "</dev/tcp/$mx_host/$port" 2>/dev/null && echo "✅ Open" || echo "❌ Closed"
done
echo ""

# EOP Detection
if [[ "$mx_host" == *"mail.protection.outlook.com" ]]; then
  echo "💡 Detected Microsoft Exchange Online Protection (EOP)."
  echo "   Ports are commonly closed to the public by design."
  echo "   Use trusted relay IP or authenticated connection for deeper testing."
  echo ""
fi

# TLS Info
echo "🔐 TLS Check on Port 465:"
echo "-----------------------------"
timeout 5 openssl s_client -connect "$mx_host:465" -servername "$domain" < /dev/null 2>/dev/null | grep -E "subject=|issuer=|start date:|expire date:" || echo "❌ Could not fetch TLS info"

echo ""
echo "📁 Full diagnostic saved to: $log_file"
echo "🧠 Source: $([[ "$is_cloud" == true ]] && echo "Cloud ✅" || echo "Local 🏠")"
read -p "🔁 Press Enter to return to menu..."
