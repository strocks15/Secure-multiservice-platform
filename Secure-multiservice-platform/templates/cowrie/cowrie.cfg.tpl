# Cowrie cowrie.cfg.template
# SSH/Telnet Honeypot configuration (sanitized)
# No real credentials, IPs, or hostnames included

# ------------------------------
# Core settings
# ------------------------------
[honeypot]
hostname = $COWRIE_HOSTNAME
log_path = $COWRIE_LOG_PATH
download_path = $COWRIE_DOWNLOAD_PATH
state_path = $COWRIE_STATE_PATH

# ------------------------------
# SSH listener (honeypot port)
# ------------------------------
[ssh]
enabled = true
listen_endpoints = tcp:$COWRIE_SSH_PORT:interface=0.0.0.0

# ------------------------------
# Telnet listener (optional)
# ------------------------------
[telnet]
enabled = false

# ------------------------------
# Fake filesystem
# ------------------------------
[fs]
filesystem = share/cowrie/fs.pickle

# ------------------------------
# User authentication (fake)
# ------------------------------
[auth]
enabled = true
auth_class = UserDB
userdb = etc/userdb.txt

# ------------------------------
# Logging
# ------------------------------
[logging]
loggers = cowrie

[logging_cowrie]
level = INFO
handlers = console,file

[handler_file]
class = cowrie.logfile.FileLogger
formatter = cowrie
filename = cowrie.log

# ------------------------------
# Output formats
# ------------------------------
[output_jsonlog]
enabled = true

[output_textlog]
enabled = false

# ------------------------------
# Command & session capture
# ------------------------------
[output_session]
enabled = true

# ------------------------------
# Download capture
# ------------------------------
[output_file]
enabled = true

# ------------------------------
# Resource limits
# ------------------------------
[limits]
max_log_size = 10MB
max_open_sessions = 20
