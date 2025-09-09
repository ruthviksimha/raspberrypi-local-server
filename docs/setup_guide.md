# Raspberry Pi Local Server — Setup Guide

This document contains the **full step-by-step guide** for setting up a Raspberry Pi as a Nextcloud server with auto-mounting USB drives.

---

## STEP 1 — Raspberry Pi OS

1. **Flash Raspberry Pi OS (Full)**  
   Use the Raspberry Pi Imager → Choose Raspberry Pi OS (Full) → Flash to your SD card.

   **Notes:**
   - Edit username and password according to your choice.
   - While connecting to SSH, use the credentials you set while flashing the OS.  
     Example:
     ```
     Hostname: raspberrypi
     Username: pi
     Password: admin
     ```

2. **Enable SSH & Wi-Fi**  
   Configure SSH and Wi-Fi before first boot.

3. **Boot Up & Update**  
   Connect via SSH:
   ```bash
   ssh pi@raspberrypi.local
   ```

   Update & reboot:
   ```bash
   sudo apt update && sudo apt upgrade -y
   sudo reboot
   ```

---

## STEP 2 — USB Auto-Mount for exFAT

1. **Install exFAT support:**
   ```bash
   sudo apt install exfat-fuse exfatprogs -y
   ```

2. **Create auto-mount script:**
   ```bash
   sudo nano /usr/local/bin/usb-mount.sh
   ```

   Paste the script from `scripts/usb-mount.sh`.

3. **Create the udev rule:**
   ```bash
   sudo nano /etc/udev/rules.d/99-usb-mount.rules
   ```

   Paste the rules from `config/99-usb-mount.rules`.

4. **Reload & apply:**
   ```bash
   sudo udevadm control --reload-rules
   sudo systemctl daemon-reload
   ```

5. **Test mounting:**
   Plug in an exFAT USB drive and check:
   ```bash
   mount | grep /media
   ```

6. **Fix permissions & add marker:**
   ```bash
   sudo chown -R www-data:www-data /media/usbdrive
   sudo chmod 770 /media/usbdrive
   echo "# Nextcloud data directory" | sudo tee /media/usbdrive/.ncdata
   ```

---

## STEP 3 — Install Nextcloud (Apache + PHP)

1. **Install dependencies:**
   ```bash
   sudo apt install apache2 mariadb-server libapache2-mod-php    php php-mysql php-xml php-curl php-gd php-mbstring php-zip    php-intl php-bcmath php-gmp php-imagick php-cli unzip -y
   ```

2. **Set up MariaDB:**
   ```bash
   sudo mysql -u root
   ```
   Inside the MariaDB prompt:
   ```sql
   CREATE DATABASE nextcloud;
   CREATE USER 'ncuser'@'localhost' IDENTIFIED BY 'ncpwd';
   GRANT ALL PRIVILEGES ON nextcloud.* TO 'ncuser'@'localhost';
   FLUSH PRIVILEGES;
   EXIT;
   ```

3. **Download Nextcloud:**
   ```bash
   cd /var/www/html
   sudo rm index.html
   sudo wget https://download.nextcloud.com/server/releases/latest.zip
   sudo unzip latest.zip
   sudo chown -R www-data:www-data nextcloud
   sudo chmod -R 755 nextcloud
   ```

4. **Configure Apache Virtual Host:**
   ```bash
   sudo nano /etc/apache2/sites-available/nextcloud.conf
   ```
   Paste:
   ```apache
   <VirtualHost *:80>
       DocumentRoot /var/www/html/nextcloud
       ServerName localhost

       <Directory /var/www/html/nextcloud/>
           Require all granted
           AllowOverride All
           Options FollowSymLinks MultiViews
       </Directory>
   </VirtualHost>
   ```

   Enable site & modules:
   ```bash
   sudo a2ensite nextcloud.conf
   sudo a2enmod rewrite headers env dir mime
   sudo systemctl reload apache2
   ```

---

## STEP 4 — Web Setup

1. Open in browser:
   ```
   http://<your-pi-ip>/nextcloud
   http://raspberrypi.local/nextcloud
   ```

2. Create admin:
   - Username: `rick` (or custom)
   - Password: `password` (or custom)
   - Data folder: `/media/usbdrive`
   - DB user: `ncuser`
   - DB password: `ncpwd`
   - DB name: `nextcloud`
   - DB host: `localhost`

---

## STEP 5 — Trusted Domains

1. Find IP:
   ```bash
   hostname -I
   ```

2. Edit config:
   ```bash
   sudo nano /var/www/html/nextcloud/config/config.php
   ```

   Add:
   ```php
   'trusted_domains' => array (
       0 => 'localhost',
       1 => '192.168.x.x',
       2 => 'raspberrypi.local',
       3 => '*',
   ),
   ```

3. Restart Apache:
   ```bash
   sudo systemctl restart apache2
   ```

---

## STEP 6 — Hot-Swap Checklist

1. Plug in → auto-mount.  
2. Reset permissions:  
   ```bash
   sudo chown -R www-data:www-data /media/usbdrive
   sudo chmod 770 /media/usbdrive
   echo "# Nextcloud data directory" | sudo tee /media/usbdrive/.ncdata
   sudo systemctl restart apache2
   ```
3. Only one drive at a time for `/media/usbdrive`.

---

## Optional — User Convenience

Add your user to `www-data` group:
```bash
sudo usermod -aG www-data pi
sudo reboot
```

---

## 👨‍💻 Authors

This project was created as part of a Raspberry Pi local backup server implementation.

- **Ruthvik**  
- **Virinchi**  

---
