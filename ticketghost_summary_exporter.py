# ticketghost_summary_exporter.py

import csv
from datetime import datetime, timedelta
from pathlib import Path
import xlsxwriter

today = datetime.now().date()
log_dir = Path.home()
log_files = list(log_dir.glob("ticketghost_log_*.csv"))

# Filter only past 7 days
recent_logs = [f for f in log_files if datetime.strptime(f.stem.split("_")[-1], "%Y-%m-%d").date() >= today - timedelta(days=7)]

if not recent_logs:
    print("❌ No logs from the past 7 days.")
    exit()

wb_path = log_dir / f"ticketghost_summary_{today}.xlsx"
workbook = xlsxwriter.Workbook(wb_path)
worksheet = workbook.add_worksheet("Weekly Summary")

worksheet.write_row(0, 0, ["Time", "Event", "Ticket ID", "Details"])
row = 1

for file in recent_logs:
    with file.open() as f:
        reader = csv.reader(f)
        for line in reader:
            worksheet.write_row(row, 0, line)
            row += 1

workbook.close()
print(f"✅ Excel summary saved to {wb_path}")
