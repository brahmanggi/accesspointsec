# MDVSEC Secure Access Point

<div align="center">

```
███╗   ███╗██████╗ ██╗   ██╗███████╗███████╗ ██████╗
████╗ ████║██╔══██╗██║   ██║██╔════╝██╔════╝██╔════╝
██╔████╔██║██║  ██║██║   ██║███████╗█████╗  ██║
██║╚██╔╝██║██║  ██║╚██╗ ██╔╝╚════██║██╔══╝  ██║
██║ ╚═╝ ██║██████╔╝ ╚████╔╝ ███████║███████╗╚██████╗
╚═╝     ╚═╝╚═════╝   ╚═══╝  ╚══════╝╚══════╝ ╚═════╝
```

**A comprehensive WiFi Access Point management tool with advanced security features**

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Version](https://img.shields.io/badge/version-1.4.0-green.svg)](https://github.com/brahmanggi/accesspointsec/releases)
[![Platform](https://img.shields.io/badge/platform-linux-lightgrey.svg)](https://github.com/brahmanggi/accesspointsec)

</div>

---

## ⚠️ **IMPORTANT WARNING**

> [!WARNING]
> **This software is currently in BETA and considered UNSTABLE.**
>
> - 🚧 **Use at your own risk** - This software may contain bugs or unexpected behavior
> - 🔬 **Testing phase** - Not recommended for production environments
> - 💾 **Backup your data** - Always backup important configurations before use
> - 🛡️ **Security considerations** - While security features are included, the software is still under development
> - 📝 **Report issues** - Please report any bugs or issues on GitHub
>
> **USE THIS SOFTWARE CAREFULLY AND RESPONSIBLY**

---

## 📋 Table of Contents

- [Features](#-features)
- [System Requirements](#-system-requirements)
- [Installation](#-installation)
  - [Quick Install (Debian Package)](#quick-install-debian-package)
  - [Manual Installation](#manual-installation)
- [Building from Source](#-building-from-source)
- [Usage](#-usage)
- [Supported Platforms](#-supported-platforms)
- [Configuration](#-configuration)
- [Uninstallation](#-uninstallation)
- [Screenshots](#-screenshots)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🚀 Features

### Core Features
- 📡 **WiFi Access Point Setup** - Easy configuration for 2.4GHz, 5GHz, and 6GHz bands
- 🎨 **Interactive Menu** - User-friendly menu-driven interface
- 🔧 **Auto-configuration** - Automated setup with sensible defaults
- 🌐 **Multi-WAN Support** - Ethernet, WiFi WAN, and USB tethering

### Security Features
- 🔒 **DNS over HTTPS (DoH)** - Privacy-focused DNS via Cloudflared
- 🛡️ **WireGuard VPN** - Secure VPN tunnel integration
- 🔍 **Suricata IDS/IPS** - Real-time threat detection and prevention
- 🔐 **WPA2/WPA3 Encryption** - Modern WiFi security standards
- 🔑 **Admin Password Protection** - Secure admin access

### Advanced Features
- 🔄 **WAN Failover** - Automatic internet source switching
- 📱 **Telegram Notifications** - Real-time alerts for connections and threats
- 📊 **SNMP Monitoring** - Network management and monitoring support
- 📈 **Speed Testing** - Built-in internet speed test
- 👥 **Client Monitoring** - Track connected devices
- 💾 **Configuration Backup/Restore** - Save and restore settings

### Management Features
- 🖥️ **System Status Dashboard** - Real-time monitoring
- 📝 **Service Logs** - View hostapd, dnsmasq, cloudflared, and more
- 🔧 **NAT/Routing Fixer** - Automatic network troubleshooting
- ⚡ **Service Control** - Start, stop, restart services

---

## 💻 System Requirements

### Minimum Requirements
- **OS**: Debian 10+ / Ubuntu 18.04+ / Raspberry Pi OS
- **RAM**: 4 MB (16 GB recommended)
- **Storage**: 100 MB for software + dependencies
- **Network**: At least one wireless interface supporting AP mode

### Recommended Hardware
- **Raspberry Pi 3/4/5** - Ideal for dedicated AP
- **Ubuntu Server** - For VM or desktop deployment
- **USB WiFi Adapter** - For dual-band or better range

### Dependencies
**Required** (auto-installed):
- bash (>= 4.0)
- hostapd
- dnsmasq
- iproute2
- iptables
- openssl
- iw
- lsb-release
- isc-dhcp-client or dhcpcd5

**Optional** (recommended):
- wireguard
- cloudflared
- suricata
- speedtest-cli
- snmpd
- curl

---

## 📦 Installation

### Quick Install (Debian Package)

#### Step 1: Download the Package

**Option A: Download from Releases** (recommended)
```bash
wget https://github.com/brahmanggi/accesspointsec/releases/download/v1.4.0/mdvsec-ap_1.4.0_all.deb
```

**Option B: Clone and Build**
```bash
git clone https://github.com/brahmanggi/accesspointsec.git
cd accesspointsec
./build-deb.sh
```

#### Step 2: Install the Package

**Using apt** (recommended - auto-installs dependencies):
```bash
sudo apt install ./mdvsec-ap_1.4.0_all.deb
```

**Using dpkg**:
```bash
sudo dpkg -i mdvsec-ap_1.4.0_all.deb
sudo apt-get install -f  # Install missing dependencies
```

#### Step 3: Run the Software
```bash
sudo mdvsec-ap
```

### Manual Installation

If you prefer to run the script directly without installing the package:

```bash
# Clone the repository
git clone https://github.com/brahmanggi/accesspointsec.git
cd accesspointsec

# Make the script executable
chmod +x install.sh

# Run the script
sudo ./install.sh
```

---

## 🔨 Building from Source

### Prerequisites

Install the build dependencies:
```bash
sudo apt update
sudo apt install dpkg-dev git
```

### Build Process

1. **Clone the repository**:
   ```bash
   git clone https://github.com/brahmanggi/accesspointsec.git
   cd accesspointsec
   ```

2. **Run the build script**:
   ```bash
   ./build-deb.sh
   ```

3. **The package will be created in the `dist/` directory**:
   ```
   dist/mdvsec-ap_1.4.0_all.deb
   ```

### Build Output

The build script will:
- ✅ Verify all required files
- ✅ Set proper permissions
- ✅ Create the .deb package
- ✅ Verify package integrity
- ✅ Display package information

Example output:
```
╔════════════════════════════════════════════════════════╗
║  MDVSEC Debian Package Builder                        ║
║  Version: 1.4.0                                        ║
╚════════════════════════════════════════════════════════╝

[1/5] Checking dependencies...
✓ Dependencies OK
[2/5] Verifying package structure...
✓ Package structure OK
[3/5] Setting permissions...
✓ Permissions set
[4/5] Creating output directory...
✓ Output directory ready
[5/5] Building .deb package...
✓ Package built successfully!

Package: dist/mdvsec-ap_1.4.0_all.deb
Size: 22K
Architecture: all (supports x86, x64, ARM, ARM64)
```

### Testing the Package

After building, test the package:
```bash
# Check package info
dpkg-deb -I dist/mdvsec-ap_1.4.0_all.deb

# List package contents
dpkg-deb -c dist/mdvsec-ap_1.4.0_all.deb

# Install and test
sudo apt install ./dist/mdvsec-ap_1.4.0_all.deb
sudo mdvsec-ap
```

---

## 🎯 Usage

### First Run

After installation, run the software:
```bash
sudo mdvsec-ap
```

You'll see the interactive menu:

```
███╗   ███╗██████╗ ██╗   ██╗███████╗███████╗ ██████╗
████╗ ████║██╔══██╗██║   ██║██╔════╝██╔════╝██╔════╝
██╔████╔██║██║  ██║██║   ██║███████╗█████╗  ██║
██║╚██╔╝██║██║  ██║╚██╗ ██╔╝╚════██║██╔══╝  ██║
██║ ╚═╝ ██║██████╔╝ ╚████╔╝ ███████║███████╗╚██████╗
╚═╝     ╚═╝╚═════╝   ╚═══╝  ╚══════╝╚══════╝ ╚═════╝

╔═══════════════════════════════════════════════════════╗
║  ⚡ MDVSEC - Secure Access Point Tool ⚡              ║
║   v1.4.0 | Arch: x86_64 | OS: Ubuntu                 ║
╚═══════════════════════════════════════════════════════╝

╭─ 🏠  Main Menu
╰─────────────────────────────────────────────────────

  1) 🚀 Quick Start
     Automated setup and start

  2) 📡 WiFi Setup
     Configure SSID, password, channels, and drivers

  3) 🔒 Security Settings
     DoH, WireGuard, Suricata, Telegram, SNMP

  4) ⚙️  Admin Menu
     System management and monitoring

  5) 🚪 Exit

Select option:
```

### Quick Start Guide

1. **Select Option 1: Quick Start**
   - Enter your desired SSID
   - Set a WiFi password (minimum 8 characters)
   - Select your wireless interface
   - The system will configure and start the AP

2. **Configure Security (Optional)**
   - Select Option 3: Security Settings
   - Enable DNS over HTTPS for privacy
   - Set up WireGuard VPN if needed
   - Configure Suricata IDS/IPS for threat detection
   - Enable Telegram notifications

3. **Monitor Your AP**
   - Select Option 4: Admin Menu
   - View active clients
   - Check system status
   - View service logs
   - Run speed tests

### Common Tasks

#### View Connected Clients
```
Main Menu → Admin Menu → View Active Clients
```

#### Change WiFi Password
```
Main Menu → WiFi Setup → Configure Basic Settings → Enter new password
```

#### Enable DNS over HTTPS
```
Main Menu → Security Settings → Configure DNS over HTTPS
```

#### View System Logs
```
Main Menu → Admin Menu → View Service Logs
```

#### Restart Access Point
```
Main Menu → Admin Menu → Restart Access Point
```

---

## 🌍 Supported Platforms

### Operating Systems
| OS | Version | Architecture | Status |
|---|---|---|---|
| **Debian** | 10, 11, 12+ | x86, x64, ARM, ARM64 | ✅ Tested |
| **Ubuntu** | 18.04, 20.04, 22.04, 24.04+ | x86, x64, ARM, ARM64 | ✅ Tested |
| **Raspberry Pi OS** | All versions | ARM, ARM64 | ✅ Tested |
| **Linux Mint** | 19+ | x86, x64 | ✅ Compatible |
| **Pop!_OS** | 20.04+ | x64 | ✅ Compatible |
| **Elementary OS** | 6+ | x64 | ✅ Compatible |
| **Kali Linux** | 2020+ | x86, x64, ARM | ✅ Compatible |
| **MX Linux** | All | x86, x64 | ✅ Compatible |

### Hardware Support

#### Tested Devices
- ✅ Raspberry Pi 1, 2, 3, 4, 5
- ✅ Raspberry Pi Zero W
- ✅ Intel/AMD x86/x64 systems
- ✅ VirtualBox/VMware VMs
- ✅ Orange Pi, Banana Pi

#### WiFi Adapters
Most wireless adapters supporting AP mode work. Popular chipsets:
- Realtek RTL8188xxx, RTL8192xxx, RTL8812xxx
- Atheros AR9xxx
- Broadcom BCM43xxx (built-in Raspberry Pi WiFi)
- MediaTek MT76xx

**Check AP mode support**:
```bash
iw list | grep "Supported interface modes" -A 10
```

---

## ⚙️ Configuration

### Configuration Files

All configuration files are stored in `/etc/secure-ap/`:

| File | Description |
|---|---|
| `config.conf` | Main configuration (SSID, password, interface, etc.) |
| `.admin_password` | Admin password hash |
| `.telegram_configured` | Telegram bot settings |
| `failover.conf` | WAN failover configuration |

### Default Settings

| Setting | Default Value |
|---|---|
| **SSID** | `mdvsec` |
| **Password** | `SecurePass123` |
| **Channel** | `6` (2.4GHz) |
| **Frequency** | `2.4 GHz` |
| **Interface** | `wlan0` |
| **IP Range** | `192.168.4.0/24` |
| **Gateway** | `192.168.4.1` |

### Customization

You can modify settings through the interactive menu or by editing:
```bash
sudo nano /etc/secure-ap/config.conf
```

---

## 🗑️ Uninstallation

### Remove Package (Keep Configuration)
```bash
sudo apt remove mdvsec-ap
```
Configuration files in `/etc/secure-ap/` will be preserved.

### Complete Removal (Including Configuration)
```bash
sudo apt purge mdvsec-ap
```
This will prompt you to confirm deletion of configuration files.

### Manual Cleanup
If needed, manually remove configuration:
```bash
sudo rm -rf /etc/secure-ap
sudo systemctl disable mdvsec-client-monitor mdvsec-failover
sudo rm /etc/systemd/system/mdvsec-*.service
sudo rm /usr/local/bin/mdvsec-*
```

---

## 📸 Screenshots

### Main Menu
The colorful MDVSEC ASCII banner with blue, white, and yellow colors greets you on startup, followed by an intuitive menu system.

### WiFi Setup
Configure your access point with support for:
- 2.4 GHz (Channels 1-13)
- 5 GHz (Channels 36-165)
- 6 GHz (Channels 1-233) - WiFi 6E compatible

### Security Dashboard
Monitor threats, configure VPN, enable DoH, and receive Telegram notifications for security events.

### System Status
Real-time monitoring of:
- Connected clients
- Service status
- System resources (CPU, memory, disk)
- Network interfaces

---

## 🔧 Troubleshooting

### WiFi Interface Not Detected

**Problem**: Script doesn't detect wireless interface

**Solution**:
```bash
# List all wireless interfaces
iw dev

# Check if interface is down
ip link show

# Bring interface up
sudo ip link set wlan0 up

# Check AP mode support
iw list | grep -A 10 "Supported interface modes"
```

### Access Point Not Starting

**Problem**: hostapd fails to start

**Solution**:
```bash
# Check hostapd status
sudo systemctl status hostapd

# View hostapd logs
sudo journalctl -u hostapd -n 50

# Kill conflicting processes
sudo killall wpa_supplicant
sudo killall NetworkManager

# Restart access point
sudo mdvsec-ap → Admin Menu → Restart Access Point
```

### Clients Can't Get IP Address

**Problem**: DHCP not working

**Solution**:
```bash
# Check dnsmasq status
sudo systemctl status dnsmasq

# View dnsmasq logs
sudo journalctl -u dnsmasq -n 50

# Restart dnsmasq
sudo systemctl restart dnsmasq

# Check IP forwarding
cat /proc/sys/net/ipv4/ip_forward  # Should be 1
```

### No Internet on Connected Clients

**Problem**: NAT/routing not working

**Solution**:
```bash
# Use the built-in fixer
sudo mdvsec-ap → Admin Menu → Fix NAT/Routing

# Or manually check
sudo iptables -t nat -L -n -v
ip route show
```

### Package Installation Fails

**Problem**: Dependency errors

**Solution**:
```bash
# Update package list
sudo apt update

# Fix broken dependencies
sudo apt install -f

# Install missing packages manually
sudo apt install hostapd dnsmasq iproute2 iptables
```

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues, fork the repository, and create pull requests.

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Commit your changes**: `git commit -m 'Add amazing feature'`
4. **Push to the branch**: `git push origin feature/amazing-feature`
5. **Open a Pull Request**

### Development Setup

```bash
# Clone your fork
git clone https://github.com/yourusername/accesspointsec.git
cd accesspointsec

# Create a branch
git checkout -b feature/my-feature

# Make changes and test
sudo ./install.sh

# Build and test package
./build-deb.sh
sudo apt install ./dist/mdvsec-ap_1.4.0_all.deb
```

### Reporting Issues

Please include:
- Operating system and version
- Architecture (x86, x64, ARM, ARM64)
- Error messages or logs
- Steps to reproduce

---

## 📄 License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

```
Copyright (C) 2025 MDVSEC Team

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
```

---

## 🙏 Acknowledgments

- **hostapd** - WiFi access point daemon
- **dnsmasq** - DHCP and DNS server
- **Cloudflared** - DNS over HTTPS proxy
- **WireGuard** - VPN protocol
- **Suricata** - IDS/IPS engine
- All contributors and users of this project

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/brahmanggi/accesspointsec/issues)
- **Discussions**: [GitHub Discussions](https://github.com/brahmanggi/accesspointsec/discussions)
- **Email**: brahmanggi@gmail.com

---

## 🌟 Star History

If you find this project useful, please consider giving it a star ⭐

---

<div align="center">

**Made with ❤️ by the MDVSEC Team**

[Report Bug](https://github.com/brahmanggi/accesspointsec/issues) · [Request Feature](https://github.com/brahmanggi/accesspointsec/issues) · [Documentation](https://github.com/brahmanggi/accesspointsec/wiki)

</div>
