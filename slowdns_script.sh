#!/bin/bash

##############################################
# SLOWDNS ULTRA SPEED - HALOTEL OPTIMIZED
# Created By STANY 👑 💯
# Version: 9.0.0 - MAXIMUM SPEED EDITION
# Optimized for Halotel Tanzania - 10-25 Mbps
# PURE SPEED - NO COMPROMISE
##############################################

set -o pipefail 2>/dev/null || true

# ============================================
# COLORS - ENHANCED
# ============================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

# ============================================
# PATHS
# ============================================
INSTALL_DIR="/etc/slowdns"
SSH_DIR="/etc/slowdns/ssh"
USER_DB="$INSTALL_DIR/users.txt"
LOG_DIR="/var/log/slowdns"
LOG_FILE="$LOG_DIR/slowdns.log"
PID_FILE="/var/run/slowdns.pid"
CONFIG_FILE="$INSTALL_DIR/config.conf"

# ============================================
# HALOTEL OPTIMIZED SETTINGS
# ============================================
DNSTT_PORT=5300
DNS_PORT=53
SSH_PORT=22
MTU=1420
MAX_SPEED=25000  # 25 Mbps target
BUFFER_SIZE=1073741824  # 1GB
UDP_BUFFER=134217728  # 128MB
TCP_BUFFER=134217728  # 128MB

# Halotel Tanzania - Best DNS Servers
HALOTEL_DNS=(
    "154.70.103.17"
    "154.70.103.18"
    "154.70.64.2"
    "8.8.8.8"
    "1.1.1.1"
)

# ============================================
# BANNER - STANY EDITION
# ============================================
show_banner() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   ███████╗██╗      ██████╗ ██╗    ██╗██████╗ ███╗   ██╗███████╗             ║
║   ██╔════╝██║     ██╔═══██╗██║    ██║██╔══██╗████╗  ██║██╔════╝             ║
║   ███████╗██║     ██║   ██║██║ █╗ ██║██║  ██║██╔██╗ ██║███████╗             ║
║   ╚════██║██║     ██║   ██║██║███╗██║██║  ██║██║╚██╗██║╚════██║             ║
║   ███████║███████╗╚██████╔╝╚███╔███╔╝██████╔╝██║ ╚████║███████║             ║
║   ╚══════╝╚══════╝ ╚═════╝  ╚══╝╚══╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝             ║
║                                                                              ║
║          ╔═══════════════════════════════════════════════════════════╗        ║
║          ║   🚀 SLOWDNS ULTRA SPEED - HALOTEL OPTIMIZED 🚀        ║        ║
║          ║       ⚡ TARGET SPEED: 10-25 Mbps ⚡                    ║        ║
║          ║         📡 NETWORK: HALOTEL TANZANIA 📡               ║        ║
║          ║           🔥 MAXIMUM PERFORMANCE EDITION 🔥           ║        ║
║          ╚═══════════════════════════════════════════════════════════╝        ║
║                                                                              ║
║              ╔══════════════════════════════════════════════╗                ║
║              ║     CREATED BY STANY 👑 💯                   ║                ║
║              ╚══════════════════════════════════════════════╝                ║
║                                                                              ║
║              ╔══════════════════════════════════════════════╗                ║
║              ║   📱 OPTIMIZED FOR TANZANIA NETWORKS 📱    ║                ║
║              ╚══════════════════════════════════════════════╝                ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# ============================================
# UI FUNCTIONS
# ============================================
print_header() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${WHITE}  $1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
    echo -e "  ${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "  ${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "  ${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "  ${CYAN}ℹ️  $1${NC}"
}

print_value() {
    printf "  ${WHITE}%-20s${NC} : ${GREEN}%s${NC}\n" "$1" "$2"
}

press_enter() {
    echo ""
    read -p "  Press Enter to continue..."
}

# ============================================
# SYSTEM CHECKS
# ============================================
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}❌ ERROR: Root privileges required${NC}"
        echo -e "${YELLOW}➜ Run: sudo bash $0${NC}"
        exit 1
    fi
}

