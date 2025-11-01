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

**Easy WiFi Access Point setup with security features**

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Version](https://img.shields.io/badge/version-1.4.0-green.svg)](https://github.com/brahmanggi/accesspointsec/releases)

</div>

---

## ⚠️ **IMPORTANT WARNING**

> [!WARNING]
> **This software is BETA and UNSTABLE. Use at your own risk!**
>
> - Not recommended for production
> - Backup your data before use
> - Report bugs on GitHub

---

## 🚀 Quick Install

### Option 1: Install via .deb Package (Recommended)

```bash
# Download
wget https://github.com/brahmanggi/accesspointsec/releases/download/v1.4.0/mdvsec-ap_1.4.0_all.deb

# Install
sudo apt install ./mdvsec-ap_1.4.0_all.deb

# Run
sudo mdvsec-ap
```

### Option 2: Run Script Directly

```bash
# Download
wget https://github.com/brahmanggi/accesspointsec/releases/download/v1.4.0/install.sh

# Make executable and run
chmod +x install.sh
sudo ./install.sh
```

---

## 📋 What Does It Do?

MDVSEC turns your Linux computer or Raspberry Pi into a secure WiFi Access Point with:

- 📡 **WiFi Hotspot** - Share your internet via WiFi (2.4GHz/5GHz/6GHz)
- 🔒 **DNS over HTTPS** - Encrypted DNS for privacy
- 🛡️ **VPN Support** - WireGuard integration
- 🔍 **Threat Detection** - Suricata IDS/IPS
- 📱 **Telegram Alerts** - Get notified when devices connect
- 🔄 **Auto Failover** - Switch between internet sources automatically

---

## 💻 Supported Systems

Works on any Debian-based Linux:

| System | Architectures |
|--------|---------------|
| **Debian** 10/11/12+ | x86, x64, ARM, ARM64 |
| **Ubuntu** 18.04/20.04/22.04/24.04+ | x86, x64, ARM, ARM64 |
| **Raspberry Pi OS** | ARM, ARM64 |
| **Linux Mint** | x86, x64 |
| **Other Debian-based** | Most architectures |

---

## 🎯 Quick Start

1. **Install** using one of the methods above
2. **Run**: `sudo mdvsec-ap`
3. **Select**: "Quick Start" from menu
4. **Configure**: Enter SSID and password
5. **Done**: Connect to your new WiFi!

---

## 🔨 Build .deb Package

Want to build the package yourself?

```bash
# Install build tools
sudo apt install dpkg-dev git

# Clone repository
git clone https://github.com/brahmanggi/accesspointsec.git
cd accesspointsec

# Build
./build-deb.sh

# Package will be in dist/ folder
```

---

## 🗑️ Uninstall

```bash
# Remove (keep settings)
sudo apt remove mdvsec-ap

# Remove everything
sudo apt purge mdvsec-ap
```

---

## 📖 Documentation

- **Full Docs**: [PACKAGE_README.md](PACKAGE_README.md)
- **Install Guide**: [INSTALL.txt](INSTALL.txt)
- **Latest Release**: [v1.4.0](https://github.com/brahmanggi/accesspointsec/releases/tag/v1.4.0)

---

## 🐛 Issues or Questions?

- **Report bugs**: [GitHub Issues](https://github.com/brahmanggi/accesspointsec/issues)
- **Ask questions**: [GitHub Discussions](https://github.com/brahmanggi/accesspointsec/discussions)
- **Email**: brahmanggi@gmail.com

---

## 📄 License

GPL-3.0 License - See [LICENSE](LICENSE) for details

---

<div align="center">

**Made with ❤️ by MDVSEC Team**

Give it a ⭐ if you find it useful!

</div>
