Linux System Enumeration Script (Post-Exploitation)

No enumeration, no root.
This script is the result of my hands-on learning process in ethical hacking, focused on Linux system enumeration after initial access.

It’s not magic.
It’s not an exploit.
It’s about understanding the system better than the person who configured it.

🎯 What is this script for?

sys_enum.sh automates the tasks I always perform after gaining initial access to a Linux system in order to:

- identify who I am and what permissions I have

- detect dangerous binaries (SUID / sudo)

- discover scripts, cron jobs, and services executed as root

- identify potentially vulnerable versions

- search for exposed credentials

- prepare the ground for privilege escalation

This is a post-exploitation / post-access enumeration script, designed for labs, CTFs, and learning environments.

🔍 What does it enumerate?
🧠 System

- Hostname
- kernel
- Distribution

Current user, groups, PATH, shell
- Users with /bin/bash
- Environment variables

🌐 Network

- Network interfaces and routes
- Listening services
- ARP table and network status

👤 Users & Privileges

- sudo -l
- Cron jobs
- Permissions on /etc/cron*

📁 Critical Files

Home directories, .ssh, /root

- .conf files
- Writable directories
- SUID binaries

⚙️ Interesting Binaries

Automatically detects binaries useful for:

- File transfer
- Command execution
- Compilation
- Container interaction

🐳 Containers / Virtualization

- Docker
- Cgroups
- Systemd virtualization

🔐 Credential Hunting

- Passwords
- Tokens
- Api keys

All with clear, readable, and structured output.

🚀 Usage
chmod +x sys_enum.sh
./sys_enum.sh

Or:

bash sys_enum.sh


⚠️ Recommended to run without sudo first to fully understand the real context of the compromised user.

⚠️ Disclaimer

This script is intended only for controlled environments:

- labs

- CTFs

- Owned systems

- Training and awareness

I am not responsible for any misuse.
