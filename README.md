# 🧠 StatGhost Scripts Toolkit

Welcome to the **StatGhost Scripts Toolkit**, built by Ruben Valencia for elite-level NOC operations, server triage, and rapid diagnostics.

This toolkit includes powerful, modular bash utilities designed to run inside any Ubuntu-based environment. Fully portable via USB, GitHub, or WSL.

---

## 🚀 Tools Included

| Script Name                 | Purpose                                                                |
|-----------------------------|------------------------------------------------------------------------|
| `launchpad`                 | Master launcher with animated intro, tool selector, and Matrix styling |
| `find_ip_info_batch.sh`     | Batch lookup of DHCP logs by IP/date, raw subpoena-ready pulls         |
| `dns_query_tool.sh`         | Run `dig`, `nslookup`, and `host` on a domain in one click             |
| `email_flow_checker.sh`     | Test basic SMTP/IMAP email flow for any mailserver                     |
| `spf_failure_finder.sh`     | Scan logs for SPF/DKIM failures                                        |
| `spf_spoof_test.sh`         | Simulated spoofing test to evaluate SPF protection                     |
| `linux_command_trainer.sh`  | Randomized Linux CLI quiz to drill your skills                         |

---

## 🛠 Requirements
- Bash 4+
- Ubuntu / WSL / Debian-based system
- Permissions to access log files (e.g., `/var/log/dhcp.*.gz`)

## 📦 How to Use
Clone the repo or copy scripts to your server/workstation:

```bash
git clone https://github.com/ruben9830/statghost-scripts.git
cd statghost-scripts
chmod +x *
./launchpad

## 👤 Author
**Ruben Valencia**  
Data Science Masters Student | NOC Technician | CLI Wizard  
📍 Georgetown, KY  
🔗 [LinkedIn Profile](https://www.linkedin.com/in/rubenvalenciajr)  
🧠 *"Automate or die trying."*

---
© 2025 Ruben Valencia  
Licensed under the [MIT License](LICENSE)
