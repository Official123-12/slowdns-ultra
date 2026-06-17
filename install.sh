#!/bin/bash

##############################################
# SlowDNS Manager - ULTIMATE EDITION
# Created By STANYTZ
# Version: 11.0.0 - COMPLETE IMPROVED
# Optimized for Halotel Tanzania - Speed 2+ Mbps
##############################################

# Colors - Enhanced for better UI
R='\033[0;31m' G='\033[0;32m' Y='\033[1;33m' C='\033[0;36m' W='\033[1;37m' B='\033[0;34m' M='\033[0;35m' N='\033[0m'
BOLD='\033[1m' DIM='\033[2m' ITALIC='\033[3m' BLINK='\033[5m'

# UI Elements
LINE="${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}"
DOUBLE_LINE="${C}════════════════════════════════════════════════════════════════════════════════════${N}"
TITLE_LINE="${Y}────────────────────────────────────────────────────────────────────────────────────${N}"

#============================================
# CONFIGURATION
#============================================
CONFIG_DIR="/etc/slowdns"
CONFIG_FILE="${CONFIG_DIR}/config.conf"
LOG_DIR="/var/log/slowdns"
LOG_FILE="${LOG_DIR}/slowdns.log"
PID_DIR="/var/run/slowdns"
PID_FILE="${PID_DIR}/slowdns.pid"
DNS_LIST="${CONFIG_DIR}/dns_servers.txt"
USER_LIST="${CONFIG_DIR}/users.txt"

# Default Settings
DNSTT_PORT=5300
DNS_PORT=53
MAX_SPEED=2048
AUTO_START=true
ENABLE_LOGGING=true

# Halotel Tanzania DNS Servers
HALOTEL_NS=(
    "154.70.103.17"
    "154.70.103.18" 
    "154.70.64.2"
    "8.8.8.8"
    "1.1.1.1"
    "9.9.9.9"
    "208.67.222.222"
)

#============================================
# BANNER - ENHANCED UI
#============================================
banner() {
    clear
    echo -e "${C}"
    cat << "BAN"
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║    ███████╗██╗      ██████╗ ██╗    ██╗██████╗ ███╗   ██╗███████╗           ║
║    ██╔════╝██║     ██╔═══██╗██║    ██║██╔══██╗████╗  ██║██╔════╝           ║
║    ███████╗██║     ██║   ██║██║ █╗ ██║██║  ██║██╔██╗ ██║███████╗           ║
║    ╚════██║██║     ██║   ██║██║███╗██║██║  ██║██║╚██╗██║╚════██║           ║
║    ███████║███████╗╚██████╔╝╚███╔███╔╝██████╔╝██║ ╚████║███████║           ║
║    ╚══════╝╚══════╝ ╚═════╝  ╚══╝╚══╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝           ║
║                                                                              ║
║              ██████╗ ███████╗██╗   ██╗██╗██╗     ███████╗██████╗            ║
║              ██╔══██╗██╔════╝╚██╗ ██╔╝██║██║     ██╔════╝██╔══██╗           ║
║              ██║  ██║█████╗   ╚████╔╝ ██║██║     █████╗  ██████╔╝           ║
║              ██║  ██║██╔══╝    ╚██╔╝  ██║██║     ██╔══╝  ██╔══██╗           ║
║              ██████╔╝███████╗   ██║   ██║███████╗███████╗██║  ██║           ║
║              ╚═════╝ ╚══════╝   ╚═╝   ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝           ║
║                                                                              ║
║          ╔═══════════════════════════════════════════════════════════╗        ║
║          ║  🚀 SLOWDNS MANAGER - ULTIMATE EDITION  🚀              ║        ║
║          ║         ⚡ SPEED: 2+ Mbps ⚡                           ║        ║
║          ║         📡 NETWORK: HALOTEL TANZANIA 📡              ║        ║
║          ╚═══════════════════════════════════════════════════════════╝        ║
║                                                                              ║
║                      CREATED BY STANYTZ - Official123-12                    ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
BAN
    echo -e "${N}"
}

