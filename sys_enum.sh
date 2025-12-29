#!/usr/bin/env bash
# Post Exploitation Recon Tool – Visual Edition

# ─────────────── COLORS & ICONS ───────────────
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m'

OK='✔'
INFO='ℹ'
WARN='⚠'
ARROW='➜'

# ─────────────── HELPERS ───────────────
run() {
    CMD="$1"
    RES=$(sh -c "$CMD" 2>/dev/null)
    if [ -n "$RES" ]; then
        echo -e "${CYAN}${ARROW}${NC} ${CMD}"
        echo -e "$RES\n"
    fi
}

header() {
    echo -e "\n${BLUE}══════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}${INFO} $1${NC}"
    echo -e "${BLUE}══════════════════════════════════════════════════════${NC}"
}

sub() {
    echo -e "${YELLOW}--- $1 ---${NC}"
}

# ─────────────── SYSTEM INFO ───────────────
header "SYSTEM INFORMATION"
run "hostname"
run "uname -a"
run "cat /etc/*release"
run "whoami"
run "id"
echo -e "${CYAN}PATH:${NC} $PATH"
echo -e "${CYAN}SHELL:${NC} $SHELL"

sub "1) Who has access (and how)?"
run "cat /etc/passwd | grep '/bin/bash'"
run "ls -la /home/*/.ssh/authorized_keys"

sub "3) Are updates being applied (Ubuntu example)?"
run "sudo apt update && sudo apt list --upgradable"

sub "(Extra hardening checks I usually add)"
run "who"
run "w"
run "last -F | head"
run "df -h"
run "uptime"
run "systemctl --failed"
run "ufw status verbose"
run "firewall-cmd --state"
run "iptables -S"
run "journalctl -n 50"

# ─────────────── NETWORK ───────────────
header "NETWORK INFORMATION"
sub "Interfaces"
run "ip a"
run "ifconfig -a"

sub "Routing"
run "ip r"
run "route -n"

sub "Listening Services"
run "ss -tulnp"
run "netstat -tulnp"

sub "ARP"
run "arp -a"

# ─────────────── USERS & PERMS ───────────────
header "USER & PERMISSIONS"
run "groups"
run "sudo -l"
run "crontab -l"
run "ls -la /etc/cron*"

# ─────────────── FILES ───────────────
header "FILES OF INTEREST"
sub "Home"
run "ls -la ~"

sub "SSH"
run "ls -la ~/.ssh"

sub "Root"
run "ls -la /root"

sub "Config Files"
run "find / -type f -name '*.conf' 2>/dev/null | head -n 20"

sub "SUID Files"
run "find / -perm -4000 2>/dev/null"

# ─────────────── BINARIES ───────────────
header "INTERESTING BINARIES"
PROGRAMS="
aws splunk nmap nc ncat netcat wget curl gcc make gdb base64 socat perl php ruby
python python2 python3 docker kubectl ssh apache2 nginx mysql postgres java openssl
"

for p in $PROGRAMS; do
    PPATH=$(command -v "$p" 2>/dev/null)
    [ -n "$PPATH" ] && echo -e "${GREEN}${OK}${NC} $p ${ARROW} $PPATH"
done

# ─────────────── CONTAINERS ───────────────
header "CONTAINER & VIRTUALIZATION"
[ -f "/.dockerenv" ] && echo -e "${WARN} Docker environment detected"
run "cat /proc/1/cgroup"
run "docker ps"
run "systemd-detect-virt"

# ─────────────── ADVANCED ENUM ───────────────
header "ADVANCED ENUMERATION"
sub "Environment"
run "env"

sub "Processes"
run "ps aux | head -n 30"

sub "Mounts"
run "mount"

sub "Disk"
run "df -h"

sub "Kernel Logs"
run "dmesg | tail -n 20"

sub "Loaded Modules"
run "lsmod"

# ─────────────── WRITABLE DIRS ───────────────
header "WRITABLE DIRECTORIES"
run "find / -type d -writable 2>/dev/null | head -n 20"

# ─────────────── CREDS ───────────────
header "CREDENTIAL LEAK HUNT"
run "grep -Ri 'password' /etc 2>/dev/null | head"
run "grep -Ri 'token' /home 2>/dev/null | head"
run "grep -Ri 'api_key' /home 2>/dev/null | head"

# ─────────────── SUDO ───────────────
header "SUDO VERSION"
if command -v sudo >/dev/null 2>&1; then
    VER=$(sudo --version 2>/dev/null | head -n1)
    echo -e "${GREEN}${OK}${NC} $VER"
else
    echo -e "${RED}${WARN}${NC} sudo not installed"
fi

header "DONE"
echo -e "${GREEN}${OK}${NC} Enumeration completed"

