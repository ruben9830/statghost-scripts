#!/bin/bash
# port_scanner.sh — Simple TCP port scanner using bash and nc

clear
echo -e "\e[96m📡 Port Scanner (Top 20 TCP Ports)\e[0m"
echo "------------------------------------------------------"
read -p "Enter target IP or hostname: " target

ports=(21 22 23 25 53 80 110 139 143 443 445 465 587 993 995 1025 1723 3306 3389 5900)

for port in "${ports[@]}"; do
  timeout 1 bash -c "echo >/dev/tcp/$target/$port" 2>/dev/null &&
    echo -e "Port \e[32m$port OPEN\e[0m" ||
    echo -e "Port $port closed"
done

echo "------------------------------------------------------"
read -p '🔁 Press Enter to return to menu...'
