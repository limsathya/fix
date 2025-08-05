#!/bin/bash
# fix.sh – Kali optimization for low-end PCs
# Tested on XFCE/LXDE | Author: ChatGPT

echo "[*] Updating system..."
sudo apt update && sudo apt full-upgrade -y

echo "[*] Installing XFCE (lightweight desktop)..."
sudo apt install kali-desktop-xfce -y

echo "[*] Installing LXDE (ultra-light desktop, optional)..."
sudo apt install lxde-core lxde -y

echo "[*] Disabling unnecessary services..."
sudo systemctl disable bluetooth
sudo systemctl disable cups
sudo systemctl disable avahi-daemon
sudo systemctl disable apache2

echo "[*] Installing TLP for battery/CPU optimization..."
sudo apt install tlp -y
sudo systemctl enable tlp
sudo systemctl start tlp

echo "[*] Setting up zRAM for better RAM usage..."

# Create zram script
sudo bash -c 'cat > /usr/local/bin/zram-start <<EOF
#!/bin/bash
modprobe zram
echo lz4 > /sys/block/zram0/comp_algorithm
echo \$(( \$(grep MemTotal /proc/meminfo | awk "{print \$2}") * 1024 / 2 )) > /sys/block/zram0/disksize
mkswap /dev/zram0
swapon /dev/zram0
EOF'

sudo chmod +x /usr/local/bin/zram-start

# Add to crontab for auto-start
(crontab -l 2>/dev/null; echo "@reboot /usr/local/bin/zram-start") | crontab -

# Run zram now
sudo /usr/local/bin/zram-start

echo "[*] Cleaning system..."
sudo apt autoremove --purge -y
sudo apt clean

echo "[✓] Optimization complete!"
echo "👉 On login screen, choose XFCE or LXDE session for best performance."
