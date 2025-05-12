#!/bin/bash
# GhostOps Notes Viewer

clear

echo -e "\e[96m📓 GhostOps Notes Viewer\e[0m"
echo "----------------------------------"
echo "1) Synacor Escalation Template – RBL/550 Error"
echo "2) Exit"
echo ""
read -p "Choose a note to view: " note_choice

case $note_choice in
  1)
    clear
    cat << "EOF"
📤 Synacor Escalation Template – Internal Reputation Block

Subject: Escalation – Outbound Mail Blocked by Internal Reputation Filter (IP: 64.250.61.100)

Hi Synacor Team,

We’re seeing an outbound mail delivery issue for a customer on the domain: peoplestelecom.net.

Affected users are receiving the following bounce error:

550 5.7.1 RBL Restriction – Blacklisted by Internal Reputation Service

This is affecting all users from their office location. Their public IP is:

➡️ IP Address: 64.250.61.100

🔎 Confirmed not listed on public DNSBLs (Spamhaus, Spamcop, Barracuda, etc.)

✅ Webmail and Zimbra access are functional
❌ SMTP is blocked with the above error

📌 Request:
Please review the internal reputation status of 64.250.61.100 and advise on clearing or delisting.

Let us know if you require headers or message samples.

Thanks,
EOF
    echo ""
    read -p "🔁 Press Enter to return..."
    ;;
  2)
    exit 0
    ;;
  *)
    echo "❌ Invalid selection"
    ;;
esac
