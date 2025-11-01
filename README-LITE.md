# MDVSEC Lite - Simplified Access Point

<div align="center">

```
███╗   ███╗██████╗ ██╗   ██╗███████╗███████╗ ██████╗
████╗ ████║██╔══██╗██║   ██║██╔════╝██╔════╝██╔════╝
██╔████╔██║██║  ██║██║   ██║███████╗█████╗  ██║
██║╚██╔╝██║██║  ██║╚██╗ ██╔╝╚════██║██╔══╝  ██║
██║ ╚═╝ ██║██████╔╝ ╚████╔╝ ███████║███████╗╚██████╗
╚═╝     ╚═╝╚═════╝   ╚═══╝  ╚══════╝╚══════╝ ╚═════╝

              LITE VERSION
```

**Minimal WiFi Access Point for Low-Resource Systems**

</div>

---

## 🎯 What is MDVSEC Lite?

MDVSEC Lite is a **simplified version** designed for:
- 💾 **Low-resource systems** (Raspberry Pi Zero, older hardware)
- 🎯 **Basic Access Point needs** without advanced features
- ⚡ **Quick setup** with minimal dependencies
- 🔒 **Essential security** only

---

## ⚙️ Minimum System Requirements

### Hardware
| Component | Minimum | Recommended |
|-----------|---------|-------------|
| **CPU** | 700 MHz Single Core | 1 GHz+ |
| **RAM** | 256 MB | 512 MB |
| **Storage** | 50 MB free | 100 MB |
| **Network** | 1x Ethernet + 1x WiFi | Same |

### Tested Devices
- ✅ Raspberry Pi Zero W (512 MB RAM)
- ✅ Raspberry Pi 1 Model B (512 MB RAM)
- ✅ Raspberry Pi 2/3/4/5
- ✅ Old laptops with 512 MB+ RAM
- ✅ Virtual machines with limited resources

---

## 📋 Features Comparison

| Feature | Full Version | Lite Version |
|---------|-------------|--------------|
| **WiFi Access Point** | ✅ | ✅ |
| **DNS over HTTPS** | ✅ | ✅ (Optional) |
| **WireGuard VPN** | ✅ | ✅ (Optional) |
| **Telegram Notifications** | ✅ | ✅ (Optional) |
| **SNMP Monitoring** | ✅ | ✅ (Optional) |
| **Suricata IDS/IPS** | ✅ | ❌ Removed |
| **WAN Failover** | ✅ | ❌ Removed |
| **Multi-WAN Support** | ✅ | ❌ Removed |
| **WiFi WAN** | ✅ | ❌ Removed |
| **Internet Source** | Multiple | **eth0 only** |
| **Client Monitoring** | ✅ | ✅ |

---

## 🚀 Quick Install

### Option 1: Download Lite Script

```bash
# Download lite version
wget https://github.com/brahmanggi/accesspointsec/releases/download/v1.4.0-lite/install-lite.sh

# Make executable
chmod +x install-lite.sh

# Run
sudo ./install-lite.sh
```

### Option 2: Use Full Version (Lite Mode)

Use the full version but skip advanced features:

```bash
# Install full version
wget https://github.com/brahmanggi/accesspointsec/releases/download/v1.4.0/mdvsec-ap_1.4.0_all.deb
sudo apt install ./mdvsec-ap_1.4.0_all.deb

# Run
sudo mdvsec-ap

# In menu:
# 1. Select "Quick Start"
# 2. Skip Suricata setup
# 3. Skip WAN Failover
# 4. Use eth0 as internet source
```

---

## 💻 What's Removed?

### 🛡️ Suricata IDS/IPS
**Why removed**: High resource usage
- CPU: ~30-50% on low-end devices
- RAM: 200-300 MB minimum
- Storage: Rules database 50+ MB

**Impact**: No threat detection/prevention
**Alternative**: Use lightweight firewall rules

### 🔄 WAN Failover
**Why removed**: Complex, unnecessary for basic setups
- Requires monitoring multiple interfaces
- Background daemon overhead
- Most home setups have single internet source

**Impact**: Cannot automatically switch internet sources
**Alternative**: Manual interface selection

### 📡 WiFi WAN Support
**Why removed**: Simplifies configuration
- Reduces complexity
- Most setups use Ethernet for internet

**Impact**: Must use eth0 (Ethernet) for internet
**Alternative**: Use USB Ethernet adapter if needed

---

## 🔧 Installation Steps

### 1. Install Dependencies

```bash
sudo apt update
sudo apt install hostapd dnsmasq iptables iw
```

**That's it!** Lite version needs only 4 core packages.

### 2. Configure

```bash
sudo ./install-lite.sh
```

### 3. Setup WiFi AP

- Enter SSID (e.g., "MyWiFi")
- Enter password (min 8 characters)
- Select wlan0 as AP interface
- **Internet source**: Automatically uses eth0

### 4. Done!

Connect ethernet cable to eth0 and your WiFi AP is ready.

---

## 📊 Resource Usage Comparison

### Full Version
```
CPU:  15-50% (with Suricata)
RAM:  300-500 MB
Disk: 150 MB
```

### Lite Version
```
CPU:  5-15%
RAM:  100-200 MB
Disk: 50 MB
```

**Savings**: ~50-70% less resource usage!

---

## 🌐 Network Topology

### Simple Setup (Lite)

