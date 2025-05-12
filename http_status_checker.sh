#!/bin/bash

# http_status_checker.sh — Check HTTP response codes for multiple URLs

clear
echo -e "\e[96m🌐 HTTP Status Checker\e[0m"
echo "------------------------------------"

# Define list of URLs to check
urls=(
  "https://google.com"
  "https://github.com"
  "https://duckduckgo.com"
  "https://thisurldoesnotexist.dev"
)

for url in "${urls[@]}"; do
  echo -n "Checking $url ... "
  status=$(curl -s --max-time 5 -o /dev/null -w "%{http_code}" "$url")
  case $status in
    200) echo -e "\e[32m$status OK\e[0m" ;;
    301|302) echo -e "\e[33m$status Redirect\e[0m" ;;
    404) echo -e "\e[91m$status Not Found\e[0m" ;;
    000) echo -e "\e[91mTimeout or DNS Fail\e[0m" ;;
    500|502|503) echo -e "\e[91m$status Server Error\e[0m" ;;
    *) echo -e "\e[90m$status Unknown\e[0m" ;;
  esac
done


echo -e "\n✅ Done!"
read -p "🔁 Press Enter to return to menu..."
