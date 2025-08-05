#!/bin/bash
# fix-all.sh — Complete system fixer & optimizer for low-end Linux

echo "=============================="
echo "🚀 Starting full system repair and optimization..."
echo "=============================="

# 1. Fix broken packages and update
echo "[1] Fixing broken/missing packages..."
sudo dpkg --configure -a
sudo apt --fix-broken install -y
sudo apt update --fix-missing
sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y

# 2. Clean the system
echo "[2] Cleaning up system junk..."
sudo apt autoremove --purge -y
sudo apt clean

# 3. Install lightweight XFCE desktop
echo "[3] Installing XFCE (lightweight desktop)..."
sudo apt install kali-desktop-xfce xfce4 xfce4-goodies -y

# 4. Disable heavy services
echo "[4] Disabling heavy background services..."
for service in bluetooth cups apache2 avahi-daemon; do
  sudo systemctl disable $service
  sudo systemctl stop $service
done

# 5. Install & activate TLP
echo "[5] Installing TLP (CPU & battery optimizer)..."
sudo apt install tlp -y
sudo systemctl enable tlp
sudo systemctl start tlp

# 6. Enable zRAM for better RAM handling
echo "[6] Setting up zRAM..."
sudo bash -c 'cat > /usr/local/bin/zram-start <<EOF
#!/bin/bash
modprobe zram
echo lz4 > /sys/block/zram0/comp_algorithm
echo \$(( \$(grep MemTotal /proc/meminfo | awk "{print \$2}") * 1024 / 2 )) > /sys/block/zram0/disksize
mkswap /dev/zram0
swapon /dev/zram0
EOF'
sudo chmod +x /usr/local/bin/zram-start
sudo /usr/local/bin/zram-start
(crontab -l 2>/dev/null; echo "@reboot /usr/local/bin/zram-start") | crontab -

# 7. Install lightweight daily apps
echo "[7] Installing lightweight apps..."
sudo apt install thunar mousepad xfce4-terminal midori htop -y

# 8. Check filesystem on next boot
echo "[8] Enabling filesystem check..."
sudo touch /forcefsck

# 9. Show completion message
echo "=============================="
echo "✅ All system fixes applied successfully!"
echo "📌 Reboot your laptop now."
echo "💡 On login screen, choose XFCE session for best performance."
echo "=============================="
