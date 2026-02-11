# 🔐 Secure multiservice Platform 

A production-oriented **cybersecurity + infrastructure showcase project** that automates deployment of a hardened: 
- 📬 Mail Server (Postfix + Dovecot + SpamAssassin)
- 🔥 Firewall (UFW)
- 🚨 Intrusion Detection (PSAD)
- 🔐 TLS Automation (Certbot / Let’s Encrypt)
- 🕵️ SSH Honeypot (Cowrie, Supervisor-managed)

Designed with a **security-first, DevOps-aware, recruiter-friendly architecture** — fully modular, automated, and **GitHub-safe**.

---

## 🎯 Project Objective

Most homelab or mail-server projects:

- Hard-code credentials
- Commit real configs (🚨 security risk)
- Ignore threat modeling
- Lack automation or modularity
- Don’t separate configuration from code

This project was built to  answers:

>**“How would you design and deploy secure, auditable, reproducible infrastructure on constrained hardware?”**

This is not just service setup — it is **secure system design**.

---

# 🧱  High-Level Architecture

```
Internet
   |
   |  SMTP / IMAPS / POP3S
   v
+----------------------------+
|        Raspberry Pi        |
|                            |
|  Postfix  <-->  Dovecot    |
|     |              |       |
|     v              v       |
|  SpamAssassin   Mailboxes  |
|                            |
|  UFW Firewall               |
|  PSAD (IDS)                 |
|                            |
|  Cowrie SSH Honeypot        |
|    (Supervisor managed)    |
+----------------------------+
```

---

# 🧩 Core Components

## 📬 Mail Stack

- **Postfix** – SMTP server (TLS enforced)
- **Dovecot** – IMAP/POP3 with SSL
- **SpamAssassin** – Spam filtering (Bayes, DNSBL, Razor, Pyzor)

## 🛡️ Network & Detection

- **UFW** – Host-based firewall with strict allow rules
- **PSAD** – Intrusion detection & port scan alerting

## 🕵️ Honeypot Layer

- **Cowrie** – SSH/Telnet honeypot
- Managed via **Supervisor**
- Captures attacker behavior without exposing real services

## 🔐 Certificate Management

- **Certbot (Let’s Encrypt)** – Automated TLS issuance & renewal

| Component        | Purpose                                   |
| ---------------- | ----------------------------------------- |
| **Postfix**      | SMTP Mail Transfer Agent                  |
| **Dovecot**      | IMAP/POP3 + Authentication                |
| **SpamAssassin** | Spam filtering engine                     |
| **UFW**          | Host-based firewall                       |
| **PSAD**         | Intrusion detection (port scan alerts)    |
| **Cowrie**       | SSH/Telnet honeypot                       |
| **Certbot**      | TLS certificate automation                |
| **Supervisor**   | Service supervision                       |
| **Authbind**     | Privileged port binding without full root |

---
# 🔄 Configuration Strategy

This repository **never commits live configuration files**.

Instead, it follows:

