#!/bin/bash

# 🧠 GhostOps Tool 29: DHCP Triage Assistant
# Created: 2025-05-16
# Author: Ruben Valencia (GhostOps)

LEASE_FILE="/var/lib/dhcpd/dhcpd.leases"

function banner() {
    clear
    echo "🧠 GhostOps DHCP Triage Tool v1.0"
    echo "----------------------------------"
}

function show_menu() {
    echo ""
    echo "What would you like to do?"
    echo "1️⃣  Search for a DHCP lease"
    echo "2️⃣  Guided DHCP ticket triage"
    echo "3️⃣  Lease summary by subnet"
    echo "4️⃣  Exit"
    echo ""
    read -p "Select option [1-4]: " opt
    case $opt in
        1) lease_search;;
        2) echo "🚧 Ticket triage not implemented yet"; sleep 2; banner; show_menu;;
        3) echo "🚧 Lease summary not implemented yet"; sleep 2; banner; show_menu;;
        4) echo "👻 Goodbye!"; exit 0;;
        *) echo "❌ Invalid option"; sleep 1; show_menu;;
    esac
}

function lease_search() {
    echo ""
    echo "Search lease by:"
    echo "a) MAC address"
    echo "b) IP address"
    echo ""
    read -p "Choose a or b: " search_type

    if [[ $search_type == "a" ]]; then
        read -p "🔗 Enter MAC address (e.g., ac:15:a2:6b:cd:54): " query
        matches=$(grep -in -B5 "$query" $LEASE_FILE)
    elif [[ $search_type == "b" ]]; then
        read -p "🌐 Enter IP address (e.g., 149.19.223.42): " query
        matches=$(grep -in "lease $query " $LEASE_FILE -A10)
    else
        echo "❌ Invalid choice."; sleep 1; lease_search
        return
    fi

    if [[ -z "$matches" ]]; then
        echo "❌ No leases found for $query"
    else
        echo ""
        echo "📍 Lease(s) found for: $query"
        echo "------------------------------"
        echo "$matches" | while IFS= read -r line; do
            if [[ $line == *"lease "* ]]; then
                ip=$(echo $line | awk '{print $2}')
                lineno=$(echo $line | cut -d: -f1)
                echo "📄 File: $LEASE_FILE"
                echo "🔢 Line: $lineno"
                echo -n "🧾 State: "; awk "NR==$lineno,NR==$lineno+10" $LEASE_FILE | grep "binding state" | awk '{print $3}' | tr -d ';'
                echo -n "📅 Starts: "; awk "NR==$lineno,NR==$lineno+10" $LEASE_FILE | grep "starts" | awk '{print $3, $4}' | tr -d ';'
                echo -n "🔗 MAC: "; awk "NR==$lineno,NR==$lineno+10" $LEASE_FILE | grep "hardware ethernet" | awk '{print $3}' | tr -d ';'
                echo ""
            fi
        done
    fi

    echo ""
    read -p "🔁 Return to main menu? (y/n): " back
    [[ $back == "y" || $back == "Y" ]] && banner && show_menu || exit 0
}

banner
show_menu