#============================================
# BOXED TEXT FUNCTIONS - IMPROVED UI
#============================================
box_title() {
    local text="$1"
    local len=${#text}
    local padding=$(( (70 - len) / 2 ))
    echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
    printf "${C}│${N}%*s${BOLD}${Y}${text}${N}%*s${C}│${N}\n" $padding "" $(( 70 - len - padding )) ""
    echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
}

box_info() {
    local label="$1"
    local value="$2"
    printf "${C}│${N} ${W}%-20s${N} : ${G}%-45s${N} ${C}│${N}\n" "$label" "$value"
}

box_status() {
    local label="$1"
    local status="$2"
    local color=""
    [[ "$status" == "RUNNING" ]] && color="${G}" || color="${R}"
    printf "${C}│${N} ${W}%-20s${N} : ${color}%-45s${N} ${C}│${N}\n" "$label" "$status"
}

box_separator() {
    echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
}

#============================================
# HEADER/FOOTER - IMPROVED UI
#============================================
print_header() {
    echo -e "${C}"
    echo "╔══════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                          ║"
    printf "║  %-70s ║\n" "${BOLD}${W}$1${N}"
    echo "║                                                                          ║"
    echo "╚══════════════════════════════════════════════════════════════════════════╝"
    echo -e "${N}"
}

print_footer() {
    echo -e "${DIM}${C}────────────────────────────────────────────────────────────────────────${N}"
}

#============================================
# PROGRESS BAR - IMPROVED UI
#============================================
show_progress() {
    local current=$1
    local total=$2
    local percent=$((current * 100 / total))
    local filled=$((percent / 2))
    local empty=$((50 - filled))
    
    printf "\r${C}[${N}"
    printf "%${filled}s" | tr ' ' '█'
    printf "%${empty}s" | tr ' ' '░'
    printf "${C}]${N} ${G}%3d%%${N}" "$percent"
}

#============================================
# CHECK ROOT
#============================================
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${R}╔══════════════════════════════════════════════════════════════════════════╗${N}"
        echo -e "${R}║                                                                          ║${N}"
        echo -e "${R}║  ✗ ERROR: ROOT PRIVILEGES REQUIRED                                     ║${N}"
        echo -e "${R}║                                                                          ║${N}"
        echo -e "${R}║  ➜ Run: ${W}sudo $0${N}${R}                                                      ║${N}"
        echo -e "${R}║                                                                          ║${N}"
        echo -e "${R}╚══════════════════════════════════════════════════════════════════════════╝${N}"
        exit 1
    fi
}

#============================================
# INITIALIZE SYSTEM
#============================================
init_system() {
    mkdir -p "$CONFIG_DIR" "$LOG_DIR" "$PID_DIR" 2>/dev/null
    
    if [[ ! -f "$CONFIG_FILE" ]]; then
        cat > "$CONFIG_FILE" << EOF
# SlowDNS Configuration - Ultimate Edition
# Created: $(date)
# Network: Halotel Tanzania

# Server Settings
DNSTT_PORT=${DNSTT_PORT}
DNS_PORT=${DNS_PORT}
MAX_SPEED=${MAX_SPEED}
AUTO_START=${AUTO_START}
ENABLE_LOGGING=${ENABLE_LOGGING}

# Network Optimization
TCP_CONGESTION="bbr"
MTU="1400"
UDP_BUFFER="134217728"
TCP_BUFFER="134217728"

# DNS Settings
PRIMARY_DNS="${HALOTEL_NS[0]}"
SECONDARY_DNS="${HALOTEL_NS[1]}"
BACKUP_DNS="8.8.8.8"

# Security
ENABLE_FIREWALL=true
ALLOWED_PORTS="${DNSTT_PORT},${DNS_PORT}"

# Generated: $(date +%Y-%m-%d_%H:%M:%S)
EOF
    fi
    
    if [[ ! -f "$DNS_LIST" ]]; then
        printf "%s\n" "${HALOTEL_NS[@]}" > "$DNS_LIST"
    fi
    
    if [[ ! -f "$USER_LIST" ]]; then
        touch "$USER_LIST"
    fi
    
    source "$CONFIG_FILE" 2>/dev/null
}

