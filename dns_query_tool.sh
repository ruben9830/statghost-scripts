#!/bin/bash

source ./ghostops_helpers.sh
require_tools dig nslookup

echo "🌐 DNS Query Tool"

read -p "Enter the domain or IP to query: " target

echo ""
echo "🔎 DIG result:"
dig +short "$target"

echo ""
echo "🔎 NSLOOKUP result:"
nslookup "$target"

echo ""
echo "🔎 HOST result:"
host "$target"

echo ""
echo "✅ DNS queries completed!"

