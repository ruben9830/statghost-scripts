#!/bin/bash
# timer_tool.sh - Simple time tracker

echo ""
read -p "🕒 Enter task name: " task
echo "⏳ Timer started for task: $task"
start=$(date +%s)

read -p "🔁 Press [Enter] to stop the timer..."
end=$(date +%s)

elapsed=$(( end - start ))
minutes=$(( elapsed / 60 ))
seconds=$(( elapsed % 60 ))

echo "✅ Task [$task] took ${minutes}m ${seconds}s"
