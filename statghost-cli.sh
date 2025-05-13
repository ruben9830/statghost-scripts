#!/bin/bash

source ./ghostops_helpers.sh
require_tools curl dig howdoi tldr

# StatGhost CLI Assistant — Fully Upgraded with Smart Clipboard Support

LOGFILE="$HOME/statghost_usage.log"
USER_NAME=$(whoami)
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

log_action() {
  echo "[$TIMESTAMP] [$USER_NAME] Selected Option $1 — $2" >> "$LOGFILE"
}

copy_to_clipboard() {
  if command -v xclip &>/dev/null; then
    echo -n "$1" | xclip -selection clipboard
    echo "📋 Copied using xclip!"
  elif command -v wl-copy &>/dev/null; then
    echo -n "$1" | wl-copy
    echo "📋 Copied using wl-copy!"
  elif command -v pbcopy &>/dev/null; then
    echo -n "$1" | pbcopy
    echo "📋 Copied using pbcopy!"
  else
    echo "$1" > /tmp/ghostcopy.txt
    echo "📄 Copied to /tmp/ghostcopy.txt — please copy manually."
  fi
}

clear
echo -e "\e[96m"
cat << "EOF"
  ███████╗████████╗ █████╗ ████████╗ ██████╗  ██████╗ ███████╗████████╗
  ██╔════╝╚══██╔══╝██╔══██╗╚══██╔══╝██╔═══██╗██╔════╝ ██╔════╝╚══██╔══╝
  ███████╗   ██║   ███████║   ██║   ██║   ██║██║  ███╗█████╗     ██║
  ╚════██║   ██║   ██╔══██║   ██║   ██║   ██║██║   ██║██╔══╝     ██║
  ███████║   ██║   ██║  ██║   ██║   ╚██████╔╝╚██████╔╝███████╗   ██║
  ╚══════╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝   ╚═╝

               🧠 StatGhost CLI Assistant — Instant Triage Tools
EOF
echo -e "\e[0m"

echo ""
echo "1) DNS Troubleshooting"
echo "2) Email / Postfix Help"
echo "3) TLS/SSL Certificate Checks"
echo "4) Restarting Services"
echo "5) Network Diagnostics"
echo "6) Launch Offline AI (Ollama)"
echo "0) Exit"
echo ""
read -p "Select an option: " opt

case $opt in
  1)
    log_action 1 "DNS (cheat.sh)"
    curl -s cheat.sh/dig
    ;;

  2)
    log_action 2 "Email / Postfix Help"
    clear
    echo -e "\e[93m📧 Postfix / Email Troubleshooting Tips\e[0m"
    echo "--------------------------------------------"
    echo "1. sudo tail -n 50 /var/log/mail.log"
    echo "2. sudo grep -Ei 'reject|error|warning|relay' /var/log/mail.log"
    echo "3. mailq"
    echo "4. sudo postfix flush"
    echo "5. sudo systemctl restart postfix"
    read -p "Copy a command number to clipboard (1-5), or press Enter to skip: " copyopt
    case $copyopt in
      1) copy_to_clipboard "sudo tail -n 50 /var/log/mail.log" ;;
      2) copy_to_clipboard "sudo grep -Ei 'reject|error|warning|relay' /var/log/mail.log" ;;
      3) copy_to_clipboard "mailq" ;;
      4) copy_to_clipboard "sudo postfix flush" ;;
      5) copy_to_clipboard "sudo systemctl restart postfix" ;;
    esac
    read -p "🔁 Press Enter to return..."
    ;;

  3)
    if command -v tldr >/dev/null 2>&1; then
      log_action 3 "TLS (tldr)"
      tldr openssl
    else
      log_action 3 "tldr not found"
      echo "⚠️  tldr is not installed. Run: sudo apt install tldr"
    fi
    ;;

  4)
    log_action 4 "Restarting Services"
    clear
    echo -e "\e[94m🔄 Restart Common Services\e[0m"
    echo "---------------------------------"
    echo "1. sudo systemctl restart NetworkManager"
    echo "2. sudo systemctl restart named"
    echo "3. sudo systemctl restart postfix"
    echo "4. sudo systemctl restart dovecot"
    echo "5. journalctl -u <service> --no-pager"
    read -p "Copy a command number to clipboard (1-5), or press Enter to skip: " copyopt
    case $copyopt in
      1) copy_to_clipboard "sudo systemctl restart NetworkManager" ;;
      2) copy_to_clipboard "sudo systemctl restart named" ;;
      3) copy_to_clipboard "sudo systemctl restart postfix" ;;
      4) copy_to_clipboard "sudo systemctl restart dovecot" ;;
      5) copy_to_clipboard "journalctl -u <service> --no-pager" ;;
    esac
    read -p "🔁 Press Enter to return..."
    ;;

  5)
    log_action 5 "Network Diagnostics"
    clear
    echo -e "\e[96m🌐 Network Diagnostic Toolkit\e[0m"
    echo "----------------------------------"
    echo "1. ping -c 4 8.8.8.8"
    echo "2. traceroute google.com"
    echo "3. ss -tulnp"
    if command -v iftop >/dev/null 2>&1; then
      echo "4. sudo iftop"
    else
      echo "4. ⚠️ iftop not installed. sudo apt install iftop"
    fi
    if command -v mtr >/dev/null 2>&1; then
      echo "5. mtr -rwzbc 10 google.com"
    else
      echo "5. ⚠️ mtr not installed. sudo apt install mtr"
    fi
    read -p "Copy a command number to clipboard (1-5), or press Enter to skip: " copyopt
    case $copyopt in
      1) copy_to_clipboard "ping -c 4 8.8.8.8" ;;
      2) copy_to_clipboard "traceroute google.com" ;;
      3) copy_to_clipboard "ss -tulnp" ;;
      4) copy_to_clipboard "sudo iftop" ;;
      5) copy_to_clipboard "mtr -rwzbc 10 google.com" ;;
    esac
    read -p "🔁 Press Enter to return..."
    ;;

  6)
    if command -v ollama >/dev/null 2>&1; then
      log_action 6 "Ollama launched"
      ollama run codellama
    else
      log_action 6 "ollama not found"
      echo "⚠️  Ollama is not installed. Visit: https://ollama.com/download"
    fi
    ;;

  0)
    log_action 0 "Exited script"
    echo "👋 Goodbye!" && exit 0
    ;;

  *)
    log_action "$opt" "Invalid choice"
    echo "❌ Invalid option."
    ;;
esac
