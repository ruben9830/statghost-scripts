#!/bin/bash

# statghost-helper.sh — StatGhost CLI Assistant with Logging

LOGFILE="$HOME/statghost_usage.log"
USER_NAME=$(whoami)
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

log_action() {
  echo "[$TIMESTAMP] [$USER_NAME] Selected Option $1 — $2" >> "$LOGFILE"
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
    if command -v howdoi >/dev/null 2>&1; then
      log_action 2 "Email (howdoi)"
      howdoi check postfix logs
    else
      log_action 2 "howdoi not found"
      echo "⚠️  howdoi is not installed. Run: pipx install howdoi"
    fi
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
    if command -v howdoi >/dev/null 2>&1; then
      log_action 4 "Restart Services (howdoi)"
      howdoi restart a service in ubuntu
    else
      log_action 4 "howdoi not found"
      echo "⚠️  howdoi is not installed. Run: pipx install howdoi"
    fi
    ;;
  5)
    log_action 5 "Network Diag (cheat.sh)"
     echo -e "\n🌐 Network Diagnostic Commands (via tldr)\n"

  if command -v tldr >/dev/null 2>&1; then
    echo -e "🔹 ping:\n"
    tldr ping
    echo -e "\n🔹 traceroute:\n"
    tldr traceroute
    echo -e "\n🔹 netstat:\n"
    tldr netstat
  else
    echo "⚠️  tldr not installed. Run: sudo apt install tldr"
  fi
  ;;

  6)
    if command -v ollama >/dev/null 2>&1; then
      log_action 6 "Ollama launched"
      ollama run codellama    else
      log_action 6 "ollama not found"
      echo "⚠️  Ollama is not installed. Visit: https://ollama.com/download"
    fi
    ;;
  0)
    log_action 0 "Exited script"
    echo "Goodbye!" && exit 0
    ;;
  *)
    log_action "$opt" "Invalid choice"
    echo "❌ Invalid option."
    ;;
esac
