#!/bin/bash

################################################################################
# Secure Access Point Setup Script
# Compatible with Ubuntu/Debian (x86_64 and ARM64/Raspberry Pi)
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m' # No Color

# Bright colors
BRIGHT_RED='\033[1;31m'
BRIGHT_GREEN='\033[1;32m'
BRIGHT_YELLOW='\033[1;33m'
BRIGHT_BLUE='\033[1;34m'
BRIGHT_PURPLE='\033[1;35m'
BRIGHT_CYAN='\033[1;36m'

# Background colors
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_PURPLE='\033[45m'
BG_CYAN='\033[46m'

# Configuration file
CONFIG_DIR="/etc/secure-ap"
CONFIG_FILE="${CONFIG_DIR}/config.conf"
PASSWORD_FILE="${CONFIG_DIR}/.admin_password"
HOSTAPD_CONF="/etc/hostapd/hostapd.conf"
DNSMASQ_CONF="/etc/dnsmasq.conf"

# Default values
DEFAULT_SSID="mdvsec"
DEFAULT_PASSWORD="SecurePass123"
DEFAULT_CHANNEL="6"
DEFAULT_FREQUENCY="2.4"
DEFAULT_INTERFACE="wlan0"

################################################################################
# Helper Functions
################################################################################

print_header() {
    clear
    echo ""
    echo -e "${BRIGHT_BLUE}███╗   ███╗${WHITE}██████╗${BRIGHT_YELLOW} ██╗   ██╗${BRIGHT_BLUE}███████╗${WHITE}███████╗${BRIGHT_YELLOW} ██████╗${NC}"
    echo -e "${BRIGHT_BLUE}████╗ ████║${WHITE}██╔══██╗${BRIGHT_YELLOW}██║   ██║${BRIGHT_BLUE}██╔════╝${WHITE}██╔════╝${BRIGHT_YELLOW}██╔════╝${NC}"
    echo -e "${BRIGHT_BLUE}██╔████╔██║${WHITE}██║  ██║${BRIGHT_YELLOW}██║   ██║${BRIGHT_BLUE}███████╗${WHITE}█████╗${BRIGHT_YELLOW}  ██║     ${NC}"
    echo -e "${BRIGHT_BLUE}██║╚██╔╝██║${WHITE}██║  ██║${BRIGHT_YELLOW}╚██╗ ██╔╝${BRIGHT_BLUE}╚════██║${WHITE}██╔══╝${BRIGHT_YELLOW}  ██║     ${NC}"
    echo -e "${BRIGHT_BLUE}██║ ╚═╝ ██║${WHITE}██████╔╝${BRIGHT_YELLOW} ╚████╔╝${BRIGHT_BLUE} ███████║${WHITE}███████╗${BRIGHT_YELLOW}╚██████╗${NC}"
    echo -e "${BRIGHT_BLUE}╚═╝     ╚═╝${WHITE}╚═════╝${BRIGHT_YELLOW}  ╚═══╝${BRIGHT_BLUE}  ╚══════╝${WHITE}╚══════╝${BRIGHT_YELLOW} ╚═════╝${NC}"
    echo ""
    echo -e "${BRIGHT_CYAN}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BRIGHT_CYAN}║${NC}  ${BRIGHT_PURPLE}⚡${NC} ${BOLD}${BRIGHT_GREEN}MDVSEC${NC} ${BRIGHT_BLUE}- Secure Access Point Tool${NC} ${BRIGHT_PURPLE}⚡${NC}     ${BRIGHT_CYAN}║${NC}"
    echo -e "${BRIGHT_CYAN}║${NC}   ${DIM}v1.4.0${NC} ${DIM}|${NC} ${DIM}Arch:${NC} ${CYAN}$(uname -m)${NC} ${DIM}|${NC} ${DIM}OS:${NC} ${CYAN}$(lsb_release -si)${NC}   ${BRIGHT_CYAN}║${NC}"
    echo -e "${BRIGHT_CYAN}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() {
    echo -e "${BRIGHT_GREEN}✓${NC} ${GREEN}$1${NC}"
}

print_error() {
    echo -e "${BRIGHT_RED}✗${NC} ${RED}$1${NC}"
}

print_warning() {
    echo -e "${BRIGHT_YELLOW}⚠${NC}  ${YELLOW}$1${NC}"
}

print_info() {
    echo -e "${BRIGHT_BLUE}ℹ${NC}  ${BLUE}$1${NC}"
}

print_banner() {
    local color=$1
    local text=$2
    echo -e "${color}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${color}│${NC}  ${BOLD}${text}${NC}"
    echo -e "${color}└─────────────────────────────────────────────────────────┘${NC}"
}

print_section() {
    local emoji=$1
    local text=$2
    echo ""
    echo -e "${BRIGHT_CYAN}╭─${NC} ${emoji}  ${BOLD}${BRIGHT_WHITE}${text}${NC}"
    echo -e "${BRIGHT_CYAN}╰─────────────────────────────────────────────────────${NC}"
}

print_box() {
    local color=$1
    local title=$2
    shift 2
    echo ""
    echo -e "${color}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${color}║${NC}  ${BOLD}${title}${NC}"
    echo -e "${color}╟───────────────────────────────────────────────────────╢${NC}"
    for line in "$@"; do
        echo -e "${color}║${NC}  $line"
    done
    echo -e "${color}╚═══════════════════════════════════════════════════════╝${NC}"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "This script must be run as root"
        exit 1
    fi
}

