#!/bin/bash

echo "🛠 Updating your GitHub repo..."

# Step 1: Ask for commit message
read -p "📝 Enter commit message: " commit_message

# Step 2: Git add, commit, push
git add .
git commit -m "$commit_message"
git push

echo "✅ GitHub update complete!"