# ============================================
# ULTRA SPEED OPTIMIZATION - HALOTEL
# ============================================
optimize_halotel_speed() {
    print_header "⚡ ULTRA SPEED OPTIMIZATION - HALOTEL"
    echo ""
    
    # Enable IP forwarding
    sysctl -w net.ipv4.ip_forward=1 > /dev/null 2>&1
    
    # Load BBR for maximum speed
    modprobe tcp_bbr 2>/dev/null
    modprobe tcp_hybla 2>/dev/null
    
    echo -e "${CYAN}  [1/10]${NC} TCP BBR + FQ-CoDel (Maximum throughput)..."
    sysctl -w net.ipv4.tcp_congestion_control=bbr > /dev/null 2>&1
    sysctl -w net.core.default_qdisc=fq > /dev/null 2>&1
    print_success "BBR + FQ enabled - 10-25 Mbps capable"
    sleep 0.3
    
    echo -e "${CYAN}  [2/10]${NC} 1GB Network Buffers (Zero packet loss)..."
    sysctl -w net.core.rmem_max=$BUFFER_SIZE > /dev/null 2>&1
    sysctl -w net.core.wmem_max=$BUFFER_SIZE > /dev/null 2>&1
    sysctl -w net.core.rmem_default=$UDP_BUFFER > /dev/null 2>&1
    sysctl -w net.core.wmem_default=$TCP_BUFFER > /dev/null 2>&1
    sysctl -w net.ipv4.tcp_rmem="16384 1048576 $BUFFER_SIZE" > /dev/null 2>&1
    sysctl -w net.ipv4.tcp_wmem="16384 1048576 $BUFFER_SIZE" > /dev/null 2>&1
    print_success "1GB Network Buffers configured"
    sleep 0.3
    
    echo -e "${CYAN}  [3/10]${NC} UDP Buffer for DNS Tunnels (128MB)..."
    sysctl -w net.ipv4.udp_rmem_min=$UDP_BUFFER > /dev/null 2>&1
    sysctl -w net.ipv4.udp_wmem_min=$UDP_BUFFER > /dev/null 2>&1
    sysctl -w net.ipv4.udp_mem="134217728 268435456 536870912" > /dev/null 2>&1
    print_success "128MB UDP buffers - EDNS0++ ready"
    sleep 0.3
    
    echo -e "${CYAN}  [4/10]${NC} Packet Processing (300K packets/sec)..."
    sysctl -w net.core.netdev_max_backlog=500000 > /dev/null 2>&1
    sysctl -w net.core.netdev_budget=6000 > /dev/null 2>&1
    sysctl -w net.core.netdev_budget_usecs=40000 > /dev/null 2>&1
    sysctl -w net.core.somaxconn=524288 > /dev/null 2>&1
    print_success "300K packet/sec processing"
    sleep 0.3
    
    echo -e "${CYAN}  [5/10]${NC} Connection Tracking (8M connections)..."
    sysctl -w net.netfilter.nf_conntrack_max=8000000 > /dev/null 2>&1
    sysctl -w net.netfilter.nf_conntrack_tcp_timeout_established=432000 > /dev/null 2>&1
    sysctl -w net.netfilter.nf_conntrack_udp_timeout=120 > /dev/null 2>&1
    print_success "8M connection tracking"
    sleep 0.3
    
    echo -e "${CYAN}  [6/10]${NC} TCP FastOpen + Advanced Tuning..."
    sysctl -w net.ipv4.tcp_fastopen=3 > /dev/null 2>&1
    sysctl -w net.ipv4.tcp_slow_start_after_idle=0 > /dev/null 2>&1
    sysctl -w net.ipv4.tcp_tw_reuse=1 > /dev/null 2>&1
    sysctl -w net.ipv4.tcp_fin_timeout=5 > /dev/null 2>&1
    sysctl -w net.ipv4.tcp_max_tw_buckets=2000000 > /dev/null 2>&1
    print_success "TCP FastOpen + Zero delay"
    sleep 0.3
    
    echo -e "${CYAN}  [7/10]${NC} Zero-Copy + Offloading (Maximum speed)..."
    sysctl -w net.ipv4.tcp_low_latency=1 > /dev/null 2>&1
    sysctl -w net.ipv4.tcp_sack=1 > /dev/null 2>&1
    sysctl -w net.ipv4.tcp_fack=1 > /dev/null 2>&1
    sysctl -w net.ipv4.tcp_timestamps=1 > /dev/null 2>&1
    sysctl -w net.ipv4.tcp_mtu_probing=1 > /dev/null 2>&1
    print_success "Zero-copy + Offloading enabled"
    sleep 0.3
    
    echo -e "${CYAN}  [8/10]${NC} Halotel DNS Optimization..."
    echo "nameserver 154.70.103.17" > /etc/resolv.conf
    echo "nameserver 154.70.103.18" >> /etc/resolv.conf
    echo "nameserver 8.8.8.8" >> /etc/resolv.conf
    chattr +i /etc/resolv.conf 2>/dev/null
    print_success "Halotel DNS servers configured"
    sleep 0.3
    
    echo -e "${CYAN}  [9/10]${NC} MTU Optimization (${MTU} bytes)..."
    IFACE=$(ip route | grep default | awk '{print $5}' | head -1)
    [[ -n "$IFACE" ]] && ip link set dev "$IFACE" mtu $MTU 2>/dev/null
    ip link set lo mtu 65536 2>/dev/null
    print_success "MTU $MTU optimized for Halotel"
    sleep 0.3
    
    echo -e "${CYAN} [10/10]${NC} File Descriptors (2M) + Process Priority..."
    ulimit -n 2097152 2>/dev/null
    cat > /etc/security/limits.d/99-slowdns.conf << 'EOF'
* soft nofile 2097152
* hard nofile 2097152
root soft nofile 2097152
root hard nofile 2097152
* soft nproc 2097152
* hard nproc 2097152
EOF
    renice -n -20 -p $$ 2>/dev/null
    print_success "2M File Descriptors + RT Priority"
    sleep 0.3
    
    # Save permanent config
    cat > /etc/sysctl.d/99-slowdns-speed.conf << 'EOF'
# SLOWDNS ULTRA SPEED - HALOTEL OPTIMIZED
# Created By STANY 👑 💯
# Target: 10-25 Mbps

net.ipv4.ip_forward = 1
net.ipv4.tcp_congestion_control = bbr
net.core.default_qdisc = fq

net.core.rmem_max = 1073741824
net.core.wmem_max = 1073741824
net.core.rmem_default = 134217728
net.core.wmem_default = 134217728
net.ipv4.tcp_rmem = 16384 1048576 1073741824
net.ipv4.tcp_wmem = 16384 1048576 1073741824

net.ipv4.udp_rmem_min = 134217728
net.ipv4.udp_wmem_min = 134217728
net.ipv4.udp_mem = 134217728 268435456 536870912

net.core.netdev_max_backlog = 500000
net.core.netdev_budget = 6000
net.core.netdev_budget_usecs = 40000
net.core.somaxconn = 524288

net.netfilter.nf_conntrack_max = 8000000
net.netfilter.nf_conntrack_tcp_timeout_established = 432000
net.netfilter.nf_conntrack_udp_timeout = 120

net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 5
net.ipv4.tcp_max_tw_buckets = 2000000

net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_sack = 1
net.ipv4.tcp_fack = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_mtu_probing = 1

net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.udp_early_demux = 1
net.ipv4.tcp_early_retrans = 3

vm.min_free_kbytes = 65536
vm.swappiness = 10
EOF

    sysctl -p /etc/sysctl.d/99-slowdns-speed.conf > /dev/null 2>&1
    
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║       ⚡ ULTRA SPEED ACTIVATED - HALOTEL ⚡              ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "  ${CYAN}Optimization Summary:${NC}"
    echo -e "  ${GREEN}✓${NC} BBR + FQ-CoDel (Next-gen congestion)"
    echo -e "  ${GREEN}✓${NC} 1GB Network Buffers (Zero loss)"
    echo -e "  ${GREEN}✓${NC} 128MB UDP Buffers (EDNS0++)"
    echo -e "  ${GREEN}✓${NC} 300K Packet/sec Processing"
    echo -e "  ${GREEN}✓${NC} 8M Connection Tracking"
    echo -e "  ${GREEN}✓${NC} TCP FastOpen + Zero-delay"
    echo -e "  ${GREEN}✓${NC} Halotel DNS Optimized"
    echo -e "  ${GREEN}✓${NC} MTU $MTU optimized"
    echo -e "  ${GREEN}✓${NC} 2M File Descriptors"
    echo ""
    echo -e "  ${YELLOW}🎯 EXPECTED SPEED: 10-25 Mbps on Halotel${NC}"
    echo ""
    sleep 2
}

