#!/bin/bash
# GhostOps Notes Viewer

clear

echo -e "\e[96m📓 GhostOps Notes Viewer\e[0m"
echo "----------------------------------"
echo "1) Synacor Escalation Template – RBL/550 Error"
echo "2) Tool 14 – Mail Port Tester + TLS Diagnostic Guide"
echo "3) Outlook Calendar Sync – Toolless Fix (HTC Webmail)"
echo "4) DMARC Fail – Forwarded Email to Outlook Gets Rejected"
echo "5) Exit"
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
    clear
    cat << "EOF"
📘 Tool 14 – Mail Port Tester + TLS Diagnostic Guide

Purpose:
Diagnose availability of mail services and verify SSL/TLS configuration for IMAP/SMTP using Tool 14.

From Launchpad:
🔧 Option: 14) Full Mail Port Connectivity Test

Tool Location:
~/scripts/smtp_tester.sh

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔍 What It Does:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
• Looks up MX records for a given domain
• Detects if domain is cloud-hosted (M365, Google, Proofpoint)
• Tests SMTP, IMAP, POP3 ports using netcat
• Uses OpenSSL to extract:
  - TLS protocol and cipher
  - Certificate CN, issuer, validity
  - IMAP server greeting banner (if any)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💻 Linux CLI Equivalents:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- MX Lookup: dig MX domain.com +short
- Port Check: nc -z -v mail.domain.com 993
- TLS Cert: openssl s_client -connect mail.domain.com:993

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🪟 Windows Equivalents:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- MX: nslookup -type=mx domain.com
- Port: Test-NetConnection -ComputerName mail.domain.com -Port 993
- TLS: Use OpenSSL via Git Bash or WSL

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🧠 Use Case:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Ticket #112589 – Outlook 2010 couldn't connect to vicki@sepb.net

✅ Tool 14 confirmed:
• mail.sepb.net on port 993 was reachable
• Certificate: valid, issued by Let's Encrypt
• IMAP banner received

EOF
    echo ""
    read -p "🔁 Press Enter to return..."
    ;;

  3)
    clear
    cat << "EOF"
📅 Outlook Calendar Sync – Toolless Fix (HTC Webmail ICS Issue)

🧠 Problem:
User tried to import .ics from HTC Webmail to Outlook and it failed to sync or show events.

❌ Importing .ics manually = one-time snapshot
❌ Link requires login = cannot subscribe
✅ Google Drive hosting allows sync workaround

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🛠️ Step-by-Step Fix:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. Download .ics from HTC Webmail
2. Upload to Google Drive
3. Right-click > Get Link > Anyone with link
4. Convert link:
   From:
   https://drive.google.com/file/d/FILEID/view?usp=sharing
   To:
   https://drive.google.com/uc?export=download&id=FILEID
5. Go to: https://outlook.office.com/calendar
   → Add calendar > Subscribe from web
   → Paste converted .ics link
   → Name it (e.g. "HTC Calendar") → Import

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔁 To Refresh Later:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Download updated .ics from webmail
- In Drive: Right-click calendar > Manage versions
- Upload new file (same name)

This keeps Outlook subscribed to a current version via Google.

EOF
    echo ""
    read -p "🔁 Press Enter to return..."
    ;;

  4)
    clear
    cat << "EOF"
📨 DMARC Fail – Forwarded Email to Outlook Gets Rejected

🧠 Scenario:
The City of Detroit, Oregon moved to Outlook (detroitor.gov) but still gets mail at old wvi.com inboxes.

Forwarding was set up in Zimbra for addresses like:
- cod_smith@wvi.com → detroit@detroitor.gov

Zimbra forwards the mail, but Outlook is rejecting it with:
❌ 550 5.7.509 Access denied – DMARC fail from hedricklawoffice.com

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔍 Root Cause:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- The original sender (hedricklawoffice.com) has a **strict DMARC policy**:
  ➤ aspf=s → strict SPF alignment required
- When mail is forwarded through wvi.com, it **breaks the Return-Path**
- Outlook sees mismatch between:
  ➤ From: hedricklawoffice.com
  ➤ Return-Path: rewritten via wvi.com
- Result: DMARC fails → Outlook blocks the message

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Fix Options:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. 🔧 Sender (hedricklawoffice.com) changes `aspf=s` → `aspf=r` in DMARC
   → Accepts relaxed SPF alignment, allows legit forwarding

2. 🛠️ Implement **ARC (Authenticated Received Chain)** or rewrite method with correct DKIM handling (complex)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 Summary:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Outlook rejected a forwarded message due to **strict DMARC alignment**.
The fix is to either:
- Relax DMARC SPF rules (`aspf=r`) or
- Use advanced email relay fixes (ARC, SRS with trusted relays)

EOF
    echo ""
    read -p "🔁 Press Enter to return..."
    ;;


  5)
    exit 0
    ;;
  *)
    echo "❌ Invalid selection"
    ;;
esac
