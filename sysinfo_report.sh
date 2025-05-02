#!/bin/bash
# sysinfo_report.sh — Quick system info summary

clear
echo -e "\e[96m🧾 System Info Report\e[0m"
echo "------------------------------------"
echo "Hostname:     $(hostname)"
echo "Uptime:       $(uptime -p)"
echo "IP Address:   $(hostname -I | awk '{print $1}')"
echo "Memory Usage: $(free -h | awk '/Mem:/ {print $3 "/" $2}')"
echo "Disk Usage:   $(df -h / | awk 'END{print $3 "/" $2 " used"}')"
echo "CPU Load:     $(top -bn1 | grep load | awk '{printf "%.2f\n", $(NF-2)}')"
echo "OS Version:   $(lsb_release -ds 2>/dev/null || cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2)"
echo "------------------------------------"
read -p '🔁 Press Enter to return to menu...'
