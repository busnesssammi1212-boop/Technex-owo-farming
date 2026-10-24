<p align="center">
  <img src="technex-banner.png" alt="Technex" width="700">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/python-3.10%2B-blue?logo=python&logoColor=white" alt="Python 3.10+">
  <img src="https://img.shields.io/badge/license-GPL--3.0-green" alt="GPL-3.0">
  <img src="https://img.shields.io/badge/platform-Windows%20%7C%20Linux-lightgrey" alt="Platform">
</p>

# Technex

Technex is a Python-based automation tool for OwO farming on Discord, with a clean web dashboard that runs locally on your own PC. It handles the repetitive parts of the grind so you can check progress instead of typing commands all day.

## Features

- Auto hunt and battle with human-like timing
- Quest, HuntBot and channel-switch scheduling
- Multi-account support with per-account configuration
- Proxy support for each account
- Live dashboard: balance, uptime, hunts, battles, CPM and an activity chart
- Scheduled Actions panel showing what runs next
- Built-in terminal and history log
- Start, stop and cash controls, responsive on desktop and mobile
- Searchable configuration page with "Save to all accounts"

## Quick start (Windows)

1. Install [Python 3.10+](https://www.python.org/downloads/) (tick **Add Python to PATH**).
2. Download or clone this repository.
3. Double-click **`start_technex.bat`**.
   - First run installs the requirements and creates your dashboard login.
4. Open the local dashboard link shown in the window, sign in, and adjust your settings in the **Configuration** tab.

The default dashboard login is created on first run and stored in `config/auth.json`. **Change the default password**, and never share this file.

## Linux / macOS

```bash
pip install -r requirements.txt
python technex_setup.py --quick
python technex.py
```

## Privacy and safety

- Everything runs on your own machine.
- Your account tokens and dashboard login stay in local files (`config/accounts.json`, `config/auth.json`). They are ignored by Git, so do not upload them anywhere.
- Keep the dashboard on your own PC (`127.0.0.1`) so nobody else on your network can reach it.

## Disclaimer

Automating a Discord user account (a self-bot) is against Discord's Terms of Service, and macros are not allowed under OwO's rules. Accounts can be flagged or banned. Use at your own risk, preferably on an alt account. This project is provided as is, without warranty.

## License

Released under the **GNU General Public License v3.0**. See [`LICENSE`](LICENSE).

Based on NeuraSelf by Routo.
