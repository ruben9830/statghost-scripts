#!/bin/bash

# ===============================================
# 📬 SPF Authorization Checker (Sender-As-Another-Domain)
# ===============================================
# Checks if source domain's mail servers are allowed
# to send mail on behalf of the target domain.
#
# Example:
#   If agrifulsoftware.com is sending email as intrstar.net,
#   run:
#     ./spf_authorization_check.sh intrstar.net agrifulsoftware.com
#
# ===============================================

source ./ghostops_helpers.sh
require_tools dig host

# Requirements
if ! command -v dig >/dev/null 2>&1 || ! command -v host >/dev/null 2>&1; then
  echo "❌ Requires 'dig' and 'host'. Install with: sudo apt install dnsutils"
  exit 1
fi

# Prompt for domains if not supplied
if [ "$#" -ne 2 ]; then
  read -p "Enter the domain being spoofed (e.g., intrstar.net): " TARGET_DOMAIN
  read -p "Enter the actual sending domain (e.g., agrifulsoftware.com): " SOURCE_DOMAIN
else
  TARGET_DOMAIN="$1"
  SOURCE_DOMAIN="$2"
fi

echo ""
echo "🔍 Checking SPF record for: $TARGET_DOMAIN"
SPF_RECORD=$(dig +short TXT "$TARGET_DOMAIN" | grep spf1 | tr -d '"')
echo "📜 SPF Record: $SPF_RECORD"

SOURCE_IP=$(dig +short A "$SOURCE_DOMAIN" | head -n1)
echo "🌐 $SOURCE_DOMAIN resolves to: $SOURCE_IP"
echo ""

if [[ "$SPF_RECORD" == *"$SOURCE_IP"* ]]; then
  echo "✅ $SOURCE_IP is explicitly listed in $TARGET_DOMAIN's SPF record."
else
  echo "❌ $SOURCE_IP is NOT listed in $TARGET_DOMAIN's SPF record."
  echo ""
  echo "📌 If $SOURCE_DOMAIN is sending mail using a 'From' address at $TARGET_DOMAIN,"
  echo "you must update $TARGET_DOMAIN's SPF record to authorize that server."
  echo ""
  echo "💡 Suggested Fix:"
  echo "   Add the following to $TARGET_DOMAIN's SPF:"
  echo "     ip4:$SOURCE_IP"
  echo "   OR an include: for $SOURCE_DOMAIN's SPF provider, if available."
  echo ""
  echo "📣 Contact the mail admin of $TARGET_DOMAIN to request SPF inclusion."
fi

echo ""
echo "✅ SPF Authorization Check Complete."
