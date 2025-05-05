#!/bin/bash
# smtp_tester.sh - Check SMTP server connectivity

read -p "Enter SMTP server (e.g., mail.example.com): " server
read -p "Enter port (usually 25, 465, or 587): " port

echo ""
echo "📡 Testing SMTP connectivity to $server on port $port..."
timeout 5 bash -c "echo -e 'EHLO test.localdomain\nQUIT' | openssl s_client -crlf -connect $server:$port 2>/dev/null | grep -E '220|250'"

if [ $? -ne 0 ]; then
  echo "❌ Connection failed or timed out."
else
  echo "✅ Connection successful."
fi
