# MDVSEC Secure Access Point v1.4.0

## ⚠️ IMPORTANT WARNING

**This software is currently in BETA and considered UNSTABLE.**

- 🚧 **Use at your own risk** - May contain bugs or unexpected behavior
- 🔬 **Testing phase** - Not recommended for production environments
- 💾 **Backup your data** - Always backup important configurations before use
- 🛡️ **Security considerations** - Still under development
- 📝 **Report issues** - Please report any bugs on GitHub

**USE THIS SOFTWARE CAREFULLY AND RESPONSIBLY**

---

## 🎉 Release Highlights

This is the initial release of MDVSEC Secure Access Point with complete Debian package support!

### Major Features

- **🎨 New MDVSEC Branding** - Colorful ASCII art banner with blue, white, and yellow colors
- **📦 Debian Package** - Universal .deb package supporting all architectures
- **🔒 Security Suite** - DNS over HTTPS, WireGuard VPN, Suricata IDS/IPS
- **📱 Telegram Notifications** - Real-time alerts for connections and threats
- **🔄 WAN Failover** - Automatic internet source switching
- **📊 SNMP Monitoring** - Network management support

### What's Included

This release contains two installation methods:

#### 1. Debian Package (Recommended)
- **File**: `mdvsec-ap_1.4.0_all.deb`
- **Size**: 22KB
- **Architecture**: all (universal - works on x86, x64, ARM, ARM64)
- **Auto-installs**: All dependencies
- **Includes**: Proper installation/removal scripts, systemd integration

#### 2. Standalone Script
- **File**: `install.sh`
- **Size**: 99KB
- **Usage**: Direct execution without package installation
- **Portable**: Can be run from any location

---

## 📦 Installation

### Method 1: Using Debian Package (Recommended)

```bash
# Download the package
wget https://github.com/brahmanggi/accesspointsec/releases/download/v1.4.0/mdvsec-ap_1.4.0_all.deb

# Install with apt (auto-installs dependencies)
sudo apt install ./mdvsec-ap_1.4.0_all.deb

# Run the software
sudo mdvsec-ap
```

### Method 2: Using Standalone Script

```bash
# Download the script
wget https://github.com/brahmanggi/accesspointsec/releases/download/v1.4.0/install.sh

# Make executable
chmod +x install.sh

# Run the script
sudo ./install.sh
```

---

## 🚀 Features

### Core Features
- 📡 WiFi Access Point setup (2.4GHz, 5GHz, 6GHz)
- 🎨 Interactive menu-driven interface
- 🔧 Automated configuration with sensible defaults
- 🌐 Multi-WAN support (Ethernet, WiFi WAN, USB tethering)

### Security Features
- 🔒 DNS over HTTPS (DoH) via Cloudflared
- 🛡️ WireGuard VPN integration
- 🔍 Suricata IDS/IPS for threat detection
- 🔐 WPA2/WPA3 encryption support
- 🔑 Admin password protection

### Advanced Features
- 🔄 WAN Failover with automatic switching
- 📱 Telegram notifications for events
- 📊 SNMP monitoring support
- 📈 Built-in speed testing
- 👥 Client connection monitoring
- 💾 Configuration backup/restore

### Management Features
- 🖥️ Real-time system status dashboard
- 📝 Service logs viewer (hostapd, dnsmasq, cloudflared, etc.)
- 🔧 Automatic NAT/routing fixer
- ⚡ Service control (start, stop, restart)

---

## 🌍 Supported Platforms

### Operating Systems
- ✅ Debian 10, 11, 12+
- ✅ Ubuntu 18.04, 20.04, 22.04, 24.04+
- ✅ Raspberry Pi OS (all versions)
- ✅ Linux Mint 19+
- ✅ Pop!_OS 20.04+
- ✅ Elementary OS 6+
- ✅ Kali Linux
- ✅ Any Debian-based distribution

### Architectures
- ✅ x86 (32-bit Intel/AMD)
- ✅ x64/amd64 (64-bit Intel/AMD)
- ✅ ARM (32-bit ARM devices)
- ✅ ARM64/aarch64 (Raspberry Pi 3/4/5)

### Tested Hardware
- Raspberry Pi 1, 2, 3, 4, 5
- Raspberry Pi Zero W
- Intel/AMD x86/x64 systems
- VirtualBox/VMware VMs
- Orange Pi, Banana Pi

---

## 📋 System Requirements

### Minimum
- **RAM**: 512 MB (1 GB recommended)
- **Storage**: 100 MB for software + dependencies
- **Network**: At least one wireless interface supporting AP mode

### Dependencies
**Required** (auto-installed with .deb):
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

## 🔧 Quick Start

1. Install the package using one of the methods above
2. Run: `sudo mdvsec-ap`
3. Select "Quick Start" from the menu
4. Follow the prompts to configure your access point
5. Connect to your new WiFi network!

---

## 📚 Documentation

- **README**: Full documentation in the repository
- **Installation Guide**: See `INSTALL.txt`
- **Package Details**: See `PACKAGE_README.md`
- **Troubleshooting**: Included in README.md

---

## 🐛 Known Issues

- Software is in BETA - expect bugs
- Some WiFi adapters may not support all features
- WAN failover requires manual script installation
- Telegram notifications require bot setup

---

## 🤝 Contributing

Contributions are welcome! Please see the README for guidelines.

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/brahmanggi/accesspointsec/issues)
- **Discussions**: [GitHub Discussions](https://github.com/brahmanggi/accesspointsec/discussions)
- **Email**: brahmanggi@gmail.com

---

## 📝 Changelog

### Added
- Initial release of MDVSEC Secure Access Point
- Colorful ASCII art banner (blue, white, yellow)
- Debian package support for all architectures
- DNS over HTTPS configuration
- WireGuard VPN integration
- Suricata IDS/IPS support
- WAN failover functionality
- Telegram notification system
- SNMP monitoring support
- Interactive menu system
- Client connection monitoring
- Configuration backup/restore
- Comprehensive documentation

### Changed
- Rebranded from IntraSec to MDVSEC
- Updated all service names and file paths
- Improved installation experience

---

## 📄 License

GNU General Public License v3.0

---

**Thank you for using MDVSEC Secure Access Point!** ⚡

Please report any issues or provide feedback on GitHub.
