#!/bin/bash
set -e
set -x

if [ $# -ne 1 ]; then
    echo "Usage: $0 output name"
    exit 1
fi

FLATPAK_NAME=$1

## Check if the DEB file exists

GPG=
# Create build directory
BUILD_DIR="build"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"


cp ../openaudible.yml org.openaudible.OpenAudible.yml


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
flatpak build-bundle  repo $FLATPAK_NAME org.openaudible.OpenAudible



if [ ! -f "$FLATPAK_NAME" ]; then
    echo "Error: $FLATPAK_NAME file not found: $FLATPAK_NAME"
    echo "`ls`"
    exit 1
fi


