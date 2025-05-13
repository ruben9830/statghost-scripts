#!/bin/bash
# 🌐 ghostops_helpers.sh – Shared GhostOps utilities

require_tools() {
  local missing=()
  for tool in "$@"; do
    if ! command -v "$tool" &>/dev/null; then
      missing+=("$tool")
    fi
  done
  if [[ ${#missing[@]} -gt 0 ]]; then
    echo -e "\e[91m❌ Missing required tools: ${missing[*]}\e[0m"
    echo "➡️  Install with: sudo apt install ${missing[*]}"
    exit 1
  fi
}
