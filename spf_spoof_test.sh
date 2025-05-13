#!/bin/bash

source ./ghostops_helpers.sh
require_tools dig

echo "📬 SPF Spoof Test Helper"
echo ""
echo "This guide will help you manually test if a domain is protected against email spoofing."
echo ""
echo "⚙️  Steps:"
echo "1) Open a Linux terminal."
echo "2) Use the 'sendemail' or 'swaks' tool to craft a spoofed email."
echo "Example (with swaks):"
echo ""
echo "swaks --to victim@example.com --from spoofed@targetdomain.com --server smtp.yourcompany.com"
echo ""
echo "3) Check if the spoofed email gets delivered or blocked."
echo "4) Analyze headers if it goes through (SPF PASS or FAIL)."
echo ""
echo "✅ TIP: A properly configured domain should cause SPF to FAIL on spoof attempts."
echo ""
echo "🚨 WARNING: Only perform spoof tests on domains you own or have permission to test!"
echo ""
echo "🏁 Done. Good luck testing!"
