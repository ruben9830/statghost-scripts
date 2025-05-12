#!/bin/bash

ZONE="us-central1-a"
INSTANCE_NAME="ghostops-maildiag"
SCRIPT_NAME="mail_full_diagnostic.sh"

echo "🌩️ Launching Google Cloud VM for remote diagnostic..."
gcloud compute instances create $INSTANCE_NAME \
  --zone=$ZONE \
  --machine-type=e2-micro \
  --image-family=ubuntu-2004-lts \
  --image-project=ubuntu-os-cloud \
  --quiet

echo "⏳ Waiting 20 seconds for boot..."
sleep 20

echo "📤 Uploading diagnostic script..."
gcloud compute scp $SCRIPT_NAME $INSTANCE_NAME:~ --zone=$ZONE

echo "🔐 SSHing into VM to run the diagnostic..."
gcloud compute ssh $INSTANCE_NAME --zone=$ZONE --command="chmod +x $SCRIPT_NAME && ./$SCRIPT_NAME"

echo ""
read -p "📥 Enter domain to pull result log (leave blank to skip): " pull_domain
if [[ -n "$pull_domain" ]]; then
  safe_domain=$(echo "$pull_domain" | tr '.' '_')
  gcloud compute scp $INSTANCE_NAME:mail_diag_${safe_domain}_*.txt . --zone=$ZONE
fi

echo "🗑️ Cleaning up cloud VM..."
gcloud compute instances delete $INSTANCE_NAME --zone=$ZONE --quiet

echo "✅ Done!"
