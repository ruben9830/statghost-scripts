#!/bin/bash

domain="$1"
config_file="$HOME/GhostCheck/config/hosting_patterns.conf"

[[ -z "$domain" ]] && {
    echo "❌ Usage: $0 domain.com"
    exit 1
}

if [[ ! -f "$config_file" ]]; then
    echo "⚠️  No hosting patterns found at $config_file"
    echo "➡️  Create this file with one pattern per line (e.g., neonova.net, nrtc.coop)"
    exit 2
fi

# Force-trim + clean patterns
patterns=()
while IFS= read -r line; do
    clean=$(echo "$line" | tr -d '\r' | xargs)
    [[ -n "$clean" ]] && patterns+=("$clean")
done < "$config_file"

echo -e "\n[== Hosting Status Check for: $domain ==]"

soa_record=$(dig +short SOA "$domain")
ns_records=($(dig +short NS "$domain"))

echo -e "\n[== SOA Record ==]\n$soa_record"
echo -e "\n[== NS Records ==]"
for ns in "${ns_records[@]}"; do
    echo "$ns"
done

echo -e "\n[== Hosting Status ==]"

match_found=false
matched_provider=""

# Debug dump of patterns
# echo "📜 Loaded patterns: ${patterns[*]}"

# Check SOA
for pattern in "${patterns[@]}"; do
    if [[ "$soa_record" == *"$pattern"* ]]; then
        echo "✅ Hosting matches known provider (SOA): $pattern"
        match_found=true
        matched_provider="$pattern"
        break
    fi
done

# Check NS records if no SOA match
if [[ "$match_found" == false ]]; then
    for ns in "${ns_records[@]}"; do
        for pattern in "${patterns[@]}"; do
            echo "🔍 Checking if [$ns] contains [$pattern]"
            if [[ "$ns" == *"$pattern"* ]]; then
                echo "✅ Hosting matches known provider (NS): $pattern"
                match_found=true
                matched_provider="$pattern"
                break 2
            fi
        done
    done
fi

# Final summary
if [[ "$match_found" == true ]]; then
    echo "✅ Hosting matches known provider: $matched_provider"
else
    echo "❌ Domain is *NOT* hosted by any known provider in your config"
fi