#============================================
# CHECK DEPENDENCIES - IMPROVED UI
#============================================
check_deps() {
    echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
    echo -e "${C}│${N}  ${BOLD}${Y}📦 CHECKING DEPENDENCIES${N}                                        ${C}│${N}"
    echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
    
    local deps=("wget" "curl" "openssl" "screen" "net-tools" "bc" "dnsutils" "iptables" "systemctl")
    local missing=()
    local total=${#deps[@]}
    local count=0
    
    for dep in "${deps[@]}"; do
        count=$((count + 1))
        show_progress $count $total
        if ! command -v "$dep" &>/dev/null; then
            missing+=("$dep")
        fi
    done
    echo ""
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
        echo -e "${C}│${N}  ${Y}⚡ Installing: ${W}${missing[*]}${N}                                      ${C}│${N}"
        
        if command -v apt &>/dev/null; then
            apt update -qq 2>/dev/null
            apt install -y "${missing[@]}" -qq 2>/dev/null
        elif command -v apt-get &>/dev/null; then
            apt-get update -qq 2>/dev/null
            apt-get install -y "${missing[@]}" -qq 2>/dev/null
        elif command -v yum &>/dev/null; then
            yum install -y "${missing[@]}" -q 2>/dev/null
        elif command -v dnf &>/dev/null; then
            dnf install -y "${missing[@]}" -q 2>/dev/null
        elif command -v pacman &>/dev/null; then
            pacman -S --noconfirm "${missing[@]}" 2>/dev/null
        else
            echo -e "${C}│${N}  ${R}✗ Cannot install dependencies${N}                                      ${C}│${N}"
            echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
            exit 1
        fi
    fi
    
    echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
    echo -e "${C}│${N}  ${G}✅ All dependencies installed successfully${N}                              ${C}│${N}"
    echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
    echo ""
}

#============================================
# NETWORK OPTIMIZATION - IMPROVED UI
#============================================
optimize_network() {
    echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
    echo -e "${C}│${N}  ${BOLD}${Y}🔧 NETWORK OPTIMIZATION - HALOTEL${N}                                ${C}│${N}"
    echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
    
    # TCP Optimization
    echo -e "${C}│${N}  ${W}➜ TCP BBR Optimization${N}                                               ${C}│${N}"
    modprobe tcp_bbr 2>/dev/null
    
    cat > /etc/sysctl.d/99-slowdns.conf << EOF
# SlowDNS Ultimate Network Optimization
# Optimized for Halotel Tanzania

# TCP Settings
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.core.rmem_default = 16777216
net.core.wmem_default = 16777216
net.ipv4.tcp_rmem = 4096 87380 134217728
net.ipv4.tcp_wmem = 4096 65536 134217728
net.core.netdev_max_backlog = 5000
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_congestion_control = bbr
net.core.default_qdisc = fq
net.ipv4.tcp_notsent_lowat = 16384
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_keepalive_intvl = 15
net.ipv4.ip_forward = 1

# UDP Settings
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728

# Security
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.tcp_syncookies = 1
EOF
    
    sysctl -p /etc/sysctl.d/99-slowdns.conf 2>/dev/null
    
    # MTU Optimization
    echo -e "${C}│${N}  ${W}➜ MTU Optimization${N}                                                 ${C}│${N}"
    local IFACE=$(ip route | grep default | awk '{print $5}' | head -1)
    [[ -n "$IFACE" ]] && ip link set dev "$IFACE" mtu 1400 2>/dev/null
    
    # DNS Optimization
    echo -e "${C}│${N}  ${W}➜ DNS Optimization${N}                                                 ${C}│${N}"
    echo "nameserver 154.70.103.17" > /etc/resolv.conf
    echo "nameserver 154.70.103.18" >> /etc/resolv.conf
    echo "nameserver 8.8.8.8" >> /etc/resolv.conf
    
    # Firewall Optimization
    echo -e "${C}│${N}  ${W}➜ Firewall Optimization${N}                                            ${C}│${N}"
    iptables -I INPUT -p udp --dport ${DNSTT_PORT} -j ACCEPT 2>/dev/null
    iptables -I INPUT -p tcp --dport ${DNS_PORT} -j ACCEPT 2>/dev/null
    
    echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
    echo -e "${C}│${N}  ${G}✅ Network optimization complete${N}                                     ${C}│${N}"
    echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
    echo ""
}

#============================================
# INSTALL DNSTT - IMPROVED UI
#============================================
install_dnstt() {
    echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
    echo -e "${C}│${N}  ${BOLD}${Y}📥 INSTALLING DNSTT${N}                                              ${C}│${N}"
    echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
    
    local ARCH=$(uname -m)
    local DNSTT_URL=""
    
    case "$ARCH" in
        x86_64)
            DNSTT_URL="https://github.com/Official123-12/slowdns-manager/releases/latest/download/dnstt_linux_amd64"
            ;;
        aarch64)
            DNSTT_URL="https://github.com/Official123-12/slowdns-manager/releases/latest/download/dnstt_linux_arm64"
            ;;
        armv7l|armv6l)
            DNSTT_URL="https://github.com/Official123-12/slowdns-manager/releases/latest/download/dnstt_linux_arm"
            ;;
        *)
            DNSTT_URL="https://github.com/Official123-12/slowdns-manager/releases/latest/download/dnstt_linux_386"
            ;;
    esac
    
    echo -e "${C}│${N}  ${W}➜ Downloading DNSTT for ${C}$ARCH${N}                                     ${C}│${N}"
    wget -q --show-progress -O /usr/local/bin/dnstt "$DNSTT_URL" 2>/dev/null
    chmod +x /usr/local/bin/dnstt
    
    echo -e "${C}│${N}  ${W}➜ Generating encryption keys${N}                                         ${C}│${N}"
    /usr/local/bin/dnstt -gen-key > "${CONFIG_DIR}/keys.txt" 2>/dev/null
    
    PUBLIC_KEY=$(grep "Public" "${CONFIG_DIR}/keys.txt" | awk '{print $3}')
    PRIVATE_KEY=$(grep "Private" "${CONFIG_DIR}/keys.txt" | awk '{print $3}')
    
    sed -i "s/^PUBLIC_KEY=.*/PUBLIC_KEY=\"${PUBLIC_KEY}\"/" "$CONFIG_FILE" 2>/dev/null
    sed -i "s/^PRIVATE_KEY=.*/PRIVATE_KEY=\"${PRIVATE_KEY}\"/" "$CONFIG_FILE" 2>/dev/null
    
    echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
    echo -e "${C}│${N}  ${G}✅ DNSTT installed successfully${N}                                     ${C}│${N}"
    echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
    echo ""
}

