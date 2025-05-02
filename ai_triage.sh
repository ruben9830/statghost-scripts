#!/bin/bash
# ai_triage.sh — Ask local LLM (Ollama) to explain error messages

clear
echo -e "\e[95m🤖 AI Triage Assistant (via Ollama)\e[0m"
echo "------------------------------------------------------"

# Check if ollama is installed
if ! command -v ollama &> /dev/null; then
  echo "❌ Ollama is not installed. Install it from https://ollama.com/download"
  read -p '🔁 Press Enter to return to menu...'
  exit 1
fi

# Prompt user for the error or issue
read -p "Paste the error message or issue description: " input

# Query Ollama (default model: llama3)
echo -e "\n💬 Asking AI..."
echo "------------------------------------------------------"
ollama run llama3 "Act like a Linux NOC support tech. Help diagnose: $input"
echo "------------------------------------------------------"

read -p '🔁 Press Enter to return to menu...'