```
Internet
   |
 [eth0] ← Internet from ISP/Router
   |
Linux PC/Pi (MDVSEC Lite)
   |
[wlan0] ← WiFi Access Point
   |
Devices (Phones, Laptops, etc.)
```

### Requirements
- ✅ Ethernet cable from router/modem to eth0
- ✅ WiFi adapter for wlan0 (built-in or USB)
- ❌ No second WAN source needed
- ❌ No failover configuration needed

---

## ⚙️ Configuration

### Default Settings

| Setting | Value |
|---------|-------|
| SSID | `mdvsec-lite` |
| Password | `SecurePass123` |
| WiFi Interface | `wlan0` |
| Internet Interface | `eth0` (fixed) |
| IP Range | `192.168.4.0/24` |
| Gateway | `192.168.4.1` |
| DHCP Range | `.100 - .250` |

### Enable Optional Features

After basic setup, you can optionally enable:

```bash
sudo mdvsec-ap

# From menu:
# 2) WiFi Setup
# 3) Security Settings
#    1) Configure DNS over HTTPS  ← Optional
#    2) Setup WireGuard VPN       ← Optional
#    4) Telegram Notifications    ← Optional
#    5) SNMP Monitoring           ← Optional
```

---

## 🎯 Use Cases

### Perfect For:
- ✅ Home WiFi sharing
- ✅ Small office (< 10 devices)
- ✅ Travel router
- ✅ Guest WiFi network
- ✅ IoT device connectivity
- ✅ Learning/testing
- ✅ Raspberry Pi Zero projects

### Not Suitable For:
- ❌ Enterprise networks
- ❌ High-security requirements
- ❌ Networks needing IDS/IPS
- ❌ Multi-WAN setups
- ❌ Automatic failover needs
- ❌ Heavy traffic (50+ devices)

---

## 🔒 Security Considerations

### What's Included:
- ✅ WPA2/WPA3 WiFi encryption
- ✅ NAT firewall
- ✅ Basic iptables rules
- ✅ Admin password protection
- ✅ Optional DoH for DNS privacy
- ✅ Optional WireGuard VPN

### What's Missing (vs Full):
- ❌ No Suricata threat detection
- ❌ No intrusion prevention
- ❌ No advanced traffic analysis

### Security Tips:
1. Use strong WiFi password (12+ characters)
2. Change default admin password
3. Keep system updated: `sudo apt update && sudo apt upgrade`
4. Enable DoH for DNS privacy
5. Consider adding WireGuard VPN

---

## 📝 Quick Command Reference

```bash
# Start Access Point
sudo systemctl start hostapd dnsmasq

# Stop Access Point
sudo systemctl stop hostapd dnsmasq

# Restart Access Point
sudo systemctl restart hostapd dnsmasq

# View Connected Clients
cat /var/lib/misc/dnsmasq.leases

# View AP Status
sudo systemctl status hostapd

# Check Internet Connection
ping -c 4 8.8.8.8

# View IP Forwarding (should be 1)
cat /proc/sys/net/ipv4/ip_forward

# Manual NAT Fix
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```

---

## 🔧 Troubleshooting

### WiFi Not Appearing

```bash
# Check hostapd status
sudo systemctl status hostapd

# Check if interface is up
ip link show wlan0

# Manually start
sudo systemctl start hostapd
```

### Devices Connect But No Internet

```bash
# Check IP forwarding
sudo sysctl -w net.ipv4.ip_forward=1

# Check NAT rules
sudo iptables -t nat -L -n -v

# Verify eth0 has internet
ping -I eth0 8.8.8.8
```

### Low Performance

```bash
# Check CPU usage
top

# Check memory
free -h

# Reduce DHCP lease time in /etc/dnsmasq.conf
dhcp-leasetime=12h  # Instead of 24h
```

---

## 📦 Package Size Comparison

| Version | Download Size | Installed Size | Dependencies |
|---------|--------------|----------------|--------------|
| **Full** | 22 KB | ~100 MB | 15+ packages |
| **Lite** | 18 KB | ~50 MB | 4 core packages |

---

## 🆚 Should I Use Lite or Full?

### Choose LITE if:
- 💾 You have **limited RAM** (< 1 GB)
- 🎯 You need **basic WiFi sharing** only
- ⚡ You want **quick, simple setup**
- 🏠 Home or personal use
- 📶 Internet via **Ethernet only**

### Choose FULL if:
- 💪 You have **adequate resources** (1 GB+ RAM)
- 🛡️ You need **threat detection** (IDS/IPS)
- 🔄 You need **WAN failover**
- 📡 You use **multiple internet sources**
- 🏢 Business or production use

---

## 📖 Documentation

- **Main README**: [README.md](README.md)
- **Full Documentation**: [PACKAGE_README.md](PACKAGE_README.md)
- **Installation Guide**: [INSTALL.txt](INSTALL.txt)

---

## 🐛 Support

- **Issues**: [GitHub Issues](https://github.com/brahmanggi/accesspointsec/issues)
- **Discussions**: [GitHub Discussions](https://github.com/brahmanggi/accesspointsec/discussions)
- **Email**: brahmanggi@gmail.com

**Please mention "LITE VERSION" when reporting issues**

---

## 📄 License

GPL-3.0 License - Same as full version

---

<div align="center">

**MDVSEC Lite - Perfect for Raspberry Pi Zero and low-resource systems!**

⭐ Star the repo if you find it useful!

</div>