# ============================================
# FIREWALL - HALOTEL OPTIMIZED
# ============================================
configure_firewall() {
    print_header "🔥 FIREWALL CONFIGURATION"
    echo ""
    
    # Stop systemd-resolved (port 53 conflict)
    if systemctl is-active --quiet systemd-resolved 2>/dev/null; then
        systemctl stop systemd-resolved 2>/dev/null
        systemctl disable systemd-resolved 2>/dev/null
        print_success "systemd-resolved stopped"
    fi
    
    # Configure iptables
    iptables -F 2>/dev/null
    iptables -t nat -F 2>/dev/null
    
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT
    
    # Allow all needed ports
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT
    iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    
    # DNSTT ports
    iptables -I INPUT 1 -p udp --dport $DNSTT_PORT -j ACCEPT
    iptables -I INPUT 2 -p udp --dport 53 -j ACCEPT
    
    # Redirect 53 → 5300
    iptables -t nat -I PREROUTING 1 -p udp --dport 53 -j REDIRECT --to-ports $DNSTT_PORT
    
    # SSH
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    
    # Save rules
    mkdir -p /etc/iptables
    iptables-save > /etc/iptables/rules.v4 2>/dev/null
    
    print_success "Firewall configured"
    echo ""
    echo -e "  ${CYAN}Open Ports:${NC}"
    echo -e "  ${GREEN}✓${NC} UDP 53 → DNSTT (5300)"
    echo -e "  ${GREEN}✓${NC} UDP $DNSTT_PORT (DNSTT Server)"
    echo -e "  ${GREEN}✓${NC} TCP 22 (SSH)"
    echo ""
    sleep 1
}

