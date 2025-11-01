# MDVSEC v1.4.0 - WiFi Access Point Tool

> [!WARNING]
> **BETA Software - Use at your own risk!**

Turn your Linux PC or Raspberry Pi into a secure WiFi hotspot.

---

## 📥 Download

Choose the version that fits your system:

### 🚀 Full Version
**For systems with 1GB+ RAM**

| File | Install Command |
|------|-----------------|
| **mdvsec-ap_1.4.0_all.deb** | `sudo apt install ./mdvsec-ap_1.4.0_all.deb` |
| **install.sh** | `chmod +x install.sh && sudo ./install.sh` |

**Features**: All features including IDS/IPS, WAN failover, threat detection

### 💾 Lite Version
**For systems with 256MB+ RAM (Raspberry Pi Zero, old hardware)**

| File | Install Command |
|------|-----------------|
| **install-lite.sh** | `chmod +x install-lite.sh && sudo ./install-lite.sh` |

**Features**: Basic WiFi AP, no IDS/IPS, no failover, eth0-only internet

---

## 🎯 Quick Start

**Full Version:**
```bash
wget https://github.com/brahmanggi/accesspointsec/releases/download/v1.4.0/mdvsec-ap_1.4.0_all.deb
sudo apt install ./mdvsec-ap_1.4.0_all.deb
sudo mdvsec-ap
```

**Lite Version:**
```bash
wget https://github.com/brahmanggi/accesspointsec/releases/download/v1.4.0/install-lite.sh
chmod +x install-lite.sh
sudo ./install-lite.sh
```

---

## ✨ What's Included

### Full Version Features
- ✅ WiFi Access Point (2.4/5/6 GHz)
- ✅ DNS over HTTPS
- ✅ WireGuard VPN
- ✅ Suricata IDS/IPS (threat detection)
- ✅ WAN Failover (auto-switch internet sources)
- ✅ Telegram notifications
- ✅ SNMP monitoring

### Lite Version Features
- ✅ WiFi Access Point (2.4/5/6 GHz)
- ✅ DNS over HTTPS (optional)
- ✅ WireGuard VPN (optional)
- ✅ Telegram notifications (optional)
- ❌ No Suricata IDS/IPS
- ❌ No WAN Failover
- ⚡ 50-70% less resource usage

---

## 💻 Requirements

| Version | CPU | RAM | Storage |
|---------|-----|-----|---------|
| **Full** | 1 GHz+ | 1 GB | 100 MB |
| **Lite** | 700 MHz+ | 256 MB | 50 MB |

---

## 🌍 Works On

- Debian 10/11/12+
- Ubuntu 18.04/20.04/22.04/24.04+
- Raspberry Pi OS
- Linux Mint, Pop!_OS, Elementary OS
- Any Debian-based distro

**Architectures**: x86, x64, ARM, ARM64

---

## 📖 Documentation

- [Main README](https://github.com/brahmanggi/accesspointsec/blob/master/README.md)
- [Lite Version README](https://github.com/brahmanggi/accesspointsec/blob/master/README-LITE.md)
- [Full Documentation](https://github.com/brahmanggi/accesspointsec/blob/master/PACKAGE_README.md)

---

## 🐛 Issues?

[Report bugs here](https://github.com/brahmanggi/accesspointsec/issues)

---

**Made with ❤️ by MDVSEC Team** | GPL-3.0 License