check_and_install_dependencies() {
    print_info "Checking dependencies..."

    local deps_needed=()

    # Check for essential tools
    command -v iw &>/dev/null || deps_needed+=("iw")
    command -v ip &>/dev/null || deps_needed+=("iproute2")
    command -v iptables &>/dev/null || deps_needed+=("iptables")
    command -v openssl &>/dev/null || deps_needed+=("openssl")
    command -v lsb_release &>/dev/null || deps_needed+=("lsb-release")

    # Check for DHCP client (dhclient or dhcpcd)
    if ! command -v dhclient &>/dev/null && ! command -v dhcpcd &>/dev/null; then
        deps_needed+=("isc-dhcp-client")
    fi

    if [[ ${#deps_needed[@]} -gt 0 ]]; then
        print_warning "Missing dependencies: ${deps_needed[*]}"
        print_info "Installing required packages..."

        export DEBIAN_FRONTEND=noninteractive
        apt-get update -qq
        apt-get install -y -qq "${deps_needed[@]}" 2>&1 | grep -v "^debconf:" || true

        print_success "Dependencies installed"
    else
        print_success "All dependencies present"
    fi
}

# Helper function to request DHCP (works with dhclient or dhcpcd)
request_dhcp() {
    local interface=$1

    if command -v dhclient &>/dev/null; then
        # Use dhclient
        dhclient -r "$interface" 2>/dev/null || true
        dhclient "$interface"
    elif command -v dhcpcd &>/dev/null; then
        # Use dhcpcd
        dhcpcd -k "$interface" 2>/dev/null || true
        dhcpcd "$interface"
    else
        print_error "No DHCP client found (dhclient or dhcpcd)"
        return 1
    fi
}

# Helper function to release DHCP
release_dhcp() {
    local interface=$1

    if command -v dhclient &>/dev/null; then
        dhclient -r "$interface" 2>/dev/null || true
    elif command -v dhcpcd &>/dev/null; then
        dhcpcd -k "$interface" 2>/dev/null || true
    fi
}

press_any_key() {
    echo ""
    read -n 1 -s -r -p "Press any key to continue..."
}

initialize_config() {
    mkdir -p "${CONFIG_DIR}"
    chmod 700 "${CONFIG_DIR}"

    if [[ ! -f "${CONFIG_FILE}" ]]; then
        cat > "${CONFIG_FILE}" << EOF
SSID=${DEFAULT_SSID}
PASSWORD=${DEFAULT_PASSWORD}
CHANNEL=${DEFAULT_CHANNEL}
FREQUENCY=${DEFAULT_FREQUENCY}
INTERFACE=${DEFAULT_INTERFACE}
DOH_SERVICE=cloudflare
WIREGUARD_ENABLED=false
EOF
        chmod 600 "${CONFIG_FILE}"
    fi

    if [[ ! -f "${PASSWORD_FILE}" ]]; then
        # Default admin password hash (default: admin123)
        echo 'admin123' | openssl passwd -6 -stdin > "${PASSWORD_FILE}"
        chmod 600 "${PASSWORD_FILE}"
    fi
}

load_config() {
    if [[ -f "${CONFIG_FILE}" ]]; then
        source "${CONFIG_FILE}"
    fi
}

save_config() {
    cat > "${CONFIG_FILE}" << EOF
SSID=${SSID}
PASSWORD=${PASSWORD}
CHANNEL=${CHANNEL}
FREQUENCY=${FREQUENCY}
INTERFACE=${INTERFACE}
DOH_SERVICE=${DOH_SERVICE}
WIREGUARD_ENABLED=${WIREGUARD_ENABLED}
EOF
    chmod 600 "${CONFIG_FILE}"
}

verify_admin_password() {
    local stored_hash=$(cat "${PASSWORD_FILE}")
    echo ""
    read -s -p "Enter admin password: " input_pass
    echo ""

    local input_hash=$(echo "$input_pass" | openssl passwd -6 -stdin -salt $(echo $stored_hash | cut -d'$' -f3))

    if [[ "$input_hash" != "$stored_hash" ]]; then
        print_error "Invalid password"
        sleep 2
        return 1
    fi
    return 0
}

################################################################################
# WiFi Setup Functions
################################################################################

list_wireless_interfaces() {
    print_info "Available wireless interfaces:"

    # Method 1: Try iw command
    if command -v iw &>/dev/null; then
        iw dev 2>/dev/null | awk '$1=="Interface"{print "  - "$2}'
    else
        # Method 2: Fallback to checking /sys/class/net
        for iface in /sys/class/net/*; do
            if [[ -d "$iface/wireless" ]] || [[ -L "$iface/phy80211" ]]; then
                echo "  - $(basename $iface)"
            fi
        done
    fi

    # Method 3: Additional fallback using iwconfig if available
    if command -v iwconfig &>/dev/null; then
        iwconfig 2>&1 | grep -o "^[a-z0-9]*" | while read iface; do
            if [[ "$iface" != "lo" ]] && iwconfig "$iface" 2>&1 | grep -q "IEEE 802.11"; then
                echo "  - $iface (detected via iwconfig)"
            fi
        done
    fi
}

################################################################################
# WiFi as WAN Functions
################################################################################

scan_wifi_networks() {
    local scan_interface=$1
    print_info "Scanning for available WiFi networks..."

    # Bring interface up
    ip link set "$scan_interface" up 2>/dev/null
    sleep 1

    # Scan networks
    if command -v nmcli &>/dev/null; then
        nmcli device wifi list 2>/dev/null || iw dev "$scan_interface" scan 2>/dev/null | grep -E "SSID|signal" | head -20
    else
        iw dev "$scan_interface" scan 2>/dev/null | grep -E "SSID|signal" | head -20
    fi
}

connect_to_wifi_wan() {
    print_header
    print_section "🌐" "Connect to WiFi Internet Source"
    echo ""

    load_config

    # Check if we need a separate interface for WAN
    print_info "You need a separate wireless interface for WiFi WAN"
    echo ""
    print_warning "Current AP interface: ${INTERFACE}"
    echo ""
    print_info "Available wireless interfaces:"

    # List all wireless interfaces
    local all_ifaces=()
    if command -v iw &>/dev/null; then
        while IFS= read -r iface; do
            all_ifaces+=("$iface")
            echo "  - $iface"
        done < <(iw dev 2>/dev/null | awk '$1=="Interface"{print $2}')
    fi

    if [[ ${#all_ifaces[@]} -lt 2 ]]; then
        print_error "You need at least 2 wireless interfaces!"
        echo ""
        print_info "Options:"
        echo "  1. Use a USB WiFi adapter for WAN"
        echo "  2. Use Ethernet for internet (current setup)"
        echo "  3. Get a dual-band adapter (one for AP, one for WAN)"
        press_any_key
        return
    fi

    echo ""
    read -p "Enter WAN interface name (not ${INTERFACE}): " wan_interface

    if [[ -z "$wan_interface" ]] || [[ "$wan_interface" == "$INTERFACE" ]]; then
        print_error "Invalid interface"
        sleep 2
        return
    fi

    # Check if interface exists
    if ! ip link show "$wan_interface" &>/dev/null; then
        print_error "Interface $wan_interface not found"
        sleep 2
        return
    fi

    # Scan for networks
    echo ""
    scan_wifi_networks "$wan_interface"

    echo ""
    read -p "Enter SSID to connect to: " wan_ssid

    if [[ -z "$wan_ssid" ]]; then
        print_error "SSID cannot be empty"
        sleep 2
        return
    fi

    read -s -p "Enter password (leave empty for open network): " wan_password
    echo ""

    # Stop NetworkManager if running on this interface
    if systemctl is-active --quiet NetworkManager; then
        print_info "Stopping NetworkManager on $wan_interface..."
        nmcli device set "$wan_interface" managed no 2>/dev/null || true
    fi

    # Create wpa_supplicant configuration
    print_info "Creating WiFi WAN configuration..."

    local wpa_conf="/etc/wpa_supplicant/wpa_supplicant-${wan_interface}.conf"

    if [[ -z "$wan_password" ]]; then
        # Open network
        cat > "$wpa_conf" << EOF
ctrl_interface=/var/run/wpa_supplicant
update_config=1

network={
    ssid="${wan_ssid}"
    key_mgmt=NONE
}
EOF
    else
        # Secured network
        wpa_passphrase "$wan_ssid" "$wan_password" > "$wpa_conf"
    fi

    chmod 600 "$wpa_conf"

    # Stop any existing wpa_supplicant on this interface
    killall wpa_supplicant 2>/dev/null || true
    pkill -f "wpa_supplicant.*${wan_interface}" 2>/dev/null || true
    sleep 1

    # Bring interface up
    ip link set "$wan_interface" up 2>/dev/null
    sleep 1

    # Start wpa_supplicant
    print_info "Connecting to ${wan_ssid}..."
    if ! wpa_supplicant -B -i "$wan_interface" -c "$wpa_conf" -D nl80211,wext; then
        print_error "Failed to start wpa_supplicant"
        print_info "Trying with different driver..."
        wpa_supplicant -B -i "$wan_interface" -c "$wpa_conf" -D wext
    fi

    # Wait for association
    print_info "Waiting for wireless association..."
    local timeout=15
    local count=0
    while [[ $count -lt $timeout ]]; do
        if iw dev "$wan_interface" link 2>/dev/null | grep -q "Connected"; then
            print_success "Associated with AP"
            break
        fi
        sleep 1
        ((count++))
        echo -n "."
    done
    echo ""

    if [[ $count -ge $timeout ]]; then
        print_error "Failed to associate with AP after ${timeout}s"
        echo ""
        print_info "Checking wpa_supplicant status..."
        iw dev "$wan_interface" link
        echo ""
        print_info "Possible issues:"
        echo "  - Wrong password"
        echo "  - WPA3/Enterprise network (not supported)"
        echo "  - Signal too weak"
        echo "  - Network out of range"
        echo ""
        print_info "Try again or check: sudo journalctl -xe | grep wpa"
        press_any_key
        return
    fi

    sleep 2

    # Request DHCP
    print_info "Requesting IP address..."
    request_dhcp "$wan_interface"

    sleep 3

    # Check connection
    if ip addr show "$wan_interface" | grep -q "inet "; then
        local wan_ip=$(ip -4 addr show "$wan_interface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
        print_success "Connected to ${wan_ssid}!"
        print_success "WAN IP: ${wan_ip}"

        # Save WAN configuration
        cat >> "${CONFIG_FILE}" << EOF

# WiFi as WAN
WIFI_WAN_ENABLED=true
WIFI_WAN_INTERFACE=${wan_interface}
WIFI_WAN_SSID=${wan_ssid}
EOF

        echo ""
        print_info "Testing internet connectivity..."
        if ping -c 2 -I "$wan_interface" 8.8.8.8 >/dev/null 2>&1; then
            print_success "Internet connection working!"
            echo ""

            # Automatically configure NAT for WiFi WAN
            print_info "Configuring NAT for WiFi WAN..."

            # Enable IP forwarding
            sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1

            # Clear old NAT rules
            iptables -t nat -F POSTROUTING 2>/dev/null || true
            iptables -F FORWARD 2>/dev/null || true

            # Add new NAT rules for WiFi WAN
            iptables -t nat -A POSTROUTING -o "$wan_interface" -j MASQUERADE
            iptables -A FORWARD -i "${INTERFACE}" -o "$wan_interface" -j ACCEPT
            iptables -A FORWARD -i "$wan_interface" -o "${INTERFACE}" -m state --state RELATED,ESTABLISHED -j ACCEPT
            iptables -P FORWARD ACCEPT

            # Save rules
            if command -v netfilter-persistent &>/dev/null; then
                netfilter-persistent save 2>/dev/null || true
            else
                mkdir -p /etc/iptables
                iptables-save > /etc/iptables/rules.v4 2>/dev/null || true
            fi

            print_success "NAT configured for ${wan_interface}!"
            echo ""
            print_info "Configuration:"
            echo "  AP Interface: ${INTERFACE}"
            echo "  Internet (WAN): ${wan_interface} (WiFi)"
            echo "  NAT: ${INTERFACE} → ${wan_interface}"
            echo ""

            # Test routing configuration
            echo ""
            print_info "Verifying routing configuration..."

            # Check if AP interface is configured
            if ! ip addr show "${INTERFACE}" 2>/dev/null | grep -q "192.168.4.1"; then
                print_warning "AP interface ${INTERFACE} not fully configured yet"
                print_info "Apply WiFi configuration first (option 6 in WiFi Setup)"
            else
                # Test routing from system
                print_info "Testing NAT routing..."
                if ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
                    print_success "✓ System can reach internet"

                    # Verify NAT rules
                    if iptables -t nat -L POSTROUTING -n | grep -q "$wan_interface"; then
                        print_success "✓ NAT rules configured correctly"
                    fi

                    # Verify FORWARD rules
                    if iptables -L FORWARD -n | grep -q "${INTERFACE}"; then
                        print_success "✓ FORWARD rules configured correctly"
                    fi

                    echo ""
                    print_success "✓ NAT Configuration Complete!"
                    print_info "Clients connecting to your AP should now have internet access"
                else
                    print_error "System cannot reach internet"
                    print_info "Check WAN connection: ping -I $wan_interface 8.8.8.8"
                fi
            fi
        else
            print_warning "Connected but no internet access"
            print_info "Check if the WiFi network has internet"
        fi

    else
        print_error "Failed to connect to ${wan_ssid}"
        print_info "Possible issues:"
        echo "  - Wrong password"
        echo "  - Network out of range"
        echo "  - Authentication failed"
    fi

    press_any_key
}

disconnect_wifi_wan() {
    print_header
    echo -e "${YELLOW}Disconnect WiFi WAN${NC}"
    echo "────────────────────────────────────────────────────────"
    echo ""

    load_config

    if [[ "${WIFI_WAN_ENABLED:-false}" != "true" ]]; then
        print_warning "WiFi WAN is not configured"
        press_any_key
        return
    fi

    local wan_interface="${WIFI_WAN_INTERFACE}"

    print_info "Disconnecting from ${WIFI_WAN_SSID}..."

    # Kill wpa_supplicant
    pkill -f "wpa_supplicant.*${wan_interface}" 2>/dev/null || true

    # Release DHCP
    release_dhcp "$wan_interface"

    # Bring interface down
    ip link set "$wan_interface" down 2>/dev/null || true

    # Remove configuration
    sed -i '/# WiFi as WAN/,/WIFI_WAN_SSID=/d' "${CONFIG_FILE}"

    print_success "WiFi WAN disconnected"

    press_any_key
}

view_wifi_wan_status() {
    print_header
    echo -e "${GREEN}WiFi WAN Status${NC}"
    echo "────────────────────────────────────────────────────────"
    echo ""

    load_config

    if [[ "${WIFI_WAN_ENABLED:-false}" != "true" ]]; then
        print_warning "WiFi WAN is not configured"
        echo ""
        print_info "To use WiFi as internet source:"
        echo "  1. You need 2 wireless interfaces"
        echo "  2. Use WiFi Setup → Connect to WiFi WAN"
        press_any_key
        return
    fi

    local wan_interface="${WIFI_WAN_INTERFACE}"
    local wan_ssid="${WIFI_WAN_SSID}"

    echo -e "${BLUE}Configuration:${NC}"
    echo "  Interface: $wan_interface"
    echo "  Connected to: $wan_ssid"
    echo ""

    echo -e "${BLUE}Connection Status:${NC}"
    if ip link show "$wan_interface" 2>/dev/null | grep -q "state UP"; then
        print_success "Interface is UP"

        if ip addr show "$wan_interface" | grep -q "inet "; then
            local wan_ip=$(ip -4 addr show "$wan_interface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
            print_success "IP Address: $wan_ip"

            # Check internet
            if ping -c 2 -I "$wan_interface" 8.8.8.8 >/dev/null 2>&1; then
                print_success "Internet: Working"
            else
                print_error "Internet: Not working"
            fi
        else
            print_error "No IP address assigned"
        fi
    else
        print_error "Interface is DOWN"
    fi

    echo ""
    echo -e "${BLUE}Signal Information:${NC}"
    iw dev "$wan_interface" link 2>/dev/null || print_warning "No connection info available"

    press_any_key
}

setup_wifi_menu() {
    while true; do
        print_header
        print_section "📡" "WiFi Setup Menu"
        load_config
        echo ""
        print_box "${CYAN}" "Current Configuration" \
            "📶 SSID:      ${BOLD}${BRIGHT_GREEN}${SSID}${NC}" \
            "🔌 Interface: ${BOLD}${BRIGHT_CYAN}${INTERFACE}${NC}" \
            "📻 Channel:   ${BOLD}${BRIGHT_YELLOW}${CHANNEL}${NC}" \
            "⚡ Frequency: ${BOLD}${BRIGHT_YELLOW}${FREQUENCY} GHz${NC}" \
            "🔑 Password:  ${BOLD}${BRIGHT_YELLOW}********${NC}"
        echo ""

        # Show WiFi WAN status if configured
        if [[ "${WIFI_WAN_ENABLED:-false}" == "true" ]]; then
            echo -e "  ${DIM}WiFi WAN:${NC} ${GREEN}Connected to ${WIFI_WAN_SSID}${NC} ${DIM}(${WIFI_WAN_INTERFACE})${NC}"
            echo ""
        fi

        echo -e "  ${DIM}Access Point Settings${NC}"
        echo -e "  ${BRIGHT_CYAN}1)${NC} ${CYAN}Change SSID${NC}"
        echo -e "  ${BRIGHT_CYAN}2)${NC} ${CYAN}Change Interface${NC}"
        echo -e "  ${BRIGHT_CYAN}3)${NC} ${CYAN}Change Channel${NC}"
        echo -e "  ${BRIGHT_CYAN}4)${NC} ${CYAN}Change Frequency (2.4 GHz / 5 GHz)${NC}"
        echo -e "  ${BRIGHT_CYAN}5)${NC} ${CYAN}Change Password${NC}"
        echo -e "  ${BRIGHT_CYAN}6)${NC} ${BRIGHT_GREEN}✓ Apply Configuration${NC}"
        echo ""
        echo -e "  ${DIM}Internet Source${NC}"
        echo -e "  ${BRIGHT_CYAN}7)${NC} ${BRIGHT_PURPLE}🌐 Connect to WiFi WAN${NC} ${DIM}(use WiFi for internet)${NC}"
        echo -e "  ${BRIGHT_CYAN}8)${NC} ${BRIGHT_PURPLE}📊 WiFi WAN Status${NC}"
        echo -e "  ${BRIGHT_CYAN}9)${NC} ${BRIGHT_PURPLE}❌ Disconnect WiFi WAN${NC}"
        echo ""
        echo -e "  ${DIM}Drivers & System${NC}"
        echo -e "  ${BRIGHT_CYAN}10)${NC} ${PURPLE}🔧 Check Wireless Drivers${NC}"
        echo -e "  ${BRIGHT_CYAN}11)${NC} ${YELLOW}← Back to Main Menu${NC}"
        echo ""
        echo -e "${BRIGHT_CYAN}╰─────────────────────────────────────────────────────${NC}"
        echo ""
        read -p "Select option: " wifi_choice

        case $wifi_choice in
            1) change_ssid ;;
            2) change_interface ;;
            3) change_channel ;;
            4) change_frequency ;;
            5) change_wifi_password ;;
            6) apply_wifi_configuration ;;
            7) connect_to_wifi_wan ;;
            8) view_wifi_wan_status ;;
            9) disconnect_wifi_wan ;;
            10) check_wireless_drivers ;;
            11) break ;;
            *) print_error "Invalid option" ; sleep 1 ;;
        esac
    done
}

change_ssid() {
    echo ""
    read -p "Enter new SSID (current: ${SSID}): " new_ssid
    if [[ -n "$new_ssid" ]]; then
        SSID="$new_ssid"
        save_config
        print_success "SSID updated to: ${SSID}"
    fi
    sleep 1
}

change_interface() {
    echo ""
    list_wireless_interfaces
    echo ""
    read -p "Enter wireless interface (current: ${INTERFACE}): " new_interface
    if [[ -n "$new_interface" ]]; then
        if ip link show "$new_interface" &> /dev/null; then
            INTERFACE="$new_interface"
            save_config
            print_success "Interface updated to: ${INTERFACE}"
        else
            print_error "Interface not found"
        fi
    fi
    sleep 2
}

change_channel() {
    echo ""
    if [[ "$FREQUENCY" == "2.4" ]]; then
        print_info "Valid channels for 2.4 GHz: 1-11 (US), 1-13 (EU)"
    else
        print_info "Valid channels for 5 GHz: 36, 40, 44, 48, 149, 153, 157, 161, 165"
    fi
    read -p "Enter channel (current: ${CHANNEL}): " new_channel
    if [[ -n "$new_channel" && "$new_channel" =~ ^[0-9]+$ ]]; then
        CHANNEL="$new_channel"
        save_config
        print_success "Channel updated to: ${CHANNEL}"
    fi
    sleep 1
}

change_frequency() {
    echo ""
    echo "1) 2.4 GHz (Better range, more compatible)"
    echo "2) 5 GHz (Faster speed, less interference)"
    read -p "Select frequency: " freq_choice

    case $freq_choice in
        1)
            FREQUENCY="2.4"
            CHANNEL="6"  # Default to channel 6 for 2.4 GHz
            ;;
        2)
            FREQUENCY="5"
            CHANNEL="36"  # Default to channel 36 for 5 GHz
            ;;
        *)
            print_error "Invalid option"
            sleep 1
            return
            ;;
    esac
    save_config
    print_success "Frequency updated to: ${FREQUENCY} GHz (Channel: ${CHANNEL})"
    sleep 1
}

change_wifi_password() {
    echo ""
    while true; do
        read -s -p "Enter new WiFi password (min 8 characters): " new_pass
        echo ""
        if [[ ${#new_pass} -lt 8 ]]; then
            print_error "Password must be at least 8 characters"
            continue
        fi
        read -s -p "Confirm password: " confirm_pass
        echo ""
        if [[ "$new_pass" == "$confirm_pass" ]]; then
            PASSWORD="$new_pass"
            save_config
            print_success "WiFi password updated"
            break
        else
            print_error "Passwords do not match"
        fi
    done
    sleep 1
}

check_wireless_drivers() {
    print_header
    echo -e "${GREEN}Wireless Driver Information${NC}"
    echo "────────────────────────────────────────────────────────"

    print_info "Checking wireless hardware..."
    echo ""

    if command -v lsusb &> /dev/null; then
        echo -e "${BLUE}USB Wireless Devices:${NC}"
        lsusb | grep -i wireless || echo "  No USB wireless devices found"
        echo ""
    fi

    echo -e "${BLUE}Wireless Network Interfaces:${NC}"
    if command -v iw &>/dev/null; then
        iw dev
    else
        print_warning "iw command not available, showing network interfaces:"
        ip link show | grep -E "wlan|wlp" || echo "  No wireless interfaces detected"
    fi
    echo ""

    echo -e "${BLUE}Loaded Wireless Drivers:${NC}"
    lsmod | grep -E "cfg80211|mac80211|ath|rtl|mt76|brcm" || echo "  No common wireless drivers loaded"
    echo ""

    echo -e "${BLUE}Driver Information for ${INTERFACE}:${NC}"
    if [[ -d "/sys/class/net/${INTERFACE}" ]]; then
        ethtool -i "${INTERFACE}" 2>/dev/null || print_warning "Unable to get driver info"
    else
        print_error "Interface ${INTERFACE} not found"
    fi
    echo ""

    echo -e "${BRIGHT_CYAN}Install/Update drivers:${NC}"
    echo -e "  ${BRIGHT_CYAN}1)${NC} ${CYAN}📦 Install common wireless drivers${NC}"
    echo -e "  ${BRIGHT_CYAN}2)${NC} ${CYAN}📦 Install Realtek drivers (RTL8188, RTL8192, etc.)${NC}"
    echo -e "  ${BRIGHT_CYAN}3)${NC} ${CYAN}📦 Install MediaTek drivers (MT76)${NC}"
    echo -e "  ${BRIGHT_CYAN}4)${NC} ${CYAN}📦 Install Atheros drivers${NC}"
    echo -e "  ${BRIGHT_CYAN}5)${NC} ${YELLOW}← Back${NC}"
    echo ""
    read -p "Select option: " driver_choice

    case $driver_choice in
        1) install_common_drivers ;;
        2) install_realtek_drivers ;;
        3) install_mediatek_drivers ;;
        4) install_atheros_drivers ;;
        5) return ;;
    esac
}

install_common_drivers() {
    print_info "Installing common wireless drivers..."
    apt-get update
    apt-get install -y firmware-linux firmware-linux-nonfree linux-firmware
    print_success "Common drivers installed"
    press_any_key
}

install_realtek_drivers() {
    print_info "Installing Realtek drivers..."
    apt-get install -y firmware-realtek rtl8192cu-dkms rtl8812au-dkms 2>/dev/null || \
        print_warning "Some Realtek drivers may not be available in repositories"
    print_success "Realtek drivers installation completed"
    press_any_key
}

install_mediatek_drivers() {
    print_info "Installing MediaTek drivers..."
    apt-get install -y firmware-misc-nonfree
    print_success "MediaTek drivers installed"
    press_any_key
}

install_atheros_drivers() {
    print_info "Installing Atheros drivers..."
    apt-get install -y firmware-atheros
    print_success "Atheros drivers installed"
    press_any_key
}

apply_wifi_configuration() {
    print_header
    print_info "Applying WiFi configuration..."

    # Install required packages
    print_info "Installing required packages..."
    apt-get update > /dev/null 2>&1
    apt-get install -y hostapd dnsmasq iptables iproute2 iw > /dev/null 2>&1

    # Stop conflicting services
    print_info "Stopping conflicting services..."
    systemctl stop hostapd dnsmasq 2>/dev/null || true
    systemctl stop systemd-resolved 2>/dev/null || true

    # Check for port conflicts
    if lsof -i :53 >/dev/null 2>&1; then
        print_warning "Port 53 is in use, attempting to free it..."
        fuser -k 53/tcp 2>/dev/null || true
        fuser -k 53/udp 2>/dev/null || true
        sleep 1
    fi

    # Configure hostapd
    print_info "Configuring hostapd..."

    local hw_mode="g"
    if [[ "$FREQUENCY" == "5" ]]; then
        hw_mode="a"
    fi

    cat > "${HOSTAPD_CONF}" << EOF
interface=${INTERFACE}
driver=nl80211
ssid=${SSID}
hw_mode=${hw_mode}
channel=${CHANNEL}
wmm_enabled=1
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=${PASSWORD}
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOF

    # Configure dnsmasq
    print_info "Configuring DHCP server..."

    # Backup existing dnsmasq.conf if it exists
    if [[ -f "${DNSMASQ_CONF}" ]]; then
        cp "${DNSMASQ_CONF}" "${DNSMASQ_CONF}.backup.$(date +%Y%m%d-%H%M%S)" 2>/dev/null || true
    fi

    cat > "${DNSMASQ_CONF}" << EOF
# Secure AP Configuration
interface=${INTERFACE}
bind-interfaces
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h
dhcp-option=3,192.168.4.1
dhcp-option=6,192.168.4.1
domain=local
address=/gw.local/192.168.4.1

# Don't read /etc/resolv.conf
no-resolv

# Use Google DNS as upstream (will be overridden by DoH if configured)
server=8.8.8.8
server=8.8.4.4

# Don't forward queries for plain names
domain-needed

# Don't forward reverse lookups for private IP ranges
bogus-priv

# Log queries for debugging (comment out in production)
# log-queries

# Cache size
cache-size=1000
EOF

    # Configure network interface
    print_info "Configuring network interface..."

    # Check if interface exists
    if ! ip link show "${INTERFACE}" &>/dev/null; then
        print_error "Interface ${INTERFACE} not found!"
        print_info "Available interfaces:"
        ip link show | grep -E "^[0-9]+:" | awk '{print "  - " $2}' | sed 's/:$//'
        press_any_key
        return 1
    fi

    ip link set "${INTERFACE}" down
    ip addr flush dev "${INTERFACE}"
    ip addr add 192.168.4.1/24 dev "${INTERFACE}"
    ip link set "${INTERFACE}" up

    # Wait for interface to be ready
    sleep 2

    # Enable IP forwarding
    echo 1 > /proc/sys/net/ipv4/ip_forward

    # Make IP forwarding persistent
    if ! grep -q "^net.ipv4.ip_forward=1" /etc/sysctl.conf 2>/dev/null; then
        echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    fi

    # Configure NAT
    print_info "Configuring NAT..."

    # Auto-detect internet interface
    INTERNET_IFACE=""
    for iface in $(ip -o link show | awk -F': ' '{print $2}' | grep -v "lo\|${INTERFACE}"); do
        if ip route show dev "$iface" 2>/dev/null | grep -q "default"; then
            INTERNET_IFACE="$iface"
            print_success "Detected internet interface: $INTERNET_IFACE"
            break
        fi
    done

    # Fallback to common interface names
    if [[ -z "$INTERNET_IFACE" ]]; then
        for iface in eth0 enp0s3 ens33 wlan1; do
            if ip link show "$iface" &>/dev/null; then
                INTERNET_IFACE="$iface"
                print_warning "Using fallback interface: $INTERNET_IFACE"
                break
            fi
        done
    fi

    if [[ -z "$INTERNET_IFACE" ]]; then
        print_error "Could not detect internet interface!"
        print_info "Available interfaces:"
        ip -brief link show | grep -v "lo\|${INTERFACE}"
        echo ""
        read -p "Enter internet interface name: " INTERNET_IFACE
    fi

    # Flush old rules
    iptables -t nat -F POSTROUTING 2>/dev/null || true
    iptables -F FORWARD 2>/dev/null || true

    # Configure NAT
    print_info "Setting up NAT: ${INTERFACE} → ${INTERNET_IFACE}"
    iptables -t nat -A POSTROUTING -o "${INTERNET_IFACE}" -j MASQUERADE

    # Configure forwarding rules
    iptables -A FORWARD -i "${INTERFACE}" -o "${INTERNET_IFACE}" -j ACCEPT
    iptables -A FORWARD -i "${INTERNET_IFACE}" -o "${INTERFACE}" -m state --state RELATED,ESTABLISHED -j ACCEPT

    # Set FORWARD policy to ACCEPT
    iptables -P FORWARD ACCEPT

    # Save iptables rules
    print_info "Saving iptables rules..."
    if command -v netfilter-persistent &>/dev/null; then
        netfilter-persistent save 2>/dev/null || true
        print_success "Rules saved with netfilter-persistent"
    else
        # Install iptables-persistent
        print_info "Installing iptables-persistent..."
        DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent >/dev/null 2>&1

        if [ $? -eq 0 ]; then
            # iptables-persistent creates the directory automatically
            netfilter-persistent save 2>/dev/null || iptables-save > /etc/iptables/rules.v4 2>/dev/null || true
            print_success "Rules saved"
        else
            # Fallback: create directory and save manually
            mkdir -p /etc/iptables
            iptables-save > /etc/iptables/rules.v4 2>/dev/null && print_success "Rules saved to /etc/iptables/rules.v4" || print_warning "Could not save iptables rules"
        fi
    fi

    print_success "NAT configured"

    # Start services
    print_info "Starting services..."
    systemctl unmask hostapd 2>/dev/null || true
    systemctl enable hostapd dnsmasq 2>&1 | grep -v "Synchronizing state" || true

    # Test dnsmasq configuration
    print_info "Testing dnsmasq configuration..."
    if dnsmasq --test -C "${DNSMASQ_CONF}" 2>&1 | grep -q "syntax check OK"; then
        print_success "dnsmasq configuration is valid"
    else
        print_error "dnsmasq configuration has errors:"
        dnsmasq --test -C "${DNSMASQ_CONF}"
        press_any_key
        return 1
    fi

    # Start dnsmasq
    print_info "Starting dnsmasq..."
    if systemctl start dnsmasq 2>&1; then
        print_success "dnsmasq started successfully"
    else
        print_error "Failed to start dnsmasq"
        print_info "Checking detailed error..."
        systemctl status dnsmasq --no-pager -l
        journalctl -u dnsmasq -n 20 --no-pager
        press_any_key
        return 1
    fi

    # Start hostapd
    print_info "Starting hostapd..."
    if systemctl start hostapd 2>&1; then
        print_success "hostapd started successfully"
    else
        print_error "Failed to start hostapd"
        print_info "Checking detailed error..."
        systemctl status hostapd --no-pager -l
        journalctl -u hostapd -n 20 --no-pager
        press_any_key
        return 1
    fi

    sleep 2

    # Verify services are running
    print_info "Verifying services..."
    local services_ok=true

    if systemctl is-active --quiet dnsmasq; then
        print_success "dnsmasq is running"
    else
        print_error "dnsmasq is not running"
        services_ok=false
    fi

    if systemctl is-active --quiet hostapd; then
        print_success "hostapd is running"
    else
        print_error "hostapd is not running"
        services_ok=false
    fi

    if [[ "$services_ok" == "true" ]]; then
        echo ""
        echo -e "${BRIGHT_GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
        echo -e "${BRIGHT_GREEN}║${NC}  ${BOLD}${BRIGHT_WHITE}🎉 Access Point is now running! 🎉${NC}              ${BRIGHT_GREEN}║${NC}"
        echo -e "${BRIGHT_GREEN}╠═══════════════════════════════════════════════════════╣${NC}"
        echo -e "${BRIGHT_GREEN}║${NC}                                                       ${BRIGHT_GREEN}║${NC}"
        echo -e "${BRIGHT_GREEN}║${NC}  ${CYAN}📡 SSID:${NC}     ${BOLD}${BRIGHT_YELLOW}${SSID}${NC}"
        echo -e "${BRIGHT_GREEN}║${NC}  ${CYAN}🔑 Password:${NC} ${BOLD}${BRIGHT_YELLOW}${PASSWORD}${NC}"
        echo -e "${BRIGHT_GREEN}║${NC}  ${CYAN}🌐 Gateway:${NC}  ${BOLD}${BRIGHT_YELLOW}192.168.4.1${NC}"
        echo -e "${BRIGHT_GREEN}║${NC}                                                       ${BRIGHT_GREEN}║${NC}"
        echo -e "${BRIGHT_GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
        echo ""
        echo -e "  ${BRIGHT_CYAN}✓${NC} ${DIM}Connect to the WiFi network and enjoy!${NC}"
    else
        echo ""
        echo -e "${BRIGHT_RED}╔═══════════════════════════════════════════════════════╗${NC}"
        echo -e "${BRIGHT_RED}║${NC}  ${BOLD}${WHITE}⚠️  Some services failed to start${NC}              ${BRIGHT_RED}║${NC}"
        echo -e "${BRIGHT_RED}╚═══════════════════════════════════════════════════════╝${NC}"
        echo ""
        print_info "Troubleshooting steps:"
        echo -e "  ${CYAN}1)${NC} Check logs: ${DIM}journalctl -u dnsmasq -n 50${NC}"
        echo -e "  ${CYAN}2)${NC} Check logs: ${DIM}journalctl -u hostapd -n 50${NC}"
        echo -e "  ${CYAN}3)${NC} Verify interface: ${DIM}ip link show ${INTERFACE}${NC}"
        echo -e "  ${CYAN}4)${NC} Check AP support: ${DIM}iw list | grep -A 10 'Supported interface modes'${NC}"
    fi

    press_any_key
}

################################################################################
# Security Menu Functions
################################################################################

security_menu() {
    while true; do
        print_header
        print_section "🔒" "Security Menu"
        load_config
        echo ""

        # Build status display with colors
        local doh_status="${YELLOW}${DOH_SERVICE:-not configured}${NC}"
        local wg_status="${YELLOW}${WIREGUARD_ENABLED:-false}${NC}"

        # Check Suricata status
        local suricata_status
        if systemctl is-active --quiet suricata 2>/dev/null; then
            suricata_status="${BG_GREEN}${WHITE} RUNNING ${NC}"
        else
            suricata_status="${BG_RED}${WHITE} STOPPED ${NC}"
        fi

        # Check Telegram notifications
        local telegram_status
        if [[ -f "${CONFIG_DIR}/.telegram_configured" ]]; then
            telegram_status="${BG_GREEN}${WHITE} CONFIGURED ${NC}"
        else
            telegram_status="${DIM}not configured${NC}"
        fi

        # Check SNMP
        local snmp_status
        if systemctl is-active --quiet snmpd 2>/dev/null; then
            snmp_status="${BG_GREEN}${WHITE} ENABLED ${NC}"
        else
            snmp_status="${BG_RED}${WHITE} DISABLED ${NC}"
        fi

        print_box "${PURPLE}" "Current Security Status" \
            "🔐 DoH Service:      ${doh_status}" \
            "🔒 WireGuard:        ${wg_status}" \
            "🛡️  Suricata IDS:     ${suricata_status}" \
            "📱 Telegram Alerts:  ${telegram_status}" \
            "📊 SNMP Monitoring:  ${snmp_status}"

        echo ""
        echo -e "  ${BRIGHT_CYAN}1)${NC} ${CYAN}🌐 Configure DNS over HTTPS (DoH)${NC}"
        echo -e "  ${BRIGHT_CYAN}2)${NC} ${CYAN}🔐 Setup WireGuard Client${NC}"
        echo -e "  ${BRIGHT_CYAN}3)${NC} ${CYAN}🔄 Enable/Disable WireGuard${NC}"
        echo -e "  ${BRIGHT_CYAN}4)${NC} ${CYAN}📋 View WireGuard Status${NC}"
        echo -e "  ${BRIGHT_CYAN}5)${NC} ${PURPLE}🔥 Configure Firewall Rules${NC}"
        echo -e "  ${BRIGHT_CYAN}6)${NC} ${BRIGHT_RED}🛡️  Setup Suricata IDS/IPS${NC}"
        echo -e "  ${BRIGHT_CYAN}7)${NC} ${BRIGHT_GREEN}📱 Configure Telegram Notifications${NC}"
        echo -e "  ${BRIGHT_CYAN}8)${NC} ${BRIGHT_YELLOW}📊 Setup SNMP Monitoring${NC}"
        echo -e "  ${BRIGHT_CYAN}9)${NC} ${YELLOW}← Back to Main Menu${NC}"
        echo ""
        echo -e "${BRIGHT_CYAN}╰─────────────────────────────────────────────────────${NC}"
        echo ""
        read -p "Select option: " sec_choice

        case $sec_choice in
            1) configure_doh ;;
            2) setup_wireguard ;;
            3) toggle_wireguard ;;
            4) view_wireguard_status ;;
            5) configure_firewall ;;
            6) setup_suricata ;;
            7) configure_telegram ;;
            8) setup_snmp ;;
            9) break ;;
            *) print_error "Invalid option" ; sleep 1 ;;
        esac
    done
}

configure_doh() {
    print_header
    echo -e "${GREEN}Configure DNS over HTTPS (DoH)${NC}"
    echo "────────────────────────────────────────────────────────"
    echo "1) Cloudflare (1.1.1.1)"
    echo "2) Google (8.8.8.8)"
    echo "3) Quad9 (9.9.9.9)"
    echo "4) AdGuard (94.140.14.14)"
    echo "5) Custom"
    echo ""
    read -p "Select DoH provider: " doh_choice

    case $doh_choice in
        1) DOH_SERVICE="cloudflare" ; DOH_URL="https://1.1.1.1/dns-query" ;;
        2) DOH_SERVICE="google" ; DOH_URL="https://dns.google/dns-query" ;;
        3) DOH_SERVICE="quad9" ; DOH_URL="https://dns.quad9.net/dns-query" ;;
        4) DOH_SERVICE="adguard" ; DOH_URL="https://dns.adguard.com/dns-query" ;;
        5)
            read -p "Enter DoH URL: " DOH_URL
            DOH_SERVICE="custom"
            ;;
        *)
            print_error "Invalid option"
            sleep 1
            return
            ;;
    esac

    save_config

    print_info "Installing cloudflared..."
    if ! command -v cloudflared &> /dev/null; then
        # Install cloudflared
        wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-$(dpkg --print-architecture) -O /usr/local/bin/cloudflared
        chmod +x /usr/local/bin/cloudflared
    fi

    # Configure cloudflared
    print_info "Configuring DoH proxy..."
    mkdir -p /etc/cloudflared
    cat > /etc/cloudflared/config.yml << EOF
proxy-dns: true
proxy-dns-port: 5053
proxy-dns-upstream:
  - ${DOH_URL}
EOF

    # Create systemd service
    cat > /etc/systemd/system/cloudflared.service << EOF
[Unit]
Description=cloudflared DNS over HTTPS proxy
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/cloudflared proxy-dns --config /etc/cloudflared/config.yml
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable cloudflared
    systemctl restart cloudflared

    # Update dnsmasq to use DoH
    if grep -q "server=127.0.0.1#5053" "${DNSMASQ_CONF}"; then
        print_info "dnsmasq already configured for DoH"
    else
        echo "server=127.0.0.1#5053" >> "${DNSMASQ_CONF}"
        echo "no-resolv" >> "${DNSMASQ_CONF}"
        systemctl restart dnsmasq
    fi

    print_success "DoH configured with ${DOH_SERVICE}"
    press_any_key
}

setup_wireguard() {
    print_header
    echo -e "${GREEN}Setup WireGuard Client${NC}"
    echo "────────────────────────────────────────────────────────"

    print_info "Installing WireGuard..."
    apt-get install -y wireguard wireguard-tools resolvconf

    echo ""
    echo "Please provide your WireGuard configuration:"
    echo "1) Import from file"
    echo "2) Manual configuration"
    echo ""
    read -p "Select option: " wg_choice

    case $wg_choice in
        1)
            read -p "Enter path to WireGuard config file (.conf): " wg_file
            if [[ -f "$wg_file" ]]; then
                cp "$wg_file" /etc/wireguard/wg0.conf
                chmod 600 /etc/wireguard/wg0.conf
                print_success "WireGuard configuration imported"
            else
                print_error "File not found"
                press_any_key
                return
            fi
            ;;
        2)
            read -p "Enter WireGuard server endpoint (IP:PORT): " wg_endpoint
            read -p "Enter your private key: " wg_private_key
            read -p "Enter server public key: " wg_public_key
            read -p "Enter allowed IPs (default: 0.0.0.0/0): " wg_allowed
            wg_allowed=${wg_allowed:-0.0.0.0/0}

            cat > /etc/wireguard/wg0.conf << EOF
[Interface]
PrivateKey = ${wg_private_key}
Address = 10.0.0.2/24
DNS = 1.1.1.1

[Peer]
PublicKey = ${wg_public_key}
Endpoint = ${wg_endpoint}
AllowedIPs = ${wg_allowed}
PersistentKeepalive = 25
EOF
            chmod 600 /etc/wireguard/wg0.conf
            print_success "WireGuard configuration created"
            ;;
    esac

    WIREGUARD_ENABLED=true
    save_config

    print_info "Starting WireGuard..."
    systemctl enable wg-quick@wg0
    systemctl start wg-quick@wg0

    sleep 2
    if systemctl is-active --quiet wg-quick@wg0; then
        print_success "WireGuard is running"
    else
        print_error "Failed to start WireGuard"
    fi

    press_any_key
}

toggle_wireguard() {
    if [[ "$WIREGUARD_ENABLED" == "true" ]]; then
        systemctl stop wg-quick@wg0
        systemctl disable wg-quick@wg0
        WIREGUARD_ENABLED=false
        print_success "WireGuard disabled"
    else
        systemctl enable wg-quick@wg0
        systemctl start wg-quick@wg0
        WIREGUARD_ENABLED=true
        print_success "WireGuard enabled"
    fi
    save_config
    sleep 1
}

view_wireguard_status() {
    print_header
    echo -e "${GREEN}WireGuard Status${NC}"
    echo "────────────────────────────────────────────────────────"

    if systemctl is-active --quiet wg-quick@wg0; then
        print_success "WireGuard is running"
        echo ""
        wg show
    else
        print_warning "WireGuard is not running"
    fi

    press_any_key
}

configure_firewall() {
    print_header
    echo -e "${GREEN}Firewall Configuration${NC}"
    echo "────────────────────────────────────────────────────────"

    print_info "Installing ufw..."
    apt-get install -y ufw

    print_info "Configuring basic firewall rules..."
    ufw --force disable
    ufw --force reset

    # Allow SSH
    ufw allow 22/tcp

    # Allow DNS
    ufw allow 53

    # Allow DHCP
    ufw allow 67/udp
    ufw allow 68/udp

    # Allow WireGuard
    ufw allow 51820/udp

    # Enable forwarding
    sed -i 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw

    ufw --force enable

    print_success "Firewall configured and enabled"
    press_any_key
}

setup_suricata() {
    print_header
    echo -e "${GREEN}Suricata IDS/IPS Setup${NC}"
    echo "────────────────────────────────────────────────────────"

    load_config

    # Check if already installed
    if command -v suricata &>/dev/null; then
        print_info "Suricata is already installed"
        if systemctl is-active --quiet suricata; then
            print_success "Suricata is running"
        else
            print_warning "Suricata is installed but not running"
        fi
        echo ""
        echo "1) Reconfigure Suricata"
        echo "2) View Suricata Status"
        echo "3) View Alerts"
        echo "4) Start/Stop Suricata"
        echo "5) Update Rules"
        echo "6) Back"
        echo ""
        read -p "Select option: " suri_opt

        case $suri_opt in
            1) ;; # Continue with setup
            2)
                systemctl status suricata --no-pager
                press_any_key
                return
                ;;
            3)
                if [[ -f /var/log/suricata/fast.log ]]; then
                    tail -50 /var/log/suricata/fast.log
                else
                    print_warning "No alerts found"
                fi
                press_any_key
                return
                ;;
            4)
                if systemctl is-active --quiet suricata; then
                    systemctl stop suricata
                    print_success "Suricata stopped"
                else
                    systemctl start suricata
                    print_success "Suricata started"
                fi
                sleep 1
                return
                ;;
            5)
                print_info "Updating Suricata rules..."
                suricata-update
                systemctl restart suricata
                print_success "Rules updated and Suricata restarted"
                press_any_key
                return
                ;;
            6) return ;;
        esac
    fi

    print_info "Installing Suricata..."
    apt-get update -qq
    apt-get install -y suricata suricata-update jq

    print_success "Suricata installed"

    # Configure Suricata
    print_info "Configuring Suricata for access point..."

    # Backup original config
    if [[ -f /etc/suricata/suricata.yaml ]]; then
        cp /etc/suricata/suricata.yaml /etc/suricata/suricata.yaml.backup
    fi

    # Configure interface
    print_info "Configuring interface: ${INTERFACE}"
    sed -i "s/interface: .*/interface: ${INTERFACE}/" /etc/suricata/suricata.yaml

    # Set home network
    sed -i "s/HOME_NET:.*/HOME_NET: \"[192.168.4.0\/24]\"/" /etc/suricata/suricata.yaml

    # Enable IPS mode (optional)
    echo ""
    read -p "Enable IPS mode (block threats)? (y/n): " enable_ips
    if [[ "$enable_ips" == "y" ]]; then
        print_info "Configuring IPS mode..."
        # Note: IPS mode requires more complex setup with nfqueue
        print_warning "IPS mode requires additional configuration"
        print_info "Running in IDS mode (detection only)"
    fi

    # Update rules
    print_info "Downloading Suricata rules..."
    suricata-update

    # Configure logging
    print_info "Configuring logging..."
    mkdir -p /var/log/suricata

    # Check if suricata user exists, if not create it
    if ! id -u suricata &>/dev/null; then
        print_info "Creating suricata user..."
        useradd -r -s /usr/sbin/nologin -M suricata 2>/dev/null || true
    fi

    # Set ownership if suricata user exists
    if id -u suricata &>/dev/null; then
        chown -R suricata:suricata /var/log/suricata
    else
        print_warning "Suricata user not found, skipping ownership change"
    fi

    # Enable and start service
    systemctl enable suricata
    systemctl start suricata

    sleep 2

    if systemctl is-active --quiet suricata; then
        print_success "Suricata is running!"
        echo ""
        print_info "Configuration:"
        echo "  Interface: ${INTERFACE}"
        echo "  Home Network: 192.168.4.0/24"
        echo "  Mode: IDS (detection)"
        echo "  Logs: /var/log/suricata/"
        echo ""
        print_info "View alerts with:"
        echo "  tail -f /var/log/suricata/fast.log"
        echo ""
        print_info "Update rules with:"
        echo "  sudo suricata-update && sudo systemctl restart suricata"
    else
        print_error "Failed to start Suricata"
        print_info "Check logs: sudo journalctl -u suricata -n 50"
    fi

    press_any_key
}

configure_telegram() {
    print_header
    echo -e "${GREEN}Telegram Notifications Setup${NC}"
    echo "────────────────────────────────────────────────────────"

    # Check if already configured
    if [[ -f "${CONFIG_DIR}/.telegram_configured" ]]; then
        source "${CONFIG_DIR}/.telegram_configured"
        print_info "Telegram is already configured"
        echo "  Bot Token: ${TELEGRAM_BOT_TOKEN:0:10}..."
        echo "  Chat ID: ${TELEGRAM_CHAT_ID}"
        echo ""
        echo "1) Reconfigure"
        echo "2) Test Notification"
        echo "3) Enable/Disable Notifications"
        echo "4) View Notification Log"
        echo "5) Back"
        echo ""
        read -p "Select option: " tg_opt

        case $tg_opt in
            1) ;; # Continue with setup
            2)
                send_telegram_message "🔔 Test notification from MDVSEC Access Point"
                press_any_key
                return
                ;;
            3)
                if [[ "${TELEGRAM_ENABLED}" == "true" ]]; then
                    sed -i 's/TELEGRAM_ENABLED=true/TELEGRAM_ENABLED=false/' "${CONFIG_DIR}/.telegram_configured"
                    print_success "Telegram notifications disabled"
                else
                    sed -i 's/TELEGRAM_ENABLED=false/TELEGRAM_ENABLED=true/' "${CONFIG_DIR}/.telegram_configured"
                    print_success "Telegram notifications enabled"
                fi
                sleep 1
                return
                ;;
            4)
                if [[ -f /var/log/telegram-notify.log ]]; then
                    tail -50 /var/log/telegram-notify.log
                else
                    print_warning "No notification log found"
                fi
                press_any_key
                return
                ;;
            5) return ;;
        esac
    fi

    echo ""
    print_info "To use Telegram notifications, you need:"
    echo "  1. Create a Telegram bot with @BotFather"
    echo "  2. Get your Chat ID from @userinfobot"
    echo ""
    echo "Instructions:"
    echo "  1. Open Telegram and search for @BotFather"
    echo "  2. Send /newbot and follow instructions"
    echo "  3. Copy the bot token"
    echo "  4. Search for @userinfobot"
    echo "  5. Send /start to get your Chat ID"
    echo ""
    read -p "Continue with setup? (y/n): " continue_tg
    if [[ "$continue_tg" != "y" ]]; then
        return
    fi

    echo ""
    read -p "Enter your Telegram Bot Token: " bot_token
    read -p "Enter your Telegram Chat ID: " chat_id

    # Validate inputs
    if [[ -z "$bot_token" ]] || [[ -z "$chat_id" ]]; then
        print_error "Bot token and Chat ID are required"
        press_any_key
        return
    fi

    # Test the bot
    print_info "Testing Telegram bot..."
    test_response=$(curl -s -X POST "https://api.telegram.org/bot${bot_token}/sendMessage" \
        -d chat_id="${chat_id}" \
        -d text="✅ MDVSEC: Telegram notifications configured successfully!")

    if echo "$test_response" | grep -q '"ok":true'; then
        print_success "Telegram bot is working!"

        # Save configuration
        cat > "${CONFIG_DIR}/.telegram_configured" << EOF
