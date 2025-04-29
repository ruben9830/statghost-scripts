#!/bin/bash

echo "🧠 Welcome to the Linux Command Trainer!"

# List of questions and answers
questions=(
"What command lists files in a directory?|ls"
"What command shows your current directory?|pwd"
"What command copies files?|cp"
"What command moves or renames files?|mv"
"What command removes a file?|rm"
"What command creates a new directory?|mkdir"
"What command displays the contents of a file?|cat"
"What command shows running processes?|ps"
"What command checks disk usage?|df"
"What command shows active network connections?|netstat"
)

# Pick a random question
random_index=$((RANDOM % ${#questions[@]}))
IFS="|" read -r question answer <<< "${questions[$random_index]}"

echo ""
echo "❓ $question"
read -p "Your answer: " user_answer

if [[ "$user_answer" == "$answer" ]]; then
  echo "✅ Correct!"
else
  echo "❌ Wrong. The correct answer is: $answer"
fi

echo ""
echo "🏁 Training session complete!"
