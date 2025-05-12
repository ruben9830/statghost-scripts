#!/bin/bash
# Simple task timer for GhostOps

clear

echo "🕒 GhostOps Task Timer"
echo "--------------------------"
read -p "Enter task description: " task
start_time=$(date +%s)
start_fmt=$(date)

echo "⏳ Timer started at: $start_fmt"
read -p "Press [Enter] when finished..."

end_time=$(date +%s)
end_fmt=$(date)
duration=$((end_time - start_time))

hours=$((duration / 3600))
minutes=$(( (duration % 3600) / 60 ))
seconds=$((duration % 60))

echo "✅ Task completed: $task"
echo "🕓 Duration: ${hours}h ${minutes}m ${seconds}s"
echo "📅 Ended at: $end_fmt"

mkdir -p ~/logs
log_entry="[$(date)] $task — ${hours}h ${minutes}m ${seconds}s"
echo "$log_entry" >> ~/logs/task_timer.log
echo "📁 Logged to ~/logs/task_timer.log"

read -p "🔁 Press Enter to return to menu..."