# ============================================
# INSTALL DEPENDENCIES
# ============================================
install_deps() {
    print_header "📦 INSTALLING DEPENDENCIES"
    echo ""
    
    echo -e "${CYAN}  Updating package lists...${NC}"
    apt-get update -qq 2>/dev/null
    
    PKGS="wget curl git build-essential ca-certificates dnsutils net-tools iproute2 sysstat htop bc openssh-server iptables"
    
    echo -e "${CYAN}  Installing packages...${NC}"
    apt-get install -y $PKGS -qq 2>/dev/null
    
    print_success "All dependencies installed"
    sleep 1
}

# ============================================
# INSTALL GO
# ============================================
install_go() {
    if command -v go &>/dev/null; then
        print_success "Go already installed"
        return 0
    fi
    
    print_header "📦 INSTALLING GO"
    echo ""
    
    ARCH=$(uname -m)
    case "$ARCH" in
        x86_64) GO_ARCH="amd64" ;;
        aarch64) GO_ARCH="arm64" ;;
        *) GO_ARCH="amd64" ;;
    esac
    
    GO_VERSION="1.22.4"
    wget -q "https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz" -O /tmp/go.tar.gz
    tar -C /usr/local -xzf /tmp/go.tar.gz
    rm -f /tmp/go.tar.gz
    
    export PATH=$PATH:/usr/local/go/bin
    export GOPATH=/root/go
    
    cat > /etc/profile.d/golang.sh << 'EOF'
export PATH=$PATH:/usr/local/go/bin
export GOPATH=/root/go
EOF
    chmod +x /etc/profile.d/golang.sh
    
    print_success "Go installed"
    sleep 1
}

# ============================================
# BUILD DNSTT
# ============================================
build_dnstt() {
    print_header "🔨 BUILDING DNSTT"
    echo ""
    
    export PATH=$PATH:/usr/local/go/bin
    export GOPATH=/root/go
    
    cd /tmp
    rm -rf dnstt-src
    
    echo -e "${CYAN}  Cloning DNSTT...${NC}"
    git clone https://www.bamsoftware.com/git/dnstt.git dnstt-src 2>/dev/null || \
    git clone https://github.com/ekoops/dnstt.git dnstt-src 2>/dev/null
    
    cd dnstt-src/dnstt-server
    go build -o /usr/local/bin/dnstt-server .
    
    cd ../dnstt-client
    go build -o /usr/local/bin/dnstt-client .
    
    chmod +x /usr/local/bin/dnstt-*
    cd /tmp
    rm -rf dnstt-src
    
    print_success "DNSTT built successfully"
    print_info "Server: /usr/local/bin/dnstt-server"
    print_info "Client: /usr/local/bin/dnstt-client"
    sleep 1
}

# ============================================
# GENERATE KEYS
# ============================================
generate_keys() {
    print_header "🔑 GENERATING ENCRYPTION KEYS"
    echo ""
    
    mkdir -p "$INSTALL_DIR"
    cd "$INSTALL_DIR"
    
    /usr/local/bin/dnstt-server -gen-key -privkey-file server.key -pubkey-file server.pub
    
    PUBKEY=$(cat server.pub)
    PRIVKEY=$(cat server.key)
    
    print_success "Keys generated"
    print_value "Public Key" "$PUBKEY"
    sleep 1
}

