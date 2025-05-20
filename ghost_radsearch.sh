#!/bin/bash
# 🧠 GhostOps Tool 28 – DNS Record Jumper (Safe Editor)
# Updated: May 15, 2025 – Replaces noisy grep version

clear
echo "🧠 GhostOps Tool 28: DNS Record Line Jumper"
echo "-------------------------------------------"

if [ -z "$1" ]; then
    echo "[❗] Usage: $0 <search-term>"
    exit 1
fi

search="$1"
matches=()
index=1

# DNS zone search locations (add more if needed)
ZONE_PATHS=(
    "/var/named/chroot/var/named/master"
    "/var/named/master"
)

echo "[🔍] Searching zone files for: '$search'"
echo ""

for path in "${ZONE_PATHS[@]}"; do
    if [ -d "$path" ]; then
        while IFS=: read -r file line content; do
            display="[$index] $file (line $line) → $content"
            matches+=("$file:$line")
            echo "$display"
            ((index++))
        done < <(sudo grep -rHn "$search" "$path" 2>/dev/null)
    fi
done

if [ "${#matches[@]}" -eq 0 ]; then
    echo "[❌] No matches found in DNS zone files."
    exit 0
fi

echo ""
read -p "[🔢] Enter match number to jump to file: " choice
selected="${matches[$((choice-1))]}"

file="${selected%%:*}"
line="${selected##*:}"

echo ""
echo "[🚀] Opening '$file' at line $line"
echo "[🧠] Reminder: Press 'i' to edit, ESC then ':wq' to save, or ':q!' to exit."
sleep 1.5

sudo vi +$line "$file"

echo ""
read -p "[⚠️] Delete this script after use? (y/N): " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
    rm -- "$0"
    echo "[🧼] Script deleted."
else
    echo "[✔️] Script kept at: $0"
fi