#============================================
# CREATE SERVICE - IMPROVED UI
#============================================
create_service() {
    echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
    echo -e "${C}│${N}  ${BOLD}${Y}⚡ CREATING SYSTEM SERVICE${N}                                       ${C}│${N}"
    echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
    
    cat > /etc/systemd/system/slowdns.service << EOF
[Unit]
Description=SlowDNS Service - Halotel Optimized
After=network.target
Wants=network-online.target

[Service]
Type=simple
User=root
WorkingDirectory=${CONFIG_DIR}
Environment="PUBLIC_KEY=${PUBLIC_KEY}"
Environment="PRIVATE_KEY=${PRIVATE_KEY}"
ExecStartPre=/bin/sleep 5
ExecStart=/usr/local/bin/dnstt -run ${PRIVATE_KEY} -pub ${PUBLIC_KEY} -udp :${DNSTT_PORT} -tcp 127.0.0.1:${DNS_PORT}
Restart=always
RestartSec=10
StartLimitInterval=0
StandardOutput=append:${LOG_FILE}
StandardError=append:${LOG_FILE}

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload 2>/dev/null
    systemctl enable slowdns 2>/dev/null
    
    echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
    echo -e "${C}│${N}  ${G}✅ Service created successfully${N}                                      ${C}│${N}"
    echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
    echo ""
}

#============================================
# START SERVICE - IMPROVED UI
#============================================
start_service() {
    echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
    echo -e "${C}│${N}  ${BOLD}${G}▶ STARTING SLOWDNS SERVICE${N}                                        ${C}│${N}"
    echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
    
    if systemctl start slowdns 2>/dev/null; then
        sleep 2
    else
        screen -dmS slowdns /usr/local/bin/dnstt -run ${PRIVATE_KEY} -pub ${PUBLIC_KEY} -udp :${DNSTT_PORT} -tcp 127.0.0.1:${DNS_PORT}
    fi
    
    sleep 2
    
    if pgrep -f "dnstt" > /dev/null; then
        local PID=$(pgrep -f dnstt | head -1)
        echo "$PID" > "$PID_FILE"
        
        echo -e "${C}│${N}                                                                      ${C}│${N}"
        echo -e "${C}│${N}  ${G}✅ SERVICE IS RUNNING${N}                                              ${C}│${N}"
        echo -e "${C}│${N}                                                                      ${C}│${N}"
        echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
        echo -e "${C}│${N}  ${W}📊 Status     : ${G}ACTIVE${N}                                               ${C}│${N}"
        echo -e "${C}│${N}  ${W}🔢 PID        : ${C}${PID}${N}                                                ${C}│${N}"
        echo -e "${C}│${N}  ${W}🔌 Port      : ${C}${DNSTT_PORT}${N}                                              ${C}│${N}"
        echo -e "${C}│${N}  ${W}🔑 Public Key: ${Y}${PUBLIC_KEY}${N}                                     ${C}│${N}"
        echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
        echo -e "${C}│${N}                                                                      ${C}│${N}"
        echo -e "${C}│${N}  ${Y}📱 CLIENT CONFIGURATION:${N}                                             ${C}│${N}"
        echo -e "${C}│${N}     ${W}Server     : ${C}$(curl -s ifconfig.me 2>/dev/null || echo 'YOUR_IP')${N}     ${C}│${N}"
        echo -e "${C}│${N}     ${W}Port      : ${C}${DNSTT_PORT}${N}                                              ${C}│${N}"
        echo -e "${C}│${N}     ${W}Public Key: ${Y}${PUBLIC_KEY}${N}                                     ${C}│${N}"
        echo -e "${C}│${N}                                                                      ${C}│${N}"
        echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
        echo -e "${C}│${N}  ${G}⚡ EXPECTED SPEED: 2+ Mbps on Halotel${N}                             ${C}│${N}"
        echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
        echo ""
        
        echo "$(date): Service started" >> "$LOG_FILE"
    else
        echo -e "${C}│${N}  ${R}✗ Failed to start service${N}                                          ${C}│${N}"
        echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
        echo "$(date): Failed to start service" >> "$LOG_FILE"
    fi
}