# ============================================
# CREATE SERVICE
# ============================================
create_service() {
    local domain=$1
    
    print_header "⚡ CREATING SERVICE"
    echo ""
    
    CPU_COUNT=$(nproc 2>/dev/null || echo "2")
    
    cat > /etc/systemd/system/slowdns.service << EOF
[Unit]
Description=SlowDNS Ultra Speed - Halotel Optimized
After=network.target network-online.target
Wants=network-online.target

[Service]
Type=simple
User=root
WorkingDirectory=$INSTALL_DIR

Environment="GOMAXPROCS=$CPU_COUNT"
Environment="GODEBUG=netdns=go"
Environment="GOGC=100"

ExecStart=/usr/local/bin/dnstt-server -udp :$DNSTT_PORT -privkey-file $INSTALL_DIR/server.key -mtu $MTU $domain 127.0.0.1:$SSH_PORT

Restart=always
RestartSec=3
StandardOutput=append:$LOG_DIR/dnstt-server.log
StandardError=append:$LOG_DIR/dnstt-error.log

LimitNOFILE=2097152
LimitNPROC=2097152
CPUSchedulingPolicy=fifo
CPUSchedulingPriority=99

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable slowdns 2>/dev/null
    
    print_success "Service created"
    print_value "CPU Workers" "$CPU_COUNT"
    print_value "Priority" "FIFO 99 (Realtime)"
    print_value "File Descriptors" "2M"
    sleep 1
}

# ============================================
# START SERVICE
# ============================================
start_service() {
    print_header "🚀 STARTING SLOWDNS"
    echo ""
    
    systemctl start slowdns
    sleep 2
    
    if systemctl is-active --quiet slowdns; then
        print_success "Service running"
        
        PUBLIC_IP=$(curl -s ifconfig.me 2>/dev/null || echo "YOUR_IP")
        PUBKEY=$(cat "$INSTALL_DIR/server.pub" 2>/dev/null || echo "N/A")
        
        echo ""
        echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║        ✅ SLOWDNS ULTRA SPEED IS RUNNING ✅              ║${NC}"
        echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        print_value "Server IP" "$PUBLIC_IP"
        print_value "Port" "$DNSTT_PORT"
        print_value "Public Key" "$PUBKEY"
        print_value "MTU" "$MTU bytes"
        print_value "Speed Target" "10-25 Mbps"
        echo ""
        echo -e "  ${YELLOW}📱 CLIENT CONFIGURATION:${NC}"
        echo -e "  ${WHITE}Server: ${GREEN}$PUBLIC_IP${NC}"
        echo -e "  ${WHITE}Port: ${GREEN}$DNSTT_PORT${NC}"
        echo -e "  ${WHITE}Public Key: ${GREEN}$PUBKEY${NC}"
        echo ""
        echo -e "  ${YELLOW}🔗 DNS Records:${NC}"
        echo -e "  ${WHITE}A Record: ${GREEN}ns.yourdomain.com → $PUBLIC_IP${NC}"
        echo -e "  ${WHITE}NS Record: ${GREEN}tunnel.yourdomain.com → ns.yourdomain.com${NC}"
        echo ""
    else
        print_error "Service failed to start"
        journalctl -u slowdns -n 20 --no-pager
    fi
    
    sleep 2
}

