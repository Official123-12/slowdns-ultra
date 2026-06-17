#!/bin/bash

##############################################
# SLOWDNS ULTRA SPEED - HALOTEL OPTIMIZED
# Created By STANY 👑 💯
# Version: 10.0.0 - PRODUCTION READY
# 100% WORKING - HALOTEL TANZANIA
# GitHub: Official123-12/slowdns-ultra
##############################################

# ============================================
# COLORS
# ============================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m'

# ============================================
# PATHS
# ============================================
INSTALL_DIR="/etc/slowdns"
LOG_DIR="/var/log/slowdns"
DNSTT_SERVER="/usr/local/bin/dnstt-server"
DNSTT_CLIENT="/usr/local/bin/dnstt-client"
USER_DB="$INSTALL_DIR/users.txt"

# ============================================
# BANNER
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
║              ╔══════════════════════════════════════════════╗                ║
║              ║   📦 Official123-12/slowdns-ultra          ║                ║
║              ╚══════════════════════════════════════════════╝                ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

print_header() {
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${WHITE}  $1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() { echo -e "  ${GREEN}✅ $1${NC}"; }
print_error() { echo -e "  ${RED}❌ $1${NC}"; }
print_info() { echo -e "  ${CYAN}ℹ️  $1${NC}"; }
print_warning() { echo -e "  ${YELLOW}⚠️  $1${NC}"; }
print_value() { printf "  ${WHITE}%-20s${NC} : ${GREEN}%s${NC}\n" "$1" "$2"; }
press_enter() { echo ""; read -p "  Press Enter to continue..."; }

check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}❌ ERROR: Root required${NC}"
        echo -e "${YELLOW}➜ Run: sudo bash $0${NC}"
        exit 1
    fi
}

