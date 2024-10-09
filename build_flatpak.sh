#!/bin/bash
set -e
set -x

if [ $# -ne 2 ]; then
    echo "Usage: $0 <version> <deb_file>"
    exit 1
fi

VERSION=$1
DEB_FILE=$2

# Check if the DEB file exists
if [ ! -f "$DEB_FILE" ]; then
    echo "Error: DEB file not found: $DEB_FILE"
    exit 1
fi

# Check if the system is x86_64
if [ "$(uname -m)" != "x86_64" ]; then
    echo "Error: OpenAudible Flatpak can only be built on x86_64 systems."
    exit 1
fi

# Create build directory
BUILD_DIR="build_flatpak"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Copy necessary files
cp ../"$DEB_FILE" OpenAudible.deb
cp ../org.openaudible.OpenAudible.yml .
cp ../org.openaudible.OpenAudible.desktop .
cp ../org.openaudible.OpenAudible.png .
cp ../org.openaudible.OpenAudible.appdata.xml .

# Extract the .deb file
mkdir -p openaudible_extracted
dpkg-deb -x OpenAudible.deb openaudible_extracted

# Update version in AppData file
sed -i "s/VERSION/$VERSION/" org.openaudible.OpenAudible.appdata.xml
sed -i "s/YYYY-MM-DD/$(date +%Y-%m-%d)/" org.openaudible.OpenAudible.appdata.xml

# Ensure Flathub remote is added
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo

# Install required runtime
flatpak install --user -y flathub org.freedesktop.Platform//23.08 org.freedesktop.Sdk//23.08

# Initialize build directory
flatpak build-init  "$BUILD_DIR" org.openaudible.OpenAudible org.freedesktop.Sdk org.freedesktop.Platform 23.08

# Build Flatpak
flatpak-builder  --force-clean --disable-rofiles-fuse --repo=repo "$BUILD_DIR" org.openaudible.OpenAudible.yml

# Create Flatpak bundle
flatpak build-bundle  repo OpenAudible-$VERSION.flatpak org.openaudible.OpenAudible

echo "Flatpak bundle created: OpenAudible-$VERSION.flatpak"

# Return to previous directory
cd ..
