#!/bin/bash

CONF="/etc/dhcpd.conf"
LEASES="/var/lib/dhcpd/dhcpd.leases"
VLAN="Calix_Vlan202"

echo "📡 GhostOps - IP Availability Map for $VLAN"
echo "==============================================="

awk -v vlan="$VLAN" '
  $0 ~ "shared-network " vlan {
    inblock = 1
    depth = 1
    print
    next
  }
  inblock {
    print
    depth += gsub(/{/, "{")
    depth -= gsub(/}/, "}")
    if (depth == 0) exit
  }
' "$CONF" > /tmp/vlan_block.tmp

if ! grep -q range /tmp/vlan_block.tmp; then
  echo "⛔ No DHCP ranges found in VLAN block. Exiting."
  exit 1
fi

grep -E 'range' /tmp/vlan_block.tmp | while read -r line; do
  RANGE_START=$(echo "$line" | awk '{print $2}')
  RANGE_END=$(echo "$line" | awk '{print $3}' | tr -d ';')

  echo -e "\n🌐 Range: $RANGE_START → $RANGE_END"
  echo "-----------------------------------------------"

  IFS=. read -r s1 s2 s3 s4 <<< "$RANGE_START"
  IFS=. read -r e1 e2 e3 e4 <<< "$RANGE_END"

  if [[ "$s1.$s2.$s3" != "$e1.$e2.$e3" ]]; then
    echo "⛔ Cross-subnet ranges not supported in this version"
    continue
  fi

  for i in $(seq $s4 $e4); do
    IP="$s1.$s2.$s3.$i"
    if grep -A 5 "lease $IP " "$LEASES" | grep -q "binding state active"; then
      echo "$IP - ACTIVE"
    else
      echo "$IP - AVAILABLE"
    fi
  done
done

rm -f /tmp/vlan_block.tmp