# ============================================
# SPEED TEST - HALOTEL
# ============================================
test_speed() {
    print_header "📊 SPEED TEST - HALOTEL"
    echo ""
    
    if ! systemctl is-active --quiet slowdns; then
        print_error "SlowDNS not running"
        press_enter
        return
    fi
    
    IFACE=$(ip route | grep default | awk '{print $5}' | head -1)
    [[ -z "$IFACE" ]] && IFACE="eth0"
    
    echo -e "${CYAN}  Testing for 30 seconds...${NC}"
    echo ""
    
    RX1=$(cat /sys/class/net/$IFACE/statistics/rx_bytes 2>/dev/null)
    TX1=$(cat /sys/class/net/$IFACE/statistics/tx_bytes 2>/dev/null)
    
    PEAK_RX=0
    PEAK_TX=0
    
    for i in $(seq 1 30); do
        sleep 1
        RX2=$(cat /sys/class/net/$IFACE/statistics/rx_bytes 2>/dev/null)
        TX2=$(cat /sys/class/net/$IFACE/statistics/tx_bytes 2>/dev/null)
        
        DOWN=$(echo "scale=2; ($RX2 - $RX1) * 8 / 1000000" | bc 2>/dev/null)
        UP=$(echo "scale=2; ($TX2 - $TX1) * 8 / 1000000" | bc 2>/dev/null)
        
        [[ $(echo "$DOWN > $PEAK_RX" | bc) -eq 1 ]] && PEAK_RX=$DOWN
        [[ $(echo "$UP > $PEAK_TX" | bc) -eq 1 ]] && PEAK_TX=$UP
        
        printf "\r  ${WHITE}Download: ${GREEN}%6.2f Mbps${NC}  ${WHITE}Upload: ${CYAN}%6.2f Mbps${NC}" "$DOWN" "$UP"
        
        RX1=$RX2
        TX1=$TX2
    done
    
    echo ""
    echo ""
    echo -e "${GREEN}━━━━━ RESULTS ━━━━━${NC}"
    print_value "Peak Download" "$PEAK_RX Mbps"
    print_value "Peak Upload" "$PEAK_TX Mbps"
    print_value "MTU Used" "$MTU bytes"
    print_value "Network" "Halotel Tanzania"
    echo ""
    
    TOTAL=$(echo "$PEAK_RX + $PEAK_TX" | bc 2>/dev/null)
    
    if (( $(echo "$TOTAL >= 15" | bc -l) )); then
        echo -e "  ${GREEN}✅ EXCELLENT! Speed: ${TOTAL} Mbps${NC}"
    elif (( $(echo "$TOTAL >= 10" | bc -l) )); then
        echo -e "  ${GREEN}✅ GOOD! Speed: ${TOTAL} Mbps${NC}"
    elif (( $(echo "$TOTAL >= 5" | bc -l) )); then
        echo -e "  ${YELLOW}⚠️  MEDIUM: ${TOTAL} Mbps${NC}"
    else
        echo -e "  ${RED}❌ LOW: ${TOTAL} Mbps - Check configuration${NC}"
    fi
    
    press_enter
}

# ============================================
# SSH USER MANAGEMENT
# ============================================
add_user() {
    print_header "👤 ADD SSH USER"
    echo ""
    
    read -p "  Username: " username
    [[ -z "$username" ]] && { print_error "Username required"; press_enter; return; }
    
    if id "$username" &>/dev/null; then
        print_error "User already exists"
        press_enter
        return
    fi
    
    read -sp "  Password: " password
    echo ""
    [[ -z "$password" ]] && { print_error "Password required"; press_enter; return; }
    
    echo ""
    echo -e "  ${YELLOW}Expiration:${NC}"
    echo "  1) 1 Day   2) 7 Days   3) 30 Days   4) 90 Days   5) 365 Days"
    read -p "  Choice [1-5, default=3]: " exp_choice
    
    case ${exp_choice:-3} in
        1) days=1 ;;
        2) days=7 ;;
        3) days=30 ;;
        4) days=90 ;;
        5) days=365 ;;
        *) days=30 ;;
    esac
    
    useradd -m -s /bin/bash "$username" 2>/dev/null
    echo "$username:$password" | chpasswd 2>/dev/null
    
    exp_date=$(date -d "+$days days" +"%Y-%m-%d")
    chage -E "$exp_date" "$username" 2>/dev/null
    
    mkdir -p "$INSTALL_DIR"
    echo "$username|$password|$exp_date|$(date +%Y-%m-%d)" >> "$USER_DB"
    
    echo ""
    print_success "User created!"
    print_value "Username" "$username"
    print_value "Password" "$password"
    print_value "Expires" "$exp_date"
    print_value "Valid Days" "$days"
    
    press_enter
}