# ============================================
# INSTALL DEPENDENCIES
# ============================================
install_deps() {
    print_header "📦 INSTALLING DEPENDENCIES"
    echo ""
    
    apt-get update -qq 2>/dev/null
    apt-get install -y wget curl git build-essential ca-certificates dnsutils net-tools iproute2 sysstat htop bc openssh-server iptables screen -qq 2>/dev/null
    
    print_success "Dependencies installed"
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
    
    wget -q "https://go.dev/dl/go1.22.4.linux-${GO_ARCH}.tar.gz" -O /tmp/go.tar.gz
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
# DOWNLOAD DNSTT
# ============================================
download_dnstt() {
    print_header "📥 DOWNLOADING DNSTT"
    echo ""
    
    ARCH=$(uname -m)
    
    rm -f "$DNSTT_SERVER" "$DNSTT_CLIENT"
    
    echo -e "${CYAN}  Downloading pre-built binaries...${NC}"
    
    if [[ "$ARCH" == "x86_64" ]]; then
        wget -q -O "$DNSTT_SERVER" "https://github.com/ekoops/dnstt/releases/latest/download/dnstt-server-linux-amd64" 2>/dev/null
        wget -q -O "$DNSTT_CLIENT" "https://github.com/ekoops/dnstt/releases/latest/download/dnstt-client-linux-amd64" 2>/dev/null
    elif [[ "$ARCH" == "aarch64" ]]; then
        wget -q -O "$DNSTT_SERVER" "https://github.com/ekoops/dnstt/releases/latest/download/dnstt-server-linux-arm64" 2>/dev/null
        wget -q -O "$DNSTT_CLIENT" "https://github.com/ekoops/dnstt/releases/latest/download/dnstt-client-linux-arm64" 2>/dev/null
    fi
    
    if [[ ! -f "$DNSTT_SERVER" ]] || [[ ! -s "$DNSTT_SERVER" ]]; then
        print_warning "Download failed, building from source..."
        
        export PATH=$PATH:/usr/local/go/bin
        export GOPATH=/root/go
        
        cd /tmp
        rm -rf dnstt-src
        
        git clone --depth 1 https://github.com/ekoops/dnstt.git dnstt-src 2>/dev/null
        
        cd dnstt-src/dnstt-server
        go build -o "$DNSTT_SERVER" .
        
        cd ../dnstt-client
        go build -o "$DNSTT_CLIENT" .
        
        cd /tmp
        rm -rf dnstt-src
    fi
    
    chmod +x "$DNSTT_SERVER" "$DNSTT_CLIENT"
    
    if [[ -f "$DNSTT_SERVER" ]] && [[ -s "$DNSTT_SERVER" ]]; then
        print_success "DNSTT installed successfully"
        print_value "Server" "$DNSTT_SERVER ($(du -sh $DNSTT_SERVER 2>/dev/null | cut -f1))"
        print_value "Client" "$DNSTT_CLIENT ($(du -sh $DNSTT_CLIENT 2>/dev/null | cut -f1))"
    else
        print_error "Failed to get DNSTT binaries"
        return 1
    fi
    
    sleep 1
    return 0
}

# ============================================
# CONFIGURE FIREWALL
# ============================================
configure_firewall() {
    print_header "🔥 CONFIGURING FIREWALL"
    echo ""
    
    if systemctl is-active --quiet systemd-resolved 2>/dev/null; then
        systemctl stop systemd-resolved 2>/dev/null
        systemctl disable systemd-resolved 2>/dev/null
        print_success "systemd-resolved stopped"
    fi
    
    iptables -F 2>/dev/null
    iptables -t nat -F 2>/dev/null
    
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT
    
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT
    iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    
    iptables -I INPUT 1 -p udp --dport 5300 -j ACCEPT
    iptables -I INPUT 2 -p udp --dport 53 -j ACCEPT
    iptables -t nat -I PREROUTING 1 -p udp --dport 53 -j REDIRECT --to-ports 5300
    
    iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    
    mkdir -p /etc/iptables
    iptables-save > /etc/iptables/rules.v4 2>/dev/null
    
    print_success "Firewall configured"
    print_info "UDP 53 → 5300 (DNSTT)"
    print_info "UDP 5300 (Server)"
    print_info "TCP 22 (SSH)"
    sleep 1
}

# ============================================
# OPTIMIZE SYSTEM - HALOTEL
# ============================================
optimize_system() {
    print_header "⚡ OPTIMIZING SYSTEM - HALOTEL"
    echo ""
    
    modprobe tcp_bbr 2>/dev/null
    
    sysctl -w net.ipv4.ip_forward=1 > /dev/null 2>&1
    sysctl -w net.ipv4.tcp_congestion_control=bbr > /dev/null 2>&1
    sysctl -w net.core.default_qdisc=fq > /dev/null 2>&1
    sysctl -w net.core.rmem_max=1073741824 > /dev/null 2>&1
    sysctl -w net.core.wmem_max=1073741824 > /dev/null 2>&1
    sysctl -w net.ipv4.udp_rmem_min=134217728 > /dev/null 2>&1
    sysctl -w net.ipv4.udp_wmem_min=134217728 > /dev/null 2>&1
    sysctl -w net.core.netdev_max_backlog=500000 > /dev/null 2>&1
    sysctl -w net.netfilter.nf_conntrack_max=8000000 > /dev/null 2>&1
    
    ulimit -n 2097152 2>/dev/null
    
    cat > /etc/security/limits.d/99-slowdns.conf << 'EOF'
* soft nofile 2097152
* hard nofile 2097152
root soft nofile 2097152
root hard nofile 2097152
EOF
    
    echo "nameserver 154.70.103.17" > /etc/resolv.conf
    echo "nameserver 154.70.103.18" >> /etc/resolv.conf
    echo "nameserver 8.8.8.8" >> /etc/resolv.conf
    
    IFACE=$(ip route | grep default | awk '{print $5}' | head -1)
    [[ -n "$IFACE" ]] && ip link set dev "$IFACE" mtu 1420 2>/dev/null
    
    print_success "System optimized for Halotel"
    print_info "BBR + FQ enabled"
    print_info "Halotel DNS configured"
    print_info "MTU 1420 set"
    print_info "1GB Network Buffers"
    print_info "8M Connection Tracking"
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
    
    rm -f server.key server.pub
    
    "$DNSTT_SERVER" -gen-key -privkey-file server.key -pubkey-file server.pub
    
    PUBKEY=$(cat server.pub)
    
    chmod 600 server.key
    chmod 644 server.pub
    
    print_success "Keys generated"
    print_value "Public Key" "$PUBKEY"
    sleep 1
}

# ============================================
# START DNSTT WITH SCREEN
# ============================================
start_dnstt() {
    local domain=$1
    
    print_header "🚀 STARTING DNSTT"
    echo ""
    
    pkill -f dnstt-server 2>/dev/null
    screen -X -S dnstt quit 2>/dev/null
    
    screen -dmS dnstt "$DNSTT_SERVER" -udp :5300 -privkey-file "$INSTALL_DIR/server.key" -mtu 1420 "$domain" 127.0.0.1:22
    
    sleep 2
    
    if pgrep -f dnstt-server > /dev/null; then
        PUBLIC_IP=$(curl -s ifconfig.me 2>/dev/null || echo "YOUR_IP")
        PUBKEY=$(cat "$INSTALL_DIR/server.pub" 2>/dev/null)
        
        echo ""
        echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║        ✅ SLOWDNS ULTRA SPEED IS RUNNING ✅              ║${NC}"
        echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        print_value "Server IP" "$PUBLIC_IP"
        print_value "Port" "5300"
        print_value "Public Key" "$PUBKEY"
        print_value "MTU" "1420 bytes"
        print_value "Speed Target" "10-25 Mbps"
        echo ""
        echo -e "  ${YELLOW}📱 CLIENT CONFIGURATION:${NC}"
        echo -e "  ${WHITE}Server: ${GREEN}$PUBLIC_IP${NC}"
        echo -e "  ${WHITE}Port: ${GREEN}5300${NC}"
        echo -e "  ${WHITE}Public Key: ${GREEN}$PUBKEY${NC}"
        echo ""
        print_success "Service is running via screen"
        print_info "To view: screen -r dnstt"
        print_info "To detach: Ctrl+A+D"
        
        cat > "$INSTALL_DIR/connection_info.txt" << EOF
═══════════════════════════════════════════════════════════════
  SLOWDNS ULTRA SPEED - HALOTEL OPTIMIZED
  Created By STANY 👑 💯
═══════════════════════════════════════════════════════════════

Server IP: $PUBLIC_IP
Port: 5300
Public Key: $PUBKEY
MTU: 1420
Speed Target: 10-25 Mbps

CLIENT CONFIGURATION:
Server: $PUBLIC_IP
Port: 5300
Public Key: $PUBKEY
MTU: 1420

DNS RECORDS NEEDED:
A Record: ns.yourdomain.com → $PUBLIC_IP
NS Record: t.yourdomain.com → ns.yourdomain.com

═══════════════════════════════════════════════════════════════
EOF
        
        return 0
    else
        print_error "Failed to start DNSTT"
        return 1
    fi
}

# ============================================
# STOP DNSTT
# ============================================
stop_dnstt() {
    print_header "⏹ STOPPING DNSTT"
    echo ""
    pkill -f dnstt-server 2>/dev/null
    screen -X -S dnstt quit 2>/dev/null
    print_success "DNSTT stopped"
    sleep 1
}

# ============================================
# STATUS
# ============================================
status_dnstt() {
    show_banner
    print_header "📊 SERVICE STATUS"
    echo ""
    
    if pgrep -f dnstt-server > /dev/null; then
        print_success "DNSTT: RUNNING"
        PID=$(pgrep -f dnstt-server | head -1)
        print_value "PID" "$PID"
        print_value "Port" "5300"
        print_value "MTU" "1420"
        print_value "Screen" "dnstt"
    else
        print_error "DNSTT: STOPPED"
    fi
    
    echo ""
    press_enter
}

# ============================================
# VIEW INFO
# ============================================
view_info() {
    show_banner
    print_header "📋 CONNECTION INFO"
    echo ""
    
    if [[ -f "$INSTALL_DIR/connection_info.txt" ]]; then
        cat "$INSTALL_DIR/connection_info.txt"
    else
        print_error "No info found. Run installation first."
    fi
    
    echo ""
    press_enter
}

# ============================================
# MAIN INSTALL
# ============================================
install_slowdns() {
    show_banner
    print_header "🚀 INSTALLING SLOWDNS ULTRA SPEED"
    echo ""
    
    install_deps
    install_go
    
    if ! download_dnstt; then
        print_error "DNSTT installation failed"
        press_enter
        return 1
    fi
    
    optimize_system
    configure_firewall
    generate_keys
    
    echo ""
    echo -e "${YELLOW}Enter tunnel domain (e.g., t.yourdomain.com):${NC}"
    echo -e "${CYAN}Default: t.slowdns.local${NC}"
    read -p "  Domain: " domain
    domain=${domain:-t.slowdns.local}
    
    if start_dnstt "$domain"; then
        echo ""
        echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
        echo -e "${GREEN}║        ✅ INSTALLATION COMPLETE! ✅                       ║${NC}"
        echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "  ${YELLOW}🎯 Expected Speed: 10-25 Mbps on Halotel${NC}"
        echo ""
    else
        print_error "Installation failed"
    fi
    
    press_enter
}

# ============================================
# ADD USER
# ============================================
add_user() {
    show_banner
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

# ============================================
# LIST USERS
# ============================================
list_users() {
    show_banner
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

# ============================================
# DELETE USER
# ============================================
delete_user() {
    show_banner
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
# UNINSTALL
# ============================================
uninstall() {
    show_banner
    print_header "🗑️ UNINSTALL"
    echo ""
    
    echo -e "${RED}⚠️  WARNING: This will remove everything${NC}"
    read -p "  Type 'yes' to confirm: " confirm
    
    [[ "$confirm" != "yes" ]] && { print_warning "Cancelled"; press_enter; return; }
    
    stop_dnstt
    rm -f "$DNSTT_SERVER" "$DNSTT_CLIENT"
    rm -rf "$INSTALL_DIR" "$LOG_DIR"
    rm -f /etc/iptables/rules.v4
    rm -f /etc/security/limits.d/99-slowdns.conf
    
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
        echo -e "  ${GREEN}1)${NC} 🚀 Install SlowDNS"
        echo -e "  ${GREEN}2)${NC} ▶  Start Service"
        echo -e "  ${YELLOW}3)${NC} ⏹  Stop Service"
        echo -e "  ${CYAN}4)${NC} 📊 Status"
        echo -e "  ${CYAN}5)${NC} 📋 Connection Info"
        echo -e "  ${BLUE}6)${NC} 👤 User Management"
        echo -e "  ${RED}7)${NC} 🗑️  Uninstall"
        echo -e "  ${WHITE}0)${NC} 🚪 Exit"
        echo ""
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${WHITE}Version: 10.0.0 | ${GREEN}Created By STANY 👑 💯${NC}"
        echo -e "${YELLOW}🎯 Target Speed: 10-25 Mbps on Halotel${NC}"
        echo -e "${CYAN}📦 GitHub: Official123-12/slowdns-ultra${NC}"
        echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""
        read -p "  Choice: " choice
        
        case $choice in
            1) install_slowdns ;;
            2) 
                echo ""
                read -p "  Enter tunnel domain: " domain
                domain=${domain:-t.slowdns.local}
                start_dnstt "$domain"
                press_enter
                ;;
            3)
                stop_dnstt
                press_enter
                ;;
            4)
                status_dnstt
                ;;
            5)
                view_info
                ;;
            6)
                while true; do
                    show_banner
                    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
                    echo -e "${CYAN}║                    USER MANAGEMENT                          ║${NC}"
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
            7)
                uninstall
                ;;
            0)
                echo -e "${GREEN}Goodbye!${NC}"
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
# MAIN
# ============================================
check_root

if [[ "$1" == "--install" ]] || [[ "$1" == "-i" ]]; then
    install_slowdns
else
    main_menu
fi
