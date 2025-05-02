# 🧠 StatGhost Scripts Toolkit

```bash
   ███████╗████████╗ █████╗ ████████╗ ██████╗  ██████╗ ███████╗████████╗
   ██╔════╝╚══██╔══╝██╔══██╗╚══██╔══╝██╔═══██╗██╔════╝ ██╔════╝╚══██╔══╝
   ███████╗   ██║   ███████║   ██║   ██║   ██║██║  ███╗█████╗     ██║   
   ╚════██║   ██║   ██╔══██║   ██║   ██║   ██║██║   ██║██╔══╝     ██║   
   ███████║   ██║   ██║  ██║   ██║   ╚██████╔╝╚██████╔╝███████╗   ██║   
   ╚══════╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝   ╚═╝   
```

> Built by **Ruben Valencia** for elite NOC ops, server triage, and rapid diagnostics.  
> Portable, fast, and battle-tested for Ubuntu/WSL-based systems.

[![Shell](https://img.shields.io/badge/language-bash-blue.svg)](https://bash.org)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Last Commit](https://img.shields.io/github/last-commit/ruben9830/statghost-scripts.svg)](https://github.com/ruben9830/statghost-scripts)

---

## 🚀 Included Tools

| Script Name                 | Description |
|----------------------------|-------------|
| `launchpad`                | Master script launcher w/ animated intro, tool selector, Matrix UI |
| `statghost-cli.sh`         | Menu-based CLI assistant (DNS, email, TLS, AI, logging, etc.) |
| `find_ip_info_batch.sh`    | Batch lookup of DHCP logs by IP/date — subpoena-style trace |
| `dns_query_tool.sh`        | One-click `dig`, `nslookup`, and `host` diagnostic |
| `email_flow_checker.sh`    | IMAP/SMTP flow test for any mailserver |
| `spf_failure_finder.sh`    | Log scan for SPF/DKIM auth failures |
| `spf_spoof_test.sh`        | Simulates spoof attempts to test SPF config |
| `linux_command_trainer.sh` | Interactive Linux CLI quiz with built-in randomness |
| `statghost-log-viewer.sh`  | Visual log parser for usage history (`statghost_usage.log`) |

---

## 🛠 Requirements

- Bash 4+
- Ubuntu / WSL / Debian-based system
- Access to relevant logs (e.g., `/var/log/dhcp.*.gz`)
- Optional tools: `tldr`, `howdoi`, `ollama`, `cheat.sh` (used in assistant menus)

---

## 📦 Quick Start

```bash
git clone https://github.com/ruben9830/statghost-scripts.git
cd statghost-scripts
chmod +x *
./launchpad
```

---

## 🎥 Demo

![StatGhost CLI Demo](https://github.com/ruben9830/statghost-scripts/assets/demo.gif)

*(Optional: add a GIF screen recording here using Peek or asciinema)*

---

## 👤 Author

**Ruben Valencia**  
📍 Georgetown, KY  
🎓 Data Science Masters Student | 🖥️ NOC Technician | 🧠 CLI Wizard  
🔗 [LinkedIn Profile](https://www.linkedin.com/in/rubenvalenciajr)  
💡 *"Automate or die trying."*

---

© 2025 Ruben Valencia  
Licensed under the [MIT License](LICENSE)
