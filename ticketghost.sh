#!/bin/bash
# ===============================================
# 🎫 TicketGhost - NOC II Ticket Monitor Tool
# ===============================================
# ✅ Detects new tickets + replies
# ✅ Sends WSL-safe desktop notifications
# ✅ Logs events to CSV
# ✅ Supports --export-today and --weekly-summary
# ✅ NEW: --show-latest to manually print last 5
# ✅ NEW: Shows "no change" if run manually
# ===============================================

source ./ghostops_helpers.sh
require_tools grep awk sed

API_KEY="your_api_key_here"
SERVER_URL="https://servicedesk.nrtc.coop"
LAST_ID_FILE="$HOME/.ticketghost_lastid"
LAST_REPLY_FILE="$HOME/.ticketghost_lastreply"
LOGFILE="$HOME/ticketghost_log_$(date +%F).csv"

# === Check for jq ===
if ! command -v jq >/dev/null 2>&1; then
  echo "❌ jq is not installed. Run: sudo apt install jq"
  exit 1
fi

# === Notification (WSL-safe) ===
notify_user() {
  TITLE="$1"
  BODY="$2"
  powershell.exe -Command "[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > \$null;   \$Template = [Windows.UI.Notifications.ToastTemplateType]::ToastText02;   \$Xml = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent(\$Template);   \$TextNodes = \$Xml.GetElementsByTagName('text');   \$TextNodes.Item(0).AppendChild(\$Xml.CreateTextNode('$TITLE')) > \$null;   \$TextNodes.Item(1).AppendChild(\$Xml.CreateTextNode('$BODY')) > \$null;   \$Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('TicketGhost');   \$Notification = [Windows.UI.Notifications.ToastNotification]::new(\$Xml);   \$Notifier.Show(\$Notification)" > /dev/null
}

# === CSV Logging ===
log_entry() {
  local time_now=$(date "+%Y-%m-%d %H:%M:%S")
  echo "$time_now,$1,$2,"$3"" >> "$LOGFILE"
}

# === Manual export options
if [[ "$1" == "--export-today" ]]; then
  SUMMARY="$HOME/ticketghost_summary.md"
  if [ ! -f "$LOGFILE" ]; then
    echo "❌ No log file found for today."
    exit 1
  fi
  echo "# 📋 Ticket Summary for $(date +%F)" > "$SUMMARY"
  echo "" >> "$SUMMARY"
  awk -F',' 'BEGIN {
    printf "| %-20s | %-10s | %-10s | %-50s |
", "Time", "Event", "Ticket ID", "Details"
    print "|----------------------|------------|------------|----------------------------------------------------|"
  }
  {
    printf "| %-20s | %-10s | %-10s | %-50s |
", $1, $2, $3, substr($4, 1, 50)
  }' "$LOGFILE" >> "$SUMMARY"
  echo "✅ Markdown summary created: $SUMMARY"
  exit 0
fi

if [[ "$1" == "--weekly-summary" ]]; then
  python3 "$(dirname "$0")/ticketghost_summary_exporter.py"
  exit 0
fi

if [[ "$1" == "--show-latest" ]]; then
  echo "🕵️  Showing 5 most recent tickets:"
  curl -s -H "authtoken: $API_KEY" -H "Content-Type: application/json" \
    "$SERVER_URL/api/v3/requests" | jq -r '.requests[] | "#\(.id): \(.subject)"' | head -n 5
  exit 0
fi

# === Main Ticket Monitoring ===
response=$(curl -s -H "authtoken: $API_KEY" -H "Content-Type: application/json" "$SERVER_URL/api/v3/requests")
latest_id=$(echo "$response" | jq -r '.requests[0].id // empty')
subject=$(echo "$response" | jq -r '.requests[0].subject // empty')

last_id=0
[ -f "$LAST_ID_FILE" ] && last_id=$(cat "$LAST_ID_FILE")

if [[ "$latest_id" != "" && "$latest_id" -gt "$last_id" ]]; then
  echo "$latest_id" > "$LAST_ID_FILE"
  echo "🚨 New Ticket: #$latest_id – $subject"
  notify_user "🚨 New Ticket #$latest_id" "$subject"
  log_entry "New Ticket" "$latest_id" "$subject"
else
  echo "✅ No new ticket. Last seen: #$last_id"
fi

# === Reply Monitoring ===
conv=$(curl -s -H "authtoken: $API_KEY" -H "Content-Type: application/json" "$SERVER_URL/api/v3/requests/$latest_id/conversations")
reply_time=$(echo "$conv" | jq -r '.conversations[0].created_time // empty')
reply_text=$(echo "$conv" | jq -r '.conversations[0].description // "New reply received."')

last_reply=""
[ -f "$LAST_REPLY_FILE" ] && last_reply=$(cat "$LAST_REPLY_FILE")

if [[ "$reply_time" != "" && "$reply_time" != "$last_reply" ]]; then
  echo "$reply_time" > "$LAST_REPLY_FILE"
  echo "📨 Reply on Ticket #$latest_id – $reply_time"
  notify_user "📨 Reply on Ticket #$latest_id" "$reply_text"
  log_entry "Reply" "$latest_id" "$reply_text"
fi
