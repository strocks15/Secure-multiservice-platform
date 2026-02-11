#!/usr/bin/env bash

set -euo pipefail

ENV_FILE="env/.env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "[ERROR] env/.env not found"
  exit 1
fi

# Load environment variables
set -a
source "$ENV_FILE"
set +a

echo "[+] Installing Cowrie dependencies..."
apt update
apt install -y \
  git \
  python3 \
  python3-venv \
  python3-pip \
  supervisor \
  libssl-dev \
  libffi-dev \
  gettext

echo "[+] Creating Cowrie user..."
useradd -r -m -d "$COWRIE_HOME" -s /usr/sbin/nologin "$COWRIE_USER" 2>/dev/null || true

echo "[+] Preparing Cowrie directories..."
mkdir -p \
  "$COWRIE_LOG_PATH" \
  "$COWRIE_STATE_PATH" \
  "$COWRIE_DOWNLOAD_PATH"

chown -R "$COWRIE_USER:$COWRIE_USER" "$COWRIE_HOME"

if [[ ! -d "$COWRIE_BASE_PATH/.git" ]]; then
  echo "[+] Cloning Cowrie..."
  git clone https://github.com/cowrie/cowrie.git "$COWRIE_BASE_PATH"
fi

echo "[+] Setting up Python virtual environment..."
python3 -m venv "$COWRIE_VENV_PATH"
"$COWRIE_VENV_PATH/bin/pip" install --upgrade pip
"$COWRIE_VENV_PATH/bin/pip" install -r "$COWRIE_BASE_PATH/requirements.txt"

echo "[+] Applying Cowrie configuration..."
cp generated-configs/cowrie/cowrie.cfg "$COWRIE_BASE_PATH/etc/cowrie.cfg"
chown "$COWRIE_USER:$COWRIE_USER" "$COWRIE_BASE_PATH/etc/cowrie.cfg"

echo "[+] Configuring Supervisor..."
cp generated-configs/supervisor/cowrie.conf /etc/supervisor/conf.d/cowrie.conf

supervisorctl reread
supervisorctl update
supervisorctl restart cowrie || supervisorctl start cowrie

echo "[✓] Cowrie honeypot deployed successfully."


