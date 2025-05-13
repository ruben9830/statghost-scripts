   ███████╗████████╗ █████╗ ████████╗ ██████╗  ██████╗ ███████╗████████╗
   ██╔════╝╚══██╔══╝██╔══██╗╚══██╔══╝██╔═══██╗██╔════╝ ██╔════╝╚══██╔══╝
   ███████╗   ██║   ███████║   ██║   ██║   ██║██║  ███╗█████╗     ██║
   ╚════██║   ██║   ██╔══██║   ██║   ██║   ██║██║   ██║██╔══╝     ██║
   ███████║   ██║   ██║  ██║   ██║   ╚██████╔╝╚██████╔╝███████╗   ██║
   ╚══════╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝   ╚═╝
Built by Ruben Daniel Valencia Jr for elite NOC ops, server triage, and rapid diagnostics.  
Portable, fast, and battle-tested for Ubuntu/WSL-based systems.

---

## 🎃 What’s New in v2.1

- ✅ Centralized `require_tools()` via `ghostops_helpers.sh`
- 🔍 `ghostcheck_qamode.sh`: QA self-test script for tool validation
- 🛠️ Full SPF Toolkit refactor (spoof/IP/failure)
- 🔁 Standardized headers across all scripts
- 🧪 MTR Report: Visual traceroute analyzer (`mtr_report.sh`)

---

## 🚀 Tool Index

| Script                        | Description                                                  |
|-------------------------------|--------------------------------------------------------------|
| `launchpad`                   | 👻 Main launcher with banner, sound, and tool menu           |
| `statghost-cli.sh`            | Interactive CLI assistant (DNS, AI, email, logs)             |
| `find_ip_info_batch.sh`       | Batch DHCP lookup by IP/date – subpoena-style                |
| `dhcp_hunter.sh`              | Search DHCP leases by IP, MAC, or date on RADs               |
| `dns_query_tool.sh`           | One-click `dig`, `nslookup`, `host` diagnostic               |
| `domain_health_check.sh`      | DNS + WHOIS recon with SPF/DMARC checks                      |
| `email_flow_checker.sh`       | IMAP/SMTP connectivity tester                                |
| `mail_settings_report.sh`     | Fetch mail config via DNS (Thunderbird, Outlook)             |
| `mail_full_diagnostic.sh`     | Full mail port checker using openssl                         |
| `spf_failure_finder.sh`       | Search logs for SPF/DKIM failures                            |
| `spf_spoof_test.sh`           | Simulate spoof attempts for SPF testing                      |
| `spf_ip_checker.sh`           | Verify IP authorization via SPF TXT                          |
| `linux_command_trainer.sh`    | Randomized Bash quiz/training shell                          |
| `http_status_checker.sh`      | Grab HTTP status codes from a URL list                       |
| `web_quick_check.sh`          | Basic web service tester (URL, DNS, port)                    |
| `log_error_grabber.sh`        | Grep + timestamped error log extractor                       |
| `trapghost.sh`                | SNMP Trap listener and logger                                |
| `rbl_check.sh`                | Email blacklist (RBL) checker                                |
| `port_scanner.sh`             | Simple TCP port scanner using `nc`                           |
| `mtr_report.sh`               | 📡 Visual traceroute+ analyzer using MTR                     |
| `timer_tool.sh`               | ⏱️ Task timer / time tracker                                  |
| `view_ghostnotes.sh`          | Viewer for markdown-based NOC field notes                    |
| `ticketghost.sh`              | Ticket assistant: grep + summary tool                        |
| `ticketghost_summary_exporter.py` | Ticket summary generator in Python                       |
| `statghost-log-viewer.sh`     | Visual log viewer for tool usage                             |
| `whois_lookup.sh`             | WHOIS checker for domains/IPs                                |
| `ai_triage.sh`                | AI-assisted troubleshooting recommender                      |

---

##Requirements

- **Bash** 4+
- **Ubuntu / WSL / Debian**
- Tools used across scripts:  
  `curl`, `dig`, `whois`, `jq`, `less`, `grep`, `awk`, `mtr`, `host`, `nc`, `openssl`, `snmptrapd`, `howdoi`, `tldr`

> Install all core dependencies:
sudo apt install curl dig whois jq less grep awk mtr host netcat openssl snmptrapd howdoi tldr

A Mode
Run this to validate all tools before push or deploy:
./ghostcheck_qamode.sh
Checks for:

Script validity

Missing require_tools

Missing dependencies

Executable flags

Quick Start
git clone https://github.com/ruben9830/statghost-scripts.git
cd statghost-scripts
chmod +x *./launchpad

👤 Author
Ruben Daniel Valencia Jr.
📍 Georgetown, KY
🎓 Data Science MS Student | 🧠 CLI Wizard
💡 "Automate or die trying."

License
MIT License – © 2025 Ruben Valencia
