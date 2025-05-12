# 📦 TicketGhost Toolkit – NOC II Edition

## 🔧 What’s Included
- `ticketghost.sh` – Main script to monitor ServiceDesk Plus for new tickets & replies.
- Sends Windows toast alerts via PowerShell
- Logs to `~/ticketghost_log_YYYY-MM-DD.csv`
- Export support: Markdown (`--export-today`) and Excel (`--weekly-summary`)

## 🚀 Usage
```bash
chmod +x ticketghost.sh
./ticketghost.sh             # Run normally
./ticketghost.sh --show-latest     # Show 5 most recent tickets
./ticketghost.sh --export-today    # Create markdown summary
./ticketghost.sh --weekly-summary  # Generate Excel report
./ticketghost.sh --reset           # Reset saved state
```

## 🔑 Before Running
Edit `ticketghost.sh` and replace:
```bash
API_KEY="your_api_key_here"
```

## 📦 Requirements
- jq (for JSON parsing)
- Python 3 (for Excel summary)
- WSL + Windows 10/11 for notifications

