#!/usr/bin/env bash
set -euo pipefail

# --------------------------------------
# Config Renderer
# --------------------------------------
# - Loads a single .env file
# - Substitutes $VAR values into templates
# - Generates production-ready configs
# --------------------------------------

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$BASE_DIR/env/.env"
TEMPLATE_DIR="$BASE_DIR/templates"
OUT_DIR="$BASE_DIR/generated-configs"

# Validate env file
if [[ ! -f "$ENV_FILE" ]]; then
  echo "❌ env/.env not found"
  exit 1
fi

# Export all variables from env
set -a
source "$ENV_FILE"
set +a

# Create output directories
mkdir -p \
  "$OUT_DIR/postfix" \
  "$OUT_DIR/dovecot/conf.d" \
  "$OUT_DIR/spamassassin" \
  "$OUT_DIR/psad" \
  "$OUT_DIR/ufw" \
  "$OUT_DIR/cowrie" \
  "$OUT_DIR/supervisor" 
render() {
  local template="$1"
  local output="$2"

  if [[ ! -f "$template" ]]; then
    echo "❌ Missing template: $template"
    exit 1
  fi

  envsubst < "$template" > "$output"
  echo "✔ Rendered: $output"
}

# ---- Postfix ----
render "$TEMPLATE_DIR/postfix/main.cf.tpl"   "$OUT_DIR/postfix/main.cf"
render "$TEMPLATE_DIR/postfix/master.cf.tpl" "$OUT_DIR/postfix/master.cf"
render "$TEMPLATE_DIR/postfix/virtual_alias_maps.tpl" "$OUT_DIR/postfix/virtual_alias_maps"

# ---- Dovecot ----
render "$TEMPLATE_DIR/dovecot/dovecot.conf.tpl"        "$OUT_DIR/dovecot/dovecot.conf"
render "$TEMPLATE_DIR/dovecot/conf.d/10-ssl.conf.tpl"        "$OUT_DIR/dovecot/conf.d/10-ssl.conf"
render "$TEMPLATE_DIR/dovecot/conf.d/10-mail.conf.tpl"        "$OUT_DIR/dovecot/conf.d/10-mail.conf"
render "$TEMPLATE_DIR/dovecot/conf.d/10-auth.conf.tpl"        "$OUT_DIR/dovecot/conf.d/10-auth.conf"

# ---- Spamassassin ----
render "$TEMPLATE_DIR/spamassassin/local.conf.tpl"        "$OUT_DIR/spamassassin/local.conf"
render "$TEMPLATE_DIR/spamassassin/v310.pre.tpl"        "$OUT_DIR/spamassassin/v310.pre"

# ---- PSAD ----
render "$TEMPLATE_DIR/psad/psad.conf.tpl"        "$OUT_DIR/psad/psad.conf"

# ---- UFW ----
render "$TEMPLATE_DIR/ufw/ufw.rules.tpl"        "$OUT_DIR/ufw/ufw.rules"

# ---- Cowrie ----
render "$TEMPLATE_DIR/cowrie/cowrie.cfg.tpl"        "$OUT_DIR/cowrie/cowrie.cfg"
# ---- Supervisor ----
render "$TEMPLATE_DIR/supervisor/cowrie.conf.tpl"        "$OUT_DIR/supervisor/cowrie.conf"


echo "✅ All configuration files rendered successfully"