#============================================
# STOP SERVICE - IMPROVED UI
#============================================
stop_service() {
    echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
    echo -e "${C}│${N}  ${BOLD}${Y}⏹ STOPPING SLOWDNS SERVICE${N}                                        ${C}│${N}"
    echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
    
    systemctl stop slowdns 2>/dev/null
    pkill -f "dnstt" 2>/dev/null
    rm -f "$PID_FILE"
    
    echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
    echo -e "${C}│${N}  ${G}✅ Service stopped${N}                                                 ${C}│${N}"
    echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
    echo ""
    echo "$(date): Service stopped" >> "$LOG_FILE"
}

#============================================
# RESTART SERVICE - IMPROVED UI
#============================================
restart_service() {
    echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
    echo -e "${C}│${N}  ${BOLD}${Y}🔄 RESTARTING SLOWDNS SERVICE${N}                                      ${C}│${N}"
    echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
    
    stop_service
    sleep 2
    start_service
}

#============================================
# SERVICE STATUS - IMPROVED UI
#============================================
service_status() {
    banner
    echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
    echo -e "${C}│${N}  ${BOLD}${C}📊 SERVICE STATUS${N}                                                ${C}│${N}"
    echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
    
    if pgrep -f "dnstt" > /dev/null; then
        local PID=$(pgrep -f dnstt | head -1)
        local UPTIME=$(ps -p "$PID" -o etime= 2>/dev/null | xargs)
        local CPU=$(ps -p "$PID" -o %cpu= 2>/dev/null | xargs)
        local MEM=$(ps -p "$PID" -o %mem= 2>/dev/null | xargs)
        
        echo -e "${C}│${N}  ${G}● STATUS: RUNNING${N}                                                ${C}│${N}"
        echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
        echo -e "${C}│${N}  ${W}🔢 PID        : ${C}${PID}${N}                                                ${C}│${N}"
        echo -e "${C}│${N}  ${W}⏱️  Uptime     : ${C}${UPTIME:-N/A}${N}                                               ${C}│${N}"
        echo -e "${C}│${N}  ${W}💻 CPU        : ${C}${CPU:-0}%${N}                                                ${C}│${N}"
        echo -e "${C}│${N}  ${W}🧠 Memory    : ${C}${MEM:-0}%${N}                                               ${C}│${N}"
        echo -e "${C}│${N}  ${W}🔌 Port      : ${C}${DNSTT_PORT}${N}                                              ${C}│${N}"
        echo -e "${C}│${N}  ${W}🔑 Public Key: ${Y}${PUBLIC_KEY:0:30}...${N}                                  ${C}│${N}"
        echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
        echo -e "${C}│${N}  ${BOLD}${C}📈 SPEED TEST${N}                                                  ${C}│${N}"
        echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
        
        if command -v speedtest-cli &>/dev/null; then
            speedtest-cli --simple 2>/dev/null | while read line; do
                echo -e "${C}│${N}  ${G}${line}${N}                                                  ${C}│${N}"
            done
        else
            local START=$(date +%s%N)
            curl -s -o /dev/null --max-time 5 https://speedtest.net 2>/dev/null
            local END=$(date +%s%N)
            local TIME=$((($END - $START) / 1000000000))
            
            if [[ $TIME -gt 0 ]]; then
                local SPEED=$(echo "scale=2; 100 / $TIME" | bc 2>/dev/null)
                echo -e "${C}│${N}  ${G}Download Speed: ${SPEED:-0} Mbps${N}                                    ${C}│${N}"
            else
                echo -e "${C}│${N}  ${Y}Speed test not available${N}                                       ${C}│${N}"
            fi
        fi
    else
        echo -e "${C}│${N}  ${R}● STATUS: STOPPED${N}                                                ${C}│${N}"
    fi
    
    echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
    echo ""
    read -p "  Press Enter to continue..."
}

#============================================
# SPEED MONITOR - IMPROVED UI
#============================================
speed_monitor() {
    banner
    echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
    echo -e "${C}│${N}  ${BOLD}${C}📊 REAL-TIME SPEED MONITOR${N}                                       ${C}│${N}"
    echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
    echo -e "${C}│${N}  ${Y}Press Ctrl+C to stop monitoring${N}                                      ${C}│${N}"
    echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
    echo -e "${C}│${N}                                                                      ${C}│${N}"
    
    local IFACE=$(ip route | grep default | awk '{print $5}' | head -1)
    
    if [[ -z "$IFACE" ]]; then
        echo -e "${C}│${N}  ${R}✗ No network interface found${N}                                      ${C}│${N}"
        echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
        read -p "  Press Enter to continue..."
        return
    fi
    
    echo -e "${C}│${N}  ${W}Interface: ${C}${IFACE}${N}                                                    ${C}│${N}"
    echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
    echo -e "${C}│${N}                                                                      ${C}│${N}"
    
    while true; do
        local RX1=$(cat /sys/class/net/$IFACE/statistics/rx_bytes 2>/dev/null)
        local TX1=$(cat /sys/class/net/$IFACE/statistics/tx_bytes 2>/dev/null)
        
        sleep 1
        
        local RX2=$(cat /sys/class/net/$IFACE/statistics/rx_bytes 2>/dev/null)
        local TX2=$(cat /sys/class/net/$IFACE/statistics/tx_bytes 2>/dev/null)
        
        local DOWN=$(echo "scale=2; ($RX2 - $RX1) / 1024 / 1024" | bc 2>/dev/null)
        local UP=$(echo "scale=2; ($TX2 - $TX1) / 1024 / 1024" | bc 2>/dev/null)
        
        printf "\r${C}│${N}  ${W}📥 Download: ${G}%6.2f Mbps${N}  ${W}📤 Upload: ${C}%6.2f Mbps${N}  ${W}🎯 Target: ${G}2+ Mbps${N}  ${C}│${N}" "$DOWN" "$UP"
    done
}