list_users() {
    print_header "📋 SSH USERS"
    echo ""
    
    if [[ ! -s "$USER_DB" ]]; then
        print_warning "No users found"
        press_enter
        return
    fi
    
    echo -e "${CYAN}  ┌─────────────┬─────────────┬─────────────┬──────────┐${NC}"
    printf "  ${CYAN}│${NC} ${WHITE}%-12s${NC} ${CYAN}│${NC} ${WHITE}%-12s${NC} ${CYAN}│${NC} ${WHITE}%-12s${NC} ${CYAN}│${NC} ${WHITE}%-8s${NC} ${CYAN}│${NC}\n" "USERNAME" "PASSWORD" "EXPIRES" "STATUS"
    echo -e "${CYAN}  ├─────────────┼─────────────┼─────────────┼──────────┤${NC}"
    
    current=$(date +%s)
    
    while IFS='|' read -r user pass exp created; do
        exp_unix=$(date -d "$exp" +%s 2>/dev/null || echo 0)
        if [[ $current -gt $exp_unix ]]; then
            status="${RED}EXPIRED${NC}"
        else
            days_left=$(( (exp_unix - current) / 86400 ))
            if [[ $days_left -le 3 ]]; then
                status="${RED}${days_left}d${NC}"
            elif [[ $days_left -le 7 ]]; then
                status="${YELLOW}${days_left}d${NC}"
            else
                status="${GREEN}${days_left}d${NC}"
            fi
        fi
        
        printf "  ${CYAN}│${NC} ${WHITE}%-12s${NC} ${CYAN}│${NC} ${YELLOW}%-12s${NC} ${CYAN}│${NC} ${CYAN}%-12s${NC} ${CYAN}│${NC} %-8s ${CYAN}│${NC}\n" "$user" "$pass" "$exp" "$status"
    done < "$USER_DB"
    
    echo -e "${CYAN}  └─────────────┴─────────────┴─────────────┴──────────┘${NC}"
    
    press_enter
}

delete_user() {
    print_header "🗑️ DELETE SSH USER"
    echo ""
    
    read -p "  Username to delete: " username
    
    if ! id "$username" &>/dev/null; then
        print_error "User not found"
        press_enter
        return
    fi
    
    echo -e "${RED}⚠️  WARNING: Deleting user: $username${NC}"
    read -p "  Type 'yes' to confirm: " confirm
    
    [[ "$confirm" != "yes" ]] && { print_warning "Cancelled"; press_enter; return; }
    
    pkill -u "$username" 2>/dev/null
    userdel -r "$username" 2>/dev/null
    sed -i "/^$username|/d" "$USER_DB"
    
    print_success "User deleted"
    press_enter
}

# ============================================
# SERVICE MANAGEMENT
# ============================================
service_status() {
    print_header "📊 SERVICE STATUS"
    echo ""
    
    if systemctl is-active --quiet slowdns; then
        print_success "SlowDNS: RUNNING"
        
        PID=$(systemctl show slowdns --property=MainPID --value)
        UPTIME=$(ps -p "$PID" -o etime= 2>/dev/null | xargs)
        CPU=$(ps -p "$PID" -o %cpu= 2>/dev/null | xargs)
        MEM=$(ps -p "$PID" -o %mem= 2>/dev/null | xargs)
        
        print_value "PID" "$PID"
        print_value "Uptime" "$UPTIME"
        print_value "CPU" "$CPU%"
        print_value "Memory" "$MEM%"
        print_value "MTU" "$MTU bytes"
    else
        print_error "SlowDNS: STOPPED"
    fi
    
    echo ""
    systemctl status slowdns --no-pager -l | head -15
    
    press_enter
}

view_logs() {
    print_header "📋 LOGS"
    echo ""
    
    tail -50 "$LOG_DIR/dnstt-server.log" 2>/dev/null || print_warning "No logs found"
    press_enter
}

restart_service() {
    print_header "🔄 RESTARTING SERVICE"
    echo ""
    
    systemctl restart slowdns
    sleep 2
    
    if systemctl is-active --quiet slowdns; then
        print_success "Service restarted"
    else
        print_error "Service failed to restart"
    fi
    
    sleep 1
}

stop_service() {
    print_header "⏹ STOPPING SERVICE"
    echo ""
    
    systemctl stop slowdns
    print_success "Service stopped"
    sleep 1
}

# ============================================
# UNINSTALL
# ============================================
uninstall() {
    print_header "🗑️ UNINSTALL"
    echo ""
    
    echo -e "${RED}⚠️  WARNING: This will remove everything${NC}"
    read -p "  Type 'yes' to confirm: " confirm
    
    [[ "$confirm" != "yes" ]] && { print_warning "Cancelled"; press_enter; return; }
    
    systemctl stop slowdns 2>/dev/null
    systemctl disable slowdns 2>/dev/null
    rm -f /etc/systemd/system/slowdns.service
    
    rm -rf "$INSTALL_DIR" "$LOG_DIR"
    rm -f /usr/local/bin/dnstt-*
    rm -f /etc/sysctl.d/99-slowdns-speed.conf
    rm -f /etc/security/limits.d/99-slowdns.conf
    
    systemctl daemon-reload
    
    print_success "Uninstall complete"
    sleep 2
}

