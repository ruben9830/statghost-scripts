#!/bin/bash

echo "📧 Email Flow Checker"

read -p "Enter the SMTP server to test (e.g., mail.example.com): " smtp_server
read -p "Enter the SMTP port (usually 25, 587, or 465): " smtp_port
read -p "Enter the IMAP server to test (e.g., imap.example.com): " imap_server
read -p "Enter the IMAP port (usually 143 or 993): " imap_port

echo ""
echo "🔎 Testing SMTP connection to $smtp_server on port $smtp_port..."
timeout 5 bash -c "</dev/tcp/$smtp_server/$smtp_port" && echo "✅ SMTP connection successful!" || echo "❌ SMTP connection failed."

echo ""
echo "🔎 Testing IMAP connection to $imap_server on port $imap_port..."
timeout 5 bash -c "</dev/tcp/$imap_server/$imap_port" && echo "✅ IMAP connection successful!" || echo "❌ IMAP connection failed."

echo ""
echo "✅ Email flow tests completed!"
