## 🛠️ Troubleshooting Guide — Raspberry Pi Local Server

This guide covers common issues with your Raspberry Pi Nextcloud server and auto-mounting USB drives.

---

### 1. USB Drive Not Auto-Mounting
- **Symptoms:** Drive not appearing in `/media/usbdrive`.  
- **Fixes:**
```bash
sudo chmod +x /usr/local/bin/usb-mount.sh
sudo udevadm control --reload-rules
sudo systemctl daemon-reload
sudo /usr/local/bin/usb-mount.sh add sda1
