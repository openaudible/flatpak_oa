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

GPG=
# Create build directory
BUILD_DIR="build"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"


# TODO: Replace URL, Version, and SHA256.
cp ../org.openaudible.OpenAudible.yml .


# Copy necessary files
#cp ../"$DEB_FILE" $DEB_FILE
#cp ../org.openaudible.OpenAudible.yml .
#cp ../org.openaudible.OpenAudible.desktop .
#cp ../org.openaudible.OpenAudible.png .
#cp ../org.openaudible.OpenAudible.appdata.xml .
#cp ../bin_openaudible .

## Extract the .deb file and get version/date as json.
#mkdir -p openaudible_extracted
#dpkg-deb -x "$DEB_FILE" openaudible_extracted
#APPDIR=./openaudible
#
#mv openaudible_extracted/opt/OpenAudible $APPDIR
#"$APPDIR"/OpenAudible --info > info.json
#rm -rf openaudible_extracted

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

# Install flatpak builder
flatpak install -y --user flathub org.flatpak.Builder

## Initialize build directory
#flatpak build-init  "$BUILD_DIR" org.openaudible.OpenAudible org.freedesktop.Sdk org.freedesktop.Platform 24.08

# Build Flatpak
flatpak run org.flatpak.Builder --force-clean --disable-rofiles-fuse --repo=repo "$BUILD_DIR" org.openaudible.OpenAudible.yml

# Create Flatpak bundle
flatpak build-bundle  repo OpenAudible-$VERSION.flatpak org.openaudible.OpenAudible


ORIG="OpenAudible-$VERSION.flatpak"

if [ ! -f "$ORIG" ]; then
    echo "Error: ORIG file not found: $ORIG"
    echo "`ls`"
    exit 1
fi


OUT=$(echo "$DEB_FILE" | sed 's/\.deb$/.flatpak/')
mv $ORIG $OUT

cp -f $OUT /tmp/oa.flatpak

if [ ! -f "$OUT" ]; then
    echo "Error: OUT file not found: $OUT"
    exit 1
fi
echo "Flatpak bundle created: $OUT"

echo $OUT