TELEGRAM_BOT_TOKEN="${bot_token}"
TELEGRAM_CHAT_ID="${chat_id}"
TELEGRAM_ENABLED=true
EOF
        chmod 600 "${CONFIG_DIR}/.telegram_configured"

        # Create notification script
        create_telegram_notify_script

        # Setup client connection monitoring
        setup_client_monitoring

        print_success "Telegram notifications configured!"
        echo ""
        print_info "Notifications will be sent when:"
        echo "  • New client connects to AP"
        echo "  • Client disconnects from AP"
        echo "  • Suricata detects threats (if enabled)"
    else
        print_error "Failed to send test message"
        print_warning "Please check your bot token and chat ID"
    fi

    press_any_key
}

send_telegram_message() {
    local message="$1"

    if [[ ! -f "${CONFIG_DIR}/.telegram_configured" ]]; then
        return
    fi

    source "${CONFIG_DIR}/.telegram_configured"

    if [[ "${TELEGRAM_ENABLED}" != "true" ]]; then
        return
    fi

    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d chat_id="${TELEGRAM_CHAT_ID}" \
        -d text="${message}" \
        -d parse_mode="HTML" >> /var/log/telegram-notify.log 2>&1 &
}

create_telegram_notify_script() {
    cat > /usr/local/bin/mdvsec-notify << 'EOF'
#!/bin/bash
CONFIG_FILE="/etc/secure-ap/.telegram_configured"

if [[ ! -f "$CONFIG_FILE" ]]; then
    exit 0
fi

source "$CONFIG_FILE"

if [[ "${TELEGRAM_ENABLED}" != "true" ]]; then
    exit 0
fi

send_message() {
    local message="$1"
    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d chat_id="${TELEGRAM_CHAT_ID}" \
        -d text="${message}" \
        -d parse_mode="HTML" >> /var/log/telegram-notify.log 2>&1
}

# Main
MESSAGE="$1"
send_message "$MESSAGE"
EOF

    chmod +x /usr/local/bin/mdvsec-notify
}

