#!/bin/bash
# web_quick_check.sh - Quick curl test

read -p "Enter website URL (e.g., https://example.com): " url
echo ""
echo "🌐 Sending HEAD request to $url..."
curl -I --max-time 5 "$url"
