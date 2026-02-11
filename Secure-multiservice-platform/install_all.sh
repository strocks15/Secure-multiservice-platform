#!/usr/bin/env bash
set -euo pipefail

echo "[+] Secure Multi-Service Platform Installer"
echo "--------------------------------------------"

# Ensure running as root"
if [[ "$EUID" -ne 0 ]]; then
  echo "[-] Please run as root (sudo)"
  exit 1
fi

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$BASE_DIR/scripts"

echo "[+] Base directory: $BASE_DIR"

echo "[+] Updating system..."
apt update -y
apt upgrade -y
apt-get update -y 

echo "[+] Installing core utilities and dependencies..."
apt install -y \
  git curl wget unzip \
  ca-certificates \
  software-properties-common \
  apt-transport-https \
  python3 python3-pip python3-venv \
  gettext \
  supervisor \
  ufw \
  psad


echo "--------------------------------------------"
echo "[Step 1] Rendering configuration templates..."
bash "$SCRIPTS_DIR/render-configs.sh"

echo "--------------------------------------------"
echo "[Step 2] Installing TLS certificates..."
bash "$SCRIPTS_DIR/install_certbot.sh"

echo "--------------------------------------------"
echo "[Step 3] Installing Mail services..."
bash "$SCRIPTS_DIR/install_mail.sh"

echo "--------------------------------------------"
echo "[Step 4] Configuring Firewall and IDS..."
bash "$SCRIPTS_DIR/install_firewall.sh"
 
echo "--------------------------------------------"
echo "[Step 5] Deploying Honeypot..."
bash "$SCRIPTS_DIR/install_honeypot.sh"

echo "--------------------------------------------"
echo "[✓] All services installed successfully"