setup_client_monitoring() {
    # Create systemd service to monitor DHCP leases
    cat > /etc/systemd/system/mdvsec-client-monitor.service << EOF
[Unit]
Description=MDVSEC Client Connection Monitor
After=network.target dnsmasq.service

[Service]
Type=simple
ExecStart=/usr/local/bin/mdvsec-monitor-clients
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

    # Create monitoring script
    cat > /usr/local/bin/mdvsec-monitor-clients << 'EOF'
#!/bin/bash

LEASE_FILE="/var/lib/misc/dnsmasq.leases"
STATE_FILE="/var/run/mdvsec-clients.state"

touch "$STATE_FILE"

while true; do
    if [[ -f "$LEASE_FILE" ]]; then
        current_macs=$(awk '{print $2}' "$LEASE_FILE" | sort)
        previous_macs=$(cat "$STATE_FILE" 2>/dev/null || echo "")

        # Check for new connections
        while read -r mac; do
            if [[ -n "$mac" ]] && ! echo "$previous_macs" | grep -q "$mac"; then
                # New client connected
                ip=$(grep "$mac" "$LEASE_FILE" | awk '{print $3}')
                hostname=$(grep "$mac" "$LEASE_FILE" | awk '{print $4}')
                /usr/local/bin/mdvsec-notify "🟢 <b>New Client Connected</b>%0A📱 Device: ${hostname:-Unknown}%0A🔗 MAC: ${mac}%0A🌐 IP: ${ip}"
            fi
        done <<< "$current_macs"

        # Check for disconnections
        while read -r mac; do
            if [[ -n "$mac" ]] && ! echo "$current_macs" | grep -q "$mac"; then
                # Client disconnected
                /usr/local/bin/mdvsec-notify "🔴 <b>Client Disconnected</b>%0A🔗 MAC: ${mac}"
            fi
        done <<< "$previous_macs"

        echo "$current_macs" > "$STATE_FILE"
    fi

    sleep 5
done
EOF

    chmod +x /usr/local/bin/mdvsec-monitor-clients

    # Enable and start the service
    systemctl daemon-reload
    systemctl enable mdvsec-client-monitor
    systemctl start mdvsec-client-monitor

    print_success "Client monitoring service installed"
}

