#!/bin/bash
set -e
set -x

if [ $# -ne 1 ]; then
    echo "Usage: $0 DEB file"
    exit 1
fi

DEB_FILE=$1

## Check if the DEB file exists
if [ ! -f "$DEB_FILE" ]; then
    echo "Error: DEB file not found: $DEB_FILE"
    exit 1
fi


# Create build directory
BUILD_DIR="build_flatpak"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Copy necessary files
cp ../"$DEB_FILE" OpenAudible_x86_64.deb
cp ../org.openaudible.OpenAudible.yml .
cp ../org.openaudible.OpenAudible.desktop .
cp ../org.openaudible.OpenAudible.png .
cp ../org.openaudible.OpenAudible.appdata.xml .

## Extract the .deb file and get version/date as json.
mkdir -p openaudible_extracted
dpkg-deb -x "$DEB_FILE" openaudible_extracted
APPDIR=./openaudible

mv openaudible_extracted/opt/OpenAudible $APPDIR
"$APPDIR"/OpenAudible --info > info.json
rm -rf openaudible_extracted

# Use jq to extract json data. apt install jq  -y

VERSION=$(cat info.json | jq -r '.appVersion' )
RELEASE_DATE=$(cat info.json | jq -r '.release_date' )

echo "Extracted $VERSION released $RELEASEDATE"


# Update version in AppData file
sed -i "s/VERSION/$VERSION/" org.openaudible.OpenAudible.appdata.xml
sed -i "s/YYYY-MM-DD/$RELEASE_DATE/" org.openaudible.OpenAudible.appdata.xml

# Ensure Flathub remote is added
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo

# Install required runtime
flatpak install -y --user flathub org.gnome.{Platform,Sdk}//47
<<<<<<< Updated upstream
=======

# Install flatpak builder
flatpak install -y --user flathub org.flatpak.Builder
>>>>>>> Stashed changes

## Initialize build directory
#flatpak build-init  "$BUILD_DIR" org.openaudible.OpenAudible org.freedesktop.Sdk org.freedesktop.Platform 24.08

# Build Flatpak
flatpak-builder  --force-clean --disable-rofiles-fuse --repo=repo "$BUILD_DIR" org.openaudible.OpenAudible.yml

# Create Flatpak bundle
flatpak build-bundle  repo OpenAudible-$VERSION.flatpak org.openaudible.OpenAudible

echo "Flatpak bundle created: OpenAudible-$VERSION.flatpak"

# Return to previous directory
cd ..

