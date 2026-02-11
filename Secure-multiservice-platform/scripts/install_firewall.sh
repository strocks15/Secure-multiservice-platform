#!/usr/bin/env bash
set -euo pipefail

echo "[+] Installing UFW and PSAD..."
apt install -y ufw psad
echo "[+] Resetting UFW..."   
ufw --force reset
echo "[+] Setting default policies..."
ufw default deny incoming
ufw default allow outgoing
echo "[+] Allowing essential services..."
ufw allow 25/tcp    # SMTP
ufw allow 465/tcp  # SMTPS
ufw allow 587/tcp   # Submission
ufw allow 993/tcp  # IMAPS
ufw allow OpenSSH
ufw allow ssh

echo "[+] Enabling logging..."
sudo ufw logging on

echo "[+] Enabling UFW..."
ufw --force enable

echo "[+] Applying PSAD configuration..."
cp generated-configs/psad/psad.conf /etc/psad/psad.conf
cp generated-configs/ufw/before.rules /etc/ufw/ufw.rules
# PSAD requires iptables logging
sed -i 's/^LOGGING=.*/LOGGING="Y"/' /etc/psad/psad.conf
sudo psad --sig-update
echo "[+] Restarting PSAD..."
systemctl restart psad

echo "[✓] Firewall and IDS Configuration complete."

