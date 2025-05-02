#!/bin/bash
# packet_lab.sh — Interactive packet capture utility

clear
echo -e "\e[96m📦 Packet Test Lab — tcpdump Helper\e[0m"
echo "------------------------------------------------------"

# Check if tcpdump is installed
if ! command -v tcpdump &> /dev/null; then
  echo "❌ tcpdump is not installed. Install it with: sudo apt install tcpdump"
  read -p '🔁 Press Enter to return to menu...'
  exit 1
fi

# Pre-select the most common interface for WSL
default_iface="eth0"
echo "Detected default interface: $default_iface"
read -p "Press Enter to use [$default_iface] or type another interface: " iface
iface="${iface:-$default_iface}"

# Filter menu
echo ""
echo "Select a filter:"
echo " 1) DNS Traffic (port 53)"
echo " 2) Web Traffic (HTTPS - port 443)"
echo " 3) Email SMTP (port 25)"
echo " 4) All traffic"
echo " 5) Custom filter"
read -p "Enter your choice: " fchoice

case $fchoice in
  1) filter="port 53" ;;
  2) filter="port 443" ;;
  3) filter="port 25" ;;
  4) filter="" ;;
  5) read -p "Enter custom tcpdump filter: " filter ;;
  *) echo "Invalid choice. Defaulting to port 53."; filter="port 53" ;;
esac

echo -e "\n🚦 Starting capture on \e[93m$iface\e[0m with filter: \e[93m${filter:-'none'}\e[0m"
echo "⏹ Press Ctrl+C to stop capture"
echo "------------------------------------------------------"
sudo tcpdump -i "$iface" $filter -nn -l -v

echo -e "\n✅ Capture complete."
read -p '🔁 Press Enter to return to menu...'
