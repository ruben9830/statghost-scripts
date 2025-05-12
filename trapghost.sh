#!/bin/bash
# TrapGhost - SNMP Trap Triage Tool

INTERFACE="any"
PORT=162
KEYWORD=""
EXPECTED_IP=""

usage() {
  echo "Usage: $0 [--listen] [--filter <string>] [--expect-ip <ip>]"
  exit 1
}

while [[ "$1" != "" ]]; do
  case $1 in
    --listen ) LISTEN=true ;;
    --filter ) shift; KEYWORD=$1 ;;
    --expect-ip ) shift; EXPECTED_IP=$1 ;;
    * ) usage ;;
  esac
  shift
done

if [ "$LISTEN" = true ]; then
  echo "[✓] Listening for traps on UDP port $PORT..."
  tcpdump -n -nn -i $INTERFACE udp port $PORT 2>/dev/null | while read line; do
    echo "$line"
    if [[ "$KEYWORD" != "" && "$line" == *"$KEYWORD"* ]]; then
      echo "[✓] Trap matched keyword: $KEYWORD"
    fi
    if [[ "$EXPECTED_IP" != "" && "$line" != *"$EXPECTED_IP"* ]]; then
      echo "[!] Trap came from unexpected IP!"
    fi
  done
fi
