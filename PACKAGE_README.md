# MDVSEC Secure Access Point - Debian Package

A comprehensive WiFi Access Point management tool with advanced security features, packaged for easy installation on Debian-based systems.

## Package Information

- **Package Name:** mdvsec-ap
- **Version:** 1.4.0
- **Architecture:** all (universal binary)
- **Supported Platforms:**
  - x86 (32-bit Intel/AMD)
  - x64/amd64 (64-bit Intel/AMD)
  - ARM (32-bit ARM)
  - ARM64/aarch64 (64-bit ARM - Raspberry Pi 3/4/5)

## Supported Operating Systems

### Tested and Verified
- ✅ Debian 10, 11, 12+
- ✅ Ubuntu 18.04, 20.04, 22.04, 24.04+
- ✅ Raspberry Pi OS (Raspbian) - All versions
- ✅ Linux Mint 19+
- ✅ Pop!_OS 20.04+
- ✅ Elementary OS 6+
- ✅ MX Linux
- ✅ Kali Linux

### Should Work On
- Any Debian-based distribution
- Any Ubuntu derivative

## Features

- 🚀 **Easy WiFi AP Setup** - Quick configuration for 2.4GHz, 5GHz, and 6GHz bands
- 🔒 **DNS over HTTPS (DoH)** - Privacy-focused DNS via Cloudflared
- 🛡️ **WireGuard VPN** - Secure VPN tunnel integration
- 🔍 **Suricata IDS/IPS** - Real-time threat detection and prevention
- 🔄 **WAN Failover** - Automatic internet source switching
- 📱 **Telegram Notifications** - Real-time alerts for connections and threats
- 📊 **SNMP Monitoring** - Network management and monitoring
- 🎯 **Multi-Architecture** - Works on x86, x64, ARM, and ARM64

## Building the Package

### Prerequisites

```bash
sudo apt update
sudo apt install dpkg-dev
```

### Build Instructions

1. Clone or download the repository:
```bash
cd /home/aditya/ideasdev/accesspointsec
```

2. Run the build script:
```bash
./build-deb.sh
```

3. The package will be created in the `dist/` directory:
```
dist/mdvsec-ap_1.4.0_all.deb
```

## Installation

### Method 1: Using apt (Recommended)

This method automatically installs dependencies:

```bash
sudo apt install ./mdvsec-ap_1.4.0_all.deb
```

### Method 2: Using dpkg

```bash
sudo dpkg -i mdvsec-ap_1.4.0_all.deb
sudo apt-get install -f  # Install missing dependencies
```

### Method 3: From Release

Download the latest release and install:

```bash
wget https://github.com/mdvsec/secure-ap/releases/download/v1.4.0/mdvsec-ap_1.4.0_all.deb
sudo apt install ./mdvsec-ap_1.4.0_all.deb
```

## Usage

After installation, run the tool with root privileges:

```bash
sudo mdvsec-ap
```

The interactive menu will guide you through:
1. **Quick Start** - Automated setup
2. **WiFi Setup** - Configure SSID, password, channel
3. **Security Settings** - Enable DoH, VPN, IDS/IPS
4. **Admin Menu** - System management and monitoring

## Package Contents

### Installed Files

- `/usr/local/bin/mdvsec-ap` - Main executable script
- `/etc/secure-ap/` - Configuration directory (created on first run)

### Runtime Files (Created by script)

- `/usr/local/bin/mdvsec-notify` - Telegram notification helper
- `/usr/local/bin/mdvsec-monitor-clients` - Client monitoring daemon
- `/usr/local/bin/mdvsec-wan-failover.sh` - WAN failover daemon
- `/etc/systemd/system/mdvsec-client-monitor.service` - Client monitoring service
- `/etc/systemd/system/mdvsec-failover.service` - Failover service

## Dependencies

### Required (Auto-installed)
- bash (>= 4.0)
- hostapd
- dnsmasq
- iproute2
- iptables
- openssl
- iw
- lsb-release
- isc-dhcp-client or dhcpcd5

