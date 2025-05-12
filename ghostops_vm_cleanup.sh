#!/bin/bash

echo "🧹 GhostOps VM Cleanup Script"
echo "────────────────────────────────────────"

# Set your default zone
ZONE="us-central1-a"

# Find matching VMs
vms=$(gcloud compute instances list --filter="name~^ghostops-" --format="value(name)")

if [[ -z "$vms" ]]; then
  echo "✅ No ghostops-* VMs found. You're all clear!"
  exit 0
fi

echo "🚨 Found the following GhostOps VMs:"
echo "$vms"
echo ""

read -p "❓ Do you want to delete ALL of these VMs now? (y/N): " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  for vm in $vms; do
    echo "🗑️ Deleting $vm..."
    gcloud compute instances delete "$vm" --zone="$ZONE" --quiet
  done
  echo "✅ Cleanup complete."
else
  echo "❌ Cleanup aborted. No VMs were deleted."
fi