#============================================
# MANAGE USERS - IMPROVED UI
#============================================
manage_users() {
    while true; do
        banner
        echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
        echo -e "${C}│${N}  ${BOLD}${C}👥 USER MANAGEMENT${N}                                              ${C}│${N}"
        echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
        echo -e "${C}│${N}  ${W}1)${G} ➕ Add user${N}                                                        ${C}│${N}"
        echo -e "${C}│${N}  ${W}2)${R} ➖ Remove user${N}                                                      ${C}│${N}"
        echo -e "${C}│${N}  ${W}3)${C} 📋 List users${N}                                                       ${C}│${N}"
        echo -e "${C}│${N}  ${W}4)${Y} ↩️  Back to menu${N}                                                     ${C}│${N}"
        echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
        echo ""
        read -p "  Select option: " opt
        
        case $opt in
            1)
                echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
                echo -e "${C}│${N}  ${BOLD}${G}➕ ADD NEW USER${N}                                                 ${C}│${N}"
                echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
                read -p "  ${W}Username: ${N}" username
                read -p "  ${W}Max Speed (Mbps): ${N}" speed
                
                local password=$(openssl rand -base64 12)
                echo "${username}:${password}:${speed}" >> "$USER_LIST"
                
                echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
                echo -e "${C}│${N}  ${G}✅ User added successfully${N}                                         ${C}│${N}"
                echo -e "${C}│${N}  ${W}Username: ${C}${username}${N}                                                  ${C}│${N}"
                echo -e "${C}│${N}  ${W}Password: ${Y}${password}${N}                                                  ${C}│${N}"
                echo -e "${C}│${N}  ${W}Speed   : ${G}${speed} Mbps${N}                                                ${C}│${N}"
                echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
                ;;
            2)
                echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
                echo -e "${C}│${N}  ${BOLD}${R}➖ REMOVE USER${N}                                                 ${C}│${N}"
                echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
                read -p "  ${W}Username to remove: ${N}" username
                sed -i "/^${username}:/d" "$USER_LIST"
                echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
                echo -e "${C}│${N}  ${G}✅ User removed${N}                                                  ${C}│${N}"
                echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
                ;;
            3)
                echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
                echo -e "${C}│${N}  ${BOLD}${C}📋 USER LIST${N}                                                   ${C}│${N}"
                echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
                if [[ -s "$USER_LIST" ]]; then
                    cat "$USER_LIST" | while IFS=':' read -r user pass speed; do
                        printf "${C}│${N}  ${W}User: ${C}%-15s${N}  ${W}Pass: ${Y}%-15s${N}  ${W}Speed: ${G}%s Mbps${N}     ${C}│${N}\n" "$user" "$pass" "$speed"
                    done
                else
                    echo -e "${C}│${N}  ${Y}No users configured${N}                                            ${C}│${N}"
                fi
                echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
                ;;
            4)
                return
                ;;
            *)
                echo -e "${R}✗ Invalid option${N}"
                ;;
        esac
        echo ""
        read -p "  Press Enter to continue..."
    done
}

#============================================
# VIEW LOGS - IMPROVED UI
#============================================
view_logs() {
    banner
    echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
    echo -e "${C}│${N}  ${BOLD}${C}📋 SYSTEM LOGS${N}                                                   ${C}│${N}"
    echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
    
    if [[ -f "$LOG_FILE" ]]; then
        tail -30 "$LOG_FILE" | while read line; do
            echo -e "${C}│${N}  ${DIM}${line}${N}${C}│${N}"
        done
    else
        echo -e "${C}│${N}  ${Y}No logs found${N}                                                  ${C}│${N}"
    fi
    
    echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
    echo ""
    read -p "  Press Enter to continue..."
}

