#!/bin/bash

# Fetch JSON data from the URL
JSON=$(wget -qO- https://openaudible.org/beta/swt_version.json)

# Extract version and release date
VERSION=$(echo $JSON | jq -r '.version')
RELEASE_DATE=$(echo $JSON | jq -r '.release_date')

# Get deb platform data
FILE=$(echo $JSON | jq -r '.platforms.deb.file')
SHA256=$(echo $JSON | jq -r '.platforms.deb.sha256')
DOWNLOAD_DIR=$(echo $JSON | jq -r '.download_dir')

# Concatenate download_dir and FILE to get full URL
DEB_URL="${DOWNLOAD_DIR}${FILE}"

# Replace DEB_URL and SHA256 in template.yml and save to output.yml
sed "s|DEB_URL|$DEB_URL|g; s|SHA256|$SHA256|g" template.yml > openaudible.yml

# Output the result file path
echo "Template has been updated and saved to openaudible.yml"
