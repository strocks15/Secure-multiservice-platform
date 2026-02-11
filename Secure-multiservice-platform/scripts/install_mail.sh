#!/usr/bin/env bash
set -euo pipefail

echo "[+] Installing mail stack..."

apt install -y \
  postfix postfix-pcre \
  dovecot-core dovecot-imapd dovecot-pop3d \
  spamassassin spamc   
  
echo "[+] Applying Postfix configuration..."
cp generated-configs/postfix/main.cf /etc/postfix/main.cf
cp generated-configs/postfix/master.cf /etc/postfix/master.cf
cp generated-configs/postfix/virtual_alis_maps /etc/postfix/virtual_alias_maps
postmap /etc/postfix/virtual_alias_maps

echo "[+] Applying Dovecot configuration..."
cp generated-configs/dovecot/dovecot.conf /etc/dovecot/dovecot.conf
cp generated-configs/dovecot/10-auth.conf /etc/dovecot/conf.d/10-auth.conf
cp generated-configs/dovecot/10-mail.conf /etc/dovecot/conf.d/10-mail.conf
cp generated-configs/dovecot/10-ssl.conf /etc/dovecot/conf.d/10-ssl.conf

echo "[+] Applying SpamAssassin configuration..."
cp generated-configs/spamassassin/local.cf /etc/spamassassin/local.cf
cp generated-configs/spamassassin/v310.pre /etc/spamassassin/v310.pre 

echo "[+] Enabling essential services..."
systemctl enable postfix
systemctl enable dovecot
systemctl enable spamassassin
systemctl start spamassassin

echo "[+] Restarting mail services..."
systemctl restart postfix
systemctl restart dovecot
systemctl restart spamassassin

echo "[✓] Mail services installed successfully"

