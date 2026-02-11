# Postfix virtual_alias_maps.template
# Virtual alias mappings (sanitized)
# Format: virtual_address real_address
# No real domains or users included

# ------------------------------
# Postmaster & admin aliases
# ------------------------------
postmaster@{{MAIL_DOMAIN}}        $ADMIN_EMAIL
admin@{{MAIL_DOMAIN}}             $ADMIN_EMAIL

# ------------------------------
# Role-based aliases
# ------------------------------
security@{{MAIL_DOMAIN}}          {{SECURITY_EMAIL}}
alerts@{{MAIL_DOMAIN}}            {{ALERTS_EMAIL}}

# ------------------------------
# Catch-all (optional)
# ------------------------------
# @{{MAIL_DOMAIN}}                {{CATCHALL_EMAIL}}

# ------------------------------
# Notes
# ------------------------------
# After deployment, run:
# postmap /etc/postfix/virtual_alias_maps