### Optional (Recommended)
- wireguard - For VPN functionality
- cloudflared - For DNS over HTTPS
- suricata - For IDS/IPS
- speedtest-cli - For speed testing
- snmpd - For SNMP monitoring
- curl - For Telegram notifications

### Optional (Suggested)
- iptables-persistent - For persistent firewall rules
- netfilter-persistent - For netfilter persistence

## Architecture Support

The package uses `Architecture: all` because it's a bash script that runs on any architecture. It automatically detects the system architecture and configures accordingly.

### Tested Hardware

- **x86/x64:**
  - Intel/AMD desktops and laptops
  - Virtual machines (VirtualBox, VMware, KVM)

- **ARM32:**
  - Raspberry Pi 1, Zero, Zero W
  - Raspberry Pi 2

- **ARM64:**
  - Raspberry Pi 3 (B, B+, A+)
  - Raspberry Pi 4 (1GB, 2GB, 4GB, 8GB)
  - Raspberry Pi 5
  - Orange Pi, Banana Pi

## Uninstallation

### Remove package (keep configuration):
```bash
sudo apt remove mdvsec-ap
```

### Remove package and configuration:
```bash
sudo apt purge mdvsec-ap
```

This will prompt you to delete `/etc/secure-ap/` configuration directory.

## Configuration Files

Configuration files are stored in `/etc/secure-ap/`:
- `config.conf` - Main configuration
- `.admin_password` - Admin password hash
- `.telegram_configured` - Telegram settings
- `failover.conf` - WAN failover configuration

These files are preserved during package removal and only deleted on purge (with confirmation).

## Troubleshooting

### Package Installation Issues

**Problem:** Dependencies not found
```bash
sudo apt update
sudo apt install -f
```

**Problem:** Package won't install
```bash
# Check package info
dpkg-deb -I mdvsec-ap_1.4.0_all.deb

# Check package contents
dpkg-deb -c mdvsec-ap_1.4.0_all.deb
```

### Runtime Issues

**Problem:** Script won't run
```bash
# Check if installed
which mdvsec-ap

# Check permissions
ls -l /usr/local/bin/mdvsec-ap

# Run with full path
sudo /usr/local/bin/mdvsec-ap
```

**Problem:** WiFi interface not detected
```bash
# List wireless interfaces
iw dev
ip link show

# Check wireless capabilities
iw list
```

## Building for Distribution

### Create Release Package

1. Update version in:
   - `mdvsec-ap-deb/DEBIAN/control`
   - `build-deb.sh`
   - `install.sh` (print_header function)

2. Build the package:
```bash
./build-deb.sh
```

3. Test on different architectures:
```bash
# On x64 system
sudo apt install ./dist/mdvsec-ap_1.4.0_all.deb
sudo mdvsec-ap

# On Raspberry Pi (ARM64)
sudo apt install ./dist/mdvsec-ap_1.4.0_all.deb
sudo mdvsec-ap
```

4. Create checksums:
```bash
cd dist
sha256sum mdvsec-ap_1.4.0_all.deb > mdvsec-ap_1.4.0_all.deb.sha256
md5sum mdvsec-ap_1.4.0_all.deb > mdvsec-ap_1.4.0_all.deb.md5
```

## License

See LICENSE file for details.

## Support

- GitHub Issues: https://github.com/mdvsec/secure-ap/issues
- Documentation: https://github.com/mdvsec/secure-ap/wiki
- Email: admin@mdvsec.local

## Contributing

Contributions are welcome! Please see CONTRIBUTING.md for guidelines.

## Changelog

### Version 1.4.0
- Initial Debian package release
- Multi-architecture support (x86, x64, ARM, ARM64)
- Automated installation and removal scripts
- Systemd service integration
- Configuration preservation on upgrade

---

**Note:** This package requires root privileges to configure network interfaces and system services. Always review scripts before running with sudo.