setup_snmp() {
    print_header
    echo -e "${GREEN}SNMP Monitoring Setup${NC}"
    echo "────────────────────────────────────────────────────────"

    # Check if already installed
    if command -v snmpd &>/dev/null; then
        print_info "SNMP is already installed"
        if systemctl is-active --quiet snmpd; then
            print_success "SNMP is running"
        else
            print_warning "SNMP is installed but not running"
        fi
        echo ""
        echo "1) Reconfigure SNMP"
        echo "2) View SNMP Status"
        echo "3) Test SNMP"
        echo "4) Start/Stop SNMP"
        echo "5) Back"
        echo ""
        read -p "Select option: " snmp_opt

        case $snmp_opt in
            1) ;; # Continue with setup
            2)
                systemctl status snmpd --no-pager
                echo ""
                echo "SNMP Configuration:"
                grep -v "^#" /etc/snmp/snmpd.conf | grep -v "^$"
                press_any_key
                return
                ;;
            3)
                print_info "Testing SNMP..."
                snmpwalk -v2c -c public localhost system
                press_any_key
                return
                ;;
            4)
                if systemctl is-active --quiet snmpd; then
                    systemctl stop snmpd
                    print_success "SNMP stopped"
                else
                    systemctl start snmpd
                    print_success "SNMP started"
                fi
                sleep 1
                return
                ;;
            5) return ;;
        esac
    fi

    print_info "Installing SNMP..."
    apt-get update -qq
    apt-get install -y snmpd snmp libsnmp-dev

    print_success "SNMP installed"

    # Get community string
    echo ""
    read -p "Enter SNMP community string (default: public): " community
    community=${community:-public}

    read -p "Allow SNMP access from network (e.g., 192.168.4.0/24): " allowed_network
    allowed_network=${allowed_network:-192.168.4.0/24}

    # Backup original config
    cp /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf.backup

    # Create new configuration
    cat > /etc/snmp/snmpd.conf << EOF
