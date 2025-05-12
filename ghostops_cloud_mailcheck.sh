#!/bin/bash

# GhostOps Cloud Mail Port Tester — GCP Edition (Interactive Fix)

INSTANCE_NAME="ghostops-mailcheck"
ZONE="us-central1-a"
PROJECT_ID=$(gcloud config get-value project)

echo "🚀 Creating temporary VM instance in $ZONE..."
gcloud compute instances create $INSTANCE_NAME \
  --zone=$ZONE \
  --machine-type=e2-micro \
  --image-family=ubuntu-2004-lts \
  --image-project=ubuntu-os-cloud \
  --quiet

echo "⏳ Waiting 20 seconds for the instance to boot..."
sleep 20

echo "📤 Uploading smtp_tester.sh..."
gcloud compute scp smtp_tester.sh $INSTANCE_NAME:~ --zone=$ZONE

echo "🛠 Installing netcat on remote VM..."
gcloud compute ssh $INSTANCE_NAME --zone=$ZONE --command "sudo apt update && sudo apt install netcat -y"

echo "✅ Setup complete!"
echo "👋 Launching interactive SSH session..."
echo "👉 Once inside, run: ./smtp_tester.sh"
echo ""

# Open interactive SSH session so the user can run the script manually
gcloud compute ssh $INSTANCE_NAME --zone=$ZONE

echo ""
read -p "🗑️ Press Enter to delete the cloud VM and exit..."
gcloud compute instances delete $INSTANCE_NAME --zone=$ZONE --quiet