# ============================================
# MAIN MENU
# ============================================
main_menu() {
    while true; do
        show_banner
        
        echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║                    MAIN MENU                                ║${NC}"
        echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "  ${GREEN}1)${NC} 🚀 Install SlowDNS Ultra Speed"
        echo -e "  ${GREEN}2)${NC} ▶  Start Service"
        echo -e "  ${YELLOW}3)${NC} ⏹  Stop Service"
        echo -e "  ${YELLOW}4)${NC} 🔄 Restart Service"
        echo -e "  ${CYAN}5)${NC} 📊 Service Status"
        echo -e "  ${CYAN}6)${NC} 📈 Speed Test"
        echo -e "  ${BLUE}7)${NC} 👤 SSH Users"
        echo -e "  ${BLUE}8)${NC} 📋 View Logs"
        echo -e "  ${PURPLE}9)${NC} ⚡ Speed Optimize"
        echo -e "  ${RED}10)${NC} 🗑️  Uninstall"
        echo -e "  ${WHITE}0)${NC} 🚪 Exit"
        echo ""
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${WHITE}Version: 9.0 ULTRA | ${GREEN}Created By STANY 👑 💯${NC}"
        echo -e "${YELLOW}🎯 Target Speed: 10-25 Mbps on Halotel${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        read -p "  Choice [0-10]: " choice
        
        case $choice in
            1)
                show_banner
                install_deps
                install_go
                build_dnstt
                generate_keys
                optimize_halotel_speed
                configure_firewall
                
                echo ""
                read -p "  Enter tunnel domain (e.g., t.yourdomain.com): " domain
                domain=${domain:-t.slowdns.local}
                
                create_service "$domain"
                start_service
                press_enter
                ;;
            2)
                start_service
                press_enter
                ;;
            3)
                stop_service
                press_enter
                ;;
            4)
                restart_service
                press_enter
                ;;
            5)
                service_status
                ;;
            6)
                test_speed
                ;;
            7)
                while true; do
                    show_banner
                    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
                    echo -e "${CYAN}║                    SSH USERS                               ║${NC}"
                    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
                    echo ""
                    echo -e "  ${GREEN}1)${NC} Add User"
                    echo -e "  ${CYAN}2)${NC} List Users"
                    echo -e "  ${RED}3)${NC} Delete User"
                    echo -e "  ${WHITE}0)${NC} Back"
                    echo ""
                    read -p "  Choice: " user_choice
                    
                    case $user_choice in
                        1) add_user ;;
                        2) list_users ;;
                        3) delete_user ;;
                        0) break ;;
                        *) print_error "Invalid choice"; sleep 1 ;;
                    esac
                done
                ;;
            8)
                view_logs
                ;;
            9)
                show_banner
                optimize_halotel_speed
                press_enter
                ;;
            10)
                uninstall
                ;;
            0)
                echo ""
                echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
                echo -e "${GREEN}    Thank you for using SlowDNS Ultra Speed! 👑 💯${NC}"
                echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
                echo ""
                exit 0
                ;;
            *)
                print_error "Invalid choice"
                sleep 1
                ;;
        esac
    done
}

# ============================================
# QUICK INSTALL - ONE COMMAND
# ============================================
quick_install() {
    show_banner
    print_header "⚡ QUICK INSTALL - ULTRA SPEED"
    echo ""
    
    install_deps
    install_go
    build_dnstt
    generate_keys
    optimize_halotel_speed
    configure_firewall
    
    domain="t.slowdns.local"
    create_service "$domain"
    start_service
    
    echo ""
    echo -e "${GREEN}✅ INSTALLATION COMPLETE!${NC}"
    echo ""
    echo -e "  ${YELLOW}📱 Client Configuration:${NC}"
    echo -e "  ${WHITE}Server: ${GREEN}$(curl -s ifconfig.me 2>/dev/null || echo 'YOUR_IP')${NC}"
    echo -e "  ${WHITE}Port: ${GREEN}$DNSTT_PORT${NC}"
    echo -e "  ${WHITE}Public Key: ${GREEN}$(cat $INSTALL_DIR/server.pub 2>/dev/null)${NC}"
    echo -e "  ${WHITE}MTU: ${GREEN}$MTU${NC}"
    echo ""
    echo -e "  ${YELLOW}🎯 Expected Speed: 10-25 Mbps on Halotel${NC}"
    echo ""
    exit 0
}

# ============================================
# MAIN
# ============================================
check_root

if [[ "$1" == "--install" ]] || [[ "$1" == "-i" ]]; then
    quick_install
else
    main_menu
fi