# MDVSEC SNMP Configuration
agentAddress udp:161

# Community string
rocommunity ${community} ${allowed_network}

# System information
sysLocation    MDVSEC Access Point
sysContact     admin@mdvsec.local
sysName        MDVSEC-AP

# Process monitoring
proc dnsmasq
proc hostapd

# Disk monitoring
disk / 10%

# Load monitoring
load 12 10 5

# Network monitoring
interface wlan0
interface eth0

# Enable built-in MIBs
view systemonly included .1.3.6.1.2.1.1
view systemonly included .1.3.6.1.2.1.25.1

# Extend with custom OIDs
extend uptime /bin/cat /proc/uptime
extend clients /usr/local/bin/count-ap-clients
EOF

    # Create script to count connected clients
    cat > /usr/local/bin/count-ap-clients << 'EOF'
#!/bin/bash
if [[ -f /var/lib/misc/dnsmasq.leases ]]; then
    wc -l < /var/lib/misc/dnsmasq.leases
else
    echo 0
fi
EOF
    chmod +x /usr/local/bin/count-ap-clients

    # Restart SNMP
    systemctl restart snmpd
    systemctl enable snmpd

    sleep 2

    if systemctl is-active --quiet snmpd; then
        print_success "SNMP is running!"
        echo ""
        print_info "Configuration:"
        echo "  Community: ${community}"
        echo "  Listen: UDP port 161"
        echo "  Allowed: ${allowed_network}"
        echo ""
        print_info "Test with:"
        echo "  snmpwalk -v2c -c ${community} localhost system"
        echo ""
        print_info "Monitor from remote:"
        echo "  snmpwalk -v2c -c ${community} <AP-IP> system"
        echo ""
        print_info "Available custom OIDs:"
        echo "  • Connected clients count"
        echo "  • System uptime"
        echo "  • Process status (hostapd, dnsmasq)"
    else
        print_error "Failed to start SNMP"
        print_info "Check logs: sudo journalctl -u snmpd -n 50"
    fi

    press_any_key
}

################################################################################
# WAN Failover Functions
################################################################################

configure_wan_failover() {
    print_header
    echo -e "${BRIGHT_PURPLE}WAN Failover Configuration${NC}"
    echo "────────────────────────────────────────────────────────"
    echo ""

    print_info "WAN Failover automatically switches between internet sources"
    print_info "when the current WAN interface fails (Ethernet, WiFi WAN, etc.)"
    echo ""

    # Check if failover daemon script exists
    if [[ ! -f "/usr/local/bin/mdvsec-wan-failover.sh" ]] && [[ ! -f "$(dirname "$0")/mdvsec-wan-failover.sh" ]]; then
        print_error "Failover daemon script not found!"
        print_info "Please ensure mdvsec-wan-failover.sh is installed"
        press_any_key
        return
    fi

    # Load current config
    load_config

    echo -e "${BLUE}Current Status:${NC}"
    if systemctl is-active --quiet mdvsec-failover 2>/dev/null; then
        print_success "Failover daemon: RUNNING"
    else
        print_warning "Failover daemon: STOPPED"
    fi

    if [[ "${FAILOVER_ENABLED:-false}" == "true" ]]; then
        print_success "Failover: ENABLED"
    else
        print_warning "Failover: DISABLED"
    fi
    echo ""

    echo -e "${BRIGHT_CYAN}Failover Options:${NC}"
    echo -e "  ${BRIGHT_CYAN}1)${NC} Enable/Disable Failover"
    echo -e "  ${BRIGHT_CYAN}2)${NC} Start Failover Daemon"
    echo -e "  ${BRIGHT_CYAN}3)${NC} Stop Failover Daemon"
    echo -e "  ${BRIGHT_CYAN}4)${NC} View Failover Status"
    echo -e "  ${BRIGHT_CYAN}5)${NC} Scan WAN Interfaces"
    echo -e "  ${BRIGHT_CYAN}6)${NC} View Failover Logs"
    echo -e "  ${BRIGHT_CYAN}7)${NC} Configure Check Interval"
    echo -e "  ${BRIGHT_CYAN}8)${NC} ← Back"
    echo ""
    read -p "Select option: " failover_choice

    case $failover_choice in
        1) toggle_failover ;;
        2) start_failover_daemon ;;
        3) stop_failover_daemon ;;
        4) view_failover_status ;;
        5) scan_wan_interfaces_menu ;;
        6) view_failover_logs ;;
        7) configure_check_interval ;;
        8) return ;;
        *) print_error "Invalid option" ; sleep 1 ;;
    esac
}

toggle_failover() {
    load_config

    if [[ "${FAILOVER_ENABLED:-false}" == "true" ]]; then
        # Disable
        sed -i '/^FAILOVER_ENABLED=/d' "${CONFIG_FILE}" 2>/dev/null || true
        echo "FAILOVER_ENABLED=false" >> "${CONFIG_FILE}"
        print_success "Failover disabled"
        print_info "Note: Daemon will continue running until stopped manually"
    else
        # Enable
        sed -i '/^FAILOVER_ENABLED=/d' "${CONFIG_FILE}" 2>/dev/null || true
        echo "FAILOVER_ENABLED=true" >> "${CONFIG_FILE}"
        print_success "Failover enabled"
        print_info "Start the failover daemon to begin monitoring"
    fi

    sleep 2
}

start_failover_daemon() {
    print_info "Starting failover daemon..."

    # Find the script
    local script_path=""
    if [[ -f "/usr/local/bin/mdvsec-wan-failover.sh" ]]; then
        script_path="/usr/local/bin/mdvsec-wan-failover.sh"
    elif [[ -f "$(dirname "$0")/mdvsec-wan-failover.sh" ]]; then
        script_path="$(dirname "$0")/mdvsec-wan-failover.sh"
    else
        print_error "Failover script not found!"
        sleep 2
        return
    fi

    # Check if systemd service exists
    if [[ -f "/etc/systemd/system/mdvsec-failover.service" ]]; then
        # Use systemd
        systemctl start mdvsec-failover
        if systemctl is-active --quiet mdvsec-failover; then
            print_success "Failover daemon started via systemd"
        else
            print_error "Failed to start daemon"
            print_info "Check logs: sudo journalctl -u mdvsec-failover -n 20"
        fi
    else
        # Start directly
        "$script_path" start &
        sleep 2
        if pgrep -f "mdvsec-wan-failover" >/dev/null; then
            print_success "Failover daemon started"
        else
            print_error "Failed to start daemon"
        fi
    fi

    sleep 2
}

stop_failover_daemon() {
    print_info "Stopping failover daemon..."

    # Try systemd first
    if systemctl is-active --quiet mdvsec-failover 2>/dev/null; then
        systemctl stop mdvsec-failover
        print_success "Failover daemon stopped"
    else
        # Try direct stop
        local script_path=""
        if [[ -f "/usr/local/bin/mdvsec-wan-failover.sh" ]]; then
            script_path="/usr/local/bin/mdvsec-wan-failover.sh"
        elif [[ -f "$(dirname "$0")/mdvsec-wan-failover.sh" ]]; then
            script_path="$(dirname "$0")/mdvsec-wan-failover.sh"
        fi

        if [[ -n "$script_path" ]]; then
            "$script_path" stop
        else
            # Kill process
            pkill -f "mdvsec-wan-failover" && print_success "Failover daemon stopped" || print_warning "Daemon not running"
        fi
    fi

    sleep 2
}

view_failover_status() {
    print_header
    echo -e "${BRIGHT_GREEN}WAN Failover Status${NC}"
    echo "────────────────────────────────────────────────────────"
    echo ""

    # Check daemon status
    if systemctl is-active --quiet mdvsec-failover 2>/dev/null; then
        print_success "Daemon: RUNNING (systemd)"
        local pid=$(systemctl show -p MainPID --value mdvsec-failover)
        echo "  PID: $pid"
    elif pgrep -f "mdvsec-wan-failover" >/dev/null; then
        print_success "Daemon: RUNNING (standalone)"
        local pid=$(pgrep -f "mdvsec-wan-failover")
        echo "  PID: $pid"
    else
        print_error "Daemon: NOT RUNNING"
    fi
    echo ""

    # Check configuration
    if [[ -f "/etc/secure-ap/failover.conf" ]]; then
        echo -e "${BLUE}Current Configuration:${NC}"
        source /etc/secure-ap/failover.conf
        echo "  Current WAN: ${CURRENT_WAN_INTERFACE:-none}"
        echo "  Last Switch: ${LAST_SWITCH_TIME:-never}"
        echo ""
    fi

    # Show active WAN interface
    echo -e "${BLUE}Active WAN Interface:${NC}"
    for iface in $(ip -o link show | awk -F': ' '{print $2}' | grep -v "^lo$\|^wlan0$"); do
        if ip route show dev "$iface" 2>/dev/null | grep -q "default"; then
            local ip_addr=$(ip -4 addr show "$iface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -1)
            print_success "$iface - $ip_addr"

            # Test internet
            if ping -c 2 -I "$iface" 8.8.8.8 >/dev/null 2>&1; then
                echo "  Internet: ✓ Working"
            else
                echo "  Internet: ✗ Not working"
            fi
            break
        fi
    done
    echo ""

    press_any_key
}

scan_wan_interfaces_menu() {
    print_header
    echo -e "${BRIGHT_CYAN}Scanning WAN Interfaces...${NC}"
    echo "────────────────────────────────────────────────────────"
    echo ""

    # Find the script
    local script_path=""
    if [[ -f "/usr/local/bin/mdvsec-wan-failover.sh" ]]; then
        script_path="/usr/local/bin/mdvsec-wan-failover.sh"
    elif [[ -f "$(dirname "$0")/mdvsec-wan-failover.sh" ]]; then
        script_path="$(dirname "$0")/mdvsec-wan-failover.sh"
    else
        print_error "Failover script not found!"
        press_any_key
        return
    fi

    # Run scan
    "$script_path" scan

    press_any_key
}

view_failover_logs() {
    print_header
    echo -e "${BRIGHT_GREEN}WAN Failover Logs${NC}"
    echo "────────────────────────────────────────────────────────"
    echo ""

    if [[ -f "/var/log/mdvsec-failover.log" ]]; then
        echo -e "${BLUE}Last 30 lines:${NC}"
        echo ""
        tail -30 /var/log/mdvsec-failover.log
    else
        print_warning "No log file found"
        print_info "Log file location: /var/log/mdvsec-failover.log"
    fi

    press_any_key
}

configure_check_interval() {
    echo ""
    print_info "Current check interval: 10 seconds (default)"
    echo ""
    read -p "Enter new check interval in seconds (5-60): " interval

    if [[ "$interval" =~ ^[0-9]+$ ]] && [[ $interval -ge 5 ]] && [[ $interval -le 60 ]]; then
        # Update config
        if [[ -f "/etc/secure-ap/failover.conf" ]]; then
            sed -i "s/^CHECK_INTERVAL=.*/CHECK_INTERVAL=$interval/" /etc/secure-ap/failover.conf
        else
            echo "CHECK_INTERVAL=$interval" >> /etc/secure-ap/failover.conf
        fi

        print_success "Check interval set to $interval seconds"
        print_info "Restart the failover daemon for changes to take effect"
    else
        print_error "Invalid interval (must be 5-60 seconds)"
    fi

    sleep 2
}

################################################################################
# Admin Menu Functions
################################################################################

admin_menu() {
    if ! verify_admin_password; then
        return
    fi

    while true; do
        print_header
        print_section "⚙️" "Admin Menu"
        echo ""
        print_banner "${YELLOW}" "🔐 ${BOLD}AUTHENTICATED${NC} ${YELLOW}- Full System Access${NC}"
        echo ""
        echo -e "  ${DIM}Configuration & Monitoring${NC}"
        echo -e "  ${BRIGHT_CYAN}1)${NC}  ${YELLOW}🔑 Change Admin Password${NC}"
        echo -e "  ${BRIGHT_CYAN}2)${NC}  ${CYAN}👥 View Active Clients${NC}"
        echo -e "  ${BRIGHT_CYAN}3)${NC}  ${CYAN}📊 View System Status${NC}"
        echo -e "  ${BRIGHT_CYAN}4)${NC}  ${CYAN}📝 View Service Logs${NC}"
        echo ""
        echo -e "  ${DIM}Services & Testing${NC}"
        echo -e "  ${BRIGHT_CYAN}5)${NC}  ${PURPLE}🌐 View DoH Status & Logs${NC}"
        echo -e "  ${BRIGHT_CYAN}6)${NC}  ${PURPLE}⚡ Run Speed Test${NC}"
        echo -e "  ${BRIGHT_CYAN}7)${NC}  ${PURPLE}🔍 Test Internet Connectivity${NC}"
        echo -e "  ${BRIGHT_CYAN}8)${NC}  ${BRIGHT_PURPLE}🔄 WAN Failover Configuration${NC}"
        echo ""
        echo -e "  ${DIM}Maintenance${NC}"
        echo -e "  ${BRIGHT_CYAN}9)${NC}  ${BRIGHT_GREEN}🔧 Fix NAT/Routing${NC}"
        echo -e "  ${BRIGHT_CYAN}10)${NC}  ${BRIGHT_GREEN}🔄 Restart Access Point${NC}"
        echo -e "  ${BRIGHT_CYAN}11)${NC} ${RED}⏹️  Stop Access Point${NC}"
        echo ""
        echo -e "  ${DIM}Backup & Restore${NC}"
        echo -e "  ${BRIGHT_CYAN}12)${NC} ${BRIGHT_YELLOW}💾 Backup Configuration${NC}"
        echo -e "  ${BRIGHT_CYAN}13)${NC} ${BRIGHT_YELLOW}📥 Restore Configuration${NC}"
        echo ""
        echo -e "  ${BRIGHT_CYAN}14)${NC} ${YELLOW}← Back to Main Menu${NC}"
        echo ""
        echo -e "${BRIGHT_CYAN}╰─────────────────────────────────────────────────────${NC}"
        echo ""
        read -p "Select option: " admin_choice

        case $admin_choice in
            1) change_admin_password ;;
            2) view_active_clients ;;
            3) view_system_status ;;
            4) view_logs ;;
            5) view_doh_status ;;
            6) run_speedtest ;;
            7) test_connectivity ;;
            8) configure_wan_failover ;;
            9) fix_nat_routing ;;
            10) restart_access_point ;;
            11) stop_access_point ;;
            12) backup_configuration ;;
            13) restore_configuration ;;
            14) break ;;
            *) print_error "Invalid option" ; sleep 1 ;;
        esac
    done
}

