#!/bin/bash

##############################################
# SLOWDNS INSTALLER - Official123-12
# Created By STANY 👑 💯
##############################################

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

GITHUB_USER="Official123-12"
GITHUB_REPO="slowdns-ultra"
GITHUB_URL="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/main/slowdns.sh"

echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║     SLOWDNS ULTRA SPEED - INSTALLER                        ║${NC}"
echo -e "${CYAN}║     GitHub: ${GITHUB_USER}/${GITHUB_REPO}                    ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check root
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}❌ ERROR: Root privileges required${NC}"
    echo -e "${YELLOW}➜ Run: sudo bash $0${NC}"
    exit 1
fi

# Download script
echo -e "${YELLOW}📥 Downloading SlowDNS Ultra Speed...${NC}"

wget -q --show-progress -O /tmp/slowdns.sh "$GITHUB_URL"

if [[ $? -eq 0 ]]; then
    chmod +x /tmp/slowdns.sh
    
    # Move to /usr/local/bin
    mv /tmp/slowdns.sh /usr/local/bin/slowdns
    
    # Create aliases
    ln -sf /usr/local/bin/slowdns /usr/local/bin/menu 2>/dev/null
    ln -sf /usr/local/bin/slowdns /usr/local/bin/dnstt 2>/dev/null
    
    echo ""
    echo -e "${GREEN}✅ Installation successful!${NC}"
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${WHITE}Commands:${NC}"
    echo -e "  ${GREEN}slowdns${NC}   - Run SlowDNS Manager"
    echo -e "  ${GREEN}menu${NC}      - Quick menu access"
    echo -e "  ${GREEN}dnstt${NC}     - DNSTT Management"
    echo ""
    echo -e "${YELLOW}⚡ Quick Install:${NC} ${WHITE}slowdns --install${NC}"
    echo -e "${YELLOW}🎯 Target Speed:${NC} ${GREEN}10-25 Mbps on Halotel${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${YELLOW}Run: ${WHITE}slowdns${NC}"
    
else
    echo -e "${RED}❌ Download failed${NC}"
    echo -e "${YELLOW}Please check your internet connection${NC}"
    exit 1
fi
