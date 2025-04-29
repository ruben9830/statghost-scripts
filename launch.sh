#!/bin/bash

# Welcome message
clear
echo "🚀 Welcome to Ruben's NOC Toolkit 🚀"
echo ""
echo "Select a tool to run:"
echo ""
echo "1) Find IP Info (Batch Mode)"
echo "2) DNS Query Tool"
echo "3) Email Flow Checker"
echo "4) SPF Failure Finder"
echo "5) Linux Command Trainer"
echo "6) SPF Spoof Test"
echo "0) Exit"
echo ""

read -p "Enter your choice: " choice

case $choice in
  1)
    ./find_ip_info_batch.sh
    ;;
  2)
    ./dns_query_tool.sh
    ;;
  3)
    ./email_flow_checker.sh
    ;;
  4)
    ./spf_failure_finder.sh
    ;;
  5)
    ./linux_command_trainer.sh
    ;;
  6)
    ./spf_spoof_test.sh
    ;;
  0)
    echo "Goodbye!"
    exit 0
    ;;
  *)
    echo "❌ Invalid option. Try again."
    sleep 2
    ./launch.sh
    ;;
esac