#============================================
# NETWORK INFO - IMPROVED UI
#============================================
network_info() {
    banner
    echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
    echo -e "${C}│${N}  ${BOLD}${C}🌐 NETWORK INFORMATION${N}                                             ${C}│${N}"
    echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
    echo -e "${C}│${N}  ${W}Interface     : ${C}$(ip route | grep default | awk '{print $5}' | head -1)${N}              ${C}│${N}"
    echo -e "${C}│${N}  ${W}IP Address    : ${C}$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127.0.0.1 | head -1)${N}              ${C}│${N}"
    echo -e "${C}│${N}  ${W}Public IP     : ${C}$(curl -s ifconfig.me 2>/dev/null || echo 'N/A')${N}              ${C}│${N}"
    echo -e "${C}│${N}  ${W}DNS Server    : ${C}$(cat /etc/resolv.conf | grep nameserver | head -1 | awk '{print $2}')${N}              ${C}│${N}"
    echo -e "${C}│${N}  ${W}MTU           : ${C}$(ip link show | grep mtu | head -1 | awk '{print $5}')${N}              ${C}│${N}"
    echo -e "${C}│${N}  ${W}TCP Congestion: ${C}$(sysctl net.ipv4.tcp_congestion_control | awk '{print $3}')${N}              ${C}│${N}"
    echo -e "${C}│${N}  ${W}Network       : ${C}Halotel Tanzania${N}                                       ${C}│${N}"
    echo -e "${C}│${N}  ${W}Speed Target  : ${G}2+ Mbps${N}                                                ${C}│${N}"
    echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
    echo ""
    read -p "  Press Enter to continue..."
}

#============================================
# UNINSTALL - IMPROVED UI
#============================================
uninstall() {
    banner
    echo -e "${R}┌──────────────────────────────────────────────────────────────────────┐${N}"
    echo -e "${R}│${N}  ${BOLD}${R}🗑️  UNINSTALL SLOWDNS${N}                                             ${R}│${N}"
    echo -e "${R}├──────────────────────────────────────────────────────────────────────┤${N}"
    echo -e "${R}│${N}  ${Y}⚠️  WARNING: This will remove:${N}                                      ${R}│${N}"
    echo -e "${R}│${N}     ${W}• DNSTT binary${N}                                                       ${R}│${N}"
    echo -e "${R}│${N}     ${W}• Configuration files${N}                                                ${R}│${N}"
    echo -e "${R}│${N}     ${W}• Log files${N}                                                          ${R}│${N}"
    echo -e "${R}│${N}     ${W}• System service${N}                                                     ${R}│${N}"
    echo -e "${R}└──────────────────────────────────────────────────────────────────────┘${N}"
    echo ""
    read -p "  Are you sure? (y/n): " confirm
    
    if [[ "$confirm" == "y" ]] || [[ "$confirm" == "Y" ]]; then
        echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
        echo -e "${C}│${N}  ${Y}⏳ Uninstalling...${N}                                               ${C}│${N}"
        echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
        
        stop_service
        systemctl disable slowdns 2>/dev/null
        rm -f /usr/local/bin/dnstt
        rm -f /etc/systemd/system/slowdns.service
        rm -rf "$CONFIG_DIR" "$LOG_DIR" "$PID_DIR"
        rm -f /etc/sysctl.d/99-slowdns.conf
        
        echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
        echo -e "${C}│${N}  ${G}✅ Uninstall complete${N}                                              ${C}│${N}"
        echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
        exit 0
    else
        echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
        echo -e "${C}│${N}  ${Y}Uninstall cancelled${N}                                              ${C}│${N}"
        echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
        read -p "  Press Enter to continue..."
    fi
}

#============================================
# MAIN MENU - IMPROVED UI
#============================================
main_menu() {
    while true; do
        banner
        echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
        echo -e "${C}│${N}  ${BOLD}${W}⚡ MAIN MENU - SLOWDNS MANAGER ULTIMATE${N}                            ${C}│${N}"
        echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
        echo -e "${C}│${N}                                                                      ${C}│${N}"
        echo -e "${C}│${N}  ${W}1)${G} 🚀 Install/Setup${N}        ${W}7)${C} 👥 User Management${N}               ${C}│${N}"
        echo -e "${C}│${N}  ${W}2)${G} ▶  Start Service${N}         ${W}8)${C} 📋 View Logs${N}                  ${C}│${N}"
        echo -e "${C}│${N}  ${W}3)${R} ⏹  Stop Service${N}          ${W}9)${C} 🌐 Network Info${N}                ${C}│${N}"
        echo -e "${C}│${N}  ${W}4)${Y} 🔄 Restart Service${N}       ${W}10)${R} 🗑️  Uninstall${N}                ${C}│${N}"
        echo -e "${C}│${N}  ${W}5)${C} 📊 Service Status${N}        ${W}11)${M} 🚪 Exit${N}                      ${C}│${N}"
        echo -e "${C}│${N}  ${W}6)${C} 📈 Speed Monitor${N}                                               ${C}│${N}"
        echo -e "${C}│${N}                                                                      ${C}│${N}"
        echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
        echo -e "${C}│${N}  ${G}⚡ Speed: 2+ Mbps  📡 Network: Halotel  🔐 Secure${N}                 ${C}│${N}"
        echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
        echo ""
        read -p "  Select option [1-11]: " opt
        
        case $opt in
            1)
                banner
                echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
                echo -e "${C}│${N}  ${BOLD}${G}🚀 INSTALLATION STARTED${N}                                          ${C}│${N}"
                echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
                echo ""
                check_deps
                optimize_network
                install_dnstt
                create_service
                start_service
                read -p "  Press Enter to continue..."
                ;;
            2)
                start_service
                read -p "  Press Enter to continue..."
                ;;
            3)
                stop_service
                read -p "  Press Enter to continue..."
                ;;
            4)
                restart_service
                read -p "  Press Enter to continue..."
                ;;
            5)
                service_status
                ;;
            6)
                speed_monitor
                ;;
            7)
                manage_users
                ;;
            8)
                view_logs
                ;;
            9)
                network_info
                ;;
            10)
                uninstall
                ;;
            11)
                echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
                echo -e "${C}│${N}  ${G}✨ Goodbye!${N}                                                         ${C}│${N}"
                echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
                exit 0
                ;;
            *)
                echo -e "${R}✗ Invalid option${N}"
                sleep 1
                ;;
        esac
    done
}

