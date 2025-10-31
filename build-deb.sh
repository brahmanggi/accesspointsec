#!/bin/bash

################################################################################
# MDVSEC Debian Package Builder
# Creates .deb packages for x86, x64, and ARM/ARM64 architectures
################################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Package information
PACKAGE_NAME="mdvsec-ap"
VERSION="1.4.0"
BUILD_DIR="mdvsec-ap-deb"
OUTPUT_DIR="dist"

echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  ${BLUE}MDVSEC Debian Package Builder${NC}                     ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${YELLOW}Version: ${VERSION}${NC}                                    ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if running as root (not needed for building)
if [[ $EUID -eq 0 ]]; then
    echo -e "${YELLOW}Warning: Building as root is not recommended${NC}"
    read -p "Continue anyway? (y/n): " continue_root
    if [[ "$continue_root" != "y" ]]; then
        exit 1
    fi
fi

# Check dependencies
echo -e "${BLUE}[1/5]${NC} Checking dependencies..."
if ! command -v dpkg-deb &>/dev/null; then
    echo -e "${RED}Error: dpkg-deb not found. Install it with: sudo apt install dpkg-dev${NC}"
    exit 1
fi
echo -e "${GREEN}✓${NC} Dependencies OK"

# Verify package structure
echo -e "${BLUE}[2/5]${NC} Verifying package structure..."
if [[ ! -d "$BUILD_DIR" ]]; then
    echo -e "${RED}Error: Build directory '$BUILD_DIR' not found${NC}"
    exit 1
fi

required_files=(
    "$BUILD_DIR/DEBIAN/control"
    "$BUILD_DIR/DEBIAN/postinst"
    "$BUILD_DIR/DEBIAN/prerm"
    "$BUILD_DIR/DEBIAN/postrm"
    "$BUILD_DIR/usr/local/bin/mdvsec-ap"
)

for file in "${required_files[@]}"; do
    if [[ ! -f "$file" ]]; then
        echo -e "${RED}Error: Required file '$file' not found${NC}"
        exit 1
    fi
done
echo -e "${GREEN}✓${NC} Package structure OK"

# Set proper permissions
echo -e "${BLUE}[3/5]${NC} Setting permissions..."
find "$BUILD_DIR" -type d -exec chmod 755 {} \;
find "$BUILD_DIR" -type f -exec chmod 644 {} \;
chmod 755 "$BUILD_DIR/DEBIAN/postinst"
chmod 755 "$BUILD_DIR/DEBIAN/prerm"
chmod 755 "$BUILD_DIR/DEBIAN/postrm"
chmod 755 "$BUILD_DIR/usr/local/bin/mdvsec-ap"
echo -e "${GREEN}✓${NC} Permissions set"

# Create output directory
echo -e "${BLUE}[4/5]${NC} Creating output directory..."
mkdir -p "$OUTPUT_DIR"
echo -e "${GREEN}✓${NC} Output directory ready"

# Build the package
echo -e "${BLUE}[5/5]${NC} Building .deb package..."
PACKAGE_FILE="${OUTPUT_DIR}/${PACKAGE_NAME}_${VERSION}_all.deb"

# Remove old package if exists
if [[ -f "$PACKAGE_FILE" ]]; then
    rm "$PACKAGE_FILE"
fi

# Build the package
dpkg-deb --build --root-owner-group "$BUILD_DIR" "$PACKAGE_FILE" 2>&1 | grep -v "warning: empty field"

if [[ -f "$PACKAGE_FILE" ]]; then
    echo -e "${GREEN}✓${NC} Package built successfully!"
    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}Package Information:${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
    echo -e "  📦 Package: ${CYAN}$PACKAGE_FILE${NC}"
    echo -e "  📏 Size: ${YELLOW}$(du -h "$PACKAGE_FILE" | cut -f1)${NC}"
    echo -e "  🏗️  Architecture: ${BLUE}all${NC} (supports x86, x64, ARM, ARM64)"
    echo ""

    # Get package info
    echo -e "${BLUE}Package Details:${NC}"
    dpkg-deb -I "$PACKAGE_FILE" | grep -E "Package:|Version:|Architecture:|Depends:|Description:" | sed 's/^/  /'
    echo ""

    echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}Installation:${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
    echo -e "  ${YELLOW}On Debian/Ubuntu/Raspberry Pi OS:${NC}"
    echo -e "    sudo dpkg -i $PACKAGE_FILE"
    echo -e "    sudo apt-get install -f  ${BLUE}# Install dependencies${NC}"
    echo ""
    echo -e "  ${YELLOW}Or using apt:${NC}"
    echo -e "    sudo apt install ./$PACKAGE_FILE"
    echo ""
    echo -e "  ${YELLOW}After installation, run:${NC}"
    echo -e "    sudo mdvsec-ap"
    echo ""
    echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}Supported Systems:${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
    echo -e "  ✓ Debian 10, 11, 12+ (x86, x64, ARM)"
    echo -e "  ✓ Ubuntu 18.04, 20.04, 22.04, 24.04+ (x86, x64, ARM)"
    echo -e "  ✓ Raspberry Pi OS (ARM, ARM64)"
    echo -e "  ✓ Linux Mint, Pop!_OS, Elementary OS"
    echo -e "  ✓ Any Debian-based distribution"
    echo ""

    # Verify package
    echo -e "${BLUE}Verifying package integrity...${NC}"
    if dpkg-deb --contents "$PACKAGE_FILE" >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} Package integrity verified"
    else
        echo -e "${RED}✗${NC} Package verification failed"
        exit 1
    fi

    echo ""
    echo -e "${GREEN}🎉 Build complete!${NC}"
    echo ""
else
    echo -e "${RED}✗${NC} Failed to build package"
    exit 1
fi
