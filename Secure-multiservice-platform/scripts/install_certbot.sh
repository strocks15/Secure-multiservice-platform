#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="env/.env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "[ERROR] env/.env not found"
  exit 1
fi

set -a
source "$ENV_FILE"
set +a

if [[ -z "${MAIL_DOMAIN:-}" || -z "${ADMIN_EMAIL:-}" ]]; then
  echo "[ERROR] MAIL_DOMAIN or ADMIN_EMAIL not set"
  exit 1
fi

echo "[+] Installing Certbot..."
apt update
apt install -y certbot

echo "[+] Requesting TLS certificate for $MAIL_DOMAIN..."
certbot certonly \
  --standalone \
  -d "$MAIL_DOMAIN" \
  -m "$ADMIN_EMAIL" \
  --agree-tos \
  --non-interactive

CERT_PATH="/etc/letsencrypt/live/$MAIL_DOMAIN/fullchain.pem"
KEY_PATH="/etc/letsencrypt/live/$MAIL_DOMAIN/privkey.pem"

echo "[✓] Certificate issued"
echo "    Cert: $CERT_PATH"
echo "    Key : $KEY_PATH"