`Templates + Environment Variables → Rendered Runtime Configurations` `

### Why this matters

✔ Prevents secret leakage  
✔ Enables safe public GitHub sharing  
✔ Mirrors real-world DevSecOps practices  
✔ Reproducible infrastructure  
✔ No committed private keys  
✔ Portable across domains  

---
# 🔐 TLS Configuration (Template Example)

TLS certificates are managed using **Certbot**.

Templates reference environment-driven variables:

### Postfix (`main.cf.template`)

`smtpd_tls_cert_file=/etc/letsencrypt/live/$MAIL_DOMAIN/fullchain.pem smtpd_tls_key_file=/etc/letsencrypt/live/$MAIL_DOMAIN/privkey.pem`

### Dovecot (`10-ssl.conf.template`)

`ssl_cert = </etc/letsencrypt/live/$MAIL_DOMAIN/fullchain.pem ssl_key  = </etc/letsencrypt/live/$MAIL_DOMAIN/privkey.pem`

Example `.env`:

`MAIL_DOMAIN=example.com MAIL_HOSTNAME=mail.example.com`

✔ No hardcoded domains  
✔ No committed certificate paths  
✔ Environment-driven security


-----

# 📁 Repository Structure

```
secure-multiservice-platform/
│
├── config/                 # Sanitized configuration templates
│   ├── postfix/
│   ├── dovecot/
│   ├── spamassassin/
│   ├── ufw/
│   ├── psad/
│   ├── cowrie/
│   └── supervisor/
|
├── install_all.sh
├── scripts/                # Modular installers
│   ├── install_mail.sh
│   ├── install_certbot.sh
│   ├── install_firewall.sh
│   ├── install_honeypot.sh
│   └── render-configs.sh
│
├── env/
│   └── .env.example        # Committed (no secrets)
│
├── generated-configs/      # Runtime configs (gitignored)
├── docs/
├── README.md
└── .gitignore
```

---

# ⚙️ Automation Design

| Script                | Purpose                             | Key Components                                                                        |
| --------------------- | ----------------------------------- | ------------------------------------------------------------------------------------- |
| `install_all.sh`      | Full automated bootstrap            | git, supervisor, postfix, dovecot, spamassassin, certbot, authbind, ufw, psad, cowrie |
| `render-configs.sh`   | Template → Runtime config rendering | envsubst,  gettext                                                                    |
| `install_mail.sh`     | Mail server setup                   | Postfix, Dovecot, SpamAssassin                                                        |
| `install_certbot.sh`  | TLS automation                      | Certbot, auto‑renewal                                                                 |
| `install_firewall.sh` | Network protection                  | UFW rules, PSAD IDS                                                                   |
| `install_honeypot.sh` | SSH deception                       | Cowrie + Supervisor                                                                   |


### Design Principles

✔ Modular scripts
✔ Idempotent execution (safe to re‑run)
✔ Clear logging  & failure visibility 
✔ Least-privilege where possible
✔ Separation of concerns  
✔ Update-safe (avoids modifying vendor defaults directly)

---

# 🛡️ Threat Model & Mitigation

| Threat                  | Mitigation                          |
| ----------------------- | ----------------------------------- |
| SMTP spam / relay abuse | Postfix restrictions + SpamAssassin |
| Brute-force SSH         | Cowrie honeypot                     |
| Port scanning           | PSAD alerts                         |
| Unauthorized access     | UFW firewall                        |
| Credential leakage      | Template + `.env` separation        |
| Service crash           | Supervisor                          |

---
# 🧠 Architectural Decisions

### Why Separate Scripts?

- Easier debugging
- Clear security boundaries
- Modular reuse
### Why Authbind?
Allows Postfix to bind privileged ports **without running as full root**.
### Why Supervisor?
Ensures honeypot and background services survive crashes & reboots.
### Why `.env.example`?
- Shows required configuration
- Prevents secrets from leaking
- Demonstrates environment abstraction

---

# 🚀 Installation

### 1️⃣ Clone Repository

`git clone https://github.com/strocks15/Secure-multiservice-platform.git  
cd secure-multiservice-platform`

### 2️⃣ Configure Environment

`cp env/.env.example env/.env`

Edit `.env`  with real values.

### 3️⃣ Run Installer 

`sudo chmod +x scripts/*.sh` 
`sudo chmod +x install_all.sh`
`sudo bash install_all.sh`

---

# 🧪 Tested On

- Raspberry Pi Zero 2 W / Pi 4 / Pi 5
- Debian / Raspberry Pi OS (64-bit)
- NAT + Port forwarding environment
- Bash

---

# 💡 What This Project Demonstrates

✔ Linux system administration
✔ Secure mail architecture
✔ Bash automation at scale
✔ Infrastructure modularization
✔ DevSecOps configuration hygiene
✔ Honeypot deployment & supervision
✔ Production-style infrastructure design
✔ Real-world GitHub hygiene
✔ TLS configuration & automation  
✔ Intrusion detection integration  
✔ Firewall hardening  

This project is intentionally **not containerized** to demonstrate OS-level infrastructure expertise.

---

# 👨‍💻 Who This Project Is For

- Cybersecurity Analyst
- SOC / Blue Team
- DevSecOps Engineer
- Linux System Administrator
- Infrastructure Security Engineer
- Recruiters evaluating **practical security skills**

-----
# 🐝 Honeypot Integration (Cowrie)

Cowrie is **not my original software**.
- This project **integrates Cowrie** using the official repository
- The setup script **automates cloning, configuring, and supervising Cowrie**
- Configuration files are sanitized and safe for public release

> Cowrie Project : https://github.com/cowrie/cowrie
>  No Cowrie source code is redistributed.

No Cowrie source code is redistributed — only automation and configuration.

---

# ⚠️ Disclaimer

This project is for **educational and defensive security purposes only**.   
Not intended for direct production deployment without additional hardeningand monitoring.

---

# 📜 License

MIT License (automation & scripts)  
Cowrie licensed separately by its authors.

---

# 🏁 Final Statement

This repository was built to demonstrate:

> Design, secure, automate, and document real infrastructure — not just make it run.

**Can this person design, secure, and automate real infrastructure?**
**Yes.**