change_admin_password() {
    echo ""
    while true; do
        read -s -p "Enter new admin password: " new_admin_pass
        echo ""
        if [[ ${#new_admin_pass} -lt 6 ]]; then
            print_error "Password must be at least 6 characters"
            continue
        fi
        read -s -p "Confirm password: " confirm_admin_pass
        echo ""
        if [[ "$new_admin_pass" == "$confirm_admin_pass" ]]; then
            echo "$new_admin_pass" | openssl passwd -6 -stdin > "${PASSWORD_FILE}"
            chmod 600 "${PASSWORD_FILE}"
            print_success "Admin password updated"
            break
        else
            print_error "Passwords do not match"
        fi
    done
    sleep 1
}

view_active_clients() {
    print_header
    echo -e "${GREEN}Active Clients${NC}"
    echo "────────────────────────────────────────────────────────"

    print_info "Connected clients on ${INTERFACE}:"
    echo ""

    if [[ -f "/var/lib/misc/dnsmasq.leases" ]]; then
        echo -e "${BLUE}DHCP Leases:${NC}"
        printf "%-18s %-15s %-20s\n" "MAC Address" "IP Address" "Hostname"
        echo "────────────────────────────────────────────────────────"
        while read -r line; do
            lease_time=$(echo "$line" | awk '{print $1}')
            mac=$(echo "$line" | awk '{print $2}')
            ip=$(echo "$line" | awk '{print $3}')
            hostname=$(echo "$line" | awk '{print $4}')
            printf "%-18s %-15s %-20s\n" "$mac" "$ip" "$hostname"
        done < /var/lib/misc/dnsmasq.leases
    else
        print_warning "No DHCP leases file found"
    fi

    echo ""
    echo -e "${BLUE}ARP Table:${NC}"
    ip neigh show dev "${INTERFACE}" 2>/dev/null || print_warning "No ARP entries"

    echo ""
    echo -e "${BLUE}Associated Stations (if available):${NC}"
    if command -v iw &>/dev/null; then
        iw dev "${INTERFACE}" station dump 2>/dev/null || print_warning "Unable to get station info"
    else
        print_warning "iw command not available - install 'iw' package for detailed station info"
    fi

    press_any_key
}

view_system_status() {
    print_header
    echo -e "${GREEN}System Status${NC}"
    echo "────────────────────────────────────────────────────────"

    echo -e "${BLUE}Service Status:${NC}"
    for service in hostapd dnsmasq cloudflared wg-quick@wg0; do
        if systemctl is-active --quiet "$service" 2>/dev/null; then
            echo -e "  $service: ${GREEN}RUNNING${NC}"
        else
            echo -e "  $service: ${RED}STOPPED${NC}"
        fi
    done

    echo ""
    echo -e "${BLUE}Network Interfaces:${NC}"
    ip -brief addr show

    echo ""
    echo -e "${BLUE}System Resources:${NC}"
    echo "  CPU Usage: $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')"
    echo "  Memory: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
    echo "  Disk: $(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 " used)"}')"

    press_any_key
}

view_logs() {
    print_header
    print_section "📝" "Service Logs"
    echo ""
    echo -e "  ${BRIGHT_CYAN}1)${NC} ${CYAN}📡 hostapd logs${NC}"
    echo -e "  ${BRIGHT_CYAN}2)${NC} ${CYAN}🌐 dnsmasq logs${NC}"
    echo -e "  ${BRIGHT_CYAN}3)${NC} ${PURPLE}🔒 cloudflared logs${NC}"
    echo -e "  ${BRIGHT_CYAN}4)${NC} ${PURPLE}🔐 WireGuard logs${NC}"
    echo -e "  ${BRIGHT_CYAN}5)${NC} ${BRIGHT_RED}🛡️  Suricata logs${NC}"
    echo -e "  ${BRIGHT_CYAN}6)${NC} ${YELLOW}📋 System logs${NC}"
    echo -e "  ${BRIGHT_CYAN}7)${NC} ${YELLOW}← Back${NC}"
    echo ""
    echo -e "${BRIGHT_CYAN}╰─────────────────────────────────────────────────────${NC}"
    echo ""
    read -p "Select service: " log_choice

    case $log_choice in
        1) journalctl -u hostapd -n 50 --no-pager ; press_any_key ;;
        2) journalctl -u dnsmasq -n 50 --no-pager ; press_any_key ;;
        3) journalctl -u cloudflared -n 50 --no-pager ; press_any_key ;;
        4) journalctl -u wg-quick@wg0 -n 50 --no-pager ; press_any_key ;;
        5) view_suricata_logs ;;
        6) journalctl -n 50 --no-pager ; press_any_key ;;
        7) return ;;
    esac
}

view_suricata_logs() {
    print_header
    print_section "🛡️" "Suricata IDS/IPS Logs"
    echo ""

    # Check if Suricata is installed
    if ! command -v suricata &>/dev/null; then
        print_warning "Suricata is not installed"
        echo ""
        print_info "To install Suricata:"
        echo "  1. Go to Security Settings (Menu 2)"
        echo "  2. Select Setup Suricata IDS/IPS (option 6)"
        press_any_key
        return
    fi

    # Check service status
    echo -e "${BLUE}Service Status:${NC}"
    if systemctl is-active --quiet suricata; then
        print_success "Suricata is running"
    else
        print_error "Suricata is STOPPED"
    fi
    echo ""

    # Show log options
    echo -e "${BRIGHT_CYAN}Available Logs:${NC}"
    echo -e "  ${BRIGHT_CYAN}1)${NC} ${BRIGHT_RED}Fast Alerts${NC} ${DIM}(security events)${NC}"
    echo -e "  ${BRIGHT_CYAN}2)${NC} ${YELLOW}Eve JSON${NC} ${DIM}(detailed events)${NC}"
    echo -e "  ${BRIGHT_CYAN}3)${NC} ${CYAN}Service Logs${NC} ${DIM}(systemd journal)${NC}"
    echo -e "  ${BRIGHT_CYAN}4)${NC} ${PURPLE}Stats${NC} ${DIM}(performance metrics)${NC}"
    echo -e "  ${BRIGHT_CYAN}5)${NC} ${GREEN}Live Monitor${NC} ${DIM}(tail alerts)${NC}"
    echo -e "  ${BRIGHT_CYAN}6)${NC} ${YELLOW}← Back${NC}"
    echo ""
    echo -e "${BRIGHT_CYAN}╰─────────────────────────────────────────────────────${NC}"
    echo ""
    read -p "Select log type: " suricata_log_choice

    case $suricata_log_choice in
        1)
            # Fast alerts log
            print_header
            echo -e "${BRIGHT_RED}🛡️  Suricata Fast Alerts (Last 50)${NC}"
            echo "────────────────────────────────────────────────────────"
            echo ""
            if [[ -f /var/log/suricata/fast.log ]]; then
                tail -50 /var/log/suricata/fast.log | grep --color=auto -E '\[\*\*\]|$'
                echo ""
                echo -e "${DIM}Total alerts: $(wc -l < /var/log/suricata/fast.log 2>/dev/null || echo 0)${NC}"
            else
                print_warning "No fast.log found"
                print_info "Log location: /var/log/suricata/fast.log"
            fi
            press_any_key
            ;;
        2)
            # Eve JSON log
            print_header
            echo -e "${YELLOW}📋 Suricata Eve JSON (Last 20 events)${NC}"
            echo "────────────────────────────────────────────────────────"
            echo ""
            if [[ -f /var/log/suricata/eve.json ]] && command -v jq &>/dev/null; then
                tail -20 /var/log/suricata/eve.json | jq -C '.' 2>/dev/null || tail -20 /var/log/suricata/eve.json
            elif [[ -f /var/log/suricata/eve.json ]]; then
                tail -20 /var/log/suricata/eve.json
                echo ""
                print_info "Install 'jq' for better JSON formatting: apt install jq"
            else
                print_warning "No eve.json found"
                print_info "Log location: /var/log/suricata/eve.json"
            fi
            press_any_key
            ;;
        3)
            # Systemd service logs
            print_header
            echo -e "${CYAN}📝 Suricata Service Logs (Last 50)${NC}"
            echo "────────────────────────────────────────────────────────"
            echo ""
            journalctl -u suricata -n 50 --no-pager
            press_any_key
            ;;
        4)
            # Stats log
            print_header
            echo -e "${PURPLE}📊 Suricata Statistics${NC}"
            echo "────────────────────────────────────────────────────────"
            echo ""
            if [[ -f /var/log/suricata/stats.log ]]; then
                tail -50 /var/log/suricata/stats.log
            else
                print_warning "No stats.log found"
                print_info "Log location: /var/log/suricata/stats.log"
            fi
            press_any_key
            ;;
        5)
            # Live monitor
            print_header
            echo -e "${BRIGHT_GREEN}🔴 Live Suricata Alerts Monitor${NC}"
            echo "────────────────────────────────────────────────────────"
            echo -e "${DIM}Press Ctrl+C to stop${NC}"
            echo ""
            if [[ -f /var/log/suricata/fast.log ]]; then
                tail -f /var/log/suricata/fast.log
            else
                print_warning "No fast.log found"
                print_info "Log location: /var/log/suricata/fast.log"
                press_any_key
            fi
            ;;
        6)
            return
            ;;
        *)
            print_error "Invalid option"
            sleep 1
            ;;
    esac
}

