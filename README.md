
![License](https://img.shields.io/badge/license-MIT-green)
![Repo Size](https://img.shields.io/github/repo-size/ruthviksimha/raspberrypi-local-server)

# Raspberry Pi Local Nextcloud Server Setup

This repository contains scripts and documentation to set up a **local Nextcloud server on Raspberry Pi** with **auto-mounting exFAT USB drives** and **hot-swap support**.

## 📂 Repository Structure
- `README.md` → Main documentation
- `scripts/usb-mount.sh` → Auto-mount script
- `config/99-usb-mount.rules` → Udev rules for hot-swap
- `docs/setup_guide.md` → Detailed setup instructions
- `LICENSE` → Open-source license (MIT)
- `.gitignore` → Ignore unnecessary files

---

## 🚀 Quick Start

1. Flash Raspberry Pi OS (Full).
2. Enable SSH & Wi-Fi, connect via:
   ```bash
   ssh pi@raspberrypi.local
   ```
3. Update & reboot:
   ```bash
   sudo apt update && sudo apt upgrade -y
   sudo reboot
   ```
4. Set up USB auto-mount using provided `usb-mount.sh` & udev rules.
5. Install Nextcloud + Apache + PHP + MariaDB.
6. Configure Nextcloud via browser:  
   - `http://<your-pi-ip>/nextcloud`  
   - or `http://raspberrypi.local/nextcloud`

For full instructions, see [`docs/setup_guide.md`](docs/setup_guide.md).

---

## 🔒 Security Note
This setup is for **local/private use**. For production:
- Remove `*` wildcard from trusted domains.
- Secure Apache with SSL (Let's Encrypt).

---

## 📜 License
This project is licensed under the [MIT License](LICENSE).