#============================================
# AUTO INSTALL - IMPROVED UI
#============================================
auto_install() {
    banner
    echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
    echo -e "${C}│${N}  ${BOLD}${G}⚡ AUTO INSTALL MODE${N}                                               ${C}│${N}"
    echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
    echo -e "${C}│${N}  ${Y}⏳ Please wait...${N}                                                    ${C}│${N}"
    echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
    echo ""
    
    check_deps
    init_system
    optimize_network
    install_dnstt
    create_service
    start_service
    
    echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
    echo -e "${C}│${N}  ${BOLD}${G}✅ INSTALLATION COMPLETE!${N}                                          ${C}│${N}"
    echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
    echo -e "${C}│${N}  ${G}🚀 SlowDNS is now running${N}                                           ${C}│${N}"
    echo -e "${C}│${N}  ${W}📱 Port       : ${C}${DNSTT_PORT}${N}                                              ${C}│${N}"
    echo -e "${C}│${N}  ${W}🔑 Public Key: ${Y}${PUBLIC_KEY}${N}                                     ${C}│${N}"
    echo -e "${C}│${N}  ${W}⚡ Speed     : ${G}2+ Mbps${N}                                                ${C}│${N}"
    echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
    echo -e "${C}│${N}  ${Y}💡 Run './$0' for full menu${N}                                     ${C}│${N}"
    echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
    echo ""
    exit 0
}

#============================================
# MAIN
#============================================
main() {
    check_root
    init_system
    
    case "$1" in
        --install|-i)
            auto_install
            ;;
        --start|-s)
            start_service
            exit 0
            ;;
        --stop|-p)
            stop_service
            exit 0
            ;;
        --restart|-r)
            restart_service
            exit 0
            ;;
        --status|-t)
            service_status
            exit 0
            ;;
        --help|-h)
            echo -e "${C}┌──────────────────────────────────────────────────────────────────────┐${N}"
            echo -e "${C}│${N}  ${BOLD}${W}SLOWDNS MANAGER - ULTIMATE EDITION${N}                               ${C}│${N}"
            echo -e "${C}├──────────────────────────────────────────────────────────────────────┤${N}"
            echo -e "${C}│${N}  ${W}Usage: $0 [OPTION]${N}                                               ${C}│${N}"
            echo -e "${C}│${N}                                                                      ${C}│${N}"
            echo -e "${C}│${N}  ${W}Options:${N}                                                          ${C}│${N}"
            echo -e "${C}│${N}    ${G}--install, -i${N}  Auto install and start${N}                               ${C}│${N}"
            echo -e "${C}│${N}    ${G}--start, -s${N}    Start service${N}                                      ${C}│${N}"
            echo -e "${C}│${N}    ${R}--stop, -p${N}     Stop service${N}                                       ${C}│${N}"
            echo -e "${C}│${N}    ${Y}--restart, -r${N}  Restart service${N}                                    ${C}│${N}"
            echo -e "${C}│${N}    ${C}--status, -t${N}   Show status${N}                                        ${C}│${N}"
            echo -e "${C}│${N}    ${W}--help, -h${N}     Show this help${N}                                     ${C}│${N}"
            echo -e "${C}│${N}                                                                      ${C}│${N}"
            echo -e "${C}│${N}  ${Y}Run without options for interactive menu${N}                              ${C}│${N}"
            echo -e "${C}└──────────────────────────────────────────────────────────────────────┘${N}"
            exit 0
            ;;
        *)
            main_menu
            ;;
    esac
}

# Run main
main "$@"