view_doh_status() {
    print_header
    echo -e "${GREEN}DNS over HTTPS (DoH) Status${NC}"
    echo "────────────────────────────────────────────────────────"

    # Check if cloudflared is installed
    if ! command -v cloudflared &>/dev/null; then
        print_warning "cloudflared is not installed"
        echo ""
        print_info "DoH is not configured. To enable:"
        echo "  1. Go to Security Settings (Menu 2)"
        echo "  2. Select Configure DoH (option 1)"
        press_any_key
        return
    fi

    # Check service status
    echo -e "${BLUE}Service Status:${NC}"
    if systemctl is-active --quiet cloudflared; then
        print_success "cloudflared is running"
    else
        print_error "cloudflared is STOPPED"
        echo ""
        read -p "Start cloudflared now? (y/n): " start_cf
        if [[ "$start_cf" == "y" ]]; then
            systemctl start cloudflared
            sleep 1
            if systemctl is-active --quiet cloudflared; then
                print_success "cloudflared started"
            else
                print_error "Failed to start cloudflared"
            fi
        fi
    fi

    echo ""
    echo -e "${BLUE}Configuration:${NC}"
    if [[ -f /etc/cloudflared/config.yml ]]; then
        cat /etc/cloudflared/config.yml
    else
        print_warning "Configuration file not found"
    fi

    echo ""
    echo -e "${BLUE}Port Check:${NC}"
    if netstat -tuln 2>/dev/null | grep -q ":5053 " || ss -tuln 2>/dev/null | grep -q ":5053 "; then
        print_success "DoH proxy is listening on port 5053"
    else
        print_warning "DoH proxy is not listening on port 5053"
    fi

    echo ""
    echo -e "${BLUE}DNS Resolution Test:${NC}"
    if dig @127.0.0.1 -p 5053 google.com +short 2>/dev/null | grep -q "."; then
        print_success "DNS resolution through DoH is working"
    else
        if ! command -v dig &>/dev/null; then
            print_info "Install 'dnsutils' to test DNS resolution"
        else
            print_warning "DNS resolution through DoH failed"
        fi
    fi

    echo ""
    echo -e "${BLUE}Recent Logs (last 20 lines):${NC}"
    echo "────────────────────────────────────────────────────────"
    journalctl -u cloudflared -n 20 --no-pager 2>/dev/null || print_warning "No logs available"

    echo ""
    echo "Actions:"
    echo "  1) View full logs"
    echo "  2) Restart cloudflared"
    echo "  3) Stop cloudflared"
    echo "  4) Start cloudflared"
    echo "  5) Back"
    echo ""
    read -p "Select action (or press Enter to go back): " doh_action

    case $doh_action in
        1)
            echo ""
            journalctl -u cloudflared -n 100 --no-pager
            press_any_key
            ;;
        2)
            systemctl restart cloudflared
            sleep 1
            print_success "cloudflared restarted"
            sleep 1
            ;;
        3)
            systemctl stop cloudflared
            print_success "cloudflared stopped"
            sleep 1
            ;;
        4)
            systemctl start cloudflared
            sleep 1
            print_success "cloudflared started"
            sleep 1
            ;;
        5|"")
            return
            ;;
    esac
}

run_speedtest() {
    print_header
    echo -e "${GREEN}Internet Speed Test${NC}"
    echo "────────────────────────────────────────────────────────"

    # Check if speedtest-cli is installed
    if ! command -v speedtest-cli &>/dev/null && ! command -v speedtest &>/dev/null; then
        print_warning "speedtest-cli is not installed"
        echo ""
        read -p "Install speedtest-cli now? (y/n): " install_st
        if [[ "$install_st" == "y" ]]; then
            print_info "Installing speedtest-cli..."
            apt-get update -qq
            apt-get install -y speedtest-cli 2>&1 | grep -v "^debconf:" || true

            if command -v speedtest-cli &>/dev/null; then
                print_success "speedtest-cli installed"
            else
                print_error "Failed to install speedtest-cli"
                press_any_key
                return
            fi
        else
            return
        fi
    fi

    echo ""
    print_info "Running speed test... (this may take 30-60 seconds)"
    echo ""

    # Determine which command to use
    if command -v speedtest &>/dev/null; then
        SPEEDTEST_CMD="speedtest"
    else
        SPEEDTEST_CMD="speedtest-cli"
    fi

    # Run speed test
    if $SPEEDTEST_CMD --simple 2>/dev/null; then
        echo ""
        print_success "Speed test completed"
    else
        # Fallback to full output
        echo ""
        $SPEEDTEST_CMD 2>&1
        echo ""
        print_success "Speed test completed"
    fi

    echo ""
    echo "Additional options:"
    echo "  1) Run detailed test"
    echo "  2) Test to specific server (list servers)"
    echo "  3) Share results (get shareable link)"
    echo "  4) Back"
    echo ""
    read -p "Select option: " st_option

    case $st_option in
        1)
            print_info "Running detailed speed test..."
            $SPEEDTEST_CMD
            press_any_key
            ;;
        2)
            print_info "Available servers:"
            $SPEEDTEST_CMD --list | head -20
            echo ""
            read -p "Enter server ID (or press Enter to cancel): " server_id
            if [[ -n "$server_id" ]]; then
                print_info "Testing to server $server_id..."
                $SPEEDTEST_CMD --server "$server_id"
                press_any_key
            fi
            ;;
        3)
            print_info "Running test and generating share link..."
            $SPEEDTEST_CMD --share
            press_any_key
            ;;
        4|"")
            return
            ;;
    esac
}

test_connectivity() {
    print_header
    echo -e "${GREEN}Internet Connectivity Test${NC}"
    echo "────────────────────────────────────────────────────────"

    load_config

    print_info "Testing from Access Point..."
    echo ""

    # Test 1: IP Forwarding
    echo -n "IP Forwarding: "
    if [[ $(cat /proc/sys/net/ipv4/ip_forward) == "1" ]]; then
        print_success "Enabled"
    else
        print_error "Disabled"
    fi

    # Test 2: Internet connectivity from AP
    echo -n "Internet (from AP): "
    if ping -c 2 -W 2 8.8.8.8 >/dev/null 2>&1; then
        print_success "Working"
    else
        print_error "Failed"
    fi

    # Test 3: DNS resolution from AP
    echo -n "DNS Resolution (from AP): "
    if ping -c 2 -W 2 google.com >/dev/null 2>&1; then
        print_success "Working"
    else
        print_error "Failed"
    fi

    # Test 4: NAT rules
    echo ""
    echo "NAT Rules (POSTROUTING):"
    iptables -t nat -L POSTROUTING -n -v | grep -E "MASQUERADE|Chain"

    echo ""
    echo "Forward Rules:"
    iptables -L FORWARD -n -v | head -5

    echo ""
    echo "Default Route:"
    ip route show default

    echo ""
    echo "Active Interfaces:"
    ip -brief addr show | grep -v "lo "

    echo ""
    print_info "From a connected client device, test:"
    echo "  1. Check IP: Should be 192.168.4.x"
    echo "  2. Check gateway: Should be 192.168.4.1"
    echo "  3. Ping gateway: ping 192.168.4.1"
    echo "  4. Ping internet: ping 8.8.8.8"
    echo "  5. Test DNS: ping google.com"

    press_any_key
}

fix_nat_routing() {
    print_header
    echo -e "${GREEN}Fix NAT and Routing${NC}"
    echo "────────────────────────────────────────────────────────"

    load_config

    print_warning "This will reconfigure NAT and routing"
    read -p "Continue? (y/n): " confirm
    if [[ "$confirm" != "y" ]]; then
        return
    fi

    echo ""

    # Enable IP forwarding
    print_info "Enabling IP forwarding..."
    echo 1 > /proc/sys/net/ipv4/ip_forward
    sysctl -w net.ipv4.ip_forward=1 >/dev/null 2>&1
    if ! grep -q "^net.ipv4.ip_forward=1" /etc/sysctl.conf 2>/dev/null; then
        echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
    fi
    print_success "IP forwarding enabled"

    # Detect internet interface
    print_info "Detecting internet interface..."
    INTERNET_IFACE=""
    for iface in $(ip -o link show | awk -F': ' '{print $2}' | grep -v "lo\|${INTERFACE}"); do
        if ip route show dev "$iface" 2>/dev/null | grep -q "default"; then
            INTERNET_IFACE="$iface"
            break
        fi
    done

    if [[ -z "$INTERNET_IFACE" ]]; then
        print_warning "Could not auto-detect internet interface"
        print_info "Available interfaces:"
        ip -brief link show | grep -v "lo\|${INTERFACE}"
        echo ""
        read -p "Enter internet interface name: " INTERNET_IFACE
    fi

    print_success "Using internet interface: $INTERNET_IFACE"

    # Clear existing rules
    print_info "Clearing old NAT rules..."
    iptables -t nat -F POSTROUTING 2>/dev/null || true
    iptables -F FORWARD 2>/dev/null || true

    # Configure NAT
    print_info "Configuring NAT..."
    iptables -t nat -A POSTROUTING -o "${INTERNET_IFACE}" -j MASQUERADE
    iptables -A FORWARD -i "${INTERFACE}" -o "${INTERNET_IFACE}" -j ACCEPT
    iptables -A FORWARD -i "${INTERNET_IFACE}" -o "${INTERFACE}" -m state --state RELATED,ESTABLISHED -j ACCEPT
    iptables -P FORWARD ACCEPT

    # Save rules
    print_info "Saving iptables rules..."
    if command -v netfilter-persistent &>/dev/null; then
        netfilter-persistent save 2>/dev/null || true
    else
        DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            netfilter-persistent save 2>/dev/null || true
        else
            mkdir -p /etc/iptables
            iptables-save > /etc/iptables/rules.v4 2>/dev/null || true
        fi
    fi

    print_success "NAT and routing configured!"
    echo ""
    print_info "Configuration:"
    echo "  AP Interface: ${INTERFACE}"
    echo "  Internet Interface: ${INTERNET_IFACE}"
    echo "  NAT: ${INTERFACE} → ${INTERNET_IFACE}"
    echo ""
    print_info "Try connecting from a client device now"

    press_any_key
}

restart_access_point() {
    print_info "Restarting access point services..."
    systemctl restart hostapd dnsmasq
    sleep 2
    print_success "Services restarted"
    sleep 1
}

stop_access_point() {
    print_warning "Stopping access point services..."
    systemctl stop hostapd dnsmasq
    sleep 1
    print_success "Access point stopped"
    sleep 1
}

backup_configuration() {
    local backup_file="/tmp/secure-ap-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
    print_info "Creating backup..."
    tar -czf "$backup_file" "${CONFIG_DIR}" "${HOSTAPD_CONF}" "${DNSMASQ_CONF}" /etc/wireguard /etc/cloudflared 2>/dev/null
    print_success "Backup created: $backup_file"
    press_any_key
}

restore_configuration() {
    read -p "Enter backup file path: " backup_file
    if [[ -f "$backup_file" ]]; then
        print_info "Restoring configuration..."
        tar -xzf "$backup_file" -C /
        print_success "Configuration restored"
        print_warning "Please restart services for changes to take effect"
    else
        print_error "Backup file not found"
    fi
    press_any_key
}

################################################################################
# Main Menu
################################################################################

main_menu() {
    while true; do
        print_header
        print_section "🏠" "Main Menu"
        echo ""
        echo -e "  ${BRIGHT_CYAN}1)${NC} ${BRIGHT_GREEN}🚀 Quick Start${NC}"
        echo -e "     ${DIM}Automated setup and start${NC}"
        echo ""
        echo -e "  ${BRIGHT_CYAN}2)${NC} ${CYAN}📡 WiFi Setup${NC}"
        echo -e "     ${DIM}Configure SSID, password, channels, and drivers${NC}"
        echo ""
        echo -e "  ${BRIGHT_CYAN}3)${NC} ${PURPLE}🔒 Security Settings${NC}"
        echo -e "     ${DIM}DoH, WireGuard, Suricata, Telegram, SNMP${NC}"
        echo ""
        echo -e "  ${BRIGHT_CYAN}4)${NC} ${YELLOW}⚙️  Admin Menu${NC}"
        echo -e "     ${DIM}System management and monitoring${NC}"
        echo ""
        echo -e "  ${BRIGHT_CYAN}5)${NC} ${RED}🚪 Exit${NC}"
        echo ""
        echo -e "${BRIGHT_CYAN}╰─────────────────────────────────────────────────────${NC}"
        echo ""
        read -p "Select option: " main_choice

        case $main_choice in
            1) quick_start ;;
            2) setup_wifi_menu ;;
            3) security_menu ;;
            4) admin_menu ;;
            5) exit 0 ;;
            *) print_error "Invalid option" ; sleep 1 ;;
        esac
    done
}

quick_start() {
    print_header
    print_info "Quick Start - Setting up secure access point..."
    echo ""

    load_config

    print_info "Current settings:"
    echo "  SSID: ${SSID}"
    echo "  Interface: ${INTERFACE}"
    read -p "Use these settings? (y/n): " use_defaults

    if [[ "$use_defaults" != "y" ]]; then
        read -p "Enter SSID: " SSID
        list_wireless_interfaces
        read -p "Enter interface: " INTERFACE
        read -s -p "Enter WiFi password (min 8 chars): " PASSWORD
        echo ""
        save_config
    fi

    apply_wifi_configuration
}

################################################################################
# Main Script
################################################################################

check_root
check_and_install_dependencies
initialize_config
load_config
main_menu
